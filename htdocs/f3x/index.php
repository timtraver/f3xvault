<?php
############################################################################
#       index.php
#
#       Tim Traver
#       5/21/12
#       Miva Merchant, Inc.
#       This is the main Customer Support Portal script
#
############################################################################
global $user;
global $user_id;
global $noside;
global $fsession;
global $messages;
global $message_graphic;

require_once("../wp-blog-header.php");
if(file_exists('C:/Program Files (x86)/Apache Software Foundation/Apache2.2/local')){
	require_once("C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\conf.php");
}else{
	require_once("/shared/links/r/c/v/a/rcvault.com/site/php/conf.php");
}

include_library('security_functions.inc');
include_library('functions.inc');
include_library('smarty/libs/Smarty.class.php');

start_fsession();

$noside=0;

# User Management
$user_id=get_current_user_id();

if($user_id){
	$wpuser=get_userdata($user_id);
	$user['ID']=$wpuser->ID;
	$user['user_id']=$wpuser->ID;
	$user['user_login']=$wpuser->user_login;
	$user['user_pass']=$wpuser->user_pass;
	$user['user_nicename']=$wpuser->user_nicename;
	$user['user_email']=$wpuser->user_email;
	$user['user_url']=$wpuser->user_url;
	$user['user_registered']=$wpuser->user_registered;
	$user['user_activation_key']=$wpuser->user_activation_key;
	$user['user_status']=$wpuser->user_status;
	$user['display_name']=$wpuser->display_name;
	$user['user_first_name']=$wpuser->first_name;
	$user['user_last_name']=$wpuser->last_name;
}else{
	$user=array();
}

# Check if they were logged in and now they aren't
#if($user && $user['user_status']==0){
#	destroy_fsession();
#	$errorstring="User is no longer active.";
#	start_smarty();
#	$smarty->assign("fsession",$GLOBALS['fsession']);
#	$smarty->assign("errorstring","$errorstring");
#	$logintpl=find_template("login.tpl");
#	$smarty->display($logintpl);
#	exit;
#}

# Main control

# Run program for main content
if(isset($_REQUEST['action'])) {
        $action=$_REQUEST['action'];
}else{
        $action='main';
}
# export main template
start_smarty();
$smarty->assign("action",$action);
$smarty->assign("_REQUEST",$_REQUEST);
$smarty->assign("_SERVER",$_SERVER);
$smarty->assign("include_paths",$GLOBALS['include_paths']);
$smarty->assign("template_dir",$GLOBALS['template_dir']);
$smarty->assign("compile_dir",$GLOBALS['compile_dir']);
$smarty->assign("user",$user);

if(file_exists("{$GLOBALS['scripts_dir']}/$action.php")){
        include("{$GLOBALS['scripts_dir']}/$action.php");
}else{
        include("{$GLOBALS['scripts_dir']}/notyet.php");
}
$smarty->assign("messages",$GLOBALS['messages']);
$smarty->assign("message_graphic",$GLOBALS['message_graphic']);
$no_header_footer=0;
if(isset($_REQUEST['no_header_footer'])){
	$no_header_footer=$_REQUEST['no_header_footer'];
}
if($no_header_footer==1){
	print $actionoutput;
}else{
	$messagetpl=find_template("messages.tpl");
	# Show wordpress header
	get_header();
	if($GLOBALS['messages']){
		$smarty->display($messagetpl);
	}
	print $actionoutput;
	# Now lets include and output the menu settings for each of the action types
	$menutpl=find_template("menu_$action.tpl");
	$smarty->display($menutpl);
	# Get wordpress footer
	if($noside==1){
		get_footer("noside");
	}else{
		get_footer();
	}
	Smarty_Internal_Debug::display_debug($smarty);
}

save_fsession();

# Exit
exit;

?>

