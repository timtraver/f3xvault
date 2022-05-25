<?php
############################################################################
#       event_message.php
#
#       Tim Traver
#       3/19/13
#       This is the script to show individual messages
#
############################################################################
$smarty->assign("current_menu",'events');

include_library("event.class");

# This whole section requires the user to be logged in
if($GLOBALS['user_id'] == 0){
	# The user is not logged in, so send the feature template
	user_message("Sorry, but you must be logged in as a user to use this feature.",1);
	$smarty->assign("redirect_action",$_REQUEST['action']);
	$smarty->assign("redirect_function",$_REQUEST['function']);
	$smarty->assign("request",$_REQUEST);
	$maintpl = find_template("feature_requires_login.tpl");
	$actionoutput = $smarty->fetch($maintpl);
}else{
	if(isset($_REQUEST['function']) && $_REQUEST['function'] != '') {
        $function = $_REQUEST['function'];
	}else{
        $function = "message_list";
	}
	if(check_user_function($function)){
        eval("\$actionoutput = $function();");
	}
}

function event_message_send() {
	global $smarty;
	global $user;
	global $template_dir;
	global $compile_dir;

	$event_id = intval( $_REQUEST['event_id'] );
	$message_subject = input_filter( $_REQUEST['message_subject'], 'string');
	$message_from = input_filter( $_REQUEST['message_from'], 'boolean');
	$from_email_address = input_filter( $_REQUEST['from_email_address'], 'string');
	$message_body = input_filter( $_REQUEST['message_body'], 'string');
	$to = input_filter( $_REQUEST['to'], 'string');
	$save = intval( $_REQUEST['save'] );
	
	if( $event_id == 0 ){
		# Return to event
		include( $GLOBALS['scripts_dir'] . "/event.php" );
		event_list();
		return;
	}

	# Get recipient pilots list entries
	$recipients = array();
	foreach( $_REQUEST as $key => $value ){
		if( preg_match( "/pilot_(\d+)/", $key, $m ) ){
			$id = input_filter($m[1], 'int');
			$recipients[] = $id;
		}
	}
	# lets get the event info so we have access to the pilot list
	$event = new Event( $event_id );
	$event->get_event_users();
	$event->get_teams();

	# Get classes to choose to be available for this event
	$stmt = db_prep("
		SELECT *,c.class_id
		FROM event_class ec
		LEFT JOIN class c ON ec.class_id = c.class_id
		WHERE ec.event_id = :event_id
		ORDER BY c.class_view_order
	");
	$classes = db_exec($stmt,array("event_id" => $event_id));
	$smarty->assign("classes",$classes);

	if( $save == 1 ){
		# Do sanity checks and then send the messages
		if( $message_subject == '' || $message_body == ''){
			user_message("You must enter a subject and body for your message.", 1);
			$_REQUEST['save'] = 0;
			return event_message_send();
		}
		if( $message_from == 0 ){
			$email_from = $user['user_email'];
		}else{
			if( $from_email_address != '' || ! filter_var( $from_email_address, FILTER_VALIDATE_EMAIL ) ){
				$email_from = $from_email_address;
			}else{
				user_message("You must enter a subject and body for your message.", 1);
				$_REQUEST['save'] = 0;
				return event_message_send();
			}
		}
		# check that there are recipients
		if( ! $recipients ){
			user_message("You must select recipients for your message.", 1);
			$_REQUEST['save'] = 0;
			return event_message_send();
		}
		# Check recaptcha
		include_library("recaptchalib.php");
		$recaptcha_secret = $GLOBALS['recaptcha_secret'];
		
		# Check recaptcha entered
		$reCaptcha = new ReCaptcha( $recaptcha_secret );
		if( $_POST["g-recaptcha-response"] ){
			$response = $reCaptcha->verifyResponse(
				$_SERVER["REMOTE_ADDR"],
				$_POST["g-recaptcha-response"]
			);
			if( $response != null && $response->success ){
				# Successful, so let it fall through
			}else{
				user_message("Recaptcha not checked.", 1);
				$_REQUEST['save'] = 0;
				return event_message_send();
			}
		}else{
			user_message("Recaptcha not checked.", 1);
			$_REQUEST['save'] = 0;
			return event_message_send();
		}
		# If we got here, then send the email
		$already_sent = array();
		foreach( $recipients as $pilot_id ){
			$stmt = db_prep( "
				SELECT *
				FROM pilot
				WHERE pilot_id = :pilot_id
			" );
			$result = db_exec( $stmt, array( "pilot_id" => $pilot_id ) );
			if( count($result) > 0){
				$pilot = $result[0];
			}else{
				continue;
			}
			if( $pilot['pilot_email'] == '' ){
				user_message( "Pilot " . $pilot['pilot_first_name'] . " " . $pilot['pilot_last_name'] . " does not have an email address. Not Sent.", 1);
			}else{
				if( in_array( $pilot['pilot_email'], $already_sent ) ){ continue; }
				
				# Send the email to this pilot
				$smarty1=new Smarty;
				$smarty1->template_dir = $template_dir;
				$smarty1->compile_dir = $compile_dir;
				$smarty1->compile_check = false;
				$smarty1->auto_literal = false;
				$smarty1->debugging = false;
				
				# Get parameters to include in templates
				# Get event_pilot_id
				$stmt = db_prep( "
					SELECT *
					FROM event_pilot
					WHERE event_id = :event_id
						AND pilot_id = :pilot_id
				" );
				$result = db_exec( $stmt, array(
					"event_id" => $event_id,
					"pilot_id" => $pilot['pilot_id']
				) );
				if( isset( $result[0] ) ){
					$amount_due = calculate_amount_owed( $result[0]['event_pilot_id'] );
					$smarty1->assign( "amount_due", $amount_due );
				}
				
				$smarty1->assign( "pilot_first_name", $pilot['pilot_first_name'] );
				$smarty1->assign( "pilot_last_name", $pilot['pilot_last_name'] );
				
				# Set event info that can be used in the template text
				$smarty1->assign( "event_id", $event_id );
				$smarty1->assign( "event_name", $event->info['event_name'] );
				$smarty1->assign( "event_start_date", $event->info['event_start_date'] );
				$smarty1->assign( "location_name", $event->info['location_name'] );
				$smarty1->assign( "event_type_name", $event->info['event_type_name'] );
				$smarty1->assign( "event", $event );
				
				# Send the email
				include_library('PHPMailer/PHPMailerAutoload.php');
				$mail=new PHPMailer();
				
				# Replace any tokens in the content
				$subject = $smarty1->fetch('string:'.$message_subject);
				$body = $smarty1->fetch('string:'.$message_body);
				
				$mail->isSMTP();
				$mail->Host = 'localhost';
				$mail->SMTPAuth = false;
				$mail->Port = 25;
				
				$mail->setFrom( "notifications@f3xvault.com",  "F3XVault Notifications" );
				if( $message_from == 1 ){
					$mail->addReplyTo( $email_from );
				}
				$mail->isHTML(true);
				$mail->CharSet = 'UTF-8';
				
				$mail->Subject = $subject;
				$mail->Body = $body;
				
				$mail->addAddress( $pilot['pilot_email'] );
				$mail->addBCC("timtraver@gmail.com");
				
				# Send the email
				try {
					$mail->send();
					$sent_to .= $pilot['pilot_first_name'] . " " . $pilot['pilot_last_name'] . "<br>";
				} catch (phpmailerException $e) {
					throw $e;
					error_log("Unable to send to: " . $to . ': ' . $e->getMessage(), 0);
					user_message( "Pilot " . $pilot['pilot_first_name'] . " " . $pilot['pilot_last_name'] . " message error and not sent.", 1);
				}
				$already_sent[] = $pilot['pilot_email'];
				
				# Now let us save the message in the messages area
				# Lets get the to user info
				$to = array();
				$stmt = db_prep("
					SELECT *
					FROM user u
					LEFT JOIN pilot p ON u.user_id = p.user_id
					WHERE u.pilot_id = :pilot_id
				");
				$result = db_exec($stmt,array("pilot_id" => $pilot['pilot_id']));
				if(isset($result[0])){
					$to = $result[0];
				}
				if( $to ){
					# Lets save it as a message in the system
					$stmt = db_prep("
						INSERT INTO user_message
						SET user_message_date = now(),
							user_id = :to_user_id,
							from_user_id = :user_id,
							user_message_subject = :user_message_subject,
							user_message_text = :user_message_text,
							user_message_read_status = 0,
							user_message_status = 1
					");
					$result = db_exec($stmt,array(
						"to_user_id"			=> $to['user_id'],
						"user_id"				=> $user['user_id'],
						"user_message_subject"	=> $subject,
						"user_message_text"		=> strip_tags($body)
					));
				}
			}
		}
		user_message( "Messages sent to : <br>" . $sent_to );
		# clear submit vars now
		$message_subject = '';
		$message_body = '';
		unset( $_REQUEST['message_subject'] );
		unset( $_REQUEST['message_body'] );
		foreach( $recipients as $r ){
			unset( $_REQUEST['pilot_'.$r] );
		}
		$recipients = array();
	}
	# Lets determine if the user is already registered as a pilot in this event
	$pilot_id = $GLOBALS['user']['pilot_id'];
	$registered = 0;
	foreach($event->pilots as $p){
		if($p['pilot_id'] == $user['pilot_id']){
			$registered = 1;
		}
	}
	$smarty->assign("registered",$registered);

	$permission = check_event_permission($event_id);
	$smarty->assign("permission",$permission);
	$smarty->assign("event",$event);
	$smarty->assign("message_subject",$message_subject);
	$smarty->assign("message_from",$message_from);
	$smarty->assign("from_email_address",$from_email_address);
	$smarty->assign("message_body",$message_body);
	$smarty->assign("recipients",$recipients);
	$smarty->assign("to",$to);
	$smarty->assign("recaptcha_key",$GLOBALS['recaptcha_key']);
	$maintpl = find_template("event/event_message.tpl");
	return $smarty->fetch($maintpl);
}

?>