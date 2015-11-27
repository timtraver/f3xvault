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

$base = '/shared/links/f/3/x/v/f3xvault.com/site';

$base_webroot = "$base/htdocs/new/";
$base_plane_media = "/images/pilot_plane_images";
$base_location_media = "/images/location_images";
$base_url = "http://{$_SERVER['HTTP_HOST']}/";

# Determine which paths to set for library includes
$include_paths=array(
	"base"=>"$base",
	"libraries"=>"$base/php/new/libraries",
	"templates"=>"$base/php/new/templates",
	"templates_c"=>"$base/php/new/templates_c",
	"scripts"=>"$base/php/new/scripts",
	"images"=>"$base_webroot/images"
);

$template_dir=$include_paths['templates'];
$compile_dir=$include_paths['templates_c'];
$scripts_dir=$include_paths['scripts'];

$logsessions=1;

# Functions to include libraries and modules
function include_library($library){
        # Function to include a library from the libraries area
        include_once("{$GLOBALS['include_paths']['libraries']}/$library");
}

?>
