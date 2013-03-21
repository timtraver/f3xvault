<?php
############################################################################
#       main.php
#
#       Tim Traver
#       8/11/12
#       This is the script to show the main screen
#
############################################################################

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
        $function=$_REQUEST['function'];
}else{
        $function="view_home";
}

if(check_user_function($function)){
        eval("\$actionoutput=$function();");
}

function view_home() {
	global $smarty;
	global $user;
	$GLOBALS['current_menu']='home';

	$maintpl=find_template("home.tpl");
	return $smarty->fetch($maintpl);
}
function view_locations() {
	global $smarty;
	global $user;
	$GLOBALS['current_menu']='locations';

	$maintpl=find_template("locations.tpl");
	return $smarty->fetch($maintpl);
}
function view_planes() {
	global $smarty;
	global $user;
	$GLOBALS['current_menu']='planes';

	$maintpl=find_template("planes.tpl");
	return $smarty->fetch($maintpl);
}
function view_events() {
	global $smarty;
	global $user;
	$GLOBALS['current_menu']='events';

	$maintpl=find_template("events.tpl");
	return $smarty->fetch($maintpl);
}
function view_pilots() {
	global $smarty;
	global $user;
	$GLOBALS['current_menu']='pilots';

	$maintpl=find_template("pilots.tpl");
	return $smarty->fetch($maintpl);
}
function view_clubs() {
	global $smarty;
	global $user;
	$GLOBALS['current_menu']='clubs';

	$maintpl=find_template("clubs.tpl");
	return $smarty->fetch($maintpl);
}
function login() {
	global $smarty;
	global $user;
	$GLOBALS['current_menu']='login';

	$maintpl=find_template("login.tpl");
	return $smarty->fetch($maintpl);
}
function user_login() {
	global $smarty;
	global $user;
	$GLOBALS['current_menu']='login';

	# ok, lets log the user in
	$check=check_login();
	if($check[0]==0){
		save_fsession();
		# The user is successfully logged in, so lets redirect to refresh the page
		$user=get_user_info($_REQUEST['login']);
		user_message("Welcome {$user['user_first_name']}! You are now successfully logged in to the site.");
		log_action($user['user_id']);
		return view_home();
	}
	# Unsuccessful login
	$user=array();
	user_message($check[1],1);
	$maintpl=find_template("login.tpl");
	return $smarty->fetch($maintpl);
}
function logout() {
	global $smarty;
	global $user;
	$GLOBALS['current_menu']='login';

	# ok, lets log them out
	destroy_fsession();
	$user=array();
	user_message("You have been logged out.");
	$maintpl=find_template("login.tpl");
	return $smarty->fetch($maintpl);
}
function main_feedback() {
	global $smarty;
	global $user;

	$maintpl=find_template("feedback.tpl");
	return $smarty->fetch($maintpl);
}
function main_feedback_save() {
	global $smarty;
	global $user;
	
	$feedback_string=$_REQUEST['feedback_string'];
	# Get admin user id
	$stmt=db_prep("
		SELECT *
		FROM user u
		WHERE user_admin=1
	");
	$result=db_exec($stmt,array());
	$admin_user_id=$result[0]['user_id'];
	
	# Lets save it as a message in the system
	$stmt=db_prep("
		INSERT INTO user_message
		SET user_message_date=now(),
			user_id=:admin_user_id,
			from_user_id=:user_id,
			user_message_subject=:user_message_subject,
			user_message_text=:user_message_text,
			user_message_read_status=0,
			user_message_status=1
	");
	$result=db_exec($stmt,array(
		"admin_user_id"=>$admin_user_id,
		"user_id"=>$user['user_id'],
		"user_message_subject"=>'Feeback Form Submission',
		"user_message_text"=>$feedback_string
	));
	
	$data=$user;
	$data['feedback_string']=$feedback_string;
	
	send_email('feedback',array('timtraver@gmail.com'),$data);
	user_message("Thank You for your comments and suggestions!");
	return view_home();
}

?>
