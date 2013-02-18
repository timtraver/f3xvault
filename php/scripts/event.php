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

$need_login=array(
	"event_edit",
	"event_save",
	"add_pilot",
	"add_pilot_quick",
	"save_pilot_quick_add",
	"event_pilot_remove",
	"event_pilot_edit",
	"event_pilot_save"
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
	
	# Get event info
	$event=get_all_event_info($event_id);
	$smarty->assign("event",$event);

	$smarty->assign("total_pilots",count($event['pilots']));

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
function add_pilot() {
	global $smarty;

	# Get list of pilot classes so I can choose a default one
	$classes=array();
	$stmt=db_prep("
		SELECT *
		FROM class c
	");
	$result=db_exec($stmt,array());
	foreach($result as $r){
		$name=$r['class_name'];
		$classes[$name]=$r;
	}
	
	$event_id=intval($_REQUEST['event_id']);
	if($event_id==0){
		user_message("That is not a proper event id to add a pilot to.");
		return event_list();
	}
	$pilot_id=intval($_REQUEST['pilot_id']);
	
	# If pilot_id is zero, then send them to the quick add pilot screen
	if($pilot_id==0){
		return add_pilot_quick();
	}else{
		# Check to see if the pilot already exists in this event
		$stmt=db_prep("
			SELECT *
			FROM event_pilot ep
			WHERE ep.event_id=:event_id
				AND ep.pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("event_id"=>$event_id,"pilot_id"=>$pilot_id));
		if(isset($result[0])){
			# The record already exists, so lets see if it has its status to 1 or not
			if($result[0]['event_pilot_status']==1){
				# This record already exists!
				user_message("The Pilot you have chosen to add is already in this event.",1);
				return event_view();
			}else{
				# Lets turn this record back on
				$stmt=db_prep("
					UPDATE event_pilot
					SET event_pilot_status=1
					WHERE event_pilot_id=:event_pilot_id
				");
				$result2=db_exec($stmt,array("event_pilot_id"=>$result[0]['event_pilot_id']));
				$_REQUEST['event_pilot_id']=$result[0]['event_pilot_id'];
			}
		}else{
			$default_class_id=$classes['open']['class_id'];
			# This record doesn't exist, so lets add it
			$stmt=db_prep("
				INSERT INTO event_pilot
				SET event_id=:event_id,
					pilot_id=:pilot_id,
					event_pilot_position=0,
					class_id=:class_id,
					event_pilot_status=1
			");
			$result2=db_exec($stmt,array("event_id"=>$event_id,"pilot_id"=>$pilot_id,"class_id"=>$default_class_id));
			$_REQUEST['event_pilot_id']=$GLOBALS['last_insert_id'];
		}
		user_message("Pilot Added to event.");
		return event_pilot_edit();
	}
}
function add_pilot_quick() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
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
	
	#Lets split apart the first and last names
	$name=preg_split("/\s/",$pilot_name,2);
	$smarty->assign("pilot_first_name",$name[0]);
	$smarty->assign("pilot_last_name",$name[1]);

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

	$maintpl=find_template("pilot_quick_add.tpl");
	return $smarty->fetch($maintpl);
}
function save_pilot_quick_add() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
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

	# Lets add the pilot to the pilot table
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
	
	# Now lets add him to the current event
	$stmt=db_prep("
		INSERT INTO event_pilot
		SET event_id=:event_id,
			pilot_id=:pilot_id,
			class_id=:class_id,
			event_pilot_freq=:event_pilot_freq,
			event_pilot_team=:event_pilot_team,
			plane_id=:plane_id,
			event_pilot_status=1
	");
	$result2=db_exec($stmt,array("event_id"=>$event_id,"pilot_id"=>$pilot_id,"class_id"=>$class_id,"event_pilot_freq"=>$event_pilot_freq,"event_pilot_team"=>$event_pilot_team,"plane_id"=>$plane_id));
	user_message("New pilot created and added to event.");
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
function event_pilot_edit() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_pilot_id=$_REQUEST['event_pilot_id'];

	$pilot=array();
	$stmt=db_prep("
		SELECT *
		FROM event_pilot ep
		LEFT JOIN event e ON ep.event_id=e.event_id
		LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
		LEFT JOIN plane pl ON ep.plane_id=pl.plane_id
		WHERE ep.event_pilot_id=:event_pilot_id
	");
	$result=db_exec($stmt,array("event_pilot_id"=>$event_pilot_id));
	$pilot=$result[0];
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

	$teams=get_event_teams($event_id);
	$smarty->assign("teams",$teams);

	$maintpl=find_template("event_pilot_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_pilot_save() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_pilot_id=$_REQUEST['event_pilot_id'];
	$pilot_ama=$_REQUEST['pilot_ama'];
	$pilot_fia=$_REQUEST['pilot_fia'];
	$class_id=intval($_REQUEST['class_id']);
	$event_pilot_freq=$_REQUEST['event_pilot_freq'];
	$event_pilot_team=$_REQUEST['event_pilot_team'];
	$plane_id=intval($_REQUEST['plane_id']);
	
	# Save the entry
	$stmt=db_prep("
		UPDATE event_pilot
		SET class_id=:class_id,
			event_pilot_freq=:event_pilot_freq,
			event_pilot_team=:event_pilot_team,
			plane_id=:plane_id
		WHERE event_pilot_id=:event_pilot_id
	");
	$result=db_exec($stmt,array("class_id"=>$class_id,"event_pilot_freq"=>$event_pilot_freq,"event_pilot_team"=>$event_pilot_team,"event_pilot_id"=>$event_pilot_id,"plane_id"=>$plane_id));

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
	$rounds=db_exec($stmt,array("event_id"=>$event_id));
	# Step through and get each pilot flight
	foreach($rounds as $key=>$round){
		$stmt=db_prep("
			SELECT *
			FROM event_round_flight erf
			LEFT JOIN event_pilot ep ON erf.event_pilot_id=ep.event_pilot_id
			LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
			LEFT JOIN round_type rt ON erf.round_type_id=rt.round_type_id
			WHERE erf.event_round_id=:event_round_id
				AND erf.event_round_flight_status=1
		");
		$flights=db_exec($stmt,array("event_round_id"=>$round['event_round_id']));
		$rounds[$key]['flights']=$flights;
	}
	$event['rounds']=$rounds;

	return $event;	
}
?>
