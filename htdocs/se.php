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

# Check the server name first and if its not www.f3xvault.com, then redirect to this script again at the new host
$server = $_SERVER['HTTP_HOST'];
if( $server != 'www.f3xvault.com' ){
	# Redirect to this script again with the right domain
	$location = "http://www.f3xvault.com/se.php?p=" . $_REQUEST['p'];
	if( isset( $_REQUEST['r'] ) ){
		$location .= "&r=" . $_REQUEST['r'];
	}
	header( "Location: $location");
	exit;
}

# Let us auto log in the pilot before we send them to the self score. That way they don't need to log into the vault
# let's get the user info
$stmt = db_prep( "
	SELECT *, u.user_id, u.user_name
	FROM event_pilot ep
	LEFT JOIN pilot p ON ep.pilot_id = p.pilot_id
	LEFT JOIN user u ON p.user_id = u.user_id
	WHERE ep.event_pilot_id = :event_pilot_id
		AND u.user_status = 1
" );
$result = db_exec( $stmt, array(
	"event_pilot_id" => $_REQUEST['p']
) );
$user = $result[0];

$path = "/";
$host = $_SERVER['HTTP_HOST'];
# New session stuff
destroy_fsession();
create_fsession($path,$host);
$fsession['auth'] = TRUE;
$fsession['user_id'] = $user['user_id'];
$fsession['user_name'] = $user['user_name'];
save_fsession();

$location = "http://www.f3xvault.com/?action=event&function=event_self_entry&event_id=" . $user['event_id'] . "&event_pilot_id=" . $_REQUEST['p'];
if( isset( $_REQUEST['r'] ) ){
	$location .= "&round_number=" . $_REQUEST['r'];
}
header( "Location: $location");
exit;
?>