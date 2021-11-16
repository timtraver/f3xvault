<?php
############################################################################
#	se.php
#
#	Tim Traver
#	11/15/21
#	This is the script to handle short URLs to redirect to longer ones for self entry QR codes
#
############################################################################

require_once("../php/conf.php");

include_library('functions.inc');

$location = "http://www.f3xvault.com/?action=event&function=event_self_entry&event_id=" . $_REQUEST['e'] . "&event_pilot_id=" . $_REQUEST['p'];
header( "Location: $location");
exit;
?>