<?php
############################################################################
#       series_update.php
#
#       Tim Traver
#       12/15/14
#       This is the script to Get all the series assigned to events to the new event series table
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
	WHERE 1
	ORDER BY e.event_start_date
");
$result=db_exec($stmt,array());
foreach($result as $event){
	print "Updating for event {$event['event_name']}...";
	$e=new Event($event['event_id']);
	if($event['series_id']){
		$series_id=$event['series_id'];
		# Lets see if there is a event series record for this one to turn on
		$stmt=db_prep("
			SELECT *
			FROM event_series es
			WHERE es.event_id=:event_id
				AND es.series_id=:series_id
		");
		$result=db_exec($stmt,array("event_id"=>$event['event_id'],"series_id"=>$series_id));
		if(isset($result[0])){
			$event_series_id=$result[0]['event_series_id'];
			$stmt=db_prep("
				UPDATE event_series
				SET event_series_status=1
				WHERE event_series_id=:event_series_id
			");
			$result=db_exec($stmt,array("event_series_id"=>$event_series_id));
		}else{
			# Make a new entry
			$stmt=db_prep("
				INSERT INTO event_series
				SET event_id=:event_id,
					series_id=:series_id,
					event_series_multiple=1,
					event_series_status=1
			");
			$result=db_exec($stmt,array("event_id"=>$event['event_id'],"series_id"=>$event['series_id']));
		}
	}
	print "complete.\n";
}

?>

