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
	
	# Get the message for the current user
	$stmt=db_prep("
		SELECT *
		FROM user_message um
		LEFT JOIN user u ON um.from_user_id=u.user_id
		WHERE um.user_id=:user_id
		AND um.user_message_status=1
	");
	$messages=db_exec($stmt,array("user_id"=>$GLOBALS['user_id']));
	
	$smarty->assign("messages",$messages);
	$maintpl=find_template("message_list.tpl");
	return $smarty->fetch($maintpl);
}
function message_edit() {
	global $smarty;
	global $user;

	$user_message_id=$_REQUEST['user_message_id'];

	# Get the message info
	$user_message=array();
	if($user_message_id!=0){
		$stmt=db_prep("
			SELECT *
			FROM user_message um
			LEFT JOIN user u ON um.from_user_id=u.user_id
			WHERE um.user_message_id=:user_message_id
		");
		$result=db_exec($stmt,array("user_message_id"=>$user_message_id));
		$user_message=$result[0];
		if($user_message['user_message_read_status']==0){
			# Lets mark it as read now
			$stmt=db_prep("
				UPDATE user_message
				SET user_message_read_status=1
				WHERE user_message_id=:user_message_id
			");
			$result=db_exec($stmt,array("user_message_id"=>$user_message['user_message_id']));
		}
	}
		
	$smarty->assign("user_message",$user_message);
	$maintpl=find_template("message_edit.tpl");
	return $smarty->fetch($maintpl);
}

?>
