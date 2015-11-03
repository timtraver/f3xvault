<?php
############################################################################
#       index.php
#
#       Tim Traver
#       5/21/12
#       This is the main F3XVault parent script
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

require_once("/shared/links/r/c/v/a/rcvault.com/site/php/new/conf.php");

$logsessions=1;

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
if(isset($_REQUEST['function'])){
	$smarty->assign("function",$_REQUEST['function']);
}else{
	$smarty->assign("function",'');
}
$smarty->assign("disc",$disc);
$smarty->assign("current_menu",$current_menu);
$unread=check_unread_messages();
$smarty->assign("unread_messages",$unread);
# Put system flags into smarty for templates
foreach($GLOBALS['system_flags'] as $flags){
	$smarty->assign($flags['system_flag_name'],$flags['system_flag_value']);
}
# Get basic database stats
$stats = get_database_stats();
$smarty->assign("stats",$stats);

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
$smarty->assign("total_queries",$GLOBALS['total_queries']);
$smarty->assign("trace",$GLOBALS['trace']);
$messagetpl=find_template("messages.tpl");
#if($GLOBALS['messages']){
#	$smarty->display($messagetpl);
#}
print $actionoutput;

if($trace_on){
	print "<!-- trace : $trace\n Total Queries : {$GLOBALS['total_queries']}\n-->";
}

save_fsession();

# Exit
exit;

?>

