<?php
############################################################################
#       admin.php
#
#       Tim Traver
#       3/18/13
#       This is the script to show the main screen
#
############################################################################
$GLOBALS['current_menu']='admin';
if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
        $function=$_REQUEST['function'];
}else{
        $function="admin_view";
}

if($user['user_admin']!=1){
	# User does not have admin access
	user_message("I'm sorry, you do not have user admin access.");
	include("{$GLOBALS['scripts_dir']}/main.php");
	$actionoutput=view_home();
}else{
	if(check_user_function($function)){
        eval("\$actionoutput=$function();");
    }
}

function admin_view() {
	global $smarty;
	global $user;

	$maintpl=find_template("admin.tpl");
	return $smarty->fetch($maintpl);
}
function admin_email() {
	global $smarty;
	global $user;

	# Lets get the list of emails
	$stmt=db_prep("
		SELECT *
		FROM email
		WHERE 1
	");
	$emails=db_exec($stmt,array());

	$smarty->assign("emails",$emails);

	$maintpl=find_template("admin_email.tpl");
	return $smarty->fetch($maintpl);
}
function admin_email_edit() {
	global $smarty;
	global $user;
	
	$email_id=$_REQUEST['email_id'];
	
	# Get signup email
	$stmt=db_prep("
		SELECT *
		FROM email
		WHERE email_id=:email_id
	");
	$result=db_exec($stmt,array("email_id"=>$email_id));
	$result[0]['email_html']=htmlentities($result[0]['email_html']);
	$smarty->assign("email",$result[0]);
	
	# Get images
	$stmt=db_prep("
		SELECT *
		FROM email_image
		WHERE email_id=:email_id
		AND email_image_status=1
	");
	$images=db_exec($stmt,array("email_id"=>$email_id));
	$smarty->assign("images",$images);

	$maintpl=find_template("admin_email_edit.tpl");
	return $smarty->fetch($maintpl);
}
function admin_email_save() {
	global $smarty;
	global $user;

	$email_id=intval($_REQUEST['email_id']);
	$email_name=$_REQUEST['email_name'];
	$email_from_name=$_REQUEST['email_from_name'];
	$email_from_address=$_REQUEST['email_from_address'];
	$email_subject=$_REQUEST['email_subject'];
	$email_html=$_REQUEST['email_html'];
	
	if($email_id==0){
		# This is a new email so save it
		$stmt=db_prep("
			INSERT INTO email
			SET email_name=:email_name,
				email_from_name=:email_from_name,
				email_from_address=:email_from_address,
				email_subject=:email_subject,
				email_html=:email_html
		");
		$result=db_exec($stmt,array(
			"email_name"=>$email_name,
			"email_from_name"=>$email_from_name,
			"email_from_address"=>$email_from_address,
			"email_subject"=>$email_subject,
			"email_html"=>$email_html
		));
	}else{
		# save signup email
		$stmt=db_prep("
			UPDATE email
			SET email_name=:email_name,
				email_from_name=:email_from_name,
				email_from_address=:email_from_address,
				email_subject=:email_subject,
				email_html=:email_html
			WHERE email_id=:email_id
		");
		$result=db_exec($stmt,array(
			"email_id"=>$email_id,
			"email_name"=>$email_name,
			"email_from_name"=>$email_from_name,
			"email_from_address"=>$email_from_address,
			"email_subject"=>$email_subject,
			"email_html"=>$email_html
		));
	}

	# If there is an image to upload, then upload it and create the image entry
	if(isset($_FILES['uploadfile']) && $_FILES['uploadfile']['tmp_name']!=''){
		$tempname=$_FILES['uploadfile']['tmp_name'];
		$dir=$GLOBALS['include_paths']['images'];
		if(!is_dir("$dir/$email_id")){
			# Make directory for this email
			mkdir("$dir/$email_id");
		}
		$name=preg_replace("/\s/","\ ",$_FILES['uploadfile']['name']);
		exec("/bin/mv $tempname $dir/{$email_id}/$name");
		exec("/bin/chmod 664 $dir/{$email_id}/$name");
		
		# Add the image record
		$stmt=db_prep("
			INSERT INTO email_image
			SET email_id=:email_id,
				email_image_name=:email_image_name,
				email_image_status=1
		");
		$result=db_exec($stmt,array(
			"email_id"=>$email_id,
			"email_image_name"=>$name
		));
	}
	
	user_message("Successfully saved email.");
	return admin_email();	
}
function admin_email_send_test() {
	# Send the test email

	$email_name=$_REQUEST['email_name'];
	$email_to=$_REQUEST['email_to'];

	# Get some sample data to replace tokens in the email
	switch($email_name){
		case 'customer_confirmation':
			$stmt=db_prep("
				SELECT *
				FROM signup
				ORDER BY signup_date DESC
			");
			$result=db_exec($stmt,array());
			$data=$result[0];
			break;
		case "domain_renewal_notification_60":
		case "domain_renewal_notification_30":
		case "domain_renewal_notification_10":
			$data['domain']='testbobbysdomain.com';
			$data['expiration']="2016-03-20";
			$data['contacts']['owner']['first_name']="Bob";
			break;
		case "hosting_info_sheet":
			$data['domain']='testbobbysdomain.com';
			$data['temp_url']='testbobbysdomain.mivamerchant.net';
			break;
	}
	send_email($email_name,array($email_to),$data);

	user_message("Sent test email to $email_to.");
	return admin_email();
}
function admin_email_del_image() {
	global $smarty;
	global $user;

	$email_id=intval($_REQUEST['email_id']);
	$email_image_id=intval($_REQUEST['email_image_id']);
	if($email_id==0 || $email_image_id==0){
		user_message("Could not delete image.");
		return admin_email_edit();
	}
	$stmt=db_prep("
		UPDATE email_image
		SET email_image_status=0
		WHERE email_image_id=:email_image_id
	");
	$result=db_exec($stmt,array("email_image_id"=>$email_image_id));

	user_message("Deleted attached image.");
	return admin_email_edit();
}

function admin_location() {
	global $smarty;
	global $user;

	# Lets get the list of location attributes
	$stmt=db_prep("
		SELECT *
		FROM location_att l
		LEFT JOIN location_att_cat lc ON l.location_att_cat_id=lc.location_att_cat_id
		WHERE l.location_att_status=1
		ORDER BY lc.location_att_cat_order,l.location_att_order
	");
	$attributes=db_exec($stmt,array());

	# Get the categories
	$stmt=db_prep("
		SELECT *
		FROM location_att_cat
		WHERE 1
		ORDER BY location_att_cat_order
	");
	$categories=db_exec($stmt,array());
	$smarty->assign("categories",$categories);

	$smarty->assign("attributes",$attributes);

	$maintpl=find_template("admin_location.tpl");
	return $smarty->fetch($maintpl);
}
function admin_location_att_edit() {
	global $smarty;
	global $user;

	$location_att_id=$_REQUEST['location_att_id'];
	
	# Lets get record
	$stmt=db_prep("
		SELECT *
		FROM location_att
		WHERE location_att_id=:location_att_id
	");
	$result=db_exec($stmt,array("location_att_id"=>$location_att_id));
	$attribute=$result[0];
	
	# Get the categories
	$stmt=db_prep("
		SELECT *
		FROM location_att_cat
		WHERE 1
		ORDER BY location_att_cat_order
	");
	$categories=db_exec($stmt,array());

	$smarty->assign("attribute",$attribute);
	$smarty->assign("categories",$categories);

	$maintpl=find_template("admin_location_att_edit.tpl");
	return $smarty->fetch($maintpl);
}
function admin_location_att_save() {
	global $smarty;
	global $user;

	$location_att_id=$_REQUEST['location_att_id'];
	$location_att_name=$_REQUEST['location_att_name'];
	$location_att_description=$_REQUEST['location_att_description'];
	$location_att_type=$_REQUEST['location_att_type'];
	$location_att_size=$_REQUEST['location_att_size'];
	$location_att_order=$_REQUEST['location_att_order'];
	$location_att_cat_id=$_REQUEST['location_att_cat_id'];
	
	if($location_att_id==0){
		# This is a new record, so lets create it
		$stmt=db_prep("
			INSERT INTO location_att
			SET location_att_name=:location_att_name,
				location_att_description=:location_att_description,
				location_att_type=:location_att_type,
				location_att_size=:location_att_size,
				location_att_order=:location_att_order,
				location_att_cat_id=:location_att_cat_id,
				location_att_status=1				
		");
		$result=db_exec($stmt,array(
			"location_att_name"=>$location_att_name,
			"location_att_description"=>$location_att_description,
			"location_att_type"=>$location_att_type,
			"location_att_size"=>$location_att_size,
			"location_att_order"=>$location_att_order,
			"location_att_cat_id"=>$location_att_cat_id
		));
	}else{
		# Lets save the existing one
		$stmt=db_prep("
			UPDATE location_att
			SET location_att_name=:location_att_name,
				location_att_description=:location_att_description,
				location_att_type=:location_att_type,
				location_att_size=:location_att_size,
				location_att_order=:location_att_order,
				location_att_cat_id=:location_att_cat_id,
				location_att_status=1
			WHERE location_att_id=:location_att_id				
		");
		$result=db_exec($stmt,array(
			"location_att_name"=>$location_att_name,
			"location_att_description"=>$location_att_description,
			"location_att_type"=>$location_att_type,
			"location_att_size"=>$location_att_size,
			"location_att_order"=>$location_att_order,
			"location_att_cat_id"=>$location_att_cat_id,
			"location_att_id"=>$location_att_id
		));
	}
	user_message("Saved location attribute.");
	return admin_location();
}
function admin_location_att_del() {
	global $smarty;
	global $user;

	$location_att_id=$_REQUEST['location_att_id'];
	
	# Lets save the record
	$stmt=db_prep("
		UPDATE location_att
		SET location_att_status=0
		WHERE location_att_id=:location_att_id				
	");
	$result=db_exec($stmt,array(
		"location_att_id"=>$location_att_id
	));

	user_message("Removed location attribute.");
	return admin_location();
}
function admin_location_cat_edit() {
	global $smarty;
	global $user;

	$location_att_cat_id=$_REQUEST['location_att_cat_id'];
	
	# Lets get record
	$stmt=db_prep("
		SELECT *
		FROM location_att_cat
		WHERE location_att_cat_id=:location_att_cat_id
	");
	$result=db_exec($stmt,array("location_att_cat_id"=>$location_att_cat_id));
	$category=$result[0];
	
	$smarty->assign("category",$category);

	$maintpl=find_template("admin_location_cat_edit.tpl");
	return $smarty->fetch($maintpl);
}
function admin_location_cat_save() {
	global $smarty;
	global $user;

	$location_att_cat_id=$_REQUEST['location_att_cat_id'];
	$location_att_cat_name=$_REQUEST['location_att_cat_name'];
	$location_att_cat_order=$_REQUEST['location_att_cat_order'];
	
	if($location_att_cat_id==0){
		# This is a new record, so lets create it
		$stmt=db_prep("
			INSERT INTO location_att_cat
			SET location_att_cat_name=:location_att_cat_name,
				location_att_cat_order=:location_att_cat_order
		");
		$result=db_exec($stmt,array(
			"location_att_cat_name"=>$location_att_cat_name,
			"location_att_cat_order"=>$location_att_cat_order
		));
	}else{
		# Lets save the existing one
		$stmt=db_prep("
			UPDATE location_att_cat
			SET location_att_cat_name=:location_att_cat_name,
				location_att_cat_order=:location_att_cat_order
			WHERE location_att_cat_id=:location_att_cat_id				
		");
		$result=db_exec($stmt,array(
			"location_att_cat_name"=>$location_att_cat_name,
			"location_att_cat_order"=>$location_att_cat_order,
			"location_att_cat_id"=>$location_att_cat_id
		));
	}
	user_message("Saved location category.");
	return admin_location();
}
function admin_location_cat_del() {
	global $smarty;
	global $user;

	$location_att_cat_id=$_REQUEST['location_att_cat_id'];
	
	# Lets remove the record
	$stmt=db_prep("
		DELETE FROM location_att_cat
		WHERE location_att_cat_id=:location_att_cat_id				
	");
	$result=db_exec($stmt,array(
		"location_att_cat_id"=>$location_att_cat_id
	));

	user_message("Removed location category.");
	return admin_location();
}

function admin_plane() {
	global $smarty;
	global $user;

	# Lets get the list of plane attributes
	$stmt=db_prep("
		SELECT *
		FROM plane_att p
		LEFT JOIN plane_att_cat pc ON p.plane_att_cat_id=pc.plane_att_cat_id
		WHERE p.plane_att_status=1
		ORDER BY pc.plane_att_cat_order,p.plane_att_order
	");
	$attributes=db_exec($stmt,array());

	# Get the categories
	$stmt=db_prep("
		SELECT *
		FROM plane_att_cat
		WHERE 1
		ORDER BY plane_att_cat_order
	");
	$categories=db_exec($stmt,array());
	$smarty->assign("categories",$categories);

	$smarty->assign("attributes",$attributes);

	$maintpl=find_template("admin_plane.tpl");
	return $smarty->fetch($maintpl);
}
function admin_plane_att_edit() {
	global $smarty;
	global $user;

	$plane_att_id=$_REQUEST['plane_att_id'];
	
	# Lets get record
	$stmt=db_prep("
		SELECT *
		FROM plane_att
		WHERE plane_att_id=:plane_att_id
	");
	$result=db_exec($stmt,array("plane_att_id"=>$plane_att_id));
	$attribute=$result[0];
	
	# Get the categories
	$stmt=db_prep("
		SELECT *
		FROM plane_att_cat
		WHERE 1
		ORDER BY plane_att_cat_order
	");
	$categories=db_exec($stmt,array());

	$smarty->assign("attribute",$attribute);
	$smarty->assign("categories",$categories);

	$maintpl=find_template("admin_plane_att_edit.tpl");
	return $smarty->fetch($maintpl);
}
function admin_plane_att_save() {
	global $smarty;
	global $user;

	$plane_att_id=$_REQUEST['plane_att_id'];
	$plane_att_name=$_REQUEST['plane_att_name'];
	$plane_att_description=$_REQUEST['plane_att_description'];
	$plane_att_type=$_REQUEST['plane_att_type'];
	$plane_att_size=$_REQUEST['plane_att_size'];
	$plane_att_order=$_REQUEST['plane_att_order'];
	$plane_att_cat_id=$_REQUEST['plane_att_cat_id'];
	
	if($plane_att_id==0){
		# This is a new record, so lets create it
		$stmt=db_prep("
			INSERT INTO plane_att
			SET plane_att_name=:plane_att_name,
				plane_att_description=:plane_att_description,
				plane_att_type=:plane_att_type,
				plane_att_size=:plane_att_size,
				plane_att_order=:plane_att_order,
				plane_att_cat_id=:plane_att_cat_id,
				plane_att_status=1				
		");
		$result=db_exec($stmt,array(
			"plane_att_name"=>$plane_att_name,
			"plane_att_description"=>$plane_att_description,
			"plane_att_type"=>$plane_att_type,
			"plane_att_size"=>$plane_att_size,
			"plane_att_order"=>$plane_att_order,
			"plane_att_cat_id"=>$plane_att_cat_id
		));
	}else{
		# Lets save the existing one
		$stmt=db_prep("
			UPDATE plane_att
			SET plane_att_name=:plane_att_name,
				plane_att_description=:plane_att_description,
				plane_att_type=:plane_att_type,
				plane_att_size=:plane_att_size,
				plane_att_order=:plane_att_order,
				plane_att_cat_id=:plane_att_cat_id,
				plane_att_status=1
			WHERE plane_att_id=:plane_att_id				
		");
		$result=db_exec($stmt,array(
			"plane_att_name"=>$plane_att_name,
			"plane_att_description"=>$plane_att_description,
			"plane_att_type"=>$plane_att_type,
			"plane_att_size"=>$plane_att_size,
			"plane_att_order"=>$plane_att_order,
			"plane_att_cat_id"=>$plane_att_cat_id,
			"plane_att_id"=>$plane_att_id
		));
	}
	user_message("Saved plane attribute.");
	return admin_plane();
}
function admin_plane_att_del() {
	global $smarty;
	global $user;

	$plane_att_id=$_REQUEST['plane_att_id'];
	
	# Lets save the record
	$stmt=db_prep("
		UPDATE plane_att
		SET plane_att_status=0
		WHERE plane_att_id=:plane_att_id				
	");
	$result=db_exec($stmt,array(
		"plane_att_id"=>$plane_att_id
	));

	user_message("Removed plane attribute.");
	return admin_plane();
}
function admin_plane_cat_edit() {
	global $smarty;
	global $user;

	$plane_att_cat_id=$_REQUEST['plane_att_cat_id'];
	
	# Lets get record
	$stmt=db_prep("
		SELECT *
		FROM plane_att_cat
		WHERE plane_att_cat_id=:plane_att_cat_id
	");
	$result=db_exec($stmt,array("plane_att_cat_id"=>$plane_att_cat_id));
	$category=$result[0];
	
	$smarty->assign("category",$category);

	$maintpl=find_template("admin_plane_cat_edit.tpl");
	return $smarty->fetch($maintpl);
}
function admin_plane_cat_save() {
	global $smarty;
	global $user;

	$plane_att_cat_id=$_REQUEST['plane_att_cat_id'];
	$plane_att_cat_name=$_REQUEST['plane_att_cat_name'];
	$plane_att_cat_order=$_REQUEST['plane_att_cat_order'];
	
	if($plane_att_cat_id==0){
		# This is a new record, so lets create it
		$stmt=db_prep("
			INSERT INTO plane_att_cat
			SET plane_att_cat_name=:plane_att_cat_name,
				plane_att_cat_order=:plane_att_cat_order
		");
		$result=db_exec($stmt,array(
			"plane_att_cat_name"=>$plane_att_cat_name,
			"plane_att_cat_order"=>$plane_att_cat_order
		));
	}else{
		# Lets save the existing one
		$stmt=db_prep("
			UPDATE plane_att_cat
			SET plane_att_cat_name=:plane_att_cat_name,
				plane_att_cat_order=:plane_att_cat_order
			WHERE plane_att_cat_id=:plane_att_cat_id				
		");
		$result=db_exec($stmt,array(
			"plane_att_cat_name"=>$plane_att_cat_name,
			"plane_att_cat_order"=>$plane_att_cat_order,
			"plane_att_cat_id"=>$plane_att_cat_id
		));
	}
	user_message("Saved plane category.");
	return admin_plane();
}
function admin_plane_cat_del() {
	global $smarty;
	global $user;

	$plane_att_cat_id=$_REQUEST['plane_att_cat_id'];
	
	# Lets remove the record
	$stmt=db_prep("
		DELETE FROM plane_att_cat
		WHERE plane_att_cat_id=:plane_att_cat_id				
	");
	$result=db_exec($stmt,array(
		"plane_att_cat_id"=>$plane_att_cat_id
	));

	user_message("Removed plane category.");
	return admin_plane();
}

function admin_activity() {
	global $smarty;
	global $user;

	# Lets get the site activity from logs
	$stmt=db_prep("
		SELECT *
		FROM site_log s
		LEFT JOIN user u ON s.user_id=u.user_id
		ORDER BY site_log_date DESC
	");
	$entries=db_exec($stmt,array());

	$entries=show_pages($entries,25);

	$smarty->assign("entries",$entries);

	$maintpl=find_template("admin_activity.tpl");
	return $smarty->fetch($maintpl);
}
function admin_user_list() {
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
		case 'pilot_first_name':
			$search_field='pilot_first_name';
			break;
		case 'pilot_last_name':
			$search_field='pilot_last_name';
			break;
		case 'pilot_city':
			$search_field='pilot_city';
			break;
		default:
			$search_field='pilot_first_name';
			break;
	}
	if($search=='' || $search=='%%'){
		$search_field='pilot_first_name';
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
		$addcountry.=" AND p.country_id=$country_id ";
	}
	$addstate='';
	if($state_id!=0){
		$addstate.=" AND p.state_id=$state_id ";
	}

	$pilots=array();
	if($search!='%%' && $search!=''){
		$stmt=db_prep("
			SELECT *,p.pilot_id
			FROM pilot p
			LEFT JOIN user u ON p.user_id=u.user_id
			LEFT JOIN state s ON p.state_id=s.state_id
			LEFT JOIN country c ON p.country_id=c.country_id
			WHERE p.$search_field $operator :search
				$addcountry
				$addstate
			ORDER BY p.pilot_first_name
		");
		$pilots=db_exec($stmt,array("search"=>$search));
	}else{
		# Get all pilots for search
		$stmt=db_prep("
			SELECT *,p.pilot_id
			FROM pilot p
			LEFT JOIN user u ON p.user_id=u.user_id
			LEFT JOIN state s ON p.state_id=s.state_id
			LEFT JOIN country c ON p.country_id=c.country_id
			WHERE 1
				$addcountry
				$addstate
			ORDER BY p.pilot_first_name
		");
		$pilots=db_exec($stmt,array());
	}
	
	# Get only countries that we have pilots for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT country_id FROM pilot) p
		LEFT JOIN country c ON c.country_id=p.country_id
		WHERE c.country_id!=0
		ORDER BY c.country_order
	");
	$countries=db_exec($stmt,array());
	# Get only states that we have locations for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT state_id FROM pilot) p
		LEFT JOIN state s ON s.state_id=p.state_id
		WHERE s.state_id!=0
		ORDER BY s.state_order
	");
	$states=db_exec($stmt,array());
	
	$pilots=show_pages($pilots,50);
	
	$smarty->assign("pilots",$pilots);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("search_field",$GLOBALS['fsession']['search_field']);
	$smarty->assign("search_operator",$GLOBALS['fsession']['search_operator']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl=find_template("admin_user_list.tpl");
	return $smarty->fetch($maintpl);
}
function admin_user_view() {
	global $user;
	global $smarty;
	
	$pilot_id=intval($_REQUEST['pilot_id']);
	
	$pilot=array();
	$pilot_planes=array();
	$pilot_clubs=array();
	$pilot_locations=array();
	$pilot_events=array();
	
	if($pilot_id!=0){
		# Get the current users pilot info
		$stmt=db_prep("
			SELECT *,p.pilot_id
			FROM pilot p
			LEFT JOIN user u ON p.pilot_id=u.pilot_id
			LEFT JOIN state s ON p.state_id=s.state_id
			LEFT JOIN country c ON p.country_id=c.country_id
			WHERE p.pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("pilot_id"=>$pilot_id));
		
		if(!isset($result[0])){
			user_message("A pilot with that id does not exist.",1);
			return pilot_list();
		}else{
			$pilot=$result[0];
			
			# Get the planes that this pilot has
			$stmt=db_prep("
				SELECT *
				FROM pilot_plane pp
				LEFT JOIN plane p ON p.plane_id=pp.plane_id
				LEFT JOIN plane_type pt ON pt.plane_type_id=p.plane_type_id
				WHERE pp.pilot_id=:pilot_id
					AND pp.pilot_plane_status=1
			");
			$pilot_planes=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
			foreach($pilot_planes as $key=>$plane){
				$disciplines=array();
				# Lets get the plane types
				$stmt=db_prep("
					SELECT *
					FROM plane_discipline pd
					LEFT JOIN discipline d ON pd.discipline_id=d.discipline_id
					WHERE pd.plane_id=:plane_id
					ORDER BY d.discipline_order
				");
				$disciplines=db_exec($stmt,array("plane_id"=>$plane['plane_id']));
				$pilot_planes[$key]['disciplines']=$disciplines;
			}
			
			# Get the pilots clubs
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

			# Get the pilots favorite locations
			$stmt=db_prep("
				SELECT *
				FROM pilot_location pl
				LEFT JOIN location l ON l.location_id=pl.location_id
				LEFT JOIN state s on s.state_id=l.state_id
				LEFT JOIN country c on c.country_id=l.country_id
				WHERE pl.pilot_id=:pilot_id
					AND pl.pilot_location_status=1
			");
			$pilot_locations=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
			
			# Get the pilots events
			$stmt=db_prep("
				SELECT *
				FROM event_pilot ep
				LEFT JOIN event e ON ep.event_id=e.event_id
				LEFT JOIN location l ON e.location_id=l.location_id
				LEFT JOIN state s on s.state_id=l.state_id
				LEFT JOIN country c on c.country_id=l.country_id
				WHERE ep.pilot_id=:pilot_id
					AND ep.event_pilot_status=1
					AND e.event_status=1
				ORDER BY event_start_date DESC
			");
			$pilot_events=db_exec($stmt,array("pilot_id"=>$pilot['pilot_id']));
		}
	}
	
	$smarty->assign("pilot",$pilot);
	$smarty->assign("pilot_id",$pilot_id);
	$smarty->assign("pilot_planes",$pilot_planes);
	$smarty->assign("pilot_locations",$pilot_locations);
	$smarty->assign("pilot_events",$pilot_events);
	$smarty->assign("pilot_clubs",$pilot_clubs);
	$smarty->assign("states",get_states());
	$smarty->assign("countries",get_countries());
	
	$maintpl=find_template("admin_user_view.tpl");
	return $smarty->fetch($maintpl);
}
function admin_user_compare() {
	global $smarty;
	global $user;

	# Lets get each of the pilots selected and show a summary
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/pilot_(\d+)/",$key,$match)){
			$id=$match[1];
			$pilots[$id]=array();
		}
	}
	# Now we've got the list of pilots, so lets get their summaries
	foreach($pilots as $pilot_id=>$p){
		$stmt=db_prep("
			SELECT *,p.pilot_id
			FROM pilot p
			LEFT JOIN user u on p.pilot_id=u.pilot_id
			WHERE p.pilot_id=:pilot_id
		");
		$pilot=db_exec($stmt,array("pilot_id"=>$pilot_id));
		
		$pilot_planes=array();
		$stmt=db_prep("
			SELECT *
			FROM pilot_plane pp
			LEFT JOIN plane p ON p.plane_id=pp.plane_id
			LEFT JOIN plane_type pt ON pt.plane_type_id=p.plane_type_id
			WHERE pp.pilot_id=:pilot_id
				AND pp.pilot_plane_status=1
		");
		$pilot_planes=db_exec($stmt,array("pilot_id"=>$pilot_id));
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
		$pilot_clubs=db_exec($stmt,array("pilot_id"=>$pilot_id));

		# Get the pilots favorite locations
		$pilot_locations=array();
		$stmt=db_prep("
			SELECT *
			FROM pilot_location pl
			LEFT JOIN location l ON l.location_id=pl.location_id
			LEFT JOIN state s on s.state_id=l.state_id
			LEFT JOIN country c on c.country_id=l.country_id
			WHERE pl.pilot_id=:pilot_id
				AND pl.pilot_location_status=1
		");
		$pilot_locations=db_exec($stmt,array("pilot_id"=>$pilot_id));
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
				AND e.event_status=1
			ORDER BY event_start_date DESC
		");
		$pilot_events=db_exec($stmt,array("pilot_id"=>$pilot_id));
		
		$pilots[$pilot_id]=$pilot[0];
		$pilots[$pilot_id]['pilot_planes']=$pilot_planes;
		$pilots[$pilot_id]['pilot_clubs']=$pilot_clubs;
		$pilots[$pilot_id]['pilot_locations']=$pilot_locations;
		$pilots[$pilot_id]['pilot_events']=$pilot_events;
		
	}

	$smarty->assign("pilots",$pilots);

	$maintpl=find_template("admin_user_compare.tpl");
	return $smarty->fetch($maintpl);
}
function admin_user_merge() {
	# Function to merge the pilots into the selected primary pilot
	global $smarty;

	# Lets get each of the pilots selected and show a summary
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/pilot_(\d+)/",$key,$match)){
			$id=$match[1];
			$pilots[$id]=array();
		}
	}
	# now lets get which ID was selected as the primary
	$primary_id=$_REQUEST['make_primary'];
	
	# OK, lets step through the pilots and change everything to the primary ID
	foreach($pilots as $pilot_id=>$p){
		if($pilot_id==$primary_id){
			continue;
		}
		# OK, lets move the planes
		$stmt=db_prep("
			UPDATE pilot_plane
			SET pilot_id=:primary_id
			WHERE pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("primary_id"=>$primary_id,"pilot_id"=>$pilot_id));
		# OK, lets move the clubs
		$stmt=db_prep("
			UPDATE club_pilot
			SET pilot_id=:primary_id
			WHERE pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("primary_id"=>$primary_id,"pilot_id"=>$pilot_id));
		# OK, lets move the locations
		$stmt=db_prep("
			UPDATE pilot_location
			SET pilot_id=:primary_id
			WHERE pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("primary_id"=>$primary_id,"pilot_id"=>$pilot_id));
		# OK, lets move the events
		$stmt=db_prep("
			UPDATE event_pilot
			SET pilot_id=:primary_id
			WHERE pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("primary_id"=>$primary_id,"pilot_id"=>$pilot_id));
		
		# And finally delete that older pilot
		$stmt=db_prep("
			DELETE FROM pilot
			WHERE pilot_id=:pilot_id
		");
		$result=db_exec($stmt,array("pilot_id"=>$pilot_id));
	}

	user_message("Merged selected pilots into pilot id $primary_id");
	return admin_user_list();
}
function admin_user_save() {
	# Function to merge the pilots into the selected primary pilot
	global $smarty;

	$pilot_id=$_REQUEST['pilot_id'];
	$pilot_first_name=$_REQUEST['pilot_first_name'];
	$pilot_last_name=$_REQUEST['pilot_last_name'];
	$pilot_city=$_REQUEST['pilot_city'];
	$state_id=intval($_REQUEST['state_id']);
	$country_id=intval($_REQUEST['country_id']);
	$pilot_ama=$_REQUEST['pilot_ama'];
	$pilot_fai=$_REQUEST['pilot_fai'];
	$pilot_email=$_REQUEST['pilot_email'];

	if($pilot_id==0){
		# Lets save the pilot
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
			"country_id"=>$country_id
		));
	}else{
		# Save the current one
		$stmt=db_prep("
			UPDATE pilot
			SET pilot_first_name=:pilot_first_name,
				pilot_last_name=:pilot_last_name,
				pilot_email=:pilot_email,
				pilot_ama=:pilot_ama,
				pilot_fai=:pilot_fai,
				pilot_city=:pilot_city,
				state_id=:state_id,
				country_id=:country_id
			WHERE pilot_id=:pilot_id
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
			"pilot_id"=>$pilot_id
		));
	}

	user_message("Saved Pilot Info");
	return admin_user_list();
}
function admin_user_delete() {
	# Function to delete the pilot
	global $smarty;

	$pilot_id=$_REQUEST['pilot_id'];
	# Delete the pilot
	$stmt=db_prep("
		DELETE FROM pilot
		WHERE pilot_id=:pilot_id
	");
	$result=db_exec($stmt,array(
		"pilot_id"=>$pilot_id
	));

	user_message("Deleted Pilot");
	return admin_user_list();
}


?>
