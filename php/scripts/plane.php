<?php
############################################################################
#	plane.php
#
#	Tim Traver
#	8/14/12
#	This is the script to handle the plane records
#
############################################################################
$GLOBALS['current_menu']='planes';

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
	$function=$_REQUEST['function'];
}else{
	$function="plane_list";
}

if(check_user_function($function)){
	eval("\$actionoutput=$function();");
}else{
	 $actionoutput= show_no_permission();
}

function plane_list() {
	global $smarty;
	global $export;

	$discipline_id=0;
	if(isset($_REQUEST['discipline_id'])){
		$discipline_id=intval($_REQUEST['discipline_id']);
		$GLOBALS['fsession']['discipline_id']=$discipline_id;
	}elseif(isset($GLOBALS['fsession']['discipline_id'])){
		$discipline_id=$GLOBALS['fsession']['discipline_id'];
	}
	$search='';
	if(isset($_REQUEST['search']) ){
		$search=$_REQUEST['search'];
		$search_operator=$_REQUEST['search_operator'];
		$GLOBALS['fsession']['search']=$_REQUEST['search'];
		$GLOBALS['fsession']['search_operator']=$_REQUEST['search_operator'];
	}elseif(isset($GLOBALS['fsession']['search']) && $GLOBALS['fsession']['search']!=''){
		$search=$GLOBALS['fsession']['search'];
		$search_operator=$GLOBALS['fsession']['search_operator'];
	}
	if(isset($_REQUEST['search_field']) && $_REQUEST['search_field']!=''){
		$search_field_entry=$_REQUEST['search_field'];
	}elseif(isset($GLOBALS['fsession']['search_field'])){
		$search_field_entry=$GLOBALS['fsession']['search_field'];
	}
	switch($search_field_entry){
		case 'plane_manufacturer':
			$search_field='plane_manufacturer';
			break;
		case 'plane_year':
			$search_field='plane_year';
			break;
		case 'plane_wing_type':
			$search_field='plane_wing_type';
			break;
		case 'plane_tail_type':
			$search_field='plane_tail_type';
			break;
		default:
			$search_field='plane_name';
			break;
	}
	if($search=='' || $search=='%%'){
		$search_field='plane_name';
	}
	$GLOBALS['fsession']['search_field']=$search_field;

#	if($search!='' & $search!='%%'){
#		$plane_type_id=0;
#		$GLOBALS['fsession']['plane_type_id']=0;
#	}

	# Get all plane types
	$stmt=db_prep("
		SELECT *
		FROM plane_type
		ORDER BY plane_type_short_name
	");
	$plane_types=db_exec($stmt,array());
	
	switch($search_operator){
		case 'contains':
			$operator='LIKE';
			$search="%$search%";
			break;
		case 'greater':
			$operator=">=";
			break;
		case 'less':
			$operator="<=";
			break;
		case 'exactly':
			$operator="=";
			break;
		default:
			$operator="LIKE";
	}

#print "search=$search<br>\n";
#print "search_field=$search_field<br>\n";
#print "search_operator=$search_operator<br>\n";
#print "operator=$operator<br>\n";

	# Add search options for discipline
	$joind='';
	$extrad='';
	if($discipline_id!=0){
		$joind='LEFT JOIN plane_discipline pd ON p.plane_id=pd.plane_id';
		$extrad='AND pd.discipline_id='.$discipline_id.' AND pd.plane_discipline_status=1';
	}

	$planes=array();
	$newplanes=array();
	if($search!='%%' && $search!=''){
		# Get all planes in this plane_type with the search criteria
		$stmt=db_prep("
			SELECT *
			FROM plane p
			$joind
			WHERE $search_field $operator :search
			$extrad
			ORDER BY p.plane_name
		");
		$planes=db_exec($stmt,array("search"=>$search));
	}else{
		# Get all planes
		$stmt=db_prep("
			SELECT *
			FROM plane p
			LEFT JOIN country c ON p.country_id=c.country_id
			$joind
			WHERE 1
			$extrad
			ORDER BY p.plane_name
		");
		$planes=db_exec($stmt,array());
	}
	# Step through each plane to figure out if it has enough information
	foreach($planes as $plane){
		$total=0;
		if($plane['plane_wingspan']!=''){$total++;}
		if($plane['plane_length']!=0){$total++;}
		if($plane['plane_wing_area']!=0){$total++;}
		if($plane['plane_manufacturer']!=''){$total++;}
		if($plane['plane_year']!=0){$total++;}
		if($plane['plane_auw_from']!=0){$total++;}
		if($plane['plane_website']!=''){$total++;}
		if($plane['country_id']!=0){$total++;}
		if($total>5){
			$plane['plane_info']='good';
		}else{
			$plane['plane_info']='need';
		}
		$newplanes[]=$plane;
	}
	$planes=show_pages($newplanes,25);

	foreach($planes as $key=>$plane){
		# Lets get the plane types
		$stmt=db_prep("
			SELECT *
			FROM plane_discipline pd
			LEFT JOIN discipline d ON pd.discipline_id=d.discipline_id
			WHERE pd.plane_id=:plane_id
			ORDER BY d.discipline_order
		");
		$disciplines=db_exec($stmt,array("plane_id"=>$plane['plane_id']));
		$planes[$key]['disciplines']=$disciplines;
	}

	# Lets reset the discipline for the top bar if needed
	set_disipline($discipline_id);

	$smarty->assign("planes",$planes);
	$smarty->assign("plane_types",$plane_types);
	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("search_field",$GLOBALS['fsession']['search_field']);
	$smarty->assign("search_operator",$GLOBALS['fsession']['search_operator']);
	$smarty->assign("disciplines",get_disciplines());

	$maintpl=find_template("plane_list.tpl");
	return $smarty->fetch($maintpl);
}
function plane_edit() {
	global $smarty;

	if(isset($_REQUEST['plane_id'])){
		$plane_id=$_REQUEST['plane_id'];
	}else{
		$plane_id=0;
	}
	if(isset($_REQUEST['plane_name'])){
		$plane_name=$_REQUEST['plane_name'];
	}
	if(isset($_REQUEST['from_action'])){
		# Lets make an array of all of the return values
		foreach($_REQUEST as $key=>$value){
			if(preg_match("/from_(\S+)/",$key,$match)){
				$from[]=array("key"=>$key,"value"=>$value);
			}
		}
		# Now lets add that array to the template
		$smarty->assign("from",$from);
	}

	if($GLOBALS['user_id']==0){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit plane information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		return $smarty->fetch($maintpl);
	}
	
	$plane=array();
	$stmt=db_prep("
		SELECT *
		FROM plane p
		LEFT JOIN plane_type pt ON pt.plane_type_id=p.plane_type_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE plane_id=:plane_id
	");
	$result=db_exec($stmt,array("plane_id"=>$plane_id));
	if($result){
		$plane=$result[0];
	}else{
		$plane['plane_name']=ucwords($plane_name);
	}
	
	# Get all of the base plane attributes as well as the ones for this plane
	$plane_attributes=array();
	$stmt=db_prep("
		SELECT *,pa.plane_att_id
		FROM plane_att pa
		LEFT JOIN plane_att_cat pc ON pc.plane_att_cat_id=pa.plane_att_cat_id
		WHERE pa.plane_att_status=1
		ORDER BY pc.plane_att_cat_order,pa.plane_att_order
	");
	$plane_attributes=db_exec($stmt,array());

	$stmt=db_prep("
		SELECT *
		FROM plane_att_value
		WHERE plane_id=:plane_id
			AND plane_att_value_status=1
	");
	$values=db_exec($stmt,array("plane_id"=>$plane_id));

	# Step through each of the values and put those entries into the plane_attributes array
	foreach ($plane_attributes as $key=>$att){
		$id=$att['plane_att_id'];
		foreach($values as $value){
			if($value['plane_att_id']==$id){
				$plane_attributes[$key]['plane_att_value_value']=$value['plane_att_value_value'];
				$plane_attributes[$key]['plane_att_value_status']=$value['plane_att_value_status'];
			}
		}
	}
	
	# Get disciplines to select for this plane
	$disciplines=get_disciplines(0);
	# Lets get the records that this plane has
	$stmt=db_prep("
		SELECT *
		FROM plane_discipline
		WHERE plane_id=:plane_id
			AND plane_discipline_status=1
	");
	$values=db_exec($stmt,array("plane_id"=>$plane_id));
	# Step through each of the values and put those entries into the disciplines array
	foreach ($disciplines as $key=>$disc){
		$id=$disc['discipline_id'];
		foreach($values as $value){
			if($value['discipline_id']==$id){
				$disciplines[$key]['discipline_selected']=1;
			}
		}
	}
	
	# Get plane media records
	$media=array();
	$stmt=db_prep("
		SELECT *
		FROM plane_media pm
		WHERE pm.plane_id=:plane_id
		AND pm.plane_media_status=1
	");
	$media=db_exec($stmt,array("plane_id"=>$plane_id));

	$smarty->assign("plane",$plane);
	$smarty->assign("plane_attributes",$plane_attributes);
	$smarty->assign("disciplines",$disciplines);
	$smarty->assign("countries",get_countries());
	$smarty->assign("media",$media);

	$maintpl=find_template("plane_edit.tpl");
	return $smarty->fetch($maintpl);
}
function plane_view() {
	global $smarty;

	if(isset($_REQUEST['plane_id'])){
		$plane_id=$_REQUEST['plane_id'];
	}

	$plane=array();
	$stmt=db_prep("
		SELECT *
		FROM plane p
		LEFT JOIN plane_type pt ON pt.plane_type_id=p.plane_type_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE plane_id=:plane_id
	");
	$result=db_exec($stmt,array("plane_id"=>$plane_id));
	if($result){
		$plane=$result[0];
	}
	
	# Get all of the base plane attributes as well as the ones for this plane
	$plane_attributes=array();
	$stmt=db_prep("
		SELECT *
		FROM plane_att_value pav
		LEFT JOIN plane_att pa ON pav.plane_att_id=pa.plane_att_id
		LEFT JOIN plane_att_cat pc ON pc.plane_att_cat_id=pa.plane_att_cat_id
		WHERE pav.plane_id=:plane_id
			AND pav.plane_att_value_status=1
	");
	$plane_attributes=db_exec($stmt,array("plane_id"=>$plane_id));

	# Get the plane media entries from various pilots
	$stmt=db_prep("
		SELECT *
		FROM pilot_plane_media ppm
		LEFT JOIN pilot_plane pp ON ppm.pilot_plane_id=pp.pilot_plane_id
		LEFT JOIN plane p ON pp.plane_id=p.plane_id
		LEFT JOIN pilot pi ON pp.pilot_id=pi.pilot_id
		LEFT JOIN state s ON pi.state_id=s.state_id
		WHERE ppm.pilot_plane_media_status=1
			AND p.plane_id=:plane_id
	");
	$media1=db_exec($stmt,array("plane_id"=>$plane_id));
	
	# Get plane media records
	$stmt=db_prep("
		SELECT *
		FROM plane_media pm
		WHERE pm.plane_id=:plane_id
		AND pm.plane_media_status=1
	");
	$media2=db_exec($stmt,array("plane_id"=>$plane_id));
	# Step thriough the media to get the user info for it
	foreach ($media2 as $key=>$m){
		if($m['user_id']!=0){
			$stmt=db_prep("
				SELECT *
				FROM pilot p
				LEFT JOIN state s ON p.state_id=s.state_id
				LEFT JOIN country c ON p.country_id=c.country_id
				WHERE p.user_id=:user_id
			");
			$result2=db_exec($stmt,array("user_id"=>$m['user_id']));
			if($result2[0]){
				# Add the user info to the array
				$media2[$key]=array_merge($m,$result2[0]);
			}
		}
	}

	# Lets step through the media1 array and change the values to the same as the plane media
	$media3=array();
	foreach ($media1 as $key=>$m){
		$media3[]=array("plane_media_type"=>$m['pilot_plane_media_type'],
			"plane_media_url"=>$m['pilot_plane_media_url'],
			"plane_media_caption"=>$m['pilot_plane_media_caption'],
			"plane_media_status"=>$m['pilot_plane_media_status'],
			"pilot_first_name"=>$m['pilot_first_name'],
			"pilot_last_name"=>$m['pilot_last_name'],
			"pilot_city"=>$m['pilot_city'],
			"state_code"=>$m['state_code'],
			"state_name"=>$m['state_name'],
			"country_code"=>$m['country_code'],
			"country_name"=>$m['country_name']
		);
	}
	# Now lets merge the two arrays
	$media=array_merge($media2,$media3);
	
	# Lets get a random picture to show on the front page of the plane view
	if(count($media)>1){
		$count=0;
		do {
			$rand=array_rand($media);
			$count++;
		}while($media[$rand]['plane_media_type']!='picture' && $count<10);
	}else{
		$rand=0;
	}

	# Lets get the disciplines that this plane has
	$stmt=db_prep("
		SELECT *
		FROM plane_discipline pd
		LEFT JOIN discipline d ON pd.discipline_id=d.discipline_id
		WHERE pd.plane_id=:plane_id
			AND pd.plane_discipline_status=1
	");
	$disciplines=db_exec($stmt,array("plane_id"=>$plane_id));
	
	# Get the plane comments
	$comments=array();
	$stmt=db_prep("
		SELECT *
		FROM plane_comment pc
		LEFT JOIN user u ON pc.user_id=u.user_id
		LEFT JOIN pilot p ON u.pilot_id=p.pilot_id
		WHERE pc.plane_id=:plane_id
		ORDER BY pc.plane_comment_date DESC
	");
	$comments=db_exec($stmt,array("plane_id"=>$plane_id));

	# Lets get the plane records to show
	$f3f_records=array();
	$f3b_records=array();
	$f3b_distance=array();
	# Lets get the top speeds in F3F across all of the events
	$stmt=db_prep("
		SELECT *,p.pilot_id as record_pilot_id,pc.country_code as pilot_country_code
		FROM event_pilot_round_flight eprf
		LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id=epr.event_pilot_round_id
		LEFT JOIN event_pilot ep ON epr.event_pilot_id=ep.event_pilot_id
		LEFT JOIN plane pl ON ep.plane_id=pl.plane_id
		LEFT JOIN pilot p on ep.pilot_id=p.pilot_id
		LEFT JOIN country pc ON p.country_id=pc.country_id
		LEFT JOIN event e ON ep.event_id=e.event_id
		LEFT JOIN location l ON e.location_id=l.location_id
		LEFT JOIN country c ON l.country_id=c.country_id
		WHERE eprf.event_pilot_round_flight_status=1
			AND ep.event_pilot_status=1
			AND e.event_status=1
			AND e.event_type_id=1
			AND eprf.event_pilot_round_flight_seconds!=0
			AND pl.plane_id=:plane_id
		ORDER BY eprf.event_pilot_round_flight_seconds
	");
	$f3f_records=db_exec($stmt,array("plane_id"=>$plane_id));

	$stmt=db_prep("
		SELECT *,p.pilot_id as record_pilot_id,pc.country_code as pilot_country_code
		FROM event_pilot_round_flight eprf
		LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id=epr.event_pilot_round_id
		LEFT JOIN event_pilot ep ON epr.event_pilot_id=ep.event_pilot_id
		LEFT JOIN plane pl ON ep.plane_id=pl.plane_id
		LEFT JOIN pilot p on ep.pilot_id=p.pilot_id
		LEFT JOIN country pc ON p.country_id=pc.country_id
		LEFT JOIN event e ON ep.event_id=e.event_id
		LEFT JOIN location l ON e.location_id=l.location_id
		LEFT JOIN country c ON l.country_id=c.country_id
		WHERE eprf.event_pilot_round_flight_status=1
			AND ep.event_pilot_status=1
			AND e.event_status=1
			AND (e.event_type_id=2 OR e.event_type_id=3)
			AND eprf.flight_type_id=3
			AND eprf.event_pilot_round_flight_seconds!=0
			AND pl.plane_id=:plane_id
		ORDER BY eprf.event_pilot_round_flight_seconds
	");
	$f3b_records=db_exec($stmt,array("plane_id"=>$plane_id));

	# Lets get the top 20 distance runs in F3B across all of the events
	$stmt=db_prep("
		SELECT *,p.pilot_id as record_pilot_id,pc.country_code as pilot_country_code
		FROM event_pilot_round_flight eprf
		LEFT JOIN event_pilot_round epr ON eprf.event_pilot_round_id=epr.event_pilot_round_id
		LEFT JOIN event_pilot ep ON epr.event_pilot_id=ep.event_pilot_id
		LEFT JOIN plane pl ON ep.plane_id=pl.plane_id
		LEFT JOIN pilot p on ep.pilot_id=p.pilot_id
		LEFT JOIN country pc ON p.country_id=pc.country_id
		LEFT JOIN event e ON ep.event_id=e.event_id
		LEFT JOIN location l ON e.location_id=l.location_id
		LEFT JOIN country c ON l.country_id=c.country_id
		WHERE eprf.event_pilot_round_flight_status=1
			AND ep.event_pilot_status=1
			AND e.event_status=1
			AND e.event_type_id=2
			AND eprf.flight_type_id=2
			AND eprf.event_pilot_round_flight_laps!=0
			AND pl.plane_id=:plane_id
		ORDER BY eprf.event_pilot_round_flight_laps DESC
	");
	$f3b_distance=db_exec($stmt,array("plane_id"=>$plane_id));

	$f3f_records=show_pages($f3f_records,20);
	# Now lets save the page info for when we do the next 2 arrays
	$temp_totalpages=$smarty->getTemplateVars('totalpages');
	$temp_startrecord=$smarty->getTemplateVars('startrecord');
	$temp_endrecord=$smarty->getTemplateVars('endrecord');
	$temp_page=$smarty->getTemplateVars('page');
	
	$f3b_records=show_pages($f3b_records,20);
	$f3b_distance=show_pages($f3b_distance,20);

	# Now lets reset the page values if needed
	if($smarty->getTemplateVars('page')==0){
		$smarty->assign("totalpages",$temp_totalpages);	
		$smarty->assign("startrecord",$temp_startrecord);	
		$smarty->assign("endrecord",$temp_endrecord);	
		$smarty->assign("page",$temp_page);	
	}

	$smarty->assign("f3f_records",$f3f_records);
	$smarty->assign("f3b_records",$f3b_records);
	$smarty->assign("f3b_distance",$f3b_distance);

	$smarty->assign("plane",$plane);
	$smarty->assign("media",$media);
	$smarty->assign("rand",$rand);
	$smarty->assign("plane_attributes",$plane_attributes);
	$smarty->assign("comments",$comments);
	$smarty->assign("comments_num",count($comments));
	$smarty->assign("disciplines",$disciplines);

	$maintpl=find_template("plane_view.tpl");
	return $smarty->fetch($maintpl);
}
function plane_save() {
	global $smarty;

	$plane=array();
	if(isset($_REQUEST['plane_id'])){
		$plane['plane_id']=intval($_REQUEST['plane_id']);
	}else{
		$plane['plane_id']=0;
	}
	if(isset($_REQUEST['plane_name'])){
		$plane['plane_name']=$_REQUEST['plane_name'];
	}
	if(isset($_REQUEST['plane_type_id'])){
		$plane['plane_type_id']=$_REQUEST['plane_type_id'];
	}else{
		$plane['plane_type_id']=0;
	}
	if(isset($_REQUEST['plane_wingspan'])){
		$plane['plane_wingspan']=$_REQUEST['plane_wingspan'];
	}else{
		$plane['plane_wingspan']=0;
	}
	if(isset($_REQUEST['plane_wingspan_units'])){
		$plane['plane_wingspan_units']=$_REQUEST['plane_wingspan_units'];
	}else{
		$plane['plane_wingspan_units']='';
	}
	if(isset($_REQUEST['plane_length'])){
		$plane['plane_length']=$_REQUEST['plane_length'];
	}else{
		$plane['plane_length']=0;
	}
	if(isset($_REQUEST['plane_length_units'])){
		$plane['plane_length_units']=$_REQUEST['plane_length_units'];
	}else{
		$plane['plane_length_units']='';
	}
	if(isset($_REQUEST['plane_root_chord_length'])){
		$plane['plane_root_chord_length']=$_REQUEST['plane_root_chord_length'];
	}else{
		$plane['plane_root_chord_length']=0;
	}
	if(isset($_REQUEST['plane_auw_from'])){
		$plane['plane_auw_from']=$_REQUEST['plane_auw_from'];
	}else{
		$plane['plane_auw_from']=0;
	}
	if(isset($_REQUEST['plane_auw_units'])){
		$plane['plane_auw_units']=$_REQUEST['plane_auw_units'];
	}else{
		$plane['plane_auw_units']='';
	}
	if(isset($_REQUEST['plane_auw_to'])){
		$plane['plane_auw_to']=$_REQUEST['plane_auw_to'];
	}else{
		$plane['plane_auw_to']=0;
	}
	if(isset($_REQUEST['plane_wing_area'])){
		$plane['plane_wing_area']=$_REQUEST['plane_wing_area'];
	}else{
		$plane['plane_wing_area']=0;
	}
	if(isset($_REQUEST['plane_tail_area'])){
		$plane['plane_tail_area']=$_REQUEST['plane_tail_area'];
	}else{
		$plane['plane_tail_area']=0;
	}
	if(isset($_REQUEST['plane_wing_area_units'])){
		$plane['plane_wing_area_units']=$_REQUEST['plane_wing_area_units'];
	}else{
		$plane['plane_wing_area_units']='';
	}
	if(isset($_REQUEST['plane_manufacturer'])){
		$plane['plane_manufacturer']=$_REQUEST['plane_manufacturer'];
	}else{
		$plane['plane_manufacturer']='';
	}
	if(isset($_REQUEST['plane_year'])){
		$plane['plane_year']=$_REQUEST['plane_year'];
	}else{
		$plane['plane_year']='';
	}
	if(isset($_REQUEST['plane_website'])){
		$plane['plane_website']=$_REQUEST['plane_website'];
	}else{
		$plane['plane_website']='';
	}
	if(isset($_REQUEST['country_id'])){
		$plane['country_id']=$_REQUEST['country_id'];
	}else{
		$plane['country_id']=0;
	}

	if($plane['plane_name']=='' || !preg_match("/\S/",$plane['plane_name'])){
		user_message("You must enter a plane name in the Plane Name field.",1);
		return plane_edit();
	}

	if($plane['plane_id']==0){
		# Create a new plane record
		unset($plane['plane_id']);
		$stmt=db_prep("
			INSERT INTO plane
			SET plane_name=:plane_name,
				plane_type_id=:plane_type_id,
				plane_wingspan=:plane_wingspan,
				plane_wingspan_units=:plane_wingspan_units,
				plane_length=:plane_length,
				plane_length_units=:plane_length_units,
				plane_root_chord_length=:plane_root_chord_length,
				plane_wing_area=:plane_wing_area,
				plane_tail_area=:plane_tail_area,
				plane_wing_area_units=:plane_wing_area_units,
				plane_manufacturer=:plane_manufacturer,
				plane_year=:plane_year,
				plane_website=:plane_website,
				plane_auw_from=:plane_auw_from,
				plane_auw_units=:plane_auw_units,
				plane_auw_to=:plane_auw_to,
				country_id=:country_id
		");
		$result=db_exec($stmt,$plane);
		# Set the old plane_id back for the rest of the routine
		$plane['plane_id']=$GLOBALS['last_insert_id'];
		$_REQUEST['plane_id']=$plane['plane_id'];
	}else{
		# Update the existing record
		$stmt=db_prep("
			UPDATE plane
			SET plane_name=:plane_name,
				plane_type_id=:plane_type_id,
				plane_wingspan=:plane_wingspan,
				plane_wingspan_units=:plane_wingspan_units,
				plane_length=:plane_length,
				plane_length_units=:plane_length_units,
				plane_root_chord_length=:plane_root_chord_length,
				plane_wing_area=:plane_wing_area,
				plane_tail_area=:plane_tail_area,
				plane_wing_area_units=:plane_wing_area_units,
				plane_manufacturer=:plane_manufacturer,
				plane_year=:plane_year,
				plane_website=:plane_website,
				plane_auw_from=:plane_auw_from,
				plane_auw_units=:plane_auw_units,
				plane_auw_to=:plane_auw_to,
				country_id=:country_id
			WHERE plane_id=:plane_id
		");
		$result=db_exec($stmt,$plane);
	}

	# Now save the attributes that this plane has

	# Lets clear out all of the attribute values that this plane has
	$stmt=db_prep("
		UPDATE plane_att_value
		SET plane_att_value_status=0
		WHERE plane_id=:plane_id
	");
	$result=db_exec($stmt,array("plane_id"=>$plane['plane_id']));
	
	# Now lets step through the attributes and see if they are turned on and add them or update them
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^plane_att_(\d+)/",$key,$match)){
				$id=$match[1];
				if($value=='On' || $value=='on'){
					$value=1;
				}
		}else{
			continue;
		}

		# ok, lets see if a record with that id exists
		$stmt=db_prep("
			SELECT *
			FROM plane_att_value pav
			WHERE plane_id=:plane_id
				AND plane_att_id=:plane_att_id
		");
		$result=db_exec($stmt,array("plane_att_id"=>$id,"plane_id"=>$plane['plane_id']));
		if($result){
			# There is already a record, so lets update it
			$plane_att_value_id=$result[0]['plane_att_value_id'];
			# Only update it if the value is not null
			if($value!=''){
				$stmt=db_prep("
					UPDATE plane_att_value
					SET plane_att_value_value=:value,
						plane_att_value_status=1
					WHERE plane_att_value_id=:plane_att_value_id
				");
				$result2=db_exec($stmt,array("value"=>$value,"plane_att_value_id"=>$plane_att_value_id));
			}
		}else{
			# There is not a record so lets make one
			if($value!=''){
				$stmt=db_prep("
					INSERT INTO plane_att_value
					SET plane_id=:plane_id,
						plane_att_id=:plane_att_id,
						plane_att_value_value=:value,
						plane_att_value_status=1
				");
				$result2=db_exec($stmt,array("plane_id"=>$plane['plane_id'],"plane_att_id"=>$id,"value"=>$value));
			}
		}
	}
	# Lets clear out all of the discipline values that this plane has
	$stmt=db_prep("
		UPDATE plane_discipline
		SET plane_discipline_status=0
		WHERE plane_id=:plane_id
	");
	$result=db_exec($stmt,array("plane_id"=>$plane['plane_id']));
	
	# Now lets step through the disciplines and see if they are turned on and add them or update them
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^disc_(\d+)/",$key,$match)){
				$id=$match[1];
				if($value=='On' || $value=='on'){
					$value=1;
				}
		}else{
			continue;
		}

		# ok, lets see if a record with that id exists
		$stmt=db_prep("
			SELECT *
			FROM plane_discipline
			WHERE plane_id=:plane_id
				AND discipline_id=:discipline_id
		");
		$result=db_exec($stmt,array("discipline_id"=>$id,"plane_id"=>$plane['plane_id']));
		if($result){
			# There is already a record, so lets update it
			$plane_discipline_id=$result[0]['plane_discipline_id'];
			# Only update it if the value is not null
			if($value!=''){
				$stmt=db_prep("
					UPDATE plane_discipline
					SET plane_discipline_status=1
					WHERE plane_discipline_id=:plane_discipline_id
				");
				$result2=db_exec($stmt,array("plane_discipline_id"=>$plane_discipline_id));
			}
		}else{
			# There is not a record so lets make one
			if($value!=''){
				$stmt=db_prep("
					INSERT INTO plane_discipline
					SET plane_id=:plane_id,
						discipline_id=:discipline_id,
						plane_discipline_status=1
				");
				$result2=db_exec($stmt,array("plane_id"=>$plane['plane_id'],"discipline_id"=>$id));
			}
		}
	}
	log_action($plane_id);
	user_message("Plane Information Saved");
	# Lets see if they came from somewhere else to add this plane
	if(isset($_REQUEST['from_action'])){
		# This came from somewhere else, so go back to that screen
		# But lets add the new plane id to the list
		$from['plane_id']=$plane['plane_id'];
		$from['plane_name']=$plane['plane_name'];
		$from['from_action']='plane';
		return return_to_action($from);
	}else{
		return plane_view();
	}
}
function plane_media_edit() {
	global $smarty;
	global $user;

	if($GLOBALS['user_id']==0){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit Plane information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		return $smarty->fetch($maintpl);
	}
		
	$plane_id=$_REQUEST['plane_id'];
	
	$stmt=db_prep("
		SELECT *
		FROM plane p
		WHERE p.plane_id=:plane_id
	");
	$result=db_exec($stmt,array("plane_id"=>$plane_id));
	$plane=$result[0];
	
	$smarty->assign("plane",$plane);
	$smarty->assign("plane_id",$plane_id);
	$maintpl=find_template("plane_edit_media.tpl");
	return $smarty->fetch($maintpl);
}
function plane_media_add() {
	global $smarty;
	global $user;

	if($GLOBALS['user_id']==0){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit plane information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		return $smarty->fetch($maintpl);
	}
		
	$plane_id=$_REQUEST['plane_id'];
	$plane_media_type=$_REQUEST['plane_media_type'];
	$plane_media_caption=$_REQUEST['plane_media_caption'];
	
	if($plane_media_type=='picture'){
		# Lets upload the file and put it in place
		$tempname=$_FILES['uploaded_file']['tmp_name'];
		$name=basename(preg_replace("/\s/","\_",$_FILES['uploaded_file']['name']));
		# Lets make the directory for this plane_id if it doesn't exist
		if(!is_dir("{$GLOBALS['base_webroot']}{$GLOBALS['base_plane_media']}/$plane_id")){
			# Create the directory
			mkdir("{$GLOBALS['base_webroot']}{$GLOBALS['base_plane_media']}/$plane_id",0770);
		}
		# Now copy the file into place
		if(file_exists("{$GLOBALS['base_webroot']}{$GLOBALS['base_plane_media']}/$plane_id/$name")){
			user_message("A media file with that name already exists, please choose another and try again!");
			return plane_edit();
		}
		if(move_uploaded_file($tempname, "{$GLOBALS['base_webroot']}{$GLOBALS['base_plane_media']}/$plane_id/$name")) {
			user_message("File $name uploaded.");
		}else{
			user_message("There was an error uploading the file, please try again!");
			return plane_edit();
		}
		$plane_media_url="{$GLOBALS['base_plane_media']}/$plane_id/$name";
	}else{
		$plane_media_url=$_REQUEST['plane_media_url'];
	}

	# Insert the database record for this media
	$media=array();
	$stmt=db_prep("
		INSERT INTO plane_media
		SET plane_id=:plane_id,
			plane_media_type=:plane_media_type,
			plane_media_caption=:plane_media_caption,
			plane_media_url=:plane_media_url,
			user_id=:user_id,
			plane_media_status=1
	");
	$result=db_exec($stmt,array("plane_id"=>$plane_id,"plane_media_type"=>$plane_media_type,"plane_media_url"=>$plane_media_url,"plane_media_caption"=>$plane_media_caption,"user_id"=>$GLOBALS['user']['user_id']));

	log_action($plane_id);
	user_message("Added your $plane_media_type media!");
	return plane_edit();
}
function plane_media_del() {
	global $user;

	$plane_id=$_REQUEST['plane_id'];
	$plane_media_id=$_REQUEST['plane_media_id'];

	# Check to see if they are the owner if this media so they cannot delete someone else's media
	$stmt=db_prep("
		SELECT *
		FROM plane_media
		WHERE plane_media_id=:plane_media_id
	");
	$result=db_exec($stmt,array("plane_media_id"=>$plane_media_id));
	if($result[0]['user_id']!=$GLOBALS['user']['user_id']){
		user_message("You are not allowed to remove media that you did not upload.",1);
		return plane_edit();
	}
	# del this media entry
	$stmt=db_prep("
		UPDATE plane_media
		SET plane_media_status=0
		WHERE plane_media_id=:plane_media_id
	");
	$result=db_exec($stmt,array("plane_media_id"=>$plane_media_id));
	log_action($plane_id);
	user_message("Removed plane media.");
	return plane_edit();
}
function plane_comment_add() {
	global $smarty;
	global $user;

	if($GLOBALS['user_id']==0){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit plane information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		return $smarty->fetch($maintpl);
	}
		
	$plane_id=$_REQUEST['plane_id'];
	
	$stmt=db_prep("
		SELECT *
		FROM plane l
		WHERE l.plane_id=:plane_id
	");
	$result=db_exec($stmt,array("plane_id"=>$plane_id));
	$plane=$result[0];
	
	$smarty->assign("plane",$plane);
	$smarty->assign("plane_id",$plane_id);
	$maintpl=find_template("plane_comment.tpl");
	return $smarty->fetch($maintpl);
}
function plane_comment_save() {
	global $smarty;
	global $user;

	if($GLOBALS['user_id']==0){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to Edit plane information.",1);
		$maintpl=find_template("feature_requires_login.tpl");
		return $smarty->fetch($maintpl);
	}
		
	$plane_id=$_REQUEST['plane_id'];
	$plane_comment_string=$_REQUEST['plane_comment_string'];
	
	# Insert the database record for this comment
	$stmt=db_prep("
		INSERT INTO plane_comment
		SET plane_id=:plane_id,
			user_id=:user_id,
			plane_comment_date=now(),
			plane_comment_string=:plane_comment_string
	");
	$result=db_exec($stmt,array("plane_id"=>$plane_id,"user_id"=>$GLOBALS['user_id'],"plane_comment_string"=>$plane_comment_string));

	user_message("Added your plane comment!");
	return plane_view();
}
?>
