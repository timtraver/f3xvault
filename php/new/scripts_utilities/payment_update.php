<?php
############################################################################
#       payment_update.php
#
#       Tim Traver
#       12/20/15
#       This is the script to Reset the payments with all of the previous payments
#
############################################################################
date_default_timezone_set("America/Los_Angeles");

require_once("/shared/links/r/c/v/a/rcvault.com/site/php/conf.php");

include_library('functions.inc');

$stmt=db_prep("
	SELECT *
	FROM event_pilot ep
	LEFT JOIN event e ON ep.event_id=e.event_id
	LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
	WHERE e.event_reg_flag=1
		AND e.event_status=1
		AND ep.event_pilot_paid_flag=1
	ORDER BY e.event_start_date
");
$result=db_exec($stmt,array());
foreach($result as $p){
	print "Updating for event {$p['event_id']} {$p['event_name']} - pilot {$p['event_pilot_id']} {$p['pilot_first_name']} {$p['pilot_last_name']} .... ";
	# Lets assume that if the payment date is before the event that it is paypal
	$event_start_date = date("Y-m-d",strtotime($p['event_start_date']));
	if($p['event_pilot_paid_date'] == ''){
		$pilot_paid = date("Y-m-d",strtotime($p['event_start_date']));
		$p['event_pilot_paid_date'] = $pilot_paid;
	}else{
		$pilot_paid = date("Y-m-d",strtotime($p['event_pilot_paid_date']));
	}
	$start_date_time = strtotime($event_start_date);
	$pilot_paid_time = strtotime($pilot_paid);
	
	if($pilot_paid_time >= $start_date_time){
		$type = 'Manual';
	}else{
		$type = 'Paypal';
	}
	print "{$p['event_pilot_paid_date']} - $type";
	# Lets get what they paid
	$stmt2=db_prep("
		SELECT *
		FROM event_pilot_reg epr
		LEFT JOIN event_reg_param erp ON epr.event_reg_param_id=erp.event_reg_param_id
		WHERE epr.event_pilot_id=:event_pilot_id
			AND epr.event_pilot_reg_status=1
	");
	$result2=db_exec($stmt2,array(
		"event_pilot_id"=>$p['event_pilot_id']
	));
	$total_owed = 0;
	foreach($result2 as $row){
		$total_owed += $row['event_pilot_reg_qty']*$row['event_reg_param_cost'];
	}

	# Ok, now lets create the payment record
	$stmt=db_prep("
		INSERT INTO event_pilot_payment
		SET event_pilot_id=:event_pilot_id,
			event_pilot_payment_date=:event_pilot_payment_date,
			event_pilot_payment_type=:event_pilot_payment_type,
			event_pilot_payment_amount=:event_pilot_payment_amount,
			event_pilot_payment_status=1
	");
	$result=db_exec($stmt,array(
		"event_pilot_id"=>$p['event_pilot_id'],
		"event_pilot_payment_date"=>$p['event_pilot_paid_date'],
		"event_pilot_payment_type"=>$type,
		"event_pilot_payment_amount"=>$total_owed
	));
	
	print "  ... complete.\n";
}

?>

