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

if(file_exists('C:/Program Files (x86)/Apache Software Foundation/Apache2.2/local')){
	$base = 'C:/Program Files (x86)/Apache Software Foundation/Apache2.2';
}else{
	$base = '/shared/links/r/c/v/a/rcvault.com/site';
}

$base_webroot = "$base/htdocs";
$base_plane_media = "/images/pilot_plane_images";
$base_location_media = "/images/location_images";
$base_url = "http://{$_SERVER['HTTP_HOST']}/";

# Determine which paths to set for library includes
$include_paths=array(
	"base"=>"$base",
	"libraries"=>"$base/php/libraries",
	"templates"=>"$base/php/templates",
	"templates_c"=>"$base/php/templates_c",
	"scripts"=>"$base/php/scripts",
	"images"=>"$base/images"
);

$template_dir=$include_paths['templates'];
$compile_dir=$include_paths['templates_c'];
$scripts_dir=$include_paths['scripts'];

$session_expiration=3600;
$logsessions=0;

# Functions to include libraries and modules
function include_library($library){
        # Function to include a library from the libraries area
        include_once("{$GLOBALS['include_paths']['libraries']}/$library");
}

?>
