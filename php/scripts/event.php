<?php
############################################################################
#       event.php
#
#       Tim Traver
#       8/11/12
#       This is the script to show the main screen
#
############################################################################

include_library("event.class");

global $noside;
$noside=1;

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
	$function=$_REQUEST['function'];
}else{
	$function="event_list";
}

$need_login=array(
	"event_edit",
	"event_save",
	"event_pilot_add",
	"add_pilot_quick",
	"save_pilot_quick_add",
	"event_pilot_remove",
	"event_pilot_edit",
	"event_pilot_save",
	"event_round_edit"
);
if(check_user_function($function)){
	if($GLOBALS['user_id']==0 && in_array($function, $need_login)){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit location information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		$actionoutput=$smarty->fetch($maintpl);
	}else{
		# Now check to see if they have permission to edit this event
		if(isset($_REQUEST['event_id']) && $_REQUEST['event_id']!=0){
			if(!in_array($function, $need_login) || (in_array($function, $need_login) && check_event_permission($_REQUEST['event_id']))){
				# They are allowed
				eval("\$actionoutput=$function();");
			}else{
				# They aren't allowed
				user_message("I'm sorry, but you do not have permission to edit this event. Please contact the event creator for access.",1);
				$actionoutput=event_view();
			}
		}else{
			eval("\$actionoutput=$function();");
		}
	}
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

	$events=array();
	if($search!='%%' && $search!=''){
		$stmt=db_prep("
			SELECT *
			FROM event e
			LEFT JOIN location l ON e.location_id=l.location_id
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
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
			LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
			WHERE 1
				$addcountry
				$addstate
			ORDER BY e.event_start_date DESC,l.country_id,l.state_id
		");
		$events=db_exec($stmt,array());
	}
		
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
function event_view() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	if($event_id==0){
		user_message("That is not a proper event id to edit.");
		return event_list();
	}
	
	$e=new Event($event_id);
	$e->get_rounds();
	$smarty->assign("event",$e);

	
	# Get event info
#	$event=get_all_event_info_new($event_id);
#	$smarty->assign("event",$event);
	
	$maintpl=find_template("event_view.tpl");
	return $smarty->fetch($maintpl);
}
function event_edit() {
	global $smarty;

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
			LEFT JOIN pilot p ON e.event_cd=p.pilot_id
			LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
			WHERE e.event_id=:event_id
		");
		$result=db_exec($stmt,array("event_id"=>$event_id));
		$event=$result[0];
	}else{
		$event['event_start_date']=time();
		$event['event_end_date']=time();
	}
	
	# Get event types
	$stmt=db_prep("
		SELECT *
		FROM event_type
	");
	$event_types=db_exec($stmt,array());

	# Now lets get the specific event options for this type
	# Get all of the base options
	$options=array();
	$stmt=db_prep("
		SELECT *
		FROM event_type_option eto
		WHERE eto.event_type_id=:event_type_id
		ORDER BY eto.event_type_option_order
	");
	$options=db_exec($stmt,array("event_type_id"=>$event['event_type_id']));

	$stmt=db_prep("
		SELECT *
		FROM event_option
		WHERE event_id=:event_id
			AND event_option_status=1
	");
	$values=db_exec($stmt,array("event_id"=>$event_id));

	# Step through each of the values and put those entries into the options array
	foreach ($options as $key=>$o){
		$id=$o['event_type_option_id'];
		foreach($values as $value){
			if($value['event_type_option_id']==$id){
				$options[$key]['event_option_value']=$value['event_option_value'];
				$options[$key]['event_option_status']=$value['event_option_status'];
			}
		}
	}

	# Now lets get the users that have additional access
	$stmt=db_prep("
		SELECT *
		FROM event_user eu
		LEFT JOIN pilot p ON eu.pilot_id=p.pilot_id
		LEFT JOIN state s ON p.state_id=s.state_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE eu.event_id=:event_id
			AND eu.event_user_status=1
	");
	$event_users=db_exec($stmt,array("event_id"=>$event_id));
	$smarty->assign("event_users",$event_users);
	
	$smarty->assign("locations",$locations);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);
	$smarty->assign("country_id",$country_id);
	$smarty->assign("state_id",$state_id);
	$smarty->assign("event_types",$event_types);
	$smarty->assign("event",$event);
	$smarty->assign("options",$options);

	$maintpl=find_template("event_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_save() {
	global $smarty;
	global $user;

	$country_id=intval($_REQUEST['country_id']);
	$state_id=intval($_REQUEST['state_id']);
	$location_id=intval($_REQUEST['location_id']);
	$event_name=$_REQUEST['event_name'];
	$event_id=intval($_REQUEST['event_id']);
	# Get the dates
	$event_start_date=$_REQUEST['event_start_dateYear']."-".$_REQUEST['event_start_dateMonth']."-".$_REQUEST['event_start_dateDay'];
	$event_end_date=$_REQUEST['event_end_dateYear']."-".$_REQUEST['event_end_dateMonth']."-".$_REQUEST['event_end_dateDay'];
	$event_type_id=intval($_REQUEST['event_type_id']);
	$event_cd=intval($_REQUEST['event_cd']);

	if($event_id==0){
		$stmt=db_prep("
			INSERT INTO event
			SET pilot_id=:pilot_id,
				event_name=:event_name,
				location_id=:location_id,
				event_start_date=:event_start_date,
				event_end_date=:event_end_date,
				event_type_id=:event_type_id,
				event_cd=:event_cd,
				event_status=1
		");
		$result=db_exec($stmt,array(
			"pilot_id"=>$user['pilot_id'],
			"event_name"=>$event_name,
			"location_id"=>$location_id,
			"event_start_date"=>$event_start_date,
			"event_end_date"=>$event_end_date,
			"event_type_id"=>$event_type_id,
			"event_cd"=>$event_cd
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
				event_type_id=:event_type_id,
				event_cd=:event_cd
			WHERE event_id=:event_id
		");
		$result=db_exec($stmt,array(
			"event_name"=>$event_name,
			"location_id"=>$location_id,
			"event_start_date"=>$event_start_date,
			"event_end_date"=>$event_end_date,
			"event_type_id"=>$event_type_id,
			"event_cd"=>$event_cd,
			"event_id"=>$event_id
		));
		user_message("Updated Base Event Info!");
	}
	return event_edit();
}
function event_pilot_edit() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_pilot_id=intval($_REQUEST['event_pilot_id']);
	$pilot_id=intval($_REQUEST['pilot_id']);
	$pilot_name=$_REQUEST['pilot_name'];

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

	# Check to see if the pilot already exists in this event
	$stmt=db_prep("
		SELECT *
		FROM event_pilot ep
		WHERE ep.event_id=:event_id
			AND ep.pilot_id=:pilot_id
			AND ep.event_pilot_status=1
	");
	$result=db_exec($stmt,array("event_id"=>$event_id,"pilot_id"=>$pilot_id));
	if(isset($result[0])){
		# The record already exists, so lets see if it has its status to 1 or not
		user_message("The Pilot you have chosen to add is already in this event.",1);
		return event_view();
	}

	$pilot=array();

	# If the event_pilot_id is zero and the pilot_id is zero, then we are making a new pilot
	if($event_pilot_id!=0){
		$stmt=db_prep("
			SELECT *
			FROM event_pilot ep
			LEFT JOIN event e ON ep.event_id=e.event_id
			LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
			LEFT JOIN state s ON p.state_id=s.state_id
			LEFT JOIN country c ON p.country_id=c.country_id
			LEFT JOIN plane pl ON ep.plane_id=pl.plane_id
			WHERE ep.event_pilot_id=:event_pilot_id
		");
		$result=db_exec($stmt,array("event_pilot_id"=>$event_pilot_id));
		$pilot=$result[0];
		if(isset($_REQUEST['from_action'])){
			# They are returning from a plane add, so lets set things the way they were
			$pilot['pilot_ama']=$_REQUEST['pilot_ama'];
			$pilot['pilot_fia']=$_REQUEST['pilot_fia'];
			$pilot['class_id']=$_REQUEST['class_id'];
			$pilot['event_pilot_freq']=$_REQUEST['event_pilot_freq'];
			$pilot['event_pilot_team']=$_REQUEST['event_pilot_team'];
			$pilot['plane_id']=$_REQUEST['plane_id'];
			$pilot['plane_name']=$_REQUEST['plane_name'];
		}
	}elseif($pilot_id!=0){
		# They have chosen a pilot from the drop down list, so lets get that info
		$stmt=db_prep("
			SELECT *
			FROM pilot p
			LEFT JOIN state s ON p.state_id=s.state_id
			LEFT JOIN country c ON p.country_id=c.country_id
			WHERE p.pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("pilot_id"=>$pilot_id));
		$pilot=$result[0];
		if(isset($_REQUEST['from_action'])){
			# They are returning from a plane add, so lets set things the way they were
			$pilot['pilot_ama']=$_REQUEST['pilot_ama'];
			$pilot['pilot_fia']=$_REQUEST['pilot_fia'];
			$pilot['class_id']=$_REQUEST['class_id'];
			$pilot['event_pilot_freq']=$_REQUEST['event_pilot_freq'];
			$pilot['event_pilot_team']=$_REQUEST['event_pilot_team'];
			$pilot['plane_id']=$_REQUEST['plane_id'];
			$pilot['plane_name']=$_REQUEST['plane_name'];
		}
	}else{
		# This will be a new pilot
		# lets see if they are returning
		if(isset($_REQUEST['from_action'])){
			# They are returning from a plane add, so lets set things the way they were
			$pilot['pilot_first_name']=$_REQUEST['pilot_first_name'];
			$pilot['pilot_last_name']=$_REQUEST['pilot_last_name'];
			$pilot['pilot_city']=$_REQUEST['pilot_city'];
			$pilot['state_id']=$_REQUEST['state_id'];
			$pilot['country_id']=$_REQUEST['country_id'];
			$pilot['pilot_email']=$_REQUEST['pilot_email'];
			$pilot['pilot_ama']=$_REQUEST['pilot_ama'];
			$pilot['pilot_fia']=$_REQUEST['pilot_fia'];
			$pilot['class_id']=$_REQUEST['class_id'];
			$pilot['event_pilot_freq']=$_REQUEST['event_pilot_freq'];
			$pilot['event_pilot_team']=$_REQUEST['event_pilot_team'];
			$pilot['event_pilot_id']=$_REQUEST['event_pilot_id'];
			$pilot['pilot_id']=$_REQUEST['pilot_id'];
			$pilot['plane_id']=$_REQUEST['plane_id'];
			$pilot['plane_name']=$_REQUEST['plane_name'];
		}else{
			# Lets set the name that was sent
			$name=preg_split("/\s/",$pilot_name,2);
			$pilot['pilot_first_name']=ucwords(strtolower($name[0]));
			$pilot['pilot_last_name']=ucwords(strtolower($name[1]));
		}
	}
	
	# Lets set a default for the Channel
	if(!isset($pilot['event_pilot_freq']) || $pilot['event_pilot_freq']==''){
		$pilot['event_pilot_freq']='2.4 GHz';
	}
	$smarty->assign("pilot",$pilot);
	
	# Lets get the classes
	$stmt=db_prep("
		SELECT *
		FROM class
		WHERE 1
		ORDER BY class_view_order
	");
	$classes=db_exec($stmt,array());
	$smarty->assign("classes",$classes);

	$smarty->assign("states",get_states());
	$smarty->assign("countries",get_countries());

	$teams=get_event_teams($event_id);
	$smarty->assign("teams",$teams);
	$smarty->assign("event_id",$event_id);

	$maintpl=find_template("event_pilot_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_pilot_save() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_pilot_id=intval($_REQUEST['event_pilot_id']);
	$pilot_id=intval($_REQUEST['pilot_id']);
	$pilot_first_name=$_REQUEST['pilot_first_name'];
	$pilot_last_name=$_REQUEST['pilot_last_name'];
	$pilot_city=$_REQUEST['pilot_city'];
	$state_id=intval($_REQUEST['state_id']);
	$country_id=intval($_REQUEST['country_id']);
	$pilot_ama=$_REQUEST['pilot_ama'];
	$pilot_fia=$_REQUEST['pilot_fia'];
	$pilot_email=$_REQUEST['pilot_email'];
	$class_id=intval($_REQUEST['class_id']);
	$event_pilot_freq=$_REQUEST['event_pilot_freq'];
	$event_pilot_team=$_REQUEST['event_pilot_team'];
	$plane_id=intval($_REQUEST['plane_id']);
	$from_confirm=intval($_REQUEST['from_confirm']);
	
	# If the pilot doesn't exist, then lets add the new pilot to the pilot table
	if($pilot_id==0){
		# This means that we need to add a new pilot
		
		if($from_confirm==0){
			# First, lets maybe see if a pilot with that name already exists in that city and country
			$pilots=array();
			$stmt=db_prep("
				SELECT *
				FROM pilot p
				LEFT JOIN state s ON p.state_id=s.state_id
				LEFT JOIN country c ON p.country_id=c.country_id
				WHERE p.pilot_first_name=LOWER(:pilot_first_name)
					AND p.pilot_last_name=LOWER(:pilot_last_name)
			");
			$pilots=db_exec($stmt,array(
				"pilot_first_name"=>strtolower($pilot_first_name),
				"pilot_last_name"=>strtolower($pilot_last_name)
			));
			if($pilots[0]){
				# This means there are records with this first and last name
				# So we want to give them a choice of selecting an existing one instead of creating a new one
				$smarty->assign("pilots",$pilots);
				$smarty->assign("event_id",$event_id);
				$smarty->assign("pilot_first_name",$pilot_first_name);
				$smarty->assign("pilot_last_name",$pilot_last_name);
				$smarty->assign("pilot_city",$pilot_city);
				$smarty->assign("state_id",$state_id);
				$smarty->assign("country_id",$country_id);
				$smarty->assign("pilot_ama",$pilot_ama);
				$smarty->assign("pilot_fia",$pilot_fia);
				$smarty->assign("pilot_email",$pilot_email);
				$smarty->assign("class_id",$class_id);
				$smarty->assign("event_pilot_freq",$event_pilot_freq);
				$smarty->assign("event_pilot_team",$event_pilot_team);
				$smarty->assign("plane_id",$plane_id);
				
				# Lets add the state name and country name for good presentation
				$states=get_states();
				$countries=get_countries();
				foreach($states as $s){
					if($s['state_id']==$state_id){
						$smarty->assign("state",$s);
					}
				}
				foreach($countries as $c){
					if($c['country_id']==$country_id){
						$smarty->assign("country",$c);
					}
				}
				
				$maintpl=find_template("event_pilot_show_possible.tpl");
				return $smarty->fetch($maintpl);
			}
		}
		
		$stmt=db_prep("
			INSERT INTO pilot
			SET pilot_wp_user_id=0,
				pilot_first_name=:pilot_first_name,
				pilot_last_name=:pilot_last_name,
				pilot_email=:pilot_email,
				pilot_ama=:pilot_ama,
				pilot_fia=:pilot_fia,
				pilot_city=:pilot_city,
				state_id=:state_id,
				country_id=:country_id
		");
		$result=db_exec($stmt,array(
			"pilot_first_name"=>$pilot_first_name,
			"pilot_last_name"=>$pilot_last_name,
			"pilot_email"=>$pilot_email,
			"pilot_ama"=>$pilot_ama,
			"pilot_fia"=>$pilot_fia,
			"pilot_city"=>$pilot_city,
			"state_id"=>$state_id,
			"country_id"=>$country_id,
		));
		$pilot_id=$GLOBALS['last_insert_id'];
		user_message("Created new pilot $pilot_first_name $pilot_last_name.");
	}

	
	if($event_pilot_id!=0){
		# Lets save this existing event pilot
		$stmt=db_prep("
			UPDATE event_pilot
			SET class_id=:class_id,
				event_pilot_freq=:event_pilot_freq,
				event_pilot_team=:event_pilot_team,
				plane_id=:plane_id
				WHERE event_pilot_id=:event_pilot_id
		");
		$result=db_exec($stmt,array(
			"class_id"=>$class_id,
			"event_pilot_freq"=>$event_pilot_freq,
			"event_pilot_team"=>$event_pilot_team,
			"event_pilot_id"=>$event_pilot_id,
			"plane_id"=>$plane_id
		));
	}else{
		# Lets see what the next increment in the order is
		$stmt=db_prep("
			SELECT MAX(event_pilot_entry_order) as max
			FROM event_pilot
			WHERE event_id=:event_id
			AND event_pilot_status=1
		");
		$result=db_exec($stmt,array("event_id"=>$event_id));
		if($result[0]['max']=='NULL' || $result[0]['max']==0){
			$event_pilot_entry_order=1;
		}else{
			$event_pilot_entry_order=$result[0]['max']+1;
		}

		# We need to create a new event pilot id
		# Lets first see if there already is one to just turn on
		$stmt=db_prep("
			SELECT *
			FROM event_pilot ep
			WHERE event_id=:event_id
				AND pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("event_id"=>$event_id,"pilot_id"=>$pilot_id));
		if(isset($result[0])){
			# This event_pilot already exists, so lets just update it
			$stmt=db_prep("
				UPDATE event_pilot
				SET class_id=:class_id,
					event_pilot_entry_order=:event_pilot_entry_order,
					event_pilot_freq=:event_pilot_freq,
					event_pilot_team=:event_pilot_team,
					plane_id=:plane_id,
					event_pilot_status=1
				WHERE event_pilot_id=:event_pilot_id
			");
			$result2=db_exec($stmt,array(
				"class_id"=>$class_id,
				"event_pilot_entry_order"=>$event_pilot_entry_order,
				"event_pilot_freq"=>$event_pilot_freq,
				"event_pilot_team"=>$event_pilot_team,
				"plane_id"=>$plane_id,
				"event_pilot_id"=>$result[0]['event_pilot_id']
			));
			$event_pilot_id=$result[0]['event_pilot_id'];
		}else{
			# We need to create a new event pilot		
			$stmt=db_prep("
				INSERT INTO event_pilot
				SET event_id=:event_id,
					pilot_id=:pilot_id,
					event_pilot_entry_order=:event_pilot_entry_order,
					class_id=:class_id,
					event_pilot_freq=:event_pilot_freq,
					event_pilot_team=:event_pilot_team,
					plane_id=:plane_id,
					event_pilot_status=1
			");
			$result2=db_exec($stmt,array(
				"event_id"=>$event_id,
				"pilot_id"=>$pilot_id,
				"class_id"=>$class_id,
				"event_pilot_entry_order"=>$event_pilot_entry_order,
				"event_pilot_freq"=>$event_pilot_freq,
				"event_pilot_team"=>$event_pilot_team,
				"plane_id"=>$plane_id
			));
			$event_pilot_id=$GLOBALS['last_insert_id'];
		}
		
		
		# Lets create a single round entry to make sure they show up if there are any rounds already
		$stmt=db_prep("
			SELECT *,erf.flight_type_id
			FROM event_round_flight erf
			LEFT JOIN event_round er ON erf.event_round_id=er.event_round_id
			WHERE er.event_id=:event_id
				AND er.event_round_status=1
		");
		$result=db_exec($stmt,array("event_id"=>$event_id));
		if(isset($result[0])){
			$round=$result[0];

			# There is at least one round, so lets create a flight on the first round
			$stmt=db_prep("
				INSERT INTO event_round_flight
				SET event_round_id=:event_round_id,
					flight_type_id=:flight_type_id,
					event_pilot_id=:event_pilot_id,
					event_round_flight_status=1
			");
			$result2=db_exec($stmt,array(
				"event_round_id"=>$round['event_round_id'],
				"flight_type_id"=>$round['flight_type_id'],
				"event_pilot_id"=>$event_pilot_id
			));
		}
	}
	# Lets see if we need to update the pilot's ama or fia number
	$stmt=db_prep("
		SELECT *
		FROM event_pilot ep
		LEFT JOIN event e ON ep.event_id=e.event_id
		LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
		WHERE ep.event_pilot_id=:event_pilot_id
	");
	$result=db_exec($stmt,array("event_pilot_id"=>$event_pilot_id));
	$pilot=$result[0];
	if($pilot_ama!=$pilot['pilot_ama'] || $pilot_fia!=$pilot['pilot_fia']){
		# lets update the pilot record
		$stmt=db_prep("
			UPDATE pilot
			SET pilot_ama=:pilot_ama,
				pilot_fia=:pilot_fia
				WHERE pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("pilot_ama"=>$pilot_ama,"pilot_fia"=>$pilot_fia,"pilot_id"=>$pilot['pilot_id']));
	}

	user_message("Updated event pilot info.");
	return event_view();
}
function event_pilot_remove() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_pilot_id=$_REQUEST['event_pilot_id'];

	$stmt=db_prep("
		UPDATE event_pilot
		SET event_pilot_status=0
		WHERE event_pilot_id=:event_pilot_id
	");
	$result=db_exec($stmt,array("event_pilot_id"=>$event_pilot_id));
	user_message("Pilot removed from event.");
	return event_view();
}
function get_event_teams($event_id){
	# Function to get the unique teams in an event
	$stmt=db_prep("
		SELECT DISTINCT(ep.event_pilot_team)
		FROM event_pilot ep
		LEFT JOIN event e ON ep.event_id=e.event_id
		LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
		WHERE ep.event_pilot_team !=''
			AND e.event_id=:event_id
			AND ep.event_pilot_status=1
	");
	$names=db_exec($stmt,array("event_id"=>$event_id));
	
	return $names;
}
function check_event_permission($event_id){
	global $user;
	# Function to check to see if this user can edit this event
	# First check if its an administrator
	if($user['administrator']){
		return 1;
	}
	
	# Get event info
	$stmt=db_prep("
		SELECT *
		FROM event
		WHERE event_id=:event_id
	");
	$result=db_exec($stmt,array("event_id"=>$event_id));
	$event=$result[0];

	if($event['pilot_id']==$user['pilot_id']){
		# This is the owner of the event, so of course he has access
		return 1;
	}
	$allowed=0;
	# Now lets get the other permissions
	$stmt=db_prep("
		SELECT *
		FROM event_user
		WHERE event_id=:event_id
			AND event_user_status=1
	");
	$users=db_exec($stmt,array("event_id"=>$event_id));
	foreach($users as $u){
		if($user['pilot_id']==$u['pilot_id']){
			$allowed=1;
		}
	}
	return $allowed;
}
function event_user_save() {
	global $smarty;
	global $user;
	
	$event_id=intval($_REQUEST['event_id']);
	$pilot_id=intval($_REQUEST['pilot_id']);

	if($pilot_id==0){
		user_message("Cannot add a blank user for access.",1);
		return event_edit();
	}
	# Get the current user pilot id to make sure they don't add themselves
	$stmt=db_prep("
		SELECT *
		FROM event e
		WHERE event_id=:event_id
	");
	$result=db_exec($stmt,array("event_id"=>$event_id));
	if(isset($result[0])){
		$event=$result[0];
	}
	if($event['pilot_id']==$pilot_id){
		user_message("You do not need to give access to yourself, as you will always have access as the owner of this event.");
		return event_edit();
	}
	
	# Now lets check to see if this is the event owner, because only they can add an event user
	if($event['pilot_id']!=$user['pilot_id']){
		user_message("You do not have access to give anyone else access. Only the event owner can do that.",1);
		return event_edit();
	}
	
	# Lets first see if this one is already added
	$stmt=db_prep("
		SELECT *
		FROM event_user
		WHERE event_id=:event_id
			AND pilot_id=:pilot_id
	");
	$result=db_exec($stmt,array("event_id"=>$event_id,"pilot_id"=>$pilot_id));
	
	if(isset($result[0])){
		# This record already exists, so lets just turn it on
		$stmt=db_prep("
			UPDATE event_user
			SET event_user_status=1
			WHERE event_user_id=:event_user_id
		");
		$result=db_exec($stmt,array("event_user_id"=>$result[0]['event_user_id']));
	}else{
		# Lets create a new record
		$stmt=db_prep("
			INSERT INTO event_user
			SET event_id=:event_id,
				pilot_id=:pilot_id,
				event_user_status=1
		");
		$result=db_exec($stmt,array(
			"event_id"=>$event_id,
			"pilot_id"=>$pilot_id
		));
	}
	user_message("New user given access to edit this event.");
	return event_edit();
}
function event_user_delete() {
	global $smarty;
	global $user;
	
	$event_id=intval($_REQUEST['event_id']);
	$event_user_id=intval($_REQUEST['event_user_id']);

	# Lets see if they are allowed to do this
	$stmt=db_prep("
		SELECT *
		FROM event e
		WHERE event_id=:event_id
	");
	$result=db_exec($stmt,array("event_id"=>$event_id));
	if(isset($result[0])){
		$event=$result[0];
	}
	
	# Now lets check to see if this is the event owner, because only they can delete a user
	if($event['pilot_id']!=$user['pilot_id']){
		user_message("You do not have access to remove access to this event. Only the event owner can do that.",1);
		return event_edit();
	}

	# Lets turn off this record
	$stmt=db_prep("
		UPDATE event_user
		SET event_user_status=0
		WHERE event_user_id=:event_user_id
	");
	$result=db_exec($stmt,array("event_user_id"=>$event_user_id));
	
	user_message("Removed user access to edit this event.");
	return event_edit();
}
function event_param_save() {
	global $smarty;
	global $user;
	
	$event_id=intval($_REQUEST['event_id']);
	
	# Lets clear out all of the option values that this event has
	$stmt=db_prep("
		UPDATE event_option
		SET event_option_status=0
		WHERE event_id=:event_id
	");
	$result=db_exec($stmt,array("event_id"=>$event_id));
	
	# Now lets step through the options and see if they are turned on and add them or update them
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^option_(\d+)/",$key,$match)){
				$id=$match[1];
				if($value=='On' || $value=='on'){
					$value=1;
				}
		}else{
			continue;
		}

		# ok, lets see if a record with that id exists
		$stmt=db_prep("
			SELECT *
			FROM event_option
			WHERE event_id=:event_id
				AND event_type_option_id=:event_type_option_id
		");
		$result=db_exec($stmt,array("event_type_option_id"=>$id,"event_id"=>$event_id));
		if($result){
			# There is already a record, so lets update it
			$event_option_id=$result[0]['event_option_id'];
			# Only update it if the value is not null
			if($value!=''){
				$stmt=db_prep("
					UPDATE event_option
					SET event_option_value=:value,
						event_option_status=1
					WHERE event_option_id=:event_option_id
				");
				$result2=db_exec($stmt,array("value"=>$value,"event_option_id"=>$event_option_id));
			}
		}else{
			# There is not a record so lets make one
			if($value!=''){
				$stmt=db_prep("
					INSERT INTO event_option
					SET event_id=:event_id,
						event_type_option_id=:event_type_option_id,
						event_option_value=:value,
						event_option_status=1
				");
				$result2=db_exec($stmt,array("event_id"=>$event_id,"event_type_option_id"=>$id,"value"=>$value));
			}
		}
	}	
	user_message("Event Parameters Saved.");
	return event_edit();
}
function get_all_event_info($event_id){
	# Function to return array of ALL current event info
	$event=array();
	$stmt=db_prep("
		SELECT *
		FROM event e
		LEFT JOIN location l ON e.location_id=l.location_id
		LEFT JOIN state s ON l.state_id=s.state_id
		LEFT JOIN country c ON c.country_id=l.country_id
		LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
		LEFT JOIN pilot p ON e.event_cd=p.pilot_id
		WHERE e.event_id=:event_id
	");
	$result=db_exec($stmt,array("event_id"=>$event_id));
	$event=$result[0];

	# Now lets get the pilots assigned to this event
	$stmt=db_prep("
		SELECT *
		FROM event_pilot ep
		LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
		LEFT JOIN class c ON ep.class_id=c.class_id
		LEFT JOIN plane pl ON ep.plane_id=pl.plane_id
		WHERE ep.event_id=:event_id
			AND ep.event_pilot_status=1
		ORDER BY ep.event_pilot_entry_order
	");
	$pilots=db_exec($stmt,array("event_id"=>$event_id));
	$event['pilots']=$pilots;
	
	# Now lets get the rounds for this event
	$stmt=db_prep("
		SELECT *
		FROM event_round er
		WHERE er.event_id=:event_id
			AND er.event_round_status=1
		ORDER BY er.event_round_number
	");
	$results=db_exec($stmt,array("event_id"=>$event_id));
	# Step through and get each pilot flight
	$rounds=array();
	foreach($results as $key=>$round){
		$event_round_number=$round['event_round_number'];
		$stmt=db_prep("
			SELECT *
			FROM event_round_flight erf
			LEFT JOIN event_pilot ep ON erf.event_pilot_id=ep.event_pilot_id
			LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
			LEFT JOIN flight_type ft ON erf.flight_type_id=ft.flight_type_id
			WHERE erf.event_round_id=:event_round_id
				AND erf.event_round_flight_status=1
			ORDER BY erf.event_round_flight_order
		");
		$flights=db_exec($stmt,array("event_round_id"=>$round['event_round_id']));
		
		$rounds[$event_round_number]=$round;
		$rounds[$event_round_number]['flights']=$flights;
	}
	$event['rounds']=$rounds;
	$event['totals']=calculate_event($event);

	return $event;	
}
function get_all_event_info_new($event_id){
	# Function to return array of ALL current event info
	$event=array();
	$stmt=db_prep("
		SELECT *
		FROM event e
		LEFT JOIN location l ON e.location_id=l.location_id
		LEFT JOIN state s ON l.state_id=s.state_id
		LEFT JOIN country c ON c.country_id=l.country_id
		LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
		LEFT JOIN pilot p ON e.event_cd=p.pilot_id
		WHERE e.event_id=:event_id
	");
	$result=db_exec($stmt,array("event_id"=>$event_id));
	$event=$result[0];

	# Now lets get the pilots assigned to this event
	$pilots=array();
	$stmt=db_prep("
		SELECT *
		FROM event_pilot ep
		LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
		LEFT JOIN class c ON ep.class_id=c.class_id
		LEFT JOIN plane pl ON ep.plane_id=pl.plane_id
		WHERE ep.event_id=:event_id
			AND ep.event_pilot_status=1
		ORDER BY ep.event_pilot_entry_order
	");
	$results=db_exec($stmt,array("event_id"=>$event_id));
	foreach($results as $pilot){
		$event_pilot_id=$pilot['event_pilot_id'];
		$pilots[$event_pilot_id]=$pilot;
	}
	$event['pilots']=$pilots;
	
	# Now lets get the rounds for this event
	$stmt=db_prep("
		SELECT *
		FROM event_round er
		WHERE er.event_id=:event_id
			AND er.event_round_status=1
		ORDER BY er.event_round_number
	");
	$results=db_exec($stmt,array("event_id"=>$event_id));
	
	# Step through each round and get pilot flights
	$rounds=array();
	foreach($results as $key=>$round){
		$event_round_number=$round['event_round_number'];
		$rounds[$event_round_number]=$round;
		foreach($pilots as $pilot){
			$event_pilot_id=$pilot['event_pilot_id'];
			# Get the pilot_round info
			$stmt=db_prep("
				SELECT *
				FROM event_pilot_round epr
				WHERE epr.event_pilot_id=:event_pilot_id
					AND epr.event_round_id=:event_round_id
			");
			$result2=db_exec($stmt,array("event_pilot_id"=>$pilot['event_pilot_id'],"event_round_id"=>$round['event_round_id']));
			if(isset($result2[0])){
				$rounds[$event_round_number]['pilots'][$event_pilot_id]=array_merge($result2[0],$pilot);
			}else{
				$rounds[$event_round_number]['pilots'][$event_pilot_id]=$pilot;
			}

			# Now get the flights for this pilot in this round
			$stmt=db_prep("
				SELECT *
				FROM event_pilot_round_flight erf
				LEFT JOIN flight_type ft ON erf.flight_type_id=ft.flight_type_id
				WHERE erf.event_pilot_round_id=:event_pilot_round_id
					AND erf.event_pilot_round_flight_status=1
				ORDER BY erf.event_pilot_round_flight_order
			");
			$flights=db_exec($stmt,array("event_pilot_round_id"=>$result2[0]['event_pilot_round_id']));
			$rounds[$event_round_number]['pilots'][$event_pilot_id]['flights']=$flights;
		}
	}
	$event['rounds']=$rounds;
	$event['totals']=calculate_event_new($event);

	return $event;	
}
function event_round_edit() {
	global $smarty;
	# Function to add or edit a round to an event
	
	$event_id=intval($_REQUEST['event_id']);
	$event_round_id=intval($_REQUEST['event_round_id']);
	$event=new Event($event_id);
	$event->get_rounds();

	$flight_types=$event->flight_types;	
	# Now lets look at the rounds to see which is the next round # to add if its a new one
	$round=array();
	if($event_round_id==0){
		$round_number=count($event->rounds)+1;
		# Lets fill out the round info with default stuff from what type of event this is
		# We actually need to fill in the default round data for an empty round
		$event->get_new_round($round_number);
	}else{
		# Step through and get the round number from the event_round_id
		foreach($event->rounds as $event_round_number=>$data){
			if($data['event_round_id']==$event_round_id){
				$round_number=$event_round_number;
			}
		}
	}
	
	$smarty->assign("event_round_id",$event_round_id);
	$smarty->assign("round_number",$round_number);

	$smarty->assign("flight_types",$flight_types);
	$smarty->assign("event",$event);
	$smarty->assign("total_pilots",count($event->pilots));
	
	$maintpl=find_template("event_round_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_round_save() {
	global $smarty;
	# Function to save the round
	
	$event_id=intval($_REQUEST['event_id']);
	$event_round_id=intval($_REQUEST['event_round_id']);
	$flight_type_id=intval($_REQUEST['flight_type_id']);
	$event_round_time_choice=$_REQUEST['event_round_time_choice'];
	$event_round_number=intval($_REQUEST['event_round_number']);
	
	# First, lets save the round info
	if($event_round_id==0){
		# New round, so lets create
		$stmt=db_prep("
			INSERT INTO event_round
			SET event_id=:event_id,
				event_round_number=:event_round_number,
				flight_type_id=:flight_type_id,
				event_round_time_choice=:event_round_time_choice,
				event_round_status=1
		");
		$result=db_exec($stmt,array(
			"event_id"=>$event_id,
			"event_round_number"=>$event_round_number,
			"flight_type_id"=>$flight_type_id,
			"event_round_time_choice"=>$event_round_time_choice
		));
		$event_round_id=$GLOBALS['last_insert_id'];
		$_REQUEST['event_round_id']=$event_round_id;
	}else{
		# Lets save it
		$stmt=db_prep("
			UPDATE event_round
			SET flight_type_id=:flight_type_id,
				event_round_time_choice=:event_round_time_choice
			WHERE event_round_id=:event_round_id
		");
		$result=db_exec($stmt,array(
			"flight_type_id"=>$flight_type_id,
			"event_round_time_choice"=>$event_round_time_choice,
			"event_round_id"=>$event_round_id
		));
	}

	# Now lets save the pilot flight info
	# Lets build the data grid
	$data=array();
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^pilot_(\S+)\_(\d+)\_(\d+)_(\d+)$/",$key,$match)){
			$field=$match[1];
			$event_pilot_round_flight_id=$match[2];
			$event_pilot_id=$match[3];
			$flight_type_id=$match[4];
			$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id][$field]=$value;
		}
	}
		
	# Now step through each one and save the flight record
	foreach($data as $event_pilot_round_flight_id=>$p){
		foreach($p as $event_pilot_id=>$f){
			foreach($f as $flight_type_id=>$v){
				# Lets see if this flight already exists
				$stmt=db_prep("
					SELECT *
					FROM event_pilot_round_flight erf
					WHERE erf.event_pilot_round_flight_id=:event_pilot_round_flight_id
				");
				$result=db_exec($stmt,array(
					"event_pilot_round_flight_id"=>$event_pilot_round_flight_id
				));
				if(isset($result[0])){
					# There is already a record, so save this one
					$stmt=db_prep("
						UPDATE event_pilot_round_flight
						SET event_pilot_round_flight_group=:event_pilot_round_flight_group,
							event_pilot_round_flight_minutes=:event_pilot_round_flight_minutes,
							event_pilot_round_flight_seconds=:event_pilot_round_flight_seconds,
							event_pilot_round_flight_laps=:event_pilot_round_flight_laps,
							event_pilot_round_flight_landing=:event_pilot_round_flight_landing,
							event_pilot_round_flight_penalty=:event_pilot_round_flight_penalty,
							event_pilot_round_flight_status=1
						WHERE event_pilot_round_flight_id=:event_pilot_round_flight_id
					");
					$result2=db_exec($stmt,array(
						"event_pilot_round_flight_id"=>$event_pilot_round_flight_id,
						"event_pilot_round_flight_group"=>$v['group'],
						"event_pilot_round_flight_minutes"=>$v['min'],
						"event_pilot_round_flight_seconds"=>$v['sec'],
						"event_pilot_round_flight_laps"=>$v['laps'],
						"event_pilot_round_flight_landing"=>$v['land'],
						"event_pilot_round_flight_penalty"=>$v['pen']
					));
				}else{
					# There isn't a record, so lets create a new one
					# We need to get the event_pilot_round_id
					$stmt=db_prep("
						SELECT *
						FROM event_pilot_round epr
						WHERE epr.event_round_id=:event_round_id
							AND epr.event_pilot_id=:event_pilot_id
					");
					$result2=db_exec($stmt,array("event_round_id"=>$event_round_id,"event_pilot_id"=>$event_pilot_id));
					if(!isset($result2[0])){
						# Event round doesn't exist, so lets create one
						$stmt=db_prep("
							INSERT INTO event_pilot_round
							SET event_pilot_id=:event_pilot_id,
								event_round_id=:event_round_id
						");
						$result3=db_exec($stmt,array("event_round_id"=>$event_round_id,"event_pilot_id"=>$event_pilot_id));
						$event_pilot_round_id=$GLOBALS['last_insert_id'];
					}else{
						$event_pilot_round_id=$result2[0]['event_pilot_round_id'];
					}
					$stmt=db_prep("
						INSERT INTO event_pilot_round_flight
						SET event_pilot_round_id=:event_pilot_round_id,
							flight_type_id=:flight_type_id,
							event_pilot_round_flight_group=:event_pilot_round_flight_group,
							event_pilot_round_flight_minutes=:event_pilot_round_flight_minutes,
							event_pilot_round_flight_seconds=:event_pilot_round_flight_seconds,
							event_pilot_round_flight_laps=:event_pilot_round_flight_laps,
							event_pilot_round_flight_landing=:event_pilot_round_flight_landing,
							event_pilot_round_flight_penalty=:event_pilot_round_flight_penalty,
							event_pilot_round_flight_status=1
					");
					$result2=db_exec($stmt,array(
						"event_pilot_round_id"=>$event_pilot_round_id,
						"flight_type_id"=>$flight_type_id,
						"event_pilot_round_flight_group"=>$v['group'],
						"event_pilot_round_flight_minutes"=>$v['min'],
						"event_pilot_round_flight_seconds"=>$v['sec'],
						"event_pilot_round_flight_laps"=>$v['laps'],
						"event_pilot_round_flight_landing"=>$v['land'],
						"event_pilot_round_flight_penalty"=>$v['pen']
					));
				}
			}
		}
	}
	# OK, now lets call the routine to do the calculation for a single round
	# First, since we saved the data, reset the $event object
	$event=new Event($event_id);
	$event->calculate_round($event_round_number);
	
	user_message("Saved event round info.");
	return event_round_edit();
}
function calculate_event($event){
	# Function to calculate the subtotals and totals per pilot for an event
	$subtotals=array();
	$totals=array();
	foreach($event['rounds'] as $round_number=>$r){
		foreach($r['flights'] as $f){
			$event_pilot_id=$f['event_pilot_id'];
			$sub=$f['event_round_flight_score'];
			$penalty=$f['event_round_flight_penalty'];
			$subtotals[$event_pilot_id]['rounds'][$round_number]+=$sub;
			$subtotals[$event_pilot_id]['subtotal']+=$sub;
			$subtotals[$event_pilot_id]['penalties']+=$penalty;
			$subtotals[$event_pilot_id]['total']+=$sub-$penalty;
			$subtotals[$event_pilot_id]['pilot_first_name']=$f['pilot_first_name'];
			$subtotals[$event_pilot_id]['pilot_last_name']=$f['pilot_last_name'];
		}
	}
	# Step through each of the subtotals and make sure there are rounds that may not be completed
	foreach($event['rounds'] as $round_number=>$r){
		foreach($event['pilots'] as $p){
			$event_pilot_id=$p['event_pilot_id'];
			if(!isset($subtotals[$event_pilot_id]['rounds'][$round_number])){
				$subtotals[$event_pilot_id]['rounds'][$round_number]=0;
			}
		}
	}

	# Now determine the rank
	foreach($subtotals as $event_pilot_id=>$t){
		# Create an array of all of the scores
		$scores[$event_pilot_id]=$t['total'];
	}
	arsort($scores);
	$count=1;
	foreach($scores as $event_pilot_id=>$f){
		$subtotals[$event_pilot_id]['overall_rank']=$count;
		$subtotals[$event_pilot_id]['event_pilot_id']=$event_pilot_id;
		$totals[]=$subtotals[$event_pilot_id];
		$count++;
	}
	return $totals;
}
function calculate_event_new($event){
	# Function to calculate the subtotals and totals per pilot for an event
	$subtotals=array();
	$totals=array();
	foreach($event['rounds'] as $round_number=>$r){
		foreach($r['pilots'] as $event_pilot_id=>$p){
			$subtotals[$event_pilot_id]['pilot_first_name']=$p['pilot_first_name'];
			$subtotals[$event_pilot_id]['pilot_last_name']=$p['pilot_last_name'];
			foreach($p['flights'] as $f){
				$sub=$f['event_pilot_round_flight_score'];
				$penalty=$f['event_pilot_round_flight_penalty'];
				$subtotals[$event_pilot_id]['rounds'][$round_number]+=$sub;
				$subtotals[$event_pilot_id]['subtotal']+=$sub;
				$subtotals[$event_pilot_id]['penalties']+=$penalty;
				$subtotals[$event_pilot_id]['total']+=$sub-$penalty;
			}
		}
	}
	# Step through each of the subtotals and make sure there are rounds that may not be completed
	foreach($event['rounds'] as $round_number=>$r){
		foreach($event['pilots'] as $p){
			$event_pilot_id=$p['event_pilot_id'];
			if(!isset($subtotals[$event_pilot_id]['rounds'][$round_number])){
				$subtotals[$event_pilot_id]['rounds'][$round_number]=0;
			}
		}
	}

	# Now determine the rank
	foreach($subtotals as $event_pilot_id=>$t){
		# Create an array of all of the scores
		$scores[$event_pilot_id]=$t['total'];
	}
	arsort($scores);
	$count=1;
	foreach($scores as $event_pilot_id=>$f){
		$subtotals[$event_pilot_id]['overall_rank']=$count;
		$subtotals[$event_pilot_id]['event_pilot_id']=$event_pilot_id;
		$totals[]=$subtotals[$event_pilot_id];
		$count++;
	}

	return $totals;
}
function event_save_totals($event){
	# Function to save the total values for each of the rounds
	foreach($event['rounds'] as $r){
		foreach($r['pilots'] as $event_pilot_id=>$p){
			$raw=0;
			
		foreach($t['rounds'] as $event_round_number=>$r){
			$event_pilot_round_id=$event['rounds'][$event_round_number]['pilots'][$event_pilot_id]['event_pilot_round_id'];
			
			
			# Save the subtotals for the round
			$stmt=db_prep("
				UPDATE event_pilot_round
				SET event_pilot_round_raw_score=:raw,
					event_pilot_round_rank=:rank,
					event_pilot_round_drop_score=:drop,
					event_pilot_round_total_score=:total
				WHERE event_pilot_round_id=:event_pilot_round_id
			");	
			$result=db_exec($stmt,array(
				"raw"=>$r
			));
		}
		}
	}

}
?>
