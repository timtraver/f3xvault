<?php
############################################################################
#	recaptcha2.php
#
#	Tim Traver
#	2/15/16
#	Functions to handle new recaptcha
#
############################################################################
global $admin_pass;

function recaptcha_check(){
	# Function to make the call back to google recaptcha servers and get the response
	global $recaptcha_secret;

	$entered_recaptcha_key = $_REQUEST['g-recaptcha-response'];
	
	$host = "www.google.com";
	$uri = "/recaptcha/api/siteverify";
	$port = 443;
	
	$data = array(
		"secret"	=> $recaptcha_secret,
		"response"	=> $entered_recaptcha_key,
		"ip"		=> $_SERVER['REMOTE_IP']
	);
	
	$req = _recaptcha_qsencode($data);

	$http_request  = "POST $uri HTTP/1.1\r\n";
	$http_request .= "Host: $host\r\n";
	$http_request .= "Content-Type: application/x-www-form-urlencoded;\r\n";
	$http_request .= "Content-Length: " . strlen($req) . "\r\n";
	$http_request .= "User-Agent: reCAPTCHA/PHP\r\n";
	$http_request .= "\r\n";
	$http_request .= $req;

	$response = '';
	if( false == ( $fs = @fsockopen($host, $port, $errno, $errstr, 10) ) ) {
		die ('Could not open socket');
	}

	fwrite($fs, $http_request);

	while ( !feof($fs) ){
		$response .= fgets($fs, 1160); // One TCP-IP packet
	}
	fclose($fs);
	
	$response_array = json_decode($response);

	if($response_array['success'] == TRUE){
		return 1;
	}else{
		return 0;
	}
}

function _recaptcha_qsencode($data) {
	$req = "";
	foreach ( $data as $key => $value ) {
		$req .= $key . '=' . urlencode( stripslashes($value) ) . '&';
	}

	// Cut the last '&'
	$req=substr($req,0,strlen($req)-1);
	return $req;
}

?>