<?php
############################################################################
#       my.php
#
#       Tim Traver
#       8/12/12
#       This is the script to show individual user and pilot profiles
#
############################################################################
$GLOBALS['current_menu']='pilots';

# This whole section requires the user to be logged in
if($GLOBALS['user_id']==0){
	# The user is not logged in, so send the feature template
	$maintpl=find_template("feature_requires_login.tpl");
	$actionoutput=$smarty->fetch($maintpl);
}else{
	if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
        $function=$_REQUEST['function'];
	}else{
        $function="my_user_show";
	}
	if(check_user_function($function)){
        eval("\$actionoutput=$function();");
	}
}

function my_user_show() {
	global $user;
	global $smarty;
	
	$is_pilotlist=0;
	# Get the current users pilot info
	$stmt=db_prep("
		SELECT *
		FROM pilot
		WHERE pilot_wp_user_id=:pilot_wp_user_id
	");
	$result=db_exec($stmt,array("pilot_wp_user_id"=>$GLOBALS['user_id']));	
	if(!isset($result[0])){
		# Lets see if we have any entries in the db already for this pilot that were created in a previous event
		$stmt=db_prep("
			SELECT *
			FROM pilot p
			WHERE p.pilot_wp_user_id=0
				AND ((p.pilot_first_name=LOWER(:user_first_name) AND p.pilot_last_name=LOWER(:user_last_name))
					OR p.pilot_email=LOWER(:user_email))
		");
		$result2=db_exec($stmt,array("user_email"=>strtolower($user['user_email']),"user_first_name"=>strtolower($user['user_first_name']),"user_last_name"=>strtolower($user['user_last_name'])));
		if(isset($result2[0])){
			# Step though and find the last events they were in
			$pilotlist=array();
			foreach($result2 as $pilot){
				$stmt=db_prep("
					SELECT *
					FROM event_pilot ep
					LEFT JOIN event e ON e.event_id=ep.event_id
					LEFT JOIN location l ON l.location_id=e.location_id
					WHERE ep.pilot_id=:pilot_id
					ORDER BY e.event_start_date desc
					LIMIT 1
				");
				$result3=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
				if(isset($result3[0])){
					$pilot['eventstring']=$result3[0]['event_name']." - ".date("F j, Y",strtotime($result3[0]['event_start_date']));
				}else{
					$pilot['eventstring']='None on file.';
				}
				$pilotlist[]=$pilot;
				$is_pilotlist=1;
			}
			$pilot=array();
			# We have found some records that look like they relate, so lets show them first
		}else{
			# They don't have a pilot ID, so pre-populate with defaults
			$pilot['pilot_first_name']=$GLOBALS['user']['user_first_name'];
			$pilot['pilot_last_name']=$GLOBALS['user']['user_last_name'];
			$pilot['pilot_email']=$GLOBALS['user']['user_email'];
			$pilot_planes=array();
			$pilot_locations=array();
			$pilotlist=array();
		}
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
		
		# Get the pilots favorite locations
		$pilot_locations=array();
		$stmt=db_prep("
			SELECT *
			FROM pilot_location pl
			LEFT JOIN location l ON pl.location_id=l.location_id
			LEFT JOIN state s on l.state_id=s.state_id
			LEFT JOIN country c on l.country_id=c.country_id
			WHERE pl.pilot_id=:pilot_id
				AND pl.pilot_location_status=1
		");
		$pilot_locations=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
		
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
		");
		$pilot_events=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
	}
	
	$smarty->assign("pilot",$pilot);
	$smarty->assign("pilotlist",$pilotlist);
	$smarty->assign("is_pilotlist",$is_pilotlist);
	$smarty->assign("pilot_planes",$pilot_planes);
	$smarty->assign("pilot_locations",$pilot_locations);
	$smarty->assign("pilot_events",$pilot_events);
	$smarty->assign("pilot_clubs",$pilot_clubs);
	$smarty->assign("states",get_states());
	$smarty->assign("countries",get_countries());
	$maintpl=find_template("my.tpl");
	return $smarty->fetch($maintpl);
}
function my_user_save(){
	# Function to save the user and their access
	global $user;

	$connect=$_REQUEST['connect'];
	if($connect==1){
		# They just came from the connect screen
		$pilot_id=$_REQUEST['pilot_id'];
		if($pilot_id!=0){
			# Connect the current logged in account to the selected pilot id
			$stmt=db_prep("
				UPDATE pilot
				SET pilot_wp_user_id=:user_id
				WHERE pilot_id=:pilot_id
			");
			$result=db_exec($stmt,array("user_id"=>$GLOBALS['user_id'],"pilot_id"=>$pilot_id));
			user_message("We have connected you to that existing user! Now you can edit any remaining details.");
			return my_user_show();
		}
	}

	$pilot_id=$_REQUEST['pilot_id'];
	$pilot_first_name=$_REQUEST['pilot_first_name'];
	$pilot_last_name=$_REQUEST['pilot_last_name'];
	$pilot_email=$_REQUEST['pilot_email'];
	$pilot_city=$_REQUEST['pilot_city'];
	$state_id=$_REQUEST['state_id'];
	$country_id=$_REQUEST['country_id'];
	$pilot_ama=$_REQUEST['pilot_ama'];
	$pilot_fia=$_REQUEST['pilot_fia'];

	if($pilot_id==0){
		# Insert new pilot info and assign the current user to it
		if($pilot_first_name==''){
			$pilot_first_name=$GLOBALS['user']['user_first_name'];
		}
		if($pilot_last_name==''){
			$pilot_last_name=$GLOBALS['user']['user_last_name'];
		}
		if($pilot_email==''){
			$pilot_email=$GLOBALS['user']['user_email'];
		}
		$stmt=db_prep("
			INSERT INTO pilot
			SET pilot_first_name=:pilot_first_name,
				pilot_last_name=:pilot_last_name,
				pilot_email=:pilot_email,
				pilot_ama=:pilot_ama,
				pilot_fia=:pilot_fia,
				pilot_city=:pilot_city,
				state_id=:state_id,
				country_id=:country_id,
				pilot_wp_user_id=:user_id
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
			"user_id"=>$GLOBALS['user_id']
		));
		user_message("User Info Created.");
	}else{
		# Update the existing pilot record
		$stmt=db_prep("
			UPDATE pilot
			SET pilot_first_name=:pilot_first_name,
				pilot_last_name=:pilot_last_name,
				pilot_email=:pilot_email,
				pilot_ama=:pilot_ama,
				pilot_fia=:pilot_fia,
				pilot_city=:pilot_city,
				state_id=:state_id,
				country_id=:country_id
			WHERE pilot_wp_user_id=:pilot_wp_user_id
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
			"pilot_wp_user_id"=>$GLOBALS['user_id']
		));
		user_message("User Info Saved.");
	}
	return my_user_show();	
}
function my_plane_edit() {
	global $smarty;
	global $user;

	$pilot_plane_id=$_REQUEST['pilot_plane_id'];

	# Get pilot plane info if exists
	$pilot_plane=array();
	if($pilot_plane_id!=0){
		$stmt=db_prep("
			SELECT *
			FROM pilot_plane pp
			LEFT JOIN plane p on p.plane_id=pp.plane_id
			WHERE pp.pilot_plane_id=:pilot_plane_id
		");
		$result=db_exec($stmt,array("pilot_plane_id"=>$pilot_plane_id));
		$pilot_plane=$result[0];
	}else{
		# Lets check if we have post variables coming back from an add
		if(isset($_REQUEST['plane_name'])){
			$pilot_plane['plane_name']=$_REQUEST['plane_name'];
		}
		if(isset($_REQUEST['plane_id'])){
			$pilot_plane['plane_id']=$_REQUEST['plane_id'];
		}
		if(isset($_REQUEST['pilot_plane_color'])){
			$pilot_plane['pilot_plane_color']=$_REQUEST['pilot_plane_color'];
		}
	}
	
	# Get plane media records
	$media=array();
	$stmt=db_prep("
		SELECT *
		FROM pilot_plane_media ppm
		WHERE ppm.pilot_plane_id=:pilot_plane_id
		AND ppm.pilot_plane_media_status=1
	");
	$media=db_exec($stmt,array("pilot_plane_id"=>$pilot_plane_id));
	
	$smarty->assign("pilot_plane",$pilot_plane);
	$smarty->assign("media",$media);
	$maintpl=find_template("my_plane_edit.tpl");
	return $smarty->fetch($maintpl);
}
function my_plane_save() {
	global $user;

	$pilot_id=get_current_pilot_id();
	$pilot_plane_id=$_REQUEST['pilot_plane_id'];
	$plane_id=$_REQUEST['plane_id'];
	$pilot_plane_color=$_REQUEST['pilot_plane_color'];

	# Save this pilot plane
	if($pilot_plane_id==0){
		# Create a new record for this plane
		$stmt=db_prep("
			INSERT INTO pilot_plane
			SET pilot_id=:pilot_id,
				plane_id=:plane_id,
				pilot_plane_color=:pilot_plane_color,
				pilot_plane_status=1
		");
		$result=db_exec($stmt,array(
			"pilot_id"=>$pilot_id,
			"plane_id"=>$plane_id,
			"pilot_plane_color"=>$pilot_plane_color		
		));
		user_message("Added New Plane to your quiver!");
		$_REQUEST['pilot_plane_id']=$GLOBALS['last_insert_id'];
	}else{
		$stmt=db_prep("
			UPDATE pilot_plane
			SET plane_id=:plane_id,
				pilot_plane_color=:pilot_plane_color
			WHERE pilot_plane_id=:pilot_plane_id
		");
		$result=db_exec($stmt,array("plane_id"=>$plane_id,"pilot_plane_color"=>$pilot_plane_color,"pilot_plane_id"=>$pilot_plane_id));
		user_message("Updated Your Plane Info");
	}
	return my_plane_edit();
}

function my_plane_del() {
	global $user;

	$pilot_plane_id=$_REQUEST['pilot_plane_id'];

	# del this plane
	$stmt=db_prep("
		UPDATE pilot_plane
		SET pilot_plane_status=0
		WHERE pilot_plane_id=:pilot_plane_id
	");
	$result=db_exec($stmt,array("pilot_plane_id"=>$pilot_plane_id));
	user_message("Removed plane from your pilot info.");
	return my_user_show();
}
function get_current_pilot_id(){
	# Get the current users pilot info
	$pilot_id=0;
	$stmt=db_prep("
		SELECT *
		FROM pilot
		WHERE pilot_wp_user_id=:pilot_wp_user_id
	");
	$result=db_exec($stmt,array("pilot_wp_user_id"=>$GLOBALS['user_id']));
	if(isset($result[0])){
		$pilot_id=$result[0]['pilot_id'];
	}
	return $pilot_id;
}
function my_plane_media_edit() {
	global $smarty;
	global $user;
	
	$pilot_plane_id=$_REQUEST['pilot_plane_id'];
	
	$stmt=db_prep("
		SELECT *
		FROM pilot_plane pp
		LEFT JOIN plane p on p.plane_id=pp.plane_id
		LEFT JOIN plane_type pt on pt.plane_type_id=p.plane_type_id
		WHERE pp.pilot_plane_id=:pilot_plane_id
	");
	$result=db_exec($stmt,array("pilot_plane_id"=>$pilot_plane_id));
	$plane=$result[0];
	
	$smarty->assign("plane",$plane);
	$smarty->assign("pilot_plane_id",$pilot_plane_id);
	$maintpl=find_template("my_plane_edit_media.tpl");
	return $smarty->fetch($maintpl);
}

function my_plane_media_add() {
	global $smarty;
	global $user;
	
	$pilot_plane_id=$_REQUEST['pilot_plane_id'];
	$pilot_plane_media_type=$_REQUEST['pilot_plane_media_type'];
	$pilot_plane_media_caption=$_REQUEST['pilot_plane_media_caption'];
	
	if($pilot_plane_media_type=='picture'){
		# Lets upload the file and put it in place
		$tempname=$_FILES['uploaded_file']['tmp_name'];
		$name=basename(preg_replace("/\s/","\_",$_FILES['uploaded_file']['name']));
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
		$pilot_plane_media_url="{$GLOBALS['base_url']}{$GLOBALS['base_plane_media']}/$pilot_plane_id/$name";
	}else{
		$pilot_plane_media_url=$_REQUEST['pilot_plane_media_url'];
	}

	# Insert the database record for this media
	$media=array();
	$stmt=db_prep("
		INSERT INTO pilot_plane_media
		SET pilot_plane_id=:pilot_plane_id,
			pilot_plane_media_type=:pilot_plane_media_type,
			pilot_plane_media_url=:pilot_plane_media_url,
			pilot_plane_media_caption=:pilot_plane_media_caption,
			pilot_plane_media_status=1
	");
	$result=db_exec($stmt,array("pilot_plane_id"=>$pilot_plane_id,"pilot_plane_media_type"=>$pilot_plane_media_type,"pilot_plane_media_url"=>$pilot_plane_media_url,"pilot_plane_media_caption"=>$pilot_plane_media_caption));

	user_message("Added your $pilot_plane_media_type media!");
	return my_plane_edit();
}
function my_plane_media_del() {
	global $user;

	$pilot_plane_id=$_REQUEST['pilot_plane_id'];
	$pilot_plane_media_id=$_REQUEST['pilot_plane_media_id'];

	# del this media entry
	$stmt=db_prep("
		UPDATE pilot_plane_media
		SET pilot_plane_media_status=0
		WHERE pilot_plane_media_id=:pilot_plane_media_id
	");
	$result=db_exec($stmt,array("pilot_plane_media_id"=>$pilot_plane_media_id));
	user_message("Removed plane media from this plane.");
	return my_plane_edit();
}
function my_location_edit() {
	global $smarty;
	global $user;

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
		case 'location_name':
			$search_field='location_name';
			break;
		case 'location_city':
			$search_field='location_city';
			break;
		default:
			$search_field='location_name';
			break;
	}
	if($search=='' || $search=='%%'){
		$search_field='location_name';
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

	$locations=array();
	if($search!='%%' && $search!=''){
		$stmt=db_prep("
			SELECT *
			FROM location l
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			WHERE l.$search_field $operator :search
				$addcountry
				$addstate
			ORDER BY l.country_id,l.state_id,l.location_name
		");
		$locations=db_exec($stmt,array("search"=>$search));
	}else{
		# Get all locations for search
		$stmt=db_prep("
			SELECT *
			FROM location l
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			WHERE 1
				$addcountry
				$addstate
			ORDER BY l.country_id,l.state_id,l.location_name
		");
		$locations=db_exec($stmt,array());
	}
		
	# Get only countries that we have locations for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT country_id FROM location) l
		LEFT JOIN country c ON c.country_id=l.country_id
		WHERE c.country_id!=0
	");
	$countries=db_exec($stmt,array());
	# Get only states that we have locations for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT state_id FROM location) l
		LEFT JOIN state s ON s.state_id=l.state_id
		WHERE s.state_id!=0
	");
	$states=db_exec($stmt,array());
	
	$locations=show_pages($locations,25);
	
	$smarty->assign("locations",$locations);
	$smarty->assign("count",$count);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("search_field",$GLOBALS['fsession']['search_field']);
	$smarty->assign("search_operator",$GLOBALS['fsession']['search_operator']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl=find_template("my_location_edit.tpl");
	return $smarty->fetch($maintpl);
}
function my_location_add() {
	global $user;

	$pilot_id=get_current_pilot_id();

	# OK, lets step through each of the locations selected and add if needed
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^location\_(\d+)/",$key,$match) && ($value=='On' || $value=='on')){
			$location_id=$match[1];
			# Lets see if they already have one
			$stmt=db_prep("
				SELECT *
				FROM pilot_location
				WHERE pilot_id=:pilot_id
				AND location_id=:location_id
			");
			$result=db_exec($stmt,array("pilot_id"=>$pilot_id,"location_id"=>$location_id));
			if($result[0]){
				# A record already exists, so update it
				$stmt=db_prep("
					UPDATE pilot_location
					SET pilot_location_status=1
					WHERE pilot_location_id=:pilot_location_id
				");
				$result2=db_exec($stmt,array("pilot_location_id"=>$result[0]['pilot_location_id']));
			}else{
				# Create a new record for this one
				$stmt=db_prep("
					INSERT INTO pilot_location
					SET pilot_id=:pilot_id,
						location_id=:location_id,
						pilot_location_status=1
				");
				$result2=db_exec($stmt,array("pilot_id"=>$pilot_id,"location_id"=>$location_id));
			}
		}
	}
	user_message("Added New locations!");
	return my_user_show();
}
function my_location_del() {
	global $user;

	$pilot_location_id=$_REQUEST['pilot_location_id'];

	# del this location
	$stmt=db_prep("
		UPDATE pilot_location
		SET pilot_location_status=0
		WHERE pilot_location_id=:pilot_location_id
	");
	$result=db_exec($stmt,array("pilot_location_id"=>$pilot_location_id));
	user_message("Removed location from your pilot info.");
	return my_user_show();
}






?>
