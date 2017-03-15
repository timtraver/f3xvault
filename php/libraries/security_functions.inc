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
	$functions = get_defined_functions();
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
    $error = 0;
    $errorstring = "";
    $encpass = '';

    if($_REQUEST['login'] == '') {
        $error = 1;
        $errorstring = "You must enter a login.";
        return array($error,"$errorstring");
    }
    if($_REQUEST['password'] == '') {
        $error = 1;
        $errorstring = "You must enter a password.";
        return array($error,"$errorstring");
    }
    $login = $_REQUEST['login'];
    $password = $_REQUEST['password'];

	$sha1_pass = sha1($password);

    # Let's get the user info to check the pass
    $stmt = db_prep("
        SELECT *
        FROM user u
        WHERE u.user_name =:login
        	OR u.user_email =:login2
    ");
    $result = db_exec($stmt,array("login" => $login,"login2" => $login));
    if(isset($result[0])) {
        $user = $result[0];
        if($user['user_status'] == 0){
            $error = 2;
            $errorstring = "User does not currently have access to this site.";
            return array($error,"$errorstring");
        }
        if($sha1_pass != $user['user_pass']){
        	$error = 2;
        	$errorstring = "User password is not correct. Please try again or use the forgot password link.";
			return array($error,"$errorstring");
        }
    }else{
		$error = 2;
		$errorstring = "User does not currently have a login. Please register with us!";
		return array($error,"$errorstring");
    }

    $path = "/";
    $host = $_SERVER['HTTP_HOST'];
    # New session stuff
    create_fsession($path,$host);
    $fsession['auth'] = TRUE;
    $fsession['user_id'] = $user['user_id'];
    $fsession['user_name'] = $user['user_name'];

    save_fsession();
    return array($error,"$errorstring");
}
function get_user_info($user_parameter){
    # $user_parameter can be either user_id (int) or user_name (string)
    # Function to get all of the user info, including permissions
    $user = array();

    # Lets see if what was passed was a user_id or a user_name
    if(preg_match("/^\d+$/",$user_parameter)){
		$user_id = $user_parameter;
    }else{
		$user_id = 0;
    }
    # Now get the base user info
    if($user_id != 0){
        $stmt = db_prep("
            SELECT *
            FROM user u
            LEFT JOIN pilot p ON u.pilot_id = p.pilot_id
            LEFT JOIN state s ON p.state_id = s.state_id
            LEFT JOIN country c ON p.country_id = c.country_id
            WHERE u.user_id =:user_id
        ");
        $result = db_exec($stmt,array("user_id" => $user_id));
    }else{
        $stmt = db_prep("
            SELECT *
            FROM user u
            LEFT JOIN pilot p ON u.pilot_id = p.pilot_id
            LEFT JOIN state s ON p.state_id = s.state_id
            LEFT JOIN country c ON p.country_id = c.country_id
            WHERE u.user_name =:user_name
            	OR u.user_email =:email
        ");
        $result = db_exec($stmt,array("user_name" => $user_parameter,"email" => $user_parameter));
    }
    if($result){
        # Get the user groups and permissions
        foreach($result[0] as $key => $value){
			$user[$key] = $value;
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
	$stmt = db_prep("
		SELECT *
		FROM event
		WHERE event_id=:event_id
	");
	$result = db_exec($stmt,array("event_id"=>$event_id));
	$event = $result[0];
	if($event['pilot_id'] == $user['pilot_id'] || $event['event_cd'] == $user['pilot_id']){
		# This is the owner of the event, so of course he has access
		return 1;
	}
	
	$allowed = 0;
	# Now lets get the other permissions
	$stmt = db_prep("
		SELECT *
		FROM event_user
		WHERE event_id =:event_id
			AND event_user_status = 1
	");
	$users = db_exec($stmt,array("event_id" => $event_id));
	foreach($users as $u){
		if($user['pilot_id'] == $u['pilot_id']){
			$allowed = 1;
		}
	}
	return $allowed;
}

# Cleaning functions
function input_filter($value,$type){
	# Input filter to clean input variables and return the value
	# Types are the following
	# 'int' - integer
	# 'float' - floating point number
	# 'string' - varchar string
	# 'string_lower' - varchar string converted to lowercase
	# 'string_ul' - varchar string converted to uppercase and lowercase words
	# 'text' - textarea field
	# 'boolean' - convert from 'on' or 'off' or 1 and 0
	# 'url' - removes all characters except letters, digits, and $-_.+!*'(),{}|\\^~[]`<>#%";/?:@&=.
	# 'host' - removes all characters except letters, digits, and -.
	# 'encode' - urlencodes a string
	$value = trim($value);
	switch($type){
		case 'int':
			if($value == '' || is_null($value)){
				$value = 0;
			}
			$return_value = intval($value);
			break;
		case 'float':
			if($value == '' || is_null($value)){
				$value = 0;
			}
			$return_value = filter_var($value,FILTER_SANITIZE_NUMBER_FLOAT,FILTER_FLAG_ALLOW_FRACTION);
			break;
		case 'string':
			if(is_null($value)){
				$value = '';
			}
			$return_value = $value;
			break;
		case 'string_lower':
			if(is_null($value)){
				$value = '';
			}
			$return_value = strtolower($value);
			break;
		case 'string_ul':
			if(is_null($value)){
				$value = '';
			}
			$return_value = ucwords($value);
			break;
		case 'text':
			if(is_null($value)){
				$value = '';
			}
			$return_value = $value;
			break;
		case 'boolean':
			if($value == '' || is_null($value)){
				$value = 0;
			}
			if(filter_var($value,FILTER_VALIDATE_BOOLEAN)){
				$return_value = 1;
			}else{
				$return_value = 0;
			}
			break;
		case 'url':
			$return_value = filter_var($value,FILTER_SANITIZE_URL);
			break;
		case 'host':
			$return_value = preg_replace("/[^A-Za-z0-9\-\.]/",'',$value);
			break;
		case 'encode':
			$return_value = filter_var($value,FILTER_SANITIZE_ENCODED);
			break;
		default:
			$return_value = $value;
	}
	return $return_value;
}
function input_validate($value,$type){
	# Function to check if a given value is in a proper format
	# Types are the following
	# 'email' - email address
	# 'ip' - IP address
	$value = trim($value);
	switch($type){
		case 'email':
			if(filter_var($value,FILTER_VALIDATE_EMAIL)){
				$return_value = 1;
			}else{
				$return_value = 0;
			}
			break;
		case 'ip':
			if(filter_var($value,FILTER_VALIDATE_IP)){
				$return_value = 1;
			}else{
				$return_value = 0;
			}
			break;
		default:
			$return_value = 0;
	}
	return $return_value;
}

?>