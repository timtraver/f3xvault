<?php
############################################################################
#	import.php
#
#	Tim Traver
#	2/23/15
#	This is the script to handle importing of events
#
############################################################################
$GLOBALS['current_menu']='import';

include_library("event.class");

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
	$function=$_REQUEST['function'];
}else{
	$function="import_view";
}

$need_login=array(
	"import_view",
	"import_verify",
	"import_import"
);
if(check_user_function($function)){
	if($GLOBALS['user_id']==0 && in_array($function, $need_login)){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Import information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		$actionoutput=$smarty->fetch($maintpl);
	}else{
		# They are allowed
		eval("\$actionoutput=$function();");
	}
}else{
	 $actionoutput= show_no_permission();
}

function import_view() {
	global $user;
	global $smarty;
	
	$event_id=intval($_REQUEST['event_id']);

	$event=array();
	if($event_id!=0){
		$event=New Event();
	}


	$smarty->assign("event",$event);
	$smarty->assign("event_types",$event_types);
	$maintpl=find_template("import_view.tpl");
	return $smarty->fetch($maintpl);
}
function import_verify() {
	global $smarty;

	$event=array();
	$event_id=intval($_REQUEST['event_id']);
	if(isset($_FILES['import_file'])){
		$import_file=$_FILES['import_file']['tmp_name'];
	}
	if($import_file==''){
		return import_view();
	}
	$event_zero_round=0;
	if(isset($_REQUEST['event_zero_round']) && ($_REQUEST['event_zero_round']=='on' || $_REQUEST['event_zero_round']==1)){
		$event_zero_round=1;
	}
	$field_separator=$_REQUEST['field_separator'];
	$decimal_type=$_REQUEST['decimal_type'];

	# If the file is imported, lets get the content
	$lines=file($import_file);

	$event_line=explode($field_separator,trim(array_shift($lines)));
	$event_id=$event_line[0];
	$event_name=$event_line[1];
	$event_start_date=$event_line[2];
	$event_end_date=$event_line[3];
	$event_type_name=$event_line[4];
		
	# Lets check if this event exists if they sent an event id
	if($event_id!=0){
		# This is an existing event that we are importing in to
		# Lets first see if it even exists
		$stmt=db_prep("
			SELECT *
			FROM event
			WHERE event_id=:event_id
		");
		$result=db_exec($stmt,array("event_id"=>$event_id));
		if(!isset($result[0])){
			# Event does not exist
			$event_id=0;
		}
	}
	
	# Lets get the event type id
	$event_type_code='';
	if($event_type_name!=''){
		$stmt=db_prep("
			SELECT *
			FROM event_type
			WHERE event_type_name=:event_type_name
				OR event_type_code=:event_type_code
		");
		$result=db_exec($stmt,array("event_type_name"=>$event_type_name,"event_type_code"=>$event_type_name));
		if(!isset($result[0])){
			$event_type_id=0;
		}else{
			$event_type_id=$result[0]['event_type_id'];
			$event_type_code=$result[0]['event_type_code'];
			$event_type_name=$result[0]['event_type_name'];
		}
	}
	
	# Spit out the results to review
	if($event_type_code=='f3k'){
		# Lets get all the flight types and the round types
		$stmt=db_prep("
			SELECT *
			FROM flight_type
			WHERE flight_type_code LIKE :flight_type_code
		");
		$result=db_exec($stmt,array("flight_type_code"=>$event_type_code."%"));
		foreach($result as $row){
			$flight_type_code=$row['flight_type_code'];
			$flight_types[$flight_type_code]=$row;
		}
		# Lets read in the second line which are the round designations
		$temp_rounds=explode($field_separator,trim(array_shift($lines)));
		$x=1;
		$rounds=array();
		foreach($temp_rounds as $r){
			$rounds[$x]=$flight_types[$r];
			$x++;
		}
	}else{
		# Lets get the flight types for this discipline
		$stmt=db_prep("
			SELECT *
			FROM flight_type
			WHERE flight_type_code LIKE :flight_type_code
			ORDER BY flight_type_order
		");
		$result=db_exec($stmt,array("flight_type_code"=>$event_type_code."%"));
		foreach($result as $row){
			$flight_type_code=$row['flight_type_code'];
			$flight_types[$flight_type_code]=$row;
		}
	}
	$pilots=array();
	foreach($lines as $line){
		$line=trim($line);
		$fields=explode(",",$line);
		$temp_pilot=array();
		$temp_pilot['pilot_id']=$fields[0];
		$temp_pilot['pilot_name']=$fields[1];
		$temp_pilot['pilot_class']=$fields[2];
		$temp_pilot['pilot_freq']=$fields[3];
		$temp_pilot['pilot_team']=$fields[4];
		$x=5;
		$r=1;
		$temp_rounds=array();
		while(isset($fields[$x])){
			switch($event_type_code){
				case 'f3b':
					# F3b 3 rounds in one
					
					break;
				case 'f3f':
					# F3F Flights
					
					break;
				case 'f3j':
					# F3J special fields
					
					break;
				case 'f3k':
					# F3K subflights for this round
					$temp_rounds[$r]['group']=$fields[$x];
					$x++;
					# Read in all the subflights
					for($y=1;$y<=$rounds[$r]['flight_type_sub_flights'];$y++){
						$temp_rounds[$r]['flights']['sub'][$y]=convert_seconds_to_colon($fields[$x]);
						$x++;
					}
					$temp_rounds[$r]['penalty']=$fields[$x];
					$x++;
					break;
				case 'td':
					# TD flights
					
					break;
			}
			$r++;
		}
		$temp_pilot['rounds']=$temp_rounds;
		$pilots[]=$temp_pilot;
	}
	# Now lets step through the pilots and if they don't have an id, do a search for possible pilot names
	foreach($pilots as $key=>$p){
		$potentials=array();
		$found_pilots=array();
		if($p['pilot_id']=='' || $p['pilot_id']=='0'){
			# Lets get the list of possible pilot names for this one
			$pilot_entered=$p['pilot_name'];
			$q = trim(urldecode(strtolower($pilot_entered)));
			$q = '%'.$q.'%';
			# lets get the first name and last name out of it
			$words=preg_split("/\s+/",$pilot_entered,2);
			$first_name=$words[0];
			$last_name=$words[1];
			# Do search
			$stmt=db_prep("
				SELECT *
				FROM pilot p
				LEFT JOIN state s ON p.state_id=s.state_id
				LEFT JOIN country c ON p.country_id=c.country_id
				WHERE LOWER(p.pilot_first_name) LIKE :term1
					OR LOWER(p.pilot_last_name) LIKE :term2
					OR LOWER(CONCAT(p.pilot_first_name,' ',p.pilot_last_name)) LIKE :term3
			");
			$found_pilots=db_exec($stmt,array("term1"=>$first_name,"term2"=>$last_name,"term3"=>$q));
			$potentials[]=array("pilot_id"=>0,"pilot_full_name"=>'Add As New Pilot');
		}else{
			$stmt=db_prep("
				SELECT *
				FROM pilot p
				LEFT JOIN state s ON p.state_id=s.state_id
				LEFT JOIN country c ON p.country_id=c.country_id
				WHERE p.pilot_id=:pilot_id
			");
			$found_pilots=db_exec($stmt,array("pilot_id"=>$p['pilot_id']));
		}
		$found=0;
		foreach($found_pilots as $key2=>$fp){
			$fp['pilot_full_name']=$fp['pilot_first_name']." ".$fp['pilot_last_name'];
			if($fp['pilot_full_name']==$p['pilot_name']){
				$found=1;
			}
			$potentials[]=$fp;
		}
		$pilots[$key]['potentials']=$potentials;
		$pilots[$key]['found']=$found;
	}

	$event['event_id']=$event_id;
	$event['event_zero_round']=$event_zero_round;
	$event['field_separator']=$field_separator;
	$event['decimal_type']=$decimal_type;
	$event['event_name']=$event_name;
	$event['event_start_date']=$event_start_date;
	$event['event_end_date']=$event_end_date;
	$event['event_type_id']=$event_type_id;
	$event['event_type_name']=$event_type_name;
	$event['event_type_code']=$event_type_code;
	
	
	$smarty->assign("event",$event);
	$smarty->assign("pilots",$pilots);
	$smarty->assign("rounds",$rounds);
	
	$maintpl=find_template("import_verify.tpl");
	return $smarty->fetch($maintpl);
}
function import_import() {
	global $smarty;

	$event['event_id']=$_REQUEST['event_id'];
	$event['event_zero_round']=$_REQUEST['event_zero_round'];
	$event['event_name']=$_REQUEST['event_name'];
	$event['event_start_date']=$_REQUEST['event_start_date'];
	$event['event_end_date']=$_REQUEST['event_end_date'];
	
	# Now lets get the pilot info and put it in an array
	$pilots=array();
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^pilot_name_(\d+)/",$key,$match)){
			$number=$match[1];
			$pilots[$number]['pilot_name']=$value;
		}
		if(preg_match("/^pilot_class_(\d+)/",$key,$match)){
			$number=$match[1];
			$pilots[$number]['pilot_class']=$value;
		}
		if(preg_match("/^pilot_freq_(\d+)/",$key,$match)){
			$number=$match[1];
			$pilots[$number]['pilot_freq']=$value;
		}
		if(preg_match("/^pilot_team_(\d+)/",$key,$match)){
			$number=$match[1];
			$pilots[$number]['pilot_team']=$value;
		}
		if(preg_match("/^pilot_(\d+)_round_(\d+)_group/",$key,$match)){
			$number=$match[1];
			$round=$match[2];
			$pilots[$number]['rounds'][$round]['group']=$value;
		}
		if(preg_match("/^pilot_(\d+)_round_(\d+)_pen/",$key,$match)){
			$number=$match[1];
			$round=$match[2];
			$pilots[$number]['rounds'][$round]['pen']=$value;
		}
		if(preg_match("/^pilot_(\d+)_round_(\d+)_sub_(\d+)/",$key,$match)){
			$number=$match[1];
			$round=$match[2];
			$sub=$match[3];
			$pilots[$number]['rounds'][$round]['sub'][$sub]=$value;
		}
		if(preg_match("/^pilot_id_(\d+)/",$key,$match)){
			$number=$match[1];
			$pilots[$number]['pilot_id']=$value;
		}
		if(preg_match("/^event_round_(\d+)/",$key,$match)){
			$round=$match[1];
			$event['rounds'][$round]=$value;
		}
	}
	
	
	print_r($event);
	print_r($pilots);
	
	# OK, now do each of the steps to create or update the event
	# First check to see if the event exists, and get its info
	if($event['event_id']!=0){
		# Search for the event, and update it if it exists
		$stmt=db_prep("
			SELECT *
			FROM event
			WHERE event_id=:event_id
		");
		$result=db_exec($stmt,array("event_id"=>$event['event_id']));
		if(!isset($result[0])){
			# Event does not exist
			$event_id=0;
		}else{
			# Update the event with the given info
			$stmt=db_prep("
				UPDATE event
				SET event_name=:event_name,
					location_id=:location_id,
					event_start_date=:event_start_date,
					event_end_date=:event_end_date,
					event_type_id=:event_type_id,
					event_view_status=1,
					event_status=1
				WHERE event_id=:event_id
			");
			$result=db_exec($stmt,array(
				"event_name"=>$event['event_name'],
				"location_id"=>0,
				"event_start_date"=>$event['event_start_date'],
				"event_end_date"=>$event['event_end_date'],
				"event_type_id"=>$event['event_type_id'],
				"event_id"=>$event['event_id']
			));
		}
	}
	if($event['event_id']==0){
		# Create the new event with the given parameters
		$stmt=db_prep("
			INSERT INTO event
			SET pilot_id=:pilot_id,
				event_name=:event_name,
				location_id=:location_id,
				club_id=:club_id,
				event_start_date=:event_start_date,
				event_end_date=:event_end_date,
				event_cd=:event_cd,
				event_type_id=:event_type_id,
				event_view_status=1,
				event_status=1
			WHERE event_id=:event_id
		");
		$result=db_exec($stmt,array(
			"event_name"=>$event['event_name'],
			"location_id"=>0,
			"event_start_date"=>$event['event_start_date'],
			"event_end_date"=>$event['event_end_date'],
			"event_type_id"=>$event['event_type_id'],
			"event_id"=>$event['event_id']
		));
		$event['event_id']=$GLOBALS['last_insert_id'];
	}


	# Update the event info with the names and dates
	
	# Get list of pilots if there are any
	
	# Determine event classes to check in the options
	
	# Update list of pilots from array and copy in event_pilot_id to the array
	# Create any event_pilots that don't already exist
	
	# Set event tasks if there are any
	
	
	# Clear all round entries by turning them off
	
	# Step through each pilot and create the round entries (turning on if existing)
	
	
	# Step through each round and total the round
	
	# Run the total entire event
	
	


	user_message("Successfully imported event!");
	return import_view();

}


?>
