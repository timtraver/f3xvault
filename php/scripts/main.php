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
        $function="view_home";
}

if(check_user_function($function)){
        eval("\$actionoutput=$function();");
}

function view_home() {
	global $smarty;
	global $user;
	global $fsession;
	$smarty->assign('current_menu','home');

	# If this is their first hit to the site, then show them the welcome screen
	$maintpl=find_template("home.tpl");
	if(!isset($fsession['welcome']) || $_REQUEST['slideshow'] == 1){
		if(isset($_REQUEST['user_only'])){
			$smarty->assign("user_id",$user['user_id']);
		}
		if($_REQUEST['slideshow'] == 1){
			$maintpl=find_template("slideshow.tpl");
		}else{
			$maintpl=find_template("welcome.tpl");
		}
		$fsession['welcome']=1;
		return $smarty->fetch($maintpl);
	}
	# And if they are actually logged in, then show them the my home page
	if($user['user_name'] !=''){
		# lets find out if they have some events that they are CD'ing or participating in coming up
		$current = array();
		$future = array();
		$past = array();
		$now = strtotime(date("Y-m-d",time()));
		$stmt=db_prep("
			SELECT *,ep.pilot_id as epilot_id
			FROM event e
			LEFT JOIN event_pilot ep ON ep.event_id=e.event_id
			WHERE ((ep.pilot_id=:pilot_id AND ep.event_pilot_status=1) OR e.pilot_id=:pilot_id2 OR e.event_cd=:pilot_id3)
				AND e.event_status=1
			GROUP BY e.event_id
			ORDER BY e.event_start_date DESC
		");
		$result=db_exec($stmt,array(
			"pilot_id"=>$user['pilot_id'],
			"pilot_id2"=>$user['pilot_id'],
			"pilot_id3"=>$user['pilot_id']
		));
				
		foreach($result as $row){
			if(($row['event_cd'] == $user['pilot_id'] || $row['epilot_id'] == $user['pilot_id']) && ($now >= strtotime($row['event_start_date']) && $now <= strtotime($row['event_end_date']))){
				$current = $row;
			}elseif(strtotime($row['event_start_date']) > $now){
				$future[]=$row;
			}else{
				$past[]=$row;
			}
		}
		$smarty->assign("current",$current);
		$smarty->assign("future",$future);
		$smarty->assign("past",$past);
		$maintpl = find_template("my_home.tpl");
	}
	return $smarty->fetch($maintpl);
}
function view_locations() {
	global $smarty;
	global $user;
	$smarty->assign('current_menu','locations');

	$maintpl=find_template("location/locations.tpl");
	return $smarty->fetch($maintpl);
}
function view_planes() {
	global $smarty;
	global $user;
	$smarty->assign('current_menu','planes');

	$maintpl=find_template("plane/planes.tpl");
	return $smarty->fetch($maintpl);
}
function view_events() {
	global $smarty;
	global $user;
	$smarty->assign('current_menu','events');

	$maintpl=find_template("event/events.tpl");
	return $smarty->fetch($maintpl);
}
function view_pilots() {
	global $smarty;
	global $user;
	$smarty->assign('current_menu','pilots');

	$maintpl=find_template("pilot/pilots.tpl");
	return $smarty->fetch($maintpl);
}
function view_clubs() {
	global $smarty;
	global $user;
	$smarty->assign('current_menu','clubs');

	$maintpl=find_template("club/clubs.tpl");
	return $smarty->fetch($maintpl);
}
function login() {
	global $smarty;
	global $user;
	$smarty->assign('current_menu','login');

	$maintpl=find_template("login.tpl");
	return $smarty->fetch($maintpl);
}
function user_login() {
	global $smarty;
	global $user;
	global $actionoutput;

	# ok, lets log the user in
	$check=check_login();
	if($check[0]==0){
		# The user is successfully logged in, so lets redirect to refresh the page
		$user=get_user_info($_REQUEST['login']);
		user_message("Welcome {$user['user_first_name']}! You are now successfully logged in to the site.");
		log_action($user['user_id']);
		
		if(isset($_REQUEST['redirect_action']) && $_REQUEST['redirect_action'] != ''){
			$_REQUEST['action']=$_REQUEST['redirect_action'];
		}else{
			$_REQUEST['action']='main';
		}
		if(isset($_REQUEST['redirect_function']) && $_REQUEST['redirect_function'] != ''){
			$_REQUEST['function']=$_REQUEST['redirect_function'];
		}else{
			$_REQUEST['function']='view_home';
		}
		$GLOBALS['user_id']=$user['user_id'];
		$user=get_user_info($GLOBALS['user_id']);
		$smarty->assign("user",$user);
		if($_REQUEST['action'] == 'main'){
			return view_home();
		}
        include("{$GLOBALS['scripts_dir']}/{$_REQUEST['action']}.php");
		return $actionoutput;
	}
	# Unsuccessful login
	$user=array();
	user_message($check[1],1);
	
	$smarty->assign("redirect_action",$_REQUEST['redirect_action']);
	$smarty->assign("redirect_function",$_REQUEST['redirect_function']);
	$smarty->assign("request",$_REQUEST);
	$maintpl=find_template("login.tpl");
	return $smarty->fetch($maintpl);
}
function logout() {
	global $smarty;
	global $user;
	$smarty->assign('current_menu','login');

	# ok, lets log them out
	destroy_fsession();
	$user=array();
	user_message("You have been logged out.");
	$maintpl=find_template("login.tpl");
	return $smarty->fetch($maintpl);
}
function main_feedback() {
	global $smarty;
	global $user;

	$smarty->assign("recaptcha_key",$GLOBALS['recaptcha_key']);
	$maintpl=find_template("feedback.tpl");
	return $smarty->fetch($maintpl);
}
function main_feedback_save() {
	global $smarty;
	global $user;
	include_library("recaptchalib.php");
	
	$email_address=$_REQUEST['email_address'];
	$feedback_string=$_REQUEST['feedback_string'];
	
	$recaptcha_secret = $GLOBALS['recaptcha_secret'];
	
	# Check recaptcha entered
	$reCaptcha = new ReCaptcha($recaptcha_secret);
	if ($_POST["g-recaptcha-response"]) {
    	$response = $reCaptcha->verifyResponse(
        	$_SERVER["REMOTE_ADDR"],
			$_POST["g-recaptcha-response"]
		);
		if ($response != null && $response->success) {
			# Successful, so let it fall through
		}else{
			user_message("Recaptcha entered incorrectly!");
			return main_feedback();
		}
	}else{
		user_message("Recaptcha entered incorrectly!");
		return main_feedback();
	}
	
	# Get admin user id
	$stmt=db_prep("
		SELECT *
		FROM user u
		WHERE user_admin=1
	");
	$result=db_exec($stmt,array());
	$admin_user_id=$result[0]['user_id'];
	
	# Lets save it as a message in the system
	$stmt=db_prep("
		INSERT INTO user_message
		SET user_message_date=now(),
			user_id=:admin_user_id,
			from_user_id=:user_id,
			user_message_subject=:user_message_subject,
			user_message_text=:user_message_text,
			user_message_read_status=0,
			user_message_status=1
	");
	$result=db_exec($stmt,array(
		"admin_user_id"=>$admin_user_id,
		"user_id"=>$user['user_id'],
		"user_message_subject"=>'Feeback Form Submission',
		"user_message_text"=>$feedback_string
	));
	
	$data=$user;
	$data['feedback_string']=$feedback_string;
	$data['email_address']=$email_address;
	
	send_email('feedback','timtraver@gmail.com',$data);
	user_message("Thank You for your comments and suggestions!");
	return view_home();
}
function forgot() {
	global $smarty;
	# ok, lets present the user with the ability to enter their user name
	$maintpl=find_template("forgot.tpl");
	return $smarty->fetch($maintpl);
}
function forgot_send() {
	global $smarty;
	global $user;

	# ok, lets check to see if they are a user, and send them a password reset email
	$email=$_REQUEST['email'];
	if($email==''){
		user_message("You must enter an email address for the password recovery process.",1);
		return forgot();
	}
	# Lets check if the email address exists
	$stmt=db_prep("
		SELECT *
		FROM user u
		WHERE u.user_email=:email
	");
	$result=db_exec($stmt,array("email"=>$email));
	if(isset($result[0])){
		$recovery=get_user_info($result[0]['user_id']);
	}else{
		user_message("I'm sorry, I do not recognize a user account with that email address.",1);
		return forgot();
	}
	# If it got here, then we need to send the email
	
	$hash=sha1($recovery['user_id'].$recovery['user_name'].$recovery['user_email']);
	$recovery['hash']=$hash;
	
	send_email('password_recovery',$recovery['user_email'],$recovery);
	user_message("A Message has been sent to the email address with instructions on how to reset your password.");
	return view_home();
}
function pass_recovery(){
	# Function to reset the user password 
	global $user;
	global $fsession;
	global $smarty;

	# Lets get the inputted strings from the URL
	$user_id=intval($_REQUEST['user_id']);
	$hash=$_REQUEST['hash'];
	
	$user_info=get_user_info($user_id);
	$compare=sha1($user_id.$user_info['user_name'].$user_info['user_email']);
	
	if($hash!=$compare){
		user_message("I'm sorry, but that does not appear to be a proper email recovery link.",1);
		$user=array();
		return view_home();	
	}
	
	# They have successfully come here to change their password!
	# Show them the change password screen
	$smarty->assign("user_info",$user_info);
	$smarty->assign("hash",$hash);
	$maintpl=find_template("change_password.tpl");
	return $smarty->fetch($maintpl);
}
function pass_recovery_save(){
	# Function to reset the user password 
	global $user;
	global $fsession;
	global $smarty;

	# Lets get the inputted strings from the URL
	$user_id=intval($_REQUEST['user_id']);
	$hash=$_REQUEST['hash'];
	$pass1=$_REQUEST['pass1'];
	$pass2=$_REQUEST['pass2'];
	
	if($pass1!=$pass2){
		user_message("I'm sorry, but the two entered passwords do not match.",1);
		$user=array();
		return pass_recovery();
	}
	$user_info=get_user_info($user_id);
	$compare=sha1($user_id.$user_info['user_name'].$user_info['user_email']);
	
	if($hash!=$compare){
		user_message("I'm sorry, but that does not appear to be a proper email recovery link.",1);
		$user=array();
		return pass_recovery();
	}
	
	# They have successfully come here to change their password!
	# ok, lets change it and then have them logged in
	$stmt=db_prep("
		UPDATE user
		SET user_pass=:pass
		WHERE user_id=:user_id
	");
	$result=db_exec($stmt,array(
		"pass"=>sha1($pass1),
		"user_id"=>$user_id
	));
	user_message("Congratulations! You have updated your password and have been automatically logged in. Enjoy!");
		
	destroy_fsession();
	$path="/";
	$host=$_SERVER['HTTP_HOST'];
	# New session stuff
	create_fsession($path,$host);
	$fsession['auth']=TRUE;
	$fsession['user_id']=$user_info['user_id'];
	$fsession['user_name']=$user_info['user_name'];
	$user=$user_info;
	$smarty->assign("user",$user);
	$GLOBALS['user_id']=$user_info['user_id'];
	save_fsession();
        
	$_REQUEST['action']='main';
	$_REQUEST['function']='view_home';
	return view_home();	
}

?>
