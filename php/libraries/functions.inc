<?php
############################################################################
#       functions.inc
#
#       Tim Traver
#       5/21/12
#       This is an included bunch of subroutines to perform miscellaneous
#       functions.
#
############################################################################
global $admin_pass;

function strip_input($input) {
        # Function to strip any potential damaging characters from web input
        $input=strip_tags($input);
        $input=preg_replace("/\</","",$input);
        $input=preg_replace("/\>/","",$input);
        $input=trim($input);
        return $input;
}
function prep_data_int($input){
        # Function to prepare int data for input into mysql database
        $input=intval($input);
        return $input;
}
function prep_data_float($input){
        # Function to prepare float data for input into mysql database
        $input=floatval($input);
        return $input;
}
function prep_data_string($input){
        # Function to prepare string data for input into mysql database
        if(is_resource($GLOBALS['db_link'])){
                $input=mysql_real_escape_string($input,$GLOBALS['db_link']);
        }else{
                $input=mysql_escape_string($input);
        }
        return $input;
}
function clean_input() {
        # Function to strip damaging info from input variables
        # Now look at each of the request variables
        foreach($_REQUEST as $key=>$value) {
                if(is_array($value)){
                        foreach($value as $key2=>$value2){
                                $value[$key2]=strip_input($value2);
                        }
                        $_REQUEST[$key]=$value;
                }else{
                        if(! strstr($key,"file_")){
                                # This excludes those fields that start with file_ so we can edit html files
                                if(preg_match("/\S+\_id$/",$key)){
                                        $_REQUEST[$key]=intval($_REQUEST[$key]);
                                }else{
                                        $_REQUEST[$key]=strip_input($_REQUEST[$key]);
                                }
                        }
                }
        }
}
function start_smarty () {
	# Function to start the smarty template engine
	global $smarty;
	global $template_dir;
	global $compile_dir;

	$smarty=new Smarty;
	$smarty->template_dir = $template_dir;
	$smarty->compile_dir = $compile_dir;
	$smarty->compile_check = true;
	$smarty->auto_literal = false;
	$smarty->setDebugging(DEBUG);
	$smarty->debug_tpl = $template_dir.'/debug.tpl'; // requires a full path

	if (DEBUG && isset($GLOBALS['debugLogger'])) {
		$smarty->assign('debugLogger', $GLOBALS['debugLogger']);
	}
	return;
}
function find_template ($input) {
        # Function to find the reseller template or return the default
        $templatedir="{$GLOBALS['template_dir']}";
        return "$input";
}
function find_script ($input,$reseller_id){
        # Function to find the user script for a particular reseller
        $templatedir="{$GLOBALS['template_dir']}";
        return "$templatedir/user_scripts/$input";
}
function db_prep ($querystring) {
        # Function to wrap queries with error functionality
        global $admin_pass;
        global $dbh;

		# Let's determine if we are local or not
		$login = $GLOBALS['database_user'];
        $host = $GLOBALS['database_host'];
        $dbname = $GLOBALS['database_name'];
        if($admin_pass==''){
                $admin_pass = $GLOBALS['database_pass'];
        }
        try {
                $dbh=new PDO("mysql:host=$host;dbname=$dbname;charset=utf8",$login,$admin_pass,array(PDO::ATTR_PERSISTENT=> false,'log' => isset($GLOBALS['debugLogger']) && $GLOBALS['debugLogger'] instanceof DebugLogger ? $GLOBALS['debugLogger'] : null));
                $dbh->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
                $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                $stmt = $dbh->prepare($querystring);
        } catch (PDOException $e) {
                $errorstring=$e->getMessage();
                query_error($querystring,array(),$errorstring);
        }
        return $stmt;
}
function db_exec ($stmt,$data=array()) {
        global $dbh;
        global $last_insert_id;
        global $total_queries;

		# Set the default type of return
		if(preg_match("/SELECT/i",$stmt->queryString)){
			$results=array();
		}else{
			$results=0;
		}

        # Function to wrap the query execution
        try {
			$start = microtime(true);
	        $stmt->execute($data);
			$diff = microtime(true) - $start;
			
			if(isset($GLOBALS['debugLogger']) && $GLOBALS['debugLogger'] instanceof DebugLogger){
				$GLOBALS['debugLogger']->logQuery($stmt,$data, $diff);
			}
			
	        if(preg_match("/UPDATE/i",$stmt->queryString) || preg_match("/DELETE/i",$stmt->queryString)){
				$results=$stmt->rowCount();
	        }elseif(preg_match("/INSERT/i",$stmt->queryString)){
				$results=$dbh->lastInsertId();
	        }elseif(preg_match("/SELECT/i",$stmt->queryString)){
				$results=$stmt->fetchAll(PDO::FETCH_ASSOC);
	        }
        } catch (PDOException $e) {
			$string=$e->getMessage();
			query_error($stmt->queryString,$data,$string);
        }
        $last_insert_id=$dbh->lastInsertId();
        $total_queries++;
        return $results;
}
function query_error($query,$data,$error){
        # Function to write out the error
        $queryerrorfile="{$GLOBALS['include_paths']['libraries']}/query_errors.log";

        # An error has occurred
        $errorstring='';
        $errorfile=fopen($queryerrorfile,"a");
        $datetime=date("M d,y H:i:s");
        $errorstring.="----------------------------------------------------------\n";
        $errorstring.="QUERY ERROR - $datetime\n";
        $errorstring.="APP     : {$GLOBALS['current_app']}\n";
        $errorstring.="USER    : {$GLOBALS['user_name']}\n";
        $errorstring.="FUNCTION: {$_REQUEST['function']}\n";
        $errorstring.="TRACE   : ";
        $debug=debug_backtrace();
        $tracestring='';
        $space=0;
        foreach($debug AS $key=>$value){
                $value['file']=basename($value['file']);
                if($space){
                $tracestring.="         ->";
                }else{
                        $tracestring.="->";
                        $space=1;
                }
                $tracestring.=" {$value['file']}(line {$value['line']} in {$value['function']})\n";
        }
        $errorstring.=$tracestring;
        $errorstring.="STRING  : $query\n";
        $errorstring.="ERROR   : $error\n";
        $errorstring.="Data    : \n";
        foreach($data as $key=>$value){
	        $errorstring.="        : $key -> $value\n";
        }
        $errorstring.="_REQUEST: \n";
        foreach($_REQUEST as $key=>$value){
                $errorstring.="        : $key -> $value\n";
        }
        $errorstring.="----------------------------------------------------------\n";
        fwrite($errorfile,$errorstring);
        fclose($errorfile);
        $txt_error= "Query Error:\n";
        $txt_error.="App : {$GLOBALS['current_app']}\n";
        $txt_error.="User: {$GLOBALS['user_name']}\n";
        $txt_error.="Func: {$_REQUEST['function']}\n";
        $txt_error.="Err : $error\n";

        # OK, now send an email to the admin about it
#       include_library('smarty/libs/Smarty.class.php');
#       include_library('mailfunctions.inc');
#       $smarty=new Smarty();
#       $smarty->template_dir = "{$GLOBALS['template_dir']}";
#       $smarty->compile_dir = "{$GLOBALS['compile_dir']}";
#       $smarty->compile_id = $GLOBALS['reseller_id'];
#       $smarty->compile_check = false;
#       $smarty->assign("subject","Query Error");
#       $smarty->assign("message",$errorstring);
#       #send_email($smarty,'error_generic',"tt@simplenet.com");
#       # Send text message about it
#       $smarty->assign("message",$txt_error);
#       #send_email($smarty,'error_generic',"tt-txt@simplenet.com");
}

function encrypt ($input) {
        $input=trim($input);
        # Function to encrypt data for entry into the database
        $key=file_get_contents("{$GLOBALS['include_paths']['libraries']}/phrase");
        $resource=mcrypt_module_open(MCRYPT_RIJNDAEL_256,'','cbc','');
        $iv = mcrypt_create_iv (mcrypt_enc_get_iv_size ($resource), MCRYPT_RAND);
        mcrypt_generic_init ($resource, $key, $iv);
        $output=mcrypt_generic($resource,$input);
        mcrypt_generic_deinit ($resource);
        mcrypt_module_close ($resource);
        $output=base64_encode($iv . $output);
        return $output;
}
function decrypt ($input) {
        # Function to decrypt data
        $input=base64_decode($input);
        $key=file_get_contents("{$GLOBALS['include_paths']['libraries']}/phrase");
        $resource=mcrypt_module_open(MCRYPT_RIJNDAEL_256,'','cbc','');
        $iv = substr($input,0,32);
        mcrypt_generic_init ($resource, $key, $iv);
        $output=mdecrypt_generic($resource,substr($input,32,strlen($input)-32));
        mcrypt_generic_deinit ($resource);
        mcrypt_module_close ($resource);
        $output=trim($output);
        return $output;
}
function show_pages($records,$callback,$label='main'){
	# This is a function to do all of the paging work for showing long lists of records
	global $smarty;

	# Get input variables if they exist
	if(isset($_REQUEST['page'])){
		$page=intval($_REQUEST['page']);
	}else{
		$page=1;
	}
	if($page==0){
		$page=1;
	}
	if(isset($_REQUEST['perpage'])){
		$perpage=$_REQUEST['perpage'];
		if($perpage!='all'){
			$perpage=intval($_REQUEST['perpage']);
		}
	}else{
		if(isset($GLOBALS['fsession']['perpage'])){
			$perpage=$GLOBALS['fsession']['perpage'];
			if($perpage<$defaultperpage){
				$perpage=$defaultperpage;
			}
		}else{
			$perpage=25;
		}
	}
	if($perpage!='all'){
		$GLOBALS['fsession']['perpage']=$perpage;
	}
	# Now calculate some totals
	$totalrecords=count($records);

	if($perpage=='all'){
		$startrecord=0;
		$endrecord=$totalrecords;
		$prevpage=1;
		$nextpage=1;
		$totalpages=1;
		$page=1;
		$showrecords=$records;
	}else{
		$totalpages=intval(ceil($totalrecords/$perpage));
		if($page>$totalpages){
			$page=$totalpages;
		}
		$startrecord=$page*$perpage - ($perpage)+1;
		if($startrecord<0){
			$startrecord=0;
		}
		$endrecord=$startrecord+$perpage -1;
		if($endrecord>=$totalrecords){
			$endrecord=$totalrecords;
		}
		$prevpage=$page-1;
		$nextpage=$page+1;
		if($prevpage<1){
			$prevpage=1;
		}
		if($nextpage>$totalpages){
			$nextpage=$totalpages;
		}

		# OK, now narrow the array down to the records we want to see only
		$showrecords=array();
		foreach($records as $key=>$value){
			if($key >= ($startrecord-1) && $key <= ($endrecord-1)){
				$showrecords[]=$value;
			}
		}
	}
	$paging[$label]['totalrecords']=$totalrecords;
	$paging[$label]['totalpages']=$totalpages;
	$paging[$label]['prevpage']=$prevpage;
	$paging[$label]['nextpage']=$nextpage;
	$paging[$label]['startrecord']=$startrecord;
	$paging[$label]['endrecord']=$endrecord;
	$paging[$label]['page']=$page;
	$paging[$label]['perpage']=$perpage;
	$paging[$label]['callback']=$callback;
	if($smarty->getTemplateVars('paging')){
		$paging1 = $smarty->getTemplateVars('paging');
		$smarty->assign("paging",array_merge($paging,$paging1));
	}else{
		$smarty->assign("paging",$paging);
	}
	if($label == 'main'){
		# If it main, then spit out the regular variables by themselves
		$smarty->assign('totalrecords',$totalrecords);
		$smarty->assign('totalpages',$totalpages);
		$smarty->assign('prevpage',$prevpage);
		$smarty->assign('nextpage',$nextpage);
		$smarty->assign('startrecord',$startrecord);
		$smarty->assign('endrecord',$endrecord);
		$smarty->assign('page',$page);
		$smarty->assign('perpage',$perpage);
		$smarty->assign('callback',$callback);
	}
	return $showrecords;
}
function user_log($type,$log_string){
        global $user;
        # Function to log a users activity
        # Find the type record
        $stmt=db_prep("
                SELECT *
                FROM user_log_type
                WHERE user_log_type_name=:user_log_type_name
        ");
        $result=db_exec($stmt,array("user_log_type_name"=>$type));
        if(isset($result[0])){
                $user_log_type_id=$result[0]['user_log_type_id'];
        }else{
                $user_log_type_id=0;
        }
        # Create the log entry
        $stmt=db_prep("
                INSERT INTO user_log
                SET user_id=:user_id,
                        user_log_type_id=:user_log_type_id,
                        user_log_date=now(),
                        user_log_string=:user_log_string
        ");
        $result=db_exec($stmt,array("user_id"=>$user['user_id'],"user_log_type_id"=>$user_log_type_id,"user_log_string"=>$log_string));
        return;
}
function user_message($message,$error=0){
	global $smarty;
	# Routine to set the message at the top bar
	# Initialize the array if needed
	if(!isset($GLOBALS['messages'])){
		$GLOBALS['messages']=array();
	}
	if($error==1){
		$GLOBALS['messages'][]=array("message_color"=>"red","message"=>$message);
	}else{
		$GLOBALS['messages'][]=array("message_color"=>"green","message"=>$message);
	}
	$smarty->assign("messages",$GLOBALS['messages']);
	return;
}

# Session Functions
function start_fsession(){
	global $fsession;
	global $fsid;

	$fsession=array();
	if(isset($_COOKIE['fsid'])){
		$fsid=$_COOKIE['fsid'];
	}else{
		$fsid='';
	}
	logsession("Starting Session : ".$fsid);
	if($fsid){
		logsession("Reading Existing Session : ".$fsid);
		$stmt=db_prep("
			SELECT *
			FROM session
			WHERE session_hash=:fsid
			AND session_status=1
		");
		$result=db_exec($stmt,array("fsid"=>$fsid));
		if(isset($result[0])){
			$session=$result[0];
		}else{
			# Kill the cookie at this host and its base
			$host = $_SERVER['HTTP_HOST'];
	        setcookie('fsid','',0,"/",$host,FALSE,TRUE);
	        if(preg_match("/.*\.([^\.]+\.[^\.]+)$/", $host,$match)){
		        $host = $match[1];
				setcookie('fsid','',0,"/",$host,FALSE,TRUE);
	        }
	        logsession("Destroying Non existent Session : ".$fsid.",/,$host");
			$fsid='';
			create_fsession("/",$_SERVER['HTTP_HOST']);
			return;
		}
		# OK, now read the session data and populate the fsession array
		$data=explode("\n",$session['session_data']);
		foreach($data as $key=>$value){
			$line_array=explode("=",$value);
			$id=$line_array[0];
			$id_value=rtrim($line_array[1]);
			if($id!=''){
				$fsession[$id]=$id_value;
			}
		}
		logsession("Session : ".print_r($session,TRUE));
    }else{
    	create_fsession("/",$_SERVER['HTTP_HOST']);
    }
}
function logsession($string){
	global $logsessions;
	if($logsessions==1){
		$handle=fopen("{$GLOBALS['include_paths']['libraries']}/sessionlog.txt","a");
		fwrite($handle,"$string\n");
		fclose($handle);
	}
	return;
}
function create_fsession($path,$host){
	# Lets take off the www from the host name so we set them on all the same domain
	if (preg_match("/(?:.*\.)?([^.:]+\.[^.:]+)(?::\d+)?$/", $host, $match)) {
		$host = $match[1];
	}
	$time=microtime();
    $cookie_string=sha1($_SERVER['REMOTE_ADDR'].$_SERVER['SERVER_ADDR'].$time.openssl_random_pseudo_bytes(16));
    setcookie('fsid',$cookie_string,time()+(60*60*24*30),$path,$host,FALSE,TRUE);
    $GLOBALS['fsid']=$cookie_string;
    # Create the session record in the database
    $stmt=db_prep("
		INSERT INTO session
		SET session_hash=:fsid,
			session_start=now(),
			session_last=now(),
			session_status=1
    ");
    $result=db_exec($stmt,array("fsid"=>$GLOBALS['fsid']));
    logsession("Created New Session : ".$GLOBALS['fsid']." for host $host and path $path");
}
function save_fsession(){
        global $fsession;
        global $fsid;
        logsession("Saving Session : ".$GLOBALS['fsid']);
        if(isset($GLOBALS['fsid'])){
                # Create data string
                $datastring='';
                foreach($fsession as $key=>$value){
                        $datastring.="$key=$value\n";
                }
                # Now Update session if its not an empty fsid
                if($GLOBALS['fsid']!=''){
                        $stmt=db_prep("
                                UPDATE session
                                SET session_last=now(),
                                        session_data=:data
                                WHERE session_hash=:fsid
                        ");
                        $result=db_exec($stmt,array("data"=>$datastring,"fsid"=>$GLOBALS['fsid']));
                }
        }
}
function destroy_fsession(){
	global $fsid;
	$path="/";
	$host=$_SERVER['HTTP_HOST'];
	$host=preg_replace("/^www\./", "", $host);
	setcookie('fsid','',0,$path,$host,FALSE,TRUE);
	if(preg_match("/.*\.([^\.]+\.[^\.]+)$/", $host,$match)){
		setcookie('fsid','',0,"/",$match[1],FALSE,TRUE);
	}
	logsession("Destroying Session : ".$fsid.",$path,$host");
	if($fsid){
		# Turn off session db record
		$stmt=db_prep("
			UPDATE session
			SET session_status=0
			WHERE session_hash=:fsid
		");
		$result=db_exec($stmt,array("fsid"=>$GLOBALS['fsid']));
	}
	return;
}

function array_msort($array, $cols) {
        # Array to sort an associative array by multiple keys
        # $cols is an array of 'col_name'=>SORT_ASC (or SORT_DESC)
        $colarr = array();
        foreach ($cols as $col => $order) {
                $colarr[$col] = array();
                foreach ($array as $k => $row) {
                        $colarr[$col]['_'.$k] = strtolower($row[$col]);
                }
        }
        $params = array();
        foreach ($cols as $col => $order) {
                $params[] =&$colarr[$col];
                $order=(array)$order;
                foreach($order as $order_element) {
                        //pass by reference, as required by php 5.3
                        $params[]=&$order_element;
                }
        }
        call_user_func_array('array_multisort', $params);
        $ret = array();
        $keys = array();
        $first = true;
        foreach ($colarr as $col => $arr) {
                foreach ($arr as $k => $v) {
                        if ($first) {
                                $keys[$k] = substr($k,1);
                        }
                        $k = $keys[$k];
                        if (!isset($ret[$k])) {
                                $ret[$k] = $array[$k];
                        }
                        $ret[$k][$col] = $array[$k][$col];
                }
                $first = false;
        }
        return $ret;
}
function array_orderby(){
    $args = func_get_args();
    $data = array_shift($args);
    foreach ($args as $n => $field) {
        if (is_string($field)) {
            $tmp = array();
            foreach ($data as $key => $row)
                $tmp[$key] = $row[$field];
            $args[$n] = $tmp;
            }
    }
    $args[] = &$data;
    call_user_func_array('array_multisort', $args);
    return array_pop($args);
}
function get_states(){
	# Function to get state list
	$stmt=db_prep("
		SELECT *
		FROM state
		ORDER BY state_order
	");
	$states=db_exec($stmt,array());
	return $states;
}
function get_state_code_value($state_id){
	# Function to get state code from an ID
	$stmt=db_prep("
		SELECT *
		FROM state
		WHERE state_id=:state_id
	");
	$result=db_exec($stmt,array("state_id"=>$state_id));
	return $result[0]['state_code'];
}
function get_countries(){
	# Function to get country list
	$stmt=db_prep("
		SELECT *
		FROM country
		ORDER BY country_order
	");
	$countries=db_exec($stmt,array());
	return $countries;
}
function get_country_code_value($country_id){
	# Function to get country code from an ID
	$result=querydb("
		SELECT *
		FROM country
		WHERE country_id=:country_id
	");
	$result=db_exec($stmt,array("country_id"=>$country_id));
	return $result[0]['country_code'];
}
function get_disciplines($add_all=1){
	# Function to get discipline list
	$disc=array();
	$stmt=db_prep("
		SELECT *
		FROM discipline
		ORDER BY discipline_order
	");
	$disc=db_exec($stmt,array());
	$disciplines=array();
	if($add_all){
		$disciplines[]=array("discipline_id"=>0,"discipline_code"=>'all',"discipline_description"=>'All F3X Disciplines');
		$disciplines=array_merge($disciplines,$disc);
	}else{
		$disciplines=$disc;
	}
	return $disciplines;
}
function set_disipline($discipline_id){
	global $smarty;
	# Function to set discipline in the session and template
	$stmt=db_prep("
		SELECT *
		FROM discipline
		WHERE discipline_id=:discipline_id
	");
	$result=db_exec($stmt,array("discipline_id"=>$discipline_id));
	
	$smarty->assign("disc",$result[0]['discipline_code']);
	$smarty->assign("discipline_id",$discipline_id);
	$GLOBALS['fsession']['discipline_id']=$discipline_id;
	$GLOBALS['fsession']['disc']=$result[0]['discipline_code'];
	
	return;
}
function return_to_action($from){
	global $smarty;
	# Function to return to a screen from whence they came
	# Lets change the request array to the new values
	$new=array();
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/from_(\S+)/",$key,$match)){
			$id=$match[1];
			$new[$id]=$value;
		}
	}
	# Now lets add the additional from values sent to the function
	foreach($from as $key=>$value){
			$new[$key]=$value;
	}
	$_REQUEST=$new;
	$action=$new['action'];
	# Now lets include the file
	include("{$GLOBALS['scripts_dir']}/$action.php");
	return $actionoutput;
}
function send_email($email_name,$email_to,$data){
	# Send one of the emails in the system
	global $template_dir;
	global $compile_dir;
	
	include_library('smarty/libs/Smarty.class.php');
	
	$smarty1=new Smarty;
	$smarty1->template_dir = $template_dir;
	$smarty1->compile_dir = $compile_dir;
	$smarty1->compile_check = false;
	$smarty1->auto_literal = false;
	$smarty1->debugging = false;

	# Assign the given data
	$smarty1->assign("data",$data);
	
	# Get signup email from the name
	$stmt=db_prep("
		SELECT *
		FROM email
		WHERE email_name=:email_name
	");
	$result=db_exec($stmt,array("email_name"=>$email_name));
	if(isset($result[0])){
		$email=$result[0];
	}else{
		return;
	}

	# Send the email
	include_library('PHPMailer/PHPMailerAutoload.php');
	$mail=new PHPMailer();
	
	# Replace any tokens in the content
	$email['email_html']=$smarty1->fetch('string:'.$email['email_html']);
	$email['email_subject']=$smarty1->fetch('string:'.$email['email_subject']);

	$mail->isSMTP();
	$mail->Host = 'localhost';
	$mail->SMTPAuth = false;
	$mail->Port = 25;
	
	$mail->setFrom($email['email_from_address'],$email['email_from_name']);
	$mail->isHTML(true);
	$mail->CharSet = 'UTF-8';

	$mail->Subject = $email['email_subject'];
	$mail->Body = $email['email_html'];	
	$mail->addAddress($email_to);
	$mail->addBCC("timtraver@gmail.com");

	# Send the email
	try {
		$mail->send();
		return 1;
	} catch (phpmailerException $e) {
		throw $e;
		error_log("Unable to send to: " . $to . ': ' . $e->getMessage(), 0);
		return 0;
	}
	return;
}
function log_action($id){
	# This is a function to log the activity of the pilots as they cruise around
	if(!$id){
		return;
	}
	if(!$GLOBALS['user']['user_id']){
		return;
	}
	$stmt=db_prep("
		INSERT INTO site_log
		SET site_log_date=now(),
			user_id=:user_id,
			site_log_action=:action,
			site_log_function=:function,
			site_log_action_id=:action_id
	");
	$result=db_exec($stmt,array(
		"user_id"=>$GLOBALS['user']['user_id'],
		"action"=>$_REQUEST['action'],
		"function"=>$_REQUEST['function'],
		"action_id"=>$id
	));
	return;
}
function check_unread_messages(){
	# This is a function to return a quick number of unread messages for this user
	$stmt=db_prep("
		SELECT count(user_message_id) as count
		FROM user_message
		WHERE user_id=:user_id
		AND user_message_status=1
		AND user_message_read_status=0
	");
	$result=db_exec($stmt,array("user_id"=>$GLOBALS['user']['user_id']));
	return $result['0']['count'];
}
function convert_string_to_colon( $timestring, $round_to ){
	# Function to convert a time string from digits only to colon notation
	if($timestring == '0' || $timestring == '00' || $timestring == '000' || $timestring == '' ){
		return '0:00';
	}
	$timestring = preg_replace("/\;/", ':', $timestring );
	if( preg_match( "/^(\d+)\:(\d\d)/", $timestring ) ){
		# Already in colon notation, so just return it
		return $timestring;
	}
	if( preg_match( "/^(\d+)s$/", $timestring, $match ) ){
		$fullsec = $match[1];
		$min = floor( $fullsec / 60 );
		$sec = fmod( $fullsec, 60 );
		return sprintf( "%d:%02d", $min, $sec );
	}elseif( preg_match( "/^(\d+)(\d\d)$/", $timestring, $match ) ){
		$min = intval( $match[1] );
		$sec = $match[2];
		if( $sec >= 60 ){
			$sec = $sec - 60;
			$min = $min + 1;
		}
		return sprintf( "%d:%02d", $min, $sec );
	}elseif( preg_match( "/^(\d)$/", $timestring, $match ) ){
		$min = 0;
		$sec = $match[1];
		if( $sec >= 60 ){
			$sec = $sec - 60;
			$min = $min + 1;
		}
		# Pad the seconds if needed
		if( $sec < 10 ){
			$sec = "0$sec";
		}
		return "$min:$sec";
	}elseif( preg_match( "/^(\d\d)$/", $timestring, $match ) ){
		$min = 0;
		$sec = $match[1];
		if( $sec >= 60 ){
			$sec = $sec - 60;
			$min = $min + 1;
		}
		return "$min:$sec";
	}elseif( preg_match( "/^(\d+)(\d\d\.\d+)$/", $timestring, $match ) ){
		$min = intval( $match[1] );
		$sec = $match[2];
		if( $sec >= 60 ){
			$sec = $sec - 60;
			$min = $min + 1;
		}
		if( $round_to == 0 ){
			$leading = 2;
		}else{
			$leading = intval( $round_to + 3 );
		}
		$format_string = '%d:%0' . $leading . '.' . $round_to . 'f';
		return sprintf( $format_string, $min, round( $sec, $round_to ) );
	}elseif( preg_match( "/^(\d\d\.\d+)$/", $timestring, $match ) ){
		$min = 0;
		$sec = $match[1];
		if( $sec >= 60 ){
			$sec = $sec - 60;
			$min = $min + 1;
		}
		if( $round_to == 0 ){
			$leading = 2;
		}else{
			$leading = intval( $round_to + 3 );
		}
		$format_string = '%d:%0' . $leading . '.' . $round_to . 'f';
		return sprintf( $format_string, $min, round( $sec, $round_to ) );
	}
	return $timestring;
}
function convert_colon_to_seconds( $timestring, $round_to ){
	# Function to convert a time string from colon notation to seconds
	if( !preg_match( "/^(\d+)\:(\d\d)$/", $timestring ) && !preg_match( "/^(\d+)\;(\d\d)$/", $timestring ) && !preg_match( "/^(\d+)\:(\d\d\.\d+)$/", $timestring ) && !preg_match( "/^(\d+)\;(\d\d\.\d+)$/", $timestring )){
		# Not in colon notation, so just return it
		return $timestring;
	}
	if( preg_match( "/^(\d+)\:(\d\d)$/", $timestring, $match ) || preg_match( "/^(\d+)\;(\d\d)$/", $timestring, $match ) ){
		$min = $match[1];
		$sec = $match[2];
		if( $sec >= 60 ){
			$sec = $sec - 60;
			$min = $min + 1;
		}
		$total_seconds = ( 60 * $min ) + $sec;
		return $total_seconds;
	}
	if( preg_match( "/^(\d+)\:(\d\d\.\d+)$/", $timestring, $match ) ){
		$min = $match[1];
		$sec = $match[2];
		if( $sec >= 60 ){
			$sec = $sec - 60;
			$min = $min + 1;
		}
		$total_seconds = ( 60 * $min ) + $sec;
		$total_seconds = round( $total_seconds, $round_to );
		return $total_seconds;
	}
}
function convert_seconds_to_colon( $seconds, $round_to ){
	# Function to convert a number of seconds to colon time string
	$seconds = floatval( $seconds );
	$min = floor( $seconds / 60 );
	$mod = fmod( $seconds, 60 );
	if( $round_to == 0 ){
		$leading = 2;
	}else{
		$leading = intval( $round_to + 3 );
	}
	$format_string = '%d:%0' . $leading . '.' . $round_to . 'f';
	return sprintf( $format_string, $min, $mod );
}
function sub_trace(){
	# This is a small function to add to the subroutine trace string so I can see which routines I am hitting
	global $trace;
	global $trace_on;
	global $start_time;
	
	if($trace_on){
		$seconds=microtime(true)-$start_time;
		$callers=debug_backtrace();
		$trace.="\n".$callers[1]['function']." - total_queries:{$GLOBALS['total_queries']} - total_seconds:{$seconds}";
	}
	return;
}
function convert_coordinates($string){
	# Function to convert lat and long string to decimal degrees if needed
	# lets first split the string by the comma
	$latlong=preg_split("/\,/",$string);
	$latstring=trim($latlong[0]);
	$lonstring=trim($latlong[1]);
	
	if(!preg_match("/\°/",$string)){
		# Lets remove anything but numbers
		$string=preg_replace("/[^\d\,\.\-\+]/", '', $string);
		return $string;
	}
	
	if(preg_match("/^([\+\-]*\d+)\°\s*(\d+)\'\s*(\S+)\"*\s*(\S*)/",$latstring,$match)){
		$degrees=$match[1];
		$minutes=$match[2];
		$seconds=floatval($match[3]);
		$direction=strtolower($match[4]);
		$latdec=($minutes/60) + ($seconds/3600);
		if($degrees<0){
			$lat=$degrees-$latdec;
		}else{
			$lat=$degrees+$latdec;
			if($direction=='s'){
				$lat=-$lat;
			}
		}
	}
	if(preg_match("/^([\+\-]*\d+)\°\s*(\d+)\'\s*(\S+)\"*\s*(\S)*/",$lonstring,$match)){
		$degrees=$match[1];
		$minutes=$match[2];
		$seconds=floatval($match[3]);
		$direction=strtolower($match[4]);
		$londec=($minutes/60) + ($seconds/3600);
		if($degrees<0){
			$lon=$degrees-$londec;
		}else{
			$lon=$degrees+$londec;
			if($direction=='w'){
				$lon=-$lon;
			}
		}
	}
	return "$lat,$lon";
}
function get_global_flags(){
	global $system_flags;

	# Get the system flags to include in the global space
	$system_flags=array();
	$stmt=db_prep("
		SELECT *
		FROM system_flag
	");
	$result=db_exec($stmt,array());
	foreach($result as $r){
		$name=$r['system_flag_name'];
		$system_flags[$name]=$r;
	}
	return;
}
function get_currencies(){
	# Function to get currency list
	$stmt=db_prep("
		SELECT *
		FROM currency
		ORDER BY currency_order
	");
	$currencies=db_exec($stmt,array());
	return $currencies;
}
function get_database_stats(){
	# Function to make a few queries to get totals based on the current chosen discipline
	$discipline = $GLOBALS['fsession']['disc'];
	$discipline_id = $GLOBALS['fsession']['discipline_id'];
	$db_totals = array();
	# Locations total
	if($discipline_id == 0){
		# All locations
		$stmt=db_prep("
			SELECT count(location_id) AS total
			FROM location
		");
		$result=db_exec($stmt,array());
		$db_totals['locations'] = $result[0]['total'];
	}else{
		$stmt=db_prep("
			SELECT count(l.location_id) AS total
			FROM location_discipline ld
			LEFT JOIN location l ON ld.location_id=l.location_id
			WHERE ld.location_discipline_status=1
				AND ld.discipline_id=:discipline_id
		");
		$result=db_exec($stmt,array("discipline_id"=>$discipline_id));
		$db_totals['locations'] = $result[0]['total'];
	}
	# planes total
	if($discipline_id == 0){
		# All planes
		$stmt=db_prep("
			SELECT count(plane_id) AS total
			FROM plane
		");
		$result=db_exec($stmt,array());
		$db_totals['planes'] = $result[0]['total'];
	}else{
		$stmt=db_prep("
			SELECT count(p.plane_id) AS total
			FROM plane_discipline pd
			LEFT JOIN plane p ON pd.plane_id=p.plane_id
			WHERE pd.plane_discipline_status=1
				AND pd.discipline_id=:discipline_id
		");
		$result=db_exec($stmt,array("discipline_id"=>$discipline_id));
		$db_totals['planes'] = $result[0]['total'];
	}
	# competitions total
	if($discipline_id == 0){
		# All competitions
		$stmt=db_prep("
			SELECT count(event_id) AS total
			FROM event
			WHERE event_status=1
		");
		$result=db_exec($stmt,array());
		$db_totals['events'] = $result[0]['total'];
	}else{
		$stmt=db_prep("
			SELECT count(e.event_id) AS total
			FROM event e
			LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
			WHERE e.event_status=1
				AND et.event_type_code=:discipline
		");
		$result=db_exec($stmt,array("discipline"=>$discipline));
		$db_totals['events'] = $result[0]['total'];
	}
	# pilots total
	$stmt=db_prep("
		SELECT count(pilot_id) AS total
		FROM pilot
	");
	$result=db_exec($stmt,array());
	$db_totals['pilots'] = $result[0]['total'];
	# clubs total
	$stmt=db_prep("
		SELECT count(club_id) AS total
		FROM club
	");
	$result=db_exec($stmt,array());
	$db_totals['clubs'] = $result[0]['total'];
	
	return $db_totals;
}

function date_stamp_add_offset($stamp,$timezone){
	# Function to add or subtract the amount of time depending on the time zone
	date_default_timezone_set( "UTC" );
	$offset = 0;
	if($timezone != ''){
		$offset = timezone_offset_get( timezone_open( $timezone ), new DateTime() );
	}
	return $stamp + $offset;
}

function round_calculation( $event, $number, $precision ){
	# Function to round a calculation value based on the settings for the event
	# event is the event class
	# number is the calculated number
	# precision is the number of decimals to calculate to

	$truncate = 0;
	foreach( $event->options as $option ){
		if( preg_match( "/_calc_truncate/", $option['event_type_option_code'] ) ){
			$truncate = $option['event_option_value'];
		}
	}
	if( $truncate ){
		$return_value = truncate( $number, $precision );
	}else{
		$return_value = round( $number, $precision );
	}
	return $return_value;
}
function round_down($number,$precision){
    $numberpart=explode(".",$number);
    $numberpart[1]=substr_replace($numberpart[1],".",$precision,0);
    $padded='';
	if(preg_match("/^(0+)/",$numberpart[1],$match)){
    	$padded=$match[1];
    }
    if($numberpart[0]>=0){
    	$numberpart[1]=$padded.floor($numberpart[1]);
    }else{
    	$numberpart[1]=$padded.ceil($numberpart[1]);
    }
	$ceil_number= array($numberpart[0],$numberpart[1]);
	return implode(".",$ceil_number);
}
function truncate( $number, $precision = 0 ){
   // warning: precision is limited by the size of the int type
   $shift = pow( 10, $precision );
   return intval( $number * $shift ) / $shift;
}

function calculate_amount_owed( $event_pilot_id ){
	# First get the event info from the pilot
	$stmt = db_prep( "
		SELECT *,e.event_id
		FROM event_pilot ep
		LEFT JOIN event e ON ep.event_id = e.event_id
		WHERE ep.event_pilot_id = :event_pilot_id
	" );
	$result = db_exec( $stmt, array( "event_pilot_id" => $event_pilot_id ) );
	$event_id = $result[0]['event_id'];

	$event = new Event( $event_id );
	$reg_options = $event->reg_options;
	# Function to determine the balance owed by a pilot
	$stmt = db_prep("
		SELECT *
		FROM event_pilot_reg epr
		LEFT JOIN event_reg_param erp ON epr.event_reg_param_id = erp.event_reg_param_id
		WHERE epr.event_pilot_id = :event_pilot_id
			AND epr.event_pilot_reg_status = 1
	");
	$result = db_exec($stmt,array(
		"event_pilot_id" => $event_pilot_id
	));
	$total_owed = 0;
	foreach($result as $row){
		$event_reg_param_id = $row['event_reg_param_id'];
		if( isset( $reg_options[ $event_reg_param_id ] ) ){
			$total_owed  +=  $row['event_pilot_reg_qty'] * $row['event_reg_param_cost'];
			unset( $reg_options[ $event_reg_param_id ] );
		}
	}
	# Now step through the remaining reg options to see if there are any mandatory
	foreach( $reg_options as $r ){
		if( $r['event_reg_param_mandatory'] == 1 ){
			$total_owed  +=  $r['event_reg_param_cost'];
		}
	}
	
	# Total the paid records
	$stmt = db_prep("
		SELECT sum(event_pilot_payment_amount) as total_paid
		FROM event_pilot_payment
		WHERE event_pilot_id = :event_pilot_id
			AND event_pilot_payment_status = 1
	");
	$result = db_exec($stmt,array(
		"event_pilot_id" => $event_pilot_id,
	));
	$total_paid = $result[0]['total_paid'];
	$balance = $total_owed - $total_paid;
	return $balance;
}

/**
 * debug
 *
 * Helper function to write to debug logger which displays in the debugging console toolbar
 *
 * @param string $msg
 *
 * @return void
 */
function debug($msg) {
        global $debugLogger;

        if (!DEBUG || !is_object($debugLogger)) {
                return;
        }
        $debugLogger->log($msg);
}

?>
