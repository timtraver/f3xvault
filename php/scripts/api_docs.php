<?php
############################################################################
#       api_docs.php
#
#       Tim Traver
#       7/24/17
#       This is the script to show the docs for the API functions
#
############################################################################
$GLOBALS['current_menu'] = 'api_docs';

# This whole section requires the user to be logged in
if($GLOBALS['user_id'] == 0){
	# The user is not logged in, so send the feature template
	user_message("Sorry, but you must be logged in as a user to view this feature.",1);
	$smarty->assign("redirect_action",$_REQUEST['action']);
	$smarty->assign("redirect_function",$_REQUEST['function']);
	$smarty->assign("request",$_REQUEST);
	$maintpl = find_template("feature_requires_login.tpl");
	$actionoutput = $smarty->fetch($maintpl);
}else{
	if(isset($_REQUEST['function']) && $_REQUEST['function'] != '') {
        $function = $_REQUEST['function'];
	}else{
        $function = "api_docs_show";
	}
	if(check_user_function($function)){
        eval("\$actionoutput = $function();");
	}
}

function api_docs_show() {
	global $user;
	global $smarty;
		
	$functions = array();
	include_library("api.class");
	$api = new API();
	$functions = $api->functions;

	$api_functions = array();
	# Step through each function and get the basic function parameters and their info
	ksort($functions);
	
	foreach($functions as $key => $f){
		if(!is_file($GLOBALS['include_paths']['libraries']."/api/{$f['function_name']}.class")){
			continue;
		}
		include_library("api/{$f['function_name']}.class");
		eval("\$api_func = new {$f['function_name']}(\$api);");
		if(method_exists($api_func,'get_additional_parameters')){
			$api_func->get_additional_parameters();
		}
		$api_functions[] = array(
			"function_name" => $f['function_name'],
			"function_description" => $f['function_description'],
			"function_parameters" => $api->function_parameters,
			"additional_parameters" => $api_func->additional_parameters,
			"function_output_modes" => $api->function_output_modes,
			"function_output_description" => $api->function_output_description,
			"function_output_parameters" => $api->function_output_parameters,
		);
	}

	$smarty->assign("api_functions",$api_functions);
	
	$maintpl = find_template("api_docs/api_docs_show.tpl");
	return $smarty->fetch($maintpl);
}

?>