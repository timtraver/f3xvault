<?php
############################################################################
#       my.php
#
#       Tim Traver
#       8/12/12
#       This is the script to show individual user and pilot profiles
#
############################################################################
$GLOBALS['current_menu'] = 'pilots';

# This whole section requires the user to be logged in
if($GLOBALS['user_id'] == 0){
	# The user is not logged in, so send the feature template
	user_message("Sorry, but you must be logged in as a user to use this feature.",1);
	$smarty->assign("redirect_action",$_REQUEST['action']);
	$smarty->assign("redirect_function",$_REQUEST['function']);
	$smarty->assign("request",$_REQUEST);
	$maintpl = find_template("feature_requires_login.tpl");
	$actionoutput = $smarty->fetch($maintpl);
}else{
	if(isset($_REQUEST['function']) && $_REQUEST['function'] != '') {
        $function = $_REQUEST['function'];
	}else{
        $function = "my_user_show";
	}
	if(check_user_function($function)){
        eval("\$actionoutput = $function();");
	}
}

function my_user_show() {
	global $user;
	global $smarty;
	
	if(isset($_REQUEST['tab'])){
		$tab  =  $_REQUEST['tab'];
	}else{
		$tab  =  0;
	}
	
	$is_pilotlist = 0;
	# Get the current users pilot info
	$stmt = db_prep("
		SELECT *
		FROM pilot
		WHERE user_id = :user_id
	");
	$result = db_exec($stmt,array("user_id" => $GLOBALS['user_id']));	
	if(!isset($result[0])){
		# Lets see if we have any entries in the db already for this pilot that were created in a previous event
		$stmt = db_prep("
			SELECT *
			FROM pilot p
			WHERE p.user_id = 0
				AND ((p.pilot_first_name = LOWER(:user_first_name) AND p.pilot_last_name = LOWER(:user_last_name))
					OR p.pilot_email = LOWER(:user_email))
		");
		$result2 = db_exec($stmt,array("user_email" => strtolower($user['user_email']),"user_first_name" => strtolower($user['user_first_name']),"user_last_name" => strtolower($user['user_last_name'])));
		if(isset($result2[0])){
			# Step though and find the last events they were in
			$pilotlist = array();
			foreach($result2 as $pilot){
				$stmt = db_prep("
					SELECT *
					FROM event_pilot ep
					LEFT JOIN event e ON e.event_id = ep.event_id
					LEFT JOIN location l ON l.location_id = e.location_id
					WHERE ep.pilot_id = :pilot_id
					ORDER BY e.event_start_date desc
					LIMIT 1
				");
				$result3 = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));
				if(isset($result3[0])){
					$pilot['eventstring'] = $result3[0]['event_name']." - ".date("F j, Y",strtotime($result3[0]['event_start_date']));
				}else{
					$pilot['eventstring'] = 'None on file.';
				}
				$pilotlist[] = $pilot;
				$is_pilotlist = 1;
			}
			$pilot = array();
			# We have found some records that look like they relate, so lets show them first
		}else{
			# They don't have a pilot ID, so pre-populate with defaults
			$pilot['pilot_first_name'] = $GLOBALS['user']['user_first_name'];
			$pilot['pilot_last_name'] = $GLOBALS['user']['user_last_name'];
			$pilot['pilot_email'] = $GLOBALS['user']['user_email'];
			$pilot_planes = array();
			$pilot_locations = array();
			$pilotlist = array();
		}
	}else{
		$pilot = $result[0];
		
		# Get the planes that this pilot has
		$pilot_planes = array();
		$stmt = db_prep("
			SELECT *
			FROM pilot_plane pp
			LEFT JOIN plane p ON p.plane_id = pp.plane_id
			LEFT JOIN plane_type pt ON pt.plane_type_id = p.plane_type_id
			WHERE pp.pilot_id = :pilot_id
				AND pp.pilot_plane_status = 1
		");
		$pilot_planes = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));
		foreach($pilot_planes as $key => $plane){
			$disciplines = array();
			# Lets get the plane types
			$stmt = db_prep("
				SELECT *
				FROM plane_discipline pd
				LEFT JOIN discipline d ON pd.discipline_id = d.discipline_id
				WHERE pd.plane_id = :plane_id
				ORDER BY d.discipline_order
			");
			$disciplines = db_exec($stmt,array("plane_id" => $plane['plane_id']));
			$pilot_planes[$key]['disciplines'] = $disciplines;
		}
		
		# Get the pilots favorite locations
		$pilot_locations = array();
		$stmt = db_prep("
			SELECT *
			FROM pilot_location pl
			LEFT JOIN location l ON pl.location_id = l.location_id
			LEFT JOIN state s on l.state_id = s.state_id
			LEFT JOIN country c on l.country_id = c.country_id
			WHERE pl.pilot_id = :pilot_id
				AND pl.pilot_location_status = 1
		");
		$pilot_locations = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));
		
		# Get the pilots clubs
		$pilot_clubs = array();
		$stmt = db_prep("
			SELECT *
			FROM club_pilot cp
			LEFT JOIN club cl ON cp.club_id = cl.club_id
			LEFT JOIN state s on s.state_id = cl.state_id
			LEFT JOIN country c on cl.country_id = c.country_id
			WHERE cp.pilot_id = :pilot_id
				AND cp.club_pilot_status = 1
		");
		$pilot_clubs = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));

		# Get the pilots events
		$pilot_events = array();
		$stmt = db_prep("
			SELECT *
			FROM event_pilot ep
			LEFT JOIN event e ON ep.event_id = e.event_id
			LEFT JOIN location l ON e.location_id = l.location_id
			LEFT JOIN state s on s.state_id = l.state_id
			LEFT JOIN country c on c.country_id = l.country_id
			WHERE ep.pilot_id = :pilot_id
				AND ep.event_pilot_status = 1
				AND e.event_status = 1
			ORDER BY e.event_start_date desc
		");
		$pilot_events = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));
		# Lets make sure this pilot can see the event
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
			foreach($pilot_events as $key => $e){
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
			$pilot_events = $newevents;
		}
	}
	
	# If they have events, lets show their Personal Bests
	$f3f_records = array();
	$f3b_records = array();
	$f3b_dist = array();
	if($pilot_events){
		# Lets get the top speeds in F3F across all of the events
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_round_flight eprf
			LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id = epr.event_pilot_round_id
			LEFT JOIN event_pilot ep ON epr.event_pilot_id = ep.event_pilot_id
			LEFT JOIN pilot p on ep.pilot_id = p.pilot_id
			LEFT JOIN event e ON ep.event_id = e.event_id
			LEFT JOIN location l ON e.location_id = l.location_id
			LEFT JOIN country c ON l.country_id = c.country_id
			WHERE ep.pilot_id = :pilot_id
				AND eprf.event_pilot_round_flight_status = 1
				AND ep.event_pilot_status = 1
				AND e.event_status = 1
				AND e.event_type_id = 1
				AND eprf.event_pilot_round_flight_seconds != 0
			ORDER BY eprf.event_pilot_round_flight_seconds
			LIMIT 0,3
		");
		$f3f_records = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));
		# Lets get the top speeds in F3B across all of the events
		$stmt = db_prep("
			SELECT *
			FROM event_pilot_round_flight eprf
			LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id = epr.event_pilot_round_id
			LEFT JOIN event_pilot ep ON epr.event_pilot_id = ep.event_pilot_id
			LEFT JOIN pilot p on ep.pilot_id = p.pilot_id
			LEFT JOIN event e ON ep.event_id = e.event_id
			LEFT JOIN location l ON e.location_id = l.location_id
			LEFT JOIN country c ON l.country_id = c.country_id
			WHERE ep.pilot_id = :pilot_id
				AND eprf.event_pilot_round_flight_status = 1
				AND ep.event_pilot_status = 1
				AND e.event_status = 1
				AND eprf.flight_type_id = 3
				AND (e.event_type_id = 2 || e.event_type_id = 3)
				AND eprf.event_pilot_round_flight_seconds != 0
			ORDER BY eprf.event_pilot_round_flight_seconds
			LIMIT 0,3
		");
		$f3b_records = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));
		# Lets get the top distance runs in F3B across all of the events
		$stmt = db_prep("
			SELECT *,p.pilot_id as record_pilot_id,pc.country_code as pilot_country_code
			FROM event_pilot_round_flight eprf
			LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id = epr.event_pilot_round_id
			LEFT JOIN event_pilot ep ON epr.event_pilot_id = ep.event_pilot_id
			LEFT JOIN pilot p on ep.pilot_id = p.pilot_id
			LEFT JOIN country pc ON p.country_id = pc.country_id
			LEFT JOIN event e ON ep.event_id = e.event_id
			LEFT JOIN location l ON e.location_id = l.location_id
			LEFT JOIN country c ON l.country_id = c.country_id
			WHERE ep.pilot_id = :pilot_id
				AND eprf.event_pilot_round_flight_status = 1
				AND ep.event_pilot_status = 1
				AND e.event_status = 1
				AND e.event_type_id = 2
				AND eprf.flight_type_id = 2
				AND eprf.event_pilot_round_flight_laps != 0
			ORDER BY eprf.event_pilot_round_flight_laps DESC
			LIMIT 0,3
		");
		$f3b_dist = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));
	}
	
	$smarty->assign("pilot",$pilot);
	$smarty->assign("pilotlist",$pilotlist);
	$smarty->assign("is_pilotlist",$is_pilotlist);
	$smarty->assign("pilot_planes",$pilot_planes);
	$smarty->assign("pilot_locations",$pilot_locations);
	$smarty->assign("pilot_events",$pilot_events);
	$smarty->assign("pilot_clubs",$pilot_clubs);
	$smarty->assign("f3f_records",$f3f_records);
	$smarty->assign("f3b_records",$f3b_records);
	$smarty->assign("f3b_dist",$f3b_dist);
	$smarty->assign("tab",$tab);
	
	$smarty->assign("states",get_states());
	$smarty->assign("countries",get_countries());
	$maintpl = find_template("my/my.tpl");
	return $smarty->fetch($maintpl);
}
function my_user_save(){
	# Function to save the user and their access
	global $user;

	$connect = $_REQUEST['connect'];
	if($connect == 1){
		# They just came from the connect screen
		$pilot_id = $_REQUEST['pilot_id'];
		if($pilot_id != 0){
			# Connect the current logged in account to the selected pilot id
			$stmt = db_prep("
				UPDATE pilot
				SET user_id = :user_id
				WHERE pilot_id = :pilot_id
			");
			$result = db_exec($stmt,array("user_id" => $GLOBALS['user_id'],"pilot_id" => $pilot_id));
			user_message("We have connected you to that existing user! Now you can edit any remaining details.");
			return my_user_show();
		}
	}

	$pilot_id = $_REQUEST['pilot_id'];
	$pilot_first_name = trim($_REQUEST['pilot_first_name']);
	$pilot_last_name = trim($_REQUEST['pilot_last_name']);
	$pilot_email = trim(strtolower($_REQUEST['pilot_email']));
	$pilot_city = trim($_REQUEST['pilot_city']);
	$state_id = intval($_REQUEST['state_id']);
	$country_id = intval($_REQUEST['country_id']);
	$pilot_ama = trim($_REQUEST['pilot_ama']);
	$pilot_fai = trim($_REQUEST['pilot_fai']);
	$pilot_fai_license = trim($_REQUEST['pilot_fai_license']);

	if($pilot_id == 0){
		# Insert new pilot info and assign the current user to it
		if($pilot_first_name == ''){
			$pilot_first_name = $GLOBALS['user']['user_first_name'];
		}
		if($pilot_last_name == ''){
			$pilot_last_name = $GLOBALS['user']['user_last_name'];
		}
		if($pilot_email == ''){
			$pilot_email = $GLOBALS['user']['user_email'];
		}
		$stmt = db_prep("
			INSERT INTO pilot
			SET pilot_first_name = :pilot_first_name,
				pilot_last_name = :pilot_last_name,
				pilot_email = :pilot_email,
				pilot_ama = :pilot_ama,
				pilot_fai = :pilot_fai,
				pilot_fai_license = :pilot_fai_license,
				pilot_city = :pilot_city,
				state_id = :state_id,
				country_id = :country_id,
				user_id = :user_id
		");
		$result = db_exec($stmt,array(
			"pilot_first_name" => $pilot_first_name,
			"pilot_last_name" => $pilot_last_name,
			"pilot_email" => $pilot_email,
			"pilot_ama" => $pilot_ama,
			"pilot_fai" => $pilot_fai,
			"pilot_fai_license" => $pilot_fai_license,
			"pilot_city" => $pilot_city,
			"state_id" => $state_id,
			"country_id" => $country_id,
			"user_id" => $GLOBALS['user_id']
		));
		user_message("User Info Created.");
	}else{
		# Update the existing pilot record
		$stmt = db_prep("
			UPDATE pilot
			SET pilot_first_name = :pilot_first_name,
				pilot_last_name = :pilot_last_name,
				pilot_email = :pilot_email,
				pilot_ama = :pilot_ama,
				pilot_fai = :pilot_fai,
				pilot_fai_license = :pilot_fai_license,
				pilot_city = :pilot_city,
				state_id = :state_id,
				country_id = :country_id
			WHERE user_id = :user_id
		");
		$result = db_exec($stmt,array(
			"pilot_first_name" => $pilot_first_name,
			"pilot_last_name" => $pilot_last_name,
			"pilot_email" => $pilot_email,
			"pilot_ama" => $pilot_ama,
			"pilot_fai" => $pilot_fai,
			"pilot_fai_license" => $pilot_fai_license,
			"pilot_city" => $pilot_city,
			"state_id" => $state_id,
			"country_id" => $country_id,
			"user_id" => $GLOBALS['user']['user_id']
		));
		# Lets update the user info that is associated with it
		$stmt = db_prep("
			UPDATE user
			SET user_first_name = :pilot_first_name,
				user_last_name = :pilot_last_name,
				user_email = :pilot_email
			WHERE user_id = :user_id
		");
		$result = db_exec($stmt,array(
			"pilot_first_name" => $pilot_first_name,
			"pilot_last_name" => $pilot_last_name,
			"pilot_email" => $pilot_email,
			"user_id" => $GLOBALS['user']['user_id']
		));
		user_message("User Info Saved.");
	}
	log_action($pilot_id);
	return my_user_show();	
}
function my_plane_edit() {
	global $smarty;
	global $user;

	$pilot_plane_id = $_REQUEST['pilot_plane_id'];

	# Get pilot plane info if exists
	$pilot_plane = array();
	if($pilot_plane_id != 0){
		$stmt = db_prep("
			SELECT *
			FROM pilot_plane pp
			LEFT JOIN plane p on p.plane_id = pp.plane_id
			WHERE pp.pilot_plane_id = :pilot_plane_id
		");
		$result = db_exec($stmt,array("pilot_plane_id" => $pilot_plane_id));
		$pilot_plane = $result[0];
	}else{
		# Lets check if we have post variables coming back from an add
		if(isset($_REQUEST['plane_name'])){
			$pilot_plane['plane_name'] = $_REQUEST['plane_name'];
		}
		if(isset($_REQUEST['plane_id'])){
			$pilot_plane['plane_id'] = $_REQUEST['plane_id'];
		}
		if(isset($_REQUEST['pilot_plane_color'])){
			$pilot_plane['pilot_plane_color'] = $_REQUEST['pilot_plane_color'];
		}
		if(isset($_REQUEST['pilot_plane_serial'])){
			$pilot_plane['pilot_plane_serial'] = $_REQUEST['pilot_plane_serial'];
		}
		if(isset($_REQUEST['pilot_plane_auw'])){
			$pilot_plane['pilot_plane_auw'] = $_REQUEST['pilot_plane_auw'];
		}
		if(isset($_REQUEST['pilot_plane_auw_units'])){
			$pilot_plane['pilot_plane_auw_units'] = $_REQUEST['pilot_plane_auw_units'];
		}
	}
	
	# Get plane media records
	$media = array();
	$stmt = db_prep("
		SELECT *
		FROM pilot_plane_media ppm
		WHERE ppm.pilot_plane_id = :pilot_plane_id
		AND ppm.pilot_plane_media_status = 1
	");
	$media = db_exec($stmt,array("pilot_plane_id" => $pilot_plane_id));

	my_user_show();
		
	$smarty->assign("pilot_plane",$pilot_plane);
	$smarty->assign("media",$media);
	$maintpl = find_template("my/my_plane_edit.tpl");
	return $smarty->fetch($maintpl);
}
function my_plane_save() {
	global $user;

	$pilot_id = get_current_pilot_id();
	$pilot_plane_id = $_REQUEST['pilot_plane_id'];
	$plane_id = $_REQUEST['plane_id'];
	$pilot_plane_color = $_REQUEST['pilot_plane_color'];
	$pilot_plane_serial = $_REQUEST['pilot_plane_serial'];
	$pilot_plane_auw = $_REQUEST['pilot_plane_auw'];
	$pilot_plane_auw_units = $_REQUEST['pilot_plane_auw_units'];

	# Save this pilot plane
	if($pilot_plane_id == 0){
		# Create a new record for this plane
		$stmt = db_prep("
			INSERT INTO pilot_plane
			SET pilot_id = :pilot_id,
				plane_id = :plane_id,
				pilot_plane_color = :pilot_plane_color,
				pilot_plane_serial = :pilot_plane_serial,
				pilot_plane_auw = :pilot_plane_auw,
				pilot_plane_auw_units = :pilot_plane_auw_units,
				pilot_plane_status = 1
		");
		$result = db_exec($stmt,array(
			"pilot_id" => $pilot_id,
			"plane_id" => $plane_id,
			"pilot_plane_color" => $pilot_plane_color,
			"pilot_plane_serial" => $pilot_plane_serial,
			"pilot_plane_auw" => $pilot_plane_auw,
			"pilot_plane_auw_units" => $pilot_plane_auw_units
		));
		user_message("Added New Plane to your quiver!");
		$_REQUEST['pilot_plane_id'] = $GLOBALS['last_insert_id'];
	}else{
		$stmt = db_prep("
			UPDATE pilot_plane
			SET plane_id = :plane_id,
				pilot_plane_color = :pilot_plane_color,
				pilot_plane_serial = :pilot_plane_serial,
				pilot_plane_auw = :pilot_plane_auw,
				pilot_plane_auw_units = :pilot_plane_auw_units
			WHERE pilot_plane_id = :pilot_plane_id
		");
		$result = db_exec($stmt,array(
			"plane_id" => $plane_id,
			"pilot_plane_color" => $pilot_plane_color,
			"pilot_plane_serial" => $pilot_plane_serial,
			"pilot_plane_auw" => $pilot_plane_auw,
			"pilot_plane_auw_units" => $pilot_plane_auw_units,
			"pilot_plane_id" => $pilot_plane_id
		));
		user_message("Updated Your Plane Info");
	}
	log_action($pilot_id);
	return my_plane_edit();
}
function my_plane_del() {
	global $user;

	$pilot_plane_id = $_REQUEST['pilot_plane_id'];

	# del this plane
	$stmt = db_prep("
		UPDATE pilot_plane
		SET pilot_plane_status = 0
		WHERE pilot_plane_id = :pilot_plane_id
	");
	$result = db_exec($stmt,array("pilot_plane_id" => $pilot_plane_id));
	log_action($pilot_plane_id);
	user_message("Removed plane from your pilot info.");
	return my_user_show();
}
function get_current_pilot_id(){
	# Get the current users pilot info
	$pilot_id = 0;
	$stmt = db_prep("
		SELECT *
		FROM pilot
		WHERE user_id = :user_id
	");
	$result = db_exec($stmt,array("user_id" => $GLOBALS['user_id']));
	if(isset($result[0])){
		$pilot_id = $result[0]['pilot_id'];
	}
	return $pilot_id;
}
function my_plane_media_edit() {
	global $smarty;
	global $user;
	
	$pilot_plane_id = $_REQUEST['pilot_plane_id'];
	
	$stmt = db_prep("
		SELECT *
		FROM pilot_plane pp
		LEFT JOIN plane p on p.plane_id = pp.plane_id
		LEFT JOIN plane_type pt on pt.plane_type_id = p.plane_type_id
		WHERE pp.pilot_plane_id = :pilot_plane_id
	");
	$result = db_exec($stmt,array("pilot_plane_id" => $pilot_plane_id));
	$plane = $result[0];
	
	$smarty->assign("plane",$plane);
	$smarty->assign("pilot_plane_id",$pilot_plane_id);
	$maintpl = find_template("my/my_plane_edit_media.tpl");
	return $smarty->fetch($maintpl);
}
function my_plane_media_add() {
	global $smarty;
	global $user;
	
	$pilot_plane_id = $_REQUEST['pilot_plane_id'];
	$pilot_plane_media_type = $_REQUEST['pilot_plane_media_type'];
	$pilot_plane_media_caption = $_REQUEST['pilot_plane_media_caption'];
	
	if($pilot_plane_media_type == 'picture'){
		# Lets upload the file and put it in place
		$tempname = $_FILES['uploaded_file']['tmp_name'];
		$name = basename(preg_replace("/\s/","\_",$_FILES['uploaded_file']['name']));
		# Lets make the directory for this pilot_plane_id if it doesn't exist
		if(!is_dir("{$GLOBALS['base_webroot']}{$GLOBALS['base_plane_media']}/$pilot_plane_id")){
			# Create the directory
			mkdir("{$GLOBALS['base_webroot']}{$GLOBALS['base_plane_media']}/$pilot_plane_id",0770);
		}
		# Now copy the file into place
		if(file_exists("{$GLOBALS['base_webroot']}{$GLOBALS['base_plane_media']}/$pilot_plane_id/$name")){
			user_message("A media file with that name already exists, please choose another and try again!");
			return my_plane_edit();
		}
		if(move_uploaded_file($tempname, "{$GLOBALS['base_webroot']}{$GLOBALS['base_plane_media']}/$pilot_plane_id/$name")) {
			user_message("File $name uploaded.");
		}else{
			user_message("There was an error uploading the file, please try again!");
			return my_plane_edit();
		}
		$pilot_plane_media_url = "{$GLOBALS['base_url']}{$GLOBALS['base_plane_media']}/$pilot_plane_id/$name";
	}else{
		$pilot_plane_media_url = $_REQUEST['pilot_plane_media_url'];
	}

	# Insert the database record for this media
	$media = array();
	$stmt = db_prep("
		INSERT INTO pilot_plane_media
		SET pilot_plane_id = :pilot_plane_id,
			pilot_plane_media_type = :pilot_plane_media_type,
			pilot_plane_media_url = :pilot_plane_media_url,
			pilot_plane_media_caption = :pilot_plane_media_caption,
			pilot_plane_media_status = 1
	");
	$result = db_exec($stmt,array("pilot_plane_id" => $pilot_plane_id,"pilot_plane_media_type" => $pilot_plane_media_type,"pilot_plane_media_url" => $pilot_plane_media_url,"pilot_plane_media_caption" => $pilot_plane_media_caption));

	log_action($pilot_plane_id);
	user_message("Added your $pilot_plane_media_type media!");
	return my_plane_edit();
}
function my_plane_media_del() {
	global $user;

	$pilot_plane_id = $_REQUEST['pilot_plane_id'];
	$pilot_plane_media_id = $_REQUEST['pilot_plane_media_id'];

	# del this media entry
	$stmt = db_prep("
		UPDATE pilot_plane_media
		SET pilot_plane_media_status = 0
		WHERE pilot_plane_media_id = :pilot_plane_media_id
	");
	$result = db_exec($stmt,array("pilot_plane_media_id" => $pilot_plane_media_id));
	log_action($pilot_plane_id);
	user_message("Removed plane media from this plane.");
	return my_plane_edit();
}
function my_location_add() {
	global $user;

	$pilot_id = get_current_pilot_id();
	$location_id  =  $_REQUEST['location_id'];
	
	# Lets see if they already have one
	$stmt = db_prep("
		SELECT *
		FROM pilot_location
		WHERE pilot_id = :pilot_id
		AND location_id = :location_id
	");
	$result = db_exec($stmt,array("pilot_id" => $pilot_id,"location_id" => $location_id));
	if($result[0]){
		# A record already exists, so update it
		$stmt = db_prep("
			UPDATE pilot_location
			SET pilot_location_status = 1
			WHERE pilot_location_id = :pilot_location_id
		");
		$result2 = db_exec($stmt,array("pilot_location_id" => $result[0]['pilot_location_id']));
	}else{
		# Create a new record for this one
		$stmt = db_prep("
			INSERT INTO pilot_location
			SET pilot_id = :pilot_id,
				location_id = :location_id,
				pilot_location_status = 1
		");
		$result2 = db_exec($stmt,array("pilot_id" => $pilot_id,"location_id" => $location_id));
	}

	log_action($pilot_id);
	user_message("Added New location");
	return my_user_show();
}
function my_location_del() {
	global $user;

	$pilot_location_id = $_REQUEST['pilot_location_id'];

	# del this location
	$stmt = db_prep("
		UPDATE pilot_location
		SET pilot_location_status = 0
		WHERE pilot_location_id = :pilot_location_id
	");
	$result = db_exec($stmt,array("pilot_location_id" => $pilot_location_id));
	log_action($pilot_location_id);
	user_message("Removed location from your pilot info.");
	return my_user_show();
}
function show_change_password(){
	# Function to reset the user password 
	global $user;
	global $fsession;
	global $smarty;
	
	# Show them the change password screen
	$maintpl = find_template("my/my_change_password.tpl");
	return $smarty->fetch($maintpl);
}
function change_password(){
	# Function to reset the user password 
	global $user;
	global $fsession;
	global $smarty;

	# Lets get the inputted strings from the URL
	$pass = $_REQUEST['pass'];
	$pass1 = $_REQUEST['pass1'];
	$pass2 = $_REQUEST['pass2'];
	# Check the existing pass first
	if(sha1($pass) != $user['user_pass']){
		user_message("Sorry, but the entered existing password does not match.",1);
		return show_change_password();
	}
	
	if($pass1 != $pass2){
		user_message("Sorry, but the two new entered passwords do not match each other.",1);
		return show_change_password();
	}

	# They have successfully come here to change their password!
	# ok, lets change it 
	$stmt = db_prep("
		UPDATE user
		SET user_pass = :pass
		WHERE user_id = :user_id
	");
	$result = db_exec($stmt,array(
		"pass" => sha1($pass1),
		"user_id" => $user['user_id']
	));
	user_message("Congratulations! You have updated your password.");
	return my_user_show();
}

?>
