<?php
############################################################################
#       recalculate_events.php
#
#       Tim Traver
#       8/9/13
#       This is the script to recalculate all the events
#
############################################################################

if(file_exists('C:/Program Files (x86)/Apache Software Foundation/Apache2.2/local')){
	require_once("C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\conf.php");
}else{
	require_once("/shared/links/r/c/v/a/rcvault.com/site/php/conf.php");
}

include_library('functions.inc');
include_library('event.class');

$stmt=db_prep("
	SELECT *
	FROM event e
	WHERE event_status=1
	ORDER BY e.event_start_date
");
$result=db_exec($stmt,array());
foreach($result as $event){
	print "Recalculating for event {$event['event_name']}...";
	$e=new Event($event['event_id']);
	$e->get_rounds();
	$e->event_save_totals();
	print "complete.\n";
}

?>

