<?php
############################################################################
#       security_functions.inc
#
#       Tim Traver
#       6/4/12
#       Miva Merchant, Inc.
#       This is an included bunch of subroutines to handle all the user access security
#
############################################################################

function check_user_function($function){
        # Function to quickly check to see if the function being called is a proper one
        $functions=get_defined_functions();
        if(in_array($function,$functions['user'])){
                return 1;
        }else{
                return 0;
        }
}
function show_no_permission(){
        global $smarty;
        # Function to show that a user does not have permission for this area
        $tpl=find_template("no_permission.tpl");
        return $smarty->fetch($tpl);
}
function check_login () {
    global $fsession;
    global $user;

    # Function to check login against user in the database
    $error=0;
    $errorstring="";
    $encpass='';

    if($_REQUEST['login']=='') {
        $error=1;
        $errorstring="You must enter a login.";
        return array($error,"$errorstring");
    }
    if($_REQUEST['password']=='') {
        $error=1;
        $errorstring="You must enter a password.";
        return array($error,"$errorstring");
    }
    $login=$_REQUEST['login'];
    $password=$_REQUEST['password'];

	$sha1_pass=sha1($password);

    # Let's get the user info to check the pass
    $stmt=db_prep("
        SELECT *
        FROM user u
        WHERE u.user_name=:login
    ");
    $result=db_exec($stmt,array("login"=>$login));
    if(isset($result[0])) {
        $user=$result[0];
        if($user['user_status']==0){
            $error=2;
            $errorstring="User does not currently have access to this site.";
            return array($error,"$errorstring");
        }
        if($sha1_pass!=$user['user_pass']){
        	$error=2;
        	$errorstring="User password is not correct. Please try again or use the forgot password link.";
			return array($error,"$errorstring");
        }
    }else{
		$error=2;
		$errorstring="User does not currently have a login. Please register with us!";
		return array($error,"$errorstring");
    }

    $path="/";
    $host=$_SERVER['HTTP_HOST'];
    # New session stuff
    create_fsession($path,$host);
    $fsession['auth']=TRUE;
    $fsession['user_id']=$user['user_id'];
    $fsession['user_name']=$user['user_name'];

    save_fsession();
    return array($error,"$errorstring");
}
function get_user_info($user_parameter){
        # $user_parameter cna be either user_id (int) or user_name (string)
        # Function to get all of the user info, including permissions
        $user=array();

        # Lets see if what was passed was a user_id or a user_name
        if(preg_match("/^\d+$/",$user_parameter)){
                $user_id=$user_parameter;
        }else{
                $user_id=0;
        }
        # Now get the base user info
        if($user_id!=0){
                $stmt=db_prep("
                        SELECT *
                        FROM user u
                        LEFT JOIN pilot p ON u.pilot_id=p.pilot_id
                        WHERE u.user_id=:user_id
                ");
                $result=db_exec($stmt,array("user_id"=>$user_id));
        }else{
                $stmt=db_prep("
                        SELECT *
                        FROM user u
                        LEFT JOIN pilot p ON u.pilot_id=p.pilot_id
                        WHERE u.user_name=:user_name
                ");
                $result=db_exec($stmt,array("user_name"=>$user_parameter));
        }
        if($result){
                # Get the user groups and permissions
                foreach($result[0] as $key=>$value){
                        $user[$key]=$value;
                }
        }
        return $user;
}
function check_event_permission($event_id){
	global $user;
	# Function to check to see if this user can edit this event
	# First check if its an administrator
	if($user['user_admin']){
		return 1;
	}
	# Get event info
	$stmt=db_prep("
		SELECT *
		FROM event
		WHERE event_id=:event_id
	");
	$result=db_exec($stmt,array("event_id"=>$event_id));
	$event=$result[0];
	if($event['pilot_id']==$user['pilot_id'] || $event['event_cd']==$user['pilot_id']){
		# This is the owner of the event, so of course he has access
		return 1;
	}
	
	$allowed=0;
	# Now lets get the other permissions
	$stmt=db_prep("
		SELECT *
		FROM event_user
		WHERE event_id=:event_id
			AND event_user_status=1
	");
	$users=db_exec($stmt,array("event_id"=>$event_id));
	foreach($users as $u){
		if($user['pilot_id']==$u['pilot_id']){
			$allowed=1;
		}
	}
	return $allowed;
}



?>
