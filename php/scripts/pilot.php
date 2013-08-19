<?php
############################################################################
#	pilot.php
#
#	Tim Traver
#	2/17/13
#	This is the script to handle the pilots
#
############################################################################
$GLOBALS['current_menu']='pilots';

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
	$function=$_REQUEST['function'];
}else{
	$function="pilot_list";
}

if(check_user_function($function)){
	eval("\$actionoutput=$function();");
}else{
	 $actionoutput= show_no_permission();
}

function pilot_list() {
	global $smarty;

	$country_id=0;
	$state_id=0;
	if(isset($_REQUEST['country_id'])){
		$country_id=intval($_REQUEST['country_id']);
		$GLOBALS['fsession']['country_id']=$country_id;
	}elseif(isset($GLOBALS['fsession']['country_id'])){
		$country_id=$GLOBALS['fsession']['country_id'];
	}
	if(isset($_REQUEST['state_id'])){
		$state_id=intval($_REQUEST['state_id']);
		$GLOBALS['fsession']['state_id']=$state_id;
	}elseif(isset($GLOBALS['fsession']['state_id'])){
		$state_id=$GLOBALS['fsession']['state_id'];
	}

	$search='';
	if(isset($_REQUEST['search']) ){
		$search=$_REQUEST['search'];
		$search_operator=$_REQUEST['search_operator'];
		$GLOBALS['fsession']['search']=$_REQUEST['search'];
		$GLOBALS['fsession']['search_operator']=$_REQUEST['search_operator'];
	}elseif(isset($GLOBALS['fsession']['search']) && $GLOBALS['fsession']['search']!=''){
		$search=$GLOBALS['fsession']['search'];
		$search_operator=$GLOBALS['fsession']['search_operator'];
	}
	if(isset($_REQUEST['search_field']) && $_REQUEST['search_field']!=''){
		$search_field_entry=$_REQUEST['search_field'];
	}elseif(isset($GLOBALS['fsession']['search_field'])){
		$search_field_entry=$GLOBALS['fsession']['search_field'];
	}
	switch($search_field_entry){
		case 'pilot_first_name':
			$search_field='pilot_first_name';
			break;
		case 'pilot_last_name':
			$search_field='pilot_last_name';
			break;
		case 'pilot_city':
			$search_field='pilot_city';
			break;
		default:
			$search_field='pilot_first_name';
			break;
	}
	if($search=='' || $search=='%%'){
		$search_field='pilot_first_name';
	}
	$GLOBALS['fsession']['search_field']=$search_field;
	
	switch($search_operator){
		case 'contains':
			$operator='LIKE';
			$search="%$search%";
			break;
		case 'exactly':
			$operator="=";
			break;
		default:
			$operator="LIKE";
	}

	$addcountry='';
	if($country_id!=0){
		$addcountry.=" AND p.country_id=$country_id ";
	}
	$addstate='';
	if($state_id!=0){
		$addstate.=" AND p.state_id=$state_id ";
	}
#print "addcountry=$addcountry<br>\n";
#print "addstate=$addstate<br>\n";
#print "search=$search<br>\n";
#print "search_field=$search_field<br>\n";
#print "search_operator=$search_operator<br>\n";
#print "operator=$operator<br>\n";

	$pilots=array();
	if($search!='%%' && $search!=''){
		$stmt=db_prep("
			SELECT *
			FROM pilot p
			LEFT JOIN state s ON p.state_id=s.state_id
			LEFT JOIN country c ON p.country_id=c.country_id
			WHERE p.$search_field $operator :search
				$addcountry
				$addstate
			ORDER BY p.pilot_first_name
		");
		$pilots=db_exec($stmt,array("search"=>$search));
	}else{
		# Get all pilots for search
		$stmt=db_prep("
			SELECT *
			FROM pilot p
			LEFT JOIN state s ON p.state_id=s.state_id
			LEFT JOIN country c ON p.country_id=c.country_id
			WHERE 1
				$addcountry
				$addstate
			ORDER BY p.pilot_first_name
		");
		$pilots=db_exec($stmt,array());
	}
#print_r($pilots);
	
	# Get only countries that we have pilots for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT country_id FROM pilot) p
		LEFT JOIN country c ON c.country_id=p.country_id
		WHERE c.country_id!=0
		ORDER BY c.country_order
	");
	$countries=db_exec($stmt,array());
	# Get only states that we have locations for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT state_id FROM pilot) p
		LEFT JOIN state s ON s.state_id=p.state_id
		WHERE s.state_id!=0
		ORDER BY s.state_order
	");
	$states=db_exec($stmt,array());
	
	$pilots=show_pages($pilots,25);
	
	$smarty->assign("pilots",$pilots);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("search_field",$GLOBALS['fsession']['search_field']);
	$smarty->assign("search_operator",$GLOBALS['fsession']['search_operator']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl=find_template("pilot_list.tpl");
	return $smarty->fetch($maintpl);
}
function pilot_view() {
	global $user;
	global $smarty;
	
	$pilot_id=intval($_REQUEST['pilot_id']);
	
	# Get the current users pilot info
	$stmt=db_prep("
		SELECT *
		FROM pilot p
		LEFT JOIN state s ON p.state_id=s.state_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE pilot_id=:pilot_id
	");
	$result=db_exec($stmt,array("pilot_id"=>$pilot_id));
	
	if(!isset($result[0])){
		user_message("A pilot with that id does not exist.",1);
		return pilot_list();
	}else{
		$pilot=$result[0];
		
		# Get the planes that this pilot has
		$pilot_planes=array();
		$stmt=db_prep("
			SELECT *
			FROM pilot_plane pp
			LEFT JOIN plane p ON p.plane_id=pp.plane_id
			LEFT JOIN plane_type pt ON pt.plane_type_id=p.plane_type_id
			WHERE pp.pilot_id=:pilot_id
				AND pp.pilot_plane_status=1
		");
		$pilot_planes=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
		foreach($pilot_planes as $key=>$plane){
			$disciplines=array();
			# Lets get the plane types
			$stmt=db_prep("
				SELECT *
				FROM plane_discipline pd
				LEFT JOIN discipline d ON pd.discipline_id=d.discipline_id
				WHERE pd.plane_id=:plane_id
				ORDER BY d.discipline_order
			");
			$disciplines=db_exec($stmt,array("plane_id"=>$plane['plane_id']));
			$pilot_planes[$key]['disciplines']=$disciplines;
		}
		
		# Get the pilots clubs
		$pilot_clubs=array();
		$stmt=db_prep("
			SELECT *
			FROM club_pilot cp
			LEFT JOIN club cl ON cp.club_id=cl.club_id
			LEFT JOIN state s on s.state_id=cl.state_id
			LEFT JOIN country c on cl.country_id=c.country_id
			WHERE cp.pilot_id=:pilot_id
				AND cp.club_pilot_status=1
		");
		$pilot_clubs=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));

		# Get the pilots favorite locations
		$pilot_locations=array();
		$stmt=db_prep("
			SELECT *
			FROM pilot_location pl
			LEFT JOIN location l ON l.location_id=pl.location_id
			LEFT JOIN state s on s.state_id=l.state_id
			LEFT JOIN country c on c.country_id=l.country_id
			WHERE pl.pilot_id=:pilot_id
				AND pl.pilot_location_status=1
		");
		$pilot_locations=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
		
		# Get the pilots events
		$pilot_events=array();
		$stmt=db_prep("
			SELECT *
			FROM event_pilot ep
			LEFT JOIN event e ON ep.event_id=e.event_id
			LEFT JOIN location l ON e.location_id=l.location_id
			LEFT JOIN state s on s.state_id=l.state_id
			LEFT JOIN country c on c.country_id=l.country_id
			WHERE ep.pilot_id=:pilot_id
				AND ep.event_pilot_status=1
				AND e.event_status=1
			ORDER BY event_start_date DESC
		");
		$pilot_events=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
	}

	# If they have events, lets show their Personal Bests
	$f3f_records=array();
	$f3b_records=array();
	$f3b_dist=array();
	if($pilot_events){
		# Lets get the top speeds in F3F across all of the events
		$stmt=db_prep("
			SELECT *
			FROM event_pilot_round_flight eprf
			LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id=epr.event_pilot_round_id
			LEFT JOIN event_pilot ep ON epr.event_pilot_id=ep.event_pilot_id
			LEFT JOIN pilot p on ep.pilot_id=p.pilot_id
			LEFT JOIN event e ON ep.event_id=e.event_id
			LEFT JOIN location l ON e.location_id=l.location_id
			LEFT JOIN country c ON l.country_id=c.country_id
			WHERE ep.pilot_id=:pilot_id
				AND eprf.event_pilot_round_flight_status=1
				AND ep.event_pilot_status=1
				AND e.event_status=1
				AND e.event_type_id=1
				AND eprf.event_pilot_round_flight_seconds!=0
			ORDER BY eprf.event_pilot_round_flight_seconds
			LIMIT 0,3
		");
		$f3f_records=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
		# Lets get the top speeds in F3B across all of the events
		$stmt=db_prep("
			SELECT *
			FROM event_pilot_round_flight eprf
			LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id=epr.event_pilot_round_id
			LEFT JOIN event_pilot ep ON epr.event_pilot_id=ep.event_pilot_id
			LEFT JOIN pilot p on ep.pilot_id=p.pilot_id
			LEFT JOIN event e ON ep.event_id=e.event_id
			LEFT JOIN location l ON e.location_id=l.location_id
			LEFT JOIN country c ON l.country_id=c.country_id
			WHERE ep.pilot_id=:pilot_id
				AND eprf.event_pilot_round_flight_status=1
				AND ep.event_pilot_status=1
				AND e.event_status=1
				AND eprf.flight_type_id=3
				AND (e.event_type_id=2 || e.event_type_id=3)
				AND eprf.event_pilot_round_flight_seconds!=0
			ORDER BY eprf.event_pilot_round_flight_seconds
			LIMIT 0,3
		");
		$f3b_records=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
		# Lets get the top distance runs in F3B across all of the events
		$stmt=db_prep("
			SELECT *,p.pilot_id as record_pilot_id,pc.country_code as pilot_country_code
			FROM event_pilot_round_flight eprf
			LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id=epr.event_pilot_round_id
			LEFT JOIN event_pilot ep ON epr.event_pilot_id=ep.event_pilot_id
			LEFT JOIN pilot p on ep.pilot_id=p.pilot_id
			LEFT JOIN country pc ON p.country_id=pc.country_id
			LEFT JOIN event e ON ep.event_id=e.event_id
			LEFT JOIN location l ON e.location_id=l.location_id
			LEFT JOIN country c ON l.country_id=c.country_id
			WHERE ep.pilot_id=:pilot_id
				AND eprf.event_pilot_round_flight_status=1
				AND ep.event_pilot_status=1
				AND e.event_status=1
				AND e.event_type_id=2
				AND eprf.flight_type_id=2
				AND eprf.event_pilot_round_flight_laps!=0
			ORDER BY eprf.event_pilot_round_flight_laps DESC
			LIMIT 0,3
		");
		$f3b_dist=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
	}

	$smarty->assign("pilot",$pilot);
	$smarty->assign("pilot_planes",$pilot_planes);
	$smarty->assign("pilot_locations",$pilot_locations);
	$smarty->assign("pilot_events",$pilot_events);
	$smarty->assign("pilot_clubs",$pilot_clubs);
	$smarty->assign("f3f_records",$f3f_records);
	$smarty->assign("f3b_records",$f3b_records);
	$smarty->assign("f3b_dist",$f3b_dist);
	
	$maintpl=find_template("pilot_view.tpl");
	return $smarty->fetch($maintpl);
}
function pilot_add_cd() {
	global $smarty;

	$pilot_name=$_REQUEST['pilot_name'];
	# Lets set the name that was sent
	$name=preg_split("/\s/",$pilot_name,2);
	$pilot['pilot_first_name']=ucwords(strtolower($name[0]));
	$pilot['pilot_last_name']=ucwords(strtolower($name[1]));

	if(isset($_REQUEST['from_action'])){
		# Lets make an array of all of the return values
		foreach($_REQUEST as $key=>$value){
			if(preg_match("/from_(\S+)/",$key,$match)){
				$from[]=array("key"=>$key,"value"=>$value);
			}
		}
		# Now lets add that array to the template
		$smarty->assign("from",$from);
	}

	$smarty->assign("states",get_states());
	$smarty->assign("countries",get_countries());
	$smarty->assign("pilot",$pilot);

	$maintpl=find_template("event_cd_add.tpl");
	return $smarty->fetch($maintpl);
}
function pilot_save_cd() {
	global $smarty;

	$pilot_first_name=$_REQUEST['pilot_first_name'];
	$pilot_last_name=$_REQUEST['pilot_last_name'];
	$pilot_city=$_REQUEST['pilot_city'];
	$state_id=intval($_REQUEST['state_id']);
	$country_id=intval($_REQUEST['country_id']);
	$pilot_ama=$_REQUEST['pilot_ama'];
	$pilot_fai=$_REQUEST['pilot_fai'];
	$pilot_email=$_REQUEST['pilot_email'];

	# Lets create the pilot
	$stmt=db_prep("
		INSERT INTO pilot
		SET user_id=0,
			pilot_first_name=:pilot_first_name,
			pilot_last_name=:pilot_last_name,
			pilot_email=:pilot_email,
			pilot_ama=:pilot_ama,
			pilot_fai=:pilot_fai,
			pilot_city=:pilot_city,
			state_id=:state_id,
			country_id=:country_id
	");
	$result=db_exec($stmt,array(
		"pilot_first_name"=>$pilot_first_name,
		"pilot_last_name"=>$pilot_last_name,
		"pilot_email"=>$pilot_email,
		"pilot_ama"=>$pilot_ama,
		"pilot_fai"=>$pilot_fai,
		"pilot_city"=>$pilot_city,
		"state_id"=>$state_id,
		"country_id"=>$country_id,
	));
	$pilot_id=$GLOBALS['last_insert_id'];
	user_message("Created new pilot $pilot_first_name $pilot_last_name for the CD role.");

	if(isset($_REQUEST['from_action'])){
		# This came from somewhere else, so go back to that screen
		# But lets add the new cd id to the list
		$from['event_cd']=$pilot_id;
		$from['event_cd_name']=$pilot_first_name." ".$pilot_last_name;
		$from['from_action']='event';
		return return_to_action($from);
	}else{
		return event_list();
	}
}

?>
