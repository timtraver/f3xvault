<?php
############################################################################
#	records.php
#
#	Tim Traver
#	2/17/13
#	This is the script to handle the different records for speeds and distances
#
############################################################################
$smarty->assign("current_menu",'records');

if(isset($_REQUEST['function']) && $_REQUEST['function'] != '') {
	$function = $_REQUEST['function'];
}else{
	$function = "records_list";
}

$need_login = array();
if(check_user_function($function)){
	if($GLOBALS['user_id'] == 0 && in_array($function, $need_login)){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to use this feature.",1);
		$smarty->assign("redirect_action",$_REQUEST['action']);
		$smarty->assign("redirect_function",$_REQUEST['function']);
		$smarty->assign("request",$_REQUEST);
		$maintpl = find_template("feature_requires_login.tpl");
		$actionoutput = $smarty->fetch($maintpl);
	}else{
		# They are allowed
		eval("\$actionoutput = $function();");
	}
}else{
	 $actionoutput = show_no_permission();
}

function records_list() {
	global $smarty;

	$country_id = 0;
	if(isset($_REQUEST['country_id'])){
		$country_id = intval($_REQUEST['country_id']);
		$GLOBALS['fsession']['country_id'] = $country_id;
	}elseif(isset($GLOBALS['fsession']['country_id'])){
		$country_id = $GLOBALS['fsession']['country_id'];
	}
	$page = 1;
	if(isset($_REQUEST['page'])){
		$page = intval($_REQUEST['page']);
		$GLOBALS['fsession']['page'] = $page;
	}elseif(isset($GLOBALS['fsession']['page'])){
		$page = $GLOBALS['fsession']['page'];
	}
	if(isset($_REQUEST['perpage'])){
		$perpage = intval($_REQUEST['perpage']);
		$GLOBALS['fsession']['perpage'] = $perpage;
	}elseif(isset($GLOBALS['fsession']['perpage'])){
		$perpage = $GLOBALS['fsession']['perpage'];
	}
	if(!$perpage){
		$perpage = 25;
	}
	$addcountry = '';
	if($country_id != 0){
		$addcountry .= " AND pc.country_id = $country_id ";
	}
	
	# Get only countries that we have events for
	$stmt = db_prep("
		SELECT DISTINCT c.*
		FROM event e
		LEFT JOIN location l ON e.location_id = l.location_id
		LEFT JOIN country c ON c.country_id = l.country_id
		WHERE c.country_id != 0
			AND e.event_type_id IN (1,2,3)
	");
	$countries = db_exec($stmt,array());

	# Lets determine the records to show from the page and the number of pilots per page
	if($page == 1){
		$start_record = 1;
		$end_record = $perpage;
	}else{
		$start_record = (($page-1)*$perpage) + 1;
		$end_record = $start_record + $perpage -1;
	}
	$smarty->assign("start_record",$start_record);
	$smarty->assign("end_record",$end_record);

	$limit_start = $start_record-1;
	$limit_end = $perpage;
	
	$f3f_records = array();
	$f3b_records = array();
	$f3b_distance = array();
	
	# Lets get the top speeds in F3F across all of the events
	$stmt = db_prep("
		SELECT *,p.pilot_id as record_pilot_id,pc.country_code as pilot_country_code
		FROM event_pilot_round_flight eprf
		LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id = epr.event_pilot_round_id
		LEFT JOIN event_pilot ep ON epr.event_pilot_id = ep.event_pilot_id
		LEFT JOIN plane pl ON ep.plane_id = pl.plane_id
		LEFT JOIN pilot p on ep.pilot_id = p.pilot_id
		LEFT JOIN country pc ON p.country_id = pc.country_id
		LEFT JOIN event e ON ep.event_id = e.event_id
		LEFT JOIN location l ON e.location_id = l.location_id
		LEFT JOIN country c ON l.country_id = c.country_id
		WHERE eprf.event_pilot_round_flight_status = 1
			AND ep.event_pilot_status = 1
			AND e.event_status = 1
			AND e.event_type_id = 1
			AND eprf.event_pilot_round_flight_seconds != 0
			$addcountry
		ORDER BY eprf.event_pilot_round_flight_seconds
		LIMIT $limit_start,$limit_end
	");
	$f3f_records = db_exec($stmt,array());


	# Lets get the top 20 speeds in F3B across all of the events
	$stmt = db_prep("
		SELECT *,p.pilot_id as record_pilot_id,pc.country_code as pilot_country_code
		FROM event_pilot_round_flight eprf
		LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id = epr.event_pilot_round_id
		LEFT JOIN event_pilot ep ON epr.event_pilot_id = ep.event_pilot_id
		LEFT JOIN plane pl ON ep.plane_id = pl.plane_id
		LEFT JOIN pilot p on ep.pilot_id = p.pilot_id
		LEFT JOIN country pc ON p.country_id = pc.country_id
		LEFT JOIN event e ON ep.event_id = e.event_id
		LEFT JOIN location l ON e.location_id = l.location_id
		LEFT JOIN country c ON l.country_id = c.country_id
		WHERE eprf.event_pilot_round_flight_status = 1
			AND ep.event_pilot_status = 1
			AND e.event_status = 1
			AND (e.event_type_id = 2 OR e.event_type_id = 3)
			AND eprf.flight_type_id = 3
			AND eprf.event_pilot_round_flight_seconds != 0
			$addcountry
		ORDER BY eprf.event_pilot_round_flight_seconds
		LIMIT $limit_start,$limit_end
	");
	$f3b_records = db_exec($stmt,array());

	# Lets get the top 20 distance runs in F3B across all of the events
	$stmt = db_prep("
		SELECT *,p.pilot_id as record_pilot_id,pc.country_code as pilot_country_code
		FROM event_pilot_round_flight eprf
		LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id = epr.event_pilot_round_id
		LEFT JOIN event_pilot ep ON epr.event_pilot_id = ep.event_pilot_id
		LEFT JOIN plane pl ON ep.plane_id = pl.plane_id
		LEFT JOIN pilot p on ep.pilot_id = p.pilot_id
		LEFT JOIN country pc ON p.country_id = pc.country_id
		LEFT JOIN event e ON ep.event_id = e.event_id
		LEFT JOIN location l ON e.location_id = l.location_id
		LEFT JOIN country c ON l.country_id = c.country_id
		WHERE eprf.event_pilot_round_flight_status = 1
			AND ep.event_pilot_status = 1
			AND e.event_status = 1
			AND e.event_type_id = 2
			AND eprf.flight_type_id = 2
			AND eprf.event_pilot_round_flight_laps != 0
			$addcountry
		ORDER BY eprf.event_pilot_round_flight_laps DESC
		LIMIT $limit_start,$limit_end
	");
	$f3b_distance = db_exec($stmt,array());

	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);

	# Set the paging stuff manually for this one
	if($page  ==  1){
		$prev  = 1;
	}else{
		$prev  = $page - 1;
	}
	$paging['main']  = array(
		"page" => $page,
		"startrecord" => $limit_start,
		"endrecord" => $limit_end,
		"callback" => 'action = records',
		"perpage" => $perpage,
		"nextpage" => $page+1,
		"prevpage" => $prev,
		"totalpages" => $page+1,
		"totalrecords" => 1000000000
	);
	$smarty->assign("paging",$paging);
	$smarty->assign("countries",$countries);
	$smarty->assign("f3f_records",$f3f_records);
	$smarty->assign("f3b_records",$f3b_records);
	$smarty->assign("f3b_distance",$f3b_distance);
	$smarty->assign("page",$page);

	$maintpl = find_template("records.tpl");
	return $smarty->fetch($maintpl);
}
?>
