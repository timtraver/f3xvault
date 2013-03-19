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

?>
