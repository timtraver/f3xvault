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
include_library('pdf_f3k.class');

# Load system flags
get_global_flags();

$pdf = new PDF_F3K();

# Lets make a routine to build one complete cell, then we can duplicate it all around
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Tim Traver",
	"round"=>2,
	"group"=>"D",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Mike Smith",
	"round"=>1,
	"group"=>"F",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Amardeep Dugal",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);
$data[] = array(
	"event_name"=>"7th Annual John Erickson Memorial DLG Contest",
	"pilot"=>"Doug Chronkite",
	"round"=>1,
	"group"=>"A",
	"task"=>"F3K Task B - Last Two Flights (3:00 Max) 7 Min Working",
	"flights"=>array(
		array("type"=>"time","label"=>"1:00"),
		array("type"=>"time","label"=>"1:30"),
		array("type"=>"time","label"=>"2:00"),
		array("type"=>"time","label"=>"2:30"),
		array("type"=>"time","label"=>"3:00")
	)
);

$pdf->render($data);





# Exit
exit;

?>

