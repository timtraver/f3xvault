<?php
############################################################################
#       event.php
#
#       Tim Traver
#       8/11/12
#       This is the script to show the main screen
#
############################################################################
$GLOBALS['current_menu']='events';

include_library("event.class");

global $noside;
$noside=1;

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
	$function=$_REQUEST['function'];
}else{
	$function="event_list";
}

$need_login=array(
	"event_save",
	"event_pilot_add",
	"event_pilot_edit",
	"event_pilot_save",
	"event_pilot_remove",
	"event_user_save",
	"event_user_delete",
	"event_param_save",
	"add_pilot_quick",
	"save_pilot_quick_add",
	"event_pilot_remove",
	"event_pilot_save",
	"event_round_save",
	"event_round_delete",
	"event_round_flight_delete",
	"save_individual_flight"
);
if(check_user_function($function)){
	if($GLOBALS['user_id']==0 && in_array($function, $need_login)){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit information.",1);
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
	$discipline_id=0;
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
	if(isset($_REQUEST['discipline_id'])){
		$discipline_id=intval($_REQUEST['discipline_id']);
		$GLOBALS['fsession']['discipline_id']=$discipline_id;
	}elseif(isset($GLOBALS['fsession']['discipline_id'])){
		$discipline_id=$GLOBALS['fsession']['discipline_id'];
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
	$search_prefix='e.';
	switch($search_field_entry){
		case 'event_name':
			$search_field='event_name';
			break;
		case 'event_type_name':
			$search_field='event_type_name';
			$search_prefix='et.';
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

	# Add search options for discipline
	$disciplines=get_disciplines();
	$extrad='';
	if($discipline_id!=0){
		# Lets determine the discipline code that was chosen
		foreach($disciplines as $d){
			if($d['discipline_id']==$discipline_id){
				$discipline_code=$d['discipline_code'].'%';
			}
		}
		
		$extrad='AND et.event_type_code LIKE '."'$discipline_code'";
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
			WHERE e.event_status=1
				AND $search_prefix$search_field $operator :search
				$addcountry
				$addstate
				$extrad
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
			WHERE e.event_status=1
				$addcountry
				$addstate
				$extrad
			ORDER BY e.event_start_date DESC,l.country_id,l.state_id
		");
		$events=db_exec($stmt,array());
	}
	
	# Lets figure out if they are able to see this event based on the viewing prefs for the event
	$owns=array();
	$ispilot=array();
	if($GLOBALS['user_id']!=0 && $GLOBALS['user']['user_admin']!=1){
		# Lets get the events that this person owns and is a part of
		$stmt=db_prep("
			SELECT e.event_id
			FROM event e
			LEFT JOIN pilot p ON e.pilot_id=p.pilot_id
			WHERE p.user_id=:user_id
		");
		$result=db_exec($stmt,array("user_id"=>$GLOBALS['user_id']));
		foreach($result as $r){
			$owns[]=$r['event_id'];
		}
		$stmt=db_prep("
			SELECT ep.event_id
			FROM event_pilot ep
			LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
			WHERE p.user_id=:user_id
		");
		$result=db_exec($stmt,array("user_id"=>$GLOBALS['user_id']));
		foreach($result as $r){
			$ispilot[]=$r['event_id'];
		}
	}
	if($GLOBALS['user']['user_admin']!=1){
		$newevents=array();
		foreach($events as $key=>$e){
			switch($e['event_view_status']){
				case 1 :
					# Viewable by all
					$newevents[]=$e;
					break;
				case 2 : 
					# Viewable only by participants
					if(in_array($e['event_id'], $ispilot) || in_array($e['event_id'], $owns)){
						$newevents[]=$e;
					}
					break;
				case 3 : 
					# Viewable only by owner
					if(in_array($e['event_id'], $owns)){
						$newevents[]=$e;
					}
					break;
			}
		}
		$events=$newevents;
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

	# Lets reset the discipline for the top bar if needed
	set_disipline($discipline_id);
	
	$smarty->assign("events",$events);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);
	$smarty->assign("disciplines",$disciplines);

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

	# Lets determine if we need a laps report and an average speed report
	$laps=0;
	$speed=0;
	$landing=0;
	$duration=0;
	foreach($e->pilots as $p){
		if($p['event_pilot_total_laps']!=0){
			$laps=1;
		}
		if($p['event_pilot_average_speed']!=0){
			$speed=1;
		}
	}
	foreach($e->flight_types as $ft){
		if($ft['flight_type_landing']==1){
			$landing=1;
		}
		if($ft['flight_type_code']=='f3b_duration'){
			$duration=1;
		}
		if($ft['flight_type_code']=='f3f_speed' || $ft['flight_type_code']=='f3b_speed'){
			$speed=1;
		}
	}
	$lap_totals=array();
	$speed_averages=array();
	$speed_times=array();
	if($laps){
		# Lets sort the pilots by order of distance laps
		$lap_totals=array_msort($e->pilots,array("event_pilot_lap_rank"=>SORT_ASC));
		$smarty->assign("lap_totals",$lap_totals);
		# Lets get the top distance list
		$distance_laps=$e->get_top_distance();
		$smarty->assign("distance_laps",$distance_laps);
		# Lets get the distance ranking
		$distance_rank=$e->get_distance_rank();
		$smarty->assign("distance_rank",$distance_rank);
	}
	if($speed){
		# Lets get the speed ranking
		$speed_rank=$e->get_speed_rank();
		$smarty->assign("speed_rank",$speed_rank);
		# Lets sort the pilots by order of speed average
		$speed_averages=array_msort($e->pilots,array("event_pilot_average_speed_rank"=>SORT_ASC));
		$smarty->assign("speed_averages",$speed_averages);
		# Lets get the top speed list
		$speed_times=$e->get_top_speeds();
		$smarty->assign("speed_times",$speed_times);
	}
	if($landing){
		# Lets get the top landing accuracy list
		$top_landing=$e->get_top_landing();
		$smarty->assign("top_landing",$top_landing);
	}
	if($duration){
		# Lets get the duration rank
		$duration_rank=$e->get_duration_rank();
		$smarty->assign("duration_rank",$duration_rank);
	}
	
	$smarty->assign("event",$e);
	$permission=check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	
	# Save the current event id in the fsession for mobile ease of use
	$GLOBALS['fsession']['current_event_id']=$event_id;
	
	$maintpl=find_template("event_view.tpl");
	return $smarty->fetch($maintpl);
}
function event_edit() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$e=new Event($event_id);
	if($event_id==0){
		if(isset($_REQUEST['location_name'])){
			$e->info['location_name']=$_REQUEST['location_name'];
		}
		if(isset($_REQUEST['location_id'])){
			$e->info['location_id']=$_REQUEST['location_id'];
		}
		if(isset($_REQUEST['event_name'])){
			$e->info['event_name']=$_REQUEST['event_name'];
		}
		if(isset($_REQUEST['event_type_id'])){
			$e->info['event_type_id']=$_REQUEST['event_type_id'];
		}
		if(isset($_REQUEST['event_cd'])){
			$e->info['event_cd']=$_REQUEST['event_cd'];
		}
		if(isset($_REQUEST['event_cd_name'])){
			$e->info['event_cd_name']=$_REQUEST['event_cd_name'];
		}
		if(isset($_REQUEST['series_id'])){
			$e->info['series_id']=$_REQUEST['series_id'];
		}
		if(isset($_REQUEST['series_name'])){
			$e->info['series_name']=$_REQUEST['series_name'];
		}
		if(isset($_REQUEST['club_id'])){
			$e->info['club_id']=$_REQUEST['club_id'];
		}
		if(isset($_REQUEST['club_name'])){
			$e->info['club_name']=$_REQUEST['club_name'];
		}
		if(isset($_REQUEST['event_start_dateMonth'])){
			$starttime=strtotime($_REQUEST['event_start_dateMonth'].'/'.$_REQUEST['event_start_dateDay'].'/'.$_REQUEST['event_start_dateYear']);
		}else{
			$starttime=time();
		}
		if(isset($_REQUEST['event_end_dateMonth'])){
			$endtime=strtotime($_REQUEST['event_end_dateMonth'].'/'.$_REQUEST['event_end_dateDay'].'/'.$_REQUEST['event_end_dateYear']);
		}else{
			$endtime=time();
		}
		$e->info['event_start_date']=$starttime;
		$e->info['event_end_date']=$endtime;
	}else{
		# Lets only replace the id's of the things that could have been added new
		if(isset($_REQUEST['location_name'])){
			$e->info['location_name']=$_REQUEST['location_name'];
		}
		if(isset($_REQUEST['location_id'])){
			$e->info['location_id']=$_REQUEST['location_id'];
		}
		if(isset($_REQUEST['series_id'])){
			$e->info['series_id']=$_REQUEST['series_id'];
		}
		if(isset($_REQUEST['series_name'])){
			$e->info['series_name']=$_REQUEST['series_name'];
		}
		if(isset($_REQUEST['club_id'])){
			$e->info['club_id']=$_REQUEST['club_id'];
		}
		if(isset($_REQUEST['club_name'])){
			$e->info['club_name']=$_REQUEST['club_name'];
		}
		if(isset($_REQUEST['event_cd'])){
			$e->info['event_cd']=$_REQUEST['event_cd'];
		}
		if(isset($_REQUEST['event_cd_name'])){
			$e->info['event_cd_name']=$_REQUEST['event_cd_name'];
		}
	}

	# Get all event types
	$stmt=db_prep("
		SELECT *
		FROM event_type
	");
	$event_types=db_exec($stmt,array());

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
	
	$smarty->assign("event_types",$event_types);
	$smarty->assign("event",$e);

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
	$series_id=intval($_REQUEST['series_id']);
	$club_id=intval($_REQUEST['club_id']);
	$event_view_status=intval($_REQUEST['event_view_status']);

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
				series_id=:series_id,
				club_id=:club_id,
				event_view_status=:event_view_status,
				event_status=1
		");
		$result=db_exec($stmt,array(
			"pilot_id"=>$user['pilot_id'],
			"event_name"=>$event_name,
			"location_id"=>$location_id,
			"event_start_date"=>$event_start_date,
			"event_end_date"=>$event_end_date,
			"event_type_id"=>$event_type_id,
			"event_cd"=>$event_cd,
			"series_id"=>$series_id,
			"club_id"=>$club_id,
			"event_view_status"=>$event_view_status
		));

		user_message("Added your New Event!");
		$_REQUEST['event_id']=$GLOBALS['last_insert_id'];
		$event_id=$GLOBALS['last_insert_id'];
		# Now lets add the default event settings
		# Lets get each event type option and insert default values
		$stmt=db_prep("
			SELECT *
			FROM event_type_option
			WHERE event_type_id=:event_type_id
		");
		$options=db_exec($stmt,array("event_type_id"=>$event_type_id));
		foreach($options as $o){
			# Insert default value
			$stmt=db_prep("
				INSERT INTO event_option
				SET event_id=:event_id,
					event_type_option_id=:event_type_option_id,
					event_option_value=:event_option_value,
					event_option_status=1
			");
			$result2=db_exec($stmt,array(
				"event_id"=>$_REQUEST['event_id'],
				"event_type_option_id"=>$o['event_type_option_id'],
				"event_option_value"=>$o['event_type_option_default']
			));
		}
	}else{
		# Save the database record for this event
		$stmt=db_prep("
			UPDATE event
			SET event_name=:event_name,
				location_id=:location_id,
				event_start_date=:event_start_date,
				event_end_date=:event_end_date,
				event_type_id=:event_type_id,
				event_cd=:event_cd,
				series_id=:series_id,
				club_id=:club_id,
				event_view_status=:event_view_status
			WHERE event_id=:event_id
		");
		$result=db_exec($stmt,array(
			"event_name"=>$event_name,
			"location_id"=>$location_id,
			"event_start_date"=>$event_start_date,
			"event_end_date"=>$event_end_date,
			"event_type_id"=>$event_type_id,
			"event_cd"=>$event_cd,
			"series_id"=>$series_id,
			"club_id"=>$club_id,
			"event_view_status"=>$event_view_status,
			"event_id"=>$event_id
		));
		user_message("Updated Base Event Info!");
		# Lets save the totals in case some drops were changed or something
		$e=new Event($event_id);
		$e->event_save_totals();
	}
	log_action($event_id);
	return event_edit();
}
function event_delete() {
	global $smarty;
	global $user;

	$event_id=intval($_REQUEST['event_id']);
	# Lets check to make sure that its the owner that is deleting it
	$e=new Event($event_id);
	if($user['user_id']!=$e->info['user_id'] && $user['user_admin']!=1){
		# This is not the owner, so don't delete it...
		user_message("I'm sorry, but only the owner of the event can delete it.",1);
		return event_list();
	}
	# Save the database record for this event to delete it
	$stmt=db_prep("
		UPDATE event
		SET event_status=0
		WHERE event_id=:event_id
	");
	$result=db_exec($stmt,array(
		"event_id"=>$event_id
	));
	user_message("Removed Event!");

	log_action($event_id);
	return event_list();
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
			$pilot['pilot_fai']=$_REQUEST['pilot_fai'];
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
			$pilot['pilot_fai']=$_REQUEST['pilot_fai'];
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
			$pilot['pilot_fai']=$_REQUEST['pilot_fai'];
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
	# If its a new pilot, lets set the entry order
	if($event_pilot_id==0){
		# Lets see what the next increment in the order is
		$stmt=db_prep("
			SELECT MAX(event_pilot_entry_order) as max
			FROM event_pilot
			WHERE event_id=:event_id
			AND event_pilot_status=1
		");
		$result=db_exec($stmt,array("event_id"=>$event_id));
		if($result[0]['max']=='NULL' || $result[0]['max']==0){
			$pilot['event_pilot_entry_order']=1;
		}else{
			$pilot['event_pilot_entry_order']=$result[0]['max']+1;
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
	$pilot_fai=$_REQUEST['pilot_fai'];
	$pilot_email=$_REQUEST['pilot_email'];
	$class_id=intval($_REQUEST['class_id']);
	$event_pilot_freq=$_REQUEST['event_pilot_freq'];
	$event_pilot_team=$_REQUEST['event_pilot_team'];
	$plane_id=intval($_REQUEST['plane_id']);
	$from_confirm=intval($_REQUEST['from_confirm']);
	$event_pilot_entry_order=intval($_REQUEST['event_pilot_entry_order']);
	
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
				$smarty->assign("pilot_fai",$pilot_fai);
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
		user_message("Created new pilot $pilot_first_name $pilot_last_name.");
	}

	
	if($event_pilot_id!=0){
		# Lets save this existing event pilot
		$stmt=db_prep("
			UPDATE event_pilot
			SET class_id=:class_id,
				event_pilot_entry_order=:event_pilot_entry_order,
				event_pilot_freq=:event_pilot_freq,
				event_pilot_team=:event_pilot_team,
				plane_id=:plane_id
				WHERE event_pilot_id=:event_pilot_id
		");
		$result=db_exec($stmt,array(
			"class_id"=>$class_id,
			"event_pilot_entry_order"=>$event_pilot_entry_order,
			"event_pilot_freq"=>$event_pilot_freq,
			"event_pilot_team"=>$event_pilot_team,
			"event_pilot_id"=>$event_pilot_id,
			"plane_id"=>$plane_id
		));
	}else{
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
#		$stmt=db_prep("
#			SELECT *,erf.flight_type_id
#			FROM event_round_flight erf
#			LEFT JOIN event_round er ON erf.event_round_id=er.event_round_id
#			WHERE er.event_id=:event_id
#				AND er.event_round_status=1
#		");
#		$result=db_exec($stmt,array("event_id"=>$event_id));
#		if(isset($result[0])){
#			$round=$result[0];
#
#			# There is at least one round, so lets create a flight on the first round
#			$stmt=db_prep("
#				INSERT INTO event_round_flight
#				SET event_round_id=:event_round_id,
#					flight_type_id=:flight_type_id,
#					event_pilot_id=:event_pilot_id,
#					event_round_flight_status=1
#			");
#			$result2=db_exec($stmt,array(
#				"event_round_id"=>$round['event_round_id'],
#				"flight_type_id"=>$round['flight_type_id'],
#				"event_pilot_id"=>$event_pilot_id
#			));
#		}
	}
	# Lets see if we need to update the pilot's ama or fai number
	$stmt=db_prep("
		SELECT *
		FROM event_pilot ep
		LEFT JOIN event e ON ep.event_id=e.event_id
		LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
		WHERE ep.event_pilot_id=:event_pilot_id
	");
	$result=db_exec($stmt,array("event_pilot_id"=>$event_pilot_id));
	$pilot=$result[0];
	if($pilot_ama!=$pilot['pilot_ama'] || $pilot_fai!=$pilot['pilot_fai']){
		# lets update the pilot record
		$stmt=db_prep("
			UPDATE pilot
			SET pilot_ama=:pilot_ama,
				pilot_fai=:pilot_fai
				WHERE pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("pilot_ama"=>$pilot_ama,"pilot_fai"=>$pilot_fai,"pilot_id"=>$pilot['pilot_id']));
	}
	
	# Lets see if this pilot has a plane in his my planes area already
	if($plane_id!=0){
		$stmt=db_prep("
			SELECT *
			FROM pilot_plane
			WHERE pilot_id=:pilot_id
			AND plane_id=:plane_id
		");
		$result=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id'],"plane_id"=>$plane_id));
		if(!isset($result[0])){
			# Doesn't have one of these planes in their quiver, so lets put one in
			$stmt=db_prep("
				INSERT INTO pilot_plane
				SET pilot_id=:pilot_id,
					plane_id=:plane_id,
					pilot_plane_color='',
					pilot_plane_status=1
			");
			$result2=db_exec($stmt,array(
				"pilot_id"=>$pilot['pilot_id'],
				"plane_id"=>$plane_id
			));
		}
	}
	# Lets see if this pilot has a location in his my locations area already
	# Get the event info
	$e=new Event($event_id);
	
	if($e->info['location_id']!=0){
		$stmt=db_prep("
			SELECT *
			FROM pilot_location
			WHERE pilot_id=:pilot_id
			AND location_id=:location_id
		");
		$result=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id'],"location_id"=>$e->info['location_id']));
		if(!isset($result[0])){
			# Doesn't have one of these locations, so lets put one in
			$stmt=db_prep("
				INSERT INTO pilot_location
				SET pilot_id=:pilot_id,
					location_id=:location_id,
					pilot_location_status=1
			");
			$result2=db_exec($stmt,array(
				"pilot_id"=>$pilot['pilot_id'],
				"location_id"=>$e->info['location_id']
			));
		}
	}
	
	log_action($event_pilot_id);
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
	# Lets turn off their flights and rounds
	$stmt=db_prep("
		UPDATE event_pilot_round_flight
		SET event_pilot_round_flight_status=0
		WHERE event_pilot_round_id in (SELECT event_pilot_round_id from event_pilot_round WHERE event_pilot_id=:event_pilot_id)
	");
	$result=db_exec($stmt,array("event_pilot_id"=>$event_pilot_id));

	# Now lets recalculate and save the event info because this pilot is no longer there
	$e=new Event($event_id);
	$e->event_save_totals();

	log_action($event_pilot_id);
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
	if($user['user_admin']){
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
	log_action($pilot_id);
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
	
	log_action($event_user_id);
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
	# Now lets recalculate and save the event info because the parameters may have changed
	$e=new Event($event_id);
	$e->event_save_totals();
	
	log_action($event_id);
	user_message("Event Parameters Saved.");
	return event_edit();
}
function event_round_edit() {
	global $smarty;
	# Function to add or edit a round to an event
	
	$event_id=intval($_REQUEST['event_id']);
	$event_round_id=intval($_REQUEST['event_round_id']);
	$zero_round=intval($_REQUEST['zero_round']);
	$flyoff_round=intval($_REQUEST['flyoff_round']);
	if(isset($_REQUEST['sort_by'])){
		$sort_by=$_REQUEST['sort_by'];
	}else{
		$sort_by='round_rank';
	}
	$event=new Event($event_id);
	$event->get_rounds();

	$flight_types=$event->flight_types;	
	# Now lets look at the rounds to see which is the next round # to add if its a new one
	$round=array();
	if($event_round_id==0){
		# Lets see if this is a zero round
		if($zero_round){
			# Lets see if there is already a zero round and make it 00 or 000
			$num_zeros=0;
			foreach($event->rounds as $number=>$r){
				if(preg_match("/^0/",$number)){
					$num_zeros++;
				}
			}
			$round_number='';
			for($i=0; $i<=$num_zeros; $i++){
				$round_number.='0';
			}
		}else{
			# Lets figure out the next round number
			$max=0;
			foreach($event->rounds as $number=>$r){
				if($number>$max){
					$max=$number;
				}
			}
			$round_number=$max+1;
		}
		# Now Lets fill out the round info with default stuff from what type of event this is
		# We actually need to fill in the default round data for an empty round
		$event->get_new_round($round_number);
		# Lets set the round to be scored or not depending on the zero choice
		if($zero_round){
			$event->rounds[$round_number]['event_round_score_status']=0;
		}else{
			$event->rounds[$round_number]['event_round_score_status']=1;
		}
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
	$smarty->assign("sort_by",$sort_by);

	$smarty->assign("flight_types",$flight_types);
	$smarty->assign("event",$event);
	$smarty->assign("total_pilots",count($event->pilots));
	
	$permission=check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	
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
	$event_round_number=$_REQUEST['event_round_number'];
	$event_round_flyoff=intval($_REQUEST['event_round_flyoff']);
	$create_new_round=intval($_REQUEST['create_new_round']);
	$event_round_score_status=0;
	if(isset($_REQUEST['event_round_score_status']) && ($_REQUEST['event_round_score_status']=='on' || $_REQUEST['event_round_score_status']==1)){
		$event_round_score_status=1;
	}else{
		$event_round_score_status=0;
	}
	$new_round=0;
	if($event_round_id==0){
		$new_round=1;
	}
	# Get flight type info for determining max sub flights and stuff
	$flight_type=array();
	$stmt=db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id=:flight_type_id
	");
	$result=db_exec($stmt,array("flight_type_id"=>$flight_type_id));
	if(isset($result[0])){
		$flight_type=$result[0];
	}else{
		# No flight type chosen so lets set it on the event type
		$stmt=db_prep("
			SELECT *
			FROM event e
			LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
			WHERE e.event_id=:event_id
		");
		$result=db_exec($stmt,array("event_id"=>$event_id));
		$event_code=$result[0]['event_type_code'];
		$pattern='';
		switch($event_code){
			case 'f3f':
				$pattern='f3f_speed';
				break;
			case 'f3b_speed':
				$pattern='f3b_speed';
				break;
			case 'f3j':
				$pattern='f3j_duration';
				break;
			case 'td':
				$pattern='td_duration';
				break;				
			case 'f3b':
			case 'f3k':
			default:
		}
		if($pattern!=''){
			$stmt=db_prep("
				SELECT *
				FROM flight_type
				WHERE flight_type_code=:pattern
			");
			$result=db_exec($stmt,array("pattern"=>$pattern));
			$flight_type=$result[0];
			$flight_type_id=$flight_type['flight_type_id'];
		}
	}
	
	# First, lets save the round info
	if($event_round_id==0){
		# New round, so lets create
		# Lets first see if maybe we already created one with the quick score routines
		$stmt=db_prep("
			SELECT *
			FROM event_round
			WHERE event_id=:event_id
			AND event_round_number=:event_round_number
			AND event_round_status=1
		");
		$result=db_exec($stmt,array("event_id"=>$event_id,"event_round_number"=>$event_round_number));
		if(isset($result[0])){
			$event_round_id=$result[0]['event_round_id'];
			$_REQUEST['event_round_id']=$event_round_id;
			# Need to update it to say that it no longer needs calculation
			$stmt=db_prep("
				UPDATE event_round
				SET event_round_needs_calc=1
				WHERE event_round_id=:event_round_id
			");
			$result=db_exec($stmt,array(
				"event_round_id"=>$event_round_id
			));
		}else{
			$stmt=db_prep("
				INSERT INTO event_round
				SET event_id=:event_id,
					event_round_number=:event_round_number,
					flight_type_id=:flight_type_id,
					event_round_time_choice=:event_round_time_choice,
					event_round_score_status=:event_round_score_status,
					event_round_needs_calc=0,
					event_round_flyoff=:event_round_flyoff,
					event_round_status=1
			");
			$result=db_exec($stmt,array(
				"event_id"=>$event_id,
				"event_round_number"=>$event_round_number,
				"flight_type_id"=>$flight_type_id,
				"event_round_time_choice"=>$event_round_time_choice,
				"event_round_flyoff"=>$event_round_flyoff,
				"event_round_score_status"=>$event_round_score_status
			));
			$event_round_id=$GLOBALS['last_insert_id'];
			$_REQUEST['event_round_id']=$event_round_id;
		}
	}else{
		# Lets save it
		$stmt=db_prep("
			UPDATE event_round
			SET flight_type_id=:flight_type_id,
				event_round_time_choice=:event_round_time_choice,
				event_round_score_status=:event_round_score_status,
				event_round_flyoff=:event_round_flyoff,
				event_round_needs_calc=0
			WHERE event_round_id=:event_round_id
		");
		$result=db_exec($stmt,array(
			"flight_type_id"=>$flight_type_id,
			"event_round_time_choice"=>$event_round_time_choice,
			"event_round_score_status"=>$event_round_score_status,
			"event_round_flyoff"=>$event_round_flyoff,
			"event_round_id"=>$event_round_id
		));
	}

	# Now lets save the round flight type scoring data
	if($new_round && $event_code!='f3b'){
		# Its a new round, so lets create the flight types with the scoring already turned on
		# First lets see if it exists
		$stmt=db_prep("
			SELECT *
			FROM event_round_flight
			WHERE event_round_id=:event_round_id
			AND flight_type_id=:flight_type_id
		");
		$result=db_exec($stmt,array("event_round_id"=>$event_round_id,"flight_type_id"=>$flight_type_id));
		if(isset($result[0])){
			# This one already exists, so lets update it
			$stmt=db_prep("
				UPDATE event_round_flight
				SET event_round_flight_score=1
				WHERE event_round_flight_id=:event_round_flight_id
			");
			$result2=db_exec($stmt,array("event_round_flight_id"=>$result[0]['event_round_flight_id']));
		}else{
			# This record doesn't exist, so lets create a new one
			$stmt=db_prep("
				INSERT INTO event_round_flight
				SET event_round_id=:event_round_id,
					flight_type_id=:flight_type_id,
					event_round_flight_score=1
			");
			$result2=db_exec($stmt,array("event_round_id"=>$event_round_id,"flight_type_id"=>$flight_type_id));
		}
	}else{
		# This round already existed, so lets update everything
		# First, lets turn off all of the round scoring data for this round and the flights
		$stmt=db_prep("
			UPDATE event_round_flight
			SET event_round_flight_score=0
			WHERE event_round_id=:event_round_id
		");
		$result=db_exec($stmt,array("event_round_id"=>$event_round_id));
		# Now lets step through the ones that are "on" and update or create the record
		foreach($_REQUEST as $key=>$value){
			if(preg_match("/^event_round_flight_score_(\d+)$/",$key,$match)){
				$ftype_id=$match[1];
				if($value=='on'){
					# lets save or create this record
					# First lets see if it exists
					$stmt=db_prep("
						SELECT *
						FROM event_round_flight
						WHERE event_round_id=:event_round_id
						AND flight_type_id=:ftype_id
					");
					$result=db_exec($stmt,array("event_round_id"=>$event_round_id,"ftype_id"=>$ftype_id));
					if(isset($result[0])){
						# This one already exists, so lets update it
						$stmt=db_prep("
							UPDATE event_round_flight
							SET event_round_flight_score=1
							WHERE event_round_flight_id=:event_round_flight_id
						");
						$result2=db_exec($stmt,array("event_round_flight_id"=>$result[0]['event_round_flight_id']));
					}else{
						# This record doesn't exist, so lets create a new one
						$stmt=db_prep("
							INSERT INTO event_round_flight
							SET event_round_id=:event_round_id,
								flight_type_id=:ftype_id,
								event_round_flight_score=1
						");
						$result2=db_exec($stmt,array("event_round_id"=>$event_round_id,"ftype_id"=>$ftype_id));
					}
				}
			}
		}
	}

	# Now lets save the pilot flight info
	# Lets build the data grid
	$data=array();
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^pilot_sub_flight_(\d+)\_(\d+)\_(\d+)\_(\d+)$/",$key,$match)){
			$sub=$match[1];
			$event_pilot_round_flight_id=$match[2];
			$event_pilot_id=$match[3];
			$flight_type_id=$match[4];
			# Now lets massage the value to make sure its entered in colon notation, or insert the colons
			$value=convert_string_to_colon($value);
			# Lets check to see if this sub flight has a max set up and change it if it does
			if($flight_type['flight_type_sub_flights_max_time']!=0){
				$seconds=convert_colon_to_seconds($value);
				if($seconds>$flight_type['flight_type_sub_flights_max_time']){
					$seconds=$flight_type['flight_type_sub_flights_max_time'];
					$value=convert_seconds_to_colon($seconds);
				}
			}
			$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub'][$sub]=$value;
		}elseif(preg_match("/^pilot_(\S+)\_(\d+)\_(\d+)\_(\d+)$/",$key,$match)){
			$field=$match[1];
			$event_pilot_round_flight_id=$match[2];
			$event_pilot_id=$match[3];
			$flight_type_id=$match[4];
			if($value=='on'){
				$value=1;
			}
			$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id][$field]=$value;
		}
	}
	# Lets total up the subflights to calculate the full flight time
	if($flight_type['flight_type_sub_flights']!=0){
		# It has sub flights
		foreach($data as $event_pilot_round_flight_id=>$p){
			foreach($p as $event_pilot_id=>$f){
				foreach($f as $flight_type_id=>$v){
					$tot=0;
					foreach($v['sub'] as $num=>$t){
						$tot=$tot+convert_colon_to_seconds($t);
					}
					$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['min']=floor($tot/60);
					$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sec']=sprintf("%02d",fmod($tot,60));
				}
			}
		}
	}

	# Now step through each one and save the flight record
	foreach($data as $event_pilot_round_flight_id=>$p){
		foreach($p as $event_pilot_id=>$f){
			foreach($f as $flight_type_id=>$v){

				# We need to get the event_pilot_round_id for this round and event pilot
				$stmt=db_prep("
					SELECT *
					FROM event_pilot_round epr
					WHERE epr.event_round_id=:event_round_id
						AND epr.event_pilot_id=:event_pilot_id
				");
				$result=db_exec($stmt,array("event_round_id"=>$event_round_id,"event_pilot_id"=>$event_pilot_id));
				if(!isset($result[0])){
					# Event round doesn't exist, so lets create one
					$stmt=db_prep("
						INSERT INTO event_pilot_round
						SET event_pilot_id=:event_pilot_id,
							event_round_id=:event_round_id
					");
					$result2=db_exec($stmt,array("event_round_id"=>$event_round_id,"event_pilot_id"=>$event_pilot_id));
					$event_pilot_round_id=$GLOBALS['last_insert_id'];
				}else{
					$event_pilot_round_id=$result[0]['event_pilot_round_id'];
				}

				# Now lets check if this is a new one or not
				if($event_pilot_round_flight_id==0){
					# This record is a new one (maybe)
					# Lets check if one already exists from the auto save feature
					$stmt=db_prep("
						SELECT *
						FROM event_pilot_round_flight erf
						WHERE erf.event_pilot_round_id=:event_pilot_round_id
							AND erf.flight_type_id=:flight_type_id
					");
					$result=db_exec($stmt,array(
						"event_pilot_round_id"=>$event_pilot_round_id,
						"flight_type_id"=>$flight_type_id
					));
					if(isset($result[0])){
						$event_pilot_round_flight_id_actual=$result[0]['event_pilot_round_flight_id'];
					}else{
						$event_pilot_round_flight_id_actual=0;
					}
				}else{
					$event_pilot_round_flight_id_actual=$event_pilot_round_flight_id;
				}
				
				# Lets see if the values are DNS or DNF and set the parameters
				$dns=0;
				$dnf=0;
				if(strtolower($v['sec'])=='dns'){
					$dns=1;
					$v['sec']=0;
				}
				if(strtolower($v['sec'])=='dnf'){
					$dnf=1;
					$v['sec']=0;
				}
				
				# Lets see if this flight already exists
				$stmt=db_prep("
					SELECT *
					FROM event_pilot_round_flight erf
					WHERE erf.event_pilot_round_flight_id=:event_pilot_round_flight_id
				");
				$result=db_exec($stmt,array(
					"event_pilot_round_flight_id"=>$event_pilot_round_flight_id_actual
				));
				if(isset($result[0])){
					# There is already a record, so save this one
					$stmt=db_prep("
						UPDATE event_pilot_round_flight
						SET event_pilot_round_flight_group=:event_pilot_round_flight_group,
							event_pilot_round_flight_minutes=:event_pilot_round_flight_minutes,
							event_pilot_round_flight_seconds=:event_pilot_round_flight_seconds,
							event_pilot_round_flight_over=:event_pilot_round_flight_over,
							event_pilot_round_flight_laps=:event_pilot_round_flight_laps,
							event_pilot_round_flight_landing=:event_pilot_round_flight_landing,
							event_pilot_round_flight_order=:event_pilot_round_flight_order,
							event_pilot_round_flight_dns=:event_pilot_round_flight_dns,
							event_pilot_round_flight_dnf=:event_pilot_round_flight_dnf,
							event_pilot_round_flight_penalty=:event_pilot_round_flight_penalty,
							event_pilot_round_flight_status=1
						WHERE event_pilot_round_flight_id=:event_pilot_round_flight_id
					");
					$result2=db_exec($stmt,array(
						"event_pilot_round_flight_id"=>$event_pilot_round_flight_id_actual,
						"event_pilot_round_flight_group"=>$v['group'],
						"event_pilot_round_flight_minutes"=>$v['min'],
						"event_pilot_round_flight_seconds"=>$v['sec'],
						"event_pilot_round_flight_over"=>$v['over'],
						"event_pilot_round_flight_laps"=>$v['laps'],
						"event_pilot_round_flight_landing"=>$v['land'],
						"event_pilot_round_flight_order"=>$v['order'],
						"event_pilot_round_flight_dns"=>$dns,
						"event_pilot_round_flight_dnf"=>$dnf,
						"event_pilot_round_flight_penalty"=>$v['pen']
					));
				}else{
					# There isn't a record, so lets create a new one
					$stmt=db_prep("
						INSERT INTO event_pilot_round_flight
						SET event_pilot_round_id=:event_pilot_round_id,
							flight_type_id=:flight_type_id,
							event_pilot_round_flight_group=:event_pilot_round_flight_group,
							event_pilot_round_flight_minutes=:event_pilot_round_flight_minutes,
							event_pilot_round_flight_seconds=:event_pilot_round_flight_seconds,
							event_pilot_round_flight_over=:event_pilot_round_flight_over,
							event_pilot_round_flight_laps=:event_pilot_round_flight_laps,
							event_pilot_round_flight_landing=:event_pilot_round_flight_landing,
							event_pilot_round_flight_order=:event_pilot_round_flight_order,
							event_pilot_round_flight_dns=:event_pilot_round_flight_dns,
							event_pilot_round_flight_dnf=:event_pilot_round_flight_dnf,
							event_pilot_round_flight_penalty=:event_pilot_round_flight_penalty,
							event_pilot_round_flight_status=1
					");
					$result2=db_exec($stmt,array(
						"event_pilot_round_id"=>$event_pilot_round_id,
						"flight_type_id"=>$flight_type_id,
						"event_pilot_round_flight_group"=>$v['group'],
						"event_pilot_round_flight_minutes"=>$v['min'],
						"event_pilot_round_flight_seconds"=>$v['sec'],
						"event_pilot_round_flight_over"=>$v['over'],
						"event_pilot_round_flight_laps"=>$v['laps'],
						"event_pilot_round_flight_landing"=>$v['land'],
						"event_pilot_round_flight_order"=>$v['order'],
						"event_pilot_round_flight_dns"=>$dns,
						"event_pilot_round_flight_dnf"=>$dnf,
						"event_pilot_round_flight_penalty"=>$v['pen']
					));
					$event_pilot_round_flight_id_actual=$GLOBALS['last_insert_id'];
				}
				
				# lets save the sub flights now if there are any
				if(isset($v['sub'])){
					# There are sub flights, so lets save them
					foreach($v['sub'] as $num=>$t){
						# Lets see if one exists already
						$stmt=db_prep("
							SELECT *
							FROM event_pilot_round_flight_sub erfs
							WHERE erfs.event_pilot_round_flight_id=:event_pilot_round_flight_id
								AND erfs.event_pilot_round_flight_sub_num=:num
						");
						$result=db_exec($stmt,array(
							"event_pilot_round_flight_id"=>$event_pilot_round_flight_id_actual,
							"num"=>$num
						));
						if(isset($result[0])){
							$event_pilot_round_flight_sub_id=$result[0]['event_pilot_round_flight_sub_id'];
						}else{
							$event_pilot_round_flight_sub_id=0;
						}
						if($event_pilot_round_flight_sub_id==0){
							# Create a new record
							$stmt=db_prep("
								INSERT INTO event_pilot_round_flight_sub
								SET event_pilot_round_flight_id=:event_pilot_round_flight_id,
									event_pilot_round_flight_sub_num=:num,
									event_pilot_round_flight_sub_val=:val
							");
							$result=db_exec($stmt,array(
								"event_pilot_round_flight_id"=>$event_pilot_round_flight_id_actual,
								"num"=>$num,
								"val"=>$t
							));
						}else{
							# Save the existing record
							$stmt=db_prep("
								UPDATE event_pilot_round_flight_sub
								SET event_pilot_round_flight_sub_val=:val
								WHERE event_pilot_round_flight_sub_id=:event_pilot_round_flight_sub_id
							");
							$result=db_exec($stmt,array(
								"event_pilot_round_flight_sub_id"=>$event_pilot_round_flight_sub_id,
								"val"=>$t
							));
						}
					}
				}
			}
		}
	}
	# OK, now lets call the routine to do the calculation for a single round
	# First, since we saved the data, reset the $event object
	$event=new Event($event_id);
	$event->calculate_round($event_round_number);
	# Now lets recalculate and save the event total info
	# Refresh the round info
	$event->get_rounds();
	$event->event_save_totals();

	log_action($event_round_id);

	if($create_new_round==1){
		#This means they want to save the round and create a new one
		user_message("Saved round and created the next one.");
		$_REQUEST['event_round_id']=0;
		$_REQUEST['zero_round']=0;
		$_REQUEST['flyoff_round']=0;
		return event_round_edit();
	}
	user_message("Saved event round info.");
	return event_round_edit();
}
function event_round_add_reflight() {
	# Function to remove a reflight flight
	$event_id=intval($_REQUEST['event_id']);
	$event_round_id=intval($_REQUEST['event_round_id']);
	$flight_type_id=intval($_REQUEST['flight_type_id']);
	$event_pilot_id=intval($_REQUEST['event_pilot_id']);
	$event_round_number=$_REQUEST['event_round_number'];
	$group=$_REQUEST['group'];
	
	# Need to find the event_pilot_round_id from the info given
	$stmt=db_prep("
		SELECT *
		FROM event_pilot_round
		WHERE event_pilot_id=:event_pilot_id
		AND event_round_id=:event_round_id
	");
	$result=db_exec($stmt,array("event_pilot_id"=>$event_pilot_id,"event_round_id"=>$event_round_id));
	if(isset($result[0])){
		$event_pilot_round_id=$result[0]['event_pilot_round_id'];	
		# Now Lets create this record
		$stmt=db_prep("
			INSERT INTO event_pilot_round_flight
			SET event_pilot_round_id=:event_pilot_round_id,
				flight_type_id=:flight_type_id,
				event_pilot_round_flight_group=:group,
				event_pilot_round_flight_reflight=1,
				event_pilot_round_flight_status=1
		");
		$result2=db_exec($stmt,array(
			"event_pilot_round_id"=>$event_pilot_round_id,
			"flight_type_id"=>$flight_type_id,
			"group"=>$group
		));
	}	
	
	$event=new Event($event_id);
	# Refresh the round info
	$event->get_rounds();
	log_action($event_round_id);
	user_message("Added the reflight entry.");
	return event_round_edit();
}
function event_round_flight_delete() {
	# Function to remove a reflight flight
	$event_id=intval($_REQUEST['event_id']);
	$event_round_id=intval($_REQUEST['event_round_id']);
	$event_pilot_round_flight_id=intval($_REQUEST['event_pilot_round_flight_id']);
	$event_round_number=$_REQUEST['event_round_number'];
	
	# Update to turn off record
	$stmt=db_prep("
		UPDATE event_pilot_round_flight
		SET event_pilot_round_flight_status=0
		WHERE event_pilot_round_flight_id=:event_pilot_round_flight_id
	");
	$result2=db_exec($stmt,array(
		"event_pilot_round_flight_id"=>$event_pilot_round_flight_id
	));
	
	$event=new Event($event_id);
	$event->calculate_round($event_round_number);
	# Now lets recalculate and save the event total info
	# Refresh the round info
	$event->get_rounds();
	$event->event_save_totals();
	log_action($event_round_id);
	user_message("Removed the reflight entry.");
	return event_round_edit();
}
function event_round_delete() {
	global $smarty;
	# Function to save the round
	
	$event_id=intval($_REQUEST['event_id']);
	$event_round_id=intval($_REQUEST['event_round_id']);

	# First, lets save the round info
	$stmt=db_prep("
		UPDATE event_round
		SET event_round_status=0
		WHERE event_round_id=:event_round_id
	");
	$result=db_exec($stmt,array(
		"event_round_id"=>$event_round_id
	));

	# Now lets turn off all the flights in this round
	$stmt=db_prep("
		UPDATE event_pilot_round_flight
		SET event_pilot_round_flight_status=0
		WHERE event_pilot_round_id IN (SELECT event_pilot_round_id FROM event_pilot_round WHERE event_round_id=:event_round_id)
	");
	$result=db_exec($stmt,array(
		"event_round_id"=>$event_round_id
	));

	# Now lets recalculate and save the event total info
	$event=new Event($event_id);
	$event->event_save_totals();
	
	log_action($event_round_id);
	user_message("Deleted Event Round.");
	return event_view();
}
function event_pilot_rounds() {
	global $smarty;
	# Function to view the rounds for a particular pilot
	
	$event_id=intval($_REQUEST['event_id']);
	$event_pilot_id=intval($_REQUEST['event_pilot_id']);

	$event=new Event($event_id);
	$event->get_rounds();
	
	$smarty->assign("event_pilot_id",$event_pilot_id);
	$smarty->assign("event",$event);
	
	$maintpl=find_template("event_pilot_view.tpl");
	return $smarty->fetch($maintpl);
}
function event_print_overall() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	if($event_id==0){
		user_message("That is not a proper event id to print.");
		return event_list();
	}
	
	$e=new Event($event_id);
	$e->get_rounds();

	$smarty->assign("event",$e);
	
	$maintpl=find_template("print_event_overall.tpl");
	return $smarty->fetch($maintpl);
}
function event_print_round() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	if($event_id==0){
		user_message("That is not a proper event id to print.");
		return event_list();
	}
	$round_from=$_REQUEST['round_start_number'];
	$round_to=$_REQUEST['round_end_number'];
	$one_per_page=0;
	if(isset($_REQUEST['oneper']) && $_REQUEST['oneper']=='on'){
		$one_per_page=1;
	}
	
	$e=new Event($event_id);
	$e->get_rounds();

	$smarty->assign("event",$e);
	$smarty->assign("round_from",$round_from);
	$smarty->assign("round_to",$round_to);
	$smarty->assign("one_per_page",$one_per_page);
	
	$maintpl=find_template("print_event_rounds.tpl");
	return $smarty->fetch($maintpl);
}
function event_print_pilot() {
	global $smarty;
	# Function to view the rounds for a particular pilot
	
	$event_id=intval($_REQUEST['event_id']);
	$event_pilot_id=intval($_REQUEST['event_pilot_id']);

	$event=new Event($event_id);
	$event->get_rounds();
	
	$smarty->assign("event_pilot_id",$event_pilot_id);
	$smarty->assign("event",$event);
	
	$maintpl=find_template("print_event_pilot_view.tpl");
	return $smarty->fetch($maintpl);
}
function event_print_stats() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	if($event_id==0){
		user_message("That is not a proper event id to edit.");
		return event_list();
	}
	
	$e=new Event($event_id);
	$e->get_rounds();

	# Lets determine if we need a laps report and an average speed report
	$laps=0;
	$speed=0;
	$landing=0;
	$duration=0;
	foreach($e->pilots as $p){
		if($p['event_pilot_total_laps']!=0){
			$laps=1;
		}
		if($p['event_pilot_average_speed']!=0){
			$speed=1;
		}
	}
	foreach($e->flight_types as $ft){
		if($ft['flight_type_landing']==1){
			$landing=1;
		}
		if($ft['flight_type_code']=='f3b_duration'){
			$duration=1;
		}
	}
	$lap_totals=array();
	$speed_averages=array();
	$speed_times=array();
	if($laps){
		# Lets sort the pilots by order of distance laps
		$lap_totals=array_msort($e->pilots,array("event_pilot_lap_rank"=>SORT_ASC));
		$smarty->assign("lap_totals",$lap_totals);
		# Lets get the top distance list
		$distance_laps=$e->get_top_distance();
		$smarty->assign("distance_laps",$distance_laps);
		# Lets get the distance ranking
		$distance_rank=$e->get_distance_rank();
		$smarty->assign("distance_rank",$distance_rank);
	}
	if($speed){
		# Lets get the speed ranking
		$speed_rank=$e->get_speed_rank();
		$smarty->assign("speed_rank",$speed_rank);
		# Lets sort the pilots by order of speed average
		$speed_averages=array_msort($e->pilots,array("event_pilot_average_speed_rank"=>SORT_ASC));
		$smarty->assign("speed_averages",$speed_averages);
		# Lets get the top speed list
		$speed_times=$e->get_top_speeds();
		$smarty->assign("speed_times",$speed_times);
	}
	if($landing){
		# Lets get the top landing accuracy list
		$top_landing=$e->get_top_landing();
		$smarty->assign("top_landing",$top_landing);
	}
	if($duration){
		# Lets get the duration rank
		$duration_rank=$e->get_duration_rank();
		$smarty->assign("duration_rank",$duration_rank);
	}
	
	$smarty->assign("event",$e);
	
	$maintpl=find_template("print_event_stats.tpl");
	return $smarty->fetch($maintpl);
}
function save_individual_flight(){
	# Function to save a single score if it has been changed
	
	$event_id=intval($_REQUEST['event_id']);
	$event_round_id=intval($_REQUEST['event_round_id']);
	$event_round_number=$_REQUEST['event_round_number'];
	$event_round_time_choice=$_REQUEST['event_round_time_choice'];
	$event_round_score_status=$_REQUEST['event_round_score_status'];
	$event_round_time_choice=$_REQUEST['event_round_time_choice'];
	$flight_type_id=$_REQUEST['flight_type_id'];
	$field_name=$_REQUEST['field_name'];
	$field_value=$_REQUEST['field_value'];
	if($event_round_score_status == 'on' || $event_round_score_status == 1){
		$event_round_score_status=1;
	}else{
		$event_round_score_status=0;
	}
	
	# Lets get the info from the field being saved
	if(preg_match("/^pilot_(\S+)\_(\d+)\_(\d+)_(\d+)$/",$field_name,$match)){
		$field=$match[1];
		$event_pilot_round_flight_id=$match[2];
		$event_pilot_id=$match[3];
		$event_round_flight_type_id=$match[4];
		if($field_value=='on'){
			$field_value=1;
		}
	}

	# Lets determine if we need to create a new event round record first
	if($event_round_id==0){
		# Lets see if it already exists
		$stmt=db_prep("
			SELECT *
			FROM event_round
			WHERE event_id=:event_id
			AND event_round_number=:event_round_number
			AND event_round_status=1
		");
		$result=db_exec($stmt,array("event_id"=>$event_id,"event_round_number"=>$event_round_number));
		if(isset($result[0])){
			$event_round_id=$result[0]['event_round_id'];
			# Need to update it to say that it needs calculation
			$stmt=db_prep("
				UPDATE event_round
				SET event_round_needs_calc=1,
					event_round_time_choice=:event_round_time_choice,
					event_round_score_status=:event_round_score_status,
					flight_type_id=:flight_type_id
				WHERE event_round_id=:event_round_id
			");
			$result=db_exec($stmt,array(
				"event_round_id"=>$event_round_id,
				"event_round_time_choice"=>$event_round_time_choice,
				"event_round_score_status"=>$event_round_score_status,
				"flight_type_id"=>$flight_type_id
			));
		}else{
			# New round, so lets create
			$stmt=db_prep("
				INSERT INTO event_round
				SET event_id=:event_id,
					event_round_number=:event_round_number,
					flight_type_id=:flight_type_id,
					event_round_time_choice=:event_round_time_choice,
					event_round_score_status=:event_round_score_status,
					event_round_needs_calc=1,
					event_round_status=1
			");
			$result=db_exec($stmt,array(
				"event_id"=>$event_id,
				"event_round_number"=>$event_round_number,
				"flight_type_id"=>$flight_type_id,
				"event_round_time_choice"=>$event_round_time_choice,
				"event_round_score_status"=>$event_round_score_status
			));
			$event_round_id=$GLOBALS['last_insert_id'];
			# Lets also create a new event_round_flight that is set to on
			$stmt=db_prep("
				INSERT INTO event_round_flight
				SET event_round_id=:event_round_id,
					flight_type_id=:flight_type_id,
					event_round_flight_score=1
			");
			$result2=db_exec($stmt,array("event_round_id"=>$event_round_id,"flight_type_id"=>$event_round_flight_type_id));
		}
	}else{
		# Set this round to be calculated
		$stmt=db_prep("
			UPDATE event_round
			SET event_round_needs_calc=1,
				event_round_time_choice=:event_round_time_choice,
				event_round_score_status=:event_round_score_status,
				flight_type_id=:flight_type_id
			WHERE event_round_id=:event_round_id
		");
		$result=db_exec($stmt,array(
			"event_round_id"=>$event_round_id,
			"event_round_time_choice"=>$event_round_time_choice,
			"event_round_score_status"=>$event_round_score_status,
			"flight_type_id"=>$flight_type_id
		));
	}
	
	# Lets see if the values are DNS or DNF and set the parameters
	$dns=0;
	$dnf=0;

	# Make the set line based on the type
	switch($field){
		case "group":
			$setline='event_pilot_round_flight_group=:value';
			break;
		case "min":
			$setline='event_pilot_round_flight_minutes=:value';
			break;
		case "sec":
			if(strtolower($field_value)=='dns'){
				$dns=1;
				$field_value=0;
			}
			if(strtolower($field_value)=='dnf'){
				$dnf=1;
				$field_value=0;
			}
			$setline='event_pilot_round_flight_seconds=:value ';
			break;
		case "over":
			$setline='event_pilot_round_flight_over=:value';
			break;
		case "laps":
			$setline='event_pilot_round_flight_laps=:value';
			break;
		case "order":
			$setline='event_pilot_round_flight_order=:value';
			break;
		case "land":
			$setline='event_pilot_round_flight_landing=:value';
			break;
		case "pen":
			$setline='event_pilot_round_flight_penalty=:value';
			break;
	}
	
	# Now step through each one and save the flight record
	if($event_pilot_round_flight_id==0){
		# This flight doesnt yet exist, so lets create it
		# We need to get the event_pilot_round_id
		$stmt=db_prep("
			SELECT *
			FROM event_pilot_round epr
			WHERE epr.event_round_id=:event_round_id
				AND epr.event_pilot_id=:event_pilot_id
		");
		$result2=db_exec($stmt,array("event_round_id"=>$event_round_id,"event_pilot_id"=>$event_pilot_id));
		if(!isset($result2[0])){
			# Event pilot round doesn't exist, so lets create one
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
		# Now we need to see if a round flight already exists...sheesh
		$stmt=db_prep("
			SELECT *
			FROM event_pilot_round_flight
			WHERE event_pilot_round_id=:event_pilot_round_id
			AND flight_type_id=:flight_type_id
			AND event_pilot_round_flight_status=1
		");
		$result2=db_exec($stmt,array(
			"event_pilot_round_id"=>$event_pilot_round_id,
			"flight_type_id"=>$event_round_flight_type_id
		));
		if(isset($result2[0])){
			# This one already exists, so lets update it
			$stmt=db_prep("
				UPDATE event_pilot_round_flight
				SET $setline,
					event_pilot_round_flight_status=1
				WHERE event_pilot_round_flight_id=:event_pilot_round_flight_id
			");
			$result3=db_exec($stmt,array(
				"event_pilot_round_flight_id"=>$result2[0]['event_pilot_round_flight_id'],
				"value"=>$field_value
			));
		}else{
			$stmt=db_prep("
				INSERT INTO event_pilot_round_flight
				SET event_pilot_round_id=:event_pilot_round_id,
					flight_type_id=:flight_type_id,
					$setline,
					event_pilot_round_flight_dns=:dns,
					event_pilot_round_flight_dnf=:dnf,
					event_pilot_round_flight_status=1
			");
			$result2=db_exec($stmt,array(
				"event_pilot_round_id"=>$event_pilot_round_id,
				"flight_type_id"=>$event_round_flight_type_id,
				"value"=>$field_value,
				"dns"=>$dns,
				"dnf"=>$dnf
			));
		}
	}else{
		# This flight already existed
		# So lets save it
		$stmt=db_prep("
			UPDATE event_pilot_round_flight
			SET $setline,
				event_pilot_round_flight_dns=:dns,
				event_pilot_round_flight_dnf=:dnf,
				event_pilot_round_flight_status=1
			WHERE event_pilot_round_flight_id=:event_pilot_round_flight_id
		");
		$result2=db_exec($stmt,array(
			"event_pilot_round_flight_id"=>$event_pilot_round_flight_id,
			"value"=>$field_value,
			"dns"=>$dns,
			"dnf"=>$dnf
		));
	}
	return;
}
function event_draw() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$e=new Event($event_id);
	$e->get_teams();
	$e->get_rounds();
	$e->get_draws();
	
	$permission=check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	
	$smarty->assign("event",$e);
	
	# Lets determine the round #'s to print for the draw from the existing rounds to the max on the draws
	$print_rounds=array();

	foreach($e->draws as $d){
		if($d['event_draw_active']!=1){
			continue;
		}
		$min=1;
		$max=0;
		if($d['event_draw_round_to']<$min){
			$min=$d['event_draw_round_from'];
		}
		if($d['event_draw_round_to']>$max){
			$max=$d['event_draw_round_to'];
		}
		$ft=$d['flight_type_id'];
		$print_rounds[$ft]=array("min"=>$min,"max"=>$max);
	}
	# Now lets step through the rounds and see if its a different max
	$num_rounds=count($e->rounds);
	foreach($e->flight_types as $flight_type_id=>$ft){
		if($print_rounds[$flight_type_id]['max']<count($e->rounds)){
			$print_rounds[$flight_type_id]['max']=count($e->rounds);
			$print_rounds[$flight_type_id]['min']=1;
		}
	}
	
	$smarty->assign("print_rounds",$print_rounds);

	$maintpl=find_template("event_draw.tpl");
	return $smarty->fetch($maintpl);
}
function event_draw_edit() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_draw_id=intval($_REQUEST['event_draw_id']);
	$flight_type_id=intval($_REQUEST['flight_type_id']);

	$e=new Event($event_id);
	$e->get_teams();

	$draw=array();
	if($event_draw_id!=0){
		# Get draw info
		$stmt=db_prep("
			SELECT *
			FROM event_draw
			WHERE event_draw_id=:event_draw_id
		");
		$result=db_exec($stmt,array("event_draw_id"=>$event_draw_id));
		$draw=$result[0];
	}	
	# Get flight type info
	$ft=array();
	$stmt=db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id=:flight_type_id
	");
	$result=db_exec($stmt,array("flight_type_id"=>$flight_type_id));
	$ft=$result[0];

	$num_teams=count($e->teams);
	$min_groups_np=1;
	$max_groups_np=floor(count($e->pilots)/2);
	
	# Lets determine the largest team
	foreach($e->pilots as $p){
		$team_name=$p['event_pilot_team'];
		$teams[$team_name]++;
	}
	arsort($teams);
	$max_on_team=array_shift($teams);
	if($num_teams>$max_on_team){
		$min_groups_p=$num_teams;
	}else{
		$min_groups_p=$max_on_team;
	}
	$max_groups_p=floor(count($e->pilots)/2);
	
#	print "min groups with protection=$min_groups_p<br>\n";
#	print "max groups with protection=$max_groups_p<br>\n";
	
#	print "min groups no protection=$min_groups_np<br>\n";
#	print "max groups no protection=$max_groups_np<br>\n";
	

	$smarty->assign("event",$e);
	$smarty->assign("draw",$draw);
	$smarty->assign("event_id",$event_id);
	$smarty->assign("event_draw_id",$event_draw_id);
	$smarty->assign("ft",$ft);
	
	$maintpl=find_template("event_draw_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_draw_save(){
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_draw_id=intval($_REQUEST['event_draw_id']);
	$flight_type_id=intval($_REQUEST['flight_type_id']);
	$event_draw_round_from=intval($_REQUEST['event_draw_round_from']);
	$event_draw_round_to=intval($_REQUEST['event_draw_round_to']);
	$event_draw_type=$_REQUEST['event_draw_type'];
	$event_draw_number_groups=intval($_REQUEST['event_draw_number_groups']);
	$event_draw_step_size=intval($_REQUEST['event_draw_step_size']);
	$event_draw_changed=intval($_REQUEST['event_draw_changed']);

	$event_draw_team_protection=0;
	if(isset($_REQUEST['event_draw_team_protection']) && $_REQUEST['event_draw_team_protection']=='on'){
		$event_draw_team_protection=1;
	}
	$event_draw_team_separation=0;
	if(isset($_REQUEST['event_draw_team_separation']) && $_REQUEST['event_draw_team_separation']=='on'){
		$event_draw_team_separation=1;
	}
	$recalc=0;
	if(isset($_REQUEST['recalc']) && $_REQUEST['recalc']=='recalc'){
		$recalc=1;
	}
	# Get flight type info
	$ft=array();
	$stmt=db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id=:flight_type_id
	");
	$result=db_exec($stmt,array("flight_type_id"=>$flight_type_id));
	$ft=$result[0];
	
	if($event_draw_changed==1){
		# Lets save the main draw parameters
		if($event_draw_id==0){
			$stmt=db_prep("
				INSERT INTO event_draw
				SET event_id=:event_id,
					flight_type_id=:flight_type_id,
					event_draw_type=:event_draw_type,
					event_draw_round_from=:event_draw_round_from,
					event_draw_round_to=:event_draw_round_to,
					event_draw_number_groups=:event_draw_number_groups,
					event_draw_step_size=:event_draw_step_size,
					event_draw_team_protection=:event_draw_team_protection,
					event_draw_team_separation=:event_draw_team_separation,
					event_draw_active=0,
					event_draw_status=1
			");
			$result=db_exec($stmt,array(
				"event_id"=>$event_id,
				"flight_type_id"=>$flight_type_id,
				"event_draw_round_from"=>$event_draw_round_from,
				"event_draw_round_to"=>$event_draw_round_to,
				"event_draw_type"=>$event_draw_type,
				"event_draw_number_groups"=>$event_draw_number_groups,
				"event_draw_step_size"=>$event_draw_step_size,
				"event_draw_team_protection"=>$event_draw_team_protection,
				"event_draw_team_separation"=>$event_draw_team_separation
			));
			$event_draw_id=$GLOBALS['last_insert_id'];
		}else{
			# Save the existing one
			$stmt=db_prep("
				UPDATE event_draw
				SET event_draw_type=:event_draw_type,
					event_draw_round_from=:event_draw_round_from,
					event_draw_round_to=:event_draw_round_to,
					event_draw_number_groups=:event_draw_number_groups,
					event_draw_step_size=:event_draw_step_size,
					event_draw_team_protection=:event_draw_team_protection,
					event_draw_team_separation=:event_draw_team_separation
				WHERE event_draw_id=:event_draw_id
			");
			$result=db_exec($stmt,array(
				"event_draw_round_from"=>$event_draw_round_from,
				"event_draw_round_to"=>$event_draw_round_to,
				"event_draw_type"=>$event_draw_type,
				"event_draw_number_groups"=>$event_draw_number_groups,
				"event_draw_step_size"=>$event_draw_step_size,
				"event_draw_team_protection"=>$event_draw_team_protection,
				"event_draw_team_separation"=>$event_draw_team_separation,
				"event_draw_id"=>$event_draw_id
			));
		}
		
		include_library('draw.class');
		$draw=new Draw($event_draw_id);

		# OK, I guess lets build the draw elements now
		switch($event_draw_type){
			case 'random':
				# This is an order task (speed)
				$draw->create_random_rounds($recalc);
				break;
			case 'random_step':
				# This is an order task (speed) with a step progression
				$draw->create_random_step_rounds($recalc);
				break;
			case 'group':
				# This is an group task
				$draw->create_group_rounds($recalc);
				break;
		}
	}
	return event_draw();
}
function event_draw_apply(){
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_draw_id=intval($_REQUEST['event_draw_id']);
	$flight_type_id=intval($_REQUEST['flight_type_id']);

	# Get flight type info
	$ft=array();
	$stmt=db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id=:flight_type_id
	");
	$result=db_exec($stmt,array("flight_type_id"=>$flight_type_id));
	$ft=$result[0];

	# Get draw info
	$draw=array();
	$stmt=db_prep("
		SELECT *
		FROM event_draw
		WHERE event_draw_id=:event_draw_id
	");
	$result=db_exec($stmt,array("event_draw_id"=>$event_draw_id));
	$draw=$result[0];
	
	# Lets check to see if this round has overlap with existing active rounds and error out if so
	# Get other active draws for this event
	$other_draws=array();
	$stmt=db_prep("
		SELECT *
		FROM event_draw
		WHERE event_id=:event_id
			AND flight_type_id=:flight_type_id
			AND event_draw_status=1
			AND event_draw_active=1
			AND event_draw_id!=:event_draw_id
	");
	$other_draws=db_exec($stmt,array(
		"event_id"=>$event_id,
		"flight_type_id"=>$flight_type_id,
		"event_draw_id"=>$event_draw_id
	));
	
	$from=$draw['event_draw_round_from'];
	$to=$draw['event_draw_round_to'];
	$overlap=0;
	foreach($other_draws as $o){
		$ofrom=$o['event_draw_round_from'];
		$oto=$o['event_draw_round_to'];
		if(($from>=$ofrom && $from<=$oto) || ($to>=$ofrom && $to<=$oto)){
			$overlap=1;
		}
	}
	if($overlap){
		user_message("Cannot Apply the draw because it overlaps with another existing active draw.",1);
		return event_draw();
	}
	
	# Ok, now lets get the rounds for this draw, and apply the group or order number to the existing event rounds
	$draw_rounds=array();
	$stmt=db_prep("
		SELECT *
		FROM event_draw_round
		WHERE event_draw_id=:event_draw_id
			AND event_draw_round_status=1
		ORDER BY event_draw_round_number,event_draw_round_group,event_draw_round_order
	");
	$result=db_exec($stmt,array("event_draw_id"=>$event_draw_id));
	foreach($result as $r){
		$round_number=$r['event_draw_round_number'];
		$event_pilot_id=$r['event_pilot_id'];
		$draw_rounds[$round_number][$event_pilot_id]=$r;
	}
	# OK, now lets step through the existing rounds and save the flight orders for this flight type in the existing rounds
	$e=new Event($event_id);
	$e->get_rounds();
	foreach($e->rounds as $round_number=>$r){
		foreach($r['flights'][$flight_type_id]['pilots'] as $event_pilot_id=>$p){
			$group='';
			$order=0;
			if(isset($draw_rounds[$round_number][$event_pilot_id]['event_draw_round_group'])){
				$group=$draw_rounds[$round_number][$event_pilot_id]['event_draw_round_group'];
			}
			if(isset($draw_rounds[$round_number][$event_pilot_id]['event_draw_round_order'])){
				$order=$draw_rounds[$round_number][$event_pilot_id]['event_draw_round_order'];
			}
			# lets save that flight now
			if($p['event_pilot_round_flight_id']){
				$stmt=db_prep("
					UPDATE event_pilot_round_flight
					SET event_pilot_round_flight_group=:group,
						event_pilot_round_flight_order=:order
					WHERE event_pilot_round_flight_id=:event_pilot_round_flight_id
				");
				$result=db_exec($stmt,array(
					"group"=>$group,
					"order"=>$order,
					"event_pilot_round_flight_id"=>$p['event_pilot_round_flight_id']
				));
			}else{
				# Looks like this is a new pilot that doesn't have a record yet, so lets create one
				# Lets get the event_pilot_round
				$stmt=db_prep("
					SELECT *
					FROM event_pilot_round epr
					WHERE epr.event_round_id=:event_round_id
						AND epr.event_pilot_id=:event_pilot_id
				");
				$result2=db_exec($stmt,array("event_round_id"=>$r['event_round_id'],"event_pilot_id"=>$event_pilot_id));
				if(!isset($result2[0])){
					# Event pilot round doesn't exist, so lets create one
					$stmt=db_prep("
						INSERT INTO event_pilot_round
						SET event_pilot_id=:event_pilot_id,
							event_round_id=:event_round_id
					");
					$result3=db_exec($stmt,array("event_round_id"=>$r['event_round_id'],"event_pilot_id"=>$event_pilot_id));
					$event_pilot_round_id=$GLOBALS['last_insert_id'];
				}else{
					$event_pilot_round_id=$result2[0]['event_pilot_round_id'];
				}
				
				$stmt=db_prep("
					INSERT INTO event_pilot_round_flight
					SET event_pilot_round_id=:event_pilot_round_id,
						flight_type_id=:flight_type_id,
						event_pilot_round_flight_group=:group,
						event_pilot_round_flight_order=:order,
						event_pilot_round_flight_status=1
				");
				$result=db_exec($stmt,array(
					"event_pilot_round_id"=>$event_pilot_round_id,
					"flight_type_id"=>$flight_type_id,
					"group"=>$group,
					"order"=>$order
				));
			}
		}
	}
	# Now lets change the status of the draw to active
	$stmt=db_prep("
		UPDATE event_draw
		SET event_draw_active=1
		WHERE event_draw_id=:event_draw_id
	");
	$result=db_exec($stmt,array("event_draw_id"=>$event_draw_id));
	
	user_message("Event Draw Applied.");
	return event_draw();
}
function event_draw_unapply(){
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_draw_id=intval($_REQUEST['event_draw_id']);
	$flight_type_id=intval($_REQUEST['flight_type_id']);

	# Get flight type info
	$ft=array();
	$stmt=db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id=:flight_type_id
	");
	$result=db_exec($stmt,array("flight_type_id"=>$flight_type_id));
	$ft=$result[0];

	# Get draw info
	$draw=array();
	$stmt=db_prep("
		SELECT *
		FROM event_draw
		WHERE event_draw_id=:event_draw_id
	");
	$result=db_exec($stmt,array("event_draw_id"=>$event_draw_id));
	$draw=$result[0];
	
	# Now lets change the status of the draw to inactive
	$stmt=db_prep("
		UPDATE event_draw
		SET event_draw_active=0
		WHERE event_draw_id=:event_draw_id
	");
	$result=db_exec($stmt,array("event_draw_id"=>$event_draw_id));
	
	user_message("Event Draw Inactivated.");
	return event_draw();
}
function event_draw_delete() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_draw_id=intval($_REQUEST['event_draw_id']);

	if($event_draw_id!=0){
		# turn draw off
		$stmt=db_prep("
			UPDATE event_draw
			SET event_draw_status=0
			WHERE event_draw_id=:event_draw_id
		");
		$result=db_exec($stmt,array("event_draw_id"=>$event_draw_id));
		user_message("Event Draw deleted.");
	}
	return event_draw();
}
function event_draw_print() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$flight_type_id=intval($_REQUEST['flight_type_id']);
	$print_round_from=intval($_REQUEST['print_round_from']);
	$print_round_to=intval($_REQUEST['print_round_to']);
	$print_type=$_REQUEST['print_type'];
	$print_format=$_REQUEST['print_format'];

	$template='';
	$title='';
	$orientation='P';
	$sort_by='';
	switch($print_type){
		case "cd":
			$template="print_draw_cd.tpl";
			$title="CD Recording Sheet";
			$orientation="P";
			$sort_by='flight_order';
			break;
		case "pilot":
			$template="print_draw_pilot_recording.tpl";
			$title="Pilot Score Recording Sheets";
			$orientation="L";
			$sort_by='alphabetical_first';
			break;
		case "table":
			$template="print_draw_table.tpl";
			$title="Draw Table";
			$orientation="P";
			$sort_by='team';
			break;
		case "matrix":
		default :
			$template="print_draw_matrix.tpl";
			$title="Draw Matrix";
			$orientation="P";
			$sort_by='flight_order';
			break;
	}
	$_REQUEST['sort_by']=$sort_by;
	
	$e=new Event($event_id);
	$e->get_teams();
	$e->get_rounds();
	$e->get_draws();

	# Lets add the rounds that don't exist with the draw values for printing
	# Step through any existing rounds and use those
	for($event_round_number=$print_round_from;$event_round_number<=$print_round_to;$event_round_number++){
		if(!isset($e->rounds[$event_round_number])){
			# Lets create the event round and enough info from the draw to print
			foreach($e->draws as $d){
				if($d['event_draw_active']==1){
					#Step through the draw rounds and see if one exists for this round
					foreach($d['flights'] as $flight_type_id=>$f){
						foreach($f as $round_num=>$v){
							if($round_num==$event_round_number){
								# Lets create the round info
								$e->rounds[$event_round_number]['event_round_number']=$event_round_number;
								$e->rounds[$event_round_number]['event_round_status']=1;
								$e->rounds[$event_round_number]['flights'][$flight_type_id]=$e->flight_types[$flight_type_id];
								foreach($v['pilots'] as $event_pilot_id=>$p){
									$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['flight_type_id']=$flight_type_id;
									$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_group']=$p['event_draw_round_group'];
									$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_order']=$p['event_draw_round_order'];
									$e->rounds[$event_round_number]['flights'][$flight_type_id]['event_round_flight_score']=1;
								
								}
							}
						}
					}	
				}
			}
		}
	}



	$smarty->assign("print_round_from",$print_round_from);
	$smarty->assign("print_round_to",$print_round_to);
	$smarty->assign("print_format",$print_format);
	$smarty->assign("flight_type_id",$flight_type_id);
	$smarty->assign("event",$e);
	
	
	if($print_format=='pdf'){
		# Create the PDF
		#include_library('tcpdf/config/lang/eng.php');
		include_library('tcpdf/tcpdf.php');
		$maintpl=find_template($template);
		$page_html=$smarty->fetch($template);
	
		# Now create the pdf from the above template and save it
		$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
		$pdf->SetCreator('F3X Vault');
		$pdf->SetAuthor('F3X Vault');
		$pdf->SetTitle($title);
		$pdf->setPrintHeader(false);
		$pdf->setHeaderMargin(0);
		$pdf->setFooterData($tc=array(0,64,0), $lc=array(0,64,128));
#		$pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
		$pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));
		$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		$pdf->SetMargins(10, 0, 10);
		$pdf->SetHeaderMargin(0);
		$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);
		$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
		$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
		$pdf->setFontSubsetting(true);
		$pdf->SetFont('times', '', 10, '', true);
		$pdf->AddPage($orientation);
		$pdf->writeHTMLCell($w=0, $h=0, $x='', $y='', $page_html, $border=0, $ln=1, $fill=0, $reseth=true, $align='', $autopadding=false);
		$file_contents=$pdf->Output("$title.pdf", 'D');
	}else{
		$maintpl=find_template($template);
		return $smarty->fetch($maintpl);
	}
}
function event_draw_view() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event_draw_id=intval($_REQUEST['event_draw_id']);
	$flight_type_id=intval($_REQUEST['flight_type_id']);

	$template="print_draw_matrix.tpl";
	$title="Draw Matrix";
	$sort_by='flight_order';
	
	# Lets get the draw info
	$draw=array();
	$stmt=db_prep("
		SELECT *
		FROM event_draw ed
		WHERE ed.event_draw_id=:event_draw_id
		AND event_draw_status=1
	");
	$result=db_exec($stmt,array("event_draw_id"=>$event_draw_id));
	$draw=$result[0];
	
	$print_round_from=$draw['event_draw_round_from'];
	$print_round_to=$draw['event_draw_round_to'];
	
	# Now lets get the draw rounds
	$stmt=db_prep("
		SELECT *
		FROM event_draw_round 
		WHERE event_draw_id=:event_draw_id
			AND event_draw_round_status=1
		ORDER BY event_draw_round_number,event_draw_round_group,event_draw_round_order
	");
	$rounds=db_exec($stmt,array("event_draw_id"=>$event_draw_id));
	foreach($rounds as $round){
		$round_number=$round['event_draw_round_number'];
		$event_pilot_id=$round['event_pilot_id'];
		$draw['rounds']['flights'][$flight_type_id][$round_number]['pilots'][$event_pilot_id]=$round;
	}
	
	$e=new Event($event_id);
	$e->get_teams();
	
	# Lets add the rounds that don't exist with the draw values for printing
	# Step through any existing rounds and use those
	for($event_round_number=$print_round_from;$event_round_number<=$print_round_to;$event_round_number++){
		if(!isset($e->rounds[$event_round_number])){
			# Lets create the event round and enough info from the draw to print
			#Step through the draw rounds and see if one exists for this round
			foreach($draw['rounds']['flights'] as $flight_type_id=>$f){
				foreach($f as $round_num=>$v){
					if($round_num==$event_round_number){
						# Lets create the round info
						$e->rounds[$event_round_number]['event_round_number']=$event_round_number;
						$e->rounds[$event_round_number]['event_round_status']=1;
						$e->rounds[$event_round_number]['flights'][$flight_type_id]=$e->flight_types[$flight_type_id];
						foreach($v['pilots'] as $event_pilot_id=>$p){
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['flight_type_id']=$flight_type_id;
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_group']=$p['event_draw_round_group'];
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_order']=$p['event_draw_round_order'];
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['event_round_flight_score']=1;
						}
					}
				}
			}	
		}
	}

	$smarty->assign("print_round_from",$print_round_from);
	$smarty->assign("print_round_to",$print_round_to);
	$smarty->assign("flight_type_id",$flight_type_id);
	$smarty->assign("print_format","html");
	$smarty->assign("event",$e);
	
	$maintpl=find_template($template);
	return $smarty->fetch($maintpl);
}
function event_chart() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);

	$e=new Event($event_id);
	$e->get_teams();
	$e->get_rounds();
	$e->calculate_event_totals();
	$e->get_running_totals();
	
	$smarty->assign("event",$e);
	$smarty->assign("event_id",$event_id);
	
	$maintpl=find_template("event_chart.tpl");
	return $smarty->fetch($maintpl);
}
function event_import() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$imported=0;
	if(isset($_FILES['import_file'])){
		$import_file=$_FILES['import_file']['tmp_name'];
		$imported=1;
	}
	$event_zero_round=0;
	if(isset($_REQUEST['event_zero_round']) && ($_REQUEST['event_zero_round']=='on' || $_REQUEST['event_zero_round']==1)){
		$event_zero_round=1;
	}

	$event=new Event($event_id);

	# If the file is imported, lets get the content
	$lines=array();
	if($imported){
		$rawlines=file($import_file);
		foreach($rawlines as $r){
			$templine=trim($r);
			$line_array=explode(",",$templine);
			# Lets see what the columns are
			$lines[]=$line_array;
		}
		
		$columns=array();
		foreach($lines[0] as $key=>$l){
			if(preg_match("/\S+/",$l) && !preg_match("/^dns/i",$l) && !preg_match("/^dnf/i",$l)){
				# This column has strings in it
				$columns[$key]='alpha';
			}
			if(preg_match("/\d+/",$l) || $l=='' || preg_match("/^dns/i",$l) || preg_match("/^dnf/i",$l)){
				# This column has numbers in it
				$columns[$key]='numeric';
			}
		}
		
		# Now lets step through each actual line and look up the pilot for a match
		foreach($lines as $key=>$l){
			$pilot_entered=$l[0];
			$q = trim(urldecode(strtolower($pilot_entered)));
			$q = '%'.$q.'%';
			# lets get the first name and last name out of it
			$words=preg_split("/\s+/",$pilot_entered,2);
			$first_name=$words[0];
			$last_name=$words[1];
			# Do search
			$found_pilots=array();
			$pilots=array();
			$stmt=db_prep("
				SELECT *
				FROM pilot p
				LEFT JOIN state s ON p.state_id=s.state_id
				LEFT JOIN country c ON p.country_id=c.country_id
				WHERE LOWER(p.pilot_first_name) LIKE :term1
					OR LOWER(p.pilot_last_name) LIKE :term2
					OR LOWER(CONCAT(p.pilot_first_name,' ',p.pilot_last_name)) LIKE :term3
			");
			$found_pilots=db_exec($stmt,array("term1"=>$first_name,"term2"=>$last_name,"term3"=>$q));
			$pilots[]=array("pilot_id"=>0,"pilot_full_name"=>'Add As New Pilot');
			foreach($found_pilots as $p){
				$p['pilot_full_name']=$p['pilot_first_name']." ".$p['pilot_last_name'];
				$pilots[]=$p;
			}
			$lines[$key]['pilots']=$pilots;
		}
	}

	$smarty->assign("event",$event);
	$smarty->assign("event_zero_round",$event_zero_round);
	$smarty->assign("lines",$lines);
	$smarty->assign("columns",$columns);

	$maintpl=find_template("event_import.tpl");
	return $smarty->fetch($maintpl);
}
function event_import_save() {
	global $smarty;

	$event_id=intval($_REQUEST['event_id']);
	$event=new Event($event_id);
	$event_zero_round=0;
	if(isset($_REQUEST['event_zero_round']) && ($_REQUEST['event_zero_round']=='on' || $_REQUEST['event_zero_round']==1)){
		$event_zero_round=1;
	}
	
	# Now this is where we do the save, creating the whole thing
	# lets first make the array of imported values
	$import=array();
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/pilot_original_(\d+)/",$key,$match)){
			$line=$match[1];
			$import[$line]['pilot_original']=$value;
		}
		if(preg_match("/pilot_id_(\d+)/",$key,$match)){
			$line=$match[1];
			$import[$line]['pilot_id']=$value;
		}
		if(preg_match("/round_(\d+)\_(\d+)/",$key,$match)){
			$line=$match[1];
			$round=$match[2];
			$import[$line]['rounds'][$round]=$value;
		}
	}

	$default_state_id=$event->info['state_id'];
	$default_country_id=$event->info['country_id'];
	
	# Now lets step through and create the pilots that don't exist and create the event pilot id's
	foreach($import as $line=>$i){
		if($i['pilot_id']==0){
			# Lets split it up into the first name and last name
			$words=preg_split("/\s+/",$i['pilot_original'],2);
			$first_name=$words[0];
			$last_name=$words[1];
			
			# Lets create this pilot
			$stmt=db_prep("
				INSERT INTO pilot
				SET user_id=0,
					pilot_first_name=:pilot_first_name,
					pilot_last_name=:pilot_last_name,
					state_id=:state_id,
					country_id=:country_id
			");
			$result=db_exec($stmt,array(
				"pilot_first_name"=>$first_name,
				"pilot_last_name"=>$last_name,
				"state_id"=>$default_state_id,
				"country_id"=>$default_country_id
			));
			$pilot_id=$GLOBALS['last_insert_id'];
			# replace the pilot_id in the main array
			$import[$line]['pilot_id']=$pilot_id;
			user_message("Created new pilot $first_name $last_name.");
		}else{
			$pilot_id=$i['pilot_id'];
		}
		# ok, now that we have the pilot id, lets add the pilots to the event
		# Lets see if one exists already so we don't create lots of new ones if we import it again
		$stmt=db_prep("
			SELECT *
			FROM event_pilot ep
			WHERE event_id=:event_id
				AND pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("event_id"=>$event_id,"pilot_id"=>$pilot_id));
		if($result[0]){
			$event_pilot_id=$result[0]['event_pilot_id'];
			# This one already exists
			if($result[0]['event_pilot_status']==0){
				# We need to update the status to turn them back on
				$stmt=db_prep("
					UPDATE event_pilot
					SET event_pilot_status=1
					WHERE event_pilot_id=:event_pilot_id
				");
				$result2=db_exec($stmt,array("event_pilot_id"=>$event_pilot_id));
			}
		}else{
			# There isn't one, so lets add it
			$stmt=db_prep("
				INSERT INTO event_pilot
				SET event_id=:event_id,
					pilot_id=:pilot_id,
					class_id=1,
					event_pilot_entry_order=:event_pilot_entry_order,
					event_pilot_status=1
			");
			$result2=db_exec($stmt,array(
				"event_id"=>$event_id,
				"pilot_id"=>$pilot_id,
				"event_pilot_entry_order"=>$line
			));
			$event_pilot_id=$GLOBALS['last_insert_id'];
		}
		
		# Add the event_pilot_id to the main array now
		$import[$line]['event_pilot_id']=$event_pilot_id;
	}	

	# Get default flight_type_id to use
	foreach($event->flight_types as $flight_type_id=>$ft){
		$flight_type_id=$ft['flight_type_id'];
		break;
	}

	# OK, now that we have all the pilots and event pilot ids, lets create the rounds and data
	foreach($import as $line=>$i){
		$event_pilot_id=$i['event_pilot_id'];
		foreach($i['rounds'] as $round_number=>$time){
			if($event_zero_round==1){
				$round_number-=1;
			}
			
			$dns=0;
			$dnf=0;
			if(strtolower($time)=='dns'){
				$dns=1;
				$time=0;
			}
			if(strtolower($time)=='dnf'){
				$dnf=1;
				$time=0;
			}
			
			# See if an event round exists
			$stmt=db_prep("
				SELECT *
				FROM event_round
				WHERE event_id=:event_id
					AND event_round_number=:event_round_number
			");
			$result=db_exec($stmt,array("event_id"=>$event_id,"event_round_number"=>$round_number));
			if(isset($result[0])){
				# This event round already exists
				$event_round_id=$result[0]['event_round_id'];
				$stmt=db_prep("
					UPDATE event_round
					SET event_round_needs_calc=1,
						event_round_status=1
					WHERE event_round_id=:event_round_id
				");
				$result2=db_exec($stmt,array(
					"event_round_id"=>$event_round_id
				));
			}else{
				# Create a new event round
				$stmt=db_prep("
					INSERT INTO event_round
					SET event_id=:event_id,
						event_round_needs_calc=1,
						event_round_number=:event_round_number,
						flight_type_id=:flight_type_id,
						event_round_score_status=1,
						event_round_status=1
				");
				$result2=db_exec($stmt,array(
					"event_id"=>$event_id,
					"event_round_number"=>$round_number,
					"flight_type_id"=>$flight_type_id
				));
				$event_round_id=$GLOBALS['last_insert_id'];
				
				# Lets also create a new event_round_flight that is set to on
				$stmt=db_prep("
					INSERT INTO event_round_flight
					SET event_round_id=:event_round_id,
						flight_type_id=:flight_type_id,
						event_round_flight_score=1
				");
				$result2=db_exec($stmt,array("event_round_id"=>$event_round_id,"flight_type_id"=>$flight_type_id));
			}
			
			# We need to get the event_pilot_round_id
			$stmt=db_prep("
			SELECT *
				FROM event_pilot_round epr
				WHERE epr.event_round_id=:event_round_id
					AND epr.event_pilot_id=:event_pilot_id
			");
			$result2=db_exec($stmt,array("event_round_id"=>$event_round_id,"event_pilot_id"=>$event_pilot_id));
			if(!isset($result2[0])){
				# Event pilot round doesn't exist, so lets create one
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
			
			# Now we need to see if a round flight already exists...sheesh
			$stmt=db_prep("
				SELECT *
				FROM event_pilot_round_flight
				WHERE event_pilot_round_id=:event_pilot_round_id
				AND flight_type_id=:flight_type_id
				AND event_pilot_round_flight_status=1
			");
			$result2=db_exec($stmt,array(
				"event_pilot_round_id"=>$event_pilot_round_id,
				"flight_type_id"=>$event_round_flight_type_id
			));
			if(isset($result2[0])){
				# This one already exists, so lets update it
				$stmt=db_prep("
					UPDATE event_pilot_round_flight
					SET event_pilot_round_flight_seconds=:value,
						event_pilot_round_flight_status=1
					WHERE event_pilot_round_flight_id=:event_pilot_round_flight_id
				");
				$result3=db_exec($stmt,array(
					"event_pilot_round_flight_id"=>$result2[0]['event_pilot_round_flight_id'],
					"value"=>$time
				));
			}else{
				$stmt=db_prep("
					INSERT INTO event_pilot_round_flight
					SET event_pilot_round_id=:event_pilot_round_id,
						flight_type_id=:flight_type_id,
						event_pilot_round_flight_seconds=:value,
						event_pilot_round_flight_dns=:dns,
						event_pilot_round_flight_dnf=:dnf,
						event_pilot_round_flight_status=1
				");
				$result2=db_exec($stmt,array(
					"event_pilot_round_id"=>$event_pilot_round_id,
					"flight_type_id"=>$flight_type_id,
					"value"=>$time,
					"dns"=>$dns,
					"dnf"=>$dnf
				));
			}
		}
	}
	$event->get_rounds();
	$event->calculate_event_totals();
	
	return event_view();
}


?>
