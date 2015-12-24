<?php
############################################################################
#       recalculate_events.php
#
#       Tim Traver
#       8/9/13
#       This is the script to recalculate all the events
#
############################################################################

require_once("/var/www/f3xvault.com/php/conf.php");

include_library('functions.inc');
include_library('event.class');

$stmt=db_prep("
	SELECT *
	FROM event e
	WHERE event_id=259
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

