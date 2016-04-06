<?php
############################################################################
#	series.php
#
#	Tim Traver
#	2/17/13
#	This is the script to handle the series of events for pilot totals
#
############################################################################
$smarty->assign("current_menu",'events');

include_library("series.class");

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
	$function=$_REQUEST['function'];
}else{
	$function="series_list";
}

$need_login=array(
	"series_edit",
	"series_save",
	"series_save_multiples",
	"series_param_save",
	"series_option_add_drop",
	"series_user_save",
	"series_user_delete",
	"series_event_save",
	"series_event_delete"
);
if(check_user_function($function)){
	if($GLOBALS['user_id']==0 && in_array($function, $need_login)){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to use this feature.",1);
		$smarty->assign("redirect_action",$_REQUEST['action']);
		$smarty->assign("redirect_function",$_REQUEST['function']);
		$smarty->assign("request",$_REQUEST);
		$maintpl=find_template("feature_requires_login.tpl");
		$actionoutput=$smarty->fetch($maintpl);
	}else{
		# Now check to see if they have permission to edit this club
		if(isset($_REQUEST['series_id']) && $_REQUEST['series_id']!=0){
			if(!in_array($function, $need_login) || (in_array($function, $need_login) && check_series_permission($_REQUEST['series_id']))){
				# They are allowed
				eval("\$actionoutput=$function();");
			}else{
				# They aren't allowed
				user_message("Sorry, but you do not have permission to edit this club. Please contact the series creator for access.",1);
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
		$GLOBALS['fsession']['search']=$_REQUEST['search'];
	}elseif(isset($GLOBALS['fsession']['search']) && $GLOBALS['fsession']['search']!=''){
		$search=$GLOBALS['fsession']['search'];
	}
	if($search=='' || $search=='%%'){
		$search_field='series_name';
	}
	
	$addcountry='';
	if($country_id!=0){
		$addcountry.=" AND c.country_id=$country_id ";
	}
	$addstate='';
	if($state_id!=0){
		$addstate.=" AND s.state_id=$state_id ";
	}

	$series=array();
	if($search!='%%' && $search!=''){
		$stmt=db_prep("
			SELECT *
			FROM series se
			LEFT JOIN state s ON se.state_id=s.state_id
			LEFT JOIN country c ON se.country_id=c.country_id
			LEFT JOIN event_series es ON se.series_id=es.series_id
			LEFT JOIN event e ON es.event_id=e.event_id
			WHERE (se.series_name LIKE :search OR se.series_area LIKE :search2)
				$addcountry
				$addstate
			GROUP BY se.series_name
			ORDER BY e.event_end_date DESC,se.country_id,se.state_id,se.series_name desc
		");
		$series=db_exec($stmt,array("search"=>"%".$search."%","search2"=>"%".$search."%"));
	}else{
		# Get all locations for search
		$stmt=db_prep("
			SELECT *
			FROM series se
			LEFT JOIN state s ON se.state_id=s.state_id
			LEFT JOIN country c ON se.country_id=c.country_id
			LEFT JOIN event_series es ON se.series_id=es.series_id
			LEFT JOIN event e ON es.event_id=e.event_id
			WHERE 1
				$addcountry
				$addstate
			GROUP BY se.series_name
			ORDER BY e.event_end_date DESC,se.country_id,se.state_id,se.series_name desc
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
	
	$series=show_pages($series,"action=series&function=series_list");
	
	$smarty->assign("series",$series);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl=find_template("series/series_list.tpl");
	return $smarty->fetch($maintpl);
}
function series_view() {
	global $user;
	global $smarty;
	
	$series_id=intval($_REQUEST['series_id']);
	$series=new Series($series_id);

	$total_events=count($series->events);
	$smarty->assign("total_events",$total_events);
		
	# Check to see if we need to update the total
	if($series->info['series_total_events']!=$total_events){
		# Update the record
		$stmt=db_prep("
			UPDATE series 
			SET series_total_events=:series_total_events
			WHERE series_id=:series_id
		");
		$result=db_exec($stmt,array("series_id"=>$series_id,"series_total_events"=>$total_events));
	}
	
	# Now lets calculate the totals
	$series->calculate_series_totals();
	
	$smarty->assign("series",$series);
	$maintpl=find_template("series/series_view.tpl");
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
		$series=new Series($series_id);
	}else{
		# Set the name
		$series['series_name']=$series_name;
	}
	
	$smarty->assign("countries",get_countries());
	$smarty->assign("states",get_states());
	$smarty->assign("series",$series);

	$maintpl=find_template("series/series_edit.tpl");
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
	$series_scoring_type=$_REQUEST['series_scoring_type'];

	if($series_id==0){
		$stmt=db_prep("
			INSERT INTO series
			SET user_id=:user_id,
				series_name=:series_name,
				series_area=:series_area,
				state_id=:state_id,
				country_id=:country_id,
				series_scoring_type=:series_scoring_type,
				series_url=:series_url
		");
		$result=db_exec($stmt,array(
			"user_id"=>$user['user_id'],
			"series_name"=>$series_name,
			"series_area"=>$series_area,
			"state_id"=>$state_id,
			"country_id"=>$country_id,
			"series_scoring_type"=>$series_scoring_type,
			"series_url"=>$series_url
		));

		user_message("Added your New Series!");
		$_REQUEST['series_id']=$GLOBALS['last_insert_id'];
		$series_id=$GLOBALS['last_insert_id'];
		# Lets add a default drop to the series
		# First get the drop type
		$stmt=db_prep("
			SELECT *
			FROM series_option_type
			WHERE series_option_type_code='drop'
		");
		$result=db_exec($stmt,array());
		$series_option_type_id=$result[0]['series_option_type_id'];
		# Now lets add one
		$stmt=db_prep("
			INSERT INTO series_option
			SET series_id=:series_id,
				series_option_type_id=:series_option_type_id,
				series_option_value='4',
				series_option_status=1
		");
		$result=db_exec($stmt,array("series_id"=>$series_id,"series_option_type_id"=>$series_option_type_id));
	}else{
		# Save the database record for this series
		$stmt=db_prep("
			UPDATE series
			SET series_name=:series_name,
				series_area=:series_area,
				state_id=:state_id,
				country_id=:country_id,
				series_scoring_type=:series_scoring_type,
				series_url=:series_url
			WHERE series_id=:series_id
		");
		$result=db_exec($stmt,array(
			"series_name"=>$series_name,
			"series_area"=>$series_area,
			"state_id"=>$state_id,
			"country_id"=>$country_id,
			"series_url"=>$series_url,
			"series_scoring_type"=>$series_scoring_type,
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
function series_save_multiples() {
	global $smarty;
	global $user;

	$series_id=intval($_REQUEST['series_id']);
	# Lets get the array to save the values
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^multiple\_(\d+)$/",$key,$match)){
			$event_series_id=$match[1];
			$stmt=db_prep("
				UPDATE event_series
				SET event_series_multiple=:multiple
				WHERE event_series_id=:event_series_id
			");
			$result=db_exec($stmt,array("event_series_id"=>$event_series_id,"multiple"=>$value));
		}
	}
	user_message("Saved series multiples.");
	return series_view();
}
function series_param_save() {
	global $smarty;
	global $user;
	
	$series_id=intval($_REQUEST['series_id']);
		
	# Now lets step through the options and see if they are turned on and add them or update them
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^option_(\d+)_(\d+)/",$key,$match)){
				$type_id=$match[1];
				$id=$match[2];
				if($value=='yes'){
					$value=1;
				}
				if($value=='no'){
					$value=0;
				}
		}else{
			continue;
		}

		# ok, lets see if a record with that id exists
		$stmt=db_prep("
			SELECT *
			FROM series_option so
			LEFT JOIN series_option_type sot ON so.series_option_type_id=sot.series_option_type_id
			WHERE so.series_id=:series_id
				AND so.series_option_id=:series_option_id
		");
		$result=db_exec($stmt,array("series_option_id"=>$id,"series_id"=>$series_id));
		if($result){
			# There is already a record, so lets update it
			$series_option_id=$result[0]['series_option_id'];
			# Only update it if the value is not null
			if($value!=''){
				$stmt=db_prep("
					UPDATE series_option
					SET series_option_value=:value,
						series_option_status=1
					WHERE series_option_id=:series_option_id
				");
				$result2=db_exec($stmt,array("value"=>$value,"series_option_id"=>$series_option_id));
			}else{
				if($result[0]['series_option_type_code']=='drop'){
					# Lets turn this one off
					$stmt=db_prep("
						UPDATE series_option
						SET series_option_status=0
							WHERE series_option_id=:series_option_id
					");
					$result2=db_exec($stmt,array("series_option_id"=>$series_option_id));
				}
			}
		}else{
			# There is not a record so lets make one
			if($value!=''){
				$stmt=db_prep("
					INSERT INTO series_option
					SET series_id=:series_id,
						series_option_type_id=:series_option_type_id,
						series_option_value=:value,
						series_option_status=1
				");
				$result2=db_exec($stmt,array("series_id"=>$series_id,"series_option_type_id"=>$type_id,"value"=>$value));
			}
		}
	}	
	# Now lets recalculate and save the event info because the parameters may have changed
	#$e=new Event($event_id);
	#$e->event_save_totals();
	
	log_action($series_id);
	user_message("Series Parameters Saved.");
	return series_edit();
}
function series_option_add_drop() {

	$series_id=intval($_REQUEST['series_id']);
	$drop_round=intval($_REQUEST['drop_round']);

	# First get the drop type
	$stmt=db_prep("
		SELECT *
		FROM series_option_type
		WHERE series_option_type_code='drop'
	");
	$result=db_exec($stmt,array());
	$series_option_type_id=$result[0]['series_option_type_id'];
	# Now lets add one
	$stmt=db_prep("
		INSERT INTO series_option
		SET series_id=:series_id,
			series_option_type_id=:series_option_type_id,
			series_option_value=:drop_round,
			series_option_status=1
	");
	$result=db_exec($stmt,array("series_id"=>$series_id,"series_option_type_id"=>$series_option_type_id,"drop_round"=>$drop_round));

	user_message("Added a drop round for this series.");
	return series_edit();
}
function series_user_save() {
	global $smarty;
	global $user;
	
	$series_id=intval($_REQUEST['series_id']);
	$user_id=intval($_REQUEST['user_id']);

	if($user_id==0){
		user_message("Cannot add a blank user for access.",1);
		return series_edit();
	}
	# Get the current user id to make sure they don't add themselves
	$stmt=db_prep("
		SELECT *
		FROM series s
		WHERE series_id=:series_id
	");
	$result=db_exec($stmt,array("series_id"=>$series_id));
	if(isset($result[0])){
		$series=$result[0];
	}
	if($series['user_id']==$user_id){
		user_message("You do not need to give access to yourself, as you will always have access as the owner of this series.");
		return series_edit();
	}
	
	# Now lets check to see if this is the series owner, because only they can add a series user
	if($series['user_id']!=$user['user_id']){
		user_message("You do not have access to give anyone else access. Only the series owner can do that.",1);
		return series_edit();
	}
	
	# Lets first see if this one is already added
	$stmt=db_prep("
		SELECT *
		FROM series_user
		WHERE series_id=:series_id
			AND user_id=:user_id
	");
	$result=db_exec($stmt,array("series_id"=>$series_id,"user_id"=>$user_id));
	
	if(isset($result[0])){
		# This record already exists, so lets just turn it on
		$stmt=db_prep("
			UPDATE series_user
			SET series_user_status=1
			WHERE series_user_id=:series_user_id
		");
		$result=db_exec($stmt,array("series_user_id"=>$result[0]['series_user_id']));
	}else{
		# Lets create a new record
		$stmt=db_prep("
			INSERT INTO series_user
			SET series_id=:series_id,
				user_id=:user_id,
				series_user_status=1
		");
		$result=db_exec($stmt,array(
			"series_id"=>$series_id,
			"user_id"=>$user_id
		));
	}
	user_message("New user given access to edit this series.");
	return series_edit();
}
function series_user_delete() {
	global $smarty;
	global $user;
	
	$series_id=intval($_REQUEST['series_id']);
	$series_user_id=intval($_REQUEST['series_user_id']);

	# Lets see if they are allowed to do this
	$stmt=db_prep("
		SELECT *
		FROM series
		WHERE series_id=:series_id
	");
	$result=db_exec($stmt,array("series_id"=>$series_id));
	if(isset($result[0])){
		$series=$result[0];
	}
	
	# Now lets check to see if this is the series owner, because only they can delete a user
	if($series['user_id']!=$user['user_id']){
		user_message("You do not have access to remove access to this series. Only the series owner can do that.",1);
		return series_edit();
	}

	# Lets turn off this record
	$stmt=db_prep("
		UPDATE series_user
		SET series_user_status=0
		WHERE series_user_id=:series_user_id
	");
	$result=db_exec($stmt,array("series_user_id"=>$series_user_id));
	
	user_message("Removed user access to edit this series.");
	return series_edit();
}
function series_event_save() {
	global $smarty;
	global $user;
	
	$series_id=intval($_REQUEST['series_id']);
	$event_id=intval($_REQUEST['event_id']);

	if($event_id==0){
		user_message("Cannot add a blank event.",1);
		return series_edit();
	}
			
	# Lets first see if this one is already added
	$stmt=db_prep("
		SELECT *
		FROM event_series
		WHERE series_id=:series_id
			AND event_id=:event_id
	");
	$result=db_exec($stmt,array("series_id"=>$series_id,"event_id"=>$event_id));
	
	if(isset($result[0])){
		# This record already exists, so lets just turn it on
		$stmt=db_prep("
			UPDATE event_series
			SET event_series_status=1
			WHERE event_series_id=:event_series_id
		");
		$result=db_exec($stmt,array("event_series_id"=>$result[0]['event_series_id']));
	}else{
		# Lets create a new record
		$stmt=db_prep("
			INSERT INTO event_series
			SET event_id=:event_id,
				series_id=:series_id,
				event_series_multiple=1.00,
				event_series_status=1
		");
		$result=db_exec($stmt,array(
			"series_id"=>$series_id,
			"event_id"=>$event_id
		));
	}
	user_message("New event added to this series.");
	return series_edit();
}
function series_event_delete() {
	global $smarty;
	global $user;
	
	$series_id=intval($_REQUEST['series_id']);
	$event_series_id=intval($_REQUEST['event_series_id']);

	# Lets turn off this record
	$stmt=db_prep("
		UPDATE event_series
		SET event_series_status=0
		WHERE event_series_id=:event_series_id
	");
	$result=db_exec($stmt,array("event_series_id"=>$event_series_id));
	
	user_message("Removed event from this series.");
	return series_edit();
}
function check_series_permission($series_id){
	global $user;
	# Function to check to see if this user can edit this club
	# First check if its an administrator
	if($user['user_admin']){
		return 1;
	}
	# Get series info
	$stmt=db_prep("
		SELECT *
		FROM series
		WHERE series_id=:series_id
	");
	$result=db_exec($stmt,array("series_id"=>$series_id));
	$series=$result[0];

	if($series['user_id']==$user['user_id']){
		# This is the owner of the series, so of course he has access
		return 1;
	}
	$allowed=0;
	# Now lets get the other permissions
	$stmt=db_prep("
		SELECT *
		FROM series_user
		WHERE series_id=:series_id
			AND series_user_status=1
	");
	$users=db_exec($stmt,array("series_id"=>$series_id));
	foreach($users as $u){
		if($user['user_id']==$u['user_id']){
			$allowed=1;
		}
	}
	return $allowed;
}
function series_pilot_view() {
	global $smarty;
	# Function to view the event summaries for a particular pilot
	
	$series_id=intval($_REQUEST['series_id']);
	$pilot_id=intval($_REQUEST['pilot_id']);

	$series=new Series($series_id);
	$series->calculate_series_totals();
	$smarty->assign("pilot_id",$pilot_id);
	$smarty->assign("series",$series);
	
	$maintpl=find_template("series/series_pilot_view.tpl");
	return $smarty->fetch($maintpl);
}

?>
