<?php
############################################################################
#       lookup.php
#
#       Tim Traver
#       3/5/13
#       This is the script to do the ajax lookups for lists of pilots, planes, locations, etc...
#
############################################################################

if(file_exists('C:/Program Files (x86)/Apache Software Foundation/Apache2.2/local')){
	require_once("C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\conf.php");
}else{
	require_once("/shared/links/r/c/v/a/rcvault.com/site/php/conf.php");
}

include_library('functions.inc');
include_library('security_functions.inc');

# Main control
if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
        $function=$_REQUEST['function'];
}else{
        $function="lookup_pilot";
}

if(check_user_function($function)){
        eval("$function();");
}
exit;

function lookup_pilot() {
	global $user;
	global $smarty;

	$q = trim(urldecode(strtolower($_GET["term"])));
	$q = '%'.$q.'%';
	# Do search
	$stmt=db_prep("
		SELECT *
		FROM pilot p
		LEFT JOIN state s ON p.state_id=s.state_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE LOWER(p.pilot_first_name) LIKE :term1
			OR LOWER(p.pilot_last_name) LIKE :term2
			OR LOWER(CONCAT(p.pilot_first_name,' ',p.pilot_last_name)) LIKE :term3
	");
	$result=db_exec($stmt,array("term1"=>$q,"term2"=>$q,"term3"=>$q));
	
	foreach($result as $r){
		$pilots[]=array(
			"id"=>$r['pilot_id'],
			"label"=>"{$r['pilot_first_name']} {$r['pilot_last_name']} - {$r['pilot_city']},{$r['state_code']} - {$r['country_code']}",
			"value"=>"{$r['pilot_first_name']} {$r['pilot_last_name']}"
		);
	}

	print json_encode($pilots);
}
function lookup_event_pilot() {
	global $user;
	global $smarty;

	$event_id=$_REQUEST['event_id'];
	$q = trim(urldecode(strtolower($_GET["term"])));
	$q = '%'.$q.'%';
	# Do search
	$stmt=db_prep("
		SELECT *
		FROM event_pilot ep
		LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
		LEFT JOIN state s ON p.state_id=s.state_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE ep.event_id=:event_id
			AND (LOWER(p.pilot_first_name) LIKE :term1
			OR LOWER(p.pilot_last_name) LIKE :term2
			OR LOWER(CONCAT(p.pilot_first_name,' ',p.pilot_last_name)) LIKE :term3)
	");
	$result=db_exec($stmt,array("event_id"=>$event_id,"term1"=>$q,"term2"=>$q,"term3"=>$q));
	
	foreach($result as $r){
		$pilots[]=array(
			"id"=>$r['event_pilot_id'],
			"label"=>"{$r['pilot_first_name']} {$r['pilot_last_name']}",
			"value"=>"{$r['pilot_first_name']} {$r['pilot_last_name']}"
		);
	}

	print json_encode($pilots);
}
function lookup_plane() {
	global $user;
	global $smarty;

	$q = trim(urldecode(strtolower($_GET["term"])));
	$q = '%'.$q.'%';
	
	# Do search
	$stmt=db_prep("
		SELECT *
		FROM plane p
		LEFT JOIN plane_type pt ON p.plane_type_id=pt.plane_type_id
		WHERE LOWER(p.plane_name) LIKE :q
		ORDER BY plane_name
	");
	$result=db_exec($stmt,array("q"=>$q));
	
	foreach($result as $r){
		$planes[]=array(
			"id"=>$r['plane_id'],
			"label"=>"{$r['plane_type_short_name']} {$r['plane_name']}",
			"value"=>"{$r['plane_name']}"
		);
	}

	print json_encode($planes);
}
function lookup_location() {
	global $user;
	global $smarty;

	$q = trim(urldecode(strtolower($_GET["term"])));
	$q = '%'.$q.'%';
	
	# Do search
	$stmt=db_prep("
		SELECT *
		FROM location l
		LEFT JOIN state s ON l.state_id=s.state_id
		LEFT JOIN country c ON l.country_id=c.country_id
		WHERE LOWER(l.location_name) LIKE :q
	");
	$result=db_exec($stmt,array("q"=>$q));
	
	foreach($result as $r){
		$locations[]=array(
			"id"=>$r['location_id'],
			"label"=>"{$r['location_name']} - {$r['location_city']},{$r['state_code']} - {$r['country_code']}",
			"value"=>"{$r['location_name']} - {$r['location_city']},{$r['state_code']} - {$r['country_code']}"
		);
	}

	print json_encode($locations);
}
function lookup_club() {
	global $user;
	global $smarty;

	$q = trim(urldecode(strtolower($_GET["term"])));
	$q = '%'.$q.'%';
	
	# Do search
	$stmt=db_prep("
		SELECT *
		FROM club cl
		LEFT JOIN state s ON cl.state_id=s.state_id
		LEFT JOIN country c ON cl.country_id=c.country_id
		WHERE LOWER(cl.club_name) LIKE :q
	");
	$result=db_exec($stmt,array("q"=>$q));
	
	foreach($result as $r){
		$clubs[]=array(
			"id"=>$r['club_id'],
			"label"=>"{$r['club_name']} - {$r['club_city']},{$r['state_code']} - {$r['country_code']}",
			"value"=>"{$r['club_name']} - {$r['club_city']},{$r['state_code']} - {$r['country_code']}"
		);
	}

	print json_encode($clubs);
}
function lookup_series() {
	global $user;
	global $smarty;

	$q = trim(urldecode(strtolower($_GET["term"])));
	$q = '%'.$q.'%';
	
	# Do search
	$stmt=db_prep("
		SELECT *
		FROM series se
		LEFT JOIN state s ON se.state_id=s.state_id
		LEFT JOIN country c ON se.country_id=c.country_id
		WHERE LOWER(se.series_name) LIKE :q
	");
	$result=db_exec($stmt,array("q"=>$q));
	
	foreach($result as $r){
		$series[]=array(
			"id"=>$r['series_id'],
			"label"=>"{$r['series_name']} - {$r['state_code']} - {$r['country_code']}",
			"value"=>"{$r['series_name']} - {$r['state_code']} - {$r['country_code']}"
		);
	}

	print json_encode($series);
}
function lookup_user() {
	global $user;
	global $smarty;

	$q = trim(urldecode(strtolower($_GET["term"])));
	$q = '%'.$q.'%';
	# Do search
	$stmt=db_prep("
		SELECT *
		FROM user u
		LEFT JOIN pilot p on u.user_id=p.user_id
		LEFT JOIN state s ON p.state_id=s.state_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE LOWER(u.user_first_name) LIKE :term1
			OR LOWER(u.user_last_name) LIKE :term2
			OR LOWER(CONCAT(u.user_first_name,' ',u.user_last_name)) LIKE :term3
	");
	$result=db_exec($stmt,array("term1"=>$q,"term2"=>$q,"term3"=>$q));
	
	foreach($result as $r){
		$users[]=array(
			"id"=>$r['user_id'],
			"label"=>"{$r['user_first_name']} {$r['user_last_name']} - {$r['pilot_city']},{$r['state_code']} - {$r['country_code']}",
			"value"=>"{$r['user_first_name']} {$r['user_last_name']}"
		);
	}

	print json_encode($users);
}
?>

