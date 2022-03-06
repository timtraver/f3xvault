<?php
############################################################################
#       event.php
#
#       Tim Traver
#       8/11/12
#       This is the script to show the main screen
#
############################################################################
global $smarty;
$smarty->assign("current_menu",'events');

include_library("event.class");

global $noside;
$noside = 1;

if(isset($_REQUEST['function']) && $_REQUEST['function'] != '') {
	$function = $_REQUEST['function'];
}else{
	$function = "event_list";
}

$need_login = array(
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
	"save_individual_flight",
	"event_tasks_add_round",
	"event_self_entry"
);
if(check_user_function($function)){
	if($GLOBALS['user_id'] == 0 && in_array($function, $need_login)){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to use this feature.",1);
		$smarty->assign("redirect_action",$_REQUEST['action']);
		$smarty->assign("redirect_function",$_REQUEST['function']);
		$smarty->assign("request",$_REQUEST);
		$maintpl = find_template("feature_requires_login.tpl");
		$actionoutput = $smarty->fetch($maintpl);
	}else{
		# Now check to see if they have permission to edit this event
		if(isset($_REQUEST['event_id']) && $_REQUEST['event_id'] != 0){
			
			if(!in_array($function, $need_login) || (in_array($function, $need_login) && check_event_permission($_REQUEST['event_id'])) || $function == 'event_self_entry' ){
				# They are allowed
				eval("\$actionoutput = $function();");
			}else{
				# They aren't allowed
				user_message("Sorry, but you do not have permission to edit this event. Please contact the event creator for access.",1);
				$actionoutput = event_view();
			}
		}else{
			eval("\$actionoutput = $function();");
		}
	}
}else{
	 $actionoutput =  show_no_permission();
}

function event_list() {
	global $smarty;
	global $export;

	$country_id = 0;
	$state_id = 0;
	$discipline_id = 0;
	if(isset($_REQUEST['country_id'])){
		$country_id = intval($_REQUEST['country_id']);
		$GLOBALS['fsession']['country_id'] = $country_id;
	}elseif(isset($GLOBALS['fsession']['country_id'])){
		$country_id = $GLOBALS['fsession']['country_id'];
	}
	if(isset($_REQUEST['state_id'])){
		$state_id = intval($_REQUEST['state_id']);
		$GLOBALS['fsession']['state_id'] = $state_id;
	}elseif(isset($GLOBALS['fsession']['state_id'])){
		$state_id = $GLOBALS['fsession']['state_id'];
	}
	if(isset($_REQUEST['discipline_id'])){
		$discipline_id = intval($_REQUEST['discipline_id']);
		$GLOBALS['fsession']['discipline_id'] = $discipline_id;
	}elseif(isset($GLOBALS['fsession']['discipline_id'])){
		$discipline_id = $GLOBALS['fsession']['discipline_id'];
	}

	$search = '';
	if(isset($_REQUEST['search']) ){
		$search = $_REQUEST['search'];
		$GLOBALS['fsession']['search'] = $_REQUEST['search'];
	}elseif(isset($GLOBALS['fsession']['search']) && $GLOBALS['fsession']['search'] != ''){
		$search = $GLOBALS['fsession']['search'];
	}
	
	$addcountry = '';
	if($country_id != 0){
		$addcountry .= " AND l.country_id = $country_id ";
	}
	$addstate = '';
	if($state_id != 0){
		$addstate .= " AND l.state_id = $state_id ";
	}

	# Add search options for discipline
	$disciplines = get_disciplines();
	$extrad = '';
	if($discipline_id != 0){
		# Lets determine the discipline code that was chosen
		foreach($disciplines as $d){
			if($d['discipline_id'] == $discipline_id){
				$discipline_code = $d['discipline_code'].'%';
			}
		}
		
		$extrad = 'AND et.event_type_code LIKE '."'$discipline_code'";
	}

	$events = array();
	if($search != '%%' && $search != ''){
		$stmt = db_prep("
			SELECT *
			FROM event e
			LEFT JOIN location l ON e.location_id = l.location_id
			LEFT JOIN state s ON l.state_id = s.state_id
			LEFT JOIN country c ON l.country_id = c.country_id
			LEFT JOIN event_type et ON e.event_type_id = et.event_type_id
			WHERE e.event_status = 1
				AND e.event_name LIKE :search
				$addcountry
				$addstate
				$extrad
			ORDER BY e.event_start_date DESC,l.country_id,l.state_id
		");
		$events = db_exec($stmt,array("search" => '%'.$search.'%'));
		
	}else{
		# Get all events for search
		$stmt = db_prep("
			SELECT *
			FROM event e
			LEFT JOIN location l ON e.location_id = l.location_id
			LEFT JOIN state s ON l.state_id = s.state_id
			LEFT JOIN country c ON l.country_id = c.country_id
			LEFT JOIN event_type et ON e.event_type_id = et.event_type_id
			WHERE e.event_status = 1
				$addcountry
				$addstate
				$extrad
			ORDER BY e.event_start_date DESC,l.country_id,l.state_id
		");
		$events = db_exec($stmt,array());
	}
	
	# Lets figure out if they are able to see this event based on the viewing prefs for the event
	$owns = array();
	$ispilot = array();
	if($GLOBALS['user_id'] != 0 && $GLOBALS['user']['user_admin'] != 1){
		# Lets get the events that this person owns and is a part of
		$stmt = db_prep("
			SELECT e.event_id
			FROM event e
			LEFT JOIN pilot p ON e.pilot_id = p.pilot_id
			WHERE p.user_id = :user_id
		");
		$result = db_exec($stmt,array("user_id" => $GLOBALS['user_id']));
		foreach($result as $r){
			$owns[] = $r['event_id'];
		}
		$stmt = db_prep("
			SELECT ep.event_id
			FROM event_pilot ep
			LEFT JOIN pilot p ON ep.pilot_id = p.pilot_id
			WHERE p.user_id = :user_id
		");
		$result = db_exec($stmt,array("user_id" => $GLOBALS['user_id']));
		foreach($result as $r){
			$ispilot[] = $r['event_id'];
		}
	}
	if($GLOBALS['user']['user_admin'] != 1){
		$newevents = array();
		foreach($events as $key => $e){
			switch($e['event_view_status']){
				case 1 :
					# Viewable by all
					$newevents[] = $e;
					break;
				case 2 : 
					# Viewable only by participants
					if(in_array($e['event_id'], $ispilot) || in_array($e['event_id'], $owns)){
						$newevents[] = $e;
					}
					break;
				case 3 : 
					# Viewable only by owner
					if(in_array($e['event_id'], $owns)){
						$newevents[] = $e;
					}
					break;
			}
		}
		$events = $newevents;
	}
	
	# Get only countries that we have events for
	$stmt = db_prep("
		SELECT DISTINCT c.*
		FROM event e
		LEFT JOIN location l ON e.location_id = l.location_id
		LEFT JOIN country c ON c.country_id = l.country_id
		WHERE c.country_id != 0
	");
	$countries = db_exec($stmt,array());
	# Get only states that we have events for
	$stmt = db_prep("
		SELECT DISTINCT s.*
		FROM event e
		LEFT JOIN location l ON e.location_id = l.location_id
		LEFT JOIN state s ON s.state_id = l.state_id
		WHERE s.state_id != 0
	");
	$states = db_exec($stmt,array());
	
	$events = show_pages($events,"action=event&function=event_list");

	# Lets get the number of pilots for this event
	foreach($events as $key => $e){
		$stmt = db_prep("
			SELECT count(ep.event_pilot_id) as pilot_count
			FROM event_pilot ep
			WHERE ep.event_id = :event_id
				AND ep.event_pilot_status = 1
		");
		$result = db_exec($stmt,array("event_id" => $e['event_id']));
		$events[$key]['pilot_count'] = $result[0]['pilot_count'];
	}

	# Lets set a flag to show if this event is happening now, or is in the future
	$now = time();
	foreach($events as $key => $e){
		$event_from = strtotime($e['event_start_date']);
		$event_to = strtotime($e['event_end_date'])+86359;
		if($event_from>$now){
			$events[$key]['time_status'] = 2;
		}elseif($event_from <$now && $event_to>$now){
			$events[$key]['time_status'] = 1;
		}elseif($now>$event_to && $now-$event_to<604800){
			$events[$key]['time_status'] = 0;
		}else{
			$events[$key]['time_status'] = -1;
		}
	}
	# Lets reset the discipline for the top bar if needed
	set_disipline($discipline_id);
	
	$smarty->assign("events",$events);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);
	$smarty->assign("disciplines",$disciplines);
	$smarty->assign("now",time());

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("search_field",$GLOBALS['fsession']['search_field']);
	$smarty->assign("search_operator",$GLOBALS['fsession']['search_operator']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl = find_template("event/event_list.tpl");
	return $smarty->fetch($maintpl);
}
function event_view() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	if($event_id == 0){
		user_message("That is not a proper event id to edit.");
		return event_list();
	}
		
	$e = new Event($event_id);
	$_REQUEST['sort_by'] = 'flight_order';
	$e->get_rounds();
	$e->get_draws();
	$e->calculate_event_totals();
	$e->get_running_totals();
	
	# Lets determine if we need a laps report and an average speed report
	$laps = 0;
	$speed = 0;
	$landing = 0;
	$duration = 0;
	$start_height = 0;
	$f3f_plus = 0;
	foreach($e->pilots as $p){
		if($p['event_pilot_total_laps'] != 0){
			$laps = 1;
		}
		if($p['event_pilot_average_speed'] != 0){
			$speed = 1;
		}
	}
	foreach($e->flight_types as $ft){
		if($ft['flight_type_landing'] == 1){
			$landing = 1;
		}
		if($ft['flight_type_start_height'] == 1){
			$start_height = 1;
		}
		if($ft['flight_type_code'] == 'f3b_duration'){
			$duration = 1;
		}
		if($ft['flight_type_code'] == 'f3f_speed' || $ft['flight_type_code'] == 'f3b_speed'){
			$speed = 1;
		}
		if($ft['flight_type_code'] == 'f3f_plus'){
			$speed = 1;
			$f3f_plus = 1;
		}
	}
	$lap_totals = array();
	$speed_averages = array();
	$speed_times = array();
	if($laps){
		# Lets sort the pilots by order of distance laps
		$lap_totals = $e->get_total_distance();
		$smarty->assign("lap_totals",$lap_totals);
		# Lets get the top distance list
		$distance_laps = $e->get_top_distance();
		$smarty->assign("distance_laps",$distance_laps);
		# Lets get the distance ranking
		$distance_rank = $e->get_distance_rank();
		$smarty->assign("distance_rank",$distance_rank);
	}
	if($speed){
		# Lets get the speed ranking
		$speed_rank = $e->get_speed_rank();
		$smarty->assign("speed_rank",$speed_rank);
		# Lets sort the pilots by order of speed average
		$speed_averages = array_msort($e->pilots,array("event_pilot_average_speed_rank" => SORT_ASC));
		$smarty->assign("speed_averages",$speed_averages);
		# Lets get the top speed list
		$speed_times = $e->get_top_speeds();
		$smarty->assign("speed_times",$speed_times);
	}
	if($landing){
		# Lets get the top landing accuracy list
		$top_landing = $e->get_top_landing();
		$smarty->assign("top_landing",$top_landing);
	}
	if($duration){
		# Lets get the duration rank
		$duration_rank = $e->get_duration_rank();
		$smarty->assign("duration_rank",$duration_rank);
	}
	if($start_height){
		# Lets get the start_height rank
		$start_height_rank = $e->get_top_start_height();
		$smarty->assign("start_height",$start_height_rank);
	}
	if($f3f_plus){
		# Lets get all of the cool stats about f3f plus runs
		$climbout_averages = $e->get_climbout_averages();
		$smarty->assign("climbout_averages",$climbout_averages);
		$first_lap_averages = $e->get_first_lap_averages();
		$smarty->assign("first_lap_averages",$first_lap_averages);
		$first_lap_speeds = $e->get_top_first_lap_speeds();
		$smarty->assign("first_lap_speeds",$first_lap_speeds);
		$e->get_wind_averages();
		$smarty->assign("graphs",array("graphs"));
	}
	# Lets figure out round wins or task wins
	$round_wins = array();
	$total_rounds = 0;
	foreach($e->rounds as $r){
		if($r['event_round_score_status'] == 1){
			foreach($r['flights'] as $f){
				if($f['event_round_flight_score'] == 0){
					continue;
				}
				foreach($f['pilots'] as $event_pilot_id => $p){
					if($p['event_pilot_round_flight_dropped'] == 1 || $p['event_pilot_round_flight_reflight_dropped'] == 1){
						continue;
					}
					if( $e->info['event_type_score_inverse'] == 1 ){
						if($p['event_pilot_round_flight_score'] == 1 ){
							$round_wins[$event_pilot_id]['wins']++;
						}
					}else{
						if($p['event_pilot_round_flight_score'] == 1000){
							$round_wins[$event_pilot_id]['wins']++;
						}
					}
					$round_wins[$event_pilot_id]['total_rounds']++;
				}
			}
			foreach($r['reflights'] as $flight_type_id => $f){
				if(count($f['pilots'])>0){
					if($f['event_round_flight_score'] == 0){
						continue;
					}
					foreach($f['pilots'] as $event_pilot_id => $p){
						if($p['event_pilot_round_flight_dropped'] == 1 || $p['event_pilot_round_flight_reflight_dropped'] == 1){
							continue;
						}
						if($p['event_pilot_round_flight_score'] == 1000){
							$round_wins[$event_pilot_id]['wins']++;
						}
						$round_wins[$event_pilot_id]['total_rounds']++;
					}
				}
			}
		}
	}
	$round_wins = array_msort($round_wins,array("wins" => SORT_DESC));
	$smarty->assign("round_wins",$round_wins);
	
	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	
	# Lets determine if the user is already registered as a pilot in this event
	$pilot_id = $GLOBALS['user']['pilot_id'];
	$registered = 0;
	foreach($e->pilots as $p){
		if($p['pilot_id'] == $pilot_id){
			$registered = 1;
		}
	}
	$smarty->assign("registered",$registered);

	log_action($event_id);
	
	# Save the current event id in the fsession for mobile ease of use
	$GLOBALS['fsession']['current_event_id'] = $event_id;
	
	# Lets see if there are active draws
	$active_draws = 0;
	foreach($e->draws as $d){
		if($d['event_draw_active'] == 1){
			$active_draws = 1;
		}
		$event_draw_id = $d['event_draw_id'];
	}
	$smarty->assign("active_draws",$active_draws);
	$total_prelim_rounds = 0;
	$total_flyoff_rounds = 0;
	foreach($e->rounds as $r){
		if($r['event_round_flyoff'] != 0){
			$total_flyoff_rounds++;
		}else{
			$total_prelim_rounds++;
		}
	}
	$tab = 0;
	if(count($e->rounds) <= 0){
		$tab = 2;
	}
	$smarty->assign("tab",$tab);

	# Lets set the draw rounds to be able to see them in the tab
	$e->get_active_draws_and_stats();

	$event_reg_past = 0;
	if($e->info['event_reg_status'] == 2 ){
		# The registration date is past due, so lets set that variable
		$regdatestamp = strtotime($e->info['event_reg_date']) + 86400;
		$nowstamp = time();
		if($nowstamp > $regdatestamp){
			$event_reg_past = 1;
		}
	}
	# Lets set whether or not there is a self scoring option
	$self_entry_param = $e->info['event_type_code']."_self_entry";
	$self_entry = $e->find_option_value($self_entry_param);
	$smarty->assign("self_entry",$self_entry);
	
	$smarty->assign("group_totals",$group_totals);
	$smarty->assign("event",$e);
	$smarty->assign("event_reg_past",$event_reg_past);
	$smarty->assign("draw_rounds",$e->draw_rounds);
	$smarty->assign("stats",$e->draw_rounds_stats);
	$smarty->assign("stat_totals",$e->draw_rounds_stats_totals);
	$smarty->assign("draw_info",$e->draw_rounds_stats_info);
	$smarty->assign("total_prelim_rounds",$total_prelim_rounds);
	$smarty->assign("total_flyoff_rounds",$total_flyoff_rounds);
	$maintpl = find_template("event/event_view.tpl");
	return $smarty->fetch($maintpl);
}
function event_edit() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$e = new Event($event_id);
	if($event_id == 0){
		if(isset($_REQUEST['location_name'])){
			$e->info['location_name'] = $_REQUEST['location_name'];
		}
		if(isset($_REQUEST['location_id'])){
			$e->info['location_id'] = $_REQUEST['location_id'];
		}
		if(isset($_REQUEST['event_name'])){
			$e->info['event_name'] = $_REQUEST['event_name'];
		}
		if(isset($_REQUEST['event_type_id'])){
			$e->info['event_type_id'] = $_REQUEST['event_type_id'];
		}
		if(isset($_REQUEST['event_cd'])){
			$e->info['event_cd'] = $_REQUEST['event_cd'];
		}
		if(isset($_REQUEST['event_cd_name'])){
			$e->info['event_cd_name'] = $_REQUEST['event_cd_name'];
		}
		if(isset($_REQUEST['club_id'])){
			$e->info['club_id'] = $_REQUEST['club_id'];
		}
		if(isset($_REQUEST['club_name'])){
			$e->info['club_name'] = $_REQUEST['club_name'];
		}
		if(isset($_REQUEST['event_start_dateMonth'])){
			$starttime = strtotime($_REQUEST['event_start_dateMonth'].'/'.$_REQUEST['event_start_dateDay'].'/'.$_REQUEST['event_start_dateYear']);
		}else{
			$starttime = time();
		}
		if(isset($_REQUEST['event_end_dateMonth'])){
			$endtime = strtotime($_REQUEST['event_end_dateMonth'].'/'.$_REQUEST['event_end_dateDay'].'/'.$_REQUEST['event_end_dateYear']);
		}else{
			$endtime = time();
		}
		$e->info['event_start_date'] = $starttime;
		$e->info['event_end_date'] = $endtime;
		if(isset($_REQUEST['event_reg_flag'])){
			$e->info['event_reg_flag'] = $_REQUEST['event_reg_flag'];
		}
		if(isset($_REQUEST['event_notes'])){
			$e->info['event_notes'] = $_REQUEST['event_notes'];
		}
	}else{
		# Lets only replace the id's of the things that could have been added new
		if(isset($_REQUEST['location_name'])){
			$e->info['location_name'] = $_REQUEST['location_name'];
		}
		if(isset($_REQUEST['location_id'])){
			$e->info['location_id'] = $_REQUEST['location_id'];
		}
		if(isset($_REQUEST['club_id'])){
			$e->info['club_id'] = $_REQUEST['club_id'];
		}
		if(isset($_REQUEST['club_name'])){
			$e->info['club_name'] = $_REQUEST['club_name'];
		}
		if(isset($_REQUEST['event_cd'])){
			$e->info['event_cd'] = $_REQUEST['event_cd'];
		}
		if(isset($_REQUEST['event_cd_name'])){
			$e->info['event_cd_name'] = $_REQUEST['event_cd_name'];
		}
	}
	$tab = $_REQUEST['tab'];
	
	# Get all event types
	$stmt = db_prep("
		SELECT *
		FROM event_type
		ORDER BY event_type_code
	");
	$event_types = db_exec($stmt,array());

	# Now lets get the users that have additional access
	$stmt = db_prep("
		SELECT *
		FROM event_user eu
		LEFT JOIN pilot p ON eu.pilot_id = p.pilot_id
		LEFT JOIN state s ON p.state_id = s.state_id
		LEFT JOIN country c ON p.country_id = c.country_id
		WHERE eu.event_id = :event_id
			AND eu.event_user_status = 1
	");
	$result = db_exec($stmt,array("event_id" => $event_id));
	# Lets first add the current user, which is the owner
	$event_users[] = array(
		"user_id" => $GLOBALS['user']['user_id'],
		"pilot_first_name" => $GLOBALS['user']['pilot_first_name'],
		"pilot_last_name" => $GLOBALS['user']['pilot_last_name'],
		"pilot_city" => $GLOBALS['user']['pilot_city'],
		"state_code" => $GLOBALS['user']['state_code'],
		"country_code" => $GLOBALS['user']['country_code']
	);
	# Now lets add the CD, cause he has access too
	$event_users[] = array(
		"user_id" => $e->info['event_cd'],
		"pilot_first_name" => $e->info['pilot_first_name'],
		"pilot_last_name" => $e->info['pilot_last_name'],
		"pilot_city" => $e->info['pilot_city'],
		"state_code" => $e->info['state_code'],
		"country_code" => $e->info['country_code']
	);
	$event_users = array_merge($event_users,$result);
	$smarty->assign("event_users",$event_users);
	
	# Get classes to choose to be available for this event
	$stmt = db_prep("
		SELECT *,c.class_id
		FROM class c
		LEFT JOIN event_class ec ON c.class_id = ec.class_id AND ec.event_id = :event_id
		ORDER BY c.class_view_order
	");
	$classes = db_exec($stmt,array("event_id" => $event_id));
	$smarty->assign("classes",$classes);
	
	$smarty->assign("event_types",$event_types);
	$smarty->assign("event",$e);
	$smarty->assign("tab",$tab);

	$maintpl = find_template("event/event_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_save() {
	global $smarty;
	global $user;

	$country_id = intval($_REQUEST['country_id']);
	$state_id = intval($_REQUEST['state_id']);
	$location_id = intval($_REQUEST['location_id']);
	$event_name = $_REQUEST['event_name'];
	$event_id = intval($_REQUEST['event_id']);
	# Get the dates
	$event_start_date = $_REQUEST['event_start_dateYear']."-".$_REQUEST['event_start_dateMonth']."-".$_REQUEST['event_start_dateDay'];
	$event_end_date = $_REQUEST['event_end_dateYear']."-".$_REQUEST['event_end_dateMonth']."-".$_REQUEST['event_end_dateDay'];
	$event_type_id = intval($_REQUEST['event_type_id']);
	$event_cd = intval($_REQUEST['event_cd']);
	$club_id = intval($_REQUEST['club_id']);
	$event_view_status = intval($_REQUEST['event_view_status']);
	$event_reg_flag = intval($_REQUEST['event_reg_flag']);
	$event_notes = $_REQUEST['event_notes'];
	$tab = $_REQUEST['tab'];

	# Get the checkboxes for each class type
	$classes = array();
	foreach($_REQUEST as $key => $value){
		if(preg_match("/class\_(\d+)$/",$key,$match)){
			$id = $match[1];
			$classes[$id] = 1;
		}
	}

	if($event_id == 0){
		$stmt = db_prep("
			INSERT INTO event
			SET pilot_id = :pilot_id,
				event_name = :event_name,
				location_id = :location_id,
				event_start_date = :event_start_date,
				event_end_date = :event_end_date,
				event_type_id = :event_type_id,
				event_cd = :event_cd,
				club_id = :club_id,
				event_view_status = :event_view_status,
				event_reg_flag = :event_reg_flag,
				event_notes = :event_notes,
				event_status = 1
		");
		$result = db_exec($stmt,array(
			"pilot_id" => $user['pilot_id'],
			"event_name" => $event_name,
			"location_id" => $location_id,
			"event_start_date" => $event_start_date,
			"event_end_date" => $event_end_date,
			"event_type_id" => $event_type_id,
			"event_cd" => $event_cd,
			"club_id" => $club_id,
			"event_view_status" => $event_view_status,
			"event_reg_flag" => $event_reg_flag,
			"event_notes" => $event_notes
		));

		user_message("Added your New Event!");
		$_REQUEST['event_id'] = $GLOBALS['last_insert_id'];
		$event_id = $GLOBALS['last_insert_id'];
		# Now lets add the default event settings
		# Lets get each event type option and insert default values
		$stmt = db_prep("
			SELECT *
			FROM event_type_option
			WHERE event_type_id = :event_type_id
		");
		$options = db_exec($stmt,array("event_type_id" => $event_type_id));
		foreach($options as $o){
			# Insert default value
			$stmt = db_prep("
				INSERT INTO event_option
				SET event_id = :event_id,
					event_type_option_id = :event_type_option_id,
					event_option_value = :event_option_value,
					event_option_status = 1
			");
			$result2 = db_exec($stmt,array(
				"event_id" => $_REQUEST['event_id'],
				"event_type_option_id" => $o['event_type_option_id'],
				"event_option_value" => $o['event_type_option_default']
			));
		}
	}else{
		# Save the database record for this event
		$stmt = db_prep("
			UPDATE event
			SET event_name = :event_name,
				location_id = :location_id,
				event_start_date = :event_start_date,
				event_end_date = :event_end_date,
				event_type_id = :event_type_id,
				event_cd = :event_cd,
				club_id = :club_id,
				event_view_status = :event_view_status,
				event_reg_flag = :event_reg_flag,
				event_notes = :event_notes
			WHERE event_id = :event_id
		");
		$result = db_exec($stmt,array(
			"event_name" => $event_name,
			"location_id" => $location_id,
			"event_start_date" => $event_start_date,
			"event_end_date" => $event_end_date,
			"event_type_id" => $event_type_id,
			"event_cd" => $event_cd,
			"club_id" => $club_id,
			"event_view_status" => $event_view_status,
			"event_reg_flag" => $event_reg_flag,
			"event_notes" => $event_notes,
			"event_id" => $event_id
		));
		user_message("Updated Base Event Info!");
		# Lets save the totals in case some drops were changed or something
		$e = new Event($event_id);
		$e->get_rounds();
		$e->event_save_totals();
	}
	
	# If there were class choices, lets save them
	$stmt = db_prep("
		UPDATE event_class
		SET event_class_status = 0
		WHERE event_id = :event_id
	");
	$result = db_exec($stmt,array(
		"event_id" => $event_id
	));
	if($classes){
		foreach($classes as $id => $value){
			$stmt = db_prep("
				SELECT *
				FROM event_class
				WHERE event_id = :event_id
					AND class_id = :class_id
			");
			$result = db_exec($stmt,array(
				"event_id" => $event_id,
				"class_id" => $id
			));
			if(isset($result[0])){
				# This one already exists, so just turn it on
				$stmt = db_prep("
					UPDATE event_class
					SET event_class_status = 1
					WHERE event_class_id = :event_class_id
				");
				$result = db_exec($stmt,array(
					"event_class_id" => $result[0]['event_class_id']
				));
			}else{
				# We need to create a new one
				$stmt = db_prep("
					INSERT INTO event_class
					SET event_id = :event_id,
						class_id = :class_id,
						event_class_status = 1
				");
				$result = db_exec($stmt,array(
					"event_id" => $event_id,
					"class_id" => $id
				));
			}
		}
	}
	
	log_action($event_id);
	return event_edit();
}
function event_delete() {
	global $smarty;
	global $user;

	$event_id = intval($_REQUEST['event_id']);
	# Lets check to make sure that its the owner that is deleting it
	$e = new Event($event_id);
	if($user['user_id'] != $e->info['user_id'] && $user['user_admin'] != 1){
		# This is not the owner, so don't delete it...
		user_message("Sorry, but only the owner of the event can delete it.",1);
		return event_list();
	}
	# Save the database record for this event to delete it
	$stmt = db_prep("
		UPDATE event
		SET event_status = 0
		WHERE event_id = :event_id
	");
	$result = db_exec($stmt,array(
		"event_id" => $event_id
	));
	user_message("Removed Event!");

	log_action($event_id);
	return event_list();
}
function event_series_save() {
	global $smarty;
	global $user;

	$event_id = intval($_REQUEST['event_id']);
	$series_id = intval($_REQUEST['series_id']);
	
	if($series_id){
		# Look for a series record
		$stmt = db_prep("
			SELECT *
			FROM event_series
			WHERE event_id = :event_id
				AND series_id = :series_id
		");
		$result = db_exec($stmt,array(
			"event_id"	=> $event_id,
			"series_id"	=> $series_id
		));
		if(isset($result[0])){
			# Event series record exists, so lets update it
			$event_series_id = $result[0]['event_series_id'];
			$stmt = db_prep("
				UPDATE event_series
				SET event_series_status = 1
				WHERE event_series_id = :event_series_id
			");
			$result = db_exec($stmt,array(
				"event_series_id" => $event_series_id
			));
		}else{
			$stmt = db_prep("
				INSERT INTO event_series
				SET event_id = :event_id,
					series_id = :series_id,
					event_series_multiple = 1,
					event_series_status = 1
			");
			$result = db_exec($stmt,array(
				"event_id"	=> $event_id,
				"series_id"	=> $series_id
			));
		}
		user_message("Event Series Added.");
	}
	log_action($event_id);
	return event_edit();
}
function event_series_delete() {
	global $smarty;
	global $user;

	$event_id = intval($_REQUEST['event_id']);
	$event_series_id = intval($_REQUEST['event_series_id']);
	
	if($event_series_id){
		# Turn off the event series record
		$stmt = db_prep("
			UPDATE event_series
			SET event_series_status = 0
			WHERE event_series_id = :event_series_id
		");
		$result = db_exec($stmt,array(
			"event_series_id" => $event_series_id
		));
		user_message("Event Series Removed.");
	}
	log_action($event_id);
	return event_edit();
}

# Registration Routines
function event_reg_edit() {
	global $smarty;

	# Run this through the save routine first
	$save_first = intval($_REQUEST['save_first']);
	if($save_first){
		event_save();
	}
	
	$event_id = intval($_REQUEST['event_id']);
	$e = new Event($event_id);

	# make the time stamps be for the time zone
	$e->info['event_reg_open_date_stamp'] = date_stamp_add_offset( $e->info['event_reg_open_date_stamp'], $e->info['event_reg_open_tz']);
	$e->info['event_reg_close_date_stamp'] = date_stamp_add_offset( $e->info['event_reg_close_date_stamp'], $e->info['event_reg_close_tz']);
	
	$smarty->assign("event",$e);
	$smarty->assign("currencies",get_currencies());
	$maintpl = find_template("event/event_reg_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_reg_save() {
	# Save the registration parameters
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$e = new Event($event_id);
	$event_reg_status = intval($_REQUEST['event_reg_status']);
	$event_reg_max = intval($_REQUEST['event_reg_max']);
	$event_reg_pay_flag = 0;
	if(isset($_REQUEST['event_reg_pay_flag']) && $_REQUEST['event_reg_pay_flag'] == 'on'){
		$event_reg_pay_flag = 1;
	}
	$event_reg_close_on = 0;
	if(isset($_REQUEST['event_reg_close_on']) && $_REQUEST['event_reg_close_on'] == 'on'){
		$event_reg_close_on = 1;
	}
	$currency_id = $_REQUEST['currency_id'];
	$event_reg_paypal_address = $_REQUEST['event_reg_paypal_address'];
	$event_reg_add_name = $_REQUEST['event_reg_add_name'];
	
	# Get the entered dates
	$event_reg_open_date_string = $_REQUEST['event_reg_open_dateYear']."-".$_REQUEST['event_reg_open_dateMonth']."-".$_REQUEST['event_reg_open_dateDay']." ".$_REQUEST['event_reg_open_dateHour'].":".$_REQUEST['event_reg_open_dateMinute']." ".$_REQUEST['event_reg_open_dateMeridian'];
	$event_reg_close_date_string = $_REQUEST['event_reg_close_dateYear']."-".$_REQUEST['event_reg_close_dateMonth']."-".$_REQUEST['event_reg_close_dateDay']." ".$_REQUEST['event_reg_close_dateHour'].":".$_REQUEST['event_reg_close_dateMinute']." ".$_REQUEST['event_reg_close_dateMeridian'];
	$event_reg_open_tz = $_REQUEST['event_reg_open_tz'];
	$event_reg_close_tz = $_REQUEST['event_reg_close_tz'];
	
	$dateTime = new DateTime(); 
	$dateTime->setTimeZone(new DateTimeZone($event_reg_open_tz));
	$open_tz_abbr = $dateTime->format('T');
	$dateTime->setTimeZone(new DateTimeZone($event_reg_close_tz));
	$close_tz_abbr = $dateTime->format('T');

	$open_date_stamp = strtotime($event_reg_open_date_string." ".$open_tz_abbr);
	$close_date_stamp = strtotime($event_reg_close_date_string." ".$close_tz_abbr);
	
	$event_reg_teams = 0;
	if( isset( $_REQUEST['event_reg_teams'] ) && $_REQUEST['event_reg_teams'] == 'on' ){
		$event_reg_teams = 1;
	}
	$event_reg_waitlist = 0;
	if( isset( $_REQUEST['event_reg_waitlist'] ) && $_REQUEST['event_reg_waitlist'] == 'on' ){
		$event_reg_waitlist = 1;
	}

	# Now lets get the existing additional values
	$params = array();
	foreach($_REQUEST as $key => $value){
		if(preg_match("/reg\_param\_(\d+)\_(\S+)$/",$key,$match)){
			$reg_id = $match[1];
			$reg_type = $match[2];
			$params[$reg_id][$reg_type] = $value;
		}
	}

	# OK, lets save the main reg parameters
	$stmt = db_prep("
		UPDATE event
		SET event_reg_status = :event_reg_status,
			event_reg_open_date_stamp = :event_reg_open_date_stamp,
			event_reg_open_tz = :event_reg_open_tz,
			event_reg_close_on = :event_reg_close_on,
			event_reg_close_date_stamp = :event_reg_close_date_stamp,
			event_reg_close_tz = :event_reg_close_tz,
			event_reg_max = :event_reg_max,
			event_reg_pay_flag = :event_reg_pay_flag,
			currency_id = :currency_id,
			event_reg_paypal_address = :event_reg_paypal_address,
			event_reg_teams = :event_reg_teams,
			event_reg_waitlist = :event_reg_waitlist
		WHERE event_id = :event_id
	");
	$result = db_exec($stmt,array(
		"event_reg_status"				=> $event_reg_status,
		"event_reg_open_date_stamp"		=> $open_date_stamp,
		"event_reg_open_tz"				=> $event_reg_open_tz,
		"event_reg_close_on"			=> $event_reg_close_on,
		"event_reg_close_date_stamp"	=> $close_date_stamp,
		"event_reg_close_tz"			=> $event_reg_close_tz,
		"event_reg_max"					=> $event_reg_max,
		"event_reg_pay_flag"			=> $event_reg_pay_flag,
		"currency_id"					=> $currency_id,
		"event_reg_paypal_address"		=> $event_reg_paypal_address,
		"event_reg_teams"				=> $event_reg_teams,
		"event_reg_waitlist"			=> $event_reg_waitlist,
		"event_id"						=> $event_id
	));
	
	# Now lets save each of the reg values
	foreach($params as $event_reg_param_id => $p){
		if(!isset($p['qty'])){
			$p['qty'] = 0;
		}else{
			$p['qty'] = 1;
		}
		if(!isset($p['man'])){
			$p['man'] = 0;
		}else{
			$p['man'] = 1;
		}
		$stmt = db_prep("
			UPDATE event_reg_param
			SET event_reg_param_name = :event_reg_param_name,
				event_reg_param_description = :event_reg_param_description,
				event_reg_param_qty_flag = :event_reg_param_qty_flag,
				event_reg_param_cost = :event_reg_param_cost,
				event_reg_param_mandatory = :event_reg_param_mandatory,
				event_reg_param_choice_name = :event_reg_param_choice_name,
				event_reg_param_choice_values = :event_reg_param_choice_values
			WHERE event_reg_param_id = :event_reg_param_id
		");
		$result = db_exec($stmt,array(
			"event_reg_param_name"			=> $p['name'],
			"event_reg_param_description"	=> $p['desc'],
			"event_reg_param_qty_flag"		=> $p['qty'],
			"event_reg_param_cost"			=> $p['cost'],
			"event_reg_param_mandatory"		=> $p['man'],
			"event_reg_param_choice_name"	=> $p['choice_name'],
			"event_reg_param_choice_values"	=> $p['choice_values'],
			"event_reg_param_id"			=> $event_reg_param_id
		));
	}
	user_message("Event Registration Parameters saved.");
	# Lets create a new one if they added one
	if($event_reg_add_name != '0'){
		# Add a new one
		$stmt = db_prep("
			INSERT INTO event_reg_param
			SET event_id = :event_id,
				event_reg_param_name = :event_reg_param_name,
				event_reg_param_status = 1
		");
		$result = db_exec($stmt,array(
			"event_id"				=> $event_id,
			"event_reg_param_name"	=> $event_reg_add_name
		));
		user_message("Event Registration Parameter added.");
	}
	return event_reg_edit();
}
function event_reg_del() {
	# Save the registration parameters
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$e = new Event($event_id);
	$event_reg_param_id = intval($_REQUEST['event_reg_param_id']);

	# OK, lets save the main reg parameters
	$stmt = db_prep("
		UPDATE event_reg_param
		SET event_reg_param_status = 0
		WHERE event_reg_param_id = :event_reg_param_id
	");
	$result = db_exec($stmt,array(
		"event_reg_param_id" => $event_reg_param_id
	));
	user_message("Deleted Registration Value.");
	return event_reg_edit();
}
function event_view_info() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$e = new Event($event_id);
	
	$smarty->assign("event",$e);

	# Lets get CD info
	$stmt = db_prep("
		SELECT *
		FROM pilot p
		LEFT JOIN country c ON p.country_id = c.country_id
		LEFT JOIN state s ON p.state_id = s.state_id
		WHERE p.pilot_id = :pilot_id
	");
	$result = db_exec($stmt,array("pilot_id" => $e->info['event_cd']));
	$cd = $result[0];
	$smarty->assign("cd",$cd);
	
	$maintpl = find_template("event/event_view_info.tpl");
	return $smarty->fetch($maintpl);
}
function event_register() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);
	$go_to_paypal = $_REQUEST['go_to_paypal'];
	$e = new Event($event_id);
	$e->get_teams();
	$smarty->assign("event",$e);
	
	# let us check if they are logged in, and if not, send them to the login screen

	if( ! isset( $GLOBALS['fsession']['auth'] ) ){
		# They are not logged in
		user_message("You must first log into the system in order to register for an event.");
		# Now let us redirect them to the login page
		$smarty->assign('redirect_action','event');
		$smarty->assign('redirect_function','event_register');
		$smarty->assign('current_menu','login');
		$smarty->assign('request', $_REQUEST);
	
		$maintpl = find_template("login.tpl");
		return $smarty->fetch($maintpl);
	}

	# Lets check to see if they are already registered
	foreach($e->pilots as $p){
		if($p['pilot_id'] == $GLOBALS['user']['pilot_id']){
			user_message("You are Registered for this event! You can update your registration parameters here.");
			$event_pilot_id = $p['event_pilot_id'];
			break;
		}
	}
	# Lets check to see if the event has a max and its been reached
	if( $e->info['event_reg_status'] > 0 && $event_pilot_id == 0 ){
		$max = $e->info['event_reg_max'];
		if(count($e->pilots) >= $max && $max != 0){
			user_message("Registration for this event has reached a maximum of $max pilots. You cannot register for this event at this time.",1);
			return event_view();
		}
	}
	
	# Let's see if the registration window is open and refuse if it is not
	if( $e->info['event_reg_status'] == 2 ){
		$now = time();
		if( $now < $e->info['event_reg_open_date_stamp'] ){
				user_message("Registration for this event is not open yet. You cannot register for this event at this time.", 1 );
				return event_view();
		}
		if( $e->info['event_reg_close_on'] && $now > $e->info['event_reg_close_date_stamp'] ){
				user_message("Registration for this event is now closed. You cannot register for this event at this time.", 1 );
				return event_view();
		}
	}

	# Get classes to choose to be available for this event
	$stmt = db_prep("
		SELECT *,c.class_id
		FROM event_class ec
		LEFT JOIN class c ON ec.class_id = c.class_id
		WHERE ec.event_id = :event_id
		ORDER BY c.class_view_order
	");
	$classes = db_exec($stmt,array("event_id" => $event_id));
	$smarty->assign("classes",$classes);
	
	$smarty->assign("teams",$e->teams);
	
	$event_pilot = array();
	if($event_pilot_id != 0){
		$stmt = db_prep("
			SELECT *
			FROM event_pilot ep
			LEFT JOIN plane p ON ep.plane_id = p.plane_id
			WHERE event_pilot_id = :event_pilot_id
		");
		$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
		$event_pilot = $result[0];
	}else{
		$event_pilot['event_pilot_freq'] = '2.4GHz';
	}
	$smarty->assign("event_pilot",$event_pilot);
		
	$params = array();
	if($event_pilot_id != 0){
		# Lets get their reg params
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_reg epr
			LEFT JOIN event_reg_param erp ON epr.event_reg_param_id = erp.event_reg_param_id
			WHERE epr.event_pilot_id = :event_pilot_id
				AND epr.event_pilot_reg_status = 1
		");
		$result = db_exec($stmt,array(
			"event_pilot_id" => $event_pilot_id
		));
		foreach($result as $r){
			$id = $r['event_reg_param_id'];
			if($r['event_pilot_reg_choice_value'] != ''){
				$values = array();
				$values = explode(',',$r['event_pilot_reg_choice_value']);
				$r['event_pilot_reg_choice_values'] = $values;
			}
			$params[$id] = $r;
		}
	}
	$smarty->assign("params",$params);
	# Lets see if there are any sizes and set a flag so we can change the view
	$has_sizes = 0;
	foreach($e->reg_options as $p){
		if($p['event_reg_param_choice_name'] != ''){
			$has_sizes = 1;
		}
	}
	$smarty->assign("has_sizes",$has_sizes);
	
	# Get any previous payments they have made
	$payments = array();
	$stmt = db_prep("
		SELECT *
		FROM event_pilot_payment epp
		WHERE epp.event_pilot_id = :event_pilot_id
			AND epp.event_pilot_payment_status = 1
		ORDER BY epp.event_pilot_payment_date
	");
	$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
	foreach($result as $row){
		$payments[] = $row;
	}
	$smarty->assign("payments",$payments);
	
	$balance = calculate_amount_owed($event_pilot_id);
	if($go_to_paypal == 1){
		if($balance > 0){
			# They must have saved it and are trying to pay with paypal, so send the paypal info
			$smarty->assign("total",$balance);
			$smarty->assign("go_to_paypal",$go_to_paypal);
		}else{
			user_message("You don't have a balance to pay!",1);
		}
	}
	
	$maintpl = find_template("event/event_register.tpl");
	return $smarty->fetch($maintpl);
}
function event_register_save() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);
	$pilot_ama = $_REQUEST['pilot_ama'];
	$pilot_fai = $_REQUEST['pilot_fai'];
	$pilot_fai_license = $_REQUEST['pilot_fai_license'];
	$class_id = intval($_REQUEST['class_id']);
	$event_pilot_freq = $_REQUEST['event_pilot_freq'];
	$event_pilot_team = isset( $_REQUEST['event_pilot_team'] ) ? $_REQUEST['event_pilot_team'] : '' ;
	$plane_id = intval($_REQUEST['plane_id']);
	$event_pilot_reg_note = $_REQUEST['event_pilot_reg_note'];
	$existing = 0;
	
	# Now lets get the existing additional values
	$params = array();
	foreach($_REQUEST as $key => $value){
		if(preg_match("/reg\_param\_(\d+)\_(\S+)$/",$key,$match)){
			$reg_id = $match[1];
			$reg_type = $match[2];
			if(preg_match("/^(\S+)\_(\d*)/",$reg_type,$match2)){
				$reg_type = $match2[1];
				$params[$reg_id][$reg_type] = $params[$reg_id][$reg_type].",".$value;
				# Lets get rid of the first comma if necessary
				$params[$reg_id][$reg_type] = preg_replace("/^\,/",'',$params[$reg_id][$reg_type]);
			}else{
				$params[$reg_id][$reg_type] = $value;
			}
		}
	}
	if($event_pilot_id != 0){
		# Lets save this existing event pilot registration
		$stmt = db_prep("
			UPDATE event_pilot
			SET class_id = :class_id,
				event_pilot_freq = :event_pilot_freq,
				event_pilot_team = :event_pilot_team,
				plane_id = :plane_id,
				event_pilot_reg_note = :event_pilot_reg_note
				WHERE event_pilot_id = :event_pilot_id
		");
		$result = db_exec($stmt,array(
			"class_id"				=> $class_id,
			"event_pilot_freq"		=> $event_pilot_freq,
			"event_pilot_team"		=> $event_pilot_team,
			"event_pilot_id"		=> $event_pilot_id,
			"plane_id"				=> $plane_id,
			"event_pilot_reg_note"	=> $event_pilot_reg_note
		));
		user_message("Registration info updated.");
		$existing = 1;
	}else{
		# Lets check to see if the pilot is logged in first
		if(!isset($GLOBALS['user']['pilot_id']) || $GLOBALS['user']['pilot_id'] == 0){
			user_message("You must be logged in to register for an event.",1);
			return event_view();
		}
		
		# If its a new pilot, lets set the entry order

		# Lets check to see if the event has a max and its been reached
		$e = new Event($event_id);
		if($e->info['event_reg_status'] == 1 && $event_pilot_id == 0){
			$max = $e->info['event_reg_max'];
			if(count($e->pilots) >= $max && $max != 0){
				user_message("Registration for this event has reached a maximum of $max pilots. You cannot register for this event at this time.",1);
				return event_view();
			}
		}
		
		# Lets see what the next increment in the order is
		$stmt = db_prep("
			SELECT MAX(event_pilot_entry_order) as max
			FROM event_pilot
			WHERE event_id = :event_id
			AND event_pilot_status = 1
		");
		$result = db_exec($stmt,array("event_id" => $event_id));
		if($result[0]['max'] == 'NULL' || $result[0]['max'] == 0){
			$event_pilot_entry_order = 1;
		}else{
			$event_pilot_entry_order = $result[0]['max']+1;
		}
		$event_pilot_bib = $event_pilot_entry_order;

		# We need to create a new event pilot id
		$stmt = db_prep("
			INSERT INTO event_pilot
			SET event_id = :event_id,
				pilot_id = :pilot_id,
				event_pilot_entry_order = :event_pilot_entry_order,
				event_pilot_bib = :event_pilot_bib,
				class_id = :class_id,
				event_pilot_freq = :event_pilot_freq,
				event_pilot_team = :event_pilot_team,
				plane_id = :plane_id,
				event_pilot_reg_note = :event_pilot_reg_note,
				event_pilot_draw_status = 1,
				event_pilot_status = 1
		");
		$result2 = db_exec($stmt,array(
			"event_id"					=> $event_id,
			"pilot_id"					=> $GLOBALS['user']['pilot_id'],
			"class_id"					=> $class_id,
			"event_pilot_entry_order"	=> $event_pilot_entry_order,
			"event_pilot_bib"			=> $event_pilot_bib,
			"event_pilot_freq"			=> $event_pilot_freq,
			"event_pilot_team"			=> $event_pilot_team,
			"plane_id"					=> $plane_id,
			"event_pilot_reg_note"		=> $event_pilot_reg_note
		));
		$event_pilot_id = $GLOBALS['last_insert_id'];
		user_message("You Have Successfully Registered for this event!");
	}
	
	# Lets update the pilot registration parameters now
	# Lets first wipe all of the parameters clean because there are possible checkboxes
	$stmt = db_prep("
		UPDATE event_pilot_reg
		SET event_pilot_reg_status = 0
		WHERE event_pilot_id = :event_pilot_id
	");
	$result = db_exec($stmt,array(
		"event_pilot_id" => $event_pilot_id
	));
	foreach($params as $reg_id => $r){
		$qty = $r['qty'];
		if($qty == 'on'){
			$qty = 1;
		}
		# Lets see if one exists with this reg type then
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_reg
			WHERE event_pilot_id = :event_pilot_id
				AND event_reg_param_id = :event_reg_param_id
		");
		$result = db_exec($stmt,array(
			"event_pilot_id"		=> $event_pilot_id,
			"event_reg_param_id"	=> $reg_id
		));
		if(isset($result[0])){
			# One already exists, so update it
			$stmt = db_prep("
				UPDATE event_pilot_reg
				SET event_pilot_reg_status = 1,
					event_pilot_reg_qty = :qty,
					event_pilot_reg_choice_value = :choice_value
				WHERE event_pilot_reg_id = :event_pilot_reg_id
			");
			$result = db_exec($stmt,array(
				"qty"					=> $qty,
				"choice_value"			=> $r['choice_value'],
				"event_pilot_reg_id"	=> $result[0]['event_pilot_reg_id']
			));
		}else{
			# Need to create a new one
			$stmt = db_prep("
				INSERT INTO event_pilot_reg
				SET event_pilot_id = :event_pilot_id,
					event_reg_param_id = :reg_id,
					event_pilot_reg_qty = :qty,
					event_pilot_reg_choice_value = :choice_value,
					event_pilot_reg_status = 1
			");
			$result = db_exec($stmt,array(
				"event_pilot_id"	=> $event_pilot_id,
				"reg_id"			=> $reg_id,
				"qty"				=> $qty,
				"choice_value"		=> $r['choice_value']
			));
		}
	}
	
	# Lets see if we need to update the pilot's ama or fai number
	if($pilot_ama != $GLOBALS['user']['pilot_ama'] || $pilot_fai != $GLOBALS['user']['pilot_fai'] || $pilot_fai_license != $GLOBALS['user']['pilot_fai_license']){
		# lets update the pilot record
		$stmt = db_prep("
			UPDATE pilot
			SET pilot_ama = :pilot_ama,
				pilot_fai = :pilot_fai,
				pilot_fai_license = :pilot_fai_license
				WHERE pilot_id = :pilot_id
		");
		$result = db_exec($stmt,array(
			"pilot_ama" => $pilot_ama,
			"pilot_fai" => $pilot_fai,
			"pilot_fai_license" => $pilot_fai_license,
			"pilot_id" => $GLOBALS['user']['pilot_id']
		));
	}
	
	# Lets see if this pilot has a plane in his my planes area already
	if($plane_id != 0){
		$stmt = db_prep("
			SELECT *
			FROM pilot_plane
			WHERE pilot_id = :pilot_id
			AND plane_id = :plane_id
		");
		$result = db_exec($stmt,array("pilot_id" => $GLOBALS['user']['pilot_id'],"plane_id" => $plane_id));
		if(!isset($result[0])){
			# Doesn't have one of these planes in their quiver, so lets put one in
			$stmt = db_prep("
				INSERT INTO pilot_plane
				SET pilot_id = :pilot_id,
					plane_id = :plane_id,
					pilot_plane_color = '',
					pilot_plane_status = 1
			");
			$result2 = db_exec($stmt,array(
				"pilot_id" => $GLOBALS['user']['pilot_id'],
				"plane_id" => $plane_id
			));
		}
	}
	# Lets see if this pilot has a location in his my locations area already
	# Get the event info
	$e = new Event($event_id);
	
	if($e->info['location_id'] != 0){
		$stmt = db_prep("
			SELECT *
			FROM pilot_location
			WHERE pilot_id = :pilot_id
			AND location_id = :location_id
		");
		$result = db_exec($stmt,array("pilot_id" => $GLOBALS['user']['pilot_id'],"location_id" => $e->info['location_id']));
		if(!isset($result[0])){
			# Doesn't have one of these locations, so lets put one in
			$stmt = db_prep("
				INSERT INTO pilot_location
				SET pilot_id = :pilot_id,
					location_id = :location_id,
					pilot_location_status = 1
			");
			$result2 = db_exec($stmt,array(
				"pilot_id"		=> $GLOBALS['user']['pilot_id'],
				"location_id"	=> $e->info['location_id']
			));
		}
	}
	
	# Now lets check the status to see if we need to change it because of the updates
	$balance = calculate_amount_owed($event_pilot_id);
	if($balance > 0){
		# Lets update the status to DUE
		$stmt = db_prep("
			UPDATE event_pilot
			SET event_pilot_paid_flag = 0
			WHERE event_pilot_id = :event_pilot_id
		");
		$result = db_exec($stmt,array(
			"event_pilot_id" => $event_pilot_id
		));
	}
	
	log_action($event_pilot_id);
	
	# Send reg email to pilot and CD with additional reg values
	$params = array();
	# Lets get their reg params
	$stmt = db_prep("
		SELECT *
		FROM event_pilot_reg epr
		LEFT JOIN event_reg_param erp ON epr.event_reg_param_id = erp.event_reg_param_id
		WHERE epr.event_pilot_id = :event_pilot_id
			AND epr.event_pilot_reg_status = 1
	");
	$result = db_exec($stmt,array(
		"event_pilot_id" => $event_pilot_id
	));

	$data['user'] = $GLOBALS['user'];
	$data['reg'] = $result;
	$data['info'] = $e->info;
	$data['pilots'] = $e->pilots;
	
	$sent = array(); # array of already sent emails
	
	# Send it to the registered user
	if($GLOBALS['user']['user_email'] != ''){
		send_email('event_registration_confirm',$GLOBALS['user']['user_email'],$data);
		array_push($sent, $GLOBALS['user']['user_email']);
	}
	
	# Lets only send emails the first time
	if(! $existing){
		# Send it to the owner of the event too
		if($e->info['user_email'] != '' && !in_array($e->info['user_email'], $sent)){
			send_email('event_registration_confirm',$e->info['user_email'],$data);
			array_push($sent, $e->info['user_email']);
		}
		# Send it to the CD of the event too
		if($e->info['pilot_email'] != '' && !in_array($e->info['pilot_email'], $sent)){
			send_email('event_registration_confirm',$e->info['pilot_email'],$data);
			array_push($sent, $e->info['pilot_email']);
		}
		
		# Send a copy to the admins of the event
		$stmt = db_prep("
			SELECT *
			FROM event_user eu
			LEFT JOIN pilot p ON eu.pilot_id = p.pilot_id
			WHERE eu.event_id = :event_id
				AND eu.event_user_status = 1
		");
		$result = db_exec($stmt,array("event_id" => $event_id));
		foreach($result as $row){
			$email = $row['pilot_email'];
			if($email != '' && $email != $GLOBALS['user']['user_email'] && !in_array($email, $sent)){
				send_email('event_registration_confirm',$email,$data);
			}
		}
	}
	return event_register();
}
function event_register_cancel() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$pilot_id = $GLOBALS['user']['pilot_id'];
	
	$e = new Event($event_id);
	$user = array();
	
	# Step through the pilots and find the event_pilot id of the person that is trying to cancel
	$found = 0;
	$event_pilot_id = 0;
	foreach($e->pilots as $epid => $p){
		if($p['pilot_id'] == $pilot_id){
			$event_pilot_id = $epid;
			$user = $p;
		}
	}

	if($event_pilot_id){
		# Ok, lets turn off this pilot
		# We need to check and see if they have paid anything already
		$payments = array();
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_payment epp
			WHERE epp.event_pilot_id = :event_pilot_id
				AND epp.event_pilot_payment_status = 1
			ORDER BY epp.event_pilot_payment_date
		");
		$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
		foreach($result as $row){
			$payments[] = $row;
		}
		
		# Get Reg values
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_reg epr
			LEFT JOIN event_reg_param erp ON epr.event_reg_param_id = erp.event_reg_param_id
			WHERE epr.event_pilot_id = :event_pilot_id
				AND epr.event_pilot_reg_status = 1
		");
		$reg = db_exec($stmt,array(
			"event_pilot_id" => $event_pilot_id
		));

		# Lets notify the event owners
		$data['info'] = $e->info;
		$data['user'] = $user;
		$data['payments'] = $payments;
		$data['reg'] = $reg;
			
		$sent = array(); # array of already sent emails

		if($e->info['user_email'] != ''){
			send_email('event_registration_cancel',$e->info['user_email'],$data);
			array_push($sent, $e->info['user_email']);
		}
		# Send it to the CD of the event too
		if($e->info['pilot_email'] != '' && !in_array($e->info['pilot_email'], $sent)){
			send_email('event_registration_cancel',$e->info['pilot_email'],$data);
			array_push($sent, $e->info['pilot_email']);
		}
			
		# Send a copy to the admins of the event
		$stmt = db_prep("
			SELECT *
			FROM event_user eu
			LEFT JOIN pilot p ON eu.pilot_id = p.pilot_id
			WHERE eu.event_id = :event_id
				AND eu.event_user_status = 1
		");
		$result = db_exec($stmt,array("event_id" => $event_id));
		foreach($result as $row){
			$email = $row['pilot_email'];
			if($email != '' && $email != $GLOBALS['user']['user_email'] && !in_array($email, $sent)){
				send_email('event_registration_cancel',$email,$data);
				array_push($sent, $email);
			}
		}

		# Now turn off the entry record
		$stmt = db_prep("
			UPDATE event_pilot
			SET event_pilot_status = 0
			WHERE event_pilot_id = :event_pilot_id
		");
		$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
		user_message("Registration for this event has been cancelled.");
		
	}else{
		user_message("Did not find that user in this event. No action taken.",1);
	}
	
	return event_view();
}
function event_registration_report() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$e = new Event($event_id);
	$e->get_teams();
	$smarty->assign("event",$e);
	
	# lets first get all of the event params
	$reg_options = $e->reg_options;

	# lets get the pilot registration info
	$pilot_reg_options = array();
	foreach($e->pilots as $event_pilot_id => $p){
		# Lets get their reg params
		$stmt = db_prep("
			SELECT *	
			FROM event_pilot_reg
			WHERE event_pilot_id = :event_pilot_id
				AND event_pilot_reg_status = 1
		");
		$result = db_exec($stmt,array(
			"event_pilot_id" => $p['event_pilot_id']
		));
		foreach($result as $r){
			$id = $r['event_reg_param_id'];
			if($r['event_pilot_reg_choice_value'] != ''){
				$values = array();
				$values = explode(',',$r['event_pilot_reg_choice_value']);
				$r['event_pilot_reg_choice_values'] = $values;
			}
			$pilot_reg_options[$event_pilot_id][$id] = $r;
			$reg_options[$id]['qty'] += $r['event_pilot_reg_qty'];
			if($r['event_pilot_reg_choice_value'] != ''){
				foreach($values as $v){
					$reg_options[$id]['values'][$v]['qty']++;
				}
			}
		}
	}
	$smarty->assign("pilot_reg_options",$pilot_reg_options);
	$smarty->assign("reg_options",$reg_options);

	# Get any previous payments they have made
	$payments = array();
	foreach($e->pilots as $event_pilot_id => $p){
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_payment epp
			WHERE epp.event_pilot_id = :event_pilot_id
				AND epp.event_pilot_payment_status = 1
			ORDER BY epp.event_pilot_payment_date
		");
		$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
		foreach($result as $row){
			$event_pilot_id = $row['event_pilot_id'];
			$payments[$event_pilot_id][] = $row;
		}
	}
	$smarty->assign("payments",$payments);
	
	$balances = array();
	foreach($e->pilots as $event_pilot_id => $p){
		$balance = calculate_amount_owed($event_pilot_id);
		$balances[$event_pilot_id] = $balance;
	}
	$smarty->assign("balances",$balances);
	
	if(isset($_REQUEST['use_print_header'])){
		$maintpl = find_template("event/event_register_report_print.tpl");
	}else{
		$maintpl = find_template("event/event_register_report.tpl");
	}
	return $smarty->fetch($maintpl);
}

# Event Pilot Routines
function event_pilot_edit() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);
	$pilot_id = intval($_REQUEST['pilot_id']);
	$pilot_name = $_REQUEST['pilot_name'];

	$event_pilot_edit = $_REQUEST['event_pilot_edit'];

	$event = new Event($event_id);
	$event->get_teams();
	$smarty->assign("event",$event);

	if($event_pilot_edit == 0){
		# If this is not a return edit to this event pilot
		# Check to see if the pilot already exists in this event
		$stmt = db_prep("
			SELECT *
			FROM event_pilot ep
			WHERE ep.event_id = :event_id
				AND ep.pilot_id = :pilot_id
				AND ep.event_pilot_status = 1
		");
		$result = db_exec($stmt,array("event_id" => $event_id,"pilot_id" => $pilot_id));
		if(isset($result[0])){
			# The record already exists, so lets see if it has its status to 1 or not
			user_message("The Pilot you have chosen to add is already in this event.",1);
			return event_view();
		}
	}
	$pilot = array();

	# If the event_pilot_id is zero and the pilot_id is zero, then we are making a new pilot
	if($event_pilot_id != 0){
		$stmt = db_prep("
			SELECT *
			FROM event_pilot ep
			LEFT JOIN event e ON ep.event_id = e.event_id
			LEFT JOIN pilot p ON ep.pilot_id = p.pilot_id
			LEFT JOIN state s ON p.state_id = s.state_id
			LEFT JOIN country c ON p.country_id = c.country_id
			LEFT JOIN plane pl ON ep.plane_id = pl.plane_id
			WHERE ep.event_pilot_id = :event_pilot_id
		");
		$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
		$pilot = $result[0];
		if(isset($_REQUEST['from_action'])){
			# They are returning from a plane add, so lets set things the way they were
			$pilot['pilot_ama'] = $_REQUEST['pilot_ama'];
			$pilot['pilot_fai'] = $_REQUEST['pilot_fai'];
			$pilot['pilot_fai_license'] = $_REQUEST['pilot_fai_license'];
			$pilot['class_id'] = $_REQUEST['class_id'];
			$pilot['event_pilot_freq'] = $_REQUEST['event_pilot_freq'];
			$pilot['event_pilot_team'] = $_REQUEST['event_pilot_team'];
			$pilot['event_pilot_bib'] = $_REQUEST['event_pilot_bib'];
			$pilot['plane_id'] = $_REQUEST['plane_id'];
			$pilot['plane_name'] = $_REQUEST['plane_name'];
			$pilot['event_pilot_draw_status'] = $_REQUEST['event_pilot_draw_status'];
		}
	}elseif($pilot_id != 0){
		# They have chosen a pilot from the drop down list, so lets get that info
		$stmt = db_prep("
			SELECT *
			FROM pilot p
			LEFT JOIN state s ON p.state_id = s.state_id
			LEFT JOIN country c ON p.country_id = c.country_id
			WHERE p.pilot_id = :pilot_id
		");
		$result = db_exec($stmt,array("pilot_id" => $pilot_id));
		$pilot = $result[0];
		if(isset($_REQUEST['from_action'])){
			# They are returning from a plane add, so lets set things the way they were
			$pilot['pilot_ama'] = $_REQUEST['pilot_ama'];
			$pilot['pilot_fai'] = $_REQUEST['pilot_fai'];
			$pilot['pilot_fai_license'] = $_REQUEST['pilot_fai_license'];
			$pilot['class_id'] = $_REQUEST['class_id'];
			$pilot['event_pilot_freq'] = $_REQUEST['event_pilot_freq'];
			$pilot['event_pilot_team'] = $_REQUEST['event_pilot_team'];
			$pilot['plane_id'] = $_REQUEST['plane_id'];
			$pilot['plane_name'] = $_REQUEST['plane_name'];
			$pilot['event_pilot_bib'] = $_REQUEST['event_pilot_bib'];
		}
	}else{
		# This will be a new pilot
		# lets see if they are returning
		if(isset($_REQUEST['from_action'])){
			# They are returning from a plane add, so lets set things the way they were
			$pilot['pilot_first_name'] = $_REQUEST['pilot_first_name'];
			$pilot['pilot_last_name'] = $_REQUEST['pilot_last_name'];
			$pilot['pilot_city'] = $_REQUEST['pilot_city'];
			$pilot['state_id'] = $_REQUEST['state_id'];
			$pilot['country_id'] = $_REQUEST['country_id'];
			$pilot['pilot_email'] = $_REQUEST['pilot_email'];
			$pilot['pilot_ama'] = $_REQUEST['pilot_ama'];
			$pilot['pilot_fai'] = $_REQUEST['pilot_fai'];
			$pilot['pilot_fai_license'] = $_REQUEST['pilot_fai_license'];
			$pilot['class_id'] = $_REQUEST['class_id'];
			$pilot['event_pilot_freq'] = $_REQUEST['event_pilot_freq'];
			$pilot['event_pilot_team'] = $_REQUEST['event_pilot_team'];
			$pilot['event_pilot_id'] = $_REQUEST['event_pilot_id'];
			$pilot['pilot_id'] = $_REQUEST['pilot_id'];
			$pilot['plane_id'] = $_REQUEST['plane_id'];
			$pilot['plane_name'] = $_REQUEST['plane_name'];
			$pilot['event_pilot_bib'] = $_REQUEST['event_pilot_bib'];
			$pilot['event_pilot_draw_status'] = $_REQUEST['event_pilot_draw_status'];
		}else{
			# Lets set the name that was sent
			# Lets first see if it has a comma if it was pasted as last, first
			if(preg_match("/\,\s/",$pilot_name)){
				$name = preg_split("/\,\s/",$pilot_name,2);
				$pilot['pilot_first_name'] = ucwords(strtolower($name[1]));
				$pilot['pilot_last_name'] = ucwords(strtolower($name[0]));
			}else{
				$name = preg_split("/\s/",$pilot_name,2);
				$pilot['pilot_first_name'] = ucwords(strtolower($name[0]));
				$pilot['pilot_last_name'] = ucwords(strtolower($name[1]));
			}
			$pilot['state_id'] = $event->info['state_id'];
		}
	}
	# If its a new pilot, lets set the entry order
	if($event_pilot_id == 0){
		# Lets see what the next increment in the order is
		$stmt = db_prep("
			SELECT MAX(event_pilot_entry_order) as max
			FROM event_pilot
			WHERE event_id = :event_id
			AND event_pilot_status = 1
		");
		$result = db_exec($stmt,array("event_id" => $event_id));
		if($result[0]['max'] == 'NULL' || $result[0]['max'] == 0){
			$pilot['event_pilot_entry_order'] = 1;
		}else{
			$pilot['event_pilot_entry_order'] = $result[0]['max']+1;
		}
		$pilot['event_pilot_bib'] = $pilot['event_pilot_entry_order'];
		$pilot['event_pilot_draw_status'] = 1;
	}
	
	# Lets set a default for the Channel
	if(!isset($pilot['event_pilot_freq']) || $pilot['event_pilot_freq'] == ''){
		$pilot['event_pilot_freq'] = '2.4 GHz';
	}
	$smarty->assign("pilot",$pilot);
	
	# Get classes to choose to be available for this event
	$stmt = db_prep("
		SELECT *,c.class_id
		FROM event_class ec
		LEFT JOIN class c ON ec.class_id = c.class_id
		WHERE ec.event_id = :event_id
		ORDER BY c.class_view_order
	");
	$classes = db_exec($stmt,array("event_id" => $event_id));
	$smarty->assign("classes",$classes);

	$smarty->assign("states",get_states());
	$smarty->assign("countries",get_countries());

	$smarty->assign("teams",$event->teams);
	$smarty->assign("event_id",$event_id);
	
	# Get the event reg parameters for this pilot
	$params = array();
	if($event_pilot_id != 0){
		# Lets get their reg params
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_reg
			WHERE event_pilot_id = :event_pilot_id
				AND event_pilot_reg_status = 1
		");
		$result = db_exec($stmt,array(
			"event_pilot_id" => $event_pilot_id
		));
		foreach($result as $r){
			$id = $r['event_reg_param_id'];
			if($r['event_pilot_reg_choice_value'] != ''){
				$values = array();
				$values = explode(',',$r['event_pilot_reg_choice_value']);
				$r['event_pilot_reg_choice_values'] = $values;
			}
			$params[$id] = $r;
		}
	}
	$smarty->assign("params",$params);
	
	# Lets see if there are any sizes and set a flag so we can change the view
	$has_sizes = 0;
	foreach($event->reg_options as $p){
		if($p['event_reg_param_choice_name'] != ''){
			$has_sizes = 1;
		}
	}
	$smarty->assign("has_sizes",$has_sizes);

	# Get any previous payments they have made
	$payments = array();
	$stmt = db_prep("
		SELECT *
		FROM event_pilot_payment epp
		WHERE epp.event_pilot_id = :event_pilot_id
			AND epp.event_pilot_payment_status = 1
		ORDER BY epp.event_pilot_payment_date
	");
	$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
	foreach($result as $row){
		$payments[] = $row;
	}
	$smarty->assign("payments",$payments);

	$maintpl = find_template("event/event_pilot_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_pilot_save() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);
	$pilot_id = intval($_REQUEST['pilot_id']);
	$pilot_first_name = $_REQUEST['pilot_first_name'];
	$pilot_last_name = $_REQUEST['pilot_last_name'];
	$pilot_city = $_REQUEST['pilot_city'];
	$state_id = intval($_REQUEST['state_id']);
	$country_id = intval($_REQUEST['country_id']);
	$pilot_ama = $_REQUEST['pilot_ama'];
	$pilot_fai = $_REQUEST['pilot_fai'];
	$pilot_fai_license = $_REQUEST['pilot_fai_license'];
	$pilot_email = $_REQUEST['pilot_email'];
	$class_id = intval($_REQUEST['class_id']);
	$event_pilot_freq = $_REQUEST['event_pilot_freq'];
	$event_pilot_team = isset( $_REQUEST['event_pilot_team'] ) ? $_REQUEST['event_pilot_team'] : '' ;
	$plane_id = intval($_REQUEST['plane_id']);
	$from_confirm = intval($_REQUEST['from_confirm']);
	$event_pilot_entry_order = intval($_REQUEST['event_pilot_entry_order']);
	$event_pilot_bib = intval($_REQUEST['event_pilot_bib']);
	$event_pilot_paid_flag = intval($_REQUEST['event_pilot_paid_flag']);
	$event_pilot_draw_status = intval($_REQUEST['event_pilot_draw_status']);
	$manual_payment_amount = $_REQUEST['manual_payment_amount'];

	$return_event_view = 1;

	# Now lets get the existing additional values
	$params = array();
	foreach($_REQUEST as $key => $value){
		if(preg_match("/reg\_param\_(\d+)\_(\S+)$/",$key,$match)){
			$reg_id = $match[1];
			$reg_type = $match[2];
			if(preg_match("/^(\S+)\_(\d*)/",$reg_type,$match2)){
				$reg_type = $match2[1];
				$params[$reg_id][$reg_type] = $params[$reg_id][$reg_type].",".$value;
				# Lets get rid of the first comma if necessary
				$params[$reg_id][$reg_type] = preg_replace("/^\,/",'',$params[$reg_id][$reg_type]);
			}else{
				$params[$reg_id][$reg_type] = $value;
			}
		}
	}

	# If the pilot doesn't exist, then lets add the new pilot to the pilot table
	$current_pilot_id = 0;
	if($pilot_id == 0){
		# This means that we need to add a new pilot
		
		if($from_confirm == 0){
			# First, lets maybe see if a pilot with that name already exists in that city and country
			$pilots = array();
			$stmt = db_prep("
				SELECT *
				FROM pilot p
				LEFT JOIN state s ON p.state_id = s.state_id
				LEFT JOIN country c ON p.country_id = c.country_id
				WHERE p.pilot_first_name = LOWER(:pilot_first_name)
					AND p.pilot_last_name = LOWER(:pilot_last_name)
			");
			$pilots = db_exec($stmt,array(
				"pilot_first_name" => strtolower($pilot_first_name),
				"pilot_last_name" => strtolower($pilot_last_name)
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
				$smarty->assign("pilot_fai_license",$pilot_fai_license);
				$smarty->assign("pilot_email",$pilot_email);
				$smarty->assign("class_id",$class_id);
				$smarty->assign("event_pilot_freq",$event_pilot_freq);
				$smarty->assign("event_pilot_team",$event_pilot_team);
				$smarty->assign("event_pilot_bib",$event_pilot_bib);
				$smarty->assign("event_pilot_draw_status",$event_pilot_draw_status);
				$smarty->assign("plane_id",$plane_id);
				
				# Lets add the state name and country name for good presentation
				$states = get_states();
				$countries = get_countries();
				foreach($states as $s){
					if($s['state_id'] == $state_id){
						$smarty->assign("state",$s);
					}
				}
				foreach($countries as $c){
					if($c['country_id'] == $country_id){
						$smarty->assign("country",$c);
					}
				}
				
				$maintpl = find_template("event/event_pilot_show_possible.tpl");
				return $smarty->fetch($maintpl);
			}
		}
		
		$stmt = db_prep("
			INSERT INTO pilot
			SET user_id = 0,
				pilot_first_name = :pilot_first_name,
				pilot_last_name = :pilot_last_name,
				pilot_email = :pilot_email,
				pilot_ama = :pilot_ama,
				pilot_fai = :pilot_fai,
				pilot_fai_license = :pilot_fai_license,
				pilot_city = :pilot_city,
				state_id = :state_id,
				country_id = :country_id
		");
		$result = db_exec($stmt,array(
			"pilot_first_name"	=> $pilot_first_name,
			"pilot_last_name"	=> $pilot_last_name,
			"pilot_email"		=> $pilot_email,
			"pilot_ama"			=> $pilot_ama,
			"pilot_fai"			=> $pilot_fai,
			"pilot_fai_license"	=> $pilot_fai_license,
			"pilot_city"		=> $pilot_city,
			"state_id"			=> $state_id,
			"country_id"		=> $country_id,
		));
		$pilot_id = $GLOBALS['last_insert_id'];
		user_message("Created new pilot $pilot_first_name $pilot_last_name.");
	}else{
		# Lets see if this pilot ID is a new one caused by a change of pilot
		$stmt = db_prep("
			SELECT *
			FROM event_pilot
			WHERE event_pilot_id = :event_pilot_id
		");
		$result = db_exec($stmt,array( "event_pilot_id" => $event_pilot_id ));
		$current_pilot_id = $result[0]['pilot_id'];
	}
	
	if($event_pilot_id != 0){
		# Lets save this existing event pilot
		$stmt = db_prep("
			UPDATE event_pilot
			SET pilot_id = :pilot_id,
				class_id = :class_id,
				event_pilot_entry_order = :event_pilot_entry_order,
				event_pilot_bib = :event_pilot_bib,
				event_pilot_freq = :event_pilot_freq,
				event_pilot_team = :event_pilot_team,
				plane_id = :plane_id,
				event_pilot_paid_flag = :event_pilot_paid_flag,
				event_pilot_draw_status = :event_pilot_draw_status
			WHERE event_pilot_id = :event_pilot_id
		");
		$result = db_exec($stmt,array(
			"pilot_id"					=> $pilot_id,
			"class_id"					=> $class_id,
			"event_pilot_entry_order"	=> $event_pilot_entry_order,
			"event_pilot_bib"			=> $event_pilot_bib,
			"event_pilot_freq"			=> $event_pilot_freq,
			"event_pilot_team"			=> $event_pilot_team,
			"event_pilot_id"			=> $event_pilot_id,
			"plane_id"					=> $plane_id,
			"event_pilot_paid_flag"		=> $event_pilot_paid_flag,
			"event_pilot_draw_status"	=> $event_pilot_draw_status
		));
	}else{
		# We need to create a new event pilot id
		# Lets first see if there already is one to just turn on
		$stmt = db_prep("
			SELECT *
			FROM event_pilot ep
			WHERE event_id = :event_id
				AND pilot_id = :pilot_id
		");
		$result = db_exec($stmt,array("event_id" => $event_id,"pilot_id" => $pilot_id));
		if(isset($result[0])){
			# This event_pilot already exists, so lets just update it
			$stmt = db_prep("
				UPDATE event_pilot
				SET pilot_id = :pilot_id,
					class_id = :class_id,
					event_pilot_entry_order = :event_pilot_entry_order,
					event_pilot_bib = :event_pilot_bib,
					event_pilot_freq = :event_pilot_freq,
					event_pilot_team = :event_pilot_team,
					plane_id = :plane_id,
					event_pilot_paid_flag = :event_pilot_paid_flag,
					event_pilot_draw_status = :event_pilot_draw_status,
					event_pilot_status = 1
				WHERE event_pilot_id = :event_pilot_id
			");
			$result2 = db_exec($stmt,array(
				"pilot_id"					=> $pilot_id,
				"class_id"					=> $class_id,
				"event_pilot_entry_order"	=> $event_pilot_entry_order,
				"event_pilot_bib"			=> $event_pilot_bib,
				"event_pilot_freq"			=> $event_pilot_freq,
				"event_pilot_team"			=> $event_pilot_team,
				"plane_id"					=> $plane_id,
				"event_pilot_paid_flag"		=> $event_pilot_paid_flag,
				"event_pilot_draw_status"	=> $event_pilot_draw_status,
				"event_pilot_id"			=> $result[0]['event_pilot_id']
			));
			$event_pilot_id = $result[0]['event_pilot_id'];
		}else{
			# We need to create a new event pilot		
			$stmt = db_prep("
				INSERT INTO event_pilot
				SET event_id = :event_id,
					pilot_id = :pilot_id,
					event_pilot_entry_order = :event_pilot_entry_order,
					event_pilot_bib = :event_pilot_bib,
					class_id = :class_id,
					event_pilot_freq = :event_pilot_freq,
					event_pilot_team = :event_pilot_team,
					plane_id = :plane_id,
					event_pilot_paid_flag = :event_pilot_paid_flag,
					event_pilot_draw_status = :event_pilot_draw_status,
					event_pilot_status = 1
			");
			$result2 = db_exec($stmt,array(
				"event_id"					=> $event_id,
				"pilot_id"					=> $pilot_id,
				"class_id"					=> $class_id,
				"event_pilot_entry_order"	=> $event_pilot_entry_order,
				"event_pilot_bib"			=> $event_pilot_bib,
				"event_pilot_freq"			=> $event_pilot_freq,
				"event_pilot_team"			=> $event_pilot_team,
				"plane_id"					=> $plane_id,
				"event_pilot_paid_flag"		=> $event_pilot_paid_flag,
				"event_pilot_draw_status"	=> $event_pilot_draw_status
			));
			$event_pilot_id = $GLOBALS['last_insert_id'];
		}
	}
	# Lets see if we need to update the pilot's ama or fai number, but only if the pilot didn't get changed in this call
	if( $pilot_id == $current_pilot_id ){
		$stmt = db_prep("
			SELECT *
			FROM event_pilot ep
			LEFT JOIN event e ON ep.event_id = e.event_id
			LEFT JOIN pilot p ON ep.pilot_id = p.pilot_id
			WHERE ep.event_pilot_id = :event_pilot_id
		");
		$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
		$pilot = $result[0];
		if($pilot_ama != $pilot['pilot_ama'] || $pilot_fai != $pilot['pilot_fai'] || $pilot_fai_license != $pilot['pilot_fai_license']){
			# lets update the pilot record
			$stmt = db_prep("
				UPDATE pilot
				SET pilot_ama = :pilot_ama,
					pilot_fai = :pilot_fai,
					pilot_fai_license = :pilot_fai_license
					WHERE pilot_id = :pilot_id
			");
			$result = db_exec($stmt,array(
				"pilot_ama" => $pilot_ama,
				"pilot_fai" => $pilot_fai,
				"pilot_fai_license" => $pilot_fai_license,
				"pilot_id" => $pilot['pilot_id']
			));
		}
	}
	
	# Lets see if this pilot has a plane in his my planes area already
	if($plane_id != 0){
		$stmt = db_prep("
			SELECT *
			FROM pilot_plane
			WHERE pilot_id = :pilot_id
			AND plane_id = :plane_id
		");
		$result = db_exec($stmt,array("pilot_id" => $pilot['pilot_id'],"plane_id" => $plane_id));
		if(!isset($result[0])){
			# Doesn't have one of these planes in their quiver, so lets put one in
			$stmt = db_prep("
				INSERT INTO pilot_plane
				SET pilot_id = :pilot_id,
					plane_id = :plane_id,
					pilot_plane_color = '',
					pilot_plane_status = 1
			");
			$result2 = db_exec($stmt,array(
				"pilot_id" => $pilot['pilot_id'],
				"plane_id" => $plane_id
			));
		}
	}
	# Lets see if this pilot has a location in his my locations area already
	# Get the event info
	$e = new Event($event_id);
	
	if($e->info['location_id'] != 0){
		$stmt = db_prep("
			SELECT *
			FROM pilot_location
			WHERE pilot_id = :pilot_id
			AND location_id = :location_id
		");
		$result = db_exec($stmt,array("pilot_id" => $pilot_id,"location_id" => $e->info['location_id']));
		if(!isset($result[0])){
			# Doesn't have one of these locations, so lets put one in
			$stmt = db_prep("
				INSERT INTO pilot_location
				SET pilot_id = :pilot_id,
					location_id = :location_id,
					pilot_location_status = 1
			");
			$result2 = db_exec($stmt,array(
				"pilot_id"		=> $pilot_id,
				"location_id"	=> $e->info['location_id']
			));
		}
	}
	
	# Lets update the pilot registration parameters now
	# Lets first wipe all of the parameters clean because there are possible checkboxes
	$stmt = db_prep("
		UPDATE event_pilot_reg
		SET event_pilot_reg_status = 0
		WHERE event_pilot_id = :event_pilot_id
	");
	$result = db_exec($stmt,array(
		"event_pilot_id" => $event_pilot_id
	));
	foreach($params as $reg_id => $r){
		$qty = $r['qty'];
		if($qty == 'on'){
			$qty = 1;
		}
		# Lets see if one exists with this reg type then
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_reg
			WHERE event_pilot_id = :event_pilot_id
				AND event_reg_param_id = :event_reg_param_id
		");
		$result = db_exec($stmt,array(
			"event_pilot_id"		=> $event_pilot_id,
			"event_reg_param_id"	=> $reg_id
		));
		if(isset($result[0])){
			# One already exists, so update it
			$stmt = db_prep("
				UPDATE event_pilot_reg
				SET event_pilot_reg_status = 1,
					event_pilot_reg_qty = :qty,
					event_pilot_reg_choice_value = :choice_value
				WHERE event_pilot_reg_id = :event_pilot_reg_id
			");
			$result = db_exec($stmt,array(
				"qty"					=> $qty,
				"choice_value"			=> $r['choice_value'],
				"event_pilot_reg_id"	=> $result[0]['event_pilot_reg_id']
			));
		}else{
			# Need to create a new one
			$stmt = db_prep("
				INSERT INTO event_pilot_reg
				SET event_pilot_id = :event_pilot_id,
					event_reg_param_id = :reg_id,
					event_pilot_reg_qty = :qty,
					event_pilot_reg_choice_value = :choice_value,
					event_pilot_reg_status = 1
			");
			$result = db_exec($stmt,array(
				"event_pilot_id"	=> $event_pilot_id,
				"reg_id"			=> $reg_id,
				"qty"				=> $qty,
				"choice_value"		=> $r['choice_value']
			));
		}
	}
	# Lets save the payment status and manual payment info if there was one
	if($manual_payment_amount>0){
		# Insert payment
		$stmt = db_prep("
			INSERT INTO event_pilot_payment
			SET event_pilot_id = :event_pilot_id,
				event_pilot_payment_date = now(),
				event_pilot_payment_type = 'Manual',
				event_pilot_payment_amount = :amount,
				event_pilot_payment_status = 1
		");
		$result = db_exec($stmt,array(
			"event_pilot_id"	=> $event_pilot_id,
			"amount"			=> $manual_payment_amount
		));
		user_message("Added manual payment.");
		$return_event_view = 0;
	}
	# Now lets check the status to see if it is paid
	switch($event_pilot_paid_flag){
		case 2:
			# This is the automatic case, where we should set it if they paid everything
			# But only if they've manually paid something
			$balance = calculate_amount_owed($event_pilot_id);
			# See if they have any paid records
			# Total the paid records
			$stmt = db_prep("
				SELECT sum(event_pilot_payment_amount) as total_paid
				FROM event_pilot_payment
				WHERE event_pilot_id = :event_pilot_id
					AND event_pilot_payment_status = 1
			");
			$result = db_exec($stmt,array(
				"event_pilot_id" => $event_pilot_id,
			));
			$total_paid = $result[0]['total_paid'];

			# Change the status accordingly
			$status = 2;
			if(($total_paid>0 && $balance <= 0) || $balance < 0){
				# Update the status to PAID
				$status = 1;
			}
			break;
		case 0:
			$status = 0;
			break;
		case 1:
			$status = 1;
	}
	# Update the status
	if($status != 2){
		$stmt = db_prep("
			UPDATE event_pilot
			SET event_pilot_paid_flag = :event_pilot_paid_flag
			WHERE event_pilot_id = :event_pilot_id
		");
		$result = db_exec($stmt,array(
			"event_pilot_id"		=> $event_pilot_id,
			"event_pilot_paid_flag"	=> $status
		));
	}
	
	log_action($event_pilot_id);
	user_message("Updated event pilot info.");
	if($return_event_view == 1){
		return event_view();
	}else{
		return event_pilot_edit();
	}
}
function event_pilot_edit_pilot() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);

	$event = new Event($event_id);
	$event->get_teams();
	$smarty->assign("event",$event);

	$pilot = array();
	$stmt = db_prep("
		SELECT *
		FROM event_pilot ep
		LEFT JOIN pilot p ON ep.pilot_id = p.pilot_id
		WHERE ep.event_pilot_id = :event_pilot_id
	");
	$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
	$pilot = $result[0];
	
	$smarty->assign("states",get_states());
	$smarty->assign("countries",get_countries());

	$smarty->assign("pilot",$pilot);
	$smarty->assign("event_id",$event_id);
	$smarty->assign("event_pilot_id",$event_pilot_id);

	$maintpl = find_template("event/event_pilot_edit_pilot.tpl");
	return $smarty->fetch($maintpl);
}
function event_pilot_save_pilot() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);
	$pilot_id = intval($_REQUEST['pilot_id']);
	$pilot_first_name = $_REQUEST['pilot_first_name'];
	$pilot_last_name = $_REQUEST['pilot_last_name'];
	$pilot_city = $_REQUEST['pilot_city'];
	$state_id = intval($_REQUEST['state_id']);
	$country_id = intval($_REQUEST['country_id']);
	$pilot_ama = $_REQUEST['pilot_ama'];
	$pilot_fai = $_REQUEST['pilot_fai'];
	$pilot_fai_license = $_REQUEST['pilot_fai_license'];
	$pilot_email = $_REQUEST['pilot_email'];

	# OK, lets save the pilot changes and go back to the event pilot edit
	$stmt = db_prep("
		UPDATE pilot
		SET pilot_first_name = :pilot_first_name,
			pilot_last_name = :pilot_last_name,
			pilot_city = :pilot_city,
			state_id = :state_id,
			country_id = :country_id,
			pilot_email = :pilot_email,
			pilot_ama = :pilot_ama,
			pilot_fai = :pilot_fai,
			pilot_fai_license = :pilot_fai_license
			WHERE pilot_id = :pilot_id
	");
	$result = db_exec($stmt,array(
		"pilot_first_name"	=> $pilot_first_name,
		"pilot_last_name"	=> $pilot_last_name,
		"pilot_city"		=> $pilot_city,
		"state_id"			=> $state_id,
		"country_id"		=> $country_id,
		"pilot_email"		=> $pilot_email,
		"pilot_ama"			=> $pilot_ama,
		"pilot_fai"			=> $pilot_fai,
		"pilot_fai_license"	=> $pilot_fai_license,
		"pilot_id"			=> $pilot_id
	));
	user_message("Updated Pilot Info");
	return event_pilot_edit();
}
function event_pilot_remove() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = $_REQUEST['event_pilot_id'];

	$stmt = db_prep("
		UPDATE event_pilot
		SET event_pilot_status = 0
		WHERE event_pilot_id = :event_pilot_id
	");
	$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
	# Lets turn off their flights and rounds
	$stmt = db_prep("
		UPDATE event_pilot_round_flight
		SET event_pilot_round_flight_status = 0
		WHERE event_pilot_round_id in (SELECT event_pilot_round_id from event_pilot_round WHERE event_pilot_id = :event_pilot_id)
	");
	$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));

	# Now lets recalculate and save the event info because this pilot is no longer there
	$e = new Event($event_id);
	$e->event_save_totals();

	log_action($event_pilot_id);
	user_message("Pilot removed from event.");
	return event_view();
}
function event_user_save() {
	global $smarty;
	global $user;
	
	$event_id = intval($_REQUEST['event_id']);
	$pilot_id = intval($_REQUEST['pilot_id']);

	if($pilot_id == 0){
		user_message("Cannot add a blank user for access.",1);
		return event_edit();
	}
	# Get the current user pilot id to make sure they don't add themselves
	$stmt = db_prep("
		SELECT *
		FROM event e
		WHERE event_id = :event_id
	");
	$result = db_exec($stmt,array("event_id" => $event_id));
	if(isset($result[0])){
		$event = $result[0];
	}
	if($event['pilot_id'] == $pilot_id){
		user_message("You do not need to give access to yourself, as you will always have access as the owner of this event.");
		return event_edit();
	}
	
	# Now lets check to see if this is the event owner, because only they can add an event user or the CD, or the admin
	if($event['pilot_id'] != $user['pilot_id'] && $user['pilot_id'] != $event['event_cd'] && !$user['user_admin']){
		user_message("You do not have access to give anyone else access. Only the event owner can do that.",1);
		return event_edit();
	}
	
	# Lets first see if this one is already added
	$stmt = db_prep("
		SELECT *
		FROM event_user
		WHERE event_id = :event_id
			AND pilot_id = :pilot_id
	");
	$result = db_exec($stmt,array("event_id" => $event_id,"pilot_id" => $pilot_id));
	
	if(isset($result[0])){
		# This record already exists, so lets just turn it on
		$stmt = db_prep("
			UPDATE event_user
			SET event_user_status = 1
			WHERE event_user_id = :event_user_id
		");
		$result = db_exec($stmt,array("event_user_id" => $result[0]['event_user_id']));
	}else{
		# Lets create a new record
		$stmt = db_prep("
			INSERT INTO event_user
			SET event_id = :event_id,
				pilot_id = :pilot_id,
				event_user_status = 1
		");
		$result = db_exec($stmt,array(
			"event_id" => $event_id,
			"pilot_id" => $pilot_id
		));
	}
	log_action($pilot_id);
	user_message("New user given access to edit this event.");
	return event_edit();
}
function event_user_delete() {
	global $smarty;
	global $user;
	
	$event_id = intval($_REQUEST['event_id']);
	$event_user_id = intval($_REQUEST['event_user_id']);

	# Lets see if they are allowed to do this
	$stmt = db_prep("
		SELECT *
		FROM event e
		WHERE event_id = :event_id
	");
	$result = db_exec($stmt,array("event_id" => $event_id));
	if(isset($result[0])){
		$event = $result[0];
	}
	
	# Now lets check to see if this is the event owner, because only they can delete a user
	if($event['pilot_id'] != $user['pilot_id']){
		user_message("You do not have access to remove access to this event. Only the event owner can do that.",1);
		return event_edit();
	}

	# Lets turn off this record
	$stmt = db_prep("
		UPDATE event_user
		SET event_user_status = 0
		WHERE event_user_id = :event_user_id
	");
	$result = db_exec($stmt,array("event_user_id" => $event_user_id));
	
	log_action($event_user_id);
	user_message("Removed user access to edit this event.");
	return event_edit();
}
function event_param_save() {
	global $smarty;
	global $user;
	
	$event_id = intval($_REQUEST['event_id']);
	
	# Lets clear out all of the option values that this event has
	$stmt = db_prep("
		UPDATE event_option
		SET event_option_status = 0
		WHERE event_id = :event_id
	");
	$result = db_exec($stmt,array("event_id" => $event_id));
	
	# Now lets step through the options and see if they are turned on and add them or update them
	foreach($_REQUEST as $key => $value){
		if(preg_match("/^option_(\d+)/",$key,$match)){
				$id = $match[1];
				if($value == 'On' || $value == 'on'){
					$value = 1;
				}
		}else{
			continue;
		}

		# ok, lets see if a record with that id exists
		$stmt = db_prep("
			SELECT *
			FROM event_option
			WHERE event_id = :event_id
				AND event_type_option_id = :event_type_option_id
		");
		$result = db_exec($stmt,array("event_type_option_id" => $id,"event_id" => $event_id));
		if($result){
			# There is already a record, so lets update it
			$event_option_id = $result[0]['event_option_id'];
			# Only update it if the value is not null
			if($value != ''){
				$stmt = db_prep("
					UPDATE event_option
					SET event_option_value = :value,
						event_option_status = 1
					WHERE event_option_id = :event_option_id
				");
				$result2 = db_exec($stmt,array("value" => $value,"event_option_id" => $event_option_id));
			}
		}else{
			# There is not a record so lets make one
			if($value != ''){
				$stmt = db_prep("
					INSERT INTO event_option
					SET event_id = :event_id,
						event_type_option_id = :event_type_option_id,
						event_option_value = :value,
						event_option_status = 1
				");
				$result2 = db_exec($stmt,array("event_id" => $event_id,"event_type_option_id" => $id,"value" => $value));
			}
		}
	}	
	# Now lets recalculate and save the event info because the parameters may have changed
	$e = new Event($event_id);
	$e->get_rounds();
	$e->recalculate_all_rounds();
	$e->calculate_event_totals();
	$e->event_save_totals();
	
	log_action($event_id);
	user_message("Event Parameters Saved.");
	return event_edit();
}
function calculate_amount_owed($event_pilot_id){
	# Function to determine the balance owed by a pilot
	$stmt = db_prep("
		SELECT *
		FROM event_pilot_reg epr
		LEFT JOIN event_reg_param erp ON epr.event_reg_param_id = erp.event_reg_param_id
		WHERE epr.event_pilot_id = :event_pilot_id
			AND epr.event_pilot_reg_status = 1
	");
	$result = db_exec($stmt,array(
		"event_pilot_id" => $event_pilot_id
	));
	$total_owed = 0;
	foreach($result as $row){
		$total_owed  +=  $row['event_pilot_reg_qty']*$row['event_reg_param_cost'];
	}
	# Total the paid records
	$stmt = db_prep("
		SELECT sum(event_pilot_payment_amount) as total_paid
		FROM event_pilot_payment
		WHERE event_pilot_id = :event_pilot_id
			AND event_pilot_payment_status = 1
	");
	$result = db_exec($stmt,array(
		"event_pilot_id" => $event_pilot_id,
	));
	$total_paid = $result[0]['total_paid'];
	$balance = $total_owed - $total_paid;
	return $balance;
}

# Event Round Routines
function event_round_edit() {
	global $smarty;
	# Function to add or edit a round to an event
	
	$event_id = intval($_REQUEST['event_id']);
	$event_round_id = intval($_REQUEST['event_round_id']);
	$zero_round = intval($_REQUEST['zero_round']);
	$flyoff_round = intval($_REQUEST['flyoff_round']);
	$view_only = intval($_REQUEST['view_only']);
	if(isset($_REQUEST['sort_by'])){
		$sort_by = $_REQUEST['sort_by'];
	}else{
		$sort_by = 'round_rank';
	}
	$event = new Event($event_id);
	$event->get_rounds();
	$event->get_tasks();

	$flight_types = $event->flight_types;

	# Now lets look at the rounds to see which is the next round # to add if its a new one
	$round = array();
	if($event_round_id == 0){
		# Lets see if this is a zero round
		if($zero_round){
			# Lets see if there is already a zero round and make it 00 or 000
			$num_zeros = 0;
			foreach($event->rounds as $number => $r){
				if(preg_match("/^0/",$number)){
					$num_zeros++;
				}
			}
			$round_number = '';
			for($i = 0; $i <= $num_zeros; $i++){
				$round_number .= '0';
			}
		}else{
			# Lets figure out the next round number
			$max = 0;
			foreach($event->rounds as $number => $r){
				if($number>$max){
					$max = $number;
				}
			}
			$round_number = $max+1;
		}
		# Now Lets fill out the round info with default stuff from what type of event this is
		# We actually need to fill in the default round data for an empty round
		$event->get_new_round($round_number);
		if($event->info['event_type_code'] == 'f3k'){
			if($event->f3k_flight_type_id != 0){
				$flight_type_id = $event->f3k_flight_type_id;
			}
		}
		if($event->info['event_type_code'] == 'f3j' || $event->info['event_type_code'] == 'f5j'){
			if($flyoff_round){
				$event->rounds[$round_number]['event_round_time_choice'] = 15;
			}else{
				$event->rounds[$round_number]['event_round_time_choice'] = 10;
			}
		}
		# Lets set the round to be scored or not depending on the zero choice
		if($zero_round){
			$event->rounds[$round_number]['event_round_score_status'] = 0;
		}else{
			$event->rounds[$round_number]['event_round_score_status'] = 1;
		}
		$event->rounds[$round_number]['event_round_score_second'] = 1;
	}else{
		# Step through and get the round number from the event_round_id
		foreach($event->rounds as $event_round_number => $data){
			if($data['event_round_id'] == $event_round_id){
				$round_number = $event_round_number;
			}
		}
	}

	# Lets set whether or not there is a self scoring option
	$self_entry_param = $event->info['event_type_code']."_self_entry";
	$self_entry = $event->find_option_value($self_entry_param);
	$smarty->assign("self_entry",$self_entry);
	
	$smarty->assign("event_round_id",$event_round_id);
	$smarty->assign("round_number",$round_number);
	$smarty->assign("sort_by",$sort_by);

	$smarty->assign("flight_types",$flight_types);
	$smarty->assign("event",$event);
	$smarty->assign("total_pilots",count($event->pilots));
		
	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	if($permission == 1 && $view_only != 1){
		$maintpl = find_template("event/event_round_edit.tpl");
	}else{
		$maintpl = find_template("event/event_round_view.tpl");
	}
	return $smarty->fetch($maintpl);
}
function event_round_save() {
	global $smarty;
	# Function to save the round
	sub_trace();
	
	$event_id = intval($_REQUEST['event_id']);
	$event_round_id = intval($_REQUEST['event_round_id']);
	$flight_type_id = intval($_REQUEST['flight_type_id']);
	$event_round_time_choice = $_REQUEST['event_round_time_choice'];
	$event_round_number = $_REQUEST['event_round_number'];
	$event_round_flyoff = intval($_REQUEST['event_round_flyoff']);
	$create_new_round = intval($_REQUEST['create_new_round']);
	$event_round_score_status = 0;
	$event_round_locked = 0;
	$event = new Event($event_id);
	$event->get_rounds();
	if(isset($_REQUEST['event_round_score_status']) && ($_REQUEST['event_round_score_status'] == 'on' || $_REQUEST['event_round_score_status'] == 1)){
		$event_round_score_status = 1;
	}else{
		$event_round_score_status = 0;
	}
	if(isset($_REQUEST['event_round_locked']) && ($_REQUEST['event_round_locked'] == 'on' || $_REQUEST['event_round_locked'] == 1)){
		$event_round_locked = 1;
	}else{
		$event_round_locked = 0;
	}
	if(isset($_REQUEST['event_round_score_second']) && ($_REQUEST['event_round_score_second'] != '')){
		$event_round_score_second = $_REQUEST['event_round_score_second'];
	}else{
		$event_round_score_second = 1;
	}
	$new_round = 0;
	if($event_round_id == 0){
		$new_round = 1;
	}
	# Get flight type info for determining max sub flights and stuff
	$flight_type = array();
	$stmt = db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id = :flight_type_id
	");
	$result = db_exec($stmt,array("flight_type_id" => $flight_type_id));
	if(isset($result[0])){
		$flight_type = $result[0];
	}else{
		# No flight type chosen so lets set it on the event type
		$stmt = db_prep("
			SELECT *
			FROM event e
			LEFT JOIN event_type et ON e.event_type_id = et.event_type_id
			WHERE e.event_id = :event_id
		");
		$result = db_exec($stmt,array("event_id" => $event_id));
		$event_code = $result[0]['event_type_code'];
		$pattern = '';
		switch($event_code){
			case 'f3f':
				$pattern = 'f3f_speed';
				break;
			case 'f3f_plus':
				$pattern = 'f3f_plus';
				break;
			case 'f3b_speed':
				$pattern = 'f3b_speed';
				break;
			case 'f3j':
				$pattern = 'f3j_duration';
				break;
			case 'f5j':
				$pattern = 'f5j_duration';
				break;
			case 'td':
				$pattern = 'td_duration';
				break;				
			case 'mom':
				$pattern = 'mom_position';
				break;
			case 'gps':
				$pattern = 'gps_distance';
				break;
			case 'f3b':
			case 'f3k':
			default:
		}
		if($pattern != ''){
			$stmt = db_prep("
				SELECT *
				FROM flight_type
				WHERE flight_type_code = :pattern
			");
			$result = db_exec($stmt,array("pattern" => $pattern));
			$flight_type = $result[0];
			$flight_type_id = $flight_type['flight_type_id'];
		}
	}
	
	# First, lets save the round info
	if($event_round_id == 0){
		# New round, so lets create
		# Lets first see if maybe we already created one with the quick score routines
		$stmt = db_prep("
			SELECT *
			FROM event_round
			WHERE event_id = :event_id
			AND event_round_number = :event_round_number
			AND event_round_status = 1
		");
		$result = db_exec($stmt,array("event_id" => $event_id,"event_round_number" => $event_round_number));
		if(isset($result[0])){
			$event_round_id = $result[0]['event_round_id'];
			$_REQUEST['event_round_id'] = $event_round_id;
			# Need to update it to say that it no longer needs calculation
			$stmt = db_prep("
				UPDATE event_round
				SET event_round_needs_calc = 1
				WHERE event_round_id = :event_round_id
			");
			$result = db_exec($stmt,array(
				"event_round_id" => $event_round_id
			));
		}else{
			$stmt = db_prep("
				INSERT INTO event_round
				SET event_id = :event_id,
					event_round_number = :event_round_number,
					flight_type_id = :flight_type_id,
					event_round_time_choice = :event_round_time_choice,
					event_round_score_status = :event_round_score_status,
					event_round_score_second = :event_round_score_second,
					event_round_locked = :event_round_locked,
					event_round_needs_calc = 0,
					event_round_flyoff = :event_round_flyoff,
					event_round_status = 1
			");
			$result = db_exec($stmt,array(
				"event_id"					=> $event_id,
				"event_round_number"		=> $event_round_number,
				"flight_type_id"			=> $flight_type_id,
				"event_round_time_choice"	=> $event_round_time_choice,
				"event_round_flyoff"		=> $event_round_flyoff,
				"event_round_score_status"	=> $event_round_score_status,
				"event_round_score_second"	=> $event_round_score_second,
				"event_round_locked"	=> $event_round_locked
			));
			$event_round_id = $GLOBALS['last_insert_id'];
			$_REQUEST['event_round_id'] = $event_round_id;
		}
	}else{
		# Lets save it
		$stmt = db_prep("
			UPDATE event_round
			SET flight_type_id = :flight_type_id,
				event_round_time_choice = :event_round_time_choice,
				event_round_score_status = :event_round_score_status,
				event_round_score_second = :event_round_score_second,
				event_round_locked = :event_round_locked,
				event_round_flyoff = :event_round_flyoff,
				event_round_needs_calc = 0
			WHERE event_round_id = :event_round_id
		");
		$result = db_exec($stmt,array(
			"flight_type_id"			=> $flight_type_id,
			"event_round_time_choice"	=> $event_round_time_choice,
			"event_round_score_status"	=> $event_round_score_status,
			"event_round_score_second"	=> $event_round_score_second,
			"event_round_locked"		=> $event_round_locked,
			"event_round_flyoff"		=> $event_round_flyoff,
			"event_round_id"			=> $event_round_id
		));
	}

	# Now lets save the round flight type scoring data
	if($new_round && $event_code != 'f3b'){
		# Its a new round, so lets create the flight types with the scoring already turned on
		# First lets see if it exists
		$stmt = db_prep("
			SELECT *
			FROM event_round_flight
			WHERE event_round_id = :event_round_id
			AND flight_type_id = :flight_type_id
		");
		$result = db_exec($stmt,array("event_round_id" => $event_round_id,"flight_type_id" => $flight_type_id));
		if(isset($result[0])){
			# This one already exists, so lets update it
			$stmt = db_prep("
				UPDATE event_round_flight
				SET event_round_flight_score = 1
				WHERE event_round_flight_id = :event_round_flight_id
			");
			$result2 = db_exec($stmt,array("event_round_flight_id" => $result[0]['event_round_flight_id']));
		}else{
			# This record doesn't exist, so lets create a new one
			$stmt = db_prep("
				INSERT INTO event_round_flight
				SET event_round_id = :event_round_id,
					flight_type_id = :flight_type_id,
					event_round_flight_score = 1
			");
			$result2 = db_exec($stmt,array("event_round_id" => $event_round_id,"flight_type_id" => $flight_type_id));
		}
	}else{
		# This round already existed, so lets update everything
		# First, lets turn off all of the round scoring data for this round and the flights
		$stmt = db_prep("
			UPDATE event_round_flight
			SET event_round_flight_score = 0
			WHERE event_round_id = :event_round_id
		");
		$result = db_exec($stmt,array("event_round_id" => $event_round_id));
		# Now lets step through the ones that are "on" and update or create the record
		foreach($_REQUEST as $key => $value){
			if(preg_match("/^event_round_flight_score_(\d+)$/",$key,$match)){
				$ftype_id = $match[1];
				if($value == 'on'){
					# lets save or create this record
					# First lets see if it exists
					$stmt = db_prep("
						SELECT *
						FROM event_round_flight
						WHERE event_round_id = :event_round_id
						AND flight_type_id = :ftype_id
					");
					$result = db_exec($stmt,array("event_round_id" => $event_round_id,"ftype_id" => $ftype_id));
					if(isset($result[0])){
						# This one already exists, so lets update it
						$stmt = db_prep("
							UPDATE event_round_flight
							SET event_round_flight_score = 1
							WHERE event_round_flight_id = :event_round_flight_id
						");
						$result2 = db_exec($stmt,array("event_round_flight_id" => $result[0]['event_round_flight_id']));
					}else{
						# This record doesn't exist, so lets create a new one
						$stmt = db_prep("
							INSERT INTO event_round_flight
							SET event_round_id = :event_round_id,
								flight_type_id = :ftype_id,
								event_round_flight_score = 1
						");
						$result3 = db_exec($stmt,array("event_round_id" => $event_round_id,"ftype_id" => $ftype_id));
					}
				}
			}
		}
		# If there was a change of flight type, then lets update the flights
		if($flight_type_id != $event->rounds[$event_round_number]['flight_type_id'] && $flight_type_id != 0){
			$stmt = db_prep("
				UPDATE event_round_flight
				SET flight_type_id = :flight_type_id,
					event_round_flight_score = 1
				WHERE event_round_id = :event_round_id
			");
			$result2 = db_exec($stmt,array("event_round_id" => $event_round_id,"flight_type_id" => $flight_type_id));
		}
	}
	sub_trace();

	# Now lets save the pilot flight info
	# Lets build the data grid
	$data = array();
	foreach($_REQUEST as $key => $value){
		if(preg_match("/^pilot_sub_flight_(\d+)\_(\d+)\_(\d+)\_(\d+)$/",$key,$match)){
			$sub = $match[1];
			$event_pilot_round_flight_id = $match[2];
			$event_pilot_id = $match[3];
			$flight_type_id = $match[4];
			# Now lets massage the value to make sure its entered in colon notation, or insert the colons if it is an f3k event
			if($event_code != 'f3f_speed' && $event_code != 'f3f_plus'){
				$value = convert_string_to_colon($value, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
			}
			# Lets check to see if this sub flight has a max set up and change it if it does
			if($flight_type['flight_type_sub_flights_max_time'] != 0){
				$seconds = convert_colon_to_seconds($value, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
				if($seconds>$flight_type['flight_type_sub_flights_max_time']){
					$seconds = $flight_type['flight_type_sub_flights_max_time'];
				}
				$value = convert_seconds_to_colon($seconds, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
			}
			$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub'][$sub] = $value;
		}elseif(preg_match("/^pilot_reflight_sub_flight_(\d+)\_(\d+)\_(\d+)\_(\d+)$/",$key,$match)){
			$sub = $match[1];
			$event_pilot_round_flight_id = $match[2];
			$event_pilot_id = $match[3];
			$flight_type_id = $match[4];
			# Now lets massage the value to make sure its entered in colon notation, or insert the colons
			if($event_code != 'f3f_speed' && $event_code != 'f3f_plus'){
				$value = convert_string_to_colon($value, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
			}
			# Lets check to see if this sub flight has a max set up and change it if it does
			if($flight_type['flight_type_sub_flights_max_time'] != 0){
				$seconds = convert_colon_to_seconds($value, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
				if($seconds>$flight_type['flight_type_sub_flights_max_time']){
					$seconds = $flight_type['flight_type_sub_flights_max_time'];
				}
				$value = convert_seconds_to_colon($seconds, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
			}
			$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub'][$sub] = $value;
			$data[$event_pilot_round_flight_id]['reflight'] = 1;
		}elseif(preg_match("/^pilot_reflight_(\S+)\_(\d+)\_(\d+)\_(\d+)$/",$key,$match)){
			$field = $match[1];
			$event_pilot_round_flight_id = $match[2];
			$event_pilot_id = $match[3];
			$flight_type_id = $match[4];
			if($value == 'on'){
				$value = 1;
			}
			# Replace commas with periods
			$value = preg_replace("/,/",'.',$value);
			$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id][$field] = $value;
			$data[$event_pilot_round_flight_id]['reflight'] = 1;
		}elseif(preg_match("/^pilot_(\S+)\_(\d+)\_(\d+)\_(\d+)$/",$key,$match)){
			$field = $match[1];
			$event_pilot_round_flight_id = $match[2];
			$event_pilot_id = $match[3];
			$flight_type_id = $match[4];
			if($value == 'on'){
				$value = 1;
			}
			$value = preg_replace("/,/",'.',$value);
			$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id][$field] = $value;
		}
	}
	
	# Lets total up the subflights to calculate the full flight time
	if($flight_type['flight_type_sub_flights'] != 0){
		# It has sub flights
		foreach($data as $event_pilot_round_flight_id => $p){
			foreach($p as $event_pilot_id => $f){
				if(is_array($f)){
					foreach($f as $flight_type_id => $v){
						$tot = 0;
						if($flight_type['flight_type_code'] != 'f3f_plus'){ # Ignore the f3f_plus sub flights
							foreach($v['sub'] as $num => $t){
								$tot = $tot + convert_colon_to_seconds($t, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
							}
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['min'] = floor($tot/60);
							$format_string = '%02.' . $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy") . 'f';
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sec'] = sprintf( $format_string, fmod($tot,60));
						}
					}
				}
			}
		}
		# Lets check for 1234 round to truncate properly the times
		if($flight_type['flight_type_code'] == 'f3k_h'){
			# Its a 1234 flight
			# So we need to sort the times by max to min, then truncate to the max times
			foreach($data as $event_pilot_round_flight_id => $p){
				foreach($p as $event_pilot_id => $f){
					if(is_array($f)){
						foreach($f as $flight_type_id => $v){
							$tot = 0;
							$temp_sub = array();
							foreach($v['sub'] as $num => $t){
								$temp_sub[] = convert_colon_to_seconds($t, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
							}
							sort($temp_sub);
							if($temp_sub[0]>60){
								$temp_sub[0] = 60;
							}
							if($temp_sub[1]>120){
								$temp_sub[1] = 120;
							}
							if($temp_sub[2]>180){
								$temp_sub[2] = 180;
							}
							if($temp_sub[3]>240){
								$temp_sub[3] = 240;
							}					
							$tot = $temp_sub[0]+$temp_sub[1]+$temp_sub[2]+$temp_sub[3];
							
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['1'] = convert_seconds_to_colon($temp_sub[0], $event->find_option_value("f3k_duration_accuracy"));
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['2'] = convert_seconds_to_colon($temp_sub[1], $event->find_option_value("f3k_duration_accuracy"));
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['3'] = convert_seconds_to_colon($temp_sub[2], $event->find_option_value("f3k_duration_accuracy"));
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['4'] = convert_seconds_to_colon($temp_sub[3], $event->find_option_value("f3k_duration_accuracy"));
							
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['min'] = floor($tot/60);
							$format_string = '%02.' . $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy") . 'f';
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sec'] = sprintf($format_string,fmod($tot,60));
						}
					}
				}
			}
		}
		# Lets check for 357 round to truncate properly the times
		if($flight_type['flight_type_code'] == 'f3k_m'){
			# Its a 357 flight
			# So we need to sort the times by max to min, then truncate to the max times
			foreach($data as $event_pilot_round_flight_id => $p){
				foreach($p as $event_pilot_id => $f){
					if(is_array($f)){
						foreach($f as $flight_type_id => $v){
							$tot = 0;
							$temp_sub = array();
							foreach($v['sub'] as $num => $t){
								$temp_sub[] = convert_colon_to_seconds($t, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
							}
							if($temp_sub[0]>180){
								$temp_sub[0] = 180;
							}
							if($temp_sub[1]>300){
								$temp_sub[1] = 300;
							}
							if($temp_sub[2]>420){
								$temp_sub[2] = 420;
							}
							$tot = $temp_sub[0]+$temp_sub[1]+$temp_sub[2];
							
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['1'] = convert_seconds_to_colon($temp_sub[0], $event->find_option_value("f3k_duration_accuracy"));
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['2'] = convert_seconds_to_colon($temp_sub[1], $event->find_option_value("f3k_duration_accuracy"));
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['3'] = convert_seconds_to_colon($temp_sub[2], $event->find_option_value("f3k_duration_accuracy"));
							
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['min'] = floor($tot/60);
							$format_string = '%02.' . $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy") . 'f';
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sec'] = sprintf($format_string,fmod($tot,60));
						}
					}
				}
			}
		}
		# Lets check for Big Ladder round to truncate properly the times
		if($flight_type['flight_type_code'] == 'f3k_k'){
			# Its a Big Ladder flight
			# So we need to truncate to the max times
			foreach($data as $event_pilot_round_flight_id => $p){
				foreach($p as $event_pilot_id => $f){
					if(is_array($f)){
						foreach($f as $flight_type_id => $v){
							$tot = 0;
							$temp_sub = array();
							foreach($v['sub'] as $num => $t){
								$temp_sub[] = convert_colon_to_seconds($t, $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy"));
							}
							if($temp_sub[0]>60){
								$temp_sub[0] = 60;
							}
							if($temp_sub[1]>90){
								$temp_sub[1] = 90;
							}
							if($temp_sub[2]>120){
								$temp_sub[2] = 120;
							}
							if($temp_sub[3]>150){
								$temp_sub[3] = 150;
							}
							if($temp_sub[4]>180){
								$temp_sub[4] = 180;
							}
							$tot = $temp_sub[0]+$temp_sub[1]+$temp_sub[2]+$temp_sub[3]+$temp_sub[4];
							
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['1'] = convert_seconds_to_colon($temp_sub[0], $event->find_option_value("f3k_duration_accuracy"));
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['2'] = convert_seconds_to_colon($temp_sub[1], $event->find_option_value("f3k_duration_accuracy"));
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['3'] = convert_seconds_to_colon($temp_sub[2], $event->find_option_value("f3k_duration_accuracy"));
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['4'] = convert_seconds_to_colon($temp_sub[3], $event->find_option_value("f3k_duration_accuracy"));
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sub']['5'] = convert_seconds_to_colon($temp_sub[4], $event->find_option_value("f3k_duration_accuracy"));
							
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['min'] = floor($tot/60);
							$format_string = '%02.' . $event->find_option_value($event->info['event_type_code'] . "_duration_accuracy") . 'f';
							$data[$event_pilot_round_flight_id][$event_pilot_id][$flight_type_id]['sec'] = sprintf($format_string,fmod($tot,60));
						}
					}
				}
			}
		}
		
	}

	# Lets do a query to get existing event_pilot_round_id's so we don't have to do it in the loop
	$eprs = array();
	$stmt = db_prep("
		SELECT *
		FROM event_pilot_round epr
		WHERE epr.event_round_id = :event_round_id
	");
	$result = db_exec($stmt,array("event_round_id" => $event_round_id));
	foreach($result as $epr){
		$event_pilot_id = $epr['event_pilot_id'];
		$eprs[$event_pilot_id] = $epr['event_pilot_round_id'];
	}
	# Lets do a query to get existing event_pilot_round_flights so we don't have to do it in the loop
	$eprfs = array();
	$eprfs_actual = array();
	$stmt = db_prep("
		SELECT *
		FROM event_pilot_round_flight erf
		LEFT JOIN event_pilot_round epr ON epr.event_pilot_round_id = erf.event_pilot_round_id
		WHERE epr.event_round_id = :event_round_id
	");
	$result = db_exec($stmt,array("event_round_id" => $event_round_id));
	foreach($result as $eprf){
		$event_pilot_round_id = $eprf['event_pilot_round_id'];
		$flight_type_id = $eprf['flight_type_id'];
		$event_pilot_round_flight_group = $eprf['event_pilot_round_flight_group'];
		$event_pilot_round_flight_reflight = $eprf['event_pilot_round_flight_reflight'];
		$event_pilot_round_flight_id = $eprf['event_pilot_round_flight_id'];
		$eprfs[$event_pilot_round_id][$flight_type_id][$event_pilot_round_flight_group] = $eprf['event_pilot_round_flight_id'];
		$eprfs_actual[$event_pilot_round_flight_id] = 1;
	}
		
	# Now step through each one and save the flight record
	foreach($data as $event_pilot_round_flight_id => $p){
		foreach($p as $event_pilot_id => $f){
			if(is_array($f)){
				foreach($f as $flight_type_id => $v){
	
					if(!isset($eprs[$event_pilot_id])){
						# Event round doesn't exist, so lets create one
						$stmt = db_prep("
							INSERT INTO event_pilot_round
							SET event_pilot_id = :event_pilot_id,
								event_round_id = :event_round_id
						");
						$result2 = db_exec($stmt,array("event_round_id" => $event_round_id,"event_pilot_id" => $event_pilot_id));
						$event_pilot_round_id = $GLOBALS['last_insert_id'];
					}else{
						$event_pilot_round_id = $eprs[$event_pilot_id];
					}
	
					# Now lets check if this is a new one or not
					if($event_pilot_round_flight_id == 0){
						# This record is a new one (maybe)
						# Lets check if one already exists from the auto save feature
						if($p['reflight'] == 1){
							$stmt = db_prep("
								SELECT *
								FROM event_pilot_round_flight erf
								WHERE erf.event_pilot_round_id = :event_pilot_round_id
									AND erf.flight_type_id = :flight_type_id
									AND erf.event_pilot_round_flight_reflight = 1
							");
						}else{
							$stmt = db_prep("
								SELECT *
								FROM event_pilot_round_flight erf
								WHERE erf.event_pilot_round_id = :event_pilot_round_id
									AND erf.flight_type_id = :flight_type_id
							");
						}
						$result = db_exec($stmt,array(
							"event_pilot_round_id" => $event_pilot_round_id,
							"flight_type_id" => $flight_type_id
						));
						if(isset($result[0])){
							$event_pilot_round_flight_id_actual = $result[0]['event_pilot_round_flight_id'];
						}else{
							$event_pilot_round_flight_id_actual = 0;
						}
					}else{
						$event_pilot_round_flight_id_actual = $event_pilot_round_flight_id;
					}
					
					# Lets see if the values are DNS or DNF and set the parameters
					$dns = 0;
					$dnf = 0;
					if( strtolower( $v['sec'] ) == 'dns' || strtolower( $v['position'] ) == 'dns' ){
						$dns = 1;
						$v['sec'] = 0;
						$v['position'] = 0;
					}
					if( strtolower( $v['sec'] ) == 'dnf' || strtolower( $v['position'] ) == 'dnf' ){
						$dnf = 1;
						$v['sec'] = 0;
						$v['position'] = 0;
					}
					
					# Lets see if this flight already exists
					if(isset($eprfs_actual[$event_pilot_round_flight_id_actual])){
						# There is already a record, so save this one
						$stmt = db_prep("
							UPDATE event_pilot_round_flight
							SET event_pilot_round_flight_group = :event_pilot_round_flight_group,
								event_pilot_round_flight_minutes = :event_pilot_round_flight_minutes,
								event_pilot_round_flight_seconds = :event_pilot_round_flight_seconds,
								event_pilot_round_flight_start_penalty = :event_pilot_round_flight_start_penalty,
								event_pilot_round_flight_start_height = :event_pilot_round_flight_start_height,
								event_pilot_round_flight_over = :event_pilot_round_flight_over,
								event_pilot_round_flight_laps = :event_pilot_round_flight_laps,
								event_pilot_round_flight_position = :event_pilot_round_flight_position,
								event_pilot_round_flight_landing = :event_pilot_round_flight_landing,
								event_pilot_round_flight_order = :event_pilot_round_flight_order,
								event_pilot_round_flight_lane = :event_pilot_round_flight_lane,
								event_pilot_round_flight_dns = :event_pilot_round_flight_dns,
								event_pilot_round_flight_dnf = :event_pilot_round_flight_dnf,
								event_pilot_round_flight_penalty = :event_pilot_round_flight_penalty,
								event_pilot_round_flight_status = 1
							WHERE event_pilot_round_flight_id = :event_pilot_round_flight_id
						");
						$result2 = db_exec($stmt,array(
							"event_pilot_round_flight_id"				=> $event_pilot_round_flight_id_actual,
							"event_pilot_round_flight_group"			=> strtoupper($v['group']),
							"event_pilot_round_flight_minutes"			=> $v['min'],
							"event_pilot_round_flight_seconds"			=> $v['sec'],
							"event_pilot_round_flight_start_penalty"	=> $v['startpen'],
							"event_pilot_round_flight_start_height"		=> $v['startheight'],
							"event_pilot_round_flight_over"				=> $v['over'],
							"event_pilot_round_flight_laps"				=> $v['laps'],
							"event_pilot_round_flight_position"			=> $v['position'],
							"event_pilot_round_flight_landing"			=> $v['land'],
							"event_pilot_round_flight_order"			=> $v['order'],
							"event_pilot_round_flight_lane"				=> $v['lane'],
							"event_pilot_round_flight_dns"				=> $dns,
							"event_pilot_round_flight_dnf"				=> $dnf,
							"event_pilot_round_flight_penalty"			=> $v['pen']
						));
					}else{
						# There isn't a record, so lets create a new one
						$stmt = db_prep("
							INSERT INTO event_pilot_round_flight
							SET event_pilot_round_id = :event_pilot_round_id,
								flight_type_id = :flight_type_id,
								event_pilot_round_flight_group = :event_pilot_round_flight_group,
								event_pilot_round_flight_minutes = :event_pilot_round_flight_minutes,
								event_pilot_round_flight_seconds = :event_pilot_round_flight_seconds,
								event_pilot_round_flight_start_penalty = :event_pilot_round_flight_start_penalty,
								event_pilot_round_flight_start_height = :event_pilot_round_flight_start_height,
								event_pilot_round_flight_over = :event_pilot_round_flight_over,
								event_pilot_round_flight_laps = :event_pilot_round_flight_laps,
								event_pilot_round_flight_position = :event_pilot_round_flight_position,
								event_pilot_round_flight_landing = :event_pilot_round_flight_landing,
								event_pilot_round_flight_order = :event_pilot_round_flight_order,
								event_pilot_round_flight_lane = :event_pilot_round_flight_lane,
								event_pilot_round_flight_dns = :event_pilot_round_flight_dns,
								event_pilot_round_flight_dnf = :event_pilot_round_flight_dnf,
								event_pilot_round_flight_penalty = :event_pilot_round_flight_penalty,
								event_pilot_round_flight_status = 1
						");
						$result2 = db_exec($stmt,array(
							"event_pilot_round_id"						=> $event_pilot_round_id,
							"flight_type_id"							=> $flight_type_id,
							"event_pilot_round_flight_group"			=> strtoupper($v['group']),
							"event_pilot_round_flight_minutes"			=> $v['min'],
							"event_pilot_round_flight_seconds"			=> $v['sec'],
							"event_pilot_round_flight_start_penalty"	=> $v['startpen'],
							"event_pilot_round_flight_start_height"		=> $v['startheight'],
							"event_pilot_round_flight_over"				=> $v['over'],
							"event_pilot_round_flight_laps"				=> $v['laps'],
							"event_pilot_round_flight_position"			=> $v['position'],
							"event_pilot_round_flight_landing"			=> $v['land'],
							"event_pilot_round_flight_order"			=> $v['order'],
							"event_pilot_round_flight_lane"				=> $v['lane'],
							"event_pilot_round_flight_dns"				=> $dns,
							"event_pilot_round_flight_dnf"				=> $dnf,
							"event_pilot_round_flight_penalty"			=> $v['pen']
						));
						$event_pilot_round_flight_id_actual = $GLOBALS['last_insert_id'];
					}
					
					# lets save the sub flights now if there are any
					if(isset($v['sub'])){
						# There are sub flights, so lets save them
						foreach($v['sub'] as $num => $t){
							# Lets see if one exists already
							$stmt = db_prep("
								SELECT *
								FROM event_pilot_round_flight_sub erfs
								WHERE erfs.event_pilot_round_flight_id = :event_pilot_round_flight_id
									AND erfs.event_pilot_round_flight_sub_num = :num
							");
							$result = db_exec($stmt,array(
								"event_pilot_round_flight_id"	=> $event_pilot_round_flight_id_actual,
								"num"							=> $num
							));
							if(isset($result[0])){
								$event_pilot_round_flight_sub_id = $result[0]['event_pilot_round_flight_sub_id'];
							}else{
								$event_pilot_round_flight_sub_id = 0;
							}
							if($event_pilot_round_flight_sub_id == 0){
								# Create a new record
								$stmt = db_prep("
									INSERT INTO event_pilot_round_flight_sub
									SET event_pilot_round_flight_id = :event_pilot_round_flight_id,
										event_pilot_round_flight_sub_num = :num,
										event_pilot_round_flight_sub_val = :val
								");
								$result = db_exec($stmt,array(
									"event_pilot_round_flight_id"	=> $event_pilot_round_flight_id_actual,
									"num"							=> $num,
									"val"							=> $t
								));
							}else{
								# Save the existing record
								$stmt = db_prep("
									UPDATE event_pilot_round_flight_sub
									SET event_pilot_round_flight_sub_val = :val
									WHERE event_pilot_round_flight_sub_id = :event_pilot_round_flight_sub_id
								");
								$result = db_exec($stmt,array(
									"event_pilot_round_flight_sub_id"	=> $event_pilot_round_flight_sub_id,
									"val"								=> $t
								));
							}
						}
					}
				}
			}
		}
	}
	# OK, now lets call the routine to do the calculation for a single round
	sub_trace();

	# First, since we saved the data, reset the $event object
	$event = new Event($event_id);
	$event->calculate_round($event_round_number);
	# Now lets recalculate and save the event total info
	# Refresh the round info
	$event->get_rounds();
	$event->event_save_totals();

	log_action($event_round_id);

	if($create_new_round == 1){
		#This means they want to save the round and create a new one
		user_message("Saved round and created the next one.");
		$_REQUEST['event_round_id'] = 0;
		$_REQUEST['zero_round'] = 0;
		$_REQUEST['flyoff_round'] = 0;
		return event_round_edit();
	}
	
	user_message("Saved event round info.");
	return event_round_edit();
}
function event_round_add_reflight() {
	# Function to remove a reflight flight
	$event_id = intval($_REQUEST['event_id']);
	$event_round_id = intval($_REQUEST['event_round_id']);
	$flight_type_id = intval($_REQUEST['flight_type_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);
	$event_round_number = $_REQUEST['event_round_number'];
	$group = strtoupper($_REQUEST['group']);
	
	# Need to find the event_pilot_round_id from the info given
	$stmt = db_prep("
		SELECT *
		FROM event_pilot_round
		WHERE event_pilot_id = :event_pilot_id
		AND event_round_id = :event_round_id
	");
	$result = db_exec($stmt,array("event_pilot_id" => $event_pilot_id,"event_round_id" => $event_round_id));
	if(isset($result[0])){
		$event_pilot_round_id = $result[0]['event_pilot_round_id'];	
		# Now Lets create this record
		$stmt = db_prep("
			INSERT INTO event_pilot_round_flight
			SET event_pilot_round_id = :event_pilot_round_id,
				flight_type_id = :flight_type_id,
				event_pilot_round_flight_group = :group,
				event_pilot_round_flight_reflight = 1,
				event_pilot_round_flight_status = 1
		");
		$result2 = db_exec($stmt,array(
			"event_pilot_round_id"	=> $event_pilot_round_id,
			"flight_type_id"		=> $flight_type_id,
			"group"					=> $group
		));
	}	
	
	$event = new Event($event_id);
	# Refresh the round info
	$event->get_rounds();
	log_action($event_round_id);
	user_message("Added the reflight entry.");
	return event_round_edit();
}
function event_round_flight_delete() {
	# Function to remove a reflight flight
	$event_id = intval($_REQUEST['event_id']);
	$event_round_id = intval($_REQUEST['event_round_id']);
	$event_pilot_round_flight_id = intval($_REQUEST['event_pilot_round_flight_id']);
	$event_round_number = $_REQUEST['event_round_number'];
	
	# Update to turn off record
	$stmt = db_prep("
		UPDATE event_pilot_round_flight
		SET event_pilot_round_flight_status = 0
		WHERE event_pilot_round_flight_id = :event_pilot_round_flight_id
	");
	$result2 = db_exec($stmt,array(
		"event_pilot_round_flight_id" => $event_pilot_round_flight_id
	));
	
	$event = new Event($event_id);
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
	
	$event_id = intval($_REQUEST['event_id']);
	$event_round_id = intval($_REQUEST['event_round_id']);

	# First, lets save the round info
	$stmt = db_prep("
		UPDATE event_round
		SET event_round_status = 0
		WHERE event_round_id = :event_round_id
	");
	$result = db_exec($stmt,array(
		"event_round_id" => $event_round_id
	));

	# Now lets turn off all the flights in this round
	$stmt = db_prep("
		UPDATE event_pilot_round_flight
		SET event_pilot_round_flight_status = 0
		WHERE event_pilot_round_id IN (SELECT event_pilot_round_id FROM event_pilot_round WHERE event_round_id = :event_round_id)
	");
	$result = db_exec($stmt,array(
		"event_round_id" => $event_round_id
	));

	# Now lets recalculate and save the event total info
	$event = new Event($event_id);
	$event->event_save_totals();
	
	log_action($event_round_id);
	user_message("Deleted Event Round.");
	return event_view();
}
function event_pilot_rounds() {
	global $smarty;
	# Function to view the rounds for a particular pilot
	
	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);

	$event = new Event($event_id);
	$event->get_rounds();
	
	$smarty->assign("event_pilot_id",$event_pilot_id);
	$smarty->assign("event",$event);
	
	$maintpl = find_template("event/event_pilot_view.tpl");
	return $smarty->fetch($maintpl);
}
function save_individual_flight(){
	# Function to save a single score if it has been changed
	
	$event_id = intval($_REQUEST['event_id']);
	$event_round_id = intval($_REQUEST['event_round_id']);
	$event_round_number = $_REQUEST['event_round_number'];
	$event_round_time_choice = $_REQUEST['event_round_time_choice'];
	$event_round_score_status = $_REQUEST['event_round_score_status'];
	$event_round_time_choice = $_REQUEST['event_round_time_choice'];
	$flight_type_id = $_REQUEST['flight_type_id'];
	$field_name = $_REQUEST['field_name'];
	$field_value = $_REQUEST['field_value'];
	if($event_round_score_status == 'on' || $event_round_score_status == 1){
		$event_round_score_status = 1;
	}else{
		$event_round_score_status = 0;
	}
	
	# Lets get the info from the field being saved
	if(preg_match("/^pilot_(\S+)\_(\d+)\_(\d+)_(\d+)$/",$field_name,$match)){
		$field = $match[1];
		$event_pilot_round_flight_id = $match[2];
		$event_pilot_id = $match[3];
		$event_round_flight_type_id = $match[4];
		if($field_value == 'on'){
			$field_value = 1;
		}
		$field_value = preg_replace("/,/",'.',$field_value);
	}
	if(preg_match("/^pilot_reflight_(\S+)\_(\d+)\_(\d+)_(\d+)$/",$field_name,$match)){
		$field = $match[1];
		$event_pilot_round_flight_id = $match[2];
		$event_pilot_id = $match[3];
		$event_round_flight_type_id = $match[4];
		if($field_value == 'on'){
			$field_value = 1;
		}
		$field_value = preg_replace("/,/",'.',$field_value);
	}

	# Lets determine if we need to create a new event round record first
	if($event_round_id == 0){
		# Lets see if it already exists
		$stmt = db_prep("
			SELECT *
			FROM event_round
			WHERE event_id = :event_id
			AND event_round_number = :event_round_number
			AND event_round_status = 1
		");
		$result = db_exec($stmt,array("event_id" => $event_id,"event_round_number" => $event_round_number));
		if(isset($result[0])){
			$event_round_id = $result[0]['event_round_id'];
			# Need to update it to say that it needs calculation
			$stmt = db_prep("
				UPDATE event_round
				SET event_round_needs_calc = 1,
					event_round_time_choice = :event_round_time_choice,
					event_round_score_status = :event_round_score_status,
					flight_type_id = :flight_type_id
				WHERE event_round_id = :event_round_id
			");
			$result = db_exec($stmt,array(
				"event_round_id"			=> $event_round_id,
				"event_round_time_choice"	=> $event_round_time_choice,
				"event_round_score_status"	=> $event_round_score_status,
				"flight_type_id"			=> $flight_type_id
			));
		}else{
			# New round, so lets create
			$stmt = db_prep("
				INSERT INTO event_round
				SET event_id = :event_id,
					event_round_number = :event_round_number,
					flight_type_id = :flight_type_id,
					event_round_time_choice = :event_round_time_choice,
					event_round_score_status = :event_round_score_status,
					event_round_needs_calc = 1,
					event_round_status = 1
			");
			$result = db_exec($stmt,array(
				"event_id"					=> $event_id,
				"event_round_number"		=> $event_round_number,
				"flight_type_id"			=> $flight_type_id,
				"event_round_time_choice"	=> $event_round_time_choice,
				"event_round_score_status"	=> $event_round_score_status
			));
			$event_round_id = $GLOBALS['last_insert_id'];
			# Lets also create a new event_round_flight that is set to on
			$stmt = db_prep("
				INSERT INTO event_round_flight
				SET event_round_id = :event_round_id,
					flight_type_id = :flight_type_id,
					event_round_flight_score = 1
			");
			$result2 = db_exec($stmt,array("event_round_id" => $event_round_id,"flight_type_id" => $event_round_flight_type_id));
		}
	}else{
		# Set this round to be calculated
		$stmt = db_prep("
			UPDATE event_round
			SET event_round_needs_calc = 1,
				event_round_time_choice = :event_round_time_choice,
				event_round_score_status = :event_round_score_status,
				flight_type_id = :flight_type_id
			WHERE event_round_id = :event_round_id
		");
		$result = db_exec($stmt,array(
			"event_round_id"			=> $event_round_id,
			"event_round_time_choice"	=> $event_round_time_choice,
			"event_round_score_status"	=> $event_round_score_status,
			"flight_type_id"			=> $flight_type_id
		));
	}
	
	# Lets see if the values are DNS or DNF and set the parameters
	$dns = 0;
	$dnf = 0;

	# Make the set line based on the type
	switch($field){
		case "group":
			$setline = 'event_pilot_round_flight_group = :value';
			$field_value = strtoupper($field_value);
			break;
		case "min":
			$setline = 'event_pilot_round_flight_minutes = :value';
			break;
		case "sec":
			if(strtolower($field_value) == 'dns'){
				$dns = 1;
				$field_value = 0;
			}
			if(strtolower($field_value) == 'dnf'){
				$dnf = 1;
				$field_value = 0;
			}
			$setline = 'event_pilot_round_flight_seconds = :value ';
			break;
		case "startheight":
			$setline = 'event_pilot_round_flight_start_height = :value';
			break;
		case "over":
			$setline = 'event_pilot_round_flight_over = :value';
			break;
		case "laps":
			$setline = 'event_pilot_round_flight_laps = :value';
			break;
		case "position":
			$setline = 'event_pilot_round_flight_position = :value';
			break;
		case "order":
			$setline = 'event_pilot_round_flight_order = :value';
			break;
		case "land":
			$setline = 'event_pilot_round_flight_landing = :value';
			break;
		case "pen":
			$setline = 'event_pilot_round_flight_penalty = :value';
			break;
	}
	
	# Now step through each one and save the flight record
	if($event_pilot_round_flight_id == 0){
		# This flight doesnt yet exist, so lets create it
		# We need to get the event_pilot_round_id
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_round epr
			WHERE epr.event_round_id = :event_round_id
				AND epr.event_pilot_id = :event_pilot_id
		");
		$result2 = db_exec($stmt,array("event_round_id" => $event_round_id,"event_pilot_id" => $event_pilot_id));
		if(!isset($result2[0])){
			# Event pilot round doesn't exist, so lets create one
			$stmt = db_prep("
				INSERT INTO event_pilot_round
				SET event_pilot_id = :event_pilot_id,
					event_round_id = :event_round_id
			");
			$result3 = db_exec($stmt,array("event_round_id" => $event_round_id,"event_pilot_id" => $event_pilot_id));
			$event_pilot_round_id = $GLOBALS['last_insert_id'];
		}else{
			$event_pilot_round_id = $result2[0]['event_pilot_round_id'];
		}
		# Now we need to see if a round flight already exists...sheesh
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_round_flight
			WHERE event_pilot_round_id = :event_pilot_round_id
			AND flight_type_id = :flight_type_id
			AND event_pilot_round_flight_status = 1
		");
		$result2 = db_exec($stmt,array(
			"event_pilot_round_id"	=> $event_pilot_round_id,
			"flight_type_id"		=> $event_round_flight_type_id
		));
		if(isset($result2[0])){
			# This one already exists, so lets update it
			$stmt = db_prep("
				UPDATE event_pilot_round_flight
				SET $setline,
					event_pilot_round_flight_status = 1
				WHERE event_pilot_round_flight_id = :event_pilot_round_flight_id
			");
			$result3 = db_exec($stmt,array(
				"event_pilot_round_flight_id"	=> $result2[0]['event_pilot_round_flight_id'],
				"value"							=> $field_value
			));
		}else{
			$stmt = db_prep("
				INSERT INTO event_pilot_round_flight
				SET event_pilot_round_id = :event_pilot_round_id,
					flight_type_id = :flight_type_id,
					$setline,
					event_pilot_round_flight_dns = :dns,
					event_pilot_round_flight_dnf = :dnf,
					event_pilot_round_flight_status = 1
			");
			$result2 = db_exec($stmt,array(
				"event_pilot_round_id"	=> $event_pilot_round_id,
				"flight_type_id"		=> $event_round_flight_type_id,
				"value"					=> $field_value,
				"dns"					=> $dns,
				"dnf"					=> $dnf
			));
		}
	}else{
		# This flight already existed
		# So lets save it
		$stmt = db_prep("
			UPDATE event_pilot_round_flight
			SET $setline,
				event_pilot_round_flight_dns = :dns,
				event_pilot_round_flight_dnf = :dnf,
				event_pilot_round_flight_status = 1
			WHERE event_pilot_round_flight_id = :event_pilot_round_flight_id
		");
		$result2 = db_exec($stmt,array(
			"event_pilot_round_flight_id"	=> $event_pilot_round_flight_id,
			"value"							=> $field_value,
			"dns"							=> $dns,
			"dnf"							=> $dnf
		));
	}
	return;
}

# Print Routines
function event_print_overall() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$full = intval($_REQUEST['full']);
	if($event_id == 0){
		user_message("That is not a proper event id to print.");
		return event_list();
	}
	
	$e = new Event($event_id);
	$e->get_rounds();
	$e->calculate_event_totals();

	$smarty->assign("event",$e);

	if($full == 1){
		$maintpl = find_template("print/print_event_overall_full.tpl");
	}else{
		$maintpl = find_template("print/print_event_overall.tpl");
	}
	return $smarty->fetch($maintpl);
}
function event_print_rank() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	if($event_id == 0){
		user_message("That is not a proper event id to print.");
		return event_edit();
	}
	
	$event_view = event_view();
	
	$maintpl = find_template("print/print_event_rankings.tpl");
	return $smarty->fetch($maintpl);
}
function event_print_round() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	if($event_id == 0){
		user_message("That is not a proper event id to print.");
		return event_list();
	}
	$round_from = $_REQUEST['round_start_number'];
	$round_to = $_REQUEST['round_end_number'];
	$one_per_page = 0;
	if(isset($_REQUEST['oneper']) && $_REQUEST['oneper'] == 'on'){
		$one_per_page = 1;
	}
	
	$e = new Event($event_id);
	$e->get_rounds();

	$smarty->assign("event",$e);
	$smarty->assign("round_from",$round_from);
	$smarty->assign("round_to",$round_to);
	$smarty->assign("one_per_page",$one_per_page);
	
	$maintpl = find_template("print/print_event_rounds.tpl");
	return $smarty->fetch($maintpl);
}
function event_print_pilot_list() {
	global $smarty;
	# Function to print the event pilot list
	
	$event_id = intval($_REQUEST['event_id']);

	$event = new Event($event_id);
	
	$smarty->assign("event",$event);
	
	$maintpl = find_template("print/print_event_pilot_list.tpl");
	return $smarty->fetch($maintpl);
}
function event_print_pilot() {
	global $smarty;
	# Function to view the rounds for a particular pilot
	
	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);

	$event = new Event($event_id);
	$event->get_rounds();
	
	$smarty->assign("event_pilot_id",$event_pilot_id);
	$smarty->assign("event",$event);
	
	$maintpl = find_template("print/print_event_pilot_view.tpl");
	return $smarty->fetch($maintpl);
}
function event_print_position_chart() {
	global $smarty;
	# Function to print out the position chart
	
	$event_id = intval($_REQUEST['event_id']);

	$e = new Event($event_id);
	$e->get_rounds();
	$e->get_draws();
	$e->calculate_event_totals();
	$e->get_running_totals();
	
	$smarty->assign("event",$e);
	
	$maintpl = find_template("print/print_event_position_chart.tpl");
	return $smarty->fetch($maintpl);
}
function event_print_stats() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	if($event_id == 0){
		user_message("That is not a proper event id to edit.");
		return event_list();
	}
	$event_view = event_view();
	
	$maintpl = find_template("print/print_event_stats.tpl");
	return $smarty->fetch($maintpl);
}

# Draw Routines
function event_draw() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$e = new Event($event_id);
	$e->get_teams();
	$e->get_rounds();
	$e->get_draws();
	
	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	
	$smarty->assign("event",$e);
	
	# Lets determine the round #'s to print for the draw from the existing rounds to the max on the draws
	$print_rounds = array();

	foreach($e->draws as $d){
		if($d['event_draw_active'] != 1){
			continue;
		}
		$min = 1;
		$max = 0;
		if($d['event_draw_round_to']<$min){
			$min = $d['event_draw_round_from'];
		}
		if($d['event_draw_round_to']>$max){
			$max = $d['event_draw_round_to'];
		}
		$ft = $d['flight_type_id'];
		$print_rounds[$ft] = array("min" => $min,"max" => $max);
	}
	# Now lets step through the rounds and see if its a different max
	$num_rounds = count($e->rounds);
	foreach($e->flight_types as $flight_type_id => $ft){
		if($print_rounds[$flight_type_id]['max']<count($e->rounds)){
			$print_rounds[$flight_type_id]['max'] = count($e->rounds);
			$print_rounds[$flight_type_id]['min'] = 1;
		}
	}
	
	$smarty->assign("print_rounds",$print_rounds);

	$maintpl = find_template("event/event_draw.tpl");
	return $smarty->fetch($maintpl);
}
function event_draw_edit() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_draw_id = intval($_REQUEST['event_draw_id']);
	$flight_type_id = intval($_REQUEST['flight_type_id']);
	$highlight = $_REQUEST['highlight'];

	$e = new Event($event_id);
	$e->get_teams();

	$draw = array();
	if($event_draw_id != 0){
		include_library('draw.class');
		$draw = new Draw($event_draw_id);
	}
	# Get flight type info
	$ft = array();
	$stmt = db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id = :flight_type_id
	");
	$result = db_exec($stmt,array("flight_type_id" => $flight_type_id));
	$ft = $result[0];

	$draw_pilots = array();
	$draw_teams = array();
	foreach($e->pilots as $p){
		if($p['event_pilot_draw_status'] == 1){
			$draw_pilots[] = $p;
			$team = $p['event_pilot_team'];
			if(!in_array($team,$draw_teams)){
				$draw_teams[] = $team;
			}
		}
	}

	$num_teams = count($draw_teams);
	$min_groups_np = 1;
	$max_groups_np = floor(count($draw_pilots)/2);
	
	# Lets determine the largest team
	foreach($draw_pilots as $p){
		$team_name = $p['event_pilot_team'];
		if($team_name != ''){
			$teams[$team_name]++;
		}
	}
	arsort($teams);
	$max_on_team = array_shift($teams);
	$min_groups_p = $max_on_team;
	$max_groups_p = floor(count($draw_pilots)/2);

	# Lets create the event round array so that we can show the full draw for editing manually
	# Now lets get the draw rounds
	$drawrounds = array();
	$sort_string = '';
	if($ft['flight_type_group'] == 1){
		$sort_string = 'event_draw_round_number,event_draw_round_group+0<>0,event_draw_round_group+0,event_draw_round_group,event_draw_round_lane';
	}else{
		$sort_string = 'event_draw_round_number,event_draw_round_order';
	}
	
	# lets get all the entries for this draw, and only update the ones that dont match
	$stmt = db_prep("
		SELECT *
		FROM event_draw_round 
		WHERE event_draw_id = :event_draw_id
			AND event_draw_round_status = 1
		ORDER BY $sort_string
	");
	$rounds = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	foreach($rounds as $round){
		$round_number = $round['event_draw_round_number'];
		$event_pilot_id = $round['event_pilot_id'];
		$drawrounds['rounds']['flights'][$flight_type_id][$round_number]['pilots'][$event_pilot_id] = $round;
	}
	# Lets set the round flight types from the task list
	$draw_round_flight_types = array();	
	foreach($e->tasks as $round => $t){
		$draw_round_flight_types[$round] = $t['flight_type_id'];
	}

	# Lets add the rounds that don't exist with the draw values for printing
	# Step through any existing rounds and use those
	for($event_round_number = $draw->draw['event_draw_round_from'];$event_round_number <= $draw->draw['event_draw_round_to'];$event_round_number++){
		if(!isset($e->rounds[$event_round_number])){
			# Lets create the event round and enough info from the draw to print
			#Step through the draw rounds and see if one exists for this round
			foreach($drawrounds['rounds']['flights'] as $flight_type_id => $f){
				foreach($f as $round_num => $v){
					if($round_num == $event_round_number){
						# Lets create the round info
						$e->rounds[$event_round_number]['event_round_number'] = $event_round_number;
						$e->rounds[$event_round_number]['event_round_status'] = 1;
						if($e->info['event_type_code'] == 'f3k'){
							$e->rounds[$event_round_number]['flight_type_id'] = $draw_round_flight_types[$round_num];
							$flight_type_id = $draw_round_flight_types[$round_num];
						}else{
							$e->rounds[$event_round_number]['flight_type_id'] = $flight_type_id;
						}
						$e->rounds[$event_round_number]['flights'][$flight_type_id] = $e->flight_types[$flight_type_id];
						# Lets try and sort them so they are easier to look at
						foreach($v['pilots'] as $event_pilot_id => $p){
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['flight_type_id'] = $flight_type_id;
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_group'] = $p['event_draw_round_group'];
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_order'] = $p['event_draw_round_order'];
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_lane'] = $p['event_draw_round_lane'];
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['event_round_flight_score'] = 1;
						}
						
						# Now lets add any pilots that are considered active, but are not yet in a draw
						foreach($draw_pilots as $dp){
							$temp_event_pilot_id = $dp['event_pilot_id'];
							if(!isset($e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$temp_event_pilot_id])){
								# Lets set this pilot in the array as a blank
								$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$temp_event_pilot_id]['flight_type_id'] = $flight_type_id;
								$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$temp_event_pilot_id]['event_pilot_round_flight_group'] = '';
								$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$temp_event_pilot_id]['event_pilot_round_flight_order'] = '';
								$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$temp_event_pilot_id]['event_pilot_round_flight_lane'] = '';
							}
						}
					}
				}
			}	
		}
	}

	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);

	$smarty->assign("event",$e);
	$smarty->assign("draw",$draw);
	$smarty->assign("draw_pilots",$draw_pilots);
	$smarty->assign("draw_teams",$draw_teams);
	$smarty->assign("event_id",$event_id);
	$smarty->assign("event_draw_id",$event_draw_id);
	$smarty->assign("ft",$ft);
	$smarty->assign("min_groups_p",$min_groups_p);
	$smarty->assign("max_groups_p",$max_groups_p);
	$smarty->assign("min_groups_np",$min_groups_np);
	$smarty->assign("max_groups_np",$max_groups_np);
	$smarty->assign("highlight",$highlight);

	$maintpl = find_template("event/event_draw_edit.tpl");
	return $smarty->fetch($maintpl);
}
function event_draw_save(){
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_draw_id = intval($_REQUEST['event_draw_id']);
	$flight_type_id = intval($_REQUEST['flight_type_id']);
	$event_draw_round_from = intval($_REQUEST['event_draw_round_from']);
	$event_draw_round_to = intval($_REQUEST['event_draw_round_to']);
	$event_draw_type = $_REQUEST['event_draw_type'];
	$event_draw_number_groups = intval($_REQUEST['event_draw_number_groups']);
	$event_draw_step_size = intval($_REQUEST['event_draw_step_size']);
	$event_draw_changed = intval($_REQUEST['event_draw_changed']);

	$original_event_draw_id = $event_draw_id;
	
	$event_draw_team_protection = 0;
	if(isset($_REQUEST['event_draw_team_protection']) && $_REQUEST['event_draw_team_protection'] == 'on'){
		$event_draw_team_protection = 1;
	}
	$event_draw_team_separation = 0;
	if(isset($_REQUEST['event_draw_team_separation']) && $_REQUEST['event_draw_team_separation'] == 'on'){
		$event_draw_team_separation = 1;
	}
	$recalc = 0;
	if(isset($_REQUEST['recalc']) && $_REQUEST['recalc'] == 'recalc'){
		$recalc = 1;
	}
	
	# Get flight type info
	$ft = array();
	$stmt = db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id = :flight_type_id
	");
	$result = db_exec($stmt,array("flight_type_id" => $flight_type_id));
	$ft = $result[0];
	
	if($event_draw_changed == 1){
		# Lets save the main draw parameters
		if($event_draw_id == 0){
			$stmt = db_prep("
				INSERT INTO event_draw
				SET event_id = :event_id,
					flight_type_id = :flight_type_id,
					event_draw_type = :event_draw_type,
					event_draw_round_from = :event_draw_round_from,
					event_draw_round_to = :event_draw_round_to,
					event_draw_number_groups = :event_draw_number_groups,
					event_draw_step_size = :event_draw_step_size,
					event_draw_team_protection = :event_draw_team_protection,
					event_draw_team_separation = :event_draw_team_separation,
					event_draw_active = 0,
					event_draw_status = 1
			");
			$result = db_exec($stmt,array(
				"event_id"						=> $event_id,
				"flight_type_id"				=> $flight_type_id,
				"event_draw_round_from"			=> $event_draw_round_from,
				"event_draw_round_to"			=> $event_draw_round_to,
				"event_draw_type"				=> $event_draw_type,
				"event_draw_number_groups"		=> $event_draw_number_groups,
				"event_draw_step_size"			=> $event_draw_step_size,
				"event_draw_team_protection"	=> $event_draw_team_protection,
				"event_draw_team_separation"	=> $event_draw_team_separation
			));
			$event_draw_id = $GLOBALS['last_insert_id'];
			$_REQEST['event_draw_id'] = $event_draw_id;
			# If there is no currently active draw, then make this one active
			$stmt = db_prep("
				SELECT *
				FROM event_draw
				WHERE event_id = :event_id
					AND event_draw_status = 1
					AND event_draw_active = 1
			");
			$result = db_exec( $stmt, array( "event_id" => $event_id ) );
			if( count( $result ) == 0 ){
				# Let's make this new one active
				$stmt = db_prep("
					UPDATE event_draw
					SET event_draw_active = 1
					WHERE event_draw_id = :event_draw_id
				");
				$result = db_exec( $stmt, array( "event_draw_id" => $event_draw_id ) );
			}
		}else{
			# Save the existing one
			$stmt = db_prep("
				UPDATE event_draw
				SET event_draw_type = :event_draw_type,
					event_draw_round_from = :event_draw_round_from,
					event_draw_round_to = :event_draw_round_to,
					event_draw_number_groups = :event_draw_number_groups,
					event_draw_step_size = :event_draw_step_size,
					event_draw_team_protection = :event_draw_team_protection,
					event_draw_team_separation = :event_draw_team_separation
				WHERE event_draw_id = :event_draw_id
			");
			$result = db_exec($stmt,array(
				"event_draw_round_from"			=> $event_draw_round_from,
				"event_draw_round_to"			=> $event_draw_round_to,
				"event_draw_type"				=> $event_draw_type,
				"event_draw_number_groups"		=> $event_draw_number_groups,
				"event_draw_step_size"			=> $event_draw_step_size,
				"event_draw_team_protection"	=> $event_draw_team_protection,
				"event_draw_team_separation"	=> $event_draw_team_separation,
				"event_draw_id"					=> $event_draw_id
			));
		}
		
		include_library('draw.class');
		$draw = new Draw($event_draw_id);

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
	
	# We need to save the event_draw_round_flight_type values now
	# First wipe all of the statuses
	$stmt = db_prep("
		UPDATE event_draw_round_flight
		SET event_draw_round_flight_status = 0
		WHERE event_draw_id = :event_draw_id
	");
	$result = db_exec($stmt,array(
		"event_draw_id" => $event_draw_id
	));
	# Now lets step through the input variables
	foreach($_REQUEST as $key => $value){
		if(preg_match("/^round_flight_type_(\d+)$/",$key,$match)){
			$round_number = $match[1];
			# ok, lets see if this one exists already to update it
			$stmt = db_prep("
				SELECT *
				FROM event_draw_round_flight
				WHERE event_draw_id = :event_draw_id
					AND event_draw_round_number = :event_draw_round_number
			");
			$result = db_exec($stmt,array(
				"event_draw_id"				=> $event_draw_id,
				"event_draw_round_number"	=> $round_number
			));
			if(isset($result[0])){
				$id = $result[0]['event_draw_round_flight_id'];
				# This record exists, so lets update it
				$stmt = db_prep("
					UPDATE event_draw_round_flight
					SET flight_type_id = :flight_type_id,
						event_draw_round_flight_status = 1
					WHERE event_draw_round_flight_id = :event_draw_round_flight_id
				");
				$result = db_exec($stmt,array(
					"event_draw_round_flight_id"	=> $id,
					"flight_type_id"				=> $value
				));
			}else{
				# This record doesnt exist, so lets create a new one
				$stmt = db_prep("
					INSERT INTO event_draw_round_flight
					SET event_draw_id = :event_draw_id,
						event_draw_round_number = :event_draw_round_number,
						flight_type_id = :flight_type_id,
						event_draw_round_flight_status = 1
				");
				$result = db_exec($stmt,array(
					"event_draw_id"				=> $event_draw_id,
					"event_draw_round_number"	=> $round_number,
					"flight_type_id"			=> $value
				));
			}
		}
	}
	user_message("Saved Event Draw.");
	return event_draw();
}
function event_draw_apply(){
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_draw_id = intval($_REQUEST['event_draw_id']);
	$flight_type_id = intval($_REQUEST['flight_type_id']);

	# Get flight type info
	$ft = array();
	$stmt = db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id = :flight_type_id
	");
	$result = db_exec($stmt,array("flight_type_id" => $flight_type_id));
	$ft = $result[0];

	# Get draw info
	$draw = array();
	$stmt = db_prep("
		SELECT *
		FROM event_draw
		WHERE event_draw_id = :event_draw_id
	");
	$result = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	$draw = $result[0];
	
	# Lets check to see if this round has overlap with existing active rounds and error out if so
	# Get other active draws for this event
	$other_draws = array();
	$stmt = db_prep("
		SELECT *
		FROM event_draw
		WHERE event_id = :event_id
			AND flight_type_id = :flight_type_id
			AND event_draw_status = 1
			AND event_draw_active = 1
			AND event_draw_id != :event_draw_id
	");
	$other_draws = db_exec($stmt,array(
		"event_id"			=> $event_id,
		"flight_type_id"	=> $flight_type_id,
		"event_draw_id"		=> $event_draw_id
	));
	
	$from = $draw['event_draw_round_from'];
	$to = $draw['event_draw_round_to'];
	$overlap = 0;
	foreach($other_draws as $o){
		$ofrom = $o['event_draw_round_from'];
		$oto = $o['event_draw_round_to'];
		if(($from >= $ofrom && $from <= $oto) || ($to >= $ofrom && $to <= $oto)){
			$overlap = 1;
		}
	}
	if($overlap){
		user_message("Cannot Apply the draw because it overlaps with another existing active draw.",1);
		return event_draw();
	}
	
	# Ok, now lets get the rounds for this draw, and apply the group or order number to the existing event rounds
	$draw_rounds = array();
	$stmt = db_prep("
		SELECT *
		FROM event_draw_round
		WHERE event_draw_id = :event_draw_id
			AND event_draw_round_status = 1
		ORDER BY event_draw_round_number,event_draw_round_group,event_draw_round_order
	");
	$result = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	foreach($result as $r){
		$round_number = $r['event_draw_round_number'];
		$event_pilot_id = $r['event_pilot_id'];
		$draw_rounds[$round_number][$event_pilot_id] = $r;
	}
	# OK, now lets step through the existing rounds and save the flight orders for this flight type in the existing rounds
	$e = new Event($event_id);
	$e->get_rounds();
	foreach($e->rounds as $round_number => $r){
		foreach($r['flights'][$flight_type_id]['pilots'] as $event_pilot_id => $p){
			$group = '';
			$order = 0;
			if(isset($draw_rounds[$round_number][$event_pilot_id]['event_draw_round_group'])){
				$group = $draw_rounds[$round_number][$event_pilot_id]['event_draw_round_group'];
			}
			if(isset($draw_rounds[$round_number][$event_pilot_id]['event_draw_round_order'])){
				$order = $draw_rounds[$round_number][$event_pilot_id]['event_draw_round_order'];
			}
			# lets save that flight now
			if($p['event_pilot_round_flight_id']){
				$stmt = db_prep("
					UPDATE event_pilot_round_flight
					SET event_pilot_round_flight_group = :group,
						event_pilot_round_flight_order = :order
					WHERE event_pilot_round_flight_id = :event_pilot_round_flight_id
				");
				$result = db_exec($stmt,array(
					"group"							=> $group,
					"order"							=> $order,
					"event_pilot_round_flight_id"	=> $p['event_pilot_round_flight_id']
				));
			}else{
				# Looks like this is a new pilot that doesn't have a record yet, so lets create one
				# Lets get the event_pilot_round
				$stmt = db_prep("
					SELECT *
					FROM event_pilot_round epr
					WHERE epr.event_round_id = :event_round_id
						AND epr.event_pilot_id = :event_pilot_id
				");
				$result2 = db_exec($stmt,array("event_round_id" => $r['event_round_id'],"event_pilot_id" => $event_pilot_id));
				if(!isset($result2[0])){
					# Event pilot round doesn't exist, so lets create one
					$stmt = db_prep("
						INSERT INTO event_pilot_round
						SET event_pilot_id = :event_pilot_id,
							event_round_id = :event_round_id
					");
					$result3 = db_exec($stmt,array("event_round_id" => $r['event_round_id'],"event_pilot_id" => $event_pilot_id));
					$event_pilot_round_id = $GLOBALS['last_insert_id'];
				}else{
					$event_pilot_round_id = $result2[0]['event_pilot_round_id'];
				}
				
				$stmt = db_prep("
					INSERT INTO event_pilot_round_flight
					SET event_pilot_round_id = :event_pilot_round_id,
						flight_type_id = :flight_type_id,
						event_pilot_round_flight_group = :group,
						event_pilot_round_flight_order = :order,
						event_pilot_round_flight_status = 1
				");
				$result = db_exec($stmt,array(
					"event_pilot_round_id"	=> $event_pilot_round_id,
					"flight_type_id"		=> $flight_type_id,
					"group"					=> $group,
					"order"					=> $order
				));
			}
		}
	}
	# Now lets change the status of the draw to active
	$stmt = db_prep("
		UPDATE event_draw
		SET event_draw_active = 1
		WHERE event_draw_id = :event_draw_id
	");
	$result = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	
	user_message("Event Draw Applied.");
	return event_draw();
}
function event_draw_unapply(){
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_draw_id = intval($_REQUEST['event_draw_id']);
	$flight_type_id = intval($_REQUEST['flight_type_id']);

	# Get flight type info
	$ft = array();
	$stmt = db_prep("
		SELECT *
		FROM flight_type
		WHERE flight_type_id = :flight_type_id
	");
	$result = db_exec($stmt,array("flight_type_id" => $flight_type_id));
	$ft = $result[0];

	# Get draw info
	$draw = array();
	$stmt = db_prep("
		SELECT *
		FROM event_draw
		WHERE event_draw_id = :event_draw_id
	");
	$result = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	$draw = $result[0];
	
	# Now lets change the status of the draw to inactive
	$stmt = db_prep("
		UPDATE event_draw
		SET event_draw_active = 0
		WHERE event_draw_id = :event_draw_id
	");
	$result = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	
	user_message("Event Draw Inactivated.");
	return event_draw();
}
function event_draw_delete() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_draw_id = intval($_REQUEST['event_draw_id']);

	if($event_draw_id != 0){
		# turn draw off
		$stmt = db_prep("
			UPDATE event_draw
			SET event_draw_status = 0,
				event_draw_active = 0
			WHERE event_draw_id = :event_draw_id
		");
		$result = db_exec($stmt,array("event_draw_id" => $event_draw_id));
		user_message("Event Draw deleted.");
	}
	return event_draw();
}
function event_draw_print() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_draw_id = intval($_REQUEST['event_draw_id']);
	$print_flight_type_id = intval($_REQUEST['flight_type_id']);
	$print_round_from = intval($_REQUEST['print_round_from']);
	$print_round_to = intval($_REQUEST['print_round_to']);
	$print_type = $_REQUEST['print_type'];
	$use_print_header = $_REQUEST['use_print_header'];
	$highlight = $_REQUEST['highlight'];
	$pdf = 0;
	
	$template = '';
	$title = '';
	$orientation = 'P';
	$sort_by = '';
	$e = new Event($event_id);
	switch($print_type){
		case "cd":
			$template = "print/print_draw_cd.tpl";
			$title = "CD Recording Sheet";
			$orientation = "P";
			$sort_by = 'flight_order';
			break;
		case "pilot":
			# We are going to force this to be a pdf now
			$pdf = 1;
			$title = "Pilot Score Recording Sheets";
			$orientation = "L";
			$sort_by = 'alphabetical_first';
			if( $e->info['event_type_code'] == 'gps' ){
				$orientation = "P";
				$sort_by = 'alphabetical_first';
			}
			break;
		case "pilot_summary":
			# We are going do a pdf with a summary view
			$pdf = 1;
			$title = "Pilot Score Recording Sheets";
			$orientation = "L";
			$sort_by = 'alphabetical_first';
			break;
		case "table":
			$template = "print/print_draw_table.tpl";
			$title = "Draw Table";
			$orientation = "P";
			$sort_by = 'team';
			break;
		case "f3b_table":
			$template = "print/print_draw_f3b_table.tpl";
			$title = "Draw Table";
			$orientation = "P";
			$sort_by = 'team';
			break;
		case "matrix":
		default :
			$template = "print/print_draw_matrix.tpl";
			$title = "Draw Matrix";
			$orientation = "P";
			$sort_by = 'draw';
			break;
	}
	$_REQUEST['sort_by'] = $sort_by;
	
	$e = new Event($event_id);
	$e->get_teams();
	$e->get_rounds();
	$e->get_draws();

	# Lets get the draw round flight types if there are any
	$draw_round_flight_types = array();
	if($e->info['event_type_code'] == 'f3k' || $e->info['event_type_code'] == 'gps'){
		# Lets set the round flight types from the task list
		foreach($e->tasks as $round => $t){
			$draw_round_flight_types[$round] = $t['flight_type_id'];
		}
	}else{
		$stmt = db_prep("
			SELECT *,edrf.flight_type_id
			FROM event_draw_round_flight edrf
			LEFT JOIN event_draw ed ON edrf.event_draw_id = ed.event_draw_id
			WHERE ed.event_id = :event_id
				AND ed.event_draw_status = 1
				AND edrf.event_draw_round_flight_status = 1
			ORDER BY ed.event_draw_id,edrf.event_draw_round_number
		");
		$result = db_exec($stmt,array("event_id" => $event_id));
		foreach($result as $round){
			$event_draw_id = $round['event_draw_id'];
			$round_number = $round['event_draw_round_number'];
			$draw_round_flight_types[$event_draw_id][$round_number] = $round['flight_type_id'];
		}
	}
	# Lets add the rounds that don't exist with the draw values for printing
	# Step through any existing rounds and use those
	for($event_round_number = $print_round_from;$event_round_number <= $print_round_to;$event_round_number++){
		if(!isset($e->rounds[$event_round_number])){
			# Lets create the event round and enough info from the draw to print
			foreach($e->draws as $d){
				$event_draw_id = $d['event_draw_id'];
				if($d['event_draw_active'] == 1){
					#Step through the draw rounds and see if one exists for this round
					foreach($d['flights'] as $ftid => $f){
						if($e->info['event_type_code'] == 'f3k' || $e->info['event_type_code'] == 'gps'){
							$flight_type_id = $e->tasks[$event_round_number]['flight_type_id'];
						}else{
							$flight_type_id = $ftid;
						}
						foreach($f as $round_num => $v){
							if($round_num == $event_round_number){
								# Lets create the round info
								$e->rounds[$event_round_number]['event_round_number'] = $event_round_number;
								$e->rounds[$event_round_number]['event_round_status'] = 1;
								if($e->info['event_type_code'] == 'f3k' || $e->info['event_type_code'] == 'gps'){
									$e->rounds[$event_round_number]['flight_type_id'] = $draw_round_flight_types[$round_num];
								}else{
									$e->rounds[$event_round_number]['flight_type_id'] = $flight_type_id;
								}
								$e->rounds[$event_round_number]['event_round_time_choice'] = $e->tasks[$event_round_number]['event_task_time_choice'];
								$e->rounds[$event_round_number]['flights'][$flight_type_id] = $e->flight_types[$flight_type_id];
								foreach($v['pilots'] as $event_pilot_id => $p){
									$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['flight_type_id'] = $flight_type_id;
									$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_group'] = $p['event_draw_round_group'];
									$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_order'] = $p['event_draw_round_order'];
									$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_lane'] = $p['event_draw_round_lane'];
									$e->rounds[$event_round_number]['flights'][$flight_type_id]['event_round_flight_score'] = 1;
								
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
	$smarty->assign("flight_type_id",$print_flight_type_id);
	$smarty->assign("print_type",$print_type);
	$smarty->assign("highlight",$highlight);
	$smarty->assign("use_print_header",$use_print_header);
	$smarty->assign("event_draw_id",$event_draw_id);
	$smarty->assign("function",$_REQUEST['function']);
	$smarty->assign("event",$e);
	
	if($pdf == 1){
		# Create the PDF
		include_library('pdf_f3x.class');

		# Lets create the proper data string to send to the pdf routine for this event type
		$data = array();
		if( $print_type == 'pilot_summary'){
			foreach( $e->pilots as $event_pilot_id => $p ){
				$data['pilots'][ $event_pilot_id ] = $p;
				$data['pilots'][ $event_pilot_id ]['event'] = $e->info;
				foreach( $e->rounds as $event_round_number => $r ){
					if($event_round_number<$print_round_from || $event_round_number>$print_round_to){
						continue;
					}
					$flight_type_id = $r['flight_type_id'];
					$flights = array();
					foreach( $r['flights'][$flight_type_id]['pilots'] as $pilot_id => $f ){
						if($event_pilot_id == $pilot_id ){
							$data['pilots'][ $event_pilot_id ]['rounds'][ $event_round_number] = $f;
							$data['pilots'][ $event_pilot_id ]['rounds'][ $event_round_number]['event_round_time_choice'] = $r['event_round_time_choice'];
							$data['pilots'][ $event_pilot_id ]['rounds'][ $event_round_number]['flight_type_name'] = $e->flight_types[$flight_type_id]['flight_type_name'];
							$data['pilots'][ $event_pilot_id ]['rounds'][ $event_round_number]['flight_type_code'] = $e->flight_types[$flight_type_id]['flight_type_code'];
							# Get sub flights for flight type
							foreach( $r['flights'][ $flight_type_id ]['subs'] as $s ){
								$data['pilots'][ $event_pilot_id ]['rounds'][ $event_round_number]['subs'][] = array( "label" => $s );
							}
						}
					}
				}
			}
			// print_r($data);
			// exit;
		}else{
			foreach($e->pilots as $event_pilot_id => $p){
				foreach($e->rounds as $event_round_number => $r){
					if($event_round_number<$print_round_from || $event_round_number>$print_round_to){
						continue;
					}
					if($e->info['event_type_code'] == 'f3b'){
						$r['event_round_time_choice'] = 10;
						$flight_type_id = $print_flight_type_id;
					}else{
						$flight_type_id = $r['flight_type_id'];
					}
					$type = "time";
					if($r['flights'][$flight_type_id]['flight_type_code'] == 'f3k_d'){
						# Special checkboxes for ladder
						$type = "check";
					}
					# Create the subflight array
					$flights = array();
					foreach($r['flights'][$flight_type_id]['subs'] as $s){
						$flights[] = array(
							"type"	=> $type,
							"label"	=> $s
						);
					}
					
					$data[] = array(
						"event_name"	=> $e->info['event_name'],
						"pilot"			=> $p['pilot_first_name'].' '.$p['pilot_last_name'],
						"round"			=> $event_round_number,
						"task"			=> $r['flights'][$flight_type_id]['flight_type_name'],
						"order"			=> $r['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_order'],
						"group"			=> $r['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_group'],
						"spot"			=> $r['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_lane'],
						"lane"			=> $r['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_lane'],
						"target_time"	=> $r['event_round_time_choice']." min",
						"flights"		=> $flights
					);
				}
			}			
		}

		# Now create the pdf from the above template and save it
		$pdf = new PDF_F3X( $orientation );
		if( $print_type == 'pilot_summary' ){
			$pdf->render_summary( $e->info['event_type_code'], $data );
		}else{
			$pdf->render( $e->info['event_type_code'], $data );
		}
		exit;
		#$file_contents = $pdf->Output("$title.pdf", 'D');
	}else{
		$maintpl = find_template($template);
		return $smarty->fetch($maintpl);
	}
}
function event_draw_view() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_draw_id = intval($_REQUEST['event_draw_id']);
	$flight_type_id = intval($_REQUEST['flight_type_id']);
	$print_type = $_REQUEST['print_type'];
	$use_print_header = $_REQUEST['use_print_header'];
	$highlight = $_REQUEST['highlight'];

	$template = "print/print_draw_matrix.tpl";
	$title = "Draw Matrix";
	$sort_by = 'flight_order';
		
	# Lets get the draw info
	$draw = array();
	$stmt = db_prep("
		SELECT *
		FROM event_draw ed
		WHERE ed.event_draw_id = :event_draw_id
		AND event_draw_status = 1
	");
	$result = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	$draw = $result[0];
	
	$print_round_from = $draw['event_draw_round_from'];
	$print_round_to = $draw['event_draw_round_to'];
	
	# Now lets get the draw rounds
	$stmt = db_prep("
		SELECT *
		FROM event_draw_round 
		WHERE event_draw_id = :event_draw_id
			AND event_draw_round_status = 1
		ORDER BY event_draw_round_number,event_draw_round_group+0<>0,event_draw_round_group+0,event_draw_round_group,event_draw_round_lane,event_draw_round_order
	");
	$rounds = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	foreach($rounds as $round){
		$round_number = $round['event_draw_round_number'];
		$event_pilot_id = $round['event_pilot_id'];
		$draw['rounds']['flights'][$flight_type_id][$round_number]['pilots'][$event_pilot_id] = $round;
	}
	
	$e = new Event($event_id);
	$e->get_teams();

	# Lets set the round flight types from the task list
	$draw_round_flight_types = array();	
	foreach($e->tasks as $round => $t){
		$draw_round_flight_types[$round] = $t['flight_type_id'];
	}
	# Lets add the rounds that don't exist with the draw values for printing
	# Step through any existing rounds and use those
	for($event_round_number = $print_round_from;$event_round_number <= $print_round_to;$event_round_number++){
		if(!isset($e->rounds[$event_round_number])){
			# Lets create the event round and enough info from the draw to print
			#Step through the draw rounds and see if one exists for this round
			foreach($draw['rounds']['flights'] as $flight_type_id => $f){
				foreach($f as $round_num => $v){
					if($round_num == $event_round_number){
						# Lets create the round info
						$e->rounds[$event_round_number]['event_round_number'] = $event_round_number;
						$e->rounds[$event_round_number]['event_round_status'] = 1;
						if($e->info['event_type_code'] == 'f3k'){
							$e->rounds[$event_round_number]['flight_type_id'] = $draw_round_flight_types[$round_num];
							$flight_type_id = $draw_round_flight_types[$round_num];
						}else{
							$e->rounds[$event_round_number]['flight_type_id'] = $flight_type_id;
						}
						$e->rounds[$event_round_number]['flights'][$flight_type_id] = $e->flight_types[$flight_type_id];
						# Lets try and sort them so they are easier to look at
						foreach($v['pilots'] as $event_pilot_id => $p){
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['flight_type_id'] = $flight_type_id;
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_group'] = $p['event_draw_round_group'];
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_order'] = $p['event_draw_round_order'];
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_lane'] = $p['event_draw_round_lane'];
							$e->rounds[$event_round_number]['flights'][$flight_type_id]['event_round_flight_score'] = 1;
						}
					}
				}
			}	
		}
	}

	$smarty->assign("print_round_from",$print_round_from);
	$smarty->assign("print_round_to",$print_round_to);
	$smarty->assign("flight_type_id",$flight_type_id);
	$smarty->assign("event",$e);

	$smarty->assign("print_type",$print_type);
	$smarty->assign("highlight",$highlight);
	$smarty->assign("use_print_header",$use_print_header);
	$smarty->assign("event_draw_id",$event_draw_id);
	$smarty->assign("function",$_REQUEST['function']);

	$maintpl = find_template($template);
	return $smarty->fetch($maintpl);
}
function event_draw_stats() {
	global $smarty;

	include_library("draw.class");
	
	$event_id = intval($_REQUEST['event_id']);
	$event_draw_id = intval($_REQUEST['event_draw_id']);
	$flight_type_id = intval($_REQUEST['flight_type_id']);
	$from_event_view = 0;
	if(isset($_REQUEST['from_event_view'])){
		$from_event_view = intval($_REQUEST['from_event_view']);
	}
	
	if($event_draw_id == 0){
		user_message("Must have a proper event id to perform this action.",1);
		return event_draw();
	}

	$e = new Event($event_id);
	
	$d = new Draw($event_draw_id);
	$d->get_teams();
	$d->initialize_stats();
	$d->get_stats();
	
	$groups = $d->get_group_array();
	$group_totals = array();
	foreach($groups as $g){
		$group_totals[$g]++;
	}
	$num_teams = count($d->teams);

	$smarty->assign("event",$e);
	$smarty->assign("d",$d);
	$smarty->assign("event_id",$event_id);
	$smarty->assign("event_draw_id",$event_draw_id);
	$smarty->assign("ft",$ft);
	$smarty->assign("stats",$d->stats);
	$smarty->assign("stat_totals",$d->stat_totals);
	$smarty->assign("group_totals",$group_totals);
	$smarty->assign("from_event_view",$from_event_view);
	
	$maintpl = find_template("event/event_draw_stats.tpl");
	return $smarty->fetch($maintpl);
}
function event_view_draws() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$e = new Event($event_id);
	$e->get_teams();
	$e->get_rounds();
	$e->get_draws();
	
	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	
	$smarty->assign("event",$e);
	
	# Lets determine the round #'s to print for the draw from the existing rounds to the max on the draws
	$print_rounds = array();

	foreach($e->draws as $d){
		if($d['event_draw_active'] != 1){
			continue;
		}
		$min = 1;
		$max = 0;
		if($d['event_draw_round_to']<$min){
			$min = $d['event_draw_round_from'];
		}
		if($d['event_draw_round_to']>$max){
			$max = $d['event_draw_round_to'];
		}
		$ft = $d['flight_type_id'];
		$print_rounds[$ft] = array("min" => $min,"max" => $max);
	}
	# Now lets step through the rounds and see if its a different max
	$num_rounds = count($e->rounds);
	foreach($e->flight_types as $flight_type_id => $ft){
		if($print_rounds[$flight_type_id]['max']<count($e->rounds)){
			$print_rounds[$flight_type_id]['max'] = count($e->rounds);
			$print_rounds[$flight_type_id]['min'] = 1;
		}
	}
	
	$smarty->assign("print_rounds",$print_rounds);
	
	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);

	$maintpl = find_template("event/event_draw_view.tpl");
	return $smarty->fetch($maintpl);
}
function event_draw_manual_save(){
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_draw_id = intval($_REQUEST['event_draw_id']);
	
	# Get general draw info
	$stmt = db_prep("
		SELECT *
		FROM event_draw ed
		LEFT JOIN flight_type ft ON ed.flight_type_id = ft.flight_type_id
		WHERE ed.event_draw_id = :event_draw_id
	");
	$result = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	$d = $result[0];
	
	switch($d['flight_type_code']){
		case 'f3b_distance':
			$group_type = 'numeric';
			$lane_type = 'alpha';
			break;
		case 'f3b_duration':
		case 'f3j_duration':
		case 'f5j_duration':
		case 'td_duration':
			$group_type = 'alpha';
			$lane_type = 'numeric';
			break;
		default:
			if(preg_match("/^f3k\_/",$d['flight_type_code'])){
				$group_type = 'alpha';
				$lane_type = 'none';
			}else{
				$group_type = 'alpha';
				$lane_type = 'numeric';
			}
	}

	# ok, lets make the array of manual changes
	$groups = array();
	$orders = array();
	foreach($_REQUEST as $key => $value){
		if(preg_match("/draw\_group\_(\d+)\_(\d+)/",$key,$match)){
			$round = $match[1];
			$pilot = $match[2];
			$groups[$round][$pilot] = $value;
		}
		if(preg_match("/draw\_order\_(\d+)\_(\d+)/",$key,$match)){
			$round = $match[1];
			$pilot = $match[2];
			$orders[$round][$pilot] = $value;
		}
	}
	
	$sort_string = '';
	if(count($groups)>0){
		$sort_string = 'event_draw_round_number,event_draw_round_group+0<>0,event_draw_round_group+0,event_draw_round_group,event_draw_round_lane';
	}else{
		$sort_string = 'event_draw_round_number,event_draw_round_order';
	}
	
	# lets get all the entries for this draw, and only update the ones that dont match
	$drawrounds = array();
	$stmt = db_prep("
		SELECT *
		FROM event_draw_round 
		WHERE event_draw_id = :event_draw_id
			AND event_draw_round_status = 1
		ORDER BY $sort_string
	");
	$rounds = db_exec($stmt,array("event_draw_id" => $event_draw_id));
	foreach($rounds as $round){
		$round_number = $round['event_draw_round_number'];
		$event_pilot_id = $round['event_pilot_id'];
		$drawrounds[$round_number][$event_pilot_id] = $round;
	}
	# Now lets add any missing pilots to this array
	foreach($rounds as $round){
		$round_number = $round['event_draw_round_number'];
		foreach($groups[$round_number] as $event_pilot_id => $p){
			if(!isset($drawrounds[$round_number][$event_pilot_id])){
				$drawrounds[$round_number][$event_pilot_id] = array(
					"event_draw_round_id"		=> 0,
					"event_draw_id"				=> $round['event_draw_id'],
					"event_draw_round_number"	=> $round_number,
					"event_pilot_id"			=> $event_pilot_id,
					"event_draw_round_group"	=> '',
					"event_draw_round_order"	=> '',
					"event_draw_round_lane"		=> '',
					"event_draw_round_status"	=> 1
				);
			}
		}
		foreach($orders[$round_number] as $event_pilot_id => $p){
			if(!isset($drawrounds[$round_number][$event_pilot_id])){
				$drawrounds[$round_number][$event_pilot_id] = array(
					"event_draw_round_id"		=> 0,
					"event_draw_id"				=> $round['event_draw_id'],
					"event_draw_round_number"	=> $round_number,
					"event_pilot_id"			=> $event_pilot_id,
					"event_draw_round_group"	=> '',
					"event_draw_round_order"	=> '',
					"event_draw_round_lane"		=> '',
					"event_draw_round_status"	=> 1
				);
			}
		}
	}
	$group_labels = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');

	# Now lets step through our entered round fields and see if any of them have changed
	# For groups
	$group_updated = array();
	if(count($groups)>0){
		foreach($groups as $round_number => $r){
			foreach($r as $event_pilot_id => $group){
				# Now lets see if its different from the original
				if($group != $drawrounds[$round_number][$event_pilot_id]['event_draw_round_group']){
					$created_new = 0;
					if($drawrounds[$round_number][$event_pilot_id]['event_draw_round_id'] != 0){
						# This one has changed, so lets update it
						$stmt = db_prep("
							UPDATE event_draw_round
							SET event_draw_round_group = :group
							WHERE event_draw_round_id = :event_draw_round_id
						");
						$result = db_exec($stmt,array(
							"group"					=> strtoupper($group),
							"event_draw_round_id"	=> $drawrounds[$round_number][$event_pilot_id]['event_draw_round_id']
						));
					}else{
						# Create a new record
						$stmt = db_prep("
							INSERT INTO event_draw_round
							SET event_draw_id = :event_draw_id,
								event_draw_round_number = :event_draw_round_number,
								event_pilot_id = :event_pilot_id,
								event_draw_round_group = :event_draw_round_group,
								event_draw_round_order = :event_draw_round_order,
								event_draw_round_lane = :event_draw_round_lane,
								event_draw_round_status = 1
						");
						$result = db_exec($stmt,array(
							"event_draw_id"				=> $drawrounds[$round_number][$event_pilot_id]['event_draw_id'],
							"event_draw_round_number"	=> $round_number,
							"event_pilot_id"			=> $event_pilot_id,
							"event_draw_round_group"	=> strtoupper($group),
							"event_draw_round_order"	=> '',
							"event_draw_round_lane"		=> ''
						));
						$event_draw_round_id = $GLOBALS['last_insert_id'];
						$drawrounds[$round_number][$event_pilot_id]['event_draw_round_id'] = $event_draw_round_id;
						$created_new = 1;
					}
					if($drawrounds[$round_number][$event_pilot_id]['event_draw_round_lane'] != '' || $created_new == 1){
						$group_updated[$round_number][$group] = $drawrounds[$round_number][$event_pilot_id];
						#Add where they came from to get recalculated lanes as well
						$oldgroup = $drawrounds[$round_number][$event_pilot_id]['event_draw_round_group'];
						$group_updated[$round_number][$oldgroup] = $drawrounds[$round_number][$event_pilot_id];
					}
				}
			}
		}
		# Now lets go through the groups that were updated and update the lanes
		foreach($group_updated as $round_number => $g){
			foreach($g as $group => $round){
				# Lets get the pilots in that group
				$stmt = db_prep("
					SELECT *
					FROM event_draw_round
					WHERE event_draw_id = :event_draw_id
						AND event_draw_round_number = :round
						AND event_draw_round_group = :group
						AND event_draw_round_status = 1
				");
				$result = db_exec($stmt,array("event_draw_id" => $event_draw_id,"round" => $round_number,"group" => $group));
				# Now lets update them
				$count = 1;
				foreach($result as $row){
					if($lane_type == 'numeric'){
						$lane = $count;
					}else{
						$lane = $group_labels[$count-1];
					}
					$stmt = db_prep("
						UPDATE event_draw_round
						SET event_draw_round_lane = :lane
						WHERE event_draw_round_id = :event_draw_round_id
					");
					$result = db_exec($stmt,array("lane" => $lane,"event_draw_round_id" => $row['event_draw_round_id']));
					$count++;
				}
			}
		}
	}
	# For orders
	if(count($orders)>0){
		foreach($orders as $round_number => $r){
			foreach($r as $event_pilot_id => $order){
				# Now lets see if its different from the original
				if($order != $drawrounds[$round_number][$event_pilot_id]['event_draw_round_order']){
					# This one has changed, so lets update it
					if($drawrounds[$round_number][$event_pilot_id]['event_draw_round_id'] != 0){
						$stmt = db_prep("
							UPDATE event_draw_round
							SET event_draw_round_order = :order
							WHERE event_draw_round_id = :event_draw_round_id
						");
						$result = db_exec($stmt,array(
							"order" => $order,
							"event_draw_round_id" => $drawrounds[$round_number][$event_pilot_id]['event_draw_round_id']
						));
					}else{
						# Create a new record
						$stmt = db_prep("
							INSERT INTO event_draw_round
							SET event_draw_id = :event_draw_id,
								event_draw_round_number = :event_draw_round_number,
								event_pilot_id = :event_pilot_id,
								event_draw_round_group = :event_draw_round_group,
								event_draw_round_order = :event_draw_round_order,
								event_draw_round_lane = :event_draw_round_lane,
								event_draw_round_status = 1
						");
						$result = db_exec($stmt,array(
							"event_draw_id"				=> $drawrounds[$round_number][$event_pilot_id]['event_draw_id'],
							"event_draw_round_number"	=> $round_number,
							"event_pilot_id"			=> $event_pilot_id,
							"event_draw_round_group"	=> '',
							"event_draw_round_order"	=> $order,
							"event_draw_round_lane"		=> ''
						));
						$event_draw_round_id = $GLOBALS['last_insert_id'];
						$drawrounds[$round_number][$event_pilot_id]['event_draw_round_id'] = $event_draw_round_id;
					}
				}
			}
		}
	}
	
	user_message("Saved Event Draw Manual Edits.");
	return event_draw_edit();
}

# Export Routines
function event_export() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event = new Event($event_id);

	$smarty->assign("event",$event);
	$maintpl = find_template("event/event_export.tpl");
	return $smarty->fetch($maintpl);
}
function event_export_export() {
	global $smarty;
	
	$event_id = intval($_REQUEST['event_id']);
	$event = new Event($event_id);
	$event->get_draws();
	$event->get_rounds();
	$export_format = $_REQUEST['export_format'];
	$field_separator = $_REQUEST['field_separator'];

	$smarty->assign("event",$event);
	$smarty->assign("export_format",$export_format);
	$smarty->assign("field_separator",$field_separator);
	$smarty->assign("fs",$field_separator);
	
	# Lets make the draw array easier to use and add it to the pilot array
	$draws = array();
	
	# Lets pre-populate it with the pilot list
	foreach($event->pilots as $event_pilot_id => $p){
		$draws[$event_pilot_id]['draw'] = array();
	}
	
	# Now lets get the info from the draw
	foreach($event->draws as $draw_id => $d){
		if($d['event_draw_active'] == 0){
			continue;
		}
		foreach($d['flights'] as $flight_type_id => $f){
			foreach($f as $round_number => $r){
				foreach($r['pilots'] as $event_pilot_id => $p){
					if($event->flight_types[$flight_type_id]['flight_type_group'] == 1 && $event->flight_types[$flight_type_id]['flight_type_code'] != 'f3f_speed'){
						$draws[$event_pilot_id]['draw'][$round_number] = $p['event_draw_round_group'];
					}else{
						$draws[$event_pilot_id]['draw'][$round_number] = $p['event_draw_round_order'];
					}
				}
			}
		}
	}
	
	# Now Step through the task list to make sure there are the full amount of tasks in the export
	foreach($draws as $event_pilot_id => $d){
		foreach($event->tasks as $task_round => $t){
			if(!isset($draws[$event_pilot_id]['draw'][$task_round])){
				$draws[$event_pilot_id]['draw'][$task_round] = '';
			}
		}
	}	
	
	$rounds = 0;
	if(count($event->rounds)>0){
		$rounds = count($event->rounds);
	}
	if($rounds == 0 && isset($event->tasks)){
		$rounds = count($event->tasks);
	}
	if($rounds == 0 && isset($draws) && count($draws)>0){
		foreach($draws as $event_pilot_id => $d){
			$rounds = count($d['draw']);
		}
	}
	$smarty->assign("rounds",$rounds);	
	
	# Make sure the values are sorted
	$newdraws = array();
	foreach($draws as $event_pilot_id => $d){
		ksort($d['draw']);
		$newdraws[$event_pilot_id]['draw'] = $d['draw'];
	}
	$draws = $newdraws;

	$smarty->assign("draws",$draws);

	$template = '';
	switch($event->info['event_type_code']){
		case "f3b":
			$template = "event/event_export_f3b.tpl";
			break;
		case "f3b_speed":
			$template = "event/event_export_f3b.tpl";
			break;
		case "f3f":
			$template = "event/event_export_f3f.tpl";
			break;
		case "f3f_plus":
			$template = "event/event_export_f3f_plus.tpl";
			break;
		case "f3k":
			$template = "event/event_export_f3k.tpl";
			break;
		case "f3j":
		case "f5j":
			$template = "event/event_export_f3j.tpl";
			break;
		case "td":
			$template = "event/event_export_f3j.tpl";
			break;
	}

	# Get the export content
	$content_template = find_template($template);
	$content = $smarty->fetch($content_template);

	if($export_format == "csv_file"){
		header("Pragma: public");
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check = 0, pre-check = 0");
        header("Content-Type: application/force-download");
        header("Content-Type: application/octet-stream");
        header("Content-Type: application/download");
        header("Content-Disposition: attachment; filename = event_export.csv;");
        header("Content-Transfer-Encoding: text");
        header("Content-Length: ".strlen($content));
        print $content;
        exit;
	}elseif($export_format == "csv_text"){
		$smarty->assign("export_content",$content);
		$maintpl = find_template("event/event_export.tpl");
		return $smarty->fetch($maintpl);
	}
}

# Import Routines
function event_import() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$imported = 0;
	if(isset($_FILES['import_file'])){
		$import_file = $_FILES['import_file']['tmp_name'];
		$imported = 1;
	}
	$event_zero_round = 0;
	if(isset($_REQUEST['event_zero_round']) && ($_REQUEST['event_zero_round'] == 'on' || $_REQUEST['event_zero_round'] == 1)){
		$event_zero_round = 1;
	}

	$event = new Event($event_id);

	# If the file is imported, lets get the content
	$lines = array();
	if($imported){
		$field_separator = $_REQUEST['field_separator'];
		$decimal_type = $_REQUEST['decimal_type'];
        $rawfile = file_get_contents($import_file);
        if(preg_match("/\r\n/",$rawfile)){
                # This file has a carriage return and line feed
                $rawlines = explode("\r\n",$rawfile);
        }elseif(preg_match("/\r/",$rawfile)){
                # This file only has a carriage return
                $rawlines = explode("\r",$rawfile);
        }
		foreach($rawlines as $r){
			$templine = trim($r);
			if($r == '' || preg_match("/^\s+$/",$r)){
				continue;
			}
			$line_array = explode($field_separator,$templine);
			# Lets convert the commas into periods now
			foreach($line_array as $key => $la){
				$temp = preg_replace("/\,/",'.',$la);
				$temp = preg_replace("/\"/",'',$temp);
				$line_array[$key] = $temp;
			}
			# Lets see what the columns are
			$lines[] = $line_array;
		}
		
		$columns = array();
		foreach($lines[0] as $key => $l){
			if(preg_match("/\S+/",$l) && !preg_match("/^dns/i",$l) && !preg_match("/^dnf/i",$l)){
				# This column has strings in it
				$columns[$key] = 'alpha';
			}
			if(preg_match("/\d+/",$l) || $l == '' || preg_match("/^dns/i",$l) || preg_match("/^dnf/i",$l)){
				# This column has numbers in it
				$columns[$key] = 'numeric';
			}
		}
		
		# Now lets step through each actual line and look up the pilot for a match
		foreach($lines as $key => $l){
			$pilot_entered = $l[0];
			$q = trim(urldecode(strtolower($pilot_entered)));
			$q = '%'.$q.'%';
			# lets get the first name and last name out of it
			$words = preg_split("/\s+/",$pilot_entered,2);
			$first_name = $words[0];
			$last_name = $words[1];
			# Do search
			$found_pilots = array();
			$pilots = array();
			$stmt = db_prep("
				SELECT *
				FROM pilot p
				LEFT JOIN state s ON p.state_id = s.state_id
				LEFT JOIN country c ON p.country_id = c.country_id
				WHERE LOWER(p.pilot_first_name) LIKE :term1
					OR LOWER(p.pilot_last_name) LIKE :term2
					OR LOWER(CONCAT(p.pilot_first_name,' ',p.pilot_last_name)) LIKE :term3
			");
			$found_pilots = db_exec($stmt,array("term1" => $first_name,"term2" => $last_name,"term3" => $q));
			$pilots[] = array("pilot_id" => 0,"pilot_full_name" => 'Add As New Pilot');
			foreach($found_pilots as $p){
				$p['pilot_full_name'] = $p['pilot_first_name']." ".$p['pilot_last_name'];
				$pilots[] = $p;
			}
			$lines[$key]['pilots'] = $pilots;
		}
	}

	$smarty->assign("event",$event);
	$smarty->assign("event_zero_round",$event_zero_round);
	$smarty->assign("lines",$lines);
	$smarty->assign("columns",$columns);

	$maintpl = find_template("import/event_import.tpl");
	return $smarty->fetch($maintpl);
}
function event_import_save() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event = new Event($event_id);
	$event_zero_round = 0;
	if(isset($_REQUEST['event_zero_round']) && ($_REQUEST['event_zero_round'] == 'on' || $_REQUEST['event_zero_round'] == 1)){
		$event_zero_round = 1;
	}
	
	# Now this is where we do the save, creating the whole thing
	# lets first make the array of imported values
	$import = array();
	foreach($_REQUEST as $key => $value){
		if(preg_match("/pilot_original_(\d+)/",$key,$match)){
			$line = $match[1];
			$import[$line]['pilot_original'] = $value;
		}
		if(preg_match("/pilot_id_(\d+)/",$key,$match)){
			$line = $match[1];
			$import[$line]['pilot_id'] = $value;
		}
		if(preg_match("/round_(\d+)\_(\d+)/",$key,$match)){
			$line = $match[1];
			$round = $match[2];
			$import[$line]['rounds'][$round] = $value;
		}
	}

	$default_state_id = $event->info['state_id'];
	$default_country_id = $event->info['country_id'];
	
	# Now lets step through and create the pilots that don't exist and create the event pilot id's
	foreach($import as $line => $i){
		if($i['pilot_id'] == 0){
			# Lets split it up into the first name and last name
			$words = preg_split("/\s+/",$i['pilot_original'],2);
			$first_name = trim($words[0]);
			$last_name = trim($words[1]);
			
			# Lets create this pilot
			$stmt = db_prep("
				INSERT INTO pilot
				SET user_id = 0,
					pilot_first_name = :pilot_first_name,
					pilot_last_name = :pilot_last_name,
					state_id = :state_id,
					country_id = :country_id
			");
			$result = db_exec($stmt,array(
				"pilot_first_name"	=> $first_name,
				"pilot_last_name"	=> $last_name,
				"state_id"			=> $default_state_id,
				"country_id"		=> $default_country_id
			));
			$pilot_id = $GLOBALS['last_insert_id'];
			# replace the pilot_id in the main array
			$import[$line]['pilot_id'] = $pilot_id;
			user_message("Created new pilot $first_name $last_name.");
		}else{
			$pilot_id = $i['pilot_id'];
		}
		# ok, now that we have the pilot id, lets add the pilots to the event
		# Lets see if one exists already so we don't create lots of new ones if we import it again
		$stmt = db_prep("
			SELECT *
			FROM event_pilot ep
			WHERE event_id = :event_id
				AND pilot_id = :pilot_id
		");
		$result = db_exec($stmt,array("event_id" => $event_id,"pilot_id" => $pilot_id));
		if($result[0]){
			$event_pilot_id = $result[0]['event_pilot_id'];
			# This one already exists
			if($result[0]['event_pilot_status'] == 0){
				# We need to update the status to turn them back on
				$stmt = db_prep("
					UPDATE event_pilot
					SET event_pilot_status = 1
					WHERE event_pilot_id = :event_pilot_id
				");
				$result2 = db_exec($stmt,array("event_pilot_id" => $event_pilot_id));
			}
		}else{
			# There isn't one, so lets add it
			$stmt = db_prep("
				INSERT INTO event_pilot
				SET event_id = :event_id,
					pilot_id = :pilot_id,
					class_id = 1,
					event_pilot_entry_order = :event_pilot_entry_order,
					event_pilot_bib = :event_pilot_bib,
					event_pilot_status = 1
			");
			$result2 = db_exec($stmt,array(
				"event_id"					=> $event_id,
				"pilot_id"					=> $pilot_id,
				"event_pilot_entry_order"	=> $line,
				"event_pilot_bib"			=> $line
			));
			$event_pilot_id = $GLOBALS['last_insert_id'];
		}
		
		# Add the event_pilot_id to the main array now
		$import[$line]['event_pilot_id'] = $event_pilot_id;
	}	

	# Get default flight_type_id to use
	foreach($event->flight_types as $flight_type_id => $ft){
		$flight_type_id = $ft['flight_type_id'];
		break;
	}
	# Reset the event object
	$event = new Event($event_id);

	# OK, now that we have all the pilots and event pilot ids, lets create the rounds and data
	foreach($import as $line => $i){
		$event_pilot_id = $i['event_pilot_id'];
		$in_zero_round = $event_zero_round;
		foreach($i['rounds'] as $round_number => $time){
			if($round_number == 0){
				$event_round_score_status = 0;
			}else{
				$event_round_score_status = 1;
			}
			
			$dns = 0;
			$dnf = 0;
			if(strtolower($time) == 'dns'){
				$dns = 1;
				$time = 0;
			}
			if(strtolower($time) == 'dnf'){
				$dnf = 1;
				$time = 0;
			}
			
			# See if an event round exists
			$stmt = db_prep("
				SELECT *
				FROM event_round
				WHERE event_id = :event_id
					AND event_round_number = :event_round_number
			");
			$result = db_exec($stmt,array("event_id" => $event_id,"event_round_number" => $round_number));
			if(isset($result[0])){
				# This event round already exists
				$event_round_id = $result[0]['event_round_id'];
				$stmt = db_prep("
					UPDATE event_round
					SET event_round_needs_calc = 1,
						event_round_score_status = :event_round_score_status,
						event_round_status = 1
					WHERE event_round_id = :event_round_id
				");
				$result2 = db_exec($stmt,array(
					"event_round_id"			=> $event_round_id,
					"event_round_score_status"	=> $event_round_score_status
				));
			}else{
				# Create a new event round
				$stmt = db_prep("
					INSERT INTO event_round
					SET event_id = :event_id,
						event_round_needs_calc = 1,
						event_round_number = :event_round_number,
						flight_type_id = :flight_type_id,
						event_round_score_status = :event_round_score_status,
						event_round_status = 1
				");
				$result2 = db_exec($stmt,array(
					"event_id"					=> $event_id,
					"event_round_number"		=> $round_number,
					"flight_type_id"			=> $flight_type_id,
					"event_round_score_status"	=> $event_round_score_status
				));
				$event_round_id = $GLOBALS['last_insert_id'];
				
				# Lets also create a new event_round_flight that is set to on
				$stmt = db_prep("
					INSERT INTO event_round_flight
					SET event_round_id = :event_round_id,
						flight_type_id = :flight_type_id,
						event_round_flight_score = 1
				");
				$result2 = db_exec($stmt,array("event_round_id" => $event_round_id,"flight_type_id" => $flight_type_id));
			}
			
			# We need to get the event_pilot_round_id
			$stmt = db_prep("
			SELECT *
				FROM event_pilot_round epr
				WHERE epr.event_round_id = :event_round_id
					AND epr.event_pilot_id = :event_pilot_id
			");
			$result2 = db_exec($stmt,array("event_round_id" => $event_round_id,"event_pilot_id" => $event_pilot_id));
			if(!isset($result2[0])){
				# Event pilot round doesn't exist, so lets create one
				$stmt = db_prep("
					INSERT INTO event_pilot_round
					SET event_pilot_id = :event_pilot_id,
						event_round_id = :event_round_id
				");
				$result3 = db_exec($stmt,array("event_round_id" => $event_round_id,"event_pilot_id" => $event_pilot_id));
				$event_pilot_round_id = $GLOBALS['last_insert_id'];
			}else{
				$event_pilot_round_id = $result2[0]['event_pilot_round_id'];
			}
			
			# Now we need to see if a round flight already exists...sheesh
			$stmt = db_prep("
				SELECT *
				FROM event_pilot_round_flight
				WHERE event_pilot_round_id = :event_pilot_round_id
				AND flight_type_id = :flight_type_id
				AND event_pilot_round_flight_status = 1
			");
			$result2 = db_exec($stmt,array(
				"event_pilot_round_id"	=> $event_pilot_round_id,
				"flight_type_id"		=> $event_round_flight_type_id
			));
			if(isset($result2[0])){
				# This one already exists, so lets update it
				$stmt = db_prep("
					UPDATE event_pilot_round_flight
					SET event_pilot_round_flight_seconds = :value,
						event_pilot_round_flight_status = 1
					WHERE event_pilot_round_flight_id = :event_pilot_round_flight_id
				");
				$result3 = db_exec($stmt,array(
					"event_pilot_round_flight_id"	=> $result2[0]['event_pilot_round_flight_id'],
					"value"							=> $time
				));
			}else{
				$stmt = db_prep("
					INSERT INTO event_pilot_round_flight
					SET event_pilot_round_id = :event_pilot_round_id,
						flight_type_id = :flight_type_id,
						event_pilot_round_flight_seconds = :value,
						event_pilot_round_flight_dns = :dns,
						event_pilot_round_flight_dnf = :dnf,
						event_pilot_round_flight_status = 1
				");
				$result2 = db_exec($stmt,array(
					"event_pilot_round_id"	=> $event_pilot_round_id,
					"flight_type_id"		=> $flight_type_id,
					"value"					=> $time,
					"dns"					=> $dns,
					"dnf"					=> $dnf
				));
			}
		}
	}
	# Reset the event again
	$event = new Event($event_id);
	$event->get_rounds(); # This will do the recalc of all of the rounds
	$event->get_rounds(); # This refreshes the rounds for the totals
	
	$event->calculate_event_totals();
	$event->event_save_totals();
	
	return event_view();
}

# Task Routines
function event_tasks() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$e = new Event($event_id);
	$e->get_tasks();
	
	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	
	$smarty->assign("event",$e);
	
	# Find last prelim round so we can show neat flyoff round numbers
	foreach($e->tasks as $t){
		if($t['event_task_round_type'] == 'prelim'){
			$round = $t['event_task_round'];
		}
	}
	$smarty->assign("last_prelim_round",$round);
	
	$maintpl = find_template("event/event_tasks.tpl");
	return $smarty->fetch($maintpl);
}
function event_tasks_save() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$add_round = intval($_REQUEST['add_round']);
	
	$e = new Event($event_id);
	$e->get_tasks();
	
	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	
	# Lets get the entered rounds to save
	$rounds = array();
	foreach($_REQUEST as $key => $value){
		if(preg_match("/event_task_round_type_(\d*)/",$key,$match)){
			$id = $match[1];
			$rounds[$id]['event_task_round_type'] = $value;
		}
		if(preg_match("/flight_type_id_(\d*)/",$key,$match)){
			$id = $match[1];
			$rounds[$id]['flight_type_id'] = $value;
		}
		if(preg_match("/event_task_time_choice_(\d*)/",$key,$match)){
			$id = $match[1];
			$rounds[$id]['event_task_time_choice'] = $value;
		}
		if(preg_match("/event_task_score_second_(\d*)/",$key,$match)){
			$id = $match[1];
			$rounds[$id]['event_task_score_second'] = $value;
		}
	}


	# Now Lets save the round tasks
	foreach($rounds as $id => $r){
		$stmt = db_prep("
			UPDATE event_task
			SET event_task_round_type = :round_type,
				flight_type_id = :flight_type_id,
				event_task_time_choice = :event_task_time_choice,
				event_task_score_second = :event_task_score_second
			WHERE event_task_id = :event_task_id
		");
		$result = db_exec($stmt,array(
			"round_type"				=> $r['event_task_round_type'],
			"flight_type_id"			=> $r['flight_type_id'],
			"event_task_time_choice"	=> $r['event_task_time_choice'],
			"event_task_score_second"	=> $r['event_task_score_second'],
			"event_task_id"				=> $id
		));
	}
	
	# Lets see what round I should add and what type
	if($add_round){
		$round = 0;
		$round_type = 'prelim';
		foreach($e->tasks as $t){
			if($t['event_task_round']>$round){
				$round = $t['event_task_round'];
			}
			if($t['event_task_round_type'] != $round_type){
				$round_type = $t['event_task_round_type'];
			}
		}
		$round++;
		# Lets get the first flight_type_id
		foreach($e->flight_types as $id => $ft){
			$flight_type_id = $id;
			break;
		}

		# If its F3J or TD, lets set the default time and point value
		$event_task_time_choice = 0;
		$event_task_score_second = 0;
		if($e->info['event_type_code'] == 'f3j' | $e->info['event_type_code'] == 'f5j'){
			$event_task_score_second = 1;
			if($round_type == 'prelim'){
				$event_task_time_choice = 10;
			}else{
				$event_task_time_choice = 15;
			}
		}
		if($e->info['event_type_code'] == 'td'){
			$event_task_time_choice = 10;
			$event_task_score_second = 1;
		}

		# Now insert the record
		$stmt = db_prep("
			INSERT INTO event_task
			SET event_id = :event_id,
				event_task_round = :round,
				event_task_round_type = :round_type,
				flight_type_id = :flight_type_id,
				event_task_time_choice = :event_task_time_choice,
				event_task_score_second = :event_task_score_second,
				event_task_status = 1
		");
		$result = db_exec($stmt,array(
			"event_id"					=> $event_id,
			"round"						=> $round,
			"round_type"				=> $round_type,
			"flight_type_id"			=> $flight_type_id,
			"event_task_time_choice"	=> $event_task_time_choice,
			"event_task_score_second"	=> $event_task_score_second
		));
		if($round_type = 'prelim'){
			user_message("Added Preliminary Round #$round.");
		}else{
			user_message("Added Flyoff Round #$round.");
		}
	}
	user_message("Saved Tasks.");
	return event_tasks();
}
function event_task_del() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$event_task_id = intval($_REQUEST['event_task_id']);
	
	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	
	$stmt = db_prep("
		UPDATE event_task
		SET event_task_status = 0
		WHERE event_task_id = :event_task_id
	");
	$result = db_exec($stmt,array(
		"event_task_id" => $event_task_id
	));
	
	user_message("Removed Task.");
	return event_tasks();
}
function event_tasks_audio(){
	global $smarty;
	
	
#	$tpl = find_template("report_invoices_export.tpl");
#	$content = $smarty->fetch($tpl);
#	header("Pragma: public");
#	header("Expires: 0");
#	header("Cache-Control: must-revalidate, post-check = 0, pre-check = 0");
#	header("Content-Type: application/force-download");
#	header("Content-Type: application/octet-stream");
#	header("Content-Type: application/download");
#	header("Content-Disposition: attachment; filename = invoice_report.csv;");
#	header("Content-Transfer-Encoding: binary");
#	header("Content-Length: ".strlen($content));

#	print $content;
#	exit;
	return event_tasks();
	
}
function event_print_blank_task() {
	global $smarty;

	$event_id = intval($_REQUEST['event_id']);
	$blank = intval($_REQUEST['blank']);

	$e = new Event($event_id);
	$e->get_teams();
	$e->get_rounds();
	$e->get_draws();
	$e->get_tasks();
	
	$title = "Pilot Score Recording Sheets";
	$orientation = "L";
	$sort_by = 'alphabetical_first';
	$_REQUEST['sort_by'] = $sort_by;
	
	# Lets figure out how many rounds by the task list
	$print_round_from = 1;
	$print_round_to = count($e->tasks);

	# Lets get the draw round flight types if there are any
	$draw_round_flight_types = array();
	if($e->info['event_type_code'] == 'f3k'){
		# Lets set the round flight types from the task list
		foreach($e->tasks as $round => $t){
			$draw_round_flight_types[$round] = $t['flight_type_id'];
		}
	}else{
		$stmt = db_prep("
			SELECT *,edrf.flight_type_id
			FROM event_draw_round_flight edrf
			LEFT JOIN event_draw ed ON edrf.event_draw_id = ed.event_draw_id
			WHERE ed.event_id = :event_id
				AND ed.event_draw_status = 1
				AND edrf.event_draw_round_flight_status = 1
			ORDER BY ed.event_draw_id,edrf.event_draw_round_number
		");
		$result = db_exec($stmt,array("event_id" => $event_id));
		foreach($result as $round){
			$event_draw_id = $round['event_draw_id'];
			$round_number = $round['event_draw_round_number'];
			$draw_round_flight_types[$event_draw_id][$round_number] = $round['flight_type_id'];
		}
	}

	if($blank == 1){
		# Lets add the rounds that don't exist with the draw values for printing
		# Step through any existing rounds and use those
		$e->pilots = array();
		$event_pilot_id = 10000;
		$e->pilots[$event_pilot_id]['event_pilot_id'] = $event_pilot_id;
		$e->pilots[$event_pilot_id]['pilot_first_name'] = "";

		for($event_round_number = $print_round_from;$event_round_number <= $print_round_to;$event_round_number++){
			if(!isset($e->rounds[$event_round_number])){
				# Lets create the event round and enough info from the draw to print
				#Step through the draw rounds and see if one exists for this round
				if($e->info['event_type_code'] == 'f3k'){
					$flight_type_id = $e->tasks[$event_round_number]['flight_type_id'];
				}
				# Lets create the round info
				$e->rounds[$event_round_number]['event_round_number'] = $event_round_number;
				$e->rounds[$event_round_number]['event_round_status'] = 1;
				if($e->info['event_type_code'] == 'f3k'){
					$e->rounds[$event_round_number]['flight_type_id'] = $draw_round_flight_types[$event_round_number];
				}else{
					$e->rounds[$event_round_number]['flight_type_id'] = $flight_type_id;
				}
				$e->rounds[$event_round_number]['flights'][$flight_type_id] = $e->flight_types[$flight_type_id];
				
				$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['flight_type_id'] = $flight_type_id;
				$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_group'] = '';
				$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_order'] = '';
				$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_lane'] = '';
				$e->rounds[$event_round_number]['flights'][$flight_type_id]['event_round_flight_score'] = 1;
			}
		}
	}else{
		# Lets do the same thing, except populate the rounds with the current pilot list
		for($event_round_number = $print_round_from;$event_round_number <= $print_round_to;$event_round_number++){
			if(!isset($e->rounds[$event_round_number])){
				# Lets create the event round and enough info from the draw to print
				#Step through the draw rounds and see if one exists for this round
				if($e->info['event_type_code'] == 'f3k'){
					$flight_type_id = $e->tasks[$event_round_number]['flight_type_id'];
				}
				# Lets create the round info
				$e->rounds[$event_round_number]['event_round_number'] = $event_round_number;
				$e->rounds[$event_round_number]['event_round_status'] = 1;
				if($e->info['event_type_code'] == 'f3k'){
					$e->rounds[$event_round_number]['flight_type_id'] = $draw_round_flight_types[$event_round_number];
				}else{
					$e->rounds[$event_round_number]['flight_type_id'] = $flight_type_id;
				}
				$e->rounds[$event_round_number]['flights'][$flight_type_id] = $e->flight_types[$flight_type_id];
				
				# Add the current pilot list
				foreach($e->pilots as $event_pilot_id => $p){
					$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['flight_type_id'] = $flight_type_id;
					$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_group'] = '';
					$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_order'] = '';
					$e->rounds[$event_round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_lane'] = '';
					$e->rounds[$event_round_number]['flights'][$flight_type_id]['event_round_flight_score'] = 1;
				}
			}
		}
	}

	# Create the PDF
	include_library('pdf_f3x.class');

	# Lets create the proper data string to send to the pdf routine for this event type
	$data = array();
	foreach($e->pilots as $event_pilot_id => $p){
		foreach($e->rounds as $event_round_number => $r){
			if($event_round_number<$print_round_from || $event_round_number>$print_round_to){
				continue;
			}
			if($e->info['event_type_code'] == 'f3b'){
				$r['event_round_time_choice'] = 10;
				$flight_type_id = $print_flight_type_id;
			}else{
				$flight_type_id = $r['flight_type_id'];
			}
			$type = "time";
			if($r['flights'][$flight_type_id]['flight_type_code'] == 'f3k_d'){
				# Special checkboxes for ladder
				$type = "check";
			}
			# Creat the subflight array
			$flights = array();
			foreach($r['flights'][$flight_type_id]['subs'] as $s){
				$flights[] = array(
					"type"	=> $type,
					"label"	=> $s
				);
			}
			
			$data[] = array(
				"event_name"	=> $e->info['event_name'],
				"pilot"			=> $p['pilot_first_name'].' '.$p['pilot_last_name'],
				"round"			=> $event_round_number,
				"task"			=> $r['flights'][$flight_type_id]['flight_type_name'],
				"group"			=> $r['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_group'],
				"spot"			=> $r['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_lane'],
				"lane"			=> $r['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_lane'],
				"target_time"	=> $r['event_round_time_choice']." min",
				"flights"		=> $flights
			);
		}
	}
	# Now create the pdf from the above template and save it
	$pdf = new PDF_F3X();
	$pdf->render($e->info['event_type_code'],$data);
	exit;
}

# Self Entry Functions
function event_self_entry() {
	global $smarty;
	# Function to Edit a score in your event
	$event_id = intval($_REQUEST['event_id']);
	$event_pilot_id = intval($_REQUEST['event_pilot_id']);
	$flight_type_id = intval($_REQUEST['flight_type_id']);
	$round_number = intval($_REQUEST['round_number']);
	$group = $_REQUEST['group'];
	$minutes = intval($_REQUEST['minutes']);
	$seconds = intval($_REQUEST['seconds']);
	$seconds_2 = floatval($_REQUEST['seconds_2']);
	$over = intval($_REQUEST['over']);
	$landing = intval($_REQUEST['landing']);
	$laps = intval($_REQUEST['laps']);
	$startpen = intval($_REQUEST['startpen']);
	$startheight = intval($_REQUEST['startheight']);
	$penalty = intval($_REQUEST['penalty']);
	$save = intval($_REQUEST['save']);

	$event = new Event($event_id);
	$event->get_rounds();
	$event->get_tasks();
	$event->get_draws();

	# If the event_pilot id is 0, then lets get the event pilot ID from the logged in user
	if($event_pilot_id == 0){
		$pilot_id = $GLOBALS['user']['pilot_id'];
		foreach( $event->pilots as $event_pilot_id => $p ){
			if( $p['pilot_id'] == $pilot_id ) {
				$event_pilot_id = $p['event_pilot_id'];
				break;
			}
		}
	}
	$current_pilot = $event->pilots[$event_pilot_id];

	# Lets set the accuracy strings for duration events or times
	$seconds_accuracy = 0;
	foreach( $event->options as $o ){
		if( $event->info['event_type_code'] == 'f3b' && $o['event_type_option_code'] == 'f3b_duration_accuracy' ){
			$seconds_accuracy = $o['event_option_value'];
		}
		if( $event->info['event_type_code'] == 'f3j' && $o['event_type_option_code'] == 'f3j_duration_accuracy' ){
			$seconds_accuracy = $o['event_option_value'];
		}
		if( $event->info['event_type_code'] == 'f5j' && $o['event_type_option_code'] == 'f5j_duration_accuracy' ){
			$seconds_accuracy = $o['event_option_value'];
		}
		if( $event->info['event_type_code'] == 'f3k' && $o['event_type_option_code'] == 'f3k_duration_accuracy' ){
			$seconds_accuracy = $o['event_option_value'];
		}
		if( $event->info['event_type_code'] == 'td' && $o['event_type_option_code'] == 'td_duration_accuracy' ){
			$seconds_accuracy = $o['event_option_value'];
		}
		if( $event->info['event_type_code'] == 'gps' && $o['event_type_option_code'] == 'gps_time_accuracy' ){
			$seconds_accuracy = $o['event_option_value'];
		}
		if( $event->info['event_type_code'] == 'gps' && $o['event_type_option_code'] == 'gps_speed_accuracy' ){
			$seconds_accuracy = $o['event_option_value'];
		}
	}
	$seconds_accuracy_string = ".%'.0" . $seconds_accuracy . "d";

	$full_seconds = $seconds + ( $seconds_2 / pow( 10, $seconds_accuracy ) );

	# Lets check if this pilot is coming in and hasn't got a score for this round number
	# lets step through the rounds starting from the beginning and stop at the first round where this pilot doesn't have a score
	if($round_number == 0){
		foreach($event->rounds as $number => $r){
			$ftid = $r['flight_type_id'];
			if( $r['flights'][$ftid]['pilots'][$event_pilot_id]['event_pilot_round_flight_minutes'] == 0 &&
				$r['flights'][$ftid]['pilots'][$event_pilot_id]['event_pilot_round_flight_seconds'] == 0
			){
				# They haven't scored this round for themselves yet, so lets set it to this round
				$round_number = $number;
			}
		}
	}

	# reset the round number if it is at the end
	if( ( $round_number == 0 && count($event->rounds) == count($event->tasks) ) || $round_number >= count($event->tasks) ){
		$round_number = count($event->tasks);
	}

	# If round is set, then reset the flight_type_id
	if(isset($event->rounds[$round_number])){
		$flight_type_id = $event->rounds[$round_number]['flight_type_id'];
	}

	# Get sub flight data if there is any
	$sub_flights = array();
	foreach($_REQUEST as $key=>$val){
		if(preg_match("/sub_min_(\d)/", $key, $m)){
			$flight = $m[1];
			$sub_flights[$flight]['minutes'] = $val;
		}
		if(preg_match("/sub_sec_(\d)/", $key, $m)){
			$flight = $m[1];
			$sub_flights[$flight]['seconds'] = $val;
		}
		if(preg_match("/sub_sec2_(\d)/", $key, $m)){
			$flight = $m[1];
			$sub_flights[$flight]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", $val );
		}
	}
	# Lets step through the sub flights and see if there are max flight times and enforce them
	foreach($sub_flights as $sub => $f){
		$total_seconds = ( $f['minutes'] * 60 ) + $f['seconds'] + ( $f['seconds2'] / pow( 10, $seconds_accuracy ) );
		if($event->flight_types[$flight_type_id]['flight_type_sub_flights_max_time'] != 0){
			if( $total_seconds > $event->flight_types[$flight_type_id]['flight_type_sub_flights_max_time'] ){
				$total_seconds = $event->flight_types[$flight_type_id]['flight_type_sub_flights_max_time'];
				$sub_flights[$sub]['minutes'] = floor( $total_seconds / 60 );
				$sub_flights[$sub]['seconds'] = sprintf( "%02d", fmod( $total_seconds, 60 ) );
				$sub_flights[$sub]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", ($total_seconds - ( 60 * $sub_flights[$sub]['minutes'] ) - $sub_flights[$sub]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy );
			}
		}
		$sub_flights[$sub]['total_seconds'] = $total_seconds;
	}
	# Lets check for 1234 round to truncate properly the times
	if($event->flight_types[$flight_type_id]['flight_type_code'] == 'f3k_h'){
		# Its a 1234 flight
		# So we need to sort the times by max to min, then truncate to the max times
		$temp_sub = array();
		foreach($sub_flights as $sub => $f){
			$temp_sub[] = $f['total_seconds'];
		}
		sort($temp_sub);
		if($temp_sub[0]>60){
			$temp_sub[0] = 60;
		}
		if($temp_sub[1]>120){
			$temp_sub[1] = 120;
		}
		if($temp_sub[2]>180){
			$temp_sub[2] = 180;
		}
		if($temp_sub[3]>240){
			$temp_sub[3] = 240;
		}					
		$sub_flights[1]['total_seconds'] = $temp_sub[0];
		$sub_flights[1]['minutes'] = floor( $temp_sub[0] / 60 );
		$sub_flights[1]['seconds'] = sprintf( "%02d", fmod( $temp_sub[0], 60 ) );
		$sub_flights[1]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", round( ($sub_flights[1]['total_seconds'] - ( 60 * $sub_flights[1]['minutes'] ) - $sub_flights[1]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy ), $seconds_accuracy );
		$sub_flights[2]['total_seconds'] = $temp_sub[1];
		$sub_flights[2]['minutes'] = floor( $temp_sub[1] / 60 );
		$sub_flights[2]['seconds'] = sprintf( "%02d", fmod( $temp_sub[1], 60 ) );
		$sub_flights[2]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", round( ($sub_flights[2]['total_seconds'] - ( 60 * $sub_flights[2]['minutes'] ) - $sub_flights[2]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy ), $seconds_accuracy );
		$sub_flights[3]['total_seconds'] = $temp_sub[2];
		$sub_flights[3]['minutes'] = floor( $temp_sub[2] / 60 );
		$sub_flights[3]['seconds'] = sprintf( "%02d", fmod( $temp_sub[2], 60 ) );
		$sub_flights[3]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", round( ($sub_flights[3]['total_seconds'] - ( 60 * $sub_flights[3]['minutes'] ) - $sub_flights[3]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy ), $seconds_accuracy );
		$sub_flights[4]['total_seconds'] = $temp_sub[3];
		$sub_flights[4]['minutes'] = floor( $temp_sub[3] / 60 );
		$sub_flights[4]['seconds'] = sprintf( "%02d", fmod( $temp_sub[3], 60 ) );
		$sub_flights[4]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", round( ($sub_flights[4]['total_seconds'] - ( 60 * $sub_flights[4]['minutes'] ) - $sub_flights[4]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy ), $seconds_accuracy );
	}
	# Lets check for big ladder round to truncate properly the times
	if($event->flight_types[$flight_type_id]['flight_type_code'] == 'f3k_k'){
		# Its a big ladder flight
		# So we need to truncate to the max times
		$temp_sub = array();
		foreach($sub_flights as $sub => $f){
			$temp_sub[] = $f['total_seconds'];
		}
		if($temp_sub[0]>60){
			$temp_sub[0] = 60;
		}
		if($temp_sub[1]>90){
			$temp_sub[1] = 90;
		}
		if($temp_sub[2]>120){
			$temp_sub[2] = 120;
		}
		if($temp_sub[3]>150){
			$temp_sub[3] = 150;
		}					
		if($temp_sub[4]>180){
			$temp_sub[4] = 180;
		}					
		$sub_flights[1]['total_seconds'] = $temp_sub[0];
		$sub_flights[1]['minutes'] = floor( $temp_sub[0] / 60 );
		$sub_flights[1]['seconds'] = sprintf( "%02d", fmod( $temp_sub[0], 60 ) );
		$sub_flights[1]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", round( ($sub_flights[1]['total_seconds'] - ( 60 * $sub_flights[1]['minutes'] ) - $sub_flights[1]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy ), $seconds_accuracy );
		$sub_flights[2]['total_seconds'] = $temp_sub[1];
		$sub_flights[2]['minutes'] = floor( $temp_sub[1] / 60 );
		$sub_flights[2]['seconds'] = sprintf( "%02d", fmod( $temp_sub[1], 60 ) );
		$sub_flights[2]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", round( ($sub_flights[2]['total_seconds'] - ( 60 * $sub_flights[2]['minutes'] ) - $sub_flights[2]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy ), $seconds_accuracy );
		$sub_flights[3]['total_seconds'] = $temp_sub[2];
		$sub_flights[3]['minutes'] = floor( $temp_sub[2] / 60 );
		$sub_flights[3]['seconds'] = sprintf( "%02d", fmod( $temp_sub[2], 60 ) );
		$sub_flights[3]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", round( ($sub_flights[3]['total_seconds'] - ( 60 * $sub_flights[3]['minutes'] ) - $sub_flights[3]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy ), $seconds_accuracy );
		$sub_flights[4]['total_seconds'] = $temp_sub[3];
		$sub_flights[4]['minutes'] = floor( $temp_sub[3] / 60 );
		$sub_flights[4]['seconds'] = sprintf( "%02d", fmod( $temp_sub[3], 60 ) );
		$sub_flights[4]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", round( ($sub_flights[4]['total_seconds'] - ( 60 * $sub_flights[4]['minutes'] ) - $sub_flights[4]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy ), $seconds_accuracy );
		$sub_flights[5]['total_seconds'] = $temp_sub[4];
		$sub_flights[5]['minutes'] = floor( $temp_sub[4] / 60 );
		$sub_flights[5]['seconds'] = sprintf( "%02d", fmod( $temp_sub[4], 60 ) );
		$sub_flights[5]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", round( ($sub_flights[5]['total_seconds'] - ( 60 * $sub_flights[5]['minutes'] ) - $sub_flights[5]['seconds']) * pow( 10, $seconds_accuracy ), $seconds_accuracy ), $seconds_accuracy );
	}
	
	# Lets total up the subflights to calculate the full flight time
	if(count($sub_flights) != 0){
		# It has sub flights so get the total times
		foreach($sub_flights as $flight => $f){
			$tot += $f['total_seconds'];
		}
		$minutes = floor( $tot / 60 );
		$seconds = sprintf( "%1f", fmod( $tot, 60 ) );
		$full_seconds = round( $seconds, $seconds_accuracy );
	}

	# lets get the team members for this event or all members if the parameter says
	$team_members = array();
	if($event->find_option_value($event->info['event_type_code']."_self_entry_all")){
		# They can score for anyone, so lets get that list
		foreach($event->pilots as $epid => $p){
			if($event_pilot_id != $epid){
				$team_members[$epid] = $p;
			}
		}
	}else{
		# Lets just get the team members to score for
		$event->get_teams();
		$team = $event->pilots[$event_pilot_id]['event_pilot_team'];
		foreach($event->pilots as $epid => $p){
			if($p['event_pilot_team'] == $team && $event_pilot_id != $epid){
				$team_members[$epid] = $p;
			}
		}
	}
	
	# Now lets look at the rounds to see which is the next round # to add if its a new one
	$advance_round = 0;
	$max_rounds = count($event->tasks);
	if( $round_number == 0 ){
		# Lets figure out the next round number
		$max = 0;
		foreach($event->rounds as $number => $r){
			if( $number > $max ){
				$max = $number;
			}
		}
		$round_number = $max + 1;
	}
	if( isset( $event->rounds[$round_number] ) ) {
		$advance_round = 1;
	}
	if( $round_number >= $max_rounds ){
		$advance_round = 0;
	}	
	
	if( $save == 1 ) {
		# Then they have hit the save this flight button, so lets save it.
		# lets pre populate the round with a new round just in case
		$event->get_new_round($round_number);

		# First lets see if the round is there and if it is not locked.
		$stmt = db_prep("
			SELECT *
			FROM event_round
			WHERE event_id = :event_id
				AND event_round_number = :event_round_number
				AND event_round_status = 1
		");
		$result = db_exec($stmt,array("event_id" => $event_id,"event_round_number" => $round_number));
		if( isset( $result[0] ) ) {
			if($result[0]['event_round_locked'] == 1 ){
				# This event round is locked, so return a cannot edit message
				user_message("This round is locked. You cannot enter your score anymore.", 1);
				$_REQUEST['save'] = 0;
				return event_self_entry();
			}
			$event_round_id = $result[0]['event_round_id'];
			# Need to update it to say that it needs calculation
			$stmt = db_prep("
				UPDATE event_round
				SET event_round_needs_calc = 1
				WHERE event_round_id = :event_round_id
			");
			$result = db_exec($stmt,array(
				"event_round_id" => $event_round_id
			));
		}else{
			if($event->info['event_type_code'] == 'f3j' || $event->info['event_type_code'] == 'f5j' || $event->info['event_type_code'] == 'td'){
				$event_round_time_choice = $event->tasks[$round_number]['event_task_time_choice'];
			}
			$event_round_flyoff = 0;
			$event_round_score_status = 1;
			$event_round_score_second = 1;
			
			$stmt = db_prep("
				INSERT INTO event_round
				SET event_id = :event_id,
					event_round_number = :event_round_number,
					flight_type_id = :flight_type_id,
					event_round_time_choice = :event_round_time_choice,
					event_round_score_status = 1,
					event_round_score_second = :event_round_score_second,
					event_round_needs_calc = 0,
					event_round_flyoff = :event_round_flyoff,
					event_round_status = 1
			");
			$result = db_exec($stmt,array(
				"event_id"					=> $event_id,
				"event_round_number"		=> $round_number,
				"flight_type_id"			=> $flight_type_id,
				"event_round_time_choice"	=> $event_round_time_choice,
				"event_round_flyoff"		=> $event_round_flyoff,
				"event_round_score_second"	=> $event_round_score_second
			));
			$event_round_id = $GLOBALS['last_insert_id'];
		}
		# Lets create the round flight now
		# First lets see if it exists
		$stmt = db_prep("
			SELECT *
			FROM event_round_flight
			WHERE event_round_id = :event_round_id
			AND flight_type_id = :flight_type_id
		");
		$result = db_exec($stmt,array("event_round_id" => $event_round_id,"flight_type_id" => $flight_type_id));
		if(isset($result[0])){
			# This one already exists, so lets update it
			$event_round_flight_id = $result[0]['event_round_flight_id'];
			$stmt = db_prep("
				UPDATE event_round_flight
				SET event_round_flight_score = 1
				WHERE event_round_flight_id = :event_round_flight_id
			");
			$result2 = db_exec($stmt,array("event_round_flight_id" => $event_round_flight_id));
			# Check to see if the event_pilot_round is set
			$stmt = db_prep("
				SELECT *
				FROM event_pilot_round
				WHERE event_pilot_id = :event_pilot_id
					AND event_round_id = :event_round_id
			");
			$result = db_exec($stmt,array(
				"event_pilot_id" => $event_pilot_id,
				"event_round_id" => $event_round_id
			));
			if(count($result) > 0){
				$event_pilot_round_id = $result[0]['event_pilot_round_id'];
			}else{
				# We need to create a round for this pilot
				$stmt = db_prep("
					INSERT INTO event_pilot_round
					SET event_pilot_id = :event_pilot_id,
						event_round_id = :event_round_id
				");
				$result = db_exec($stmt,array(
					"event_pilot_id" => $event_pilot_id,
					"event_round_id" => $event_round_id
				));
				$event_pilot_round_id = $GLOBALS['last_insert_id'];
			}
		}else{
			# This record doesn't exist, so lets create a new one
			$stmt = db_prep("
				INSERT INTO event_round_flight
				SET event_round_id = :event_round_id,
					flight_type_id = :flight_type_id,
					event_round_flight_score = 1
			");
			$result2 = db_exec($stmt,array("event_round_id" => $event_round_id,"flight_type_id" => $flight_type_id));
			$event_round_flight_id = $GLOBALS['last_insert_id'];
			# Lets add the pilot rounds
			foreach($event->pilots as $epid => $ep){
				$stmt = db_prep("
					INSERT INTO event_pilot_round
					SET event_pilot_id = :event_pilot_id,
						event_round_id = :event_round_id
				");
				$result = db_exec($stmt,array(
					"event_pilot_id" => $epid,
					"event_round_id" => $event_round_id
				));
				$eprid = $GLOBALS['last_insert_id'];
				if($epid == $event_pilot_id){
					$event_pilot_round_id = $eprid;
				}
				# And now lets add the pilot round flight with the default group from the draw
				$stmt = db_prep("
					INSERT INTO event_pilot_round_flight
					SET event_pilot_round_id = :event_pilot_round_id,
						flight_type_id = :flight_type_id,
						event_pilot_round_flight_group = :event_pilot_round_flight_group,
						event_pilot_round_flight_lane = :event_pilot_round_flight_lane,
						event_pilot_round_flight_status = 1
				");
				$result = db_exec($stmt,array(
					"event_pilot_round_id" => $eprid,
					"flight_type_id" => $flight_type_id,
					"event_pilot_round_flight_group" => $event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$epid]['event_pilot_round_flight_group'],
					"event_pilot_round_flight_lane" => $event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$epid]['event_pilot_round_flight_lane']
				));
			}
		}

		# So, now that we are here, we should have the event_round_id and the event_round_pilot_id, so lets save the flight
		# Lets reset the event object
		$event->get_rounds();
		$flight_time = time();
		
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_round
			WHERE event_pilot_id = :event_pilot_id
				AND event_round_id = :event_round_id
		");
		$result = db_exec($stmt,array(
			"event_pilot_id" => $event_pilot_id,
			"event_round_id" => $event_round_id
		));
		$event_pilot_round_id = $result[0]['event_pilot_round_id'];

		# Now save the flight, but lets check if there is one first
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_round_flight
			WHERE event_pilot_round_id = :event_pilot_round_id
				AND flight_type_id = :flight_type_id
		");
		$result = db_exec($stmt,array(
			"event_pilot_round_id" => $event_pilot_round_id,
			"flight_type_id" => $flight_type_id
		));

		if(count($result) > 0){
			# There is already a flight to overwrite
			$event_pilot_round_flight_id = $result[0]['event_pilot_round_flight_id'];
			$stmt = db_prep("
				UPDATE event_pilot_round_flight
				SET event_pilot_round_flight_group = :group,
					event_pilot_round_flight_minutes = :minutes,
					event_pilot_round_flight_seconds = :seconds,
					event_pilot_round_flight_over = :over,
					event_pilot_round_flight_laps = :laps,
					event_pilot_round_flight_landing = :landing,
					event_pilot_round_flight_start_penalty = :startpen,
					event_pilot_round_flight_start_height = :startheight,
					event_pilot_round_flight_penalty = :penalty,
					event_pilot_round_flight_dns = 0,
					event_pilot_round_flight_dnf = 0,
					event_pilot_round_flight_time = :flight_time,
					event_pilot_round_flight_status = 1
				WHERE event_pilot_round_flight_id = :event_pilot_round_flight_id
			");
			$result = db_exec($stmt,array(
				"group" => $group,
				"minutes" => $minutes,
				"seconds" => $full_seconds,
				"over" => $over,
				"laps" => $laps,
				"landing" => $landing,
				"startpen" => $startpen,
				"startheight" => $startheight,
				"penalty" => $penalty,
				"flight_time" => $flight_time,
				"event_pilot_round_flight_id" => $event_pilot_round_flight_id
			));
		}else{
			# Create a new one
			$stmt = db_prep("
				INSERT INTO event_pilot_round_flight
				SET event_pilot_round_id = :event_pilot_round_id,
					flight_type_id = :flight_type_id,
					event_pilot_round_flight_group = :group,
					event_pilot_round_flight_minutes = :minutes,
					event_pilot_round_flight_seconds = :seconds,
					event_pilot_round_flight_over = :over,
					event_pilot_round_flight_laps = :laps,
					event_pilot_round_flight_landing = :landing,
					event_pilot_round_flight_start_penalty = :startpen,
					event_pilot_round_flight_start_height = :startheight,
					event_pilot_round_flight_penalty = :penalty,
					event_pilot_round_flight_dns = 0,
					event_pilot_round_flight_dnf = 0,
					event_pilot_round_flight_time = :flight_time,
					event_pilot_round_flight_status = 1
			");
			$result = db_exec($stmt,array(
				"event_pilot_round_id" => $event_pilot_round_id,
				"flight_type_id" => $flight_type_id,
				"group" => $group,
				"minutes" => $minutes,
				"seconds" => $full_seconds,
				"over" => $over,
				"laps" => $laps,
				"landing" => $landing,
				"startpen" => $startpen,
				"startheight" => $startheight,
				"penalty" => $penalty,
				"flight_time" => $flight_time
			));
			$event_pilot_round_flight_id = $GLOBALS['last_insert_id'];
		}
		
		# If they have sub flights, lets save them
		if(count($sub_flights) > 0 ){
			# There are sub flights, so lets save them
			foreach($sub_flights as $num => $t){
				# Lets see if one exists already
				$stmt = db_prep("
					SELECT *
					FROM event_pilot_round_flight_sub erfs
					WHERE erfs.event_pilot_round_flight_id = :event_pilot_round_flight_id
						AND erfs.event_pilot_round_flight_sub_num = :num
				");
				$result = db_exec($stmt,array(
					"event_pilot_round_flight_id"	=> $event_pilot_round_flight_id,
					"num"							=> $num
				));
				if(isset($result[0])){
					$event_pilot_round_flight_sub_id = $result[0]['event_pilot_round_flight_sub_id'];
				}else{
					$event_pilot_round_flight_sub_id = 0;
				}
				# Make the colon string
				$string = intval( $t['minutes'] ) . ":";
				if( $t['seconds'] == 0 ){
					$string .= "00";
				}elseif( $t['seconds'] > 9 ){
					$string .= intval( $t['seconds'] );
				}else{
					$string .= "0" . intval( $t['seconds'] );
				}
				if( $t['seconds2'] ){
					$string .= "." . $t['seconds2'];
				}
				if($event_pilot_round_flight_sub_id == 0){
					# Create a new record
					$stmt = db_prep("
						INSERT INTO event_pilot_round_flight_sub
						SET event_pilot_round_flight_id = :event_pilot_round_flight_id,
							event_pilot_round_flight_sub_num = :num,
							event_pilot_round_flight_sub_val = :val
					");
					$result = db_exec($stmt,array(
						"event_pilot_round_flight_id"	=> $event_pilot_round_flight_id,
						"num"							=> $num,
						"val"							=> $string
					));
				}else{
					# Save the existing record
					$stmt = db_prep("
						UPDATE event_pilot_round_flight_sub
						SET event_pilot_round_flight_sub_val = :val
						WHERE event_pilot_round_flight_sub_id = :event_pilot_round_flight_sub_id
					");
					$result = db_exec($stmt,array(
						"event_pilot_round_flight_sub_id"	=> $event_pilot_round_flight_sub_id,
						"val"								=> $string
					));
				}
			}
		}		
		
		# Now lets re-calculate things
		$event = new Event($event_id);
		$event->get_rounds();
		$event->calculate_round($round_number);		
		$event->calculate_event_totals();		
		$event->event_save_totals();				
		$subs = array();
		foreach($event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['sub'] as $num => $f){
			$string = $f['event_pilot_round_flight_sub_val'];
			$sec_converted = convert_colon_to_seconds( $string, $seconds_accuracy );
			$min = floor( $sec_converted / 60 );
			$sec = intval( fmod( $sec_converted, 60 ) );
			$sec2 = round( ( $sec_converted - ( 60 * $min ) - $sec) * pow( 10, $seconds_accuracy ), $seconds_accuracy );
			$subs[$num]['minutes'] = $min;
			$subs[$num]['seconds'] = sprintf( "%02d", $sec );
			$subs[$num]['seconds2'] = sprintf( "%" . $seconds_accuracy . "u", $sec2 );
		}
		# Lets see if we need to be able to advance after the save
		$advance_round = 0;
		$max_rounds = count($event->tasks);
		if( isset( $event->rounds[$round_number] ) ) {
			$advance_round = 1;
		}
		if( $round_number >= $max_rounds ){
			$advance_round = 0;
		}

		user_message("Posted Score Successfully.");
		
	}else{
		# Now Lets fill out the round info with default stuff from what type of event this is
		# We actually need to fill in the default round data for an empty round or existing round
		$subs = array();
		if( isset( $event->rounds[$round_number] ) ) {
			$minutes = $event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_minutes'];
			$seconds = intval($event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_seconds']);
			$seconds_2 = round( ($event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_seconds'] - $seconds) * pow( 10, $seconds_accuracy ), $seconds_accuracy );
			$landing = $event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_landing'];
			$laps = $event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_laps'];
			$over = $event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_over'];
			$startpen = $event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_start_penalty'];
			$startheight = $event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_start_height'];
			$penalty = $event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['event_pilot_round_flight_penalty'];

			# Lets fill in the sub flights
			foreach($event->rounds[$round_number]['flights'][$flight_type_id]['pilots'][$event_pilot_id]['sub'] as $num => $f){
				$string = $f['event_pilot_round_flight_sub_val'];
				$sec_converted = convert_colon_to_seconds( $string, $seconds_accuracy );
				$min = floor( $sec_converted / 60 );
				$sec = intval( fmod( $sec_converted, 60 ) );
				$sec2 = round( ( $sec_converted - ( 60 * $min ) - $sec) * pow( 10, $seconds_accuracy ), $seconds_accuracy );
				$subs[$num]['minutes'] = $min;
				$subs[$num]['seconds'] = sprintf( "%02d", $sec );
				$subs[$num]['seconds2'] = sprintf( "%0" . $seconds_accuracy . "d", $sec2 );
			}
		}else{
			$event->get_new_round($round_number);
			$round_number = count($event->rounds);
			$flight_type_id = $event->tasks[$round_number]['flight_type_id'];
		
			# Lets set the round to be scored or not depending on the zero choice
			$event->rounds[$round_number]['event_round_score_status'] = 1;
			$minutes = 0;
			$seconds = 0;
			$seconds_2 = 0;
			$laps = 0;
			$landing = 0;
			$over = 0;
			$penalty = 0;
			$startpen = 0;
			$startheight = 0;
		}
	}
	
	$smarty->assign("event",$event);
	$smarty->assign("flight_types",$flight_types);
	$smarty->assign("flight_type_id",$flight_type_id);
	$smarty->assign("event_pilot_id",$event_pilot_id);
	$smarty->assign("round_number",$round_number);
	$smarty->assign("advance_round",$advance_round);
	$smarty->assign("current_pilot",$current_pilot);
	$smarty->assign("team_members",$team_members);
	$smarty->assign("minutes",$minutes);
	$smarty->assign("seconds",$seconds);
	$smarty->assign("seconds_2",$seconds_2);
	$smarty->assign("subs",$subs);
	$smarty->assign("over",$over);
	$smarty->assign("landing",$landing);
	$smarty->assign("laps",$laps);
	$smarty->assign("startpen",$startpen);
	$smarty->assign("startheight",$startheight);
	$smarty->assign("penalty",$penalty);
	$smarty->assign("seconds_accuracy",$seconds_accuracy);
	$smarty->assign("seconds_accuracy_string",$seconds_accuracy_string);

	$maintpl = find_template("event/event_round_self_entry.tpl");
	return $smarty->fetch($maintpl);
}

?>