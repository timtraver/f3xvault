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

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
        $function=$_REQUEST['function'];
}else{
        $function="lookup_pilot";
}

if(check_user_function($function)){
        eval("\$actionoutput=$function();");
}

function lookup_pilot() {
	global $user;
	global $smarty;

	$q = urldecode(strtolower($_GET["term"]));
	
	# Check to see if this user already exists
	$stmt=db_prep("
		SELECT *
		FROM pilot p
		LEFT JOIN state s ON p.state_id=s.state_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE LOWER(p.pilot_first_name) LIKE '%$q%'
			OR LOWER(p.pilot_last_name) LIKE '%$q%'
			OR LOWER(CONCAT(p.pilot_first_name,' ',p.pilot_last_name)) LIKE '%$q%'
	");
	$result=db_exec($stmt,array());
	
	foreach($result as $r){
		$pilots[]=array(
			"id"=>$r['pilot_id'],
			"label"=>"{$r['pilot_first_name']} {$r['pilot_last_name']} - {$r['pilot_city']},{$r['state_code']} - {$r['country_code']}",
			"value"=>"{$r['pilot_first_name']} {$r['pilot_last_name']}"
		);
	}

	print json_encode($pilots);
	exit;

}

?>
