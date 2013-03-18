<?php
############################################################################
#       admin.php
#
#       Tim Traver
#       3/18/13
#       This is the script to show the main screen
#
############################################################################

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
        $function=$_REQUEST['function'];
}else{
        $function="view_admin";
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

function view_admin() {
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

?>
