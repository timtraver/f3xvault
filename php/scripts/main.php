<?php
############################################################################
#       main.php
#
#       Tim Traver
#       8/11/12
#       This is the script to show the main screen
#
############################################################################

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
        $function=$_REQUEST['function'];
}else{
        $function="view";
}

if(check_user_function($function)){
        eval("\$actionoutput=$function();");
}

function view() {
	global $smarty;
	global $user;

	# Get my event entries
	$stmt=db_prep("
		SELECT *
		FROM event
		WHERE user_id=:user_id
		AND event_status=1
		ORDER BY event_end_date desc
	");
	$results=db_exec($stmt,array($user['user_id']));

	$smarty->assign("events",$results);
	$maintpl=find_template("main.tpl");
	return $smarty->fetch($maintpl);
}

?>
