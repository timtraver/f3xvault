<?php
############################################################################
#       downloads.php
#
#       Tim Traver
#       4/15/22
#       This is the script show the downloads page for f3xtiming application
#
############################################################################

if(isset($_REQUEST['function']) && $_REQUEST['function'] != '') {
        $function = $_REQUEST['function'];
}else{
        $function = "download_view";
}

eval("\$actionoutput = $function();");

function download_view() {
	global $user;
	global $smarty;
	
	$maintpl = find_template("downloads.tpl");
	return $smarty->fetch($maintpl);
}

?>