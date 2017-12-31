<?php
############################################################################
#	api.php
#
#	Tim Traver
#	3/11/17
#	This is the script to handle api calls to the system
#
############################################################################

require_once("../php/conf.php");

include_library('functions.inc');
include_library('security_functions.inc');
include_library('api.class');
include_library('smarty/libs/Smarty.class.php');

$api = new API();
if($api->api_check_login() && $api->api_check_event_access()){
	$api->api_process_request();
}
$api->api_send_response();

exit;
?>