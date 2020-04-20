<?php
############################################################################
#       conf.php
#
#       Tim Traver
#       5/21/12
#       Miva Merchant, Inc.
#       Small configuration file to set up some paths
#
############################################################################

global $include_paths;
global $template_dir;
global $compile_dir;
global $scripts_dir;
global $base;
global $base_webroot;
global $base_url;
global $base_plane_media;
global $user_name;
global $user_id;
global $session_expiration;
global $logsessions;
global $device;
global $recaptcha_key;
global $recaptcha_secret;
global $database_name;
global $database_user;
global $database_host;
global $database_pass;

$base = '/var/www/f3xvault.com';

$database_name = 'f3xvault';
$database_user = 'f3xvault';
$database_host = '127.0.0.1';
$database_pass = 'h5^#nK;(r2';

$base_webroot			= "$base/htdocs/";
$base_plane_media		= "/images/pilot_plane_images";
$base_location_media	= "/images/location_images";
$base_url				= "http://{$_SERVER['HTTP_HOST']}/";

# Determine which paths to set for library includes
$include_paths=array(
	"base"			=> "$base",
	"libraries"		=> "$base/php/libraries",
	"templates"		=> "$base/php/templates",
	"templates_c"	=> "$base/php/templates_c",
	"scripts"		=> "$base/php/scripts",
	"images"		=> "$base_webroot/images"
);

define('DEBUG', is_file("{$GLOBALS['include_paths']['base']}/debug"));

$template_dir	= $include_paths['templates'];
$compile_dir	= $include_paths['templates_c'];
$scripts_dir	= $include_paths['scripts'];

$recaptcha_key		= '6LdAXhgTAAAAAMeN_Dg8fMqjyYpGbnilpbN3txPJ';
$recaptcha_secret	= '6LdAXhgTAAAAAHbZ4eyQr2FwuCAlAyGroQA7Re4h';

$logsessions = 1;

include_library('debug_logger.php');

if (DEBUG) {
	$debugLogger = new DebugLogger();
}

# Functions to include libraries and modules
function include_library($library){
        # Function to include a library from the libraries area
        include_once("{$GLOBALS['include_paths']['libraries']}/$library");
}

?>