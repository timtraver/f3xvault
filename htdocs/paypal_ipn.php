<?php
############################################################################
#       paypal_ipn.php
#
#       Tim Traver
#       2/12/14
#       This is the paypal return IPN script to process messages from paypal
#		Into succesful payments being marked in the system
#
############################################################################
#
require_once("/var/www/f3xvault.com/php/conf.php");
include_library('functions.inc');


// CONFIG: Enable debug mode. This means we'll log requests into 'ipn.log' in the same directory.
// Especially useful if you encounter network errors or other intermittent problems with IPN (validation).
// Set this to 0 once you go live or don't require logging.
define("DEBUG", 1);

// Set to 0 once you're ready to go live
define("USE_SANDBOX", 0);


define("LOG_FILE", "./ipn.log");


// Read POST data
// reading posted data directly from $_POST causes serialization
// issues with array data in POST. Reading raw POST data from input stream instead.
$raw_post_data = file_get_contents('php://input');
$raw_post_array = explode('&', $raw_post_data);
$myPost = array();
foreach ($raw_post_array as $keyval) {
	$keyval = explode ('=', $keyval);
	if (count($keyval) == 2)
		$myPost[$keyval[0]] = urldecode($keyval[1]);
}
// read the post from PayPal system and add 'cmd'
$req = 'cmd=_notify-validate';
if(function_exists('get_magic_quotes_gpc')) {
	$get_magic_quotes_exists = true;
}
foreach ($myPost as $key => $value) {
	if($get_magic_quotes_exists == true && get_magic_quotes_gpc() == 1) {
		$value = urlencode(stripslashes($value));
	} else {
		$value = urlencode($value);
	}
	$req .= "&$key=$value";
}

// Post IPN data back to PayPal to validate the IPN data is genuine
// Without this step anyone can fake IPN data

if(USE_SANDBOX == true) {
	$paypal_url = "https://www.sandbox.paypal.com/cgi-bin/webscr";
} else {
	$paypal_url = "https://www.paypal.com/cgi-bin/webscr";
}

$ch = curl_init($paypal_url);
if ($ch == FALSE) {
	return FALSE;
}

curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $req);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 1);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 2);
curl_setopt($ch, CURLOPT_FORBID_REUSE, 1);

if(DEBUG == true) {
	curl_setopt($ch, CURLOPT_HEADER, 1);
	curl_setopt($ch, CURLINFO_HEADER_OUT, 1);
}

// CONFIG: Optional proxy configuration
//curl_setopt($ch, CURLOPT_PROXY, $proxy);
//curl_setopt($ch, CURLOPT_HTTPPROXYTUNNEL, 1);

// Set TCP timeout to 30 seconds
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Connection: Close'));

// CONFIG: Please download 'cacert.pem' from "http://curl.haxx.se/docs/caextract.html" and set the directory path
// of the certificate as shown below. Ensure the file is readable by the webserver.
// This is mandatory for some environments.

$cert = $GLOBALS['include_paths']['libraries']."/cacert.pem";
curl_setopt($ch, CURLOPT_CAINFO, $cert);

$res = curl_exec($ch);
if (curl_errno($ch) != 0) // cURL error
	{
	if(DEBUG == true) {	
		error_log(date('[Y-m-d H:i e] '). "Can't connect to PayPal to validate IPN message: " . curl_error($ch) . PHP_EOL, 3, LOG_FILE);
	}
	curl_close($ch);
	exit;

} else {
		// Log the entire HTTP response if debug is switched on.
		if(DEBUG == true) {
			error_log(date('[Y-m-d H:i e] '). "HTTP request of validation request:". curl_getinfo($ch, CURLINFO_HEADER_OUT) ." for IPN payload: $req" . PHP_EOL, 3, LOG_FILE);
			error_log(date('[Y-m-d H:i e] '). "HTTP response of validation request: $res" . PHP_EOL, 3, LOG_FILE);

			// Split response headers and payload
			list($headers, $res) = explode("\r\n\r\n", $res, 2);
		}
		curl_close($ch);
}

// Inspect IPN validation result and act accordingly

if (preg_match("/VERIFIED/",$res)) {
 	error_log(date('[Y-m-d H:i e] '). "POST Variables : ".print_r($_POST,true). PHP_EOL, 3, LOG_FILE);
 	$event_pilot_id=$_POST['custom'];
	$event_pilot=array();
	# Get the info of the event_pilot
	$stmt=db_prep("
		SELECT *
		FROM event_pilot ep
		LEFT JOIN event e ON ep.event_id=e.event_id
		WHERE event_pilot_id=:event_pilot_id
	");
	$result=db_exec($stmt,array("event_pilot_id"=>$event_pilot_id));
	if(isset($result[0])){
		$event_pilot=$result[0];
 	}else{
 		error_log(date('[Y-m-d H:i e] '). "Did not find an event pilot with the value $event_pilot_id". PHP_EOL, 3, LOG_FILE);
 	}
	
	$checked_out=1;
	// check whether the payment_status is Completed
	if($_POST['payment_status']!='Completed'){
		$checked_out=0;
	}
	// check that txn_id has not been previously processed
	// check that receiver_email is your PayPal email
	if(strtolower($_POST['receiver_email'])!=strtolower($event_pilot['event_reg_paypal_address'])){
		$checked_out=0;
	}
	// check that payment_amount/payment_currency are correct
	// process payment and mark item as paid.

	// assign posted variables to local variables
	//$item_name = $_POST['item_name'];
	//$item_number = $_POST['item_number'];
	//$payment_status = $_POST['payment_status'];
	$payment_amount = $_POST['mc_gross'];
	//$payment_currency = $_POST['mc_currency'];
	//$txn_id = $_POST['txn_id'];
	$receiver_email = $_POST['receiver_email'];
	$payer_email = $_POST['payer_email'];
	
	error_log(date('[Y-m-d H:i e] '). "event_pilot_id: $event_pilot_id" . PHP_EOL, 3, LOG_FILE);
	error_log(date('[Y-m-d H:i e] '). "checked_out: $checked_out" . PHP_EOL, 3, LOG_FILE);
	error_log(date('[Y-m-d H:i e] '). "receiver_email: $receiver_email" . PHP_EOL, 3, LOG_FILE);
	error_log(date('[Y-m-d H:i e] '). "event_email: {$event_pilot['event_reg_paypal_address']}" . PHP_EOL, 3, LOG_FILE);
	if($checked_out==1 && isset($event_pilot['event_pilot_id'])){
		# Add the payment record
		$stmt=db_prep("
			INSERT INTO event_pilot_payment
			SET event_pilot_id=:event_pilot_id,
				event_pilot_payment_date=now(),
				event_pilot_payment_type='Paypal',
				event_pilot_payment_amount=:amount,
				event_pilot_payment_status=1
		");
		$result=db_exec($stmt,array(
			"event_pilot_id"=>$event_pilot_id,
			"amount"=>$payment_amount
		));
		$balance = calculate_amount_owed($event_pilot_id);
		if($balance <=0){
			# Set the whole event_pilot status to paid
			$stmt=db_prep("
				UPDATE event_pilot
				SET event_pilot_paid_flag=1
				WHERE event_pilot_id=:event_pilot_id
			");
			$result=db_exec($stmt,array(
				"event_pilot_id"=>$event_pilot_id
			));
		}
	}
	
	if(DEBUG == true) {
		error_log(date('[Y-m-d H:i e] '). "Verified IPN: $req ". PHP_EOL, 3, LOG_FILE);
	}
} else if (strcmp ($res, "INVALID") == 0) {
	// log for manual investigation
	// Add business logic here which deals with invalid IPN messages
	if(DEBUG == true) {
		error_log(date('[Y-m-d H:i e] '). "Invalid IPN: $req" . PHP_EOL, 3, LOG_FILE);
	}
}

function calculate_amount_owed($event_pilot_id){
	# Function to determine the balance owed by a pilot
	$stmt=db_prep("
		SELECT *
		FROM event_pilot_reg epr
		LEFT JOIN event_reg_param erp ON epr.event_reg_param_id=erp.event_reg_param_id
		WHERE epr.event_pilot_id=:event_pilot_id
			AND epr.event_pilot_reg_status=1
	");
	$result=db_exec($stmt,array(
		"event_pilot_id"=>$event_pilot_id,
	));
	$total_owed = 0;
	foreach($result as $row){
		$total_owed += $row['event_pilot_reg_qty']*$row['event_reg_param_cost'];
	}
	# Total the paid records
	$stmt=db_prep("
		SELECT sum(event_pilot_payment_amount) as total_paid
		FROM event_pilot_payment
		WHERE event_pilot_id=:event_pilot_id
			AND event_pilot_payment_status=1
	");
	$result=db_exec($stmt,array(
		"event_pilot_id"=>$event_pilot_id,
	));
	$total_paid = $result[0]['total_paid'];
	$balance = $total_owed - $total_paid;
	return $balance;
}

?>