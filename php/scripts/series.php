<?php
############################################################################
#	series.php
#
#	Tim Traver
#	2/17/13
#	This is the script to handle the series of events for pilot totals
#
############################################################################
$GLOBALS['current_menu']='events';

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
	$function=$_REQUEST['function'];
}else{
	$function="series_list";
}

$need_login=array(
	"series_edit",
	"series_save",
	"series_user_save",
	"series_user_delete",
	"series_location_add",
	"series_location_remove"
);
if(check_user_function($function)){
	if($GLOBALS['user_id']==0 && in_array($function, $need_login)){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit series information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		$actionoutput=$smarty->fetch($maintpl);
	}else{
		# Now check to see if they have permission to edit this club
		if(isset($_REQUEST['series_id']) && $_REQUEST['series_id']!=0){
			if(!in_array($function, $need_login) || (in_array($function, $need_login) && check_club_permission($_REQUEST['series_id']))){
				# They are allowed
				eval("\$actionoutput=$function();");
			}else{
				# They aren't allowed
				user_message("I'm sorry, but you do not have permission to edit this club. Please contact the series creator for access.",1);
				$actionoutput=series_view();
			}
		}else{
			eval("\$actionoutput=$function();");
		}
	}
}else{
	 $actionoutput= show_no_permission();
}

function series_list() {
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
		case 'series_name':
			$search_field='series_name';
			break;
		case 'series_area':
			$search_field='series_area';
			break;
		default:
			$search_field='series_name';
			break;
	}
	if($search=='' || $search=='%%'){
		$search_field='series_name';
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
		$addcountry.=" AND cl.country_id=$country_id ";
	}
	$addstate='';
	if($state_id!=0){
		$addstate.=" AND cl.state_id=$state_id ";
	}

	$series=array();
	if($search!='%%' && $search!=''){
		$stmt=db_prep("
			SELECT *
			FROM series se
			LEFT JOIN state s ON s.state_id=s.state_id
			LEFT JOIN country c ON s.country_id=c.country_id
			WHERE se.$search_field $operator :search
				$addcountry
				$addstate
			ORDER BY se.country_id,se.state_id,se.series_name
		");
		$series=db_exec($stmt,array("search"=>$search));
	}else{
		# Get all locations for search
		$stmt=db_prep("
			SELECT *
			FROM series se
			LEFT JOIN state s ON se.state_id=s.state_id
			LEFT JOIN country c ON se.country_id=c.country_id
			WHERE 1
				$addcountry
				$addstate
			ORDER BY se.country_id,se.state_id,se.series_name
		");
		$series=db_exec($stmt,array());
	}
		
	# Get only countries that we have series for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT country_id FROM series) se
		LEFT JOIN country c ON c.country_id=se.country_id
		WHERE c.country_id!=0
	");
	$countries=db_exec($stmt,array());
	# Get only states that we have locations for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT state_id FROM series) se
		LEFT JOIN state s ON s.state_id=se.state_id
		WHERE s.state_id!=0
	");
	$states=db_exec($stmt,array());
	
	$series=show_pages($series,25);
	
	$smarty->assign("series",$series);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("search_field",$GLOBALS['fsession']['search_field']);
	$smarty->assign("search_operator",$GLOBALS['fsession']['search_operator']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl=find_template("series_list.tpl");
	return $smarty->fetch($maintpl);
}
function series_view() {
	global $user;
	global $smarty;
	
	$series_id=intval($_REQUEST['series_id']);
	
	# Get the series info
	$stmt=db_prep("
		SELECT *
		FROM series se
		LEFT JOIN state s ON se.state_id=s.state_id
		LEFT JOIN country c ON se.country_id=c.country_id
		WHERE series_id=:series_id
	");
	$result=db_exec($stmt,array("series_id"=>$series_id));
	
	if(!isset($result[0])){
		user_message("A series with that id does not exist.",1);
		return series_list();
	}else{
		$series=$result[0];

		# Now lets get the events in this series
		$stmt=db_prep("
			SELECT *
			FROM event e
			LEFT JOIN location l ON e.location_id=l.location_id
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
			WHERE e.series_id=:series_id
			ORDER BY e.event_start_date DESC,l.country_id,l.state_id
		");
		$events=db_exec($stmt,array("series_id"=>$series_id));
		$smarty->assign("events",$events);
		$total_events=count($events);
		$smarty->assign("total_events",$total_events);
		
		# Check to see if we need to update the total
		if($series['series_total_events']!=$total_events){
			# Update the record
			$stmt=db_prep("
				UPDATE series 
				SET series_total_events=:series_total_events
				WHERE series_id=:series_id
			");
			$result=db_exec($stmt,array("series_id"=>$series_id,"series_total_events"=>$total_events));
		}
	}
	
	$smarty->assign("series",$series);
	$maintpl=find_template("series_view.tpl");
	return $smarty->fetch($maintpl);
}
function series_edit() {
	global $smarty;

	$series_id=intval($_REQUEST['series_id']);
	if(isset($_REQUEST['series_name'])){
		$series_name=ucwords($_REQUEST['series_name']);
	}
	
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

	$series=array();
	if($series_id!=0){
		# Get series info
		$stmt=db_prep("
			SELECT *
			FROM series se
			LEFT JOIN state s ON se.state_id=s.state_id
			LEFT JOIN country c ON se.country_id=c.country_id
			WHERE se.series_id=:series_id
		");
		$result=db_exec($stmt,array("series_id"=>$series_id));
		$series=$result[0];
	}else{
		# Set the name
		$series['series_name']=$series_name;
	}
	
	# Now lets get the users that have additional access
	$stmt=db_prep("
		SELECT *
		FROM series_user su
		LEFT JOIN pilot p ON su.pilot_id=p.pilot_id
		LEFT JOIN state s ON p.state_id=s.state_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE su.series_id=:series_id
			AND su.series_user_status=1
	");
	$series_users=db_exec($stmt,array("series_id"=>$club_id));
	$smarty->assign("series_users",$series_users);
	
	$smarty->assign("countries",get_countries());
	$smarty->assign("states",get_states());
	$smarty->assign("series",$series);

	$maintpl=find_template("series_edit.tpl");
	return $smarty->fetch($maintpl);
}
function series_save() {
	global $smarty;
	global $user;

	$country_id=intval($_REQUEST['country_id']);
	$state_id=intval($_REQUEST['state_id']);
	$series_name=$_REQUEST['series_name'];
	$series_id=intval($_REQUEST['series_id']);
	$series_area=$_REQUEST['series_area'];
	$series_url=$_REQUEST['series_url'];

	if($series_id==0){
		$stmt=db_prep("
			INSERT INTO series
			SET pilot_id=:pilot_id,
				series_name=:series_name,
				series_area=:series_area,
				state_id=:state_id,
				country_id=:country_id,
				series_url=:series_url
		");
		$result=db_exec($stmt,array(
			"pilot_id"=>$user['pilot_id'],
			"series_name"=>$series_name,
			"series_area"=>$series_area,
			"state_id"=>$state_id,
			"country_id"=>$country_id,
			"series_url"=>$series_url
		));

		user_message("Added your New Series!");
		$_REQUEST['series_id']=$GLOBALS['last_insert_id'];
		$series_id=$GLOBALS['last_insert_id'];
	}else{
		# Save the database record for this club
		$stmt=db_prep("
			UPDATE series
			SET series_name=:series_name,
				series_area=:series_area,
				state_id=:state_id,
				country_id=:country_id,
				series_url=:series_url
			WHERE series_id=:series_id
		");
		$result=db_exec($stmt,array(
			"series_name"=>$series_name,
			"series_area"=>$series_area,
			"state_id"=>$state_id,
			"country_id"=>$country_id,
			"series_url"=>$series_url,
			"series_id"=>$series_id
		));
		user_message("Updated Base Series Info!");
	}
	log_action($series_id);
	if(isset($_REQUEST['from_action'])){
		# This came from somewhere else, so go back to that screen
		# But lets add the new location id to the list
		$from['series_id']=$series_id;
		$from['series_name']=$series_name;
		$from['from_action']='series';
		return return_to_action($from);
	}else{
		return series_edit();
	}
}



function club_user_save() {
	global $smarty;
	global $user;
	
	$club_id=intval($_REQUEST['club_id']);
	$pilot_id=intval($_REQUEST['pilot_id']);

	if($pilot_id==0){
		user_message("Cannot add a blank user for access.",1);
		return club_edit();
	}
	# Get the current user pilot id to make sure they don't add themselves
	$stmt=db_prep("
		SELECT *
		FROM club cl
		WHERE club_id=:club_id
	");
	$result=db_exec($stmt,array("club_id"=>$club_id));
	if(isset($result[0])){
		$club=$result[0];
	}
	if($club['pilot_id']==$pilot_id){
		user_message("You do not need to give access to yourself, as you will always have access as the owner of this club.");
		return club_edit();
	}
	
	# Now lets check to see if this is the club owner, because only they can add an club user
	if($club['pilot_id']!=$user['pilot_id']){
		user_message("You do not have access to give anyone else access. Only the club owner can do that.",1);
		return club_edit();
	}
	
	# Lets first see if this one is already added
	$stmt=db_prep("
		SELECT *
		FROM club_user
		WHERE club_id=:club_id
			AND pilot_id=:pilot_id
	");
	$result=db_exec($stmt,array("club_id"=>$club_id,"pilot_id"=>$pilot_id));
	
	if(isset($result[0])){
		# This record already exists, so lets just turn it on
		$stmt=db_prep("
			UPDATE club_user
			SET club_user_status=1
			WHERE club_user_id=:club_user_id
		");
		$result=db_exec($stmt,array("club_user_id"=>$result[0]['club_user_id']));
	}else{
		# Lets create a new record
		$stmt=db_prep("
			INSERT INTO club_user
			SET club_id=:club_id,
				pilot_id=:pilot_id,
				club_user_status=1
		");
		$result=db_exec($stmt,array(
			"club_id"=>$club_id,
			"pilot_id"=>$pilot_id
		));
	}
	user_message("New user given access to edit this club.");
	return club_edit();
}
function club_user_delete() {
	global $smarty;
	global $user;
	
	$club_id=intval($_REQUEST['club_id']);
	$club_user_id=intval($_REQUEST['club_user_id']);

	# Lets see if they are allowed to do this
	$stmt=db_prep("
		SELECT *
		FROM club
		WHERE club_id=:club_id
	");
	$result=db_exec($stmt,array("club_id"=>$club_id));
	if(isset($result[0])){
		$club=$result[0];
	}
	
	# Now lets check to see if this is the club owner, because only they can delete a user
	if($club['pilot_id']!=$user['pilot_id']){
		user_message("You do not have access to remove access to this club. Only the club owner can do that.",1);
		return club_edit();
	}

	# Lets turn off this record
	$stmt=db_prep("
		UPDATE club_user
		SET club_user_status=0
		WHERE club_user_id=:club_user_id
	");
	$result=db_exec($stmt,array("club_user_id"=>$club_user_id));
	
	user_message("Removed user access to edit this club.");
	return club_edit();
}
function club_location_add() {
	global $smarty;
	
	$club_id=intval($_REQUEST['club_id']);
	if($club_id==0){
		user_message("That is not a proper club id to add a location to.");
		return club_list();
	}
	$location_id=intval($_REQUEST['location_id']);
	
	# If pilot_id is zero, then send them to the quick add pilot screen
	if($location_id==0){
		user_message("Must select a location from the searched list or create a new one.",1);
		return club_view();
	}else{
		# Check to see if the location already exists in this club
		$stmt=db_prep("
			SELECT *
			FROM club_location cl
			WHERE cl.club_id=:club_id
				AND cl.location_id=:location_id
		");
		$result=db_exec($stmt,array("club_id"=>$club_id,"location_id"=>$location_id));
		if(isset($result[0])){
			# The record already exists, so lets see if it has its status to 1 or not
			if($result[0]['club_location_status']==1){
				# This record already exists!
				user_message("The Location you have chosen to add is already in this club.",1);
				return club_view();
			}else{
				# Lets turn this record back on
				$stmt=db_prep("
					UPDATE club_location
					SET club_location_status=1
					WHERE club_location_id=:club_location_id
				");
				$result2=db_exec($stmt,array("club_location_id"=>$result[0]['club_location_id']));
				$_REQUEST['club_location_id']=$result[0]['club_location_id'];
			}
		}else{
			# This record doesn't exist, so lets add it
			$stmt=db_prep("
				INSERT INTO club_location
				SET club_id=:club_id,
					location_id=:location_id,
					club_location_status=1
			");
			$result2=db_exec($stmt,array("club_id"=>$club_id,"location_id"=>$location_id));
			$_REQUEST['club_location_id']=$GLOBALS['last_insert_id'];
		}
		user_message("Location Added to club.");
		return club_view();
	}
}
function club_location_remove() {
	global $smarty;

	$club_id=intval($_REQUEST['club_id']);
	$club_location_id=$_REQUEST['club_location_id'];

	$stmt=db_prep("
		UPDATE club_location
		SET club_location_status=0
		WHERE club_location_id=:club_location_id
	");
	$result=db_exec($stmt,array("club_location_id"=>$club_location_id));
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
	$stmt=db_prep("
		SELECT *
		FROM club
		WHERE club_id=:club_id
	");
	$result=db_exec($stmt,array("club_id"=>$club_id));
	$club=$result[0];

	if($club['pilot_id']==$user['pilot_id']){
		# This is the owner of the club, so of course he has access
		return 1;
	}
	$allowed=0;
	# Now lets get the other permissions
	$stmt=db_prep("
		SELECT *
		FROM club_user
		WHERE club_id=:club_id
			AND club_user_status=1
	");
	$users=db_exec($stmt,array("club_id"=>$club_id));
	foreach($users as $u){
		if($user['pilot_id']==$u['pilot_id']){
			$allowed=1;
		}
	}
	return $allowed;
}
function club_add_pilot() {
	global $smarty;

	$club_id=intval($_REQUEST['club_id']);
	if($club_id==0){
		user_message("That is not a proper club id to add a pilot to.");
		return club_view();
	}
	$pilot_id=intval($_REQUEST['pilot_id']);
	
	# If pilot_id is zero, then send them to the quick add pilot screen
	if($pilot_id==0){
		return club_pilot_quick_add();
	}else{
		# Check to see if the pilot already exists in this club
		$stmt=db_prep("
			SELECT *
			FROM club_pilot cp
			WHERE cp.club_id=:club_id
				AND cp.pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("club_id"=>$club_id,"pilot_id"=>$pilot_id));
		if(isset($result[0])){
			# The record already exists, so lets see if it has its status to 1 or not
			if($result[0]['club_pilot_status']==1){
				# This record already exists!
				user_message("The Pilot you have chosen to add is already in this club.",1);
				return club_view();
			}else{
				# Lets turn this record back on
				$stmt=db_prep("
					UPDATE club_pilot
					SET club_pilot_status=1
					WHERE club_pilot_id=:club_pilot_id
				");
				$result2=db_exec($stmt,array("club_pilot_id"=>$result[0]['club_pilot_id']));
				$_REQUEST['club_pilot_id']=$result[0]['club_pilot_id'];
				
			}
		}else{
			# This record doesn't exist, so lets add it
			$stmt=db_prep("
				INSERT INTO club_pilot
				SET club_id=:club_id,
					pilot_id=:pilot_id,
					club_pilot_status=1
			");
			$result2=db_exec($stmt,array("club_id"=>$club_id,"pilot_id"=>$pilot_id));
			$_REQUEST['club_pilot_id']=$GLOBALS['last_insert_id'];
		}
		user_message("Pilot Added to club.");
		return club_view();
	}
}
function club_pilot_quick_add() {
	global $smarty;

	$club_id=intval($_REQUEST['club_id']);
	$pilot_name=ucwords($_REQUEST['pilot_name']);

	$club=array();
	$stmt=db_prep("
		SELECT *
		FROM club cl
		LEFT JOIN state s ON cl.state_id=s.state_id
		LEFT JOIN country c ON cl.country_id=c.country_id
		WHERE cl.club_id=:club_id
	");
	$result=db_exec($stmt,array("club_id"=>$club_id));
	$club=$result[0];
	$smarty->assign("club",$club);
	
	#Lets split apart the first and last names
	$name=preg_split("/\s/",$pilot_name,2);
	$smarty->assign("pilot_first_name",$name[0]);
	$smarty->assign("pilot_last_name",$name[1]);

	$smarty->assign("states",get_states());
	$smarty->assign("countries",get_countries());

	$maintpl=find_template("club_pilot_quick_add.tpl");
	return $smarty->fetch($maintpl);
}
function club_save_pilot_quick_add() {
	global $smarty;

	$club_id=intval($_REQUEST['club_id']);
	$pilot_first_name=$_REQUEST['pilot_first_name'];
	$pilot_last_name=$_REQUEST['pilot_last_name'];
	$pilot_city=$_REQUEST['pilot_city'];
	$state_id=intval($_REQUEST['state_id']);
	$country_id=intval($_REQUEST['country_id']);
	$pilot_ama=$_REQUEST['pilot_ama'];
	$pilot_fai=$_REQUEST['pilot_fai'];
	$pilot_email=$_REQUEST['pilot_email'];

	# Lets add the pilot to the pilot table
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
	
	# Now lets add him to the current club
	$stmt=db_prep("
		INSERT INTO club_pilot
		SET club_id=:club_id,
			pilot_id=:pilot_id,
			club_pilot_status=1
	");
	$result2=db_exec($stmt,array("club_id"=>$club_id,"pilot_id"=>$pilot_id));
	user_message("New pilot created and added to club.");
	return club_view();
}
function club_pilot_remove() {
	global $smarty;

	$club_id=intval($_REQUEST['club_id']);
	$club_pilot_id=$_REQUEST['club_pilot_id'];

	$stmt=db_prep("
		UPDATE club_pilot
		SET club_pilot_status=0
		WHERE club_pilot_id=:club_pilot_id
	");
	$result=db_exec($stmt,array("club_pilot_id"=>$club_pilot_id));
	user_message("Pilot removed from club.");
	return club_view();
}
?>
