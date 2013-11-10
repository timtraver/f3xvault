<?php
############################################################################
#       messages.php
#
#       Tim Traver
#       3/19/13
#       This is the script to show individual messages
#
############################################################################
$GLOBALS['current_menu']='message';

# This whole section requires the user to be logged in
if($GLOBALS['user_id']==0){
	# The user is not logged in, so send the feature template
	$maintpl=find_template("feature_requires_login.tpl");
	$actionoutput=$smarty->fetch($maintpl);
}else{
	if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
        $function=$_REQUEST['function'];
	}else{
        $function="message_list";
	}
	if(check_user_function($function)){
        eval("\$actionoutput=$function();");
	}
}

function message_list() {
	global $user;
	global $smarty;
	
	$message_box='incoming';
	if(isset($_REQUEST['message_box'])){
		$message_box=$_REQUEST['message_box'];
	}elseif(isset($GLOBALS['fsession']['message_box'])){
		$message_box=$GLOBALS['fsession']['message_box'];
	}
	$GLOBALS['fsession']['message_box']=$message_box;
	switch($message_box){
		case "sent":
			$show_sent=1;
			break;
		case "incoming":
		default:
			$show_sent=0;
			break;
	}
	$messages=array();
	if($show_sent==0){
		# Get the messages for the current user
		$stmt=db_prep("
			SELECT *
			FROM user_message um
			LEFT JOIN user u ON um.from_user_id=u.user_id
			WHERE um.user_id=:user_id
			AND um.user_message_status=1
			ORDER BY user_message_date DESC
		");
		$user_messages=db_exec($stmt,array("user_id"=>$GLOBALS['user_id']));
	}else{
		# Get the sent messages
		$stmt=db_prep("
			SELECT *,um.user_id
			FROM user_message um
			LEFT JOIN user u ON um.user_id=u.user_id
			WHERE um.from_user_id=:user_id
			AND um.user_message_status=1
			ORDER BY user_message_date DESC
		");
		$user_messages=db_exec($stmt,array("user_id"=>$GLOBALS['user_id']));
	}
	
	$user_messages=show_pages($user_messages,25);
	
	$smarty->assign("message_box",$message_box);
	$smarty->assign("user_messages",$user_messages);
	$maintpl=find_template("message_list.tpl");
	return $smarty->fetch($maintpl);
}
function message_edit() {
	global $smarty;
	global $user;

	$user_message_id=$_REQUEST['user_message_id'];
	$reply=0;
	if(isset($_REQUEST['reply'])){
		$reply=intval($_REQUEST['reply']);
	}
	# Get the message info
	$user_message=array();
	if($user_message_id!=0){
		$stmt=db_prep("
			SELECT *,um.user_id
			FROM user_message um
			LEFT JOIN user u ON um.from_user_id=u.user_id
			WHERE um.user_message_id=:user_message_id
		");
		$result=db_exec($stmt,array("user_message_id"=>$user_message_id));
		$user_message=$result[0];
		$user_message['to']=get_user_info($user_message['user_id']);
		$user_message['from']=get_user_info($user_message['from_user_id']);
		
		if($user_message['user_message_read_status']==0 && $user_message['user_id']==$user['user_id']){
			# We are the intended recipient, so lets mark it as read now
			$stmt=db_prep("
				UPDATE user_message
				SET user_message_read_status=1
				WHERE user_message_id=:user_message_id
			");
			$result=db_exec($stmt,array("user_message_id"=>$user_message['user_message_id']));
		}
		if($reply==1){
			# Swap the to and from
			$from=$user['user_id'];
			$to=$user_message['from_user_id'];
			$stmt=db_prep("
				SELECT *
				FROM user u
				LEFT JOIN pilot p ON u.pilot_id=p.pilot_id
				WHERE u.user_id=:user_id
			");
			$result=db_exec($stmt,array("user_id"=>$to));
			$user_to=$result[0];
			
			$user_message['to']=get_user_info($to);
			$user_message['from']=get_user_info($from);
			
			# Now lets set the default values for the new message
			$user_message['user_message_id']=0;
			$user_message['to_user_id']=$to;
			$user_message['user_message_subject']='RE: '.$user_message['user_message_subject'];
			$user_message['user_message_text']="\n\n\n>".preg_replace("/\n/","\n>",$user_message['user_message_text']);
			
			$smarty->assign("reply",$reply);
		}
	}else{
		if(isset($_REQUEST['to_user_id'])){
			$user_message['to_user_id']=$_REQUEST['to_user_id'];
			$user_message['to']=get_user_info($_REQUEST['to_user_id']);
		}
		if(isset($_REQUEST['user_message_subject'])){
			$user_message['user_message_subject']=$_REQUEST['user_message_subject'];
		}
	}
		
	$smarty->assign("user_message",$user_message);
	$maintpl=find_template("message_edit.tpl");
	return $smarty->fetch($maintpl);
}
function message_save() {
	global $smarty;
	global $user;
	
	$user_message_id=intval($_REQUEST['user_message_id']);
	$to_user_id=intval($_REQUEST['to_user_id']);
	$user_message_subject=$_REQUEST['user_message_subject'];
	$user_message_text=$_REQUEST['user_message_text'];

	if(!isset($_REQUEST['to_user_id']) || $_REQUEST['to_user_id']==0){
		user_message("You must select a correct recipient for your message.");
		return message_edit();
	}
	# Lets get the to info
	$stmt=db_prep("
		SELECT *
		FROM user u
		LEFT JOIN pilot p ON u.user_id=p.user_id
		WHERE u.user_id=:to_user_id
	");
	$result=db_exec($stmt,array("to_user_id"=>$to_user_id));
	if(isset($result[0])){
		$to=$result[0];
	}else{
		user_message("You must select a correct recipient for your message.");
		return message_edit();
	}
	
	# Lets save it as a message in the system
	$stmt=db_prep("
		INSERT INTO user_message
		SET user_message_date=now(),
			user_id=:to_user_id,
			from_user_id=:user_id,
			user_message_subject=:user_message_subject,
			user_message_text=:user_message_text,
			user_message_read_status=0,
			user_message_status=1
	");
	$result=db_exec($stmt,array(
		"to_user_id"=>$to_user_id,
		"user_id"=>$user['user_id'],
		"user_message_subject"=>$user_message_subject,
		"user_message_text"=>$user_message_text
	));
	
	$data['from_name']=$user['user_first_name'].' '.$user['user_last_name'];
	$data['user_message_subject']=$user_message_subject;
	$data['user_message_text']=$user_message_text;
	
	send_email('message_notification',array($to['user_email']),$data);
	user_message("Message has been sent!");
	return message_list();
}
function message_delete() {
	global $smarty;
	global $user;
	
	# Lets go through the submitted message selections and turn them off
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^message\_(\d+)/",$key,$match)){
			$user_message_id=$match[1];
			if($value=='on'){
				# Turn off message
				$stmt=db_prep("
					UPDATE user_message
					SET user_message_status=0
					WHERE user_message_id=:user_message_id
				");
				$result=db_exec($stmt,array(
					"user_message_id"=>$user_message_id
				));
			}
		}
	}
	user_message("Messages have been removed!");
	return message_list();
}

?>
