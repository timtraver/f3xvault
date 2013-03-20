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
global $fsession;
global $current_menu;
global $messages;
global $message_graphic;
global $debug;

if(file_exists('C:/Program Files (x86)/Apache Software Foundation/Apache2.2/local')){
	require_once("C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\conf.php");
}else{
	require_once("/shared/links/r/c/v/a/rcvault.com/site/php/conf.php");
}

include_library('security_functions.inc');
include_library('functions.inc');
include_library('smarty/libs/Smarty.class.php');

start_fsession();

# User Management
$user=array();
if(isset($GLOBALS['fsession']['auth'])) {
	# User is logged in, so lets get their info
	$user=get_user_info($GLOBALS['fsession']['user_id']);
	$user_id=$user['user_id'];
}

# Check if they were logged in and now they aren't
if($user && $user['user_status']==0){
	destroy_fsession();
	$errorstring="User is no longer active.";
}

# Main control

$unread=check_unread_messages();

# Set default current menu item
$current_menu='home';

# Run program for main content
if(isset($_REQUEST['action'])) {
        $action=$_REQUEST['action'];
}else{
        $action='main';
}

# Lets check if there is a debug file in place, or the user sends a debug parameter
$debug=0;
if(isset($_REQUEST['debug']) || file_exists("{$GLOBALS['include_paths']['base']}/debug")){
	$debug=1;
}

# export main template
start_smarty();
$smarty->assign("action",$action);
$smarty->assign("_REQUEST",$_REQUEST);
$smarty->assign("_SERVER",$_SERVER);
$smarty->assign("include_paths",$GLOBALS['include_paths']);
$smarty->assign("template_dir",$GLOBALS['template_dir']);
$smarty->assign("compile_dir",$GLOBALS['compile_dir']);
$smarty->assign("unread_messages",$unread);
$smarty->assign("user",$user);

if(file_exists("{$GLOBALS['scripts_dir']}/$action.php")){
        include("{$GLOBALS['scripts_dir']}/$action.php");
}else{
        include("{$GLOBALS['scripts_dir']}/notyet.php");
}
# Add the user var again just in case it was changed by loging or logout status
$smarty->assign("user",$user);
$smarty->assign("current_menu",$current_menu);
$smarty->assign("fsession",$fsession);
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
	if($_REQUEST['use_print_header']==1){
		$headertpl=find_template("print_header.tpl");
	}else{
		$headertpl=find_template("header.tpl");
	}
	$smarty->display($headertpl);
	if($GLOBALS['messages']){
		$smarty->display($messagetpl);
	}
	print $actionoutput;

	if($_REQUEST['use_print_header']==1){
		$footertpl=find_template("print_footer.tpl");
	}else{
		$footertpl=find_template("footer.tpl");
	}
	$smarty->display($footertpl);
}

save_fsession();

# Exit
exit;

?>

