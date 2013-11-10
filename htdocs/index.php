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
global $logsessions;
global $messages;
global $message_graphic;
global $debug;
global $total_queries;
global $device;
global $trace;
global $trace_on;
global $start_time;
global $system_flags;

$start_time=microtime(true);

if(file_exists('C:/Program Files (x86)/Apache Software Foundation/Apache2.2/local')){
	require_once("C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\conf.php");
}else{
	require_once("/shared/links/r/c/v/a/rcvault.com/site/php/conf.php");
}

$logsessions=1;

include_library('security_functions.inc');
include_library('functions.inc');
include_library('smarty/libs/Smarty.class.php');
include_library('Mobile-Detect/Mobile_Detect.php');

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

# Lets determine the current device they are using
if(!isset($fsession['device'])){
	$detect = new Mobile_Detect;
	$device = ($detect->isMobile() ? ($detect->isTablet() ? 'tablet' : 'phone') : 'computer');
	$fsession['device']=$device;
	save_fsession();
}else{
	$device=$fsession['device'];
}
if($device=='phone'){
	$GLOBALS['include_paths']['templates']="{$GLOBALS['include_paths']['base']}/php/templates/mobile";
	$GLOBALS['template_dir']=$GLOBALS['include_paths']['templates'];
}

# Load system flags
get_global_flags();

# Main control

# Set the default category of site
if(isset($_REQUEST['disc'])){
	switch($_REQUEST['disc']){
		case "f3b":
			$disc='f3b';
			break;
		case "f3f":
			$disc='f3f';
			break;
		case "f3j":
			$disc='f3j';
			break;
		case "f3k":
			$disc='f3k';
			break;
		case "td":
			$disc='td';
			break;
		case "all":
		default:
			$disc='all';
			break;
	}
	$fsession['disc']=$disc;
	# Get discipline id for the selected one
	$disciplines=get_disciplines();
	foreach($disciplines as $d){
		if($disc==$d['discipline_code']){
			$discipline_id=$d['discipline_id'];
			break;
		}
	}
	$fsession['discipline_id']=$discipline_id;
}else if(isset($fsession['disc'])){
	$disc=$fsession['disc'];
	$discipline_id=$fsession['discipline_id'];
}else{
	$disc='all';
	$discipline_id=0;
}
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
$trace_on=0;
if(isset($_REQUEST['trace']) || file_exists("{$GLOBALS['include_paths']['base']}/trace")){
	$trace_on=1;
}

# Set the default character set output to UTF-8
header('Content-type: text/html; charset=utf-8');

# export main template
start_smarty();
$smarty->assign("action",$action);
$smarty->assign("_REQUEST",$_REQUEST);
$smarty->assign("_SERVER",$_SERVER);
$smarty->assign("include_paths",$GLOBALS['include_paths']);
$smarty->assign("template_dir",$GLOBALS['template_dir']);
$smarty->assign("compile_dir",$GLOBALS['compile_dir']);
$smarty->assign("user",$user);
$smarty->assign("function",$_REQUEST['function']);
$smarty->assign("disc",$disc);
$smarty->assign("device",$device);
# Put system flags into smarty for templates
foreach($GLOBALS['system_flags'] as $flags){
	$smarty->assign($flags['system_flag_name'],$flags['system_flag_value']);
}

if(file_exists("{$GLOBALS['scripts_dir']}/$action.php")){
        include("{$GLOBALS['scripts_dir']}/$action.php");
}else{
        include("{$GLOBALS['scripts_dir']}/notyet.php");
}
$unread=check_unread_messages();
$smarty->assign("unread_messages",$unread);

# Add the user var again just in case it was changed by loging or logout status
$smarty->assign("user",$user);
$smarty->assign("device",$device);
$smarty->assign("current_menu",$current_menu);
$smarty->assign("fsession",$fsession);
$smarty->assign("messages",$GLOBALS['messages']);
$smarty->assign("message_graphic",$GLOBALS['message_graphic']);
$smarty->assign("total_queries",$GLOBALS['total_queries']);
$smarty->assign("trace",$GLOBALS['trace']);
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
	if($trace_on){
		print "<!-- trace : $trace\n Total Queries : {$GLOBALS['total_queries']}\n-->";
	}
}

save_fsession();

# Exit
exit;

?>

