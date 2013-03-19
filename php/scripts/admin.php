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

?>
