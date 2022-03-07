<?php
############################################################################
#	club.php
#
#	Tim Traver
#	2/17/13
#	This is the script to handle the pilots
#
############################################################################
$smarty->assign("current_menu",'clubs');

if(isset($_REQUEST['function']) && $_REQUEST['function'] != '') {
	$function = $_REQUEST['function'];
}else{
	$function = "club_list";
}

$need_login = array(
	"club_edit",
	"club_save",
	"club_user_save",
	"club_user_delete",
	"club_location_add",
	"club_location_remove",
	"club_location_remove",
	"club_pilot_quick_add",
	"club_save_pilot_quick_add",
	"club_pilot_remove"
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
		# Now check to see if they have permission to edit this club
		if(isset($_REQUEST['club_id']) && $_REQUEST['club_id'] != 0){
			if(!in_array($function, $need_login) || (in_array($function, $need_login) && check_club_permission($_REQUEST['club_id']))){
				# They are allowed
				eval("\$actionoutput = $function();");
			}else{
				# They aren't allowed
				user_message("Sorry, but you do not have permission to edit this club. Please contact the club creator for access.",1);
				$actionoutput = club_view();
			}
		}else{
			eval("\$actionoutput = $function();");
		}
	}
}else{
	 $actionoutput =  show_no_permission();
}

function club_list() {
	global $smarty;

	$country_id = 0;
	$state_id = 0;
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

	$search = '';
	if(isset($_REQUEST['search']) ){
		$search = $_REQUEST['search'];
		$GLOBALS['fsession']['search'] = $_REQUEST['search'];
	}elseif(isset($GLOBALS['fsession']['search']) && $GLOBALS['fsession']['search'] != ''){
		$search = $GLOBALS['fsession']['search'];
	}
	
	$addcountry = '';
	if($country_id != 0){
		$addcountry .= " AND cl.country_id = $country_id ";
	}
	$addstate = '';
	if($state_id != 0){
		$addstate .= " AND cl.state_id = $state_id ";
	}

	$clubs = array();
	if($search != '%%' && $search != ''){
		$stmt = db_prep("
			SELECT  * 
			FROM club cl
			LEFT JOIN state s ON cl.state_id = s.state_id
			LEFT JOIN country c ON cl.country_id = c.country_id
			WHERE ( cl.club_name LIKE :search OR cl.club_city LIKE :search2)
				$addcountry
				$addstate
			ORDER BY cl.country_id,cl.state_id,cl.club_name
		");
		$clubs = db_exec($stmt,array(
			"search" => '%'.$search.'%',
			"search2" => '%'.$search.'%'
		));
	}else{
		# Get all locations for search
		$stmt = db_prep("
			SELECT  * 
			FROM club cl
			LEFT JOIN state s ON cl.state_id = s.state_id
			LEFT JOIN country c ON cl.country_id = c.country_id
			WHERE 1
				$addcountry
				$addstate
			ORDER BY cl.country_id,cl.state_id,cl.club_name
		");
		$clubs = db_exec($stmt,array());
	}
		
	# Get only countries that we have clubs for
	$stmt = db_prep("
		SELECT  * 
		FROM ( SELECT DISTINCT country_id FROM club) cl
		LEFT JOIN country c ON c.country_id = cl.country_id
		WHERE cl.country_id != 0
	");
	$countries = db_exec($stmt,array());
	# Get only states that we have locations for
	$stmt = db_prep("
		SELECT  * 
		FROM ( SELECT DISTINCT state_id FROM club) cl
		LEFT JOIN state s ON s.state_id = cl.state_id
		WHERE s.state_id != 0
	");
	$states = db_exec($stmt,array());
	
	$clubs = show_pages($clubs,"action=club&function=club_list");
	
	$smarty->assign("clubs",$clubs);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("search_field",$GLOBALS['fsession']['search_field']);
	$smarty->assign("search_operator",$GLOBALS['fsession']['search_operator']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl = find_template("club/club_list.tpl");
	return $smarty->fetch($maintpl);
}
function club_view() {
	global $user;
	global $smarty;
	
	$club_id = intval($_REQUEST['club_id']);
	$tab = intval($_REQUEST['tab']);
	
	# Get the club info
	$stmt = db_prep("
		SELECT  * 
		FROM club cl
		LEFT JOIN state s ON cl.state_id = s.state_id
		LEFT JOIN country c ON cl.country_id = c.country_id
		WHERE club_id =:club_id
	");
	$result = db_exec($stmt,array("club_id" => $club_id));
	
	if(!isset($result[0])){
		user_message("A club with that id does not exist.",1);
		return club_list();
	}else{
		$club = $result[0];
		
		# Now lets get the pilots assigned to this club
		$stmt = db_prep("
			SELECT  * 
			FROM club_pilot cp
			LEFT JOIN pilot p ON cp.pilot_id = p.pilot_id
			LEFT JOIN state s ON p.state_id = s.state_id
			LEFT JOIN country c ON p.country_id = c.country_id
			WHERE cp.club_id =:club_id
				AND cp.club_pilot_status = 1
		");
		$pilots = db_exec($stmt,array("club_id" => $club_id));
		$smarty->assign("pilots",$pilots);
		$total_pilots = count($pilots);
		$smarty->assign("total_pilots",$total_pilots);
		
		# Check to see if we need to update the total
		if($club['club_total_members'] != $total_pilots){
			# Update the record
			$stmt = db_prep("
				UPDATE club 
				SET club_total_members =:club_total_members
				WHERE club_id =:club_id
			");
			$result = db_exec($stmt,array("club_id" => $club_id,"club_total_members" => $total_pilots));
		}
		
		# Get the club locations
		$club_locations = array();
		$stmt = db_prep("
			SELECT  * 
			FROM club_location cl
			LEFT JOIN location l ON l.location_id = cl.location_id
			LEFT JOIN state s on s.state_id = l.state_id
			LEFT JOIN country c on c.country_id = l.country_id
			WHERE cl.club_id =:club_id
				AND cl.club_location_status = 1
		");
		$club_locations = db_exec($stmt,array("club_id" => $club['club_id']));
	}
	
	$smarty->assign("club",$club);
	$smarty->assign("club_locations",$club_locations);
	$smarty->assign("tab",$tab);
	$maintpl = find_template("club/club_view.tpl");
	return $smarty->fetch($maintpl);
}
function club_edit() {
	global $smarty;

	$club_id = intval($_REQUEST['club_id']);
	if(isset($_REQUEST['club_name'])){
		$club_name = ucwords($_REQUEST['club_name']);
	}
	
	# Start off with the same info as the view fo rthe tabs
	club_view();
	
	if(isset($_REQUEST['from_action'])){
		# Lets make an array of all of the return values
		foreach($_REQUEST as $key => $value){
			if(preg_match("/from_(\S+)/",$key,$match)){
				$from[] = array("key" => $key,"value" => $value);
			}
		}
		# Now lets add that array to the template
		$smarty->assign("from",$from);
	}

	$club = array();
	if($club_id != 0){
		# Get club info
		$stmt = db_prep("
			SELECT  * 
			FROM club cl
			LEFT JOIN state s ON cl.state_id = s.state_id
			LEFT JOIN country c ON cl.country_id = c.country_id
			WHERE cl.club_id =:club_id
		");
		$result = db_exec($stmt,array("club_id" => $club_id));
		$club = $result[0];
	}else{
		# Set the name
		$club['club_name'] = $club_name;
	}
	
	# Now lets get the users that have additional access
	$stmt = db_prep("
		SELECT  * 
		FROM club_user cu
		LEFT JOIN pilot p ON cu.pilot_id = p.pilot_id
		LEFT JOIN state s ON p.state_id = s.state_id
		LEFT JOIN country c ON p.country_id = c.country_id
		WHERE cu.club_id =:club_id
			AND cu.club_user_status = 1
	");
	$club_users = db_exec($stmt,array("club_id" => $club_id));
	$smarty->assign("club_users",$club_users);
	
	$smarty->assign("countries",get_countries());
	$smarty->assign("states",get_states());
	$smarty->assign("club",$club);
	$smarty->assign("tab",$tab);

	$maintpl = find_template("club/club_edit.tpl");
	return $smarty->fetch($maintpl);
}
function club_save() {
	global $smarty;
	global $user;

	$country_id = intval($_REQUEST['country_id']);
	$state_id = intval($_REQUEST['state_id']);
	$club_name = $_REQUEST['club_name'];
	$club_id = intval($_REQUEST['club_id']);
	$club_city = $_REQUEST['club_city'];
	$club_url = $_REQUEST['club_url'];
	# Get the dates
	$club_charter_date = $_REQUEST['club_charter_dateYear']."-".$_REQUEST['club_charter_dateMonth']."-".$_REQUEST['club_charter_dateDay'];

	if($club_id == 0){
		$stmt = db_prep("
			INSERT INTO club
			SET pilot_id =:pilot_id,
				club_name =:club_name,
				club_city =:club_city,
				state_id =:state_id,
				country_id =:country_id,
				club_charter_date =:club_charter_date,
				club_url =:club_url
		");
		$result = db_exec($stmt,array(
			"pilot_id" => $user['pilot_id'],
			"club_name" => $club_name,
			"club_city" => $club_city,
			"state_id" => $state_id,
			"country_id" => $country_id,
			"club_charter_date" => $club_charter_date,
			"club_url" => $club_url
		));

		user_message("Added your New Club!");
		$_REQUEST['club_id'] = $GLOBALS['last_insert_id'];
		$club_id = $GLOBALS['last_insert_id'];
	}else{
		# Save the database record for this club
		$stmt = db_prep("
			UPDATE club
			SET club_name =:club_name,
				club_city =:club_city,
				state_id =:state_id,
				country_id =:country_id,
				club_charter_date =:club_charter_date,
				club_url =:club_url
			WHERE club_id =:club_id
		");
		$result = db_exec($stmt,array(
			"club_name" => $club_name,
			"club_city" => $club_city,
			"state_id" => $state_id,
			"country_id" => $country_id,
			"club_charter_date" => $club_charter_date,
			"club_url" => $club_url,
			"club_id" => $club_id
		));
		user_message("Updated Base Club Info!");
	}
	log_action($club_id);
	if(isset($_REQUEST['from_action'])){
		# This came from somewhere else, so go back to that screen
		# But lets add the new location id to the list
		$from['club_id'] = $club_id;
		$from['club_name'] = $club_name;
		$from['from_action'] = 'club';
		return return_to_action($from);
	}else{
		return club_edit();
	}
}
function club_user_save() {
	global $smarty;
	global $user;
	
	$club_id = intval($_REQUEST['club_id']);
	$pilot_id = intval($_REQUEST['pilot_id']);

	if($pilot_id == 0){
		user_message("Cannot add a blank user for access.",1);
		return club_edit();
	}
	# Get the current user pilot id to make sure they don't add themselves
	$stmt = db_prep("
		SELECT  * 
		FROM club cl
		WHERE club_id =:club_id
	");
	$result = db_exec($stmt,array("club_id" => $club_id));
	if(isset($result[0])){
		$club = $result[0];
	}
	if($club['pilot_id'] == $pilot_id){
		user_message("You do not need to give access to yourself, as you will always have access as the owner of this club.");
		return club_edit();
	}
	
	# Now lets check to see if this is the club owner, because only they can add an club user
	if($club['pilot_id'] != $user['pilot_id']){
		user_message("You do not have access to give anyone else access. Only the club owner can do that.",1);
		return club_edit();
	}
	
	# Lets first see if this one is already added
	$stmt = db_prep("
		SELECT  * 
		FROM club_user
		WHERE club_id =:club_id
			AND pilot_id =:pilot_id
	");
	$result = db_exec($stmt,array("club_id" => $club_id,"pilot_id" => $pilot_id));
	
	if(isset($result[0])){
		# This record already exists, so lets just turn it on
		$stmt = db_prep("
			UPDATE club_user
			SET club_user_status = 1
			WHERE club_user_id =:club_user_id
		");
		$result = db_exec($stmt,array("club_user_id" => $result[0]['club_user_id']));
	}else{
		# Lets create a new record
		$stmt = db_prep("
			INSERT INTO club_user
			SET club_id =:club_id,
				pilot_id =:pilot_id,
				club_user_status = 1
		");
		$result = db_exec($stmt,array(
			"club_id" => $club_id,
			"pilot_id" => $pilot_id
		));
	}
	log_action($club_id);
	user_message("New user given access to edit this club.");
	return club_edit();
}
function club_user_delete() {
	global $smarty;
	global $user;
	
	$club_id = intval($_REQUEST['club_id']);
	$club_user_id = intval($_REQUEST['club_user_id']);

	# Lets see if they are allowed to do this
	$stmt = db_prep("
		SELECT  * 
		FROM club
		WHERE club_id =:club_id
	");
	$result = db_exec($stmt,array("club_id" => $club_id));
	if(isset($result[0])){
		$club = $result[0];
	}
	
	# Now lets check to see if this is the club owner, because only they can delete a user
	if($club['pilot_id'] != $user['pilot_id']){
		user_message("You do not have access to remove access to this club. Only the club owner can do that.",1);
		return club_edit();
	}

	# Lets turn off this record
	$stmt = db_prep("
		UPDATE club_user
		SET club_user_status = 0
		WHERE club_user_id =:club_user_id
	");
	$result = db_exec($stmt,array("club_user_id" => $club_user_id));
	
	log_action($club_id);
	user_message("Removed user access to edit this club.");
	return club_edit();
}
function club_location_add() {
	global $smarty;
	
	$club_id = intval($_REQUEST['club_id']);
	if($club_id == 0){
		user_message("That is not a proper club id to add a location to.");
		return club_list();
	}
	$location_id = intval($_REQUEST['location_id']);
	
	# If pilot_id is zero, then send them to the quick add pilot screen
	if($location_id == 0){
		user_message("Must select a location from the searched list or create a new one.",1);
		return club_view();
	}
	# Check to see if the location already exists in this club
	$stmt = db_prep("
		SELECT  * 
		FROM club_location cl
		WHERE cl.club_id =:club_id
			AND cl.location_id =:location_id
	");
	$result = db_exec($stmt,array("club_id" => $club_id,"location_id" => $location_id));
	if(isset($result[0])){
		# The record already exists, so lets see if it has its status to 1 or not
		if($result[0]['club_location_status'] == 1){
			# This record already exists!
			user_message("The Location you have chosen to add is already in this club.",1);
			return club_view();
		}else{
			# Lets turn this record back on
			$stmt = db_prep("
				UPDATE club_location
				SET club_location_status = 1
				WHERE club_location_id =:club_location_id
			");
			$result2 = db_exec($stmt,array("club_location_id" => $result[0]['club_location_id']));
			$_REQUEST['club_location_id'] = $result[0]['club_location_id'];
		}
	}else{
		# This record doesn't exist, so lets add it
		$stmt = db_prep("
			INSERT INTO club_location
			SET club_id =:club_id,
				location_id =:location_id,
				club_location_status = 1
		");
		$result2 = db_exec($stmt,array("club_id" => $club_id,"location_id" => $location_id));
		$_REQUEST['club_location_id'] = $GLOBALS['last_insert_id'];
	}
	log_action($club_id);
	user_message("Location Added to club.");
	return club_view();
}
function club_location_remove() {
	global $smarty;

	$club_id = intval($_REQUEST['club_id']);
	$club_location_id = $_REQUEST['club_location_id'];

	$stmt = db_prep("
		UPDATE club_location
		SET club_location_status = 0
		WHERE club_location_id =:club_location_id
	");
	$result = db_exec($stmt,array("club_location_id" => $club_location_id));
	log_action($club_id);
	user_message("Location removed from club.");
	return club_view();
}
function check_club_permission($club_id){
	global $user;
	# Function to check to see if this user can edit this club
	# First check if its an administrator
	if($user['user_admin']){
		return 1;
	}
	# Get club info
	$stmt = db_prep("
		SELECT  * 
		FROM club
		WHERE club_id =:club_id
	");
	$result = db_exec($stmt,array("club_id" => $club_id));
	$club = $result[0];

	if($club['pilot_id'] == $user['pilot_id']){
		# This is the owner of the club, so of course he has access
		return 1;
	}
	$allowed = 0;
	# Now lets get the other permissions
	$stmt = db_prep("
		SELECT  * 
		FROM club_user
		WHERE club_id =:club_id
			AND club_user_status = 1
	");
	$users = db_exec($stmt,array("club_id" => $club_id));
	foreach($users as $u){
		if($user['pilot_id'] == $u['pilot_id']){
			$allowed = 1;
		}
	}
	return $allowed;
}
function club_add_pilot() {
	global $smarty;

	$club_id = intval($_REQUEST['club_id']);
	if($club_id == 0){
		user_message("That is not a proper club id to add a pilot to.");
		return club_view();
	}
	$pilot_id = intval($_REQUEST['pilot_id']);
	
	# If pilot_id is zero, then send them to the quick add pilot screen
	if($pilot_id == 0){
		return club_pilot_quick_add();
	}
	# Check to see if the pilot already exists in this club
	$stmt = db_prep("
		SELECT  * 
		FROM club_pilot cp
		WHERE cp.club_id =:club_id
			AND cp.pilot_id =:pilot_id
	");
	$result = db_exec($stmt,array("club_id" => $club_id,"pilot_id" => $pilot_id));
	if(isset($result[0])){
		# The record already exists, so lets see if it has its status to 1 or not
		if($result[0]['club_pilot_status'] == 1){
			# This record already exists!
			user_message("The Pilot you have chosen to add is already in this club.",1);
			return club_view();
		}else{
			# Lets turn this record back on
			$stmt = db_prep("
				UPDATE club_pilot
				SET club_pilot_status = 1
				WHERE club_pilot_id =:club_pilot_id
			");
			$result2 = db_exec($stmt,array("club_pilot_id" => $result[0]['club_pilot_id']));
			$_REQUEST['club_pilot_id'] = $result[0]['club_pilot_id'];
			
		}
	}else{
		# This record doesn't exist, so lets add it
		$stmt = db_prep("
			INSERT INTO club_pilot
			SET club_id =:club_id,
				pilot_id =:pilot_id,
				club_pilot_status = 1
		");
		$result2 = db_exec($stmt,array("club_id" => $club_id,"pilot_id" => $pilot_id));
		$_REQUEST['club_pilot_id'] = $GLOBALS['last_insert_id'];
	}
	log_action($club_id);
	user_message("Pilot Added to club.");
	return club_view();
}
function club_pilot_quick_add() {
	global $smarty;

	$club_id = intval($_REQUEST['club_id']);
	$pilot_name = ucwords($_REQUEST['pilot_name']);

	$club = array();
	$stmt = db_prep("
		SELECT  * 
		FROM club cl
		LEFT JOIN state s ON cl.state_id = s.state_id
		LEFT JOIN country c ON cl.country_id = c.country_id
		WHERE cl.club_id =:club_id
	");
	$result = db_exec($stmt,array("club_id" => $club_id));
	$club = $result[0];
	$smarty->assign("club",$club);
	
	#Lets split apart the first and last names
	$name = preg_split("/\s/",$pilot_name,2);
	$smarty->assign("pilot_first_name",$name[0]);
	$smarty->assign("pilot_last_name",$name[1]);

	$smarty->assign("states",get_states());
	$smarty->assign("countries",get_countries());

	$maintpl = find_template("club/club_pilot_quick_add.tpl");
	return $smarty->fetch($maintpl);
}
function club_save_pilot_quick_add() {
	global $smarty;

	$club_id = intval($_REQUEST['club_id']);
	$pilot_first_name = trim($_REQUEST['pilot_first_name']);
	$pilot_last_name = trim($_REQUEST['pilot_last_name']);
	$pilot_city = trim($_REQUEST['pilot_city']);
	$state_id = intval($_REQUEST['state_id']);
	$country_id = intval($_REQUEST['country_id']);
	$pilot_ama = trim($_REQUEST['pilot_ama']);
	$pilot_fai = trim($_REQUEST['pilot_fai']);
	$pilot_fai_license = trim($_REQUEST['pilot_fai_license']);
	$pilot_email = trim(strtolower($_REQUEST['pilot_email']));

	# Lets add the pilot to the pilot table
	$stmt = db_prep("
		INSERT INTO pilot
		SET pilot_user_id = 0,
			pilot_first_name =:pilot_first_name,
			pilot_last_name =:pilot_last_name,
			pilot_email =:pilot_email,
			pilot_ama =:pilot_ama,
			pilot_fai =:pilot_fai,
			pilot_fai_license =:pilot_fai_license,
			pilot_city =:pilot_city,
			state_id =:state_id,
			country_id =:country_id
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
	));
	$pilot_id = $GLOBALS['last_insert_id'];
	
	# Now lets add him to the current club
	$stmt = db_prep("
		INSERT INTO club_pilot
		SET club_id =:club_id,
			pilot_id =:pilot_id,
			club_pilot_status = 1
	");
	$result2 = db_exec($stmt,array("club_id" => $club_id,"pilot_id" => $pilot_id));
	log_action($club_id);
	user_message("New pilot created and added to club.");
	return club_view();
}
function club_pilot_remove() {
	global $smarty;

	$club_id = intval($_REQUEST['club_id']);
	$club_pilot_id = $_REQUEST['club_pilot_id'];

	$stmt = db_prep("
		UPDATE club_pilot
		SET club_pilot_status = 0
		WHERE club_pilot_id =:club_pilot_id
	");
	$result = db_exec($stmt,array("club_pilot_id" => $club_pilot_id));
	log_action($club_id);
	user_message("Pilot removed from club.");
	return club_view();
}
?>
