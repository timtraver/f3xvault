<?php
############################################################################
#       pdf.php
#
#       Tim Traver
#       1/8/16
#       This is the test of the pdf library
#
############################################################################
global $user;
global $user_id;
global $fsession;
global $system_flags;

$start_time=microtime(true);

require_once("/var/www/f3xvault.com/php/conf.php");

include_library('security_functions.inc');
include_library('functions.inc');
include_library('smarty/libs/Smarty.class.php');
include_library('fpdf/fpdf.php');

# Load system flags
get_global_flags();

$pdf = new FPDF('L','mm','Letter');
$pdf->AddPage();
$pdf->SetFont('Arial','B',16);
$pdf->SetMargins(0,0);
$pdf->SetAutoPageBreak(FALSE);
$pdf->SetFillColor(211,211,211);

$width = $pdf->GetPageWidth();
$height = $pdf->GetPageHeight();

$space = 8;
$cols = 3;
$rows = 2;

$cell_width = ($width - ($cols+1)*$space)/$cols;
$cell_height = ($height - ($rows+1)*$space)/$rows;

$x_corner = $space;
$y_corner = $space;

$current_x = $space;
$current_y = $space;
$pad=1;

# Lets make a routine to build one complete cell, then we can duplicate it all around
$data = array(
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



# Lets set the XY for the cell
$pdf->SetXY($x_corner,$y_corner);

# Outline of the cell
$pdf->Cell($cell_width,$cell_height,'',1,0,'C',FALSE);

# Event Name header
$current_x += $pad;
$current_y += $pad;
$inner_cell_width = $cell_width - (2*$pad);
$pdf->SetFontSize(8);
$pdf->SetXY($current_x,$current_y);
$pdf->Cell($inner_cell_width,7,$data['event_name'],0,0,'L',TRUE);
$current_y += 8;

# Round Header
$pdf->SetXY($x_corner + $pad,$current_y);
$pdf->SetFillColor(211,211,211);
$pdf->SetFontSize(20);
$pdf->Cell($inner_cell_width,13,"Round {$data['round']}",0,0,'C',TRUE);
$current_y += 14;

# Pilot Name and Group
$pdf->SetFontSize(10);
$pdf->SetXY($current_x,$current_y);
$pdf->Cell(10,8,'Pilot',0,0,'C',TRUE);
$current_x += 11;
$pdf->SetXY($current_x,$current_y);
$pdf->SetFillColor(255,255,255);
$name_width = $inner_cell_width - 11 - 11 - 12;
$pdf->Cell($name_width,8,$data['pilot'],1,0,'L',TRUE);
$pdf->SetFillColor(211,211,211);

$current_x = $x_corner + $pad + $inner_cell_width - 11 - 11;
$pdf->SetXY($current_x,$current_y);
$pdf->Cell(12,8,'Group',0,0,'C',TRUE);

$current_x = $pdf->GetX() + 1;
$pdf->SetXY($current_x,$current_y);
$pdf->SetFillColor(255,255,255);
$pdf->SetFontSize(18);
$pdf->Cell(9,8,$data['group'],1,0,'C',TRUE);

$current_x = $x_corner + $pad;
$current_y += 9;

# Task Description
$pdf->SetFontSize(8);
$pdf->SetFillColor(211,211,211);
$pdf->SetXY($current_x,$current_y);
$pdf->Cell($inner_cell_width,12,$data['task'],0,0,'C',TRUE);

$current_x = $x_corner + $pad;
$current_y += 13;

# Lets add a space
$current_y += 3;

# Lets figure out how many boxes to have for flights
$num_flights = count($data['flights']);
$max_width = 20;

if((($num_flights*$max_width) + ($num_flights*$pad)) > $inner_cell_width){
	# The flight cell widths will be limited by the inner_cell_width
	$flight_cell_width = ($inner_cell_width - ($num_flights*$pad)) / $num_flights;
}else{
	$flight_cell_width = 20;
}
$all_flight_width = ($num_flights * $flight_cell_width) + ($num_flights * $pad);
$all_flight_pad = ($inner_cell_width - $all_flight_width)/2;
$start_flight_x = $x_corner + $pad + $all_flight_pad;

# Flight Labels
$pdf->SetFillColor(255,255,255);
$pdf->SetFontSize(8);
$current_x = $start_flight_x;

foreach($data['flights'] as $f){
	$pdf->SetXY($current_x,$current_y);
	$pdf->Cell($flight_cell_width,10,$f['label'],0,0,'C',TRUE);
	$current_x = $pdf->GetX() + 1;
}

# Flight Boxes
$current_y += 11;
$current_x = $start_flight_x;
$pdf->SetFontSize(10);
foreach($data['flights'] as $f){
	$pdf->SetXY($current_x,$current_y);
	$content = "";
	if($f['type'] == 'check'){
		$content = "[  ]";
	}
	$pdf->Cell($flight_cell_width,11,$content,1,0,'C',TRUE);
	$current_x = $pdf->GetX() + 1;
}

$current_y += 12;

# Lets add a space
$current_y += 3;

# Lets make quarter cells
$cell_width = ($inner_cell_width - (4*$pad)) / 4;

# Penalty Line
$current_x = $x_corner + $pad;
$pdf->SetFontSize(10);
$pdf->SetFillColor(211,211,211);
$pdf->SetXY($current_x,$current_y);
$pdf->Cell($cell_width,10,'Penalty',0,0,'C',TRUE);
$current_x = $pdf->GetX() + 1;
$pdf->SetFillColor(255,255,255);
$pdf->SetXY($current_x,$current_y);
$pdf->Cell($cell_width,10,'',1,0,'C',TRUE);
$current_x = $pdf->GetX() + 1;

# Signatures
$current_y += 11;
$current_x = $x_corner + $pad;
$pdf->SetFillColor(211,211,211);
$pdf->SetXY($current_x,$current_y);
$pdf->Cell($cell_width,10,'Pilot Sig',0,0,'C',TRUE);
$current_x = $pdf->GetX() + 1;
$pdf->SetFillColor(255,255,255);
$pdf->SetXY($current_x,$current_y);
$pdf->Cell($cell_width,10,'',1,0,'C',TRUE);
$current_x = $pdf->GetX() + 1;
$pdf->SetFillColor(211,211,211);
$pdf->SetXY($current_x,$current_y);
$pdf->Cell($cell_width,10,'Timer Sig',0,0,'C',TRUE);
$current_x = $pdf->GetX() + 1;
$pdf->SetFillColor(255,255,255);
$pdf->SetXY($current_x,$current_y);
$pdf->Cell($cell_width,10,'',1,0,'C',TRUE);


#for($x = 0;$x<$cols;$x++){
#	for($y = 0;$y<$rows;$y++){
#		$pdf->SetXY(($x*$cell_width)+$space+($x*$space),($y*$cell_height)+$space+($y*$space));
#		$pdf->Cell($cell_width,$cell_height,'',1,0,'C',FALSE);
#	}
#}

# Now lets make the headers
#$pdf->SetFontSize(8);
#$pad=1;
#for($x = 0;$x<$cols;$x++){
#	for($y = 0;$y<$rows;$y++){
#		$pdf->SetXY(($x*$cell_width)+$space+($x*$space)+$pad,($y*$cell_height)+$space+($y*$space)+$pad);
#		$pdf->Cell($cell_width - (2*$pad),5,'7th Annual John Erickson Memorial DLG Contest',1,0,'L',TRUE);
#	}
#}


#$pad=1;
#$y_offset = 6;
#$pdf->SetFontSize(14);
#for($x = 0;$x<$cols;$x++){
#	for($y = 0;$y<$rows;$y++){
#		$pdf->SetXY(($x*$cell_width)+$space+($x*$space)+$pad,($y*$cell_height)+$space+($y*$space)+$pad+$y_offset);
#		$pdf->Cell($cell_width - (2*$pad),10,'Round 1',1,0,'C',TRUE);
#	}
#}



#$pdf->SetXY(5,5);
#$pdf->Cell(85,100,'',1,0,'C',TRUE);
#$pdf->SetXY(97,5);
#$pdf->Cell(85,100,'',1,0,'C',TRUE);
#$pdf->SetXY(189,5);
#$pdf->Cell(85,100,'',1,0,'C',TRUE);

#$pdf->SetXY(5,110);
#$pdf->SetFillColor(57,245,24);
#$pdf->Cell(85,100,'',1,0,'C',TRUE);
#$pdf->SetXY(97,110);
#$pdf->Cell(85,100,'',1,0,'C',TRUE);
#$pdf->SetXY(189,110);
#$pdf->Cell(85,100,'',1,0,'C',TRUE);



#print "width=$width\n";
#print "height=$height\n";

$pdf->Output();





# Exit
exit;

?>

