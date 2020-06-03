<?php
############################################################################
#       apple-app-site-association.php
#
#       Tim Traver
#       6/3/20
#       This is a script to export the apple app association json data
#
############################################################################

$output['applinks'] = array(
	"apps" => array(),
	"details" => array( array(
		"appID" => "3FDNN97GK2.com.f3xvault",
		"paths" => array("*"),
	)),
);

header('Content-Type: application/json');
print json_encode( $output );
exit;

?>