<?php
############################################################################
#       pdf2.php
#
#       Tim Traver
#       1/8/16
#       This is the test of the pdf class
#
############################################################################
global $user;
global $user_id;
global $fsession;
global $system_flags;

$start_time=microtime(true);

require_once("/var/www/f3xvault.com/php/conf.php");

include_library('functions.inc');
include_library('pdf_f3x.class');

# Load system flags
get_global_flags();

$pdf = new PDF_F3X();

# Lets make a routine to build one complete cell, then we can duplicate it all around
$data[] = array(
	"event_name"=>"Cal Valley F3B Open",
	"pilot"=>"Darrel Zaballos",
	"round"=>2,
	"group"=>"C",
	"spot"=>"3",
	"task"=>"Thermal Duration",
	"target_time"=>"10 min"
);

$pdf->render('td',$data);





# Exit
exit;

?>

