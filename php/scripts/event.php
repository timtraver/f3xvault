<?php
############################################################################
#       event.php
#
#       Tim Traver
#       8/11/12
#       This is the script to show the main screen
#
############################################################################

global $noside;
$noside=1;

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
	$function=$_REQUEST['function'];
}else{
	$function="event_list";
}

if(check_user_function($function)){
	eval("\$actionoutput=$function();");
}else{
	 $actionoutput= show_no_permission();
}

function event_list() {
	global $smarty;
	global $export;

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
		case 'event_name':
			$search_field='event_name';
			break;
		case 'location_city':
			$search_field='location_city';
			break;
		default:
			$search_field='event_name';
			break;
	}
	if($search=='' || $search=='%%'){
		$search_field='event_name';
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
		$addcountry.=" AND l.country_id=$country_id ";
	}
	$addstate='';
	if($state_id!=0){
		$addstate.=" AND l.state_id=$state_id ";
	}
#print "addcountry=$addcountry<br>\n";
#print "addstate=$addstate<br>\n";
#print "search=$search<br>\n";
#print "search_field=$search_field<br>\n";
#print "search_operator=$search_operator<br>\n";
#print "operator=$operator<br>\n";

	$events=array();
	if($search!='%%' && $search!=''){
		$stmt=db_prep("
			SELECT *
			FROM event e
			LEFT JOIN location l ON e.location_id=l.location_id
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			WHERE e.$search_field $operator :search
				$addcountry
				$addstate
			ORDER BY e.event_start_date DESC,l.country_id,l.state_id
		");
		$events=db_exec($stmt,array("search"=>$search));
	}else{
		# Get all events for search
		$stmt=db_prep("
			SELECT *
			FROM event e
			LEFT JOIN location l ON e.location_id=l.location_id
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			WHERE 1
				$addcountry
				$addstate
			ORDER BY e.event_start_date DESC,l.country_id,l.state_id
		");
		$events=db_exec($stmt,array());
	}
	
#print_r($events);
	
	# Get only countries that we have events for
	$stmt=db_prep("
		SELECT DISTINCT c.*
		FROM event e
		LEFT JOIN location l ON e.location_id=l.location_id
		LEFT JOIN country c ON c.country_id=l.country_id
		WHERE c.country_id!=0
	");
	$countries=db_exec($stmt,array());
	# Get only states that we have events for
	$stmt=db_prep("
		SELECT DISTINCT s.*
		FROM event e
		LEFT JOIN location l ON e.location_id=l.location_id
		LEFT JOIN state s ON s.state_id=l.state_id
		WHERE s.state_id!=0
	");
	$states=db_exec($stmt,array());
	
	$events=show_pages($events,25);
	
	$smarty->assign("events",$events);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("search_field",$GLOBALS['fsession']['search_field']);
	$smarty->assign("search_operator",$GLOBALS['fsession']['search_operator']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl=find_template("event_list.tpl");
	return $smarty->fetch($maintpl);
}
function event_edit() {
	global $smarty;

	if($GLOBALS['user_id']==0){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit location information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		return $smarty->fetch($maintpl);
	}
	
	$event_id=intval($_REQUEST['event_id']);
	$event=array();
	if($event_id!=0){
		# Get event info
		$event=array();
		$stmt=db_prep("
			SELECT *
			FROM event e
			LEFT JOIN location l ON e.location_id=l.location_id
			LEFT JOIN country c ON c.country_id=l.country_id
			WHERE e.event_id=:event_id
		");
		$result=db_exec($stmt,array("event_id"=>$event_id));
		$event=$result[0];
	}
	
	$country_id=0;
	$addcountry='';
	if(isset($_REQUEST['country_id'])){
		$country_id=$_REQUEST['country_id'];
		$addcountry="AND c.country_id=:country_id";
	}else{
		$country_id=$event['country_id'];
		$addcountry="AND c.country_id=:country_id";
	}
	
	$state_id=0;
	$addstate='';
	if(isset($_REQUEST['state_id']) && $_REQUEST['state_id']!=0){
		$state_id=$_REQUEST['state_id'];
		$addstate="AND s.state_id=:state_id";
	}else{
		$state_id=$event['state_id'];
		$addstate="AND s.state_id=:state_id";
	}
	$locations=array();
	if($country_id!=0){
		# Get locations in that country and state
		$stmt=db_prep("
			SELECT *
			FROM location l
			LEFT JOIN country c ON l.country_id=c.country_id
			LEFT JOIN state s ON l.state_id=s.state_id
			WHERE c.country_id=:country_id
			$addstate
			ORDER BY l.location_name
		");
		if($state_id != 0){
			$locations=db_exec($stmt,array("country_id"=>$country_id,"state_id"=>$state_id));
		}else{
			$locations=db_exec($stmt,array("country_id"=>$country_id));
		}
	}
	
	# Get only the countries that we have events for
	$countries=get_countries()
	;
	# Get only the states that we have events for
	$states=get_states();
	
	# Get event types
	$stmt=db_prep("
		SELECT *
		FROM event_type
	");
	$event_types=db_exec($stmt,array());
	
	$smarty->assign("locations",$locations);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);
	$smarty->assign("country_id",$country_id);
	$smarty->assign("state_id",$state_id);
	$smarty->assign("event_types",$event_types);
	$smarty->assign("event",$event);

	$maintpl=find_template("event_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_save() {
	global $smarty;
	global $user;

	if($GLOBALS['user_id']==0){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit location information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		return $smarty->fetch($maintpl);
	}
		
	$country_id=$_REQUEST['country_id'];
	$state_id=$_REQUEST['state_id'];
	$location_id=$_REQUEST['location_id'];
	$event_name=$_REQUEST['event_name'];
	$event_id=$_REQUEST['event_id'];
	# Get the dates
	$event_start_date=$_REQUEST['event_start_dateYear']."-".$_REQUEST['event_start_dateMonth']."-".$_REQUEST['event_start_dateDay'];
	$event_end_date=$_REQUEST['event_end_dateYear']."-".$_REQUEST['event_end_dateMonth']."-".$_REQUEST['event_end_dateDay'];
	$event_type_id=$_REQUEST['event_type_id'];

	if($event_id==0){
		$stmt=db_prep("
			INSERT INTO event
			SET user_id=:user_id,
				event_name=:event_name,
				location_id=:location_id,
				event_start_date=:event_start_date,
				event_end_date=:event_end_date,
				event_type_id=:event_type_id,
				event_status=1
		");
		$result=db_exec($stmt,array(
			"user_id"=>$GLOBALS['user_id'],
			"event_name"=>$event_name,
			"location_id"=>$location_id,
			"event_start_date"=>$event_start_date,
			"event_end_date"=>$event_end_date,
			"event_type_id"=>$event_type_id
		));

		user_message("Added your New Event!");
		$_REQUEST['event_id']=$GLOBALS['last_insert_id'];
	}else{
		# Save the database record for this event
		$stmt=db_prep("
			UPDATE event
			SET event_name=:event_name,
				location_id=:location_id,
				event_start_date=:event_start_date,
				event_end_date=:event_end_date,
				event_type_id=:event_type_id
			WHERE event_id=:event_id
		");
		$result=db_exec($stmt,array(
			"event_name"=>$event_name,
			"location_id"=>$location_id,
			"event_start_date"=>$event_start_date,
			"event_end_date"=>$event_end_date,
			"event_type_id"=>$event_type_id,
			"event_id"=>$event_id
		));
		user_message("Updated Base Event Info!");
	}
	return event_view();
}
function event_view() {
	global $smarty;

	if($GLOBALS['user_id']==0){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit location information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		return $smarty->fetch($maintpl);
	}
	
	$event_id=intval($_REQUEST['event_id']);
	if($event_id==0){
		user_message("That is not a proper event id to edit.");
		return event_list();
	}
	
	# Get event info
	$event=array();
	$stmt=db_prep("
		SELECT *
		FROM event e
		LEFT JOIN location l ON e.location_id=l.location_id
		LEFT JOIN state s ON l.state_id=s.state_id
		LEFT JOIN country c ON c.country_id=l.country_id
		LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
		WHERE e.event_id=:event_id
	");
	$result=db_exec($stmt,array("event_id"=>$event_id));
	$event=$result[0];
	$smarty->assign("event",$event);
	
	# Now lets get the pilots assigned to this event
	$stmt=db_prep("
		SELECT *
		FROM event_pilot ep
		LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
		WHERE ep.event_id=:event_id
			AND ep.event_pilot_status=1
	");
	$pilots=db_exec($stmt,array("event_id"=>$event_id));
	$smarty->assign("pilots",$pilots);
	$smarty->assign("total_pilots",count($pilots));

	$maintpl=find_template("event_view.tpl");
	return $smarty->fetch($maintpl);
}

?>
