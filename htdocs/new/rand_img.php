<?php
############################################################################
#       rand_img.php
#
#       Tim Traver
#       3/5/13
#       This is a script to spit out a random img for an image tag
#
############################################################################

require_once("/shared/links/r/c/v/a/rcvault.com/site/php/new/conf.php");

include_library('functions.inc');

# Lets make the database call to get a random image from the images in the system
$media=array();
$stmt=db_prep("
	SELECT location_media_url
	FROM location_media
	WHERE location_media_type='picture'
		AND location_media_status=1
");
$result=db_exec($stmt,array());
foreach($result as $r=>$m){
	$media[]=$m['location_media_url'];
}

$stmt=db_prep("
	SELECT plane_media_url
	FROM plane_media
	WHERE plane_media_type='picture'
		AND plane_media_status=1
");
$result=db_exec($stmt,array());
foreach($result as $r=>$m){
	$media[]=$m['plane_media_url'];
}

$stmt=db_prep("
	SELECT pilot_plane_media_url
	FROM pilot_plane_media
	WHERE pilot_plane_media_type='picture'
		AND pilot_plane_media_status=1
");
$result=db_exec($stmt,array());
foreach($result as $r=>$m){
	$media[]=$m['pilot_plane_media_url'];
}

# Lets create a loop to make sure we get a good file to spit out
$finfo = new finfo(FILEINFO_MIME);
$file_type = '';
do{
	$key = array_rand($media);
	$url = $media[$key];
	
	# Now lets read that file in and spit it out
	$path = $url;
	# Strip out the full URL path
	$path = preg_replace("/^http\:\/\/www\.f3xvault\.com\//", '', $path);
	$path = preg_replace("/^http\:\/\/f3xvault\.com\//", '', $path);
	$path = preg_replace("/^\//", '', $path);
	$path = $GLOBALS['base_webroot'].$path;
	
	# Figure out the image type
	$file_type = $finfo->file($path);
	
	# Lets make sure its less than 1MB
	if(filesize($path)>1048576){
		$file_type = '';
	}
}while($file_type == '');

# Now lets read the file and spit it out
header("Content-Type: $file_type");
header("Pragma: no-cache");
readfile($path);

exit;

?>