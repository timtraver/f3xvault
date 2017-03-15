<?php
############################################################################
#       lookup.php
#
#       Tim Traver
#       8/11/12
#       Miva Merchant, Inc.
#       This is the script to do ajax lookups
#
############################################################################

if(isset($_REQUEST['function']) && $_REQUEST['function'] != '') {
        $function = $_REQUEST['function'];
}else{
        $function = "lookup_pilot";
}

if(check_user_function($function)){
        eval("\$actionoutput = $function();");
}

function lookup_pilot() {
	global $user;
	global $smarty;

	$q = urldecode(strtolower($_GET["term"]));
	
	# Do search
	$stmt = db_prep("
		SELECT *
		FROM pilot p
		LEFT JOIN state s ON p.state_id = s.state_id
		LEFT JOIN country c ON p.country_id = c.country_id
		WHERE LOWER(p.pilot_first_name) LIKE '%$q%'
			OR LOWER(p.pilot_last_name) LIKE '%$q%'
			OR LOWER(CONCAT(p.pilot_first_name,' ',p.pilot_last_name)) LIKE '%$q%'
	");
	$result = db_exec($stmt,array());
	
	foreach($result as $r){
		$pilots[] = array(
			"id"	=> $r['pilot_id'],
			"label"	=> "{$r['pilot_first_name']} {$r['pilot_last_name']} - {$r['pilot_city']},{$r['state_code']} - {$r['country_code']}",
			"value"	=> "{$r['pilot_first_name']} {$r['pilot_last_name']}"
		);
	}

	print json_encode($pilots);
	exit;
}
function lookup_plane() {
	global $user;
	global $smarty;

	$q = urldecode(strtolower($_GET["term"]));
	
	# Do search
	$stmt = db_prep("
		SELECT *
		FROM plane p
		LEFT JOIN plane_type pt ON p.plane_type_id = pt.plane_type_id
		WHERE LOWER(p.plane_name) LIKE '%$q%'
	");
	$result = db_exec($stmt,array());
	
	foreach($result as $r){
		$planes[] = array(
			"id"	=> $r['plane_id'],
			"label"	=> "{$r['plane_type_short_name']} {$r['plane_name']}",
			"value"	=> "{$r['plane_name']}"
		);
	}

	print json_encode($planes);
	exit;
}
function lookup_location() {
	global $user;
	global $smarty;

	$q = urldecode(strtolower($_GET["term"]));
	
	# Do search
	$stmt = db_prep("
		SELECT *
		FROM location l
		LEFT JOIN state s ON l.state_id = s.state_id
		LEFT JOIN country c ON l.country_id = c.country_id
		WHERE LOWER(l.location_name) LIKE '%$q%'
	");
	$result = db_exec($stmt,array());
	
	foreach($result as $r){
		$locations[] = array(
			"id"	=> $r['location_id'],
			"label"	=> "{$r['location_name']} - {$r['location_city']},{$r['state_code']} - {$r['country_code']}",
			"value"	=> "{$r['location_name']} - {$r['location_city']},{$r['state_code']} - {$r['country_code']}"
		);
	}

	print json_encode($locations);
	exit;
}

?>