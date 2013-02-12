<?php
############################################################################
#       functions.inc
#
#       Tim Traver
#       5/21/12
#       Miva Merchant, Inc.
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
        $smarty->debugging = true;
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

        $login="admin";
        if($admin_pass==''){
                $admin_pass=trim(file_get_contents("{$GLOBALS['include_paths']['libraries']}/db_phrase"));
        }

        try {
                $dbh=new PDO('mysql:host=localhost;dbname=f3x_timing',$login,$admin_pass,array(PDO::ATTR_PERSISTENT=>true));
                $dbh->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
                $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                $stmt = $dbh->prepare($querystring);
        } catch (PDOException $e) {
                $errorstring=$e->getMessage();
                query_error($querystring,$errorstring);
        }
        return $stmt;
}
function db_exec ($stmt,$data=array()) {
        global $dbh;
        global $last_insert_id;

        # Function to wrap the query execution
        try {
                $stmt->execute($data);
                if(preg_match("/SELECT/i",$stmt->queryString)){
                        $results=$stmt->fetchAll(PDO::FETCH_ASSOC);
                }elseif(preg_match("/INSERT/i",$stmt->queryString)){
                        $results=$dbh->lastInsertId();
                }else{
                        $results=$stmt->rowCount();
                }
        } catch (PDOException $e) {
                $string=$e->getMessage();
                query_error($stmt->queryString,$string);
        }
        $last_insert_id=$dbh->lastInsertId();
        return $results;
}
function query_error($query,$error){
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
function show_pages($records,$defaultperpage=10){
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
                        $perpage=$defaultperpage;
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

        $smarty->assign("totalrecords",$totalrecords);
        $smarty->assign("totalpages",$totalpages);
        $smarty->assign("prevpage",$prevpage);
        $smarty->assign("nextpage",$nextpage);
        $smarty->assign("startrecord",$startrecord);
        $smarty->assign("endrecord",$endrecord);
        $smarty->assign("page",$page);

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
        # Check if it needs the alert graphic
        $GLOBALS['message_graphic']='';
        $found=0;
        foreach($GLOBALS['messages'] as $key=>$value){
                if($value['message_color']=="red"){
                        $found=1;
                }
        }
        if($found==1){
                $GLOBALS['message_graphic']='<img src="/f3x/images/errortriangle.gif">';
        }
}
function start_fsession(){
        global $fsession;
        global $fsid;

        if(isset($_COOKIE['fsid'])){
                $fsid=$_COOKIE['fsid'];
        }else{
                $fsid='';
        }
        logsession("Starting Session : ".$GLOBALS['fsid']);
        if($fsid){
                logsession("Reading Existing Session : ".$GLOBALS['fsid']);
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
                        $fsid='';
                        return;
                }
                # OK, now read the session data and populate the snsession array
                $data=explode("\n",$session['session_data']);
                foreach($data as $key=>$value){
                        $line_array=explode("=",$value);
                        $id=$line_array[0];
                        $id_value=rtrim($line_array[1]);
                        if($id!=''){
                                $fsession[$id]=$id_value;
                        }
                }
                # Check the last time it was modified to expire the session if needed
                #$now=time();
                #$last_time=strtotime($session['session_last']);
                #if(($now-$last_time)>$GLOBALS['session_expiration']){
                #        # Set the variable for expired
                #        $fsession['session_expired']=1;
                #        unset($fsession['auth']);
                #}
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
        $time=microtime();
        $cookie_string=sha1($_SERVER['REMOTE_ADDR'].$_SERVER['SERVER_ADDR'].$time.openssl_random_pseudo_bytes(16));
        setcookie('fsid',$cookie_string,0,$path,$host,FALSE,TRUE);
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
        logsession("Created New Session : ".$GLOBALS['fsid']);
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
        $path="/";
        $host=$_SERVER['HTTP_HOST'];
        setcookie('fsid','',0,$path,$host,FALSE,TRUE);
        logsession("Destroying Session : ".$GLOBALS['fsid'].",$path,$host");
        # Turn off session db record
        $stmt=db_prep("
                UPDATE session
                SET session_status=0
                WHERE session_hash=:fsid
        ");
        $result=db_exec($stmt,array("fsid"=>$GLOBALS['fsid']));
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
                if($password!=decrypt($user['user_pass'])){
                	$error=2;
                	$errorstring="User password is not correct. Please try again or use the forgot password link.".decrypt($user['user_pass']);
					return array($error,"$errorstring");
                }
        }else{
				$error=2;
				$errorstring="User does not currently have a login. Please register with us!";
				return array($error,"$errorstring");
        }

        $path="/f3x";
        $host=$_SERVER['HTTP_HOST'];
        # New session stuff
        create_fsession($path,$host);
        $fsession['auth']=TRUE;
        $fsession['user_id']=$user['user_id'];
        $fsession['user_name']=$user['user_name'];

        save_fsession();
        return array($error,"$errorstring");
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

?>
