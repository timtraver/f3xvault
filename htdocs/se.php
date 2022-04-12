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

$location = "http://www.f3xvault.com/?action=event&function=event_self_entry&event_id=" . $_REQUEST['e'] . "&event_pilot_id=" . $_REQUEST['p'];
header( "Location: $location");
exit;
?>