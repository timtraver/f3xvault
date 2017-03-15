<?php
############################################################################
#       register.php
#
#       Tim Traver
#       8/11/12
#       Miva Merchant, Inc.
#       This is the script to show the registration form
#
############################################################################
include_library('recaptchalib.php');
$GLOBALS['current_menu'] = 'register';

if(isset($_REQUEST['function']) && $_REQUEST['function'] != '') {
        $function = $_REQUEST['function'];
}else{
        $function = "view_registration";
}

if(check_user_function($function)){
        eval("\$actionoutput = $function();");
}

function view_registration() {
	global $user;
	global $smarty;
	$smarty->assign("user_first_name",$_REQUEST['user_first_name']);
	$smarty->assign("user_last_name",$_REQUEST['user_last_name']);
	$smarty->assign("user_email",strtolower($_REQUEST['user_email']));
	
	# Set recaptcha
	#$publickey = '6Le6t94SAAAAACe6fF0BzRXUx-bYvKrDPjoFKE8j';
	#$recaptcha_html = recaptcha_get_html($publickey);
	$smarty->assign("recaptcha_key",$GLOBALS['recaptcha_key']);
		
	$smarty->assign("recaptcha_html",$recaptcha_html);
	$maintpl = find_template("register.tpl");
	return $smarty->fetch($maintpl);
}
function save_registration(){
	# Function to get the user registered
	global $user;
	global $smarty;
	include_library("recaptchalib.php");
	$recaptcha_secret  = $GLOBALS['recaptcha_secret'];

	if(isset($_REQUEST['from_show_pilots'])){
		$from_show_pilots = $_REQUEST['from_show_pilots'];
	}else{
		$from_show_pilots = 0;
	}
	if(isset($_REQUEST['pilot_id']) && $_REQUEST['pilot_id'] != ''){
		$pilot_id = $_REQUEST['pilot_id'];
	}else{
		$pilot_id = 0;
	}
	$user = array();

	if(isset($_REQUEST['user_first_name']) && $_REQUEST['user_first_name'] != ''){
		$user_first_name = $_REQUEST['user_first_name'];
		$user['user_first_name'] = $user_first_name;
	}else{
		user_message("You must enter a first name",1);
	}
	if(isset($_REQUEST['user_last_name']) && $_REQUEST['user_last_name'] != ''){
		$user_last_name = $_REQUEST['user_last_name'];
		$user['user_last_name'] = $user_last_name;
	}else{
		user_message("You must enter a last name",1);
	}
	if(isset($_REQUEST['user_email']) && $_REQUEST['user_email'] != ''){
		$user_email = strtolower($_REQUEST['user_email']);
		$user['user_email'] = $user_email;
	}else{
		user_message("You must enter a valid email address as your login",1);
	}
	if(isset($_REQUEST['user_pass']) && $_REQUEST['user_pass'] != ''){
		$user_pass = $_REQUEST['user_pass'];
		$user['user_pass'] = $user_pass;
	}else{
		user_message("You must enter a password",1);
	}
	if(isset($_REQUEST['user_pass2']) && $_REQUEST['user_pass2'] != ''){
		$user_pass2 = $_REQUEST['user_pass2'];
		$user['user_pass2'] = $user_pass2;
	}else{
		user_message("You must confirm your password",1);
	}
	if(isset($_REQUEST['user_pass']) && isset($_REQUEST['user_pass2']) && $_REQUEST['user_pass']  !=  $_REQUEST['user_pass2']){
		user_message("The passwords you entered do not match. Please try again",1);
	}
	if($GLOBALS['messages']){
		return view_registration();
	}
	
	# Check to see if this user already exists
	$stmt = db_prep("
		SELECT *
		FROM user
		WHERE user_name = :user_name
			OR user_email = :user_email
		AND user_status = 1
	");
	$result = db_exec($stmt,array("user_name" => $user_email,"user_email" => $user_email));
	if($result){
		user_message("A user with this name or email address already exists. Please choose another address, or if this is yours, use the forgot password link.",1);
		return view_registration();
	}
	
	if($from_show_pilots == 0){
		# Lets check the recaptcha
		$valid  = 0;
		$reCaptcha  = new ReCaptcha($recaptcha_secret);
		if ($_POST["g-recaptcha-response"]) {
	    	$response  = $reCaptcha->verifyResponse(
	        	$_SERVER["REMOTE_ADDR"],
				$_POST["g-recaptcha-response"]
			);
			if ($response  !=  null && $response->success) {
				# Successful, so let it fall through
				$valid  = 1;
			}else{
				user_message("Recaptcha entered incorrectly!",1);
				return view_registration();
			}
		}else{
			user_message("Recaptcha entered incorrectly!",1);
			return view_registration();
		}
	
		# Lets check to see if we have any pilots with that name for them to choose from
		$stmt = db_prep("
			SELECT *
			FROM pilot p
			WHERE p.user_id = 0
			AND (p.pilot_email = LOWER(:user_email) OR p.pilot_first_name = LOWER(:user_first_name) OR p.pilot_last_name = LOWER(:user_last_name))
		");
		$result = db_exec($stmt,array(
			"user_email" => strtolower($user['user_email']),
			"user_first_name" => strtolower($user['user_first_name']),
			"user_last_name" => strtolower($user['user_last_name'])
		));
		if(isset($result[0])){
			# Step though and find the last events they were in
			$pilotlist = array();
			foreach($result as $pilot){
				$stmt = db_prep("
					SELECT *
					FROM event_pilot ep
					LEFT JOIN event e ON e.event_id = ep.event_id
					LEFT JOIN location l ON l.location_id = e.location_id
					WHERE ep.pilot_id = :pilot_id
					ORDER BY e.event_start_date desc
					LIMIT 1
				");
				$result2 = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));
				if(isset($result2[0])){
					$pilot['eventstring'] = $result2[0]['event_name']." - ".date("F j, Y",strtotime($result2[0]['event_start_date']));
				}else{
					$pilot['eventstring'] = 'None on file.';
				}
				$pilotlist[] = $pilot;
			}
			# We have found some records that look like they relate, so lets show them first
			$smarty->assign("user",$user);
			$smarty->assign("recaptcha_challenge_field",$_POST["recaptcha_challenge_field"]);
			$smarty->assign("recaptcha_response_field",$_POST["recaptcha_response_field"]);
			$smarty->assign("pilots",$pilotlist);
			$maintpl = find_template("register_show_pilots.tpl");
			return $smarty->fetch($maintpl);
		}
	}
	
	if($pilot_id == 0){
		# Create pilot record to go along with this login
		$stmt = db_prep("
			INSERT INTO pilot
			SET pilot_first_name = :pilot_first_name,
				pilot_last_name = :pilot_last_name,
				pilot_email = :pilot_email
		");
		$result = db_exec($stmt,array("pilot_first_name" => $user_first_name,"pilot_last_name" => $user_last_name,"pilot_email" => $user_email));
		$pilot_id = $result;
	}
	
	# Now lets create this user
	$stmt = db_prep("
		INSERT INTO user
		SET user_name = :user_name,
			user_first_name = :user_first_name,
			user_last_name = :user_last_name,
			user_email = :user_email,
			user_pass = :user_pass,
			pilot_id = :pilot_id,
			user_status = 1
	");
	$result = db_exec($stmt,array(
		"user_name" => $user_email,
		"user_first_name" => $user_first_name,
		"user_last_name" => $user_last_name,
		"user_email" => $user_email,
		"user_pass" => sha1($user_pass),
		"pilot_id" => $pilot_id
	));
	$user_id = $GLOBALS['last_insert_id'];
	
	# Now lets set the user id in the pilot record too
	$stmt = db_prep("
		UPDATE pilot
		SET user_id = :user_id
		WHERE pilot_id = :pilot_id
	");
	$result = db_exec($stmt,array(
		"user_id" => $user_id,
		"pilot_id" => $pilot_id
	));
	
	$user = get_user_info($user_id);
	
	# Send them back to the home page
	$action = 'main';
	$_REQUEST['action'] = 'main';
	$_REQUEST['function'] = 'user_login';
	$_REQUEST['login'] = $user_email;
	$_REQUEST['password'] = $user_pass;
	
	log_action($user['user_id']);
	user_message("Welcome ".urlencode($user_first_name)." to your F3XVault account!");
	
	send_registration_email($user['user_id']);
	$user = array();
	
	include("{$GLOBALS['scripts_dir']}/$action.php");
	return $actionoutput;	
}
function send_registration_email($user_id){
	# Function to send the reg email to the user specified
	$user_to = get_user_info($user_id);
	
	# Fill in the data with the proper link
	$hash = sha1($user_id.$user_to['user_name'].$user_to['user_email']);
	$data = $user_to;
	$data['hash'] = $hash;
	
	send_email('registration',$user_to['user_email'],$data);
	return;
}
?>
