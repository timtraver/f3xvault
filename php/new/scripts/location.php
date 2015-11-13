<?php
############################################################################
#	location.php
#
#	Tim Traver
#	8/31/12
#	This is the script to handle the location records
#
############################################################################
$smarty->assign("current_menu",'locations');

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
	$function=$_REQUEST['function'];
}else{
	$function="location_list";
}

$need_login=array(
	"location_edit",
	"location_save",
	"location_media_edit",
	"location_media_add",
	"location_media_del",
	"location_comment_add",
	"location_comment_save"
);
if(check_user_function($function)){
	if($GLOBALS['user_id']==0 && in_array($function, $need_login)){
		# The user is not logged in, so send the feature template
		user_message("Sorry, but you must be logged in as a user to use this feature.",1);
		$smarty->assign("redirect_action",$_REQUEST['action']);
		$smarty->assign("redirect_function",$_REQUEST['function']);
		$smarty->assign("request",$_REQUEST);
		$maintpl=find_template("feature_requires_login.tpl");
		$actionoutput=$smarty->fetch($maintpl);
	}else{
		# They are allowed
		eval("\$actionoutput=$function();");
	}
}else{
	 $actionoutput= show_no_permission();
}

function location_list() {
	global $smarty;

	$country_id=0;
	$state_id=0;
	$discipline_id=0;
	if(isset($_REQUEST['country_id'])){
		$country_id=intval($_REQUEST['country_id']);
		$GLOBALS['fsession']['country_id']=$country_id;
	}elseif(isset($GLOBALS['fsession']['country_id'])){
		$country_id=$GLOBALS['fsession']['country_id'];
	}
	if(isset($_REQUEST['state_id'])){
		$state_id=intval($_REQUEST['state_id']);
		$GLOBALS['fsession']['state_id']=$state_id;
	}elseif(isset($GLOBALS['fsession']['state_id'])){
		$state_id=$GLOBALS['fsession']['state_id'];
	}
	if(isset($_REQUEST['discipline_id'])){
		$discipline_id=intval($_REQUEST['discipline_id']);
		$GLOBALS['fsession']['discipline_id']=$discipline_id;
	}elseif(isset($GLOBALS['fsession']['discipline_id'])){
		$discipline_id=$GLOBALS['fsession']['discipline_id'];
	}

	$search='';
	if(isset($_REQUEST['search']) ){
		$search=$_REQUEST['search'];
		$GLOBALS['fsession']['search']=$_REQUEST['search'];
	}elseif(isset($GLOBALS['fsession']['search']) && $GLOBALS['fsession']['search']!=''){
		$search=$GLOBALS['fsession']['search'];
	}
	
	$addcountry='';
	if($country_id!=0){
		$addcountry.=" AND l.country_id=$country_id ";
	}
	$addstate='';
	if($state_id!=0){
		$addstate.=" AND l.state_id=$state_id ";
	}

	# Add search options for discipline
	$joind='';
	$extrad='';
	if($discipline_id!=0){
		$joind = 'LEFT JOIN location_discipline ld ON l.location_id=ld.location_id';
		$extrad = 'AND ld.discipline_id='.$discipline_id.' AND ld.location_discipline_status=1';
	}
	$locations=array();
	if($search!='%%' && $search!=''){
		$stmt=db_prep("
			SELECT l.*,c.*,s.*,
					cs.country_name as pilot_speed_country_name,
					cs.country_code as pilot_speed_country_code,
					es.event_name as pilot_speed_event_name,
					es.event_id as pilot_speed_event_id,
					es.event_start_date as pilot_speed_event_start_date,
					est.event_type_code as pilot_speed_event_type_code,
					ps.pilot_first_name as pilot_speed_first_name,
					ps.pilot_last_name as pilot_speed_last_name,
					
					cl.country_name as pilot_laps_country_name,
					cl.country_code as pilot_laps_country_code,
					el.event_name as pilot_laps_event_name,
					el.event_id as pilot_laps_event_id,
					el.event_start_date as pilot_laps_event_start_date,
					elt.event_type_code as pilot_laps_event_type_code,
					pl.pilot_first_name as pilot_laps_first_name,
					pl.pilot_last_name as pilot_laps_last_name
			FROM location l
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			
			LEFT JOIN event_pilot eps ON l.location_record_speed_event_pilot_id=eps.event_pilot_id
			LEFT JOIN pilot ps ON eps.pilot_id=ps.pilot_id
			LEFT JOIN country cs ON ps.country_id=cs.country_id
			LEFT JOIN event es ON eps.event_id=es.event_id
			LEFT JOIN event_type est ON es.event_type_id=est.event_type_id
			
			LEFT JOIN event_pilot epl ON l.location_record_distance_event_pilot_id=epl.event_pilot_id
			LEFT JOIN pilot pl ON epl.pilot_id=pl.pilot_id
			LEFT JOIN country cl ON pl.country_id=cl.country_id
			LEFT JOIN event el ON epl.event_id=el.event_id
			LEFT JOIN event_type elt ON el.event_type_id=elt.event_type_id

			$joind
			WHERE l.location_name LIKE :search
				$addcountry
				$addstate
				$extrad
			ORDER BY l.country_id,l.state_id,l.location_name
		");
		$locations=db_exec($stmt,array("search"=>'%'.$search.'%'));
	}else{
		# Get all locations for search
		$stmt=db_prep("
			SELECT l.*,c.*,s.*,
					cs.country_name as pilot_speed_country_name,
					cs.country_code as pilot_speed_country_code,
					es.event_name as pilot_speed_event_name,
					es.event_id as pilot_speed_event_id,
					es.event_start_date as pilot_speed_event_start_date,
					est.event_type_code as pilot_speed_event_type_code,
					ps.pilot_first_name as pilot_speed_first_name,
					ps.pilot_last_name as pilot_speed_last_name,
					
					cl.country_name as pilot_laps_country_name,
					cl.country_code as pilot_laps_country_code,
					el.event_name as pilot_laps_event_name,
					el.event_id as pilot_laps_event_id,
					el.event_start_date as pilot_laps_event_start_date,
					elt.event_type_code as pilot_laps_event_type_code,
					pl.pilot_first_name as pilot_laps_first_name,
					pl.pilot_last_name as pilot_laps_last_name
			FROM location l
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			
			LEFT JOIN event_pilot eps ON l.location_record_speed_event_pilot_id=eps.event_pilot_id
			LEFT JOIN pilot ps ON eps.pilot_id=ps.pilot_id
			LEFT JOIN country cs ON ps.country_id=cs.country_id
			LEFT JOIN event es ON eps.event_id=es.event_id
			LEFT JOIN event_type est ON es.event_type_id=est.event_type_id
			
			LEFT JOIN event_pilot epl ON l.location_record_distance_event_pilot_id=epl.event_pilot_id
			LEFT JOIN pilot pl ON epl.pilot_id=pl.pilot_id
			LEFT JOIN country cl ON pl.country_id=cl.country_id
			LEFT JOIN event el ON epl.event_id=el.event_id
			LEFT JOIN event_type elt ON el.event_type_id=elt.event_type_id
			$joind
			WHERE 1
				$addcountry
				$addstate
				$extrad
			ORDER BY l.country_id,l.state_id,l.location_name
		");
		$locations=db_exec($stmt,array());
	}
	
	# Get only countries that we have locations for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT country_id FROM location) l
		LEFT JOIN country c ON c.country_id=l.country_id
		WHERE c.country_id!=0
	");
	$countries=db_exec($stmt,array());
	# Get only states that we have locations for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT state_id FROM location) l
		LEFT JOIN state s ON s.state_id=l.state_id
		WHERE s.state_id!=0
	");
	$states=db_exec($stmt,array());
	
	$locations=show_pages($locations,"action=location&function=location_list");

	$smarty->assign("locations",$locations);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);
	$smarty->assign("disciplines",get_disciplines());

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl=find_template("location/location_list.tpl");
	return $smarty->fetch($maintpl);
}
function location_edit() {
	global $smarty;

	if(isset($_REQUEST['location_id'])){
		$location_id=$_REQUEST['location_id'];
	}

	if(isset($_REQUEST['location_name'])){
		$location_name=ucwords($_REQUEST['location_name']);
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

	# Get the previous view totals to show on top of tabs
	location_view();

	$location=array();
	if($location_id!=0){
		$stmt=db_prep("
			SELECT *
			FROM location l
			LEFT JOIN country c ON l.country_id=c.country_id
			LEFT JOIN state s ON l.state_id=s.state_id
			WHERE location_id=:location_id
		");
		$result=db_exec($stmt,array("location_id"=>$location_id));
		if($result){
			$location=$result[0];
		}
	}else{
		# Set the name
		$location['location_name']=$location_name;
	}
	
	# Get all of the base location attributes
	$location_attributes=array();
	$stmt=db_prep("
		SELECT *,la.location_att_id
		FROM location_att la
		LEFT JOIN location_att_cat lc ON lc.location_att_cat_id=la.location_att_cat_id
		WHERE la.location_att_status=1
		ORDER BY lc.location_att_cat_order,la.location_att_order
	");
	$location_attributes=db_exec($stmt,array());

	$stmt=db_prep("
		SELECT *
		FROM location_att_value
		WHERE location_id=:location_id
			AND location_att_value_status=1
	");
	$values=db_exec($stmt,array("location_id"=>$location_id));

	# Step through each of the values and put those entries into the location_attributes array
	foreach ($location_attributes as $key=>$att){
		$id=$att['location_att_id'];
		foreach($values as $value){
			if($value['location_att_id']==$id){
				$location_attributes[$key]['location_att_value_value']=$value['location_att_value_value'];
				$location_attributes[$key]['location_att_value_status']=$value['location_att_value_status'];
			}
		}
	}

	# Get location media records
	$media=array();
	$stmt=db_prep("
		SELECT *
		FROM location_media lm
		WHERE lm.location_id=:location_id
		AND lm.location_media_status=1
	");
	$media=db_exec($stmt,array("location_id"=>$location_id));

	# Get disciplines to select for this location
	$disciplines=get_disciplines(0);
	# Lets get the records that this location has
	$stmt=db_prep("
		SELECT *
		FROM location_discipline
		WHERE location_id=:location_id
			AND location_discipline_status=1
	");
	$values=db_exec($stmt,array("location_id"=>$location_id));
	# Step through each of the values and put those entries into the disciplines array
	foreach ($disciplines as $key=>$disc){
		$id=$disc['discipline_id'];
		foreach($values as $value){
			if($value['discipline_id']==$id){
				$disciplines[$key]['discipline_selected']=1;
			}
		}
	}

	$smarty->assign("location",$location);
	$smarty->assign("location_attributes",$location_attributes);
	$smarty->assign("media",$media);
	$smarty->assign("countries",get_countries());
	$smarty->assign("states",get_states());
	$smarty->assign("disciplines",$disciplines);

	$maintpl=find_template("location/location_edit.tpl");
	return $smarty->fetch($maintpl);
}
function location_view() {
	global $smarty;

	if(isset($_REQUEST['location_id'])){
		$location_id=$_REQUEST['location_id'];
	}
	$tab=0;
	if(isset($_REQUEST['tab'])){
		$tab=$_REQUEST['tab'];
	}
	
	$location=array();
	$stmt=db_prep("
		SELECT *
		FROM location l
		LEFT JOIN country c ON l.country_id=c.country_id
		LEFT JOIN state s ON l.state_id=s.state_id
		WHERE location_id=:location_id
	");
	$result=db_exec($stmt,array("location_id"=>$location_id));
	if($result){
		$location=$result[0];
	}
	
	# Get all of the base location attributes as well as the ones for this location
	$location_attributes=array();
	$stmt=db_prep("
		SELECT *
		FROM location_att_value lav
		LEFT JOIN location_att la ON lav.location_att_id=la.location_att_id
		LEFT JOIN location_att_cat lc ON lc.location_att_cat_id=la.location_att_cat_id
		WHERE lav.location_id=:location_id
			AND lav.location_att_value_status=1
		ORDER BY lc.location_att_cat_order,la.location_att_order
	");
	$location_attributes=db_exec($stmt,array("location_id"=>$location_id));

	# Get location media records
	$media=array();
	$stmt=db_prep("
		SELECT *
		FROM location_media lm
		LEFT JOIN user u ON lm.user_id=u.user_id
		WHERE lm.location_id=:location_id
		AND lm.location_media_status=1
	");
	$media=db_exec($stmt,array("location_id"=>$location_id));
	# Step thriough the media to get the user info for it
	foreach ($media as $key=>$m){
		if($m['user_id']!=0){
			$stmt=db_prep("
				SELECT *
				FROM pilot p
				WHERE p.user_id=:user_id
			");
			$result2=db_exec($stmt,array("user_id"=>$m['user_id']));
			if($result2[0]){
				# Add the user info to the array
				$media[$key]=array_merge($m,$result2[0]);
			}
		}
	}
	
	# Lets get a random picture to show on the front page of the location view
	if(count($media)>1){
		$count=0;
		do {
			$rand=array_rand($media);
			$count++;
		}while($media[$rand]['location_media_type']!='picture' && $count<10);
	}else{
		$rand=0;
	}
	
	# Get the location comments
	$comments=array();
	$stmt=db_prep("
		SELECT *
		FROM location_comment l
		LEFT JOIN user u ON l.user_id=u.user_id
		LEFT JOIN pilot p ON u.pilot_id=p.pilot_id
		LEFT JOIN state s ON p.state_id=s.state_id
		LEFT JOIN country c ON p.country_id=c.country_id
		WHERE l.location_id=:location_id
		ORDER BY l.location_comment_date DESC
	");
	$comments=db_exec($stmt,array("location_id"=>$location_id));

	# Lets get the disciplines that this location has
	$stmt=db_prep("
		SELECT *
		FROM location_discipline ld
		LEFT JOIN discipline d ON ld.discipline_id=d.discipline_id
		WHERE ld.location_id=:location_id
			AND ld.location_discipline_status=1
	");
	$disciplines=db_exec($stmt,array("location_id"=>$location_id));

	# Lets get the events locations
	$events=array();
	$stmt=db_prep("
		SELECT *,count(event_pilot_id) as total_pilots
		FROM event e
		LEFT JOIN event_type et ON e.event_type_id=et.event_type_id
		LEFT JOIN event_pilot ep ON e.event_id=ep.event_id
		WHERE e.location_id=:location_id
			AND ep.event_pilot_status=1
		GROUP by e.event_id
		ORDER BY e.event_start_date DESC
	");
	$events=db_exec($stmt,array("location_id"=>$location_id));
	$events=show_pages($events,"action=location&function=location_view&location_id={$location_id}");
	
	$smarty->assign("location",$location);
	$smarty->assign("location_attributes",$location_attributes);
	$smarty->assign("rand",$rand);
	$smarty->assign("media",$media);
	$smarty->assign("comments",$comments);
	$smarty->assign("comments_num",count($comments));
	$smarty->assign("disciplines",$disciplines);
	$smarty->assign("events",$events);
	$smarty->assign("tab",$tab);

	$maintpl=find_template("location/location_view.tpl");
	return $smarty->fetch($maintpl);
}
function location_save() {
	global $smarty;

	$location=array();
	if(isset($_REQUEST['location_id'])){
		$location['location_id']=intval($_REQUEST['location_id']);
	}else{
		$location['location_id']=0;
	}
	if(isset($_REQUEST['location_name'])){
		$location['location_name']=$_REQUEST['location_name'];
	}
	if(isset($_REQUEST['location_city'])){
		$location['location_city']=$_REQUEST['location_city'];
	}else{
		$location['location_city']='';
	}
	if(isset($_REQUEST['country_id'])){
		$location['country_id']=$_REQUEST['country_id'];
	}else{
		$location['country_id']=0;
	}
	if(isset($_REQUEST['state_id'])){
		$location['state_id']=$_REQUEST['state_id'];
	}else{
		$location['state_id']=0;
	}
	if(isset($_REQUEST['location_coordinates'])){
		$location['location_coordinates']=convert_coordinates($_REQUEST['location_coordinates']);
	}else{
		$location['location_coordinates']='';
	}
	if(isset($_REQUEST['location_club'])){
		$location['location_club']=$_REQUEST['location_club'];
	}else{
		$location['location_club']='';
	}
	if(isset($_REQUEST['location_club_url'])){
		$location['location_club_url']=$_REQUEST['location_club_url'];
	}else{
		$location['location_club_url']='';
	}
	if(isset($_REQUEST['location_description'])){
		$location['location_description']=$_REQUEST['location_description'];
	}else{
		$location['location_description']='';
	}
	if(isset($_REQUEST['location_directions'])){
		$location['location_directions']=$_REQUEST['location_directions'];
	}else{
		$location['location_directions']='';
	}

	if($location['location_name']=='' || !preg_match("/\S/",$location['location_name'])){
		user_message("You must enter a location name in the Location Name field.",1);
		return location_edit();
	}

	if($location['location_id']==0){
		# Create a new location record
		unset($location['location_id']);
		$stmt=db_prep("
			INSERT INTO location
			SET location_name=:location_name,
				location_city=:location_city,
				location_coordinates=:location_coordinates,
				location_club=:location_club,
				location_club_url=:location_club_url,
				location_description=:location_description,
				location_directions=:location_directions,
				country_id=:country_id,
				state_id=:state_id
		");
		$result=db_exec($stmt,$location);
		# Set the old location_id back for the rest of the routine
		$location['location_id']=$GLOBALS['last_insert_id'];
		$_REQUEST['location_id']=$location['location_id'];
	}else{
		# Update the existing record
		$stmt=db_prep("
			UPDATE location
			SET location_name=:location_name,
				location_city=:location_city,
				location_coordinates=:location_coordinates,
				location_club=:location_club,
				location_club_url=:location_club_url,
				location_description=:location_description,
				location_directions=:location_directions,
				country_id=:country_id,
				state_id=:state_id
			WHERE location_id=:location_id
		");
		$result=db_exec($stmt,$location);
	}

	# Now save the attributes that this location has

	# Lets clear out all of the attribute values that this location has
	$stmt=db_prep("
		UPDATE location_att_value
		SET location_att_value_status=0
		WHERE location_id=:location_id
	");
	$result=db_exec($stmt,array("location_id"=>$location['location_id']));
	
	# Now lets step through the attributes and see if they are turned on and add them or update them
	foreach($_REQUEST as $key=>$value){
		if(preg_match("/^location_att_(\d+)/",$key,$match)){
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
			FROM location_att_value lav
			WHERE location_id=:location_id
				AND location_att_id=:location_att_id
		");
		$result=db_exec($stmt,array("location_att_id"=>$id,"location_id"=>$location['location_id']));
		if($result){
			# There is already a record, so lets update it
			$location_att_value_id=$result[0]['location_att_value_id'];
			# Only update it if the value is not null
			if($value!=''){
				$stmt=db_prep("
					UPDATE location_att_value
					SET location_att_value_value=:value,
						location_att_value_status=1
					WHERE location_att_value_id=:location_att_value_id
				");
				$result2=db_exec($stmt,array("value"=>$value,"location_att_value_id"=>$location_att_value_id));
			}
		}else{
			# There is not a record so lets make one
			if($value!=''){
				$stmt=db_prep("
					INSERT INTO location_att_value
					SET location_id=:location_id,
						location_att_id=:location_att_id,
						location_att_value_value=:value,
						location_att_value_status=1
				");
				$result2=db_exec($stmt,array("location_id"=>$location['location_id'],"location_att_id"=>$id,"value"=>$value));
			}
		}
	}	
	# Lets clear out all of the discipline values that this location has
	$stmt=db_prep("
		UPDATE location_discipline
		SET location_discipline_status=0
		WHERE location_id=:location_id
	");
	$result=db_exec($stmt,array("location_id"=>$location['location_id']));
	
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
			FROM location_discipline
			WHERE location_id=:location_id
				AND discipline_id=:discipline_id
		");
		$result=db_exec($stmt,array("discipline_id"=>$id,"location_id"=>$location['location_id']));
		if($result){
			# There is already a record, so lets update it
			$location_discipline_id=$result[0]['location_discipline_id'];
			# Only update it if the value is not null
			if($value!=''){
				$stmt=db_prep("
					UPDATE location_discipline
					SET location_discipline_status=1
					WHERE location_discipline_id=:location_discipline_id
				");
				$result2=db_exec($stmt,array("location_discipline_id"=>$location_discipline_id));
			}
		}else{
			# There is not a record so lets make one
			if($value!=''){
				$stmt=db_prep("
					INSERT INTO location_discipline
					SET location_id=:location_id,
						discipline_id=:discipline_id,
						location_discipline_status=1
				");
				$result2=db_exec($stmt,array("location_id"=>$location['location_id'],"discipline_id"=>$id));
			}
		}
	}	
	log_action($location_id);
	user_message("Location Information Saved");
	if(isset($_REQUEST['from_action'])){
		# This came from somewhere else, so go back to that screen
		# But lets add the new location id to the list
		$from['location_id']=$location['location_id'];
		$from['location_name']=$location['location_name'];
		$from['from_action']='location';
		return return_to_action($from);
	}else{
		return location_view();
	}
}
function location_media_edit() {
	global $smarty;
	global $user;

	$location_id=$_REQUEST['location_id'];
	
	location_view();
	
	$maintpl=find_template("location/location_edit_media.tpl");
	return $smarty->fetch($maintpl);
}
function location_media_add() {
	global $smarty;
	global $user;

	$location_id=$_REQUEST['location_id'];
	$location_media_type=$_REQUEST['location_media_type'];
	$location_media_caption=$_REQUEST['location_media_caption'];
	
	if($location_media_type=='picture'){
		# Lets upload the file and put it in place
		$tempname=$_FILES['uploaded_file']['tmp_name'];
		$name=basename(preg_replace("/\s/","\_",$_FILES['uploaded_file']['name']));
		# Lets make the directory for this location_id if it doesn't exist
		if(!is_dir("{$GLOBALS['base_webroot']}{$GLOBALS['base_location_media']}/$location_id")){
			# Create the directory
			mkdir("{$GLOBALS['base_webroot']}{$GLOBALS['base_location_media']}/$location_id",0770);
		}
		# Now copy the file into place
		if(file_exists("{$GLOBALS['base_webroot']}{$GLOBALS['base_location_media']}/$location_id/$name")){
			user_message("A media file with that name already exists, please choose another and try again!",1);
			return location_edit();
		}
		if(move_uploaded_file($tempname, "{$GLOBALS['base_webroot']}{$GLOBALS['base_location_media']}/$location_id/$name")) {
			user_message("File $name uploaded.");
		}else{
			user_message("There was an error uploading the file, please try again! ($tempname)",1);
			return location_view();
		}
		$location_media_url="{$GLOBALS['base_location_media']}/$location_id/$name";
	}else{
		$location_media_url=$_REQUEST['location_media_url'];
	}

	# Insert the database record for this media
	$media=array();
	$stmt=db_prep("
		INSERT INTO location_media
		SET location_id=:location_id,
			location_media_type=:location_media_type,
			location_media_caption=:location_media_caption,
			location_media_url=:location_media_url,
			user_id=:user_id,
			location_media_status=1
	");
	$result=db_exec($stmt,array("location_id"=>$location_id,"location_media_type"=>$location_media_type,"location_media_url"=>$location_media_url,"location_media_caption"=>$location_media_caption,"user_id"=>$GLOBALS['user']['user_id']));

	log_action($location_id);
	user_message("Added your $location_media_type media!");
	return location_view();
}
function location_media_del() {
	global $user;

	$location_id=$_REQUEST['location_id'];
	$location_media_id=$_REQUEST['location_media_id'];

	# Check to see if they are the owner if this media so they cannot delete someone else's media
	$stmt=db_prep("
		SELECT *
		FROM location_media
		WHERE location_media_id=:location_media_id
	");
	$result=db_exec($stmt,array("location_media_id"=>$location_media_id));
	if($result[0]['user_id']!=$GLOBALS['user']['user_id']){
		user_message("You are not allowed to remove media that you did not upload.",1);
		return location_edit();
	}
	# del this media entry
	$stmt=db_prep("
		UPDATE location_media
		SET location_media_status=0
		WHERE location_media_id=:location_media_id
	");
	$result=db_exec($stmt,array("location_media_id"=>$location_media_id));
	log_action($location_id);
	user_message("Removed location media.");
	return location_edit();
}
function location_comment_add() {
	global $smarty;
	global $user;

	$location_id=$_REQUEST['location_id'];
	
	location_view();
	
	$maintpl=find_template("location/location_comment.tpl");
	return $smarty->fetch($maintpl);
}
function location_comment_save() {
	global $smarty;
	global $user;

	$location_id=$_REQUEST['location_id'];
	$location_comment_string=$_REQUEST['location_comment_string'];
	
	# Insert the database record for this comment
	$stmt=db_prep("
		INSERT INTO location_comment
		SET location_id=:location_id,
			user_id=:user_id,
			location_comment_date=now(),
			location_comment_string=:location_comment_string
	");
	$result=db_exec($stmt,array("location_id"=>$location_id,"user_id"=>$GLOBALS['user_id'],"location_comment_string"=>$location_comment_string));

	user_message("Added your location comment!");
	return location_view();
}
function location_map() {
	global $smarty;

	$country_id=0;
	$state_id=0;
	$discipline_id=0;
	if(isset($_REQUEST['country_id'])){
		$country_id=intval($_REQUEST['country_id']);
		$GLOBALS['fsession']['country_id']=$country_id;
	}elseif(isset($GLOBALS['fsession']['country_id'])){
		$country_id=$GLOBALS['fsession']['country_id'];
	}
	if(isset($_REQUEST['state_id'])){
		$state_id=intval($_REQUEST['state_id']);
		$GLOBALS['fsession']['state_id']=$state_id;
	}elseif(isset($GLOBALS['fsession']['state_id'])){
		$state_id=$GLOBALS['fsession']['state_id'];
	}
	if(isset($_REQUEST['discipline_id'])){
		$discipline_id=intval($_REQUEST['discipline_id']);
		$GLOBALS['fsession']['discipline_id']=$discipline_id;
	}elseif(isset($GLOBALS['fsession']['discipline_id'])){
		$discipline_id=$GLOBALS['fsession']['discipline_id'];
	}

	$search='';
	if(isset($_REQUEST['search']) ){
		$search=$_REQUEST['search'];
		$GLOBALS['fsession']['search']=$_REQUEST['search'];
	}elseif(isset($GLOBALS['fsession']['search']) && $GLOBALS['fsession']['search']!=''){
		$search=$GLOBALS['fsession']['search'];
	}

	$addcountry='';
	if($country_id!=0){
		$addcountry.=" AND l.country_id=$country_id ";
	}
	$addstate='';
	if($state_id!=0){
		$addstate.=" AND l.state_id=$state_id ";
	}

	# Add search options for discipline
	$joind='';
	$extrad='';
	if($discipline_id!=0){
		$joind = 'LEFT JOIN location_discipline ld ON l.location_id=ld.location_id';
		$extrad = 'AND ld.discipline_id='.$discipline_id.' AND ld.location_discipline_status=1';
	}

	$locations=array();
	if($search!='%%' && $search!=''){
		$stmt=db_prep("
			SELECT *
			FROM location l
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			$joind
			WHERE (l.location_coordinates IS NOT NULL AND l.location_coordinates!='')
				AND l.location_name LIKE :search
				$addcountry
				$addstate
				$extrad
			ORDER BY l.country_id,l.state_id,l.location_name
		");
		$locations=db_exec($stmt,array("search"=>'%'.$search.'%'));
	}else{
		# Get all locations for search
		$stmt=db_prep("
			SELECT *
			FROM location l
			LEFT JOIN state s ON l.state_id=s.state_id
			LEFT JOIN country c ON l.country_id=c.country_id
			$joind
			WHERE (l.location_coordinates IS NOT NULL AND l.location_coordinates!='')
				$addcountry
				$addstate
				$extrad
			ORDER BY l.country_id,l.state_id,l.location_name
		");
		$locations=db_exec($stmt,array());
	}
	
	
	# Get only countries that we have locations and location coordinates for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT country_id FROM location WHERE (location_coordinates IS NOT NULL AND location_coordinates!='') ) l
		LEFT JOIN country c ON c.country_id=l.country_id
		WHERE c.country_id!=0
	");
	$countries=db_exec($stmt,array());
	# Get only states that we have locations for
	$stmt=db_prep("
		SELECT *
		FROM ( SELECT DISTINCT state_id FROM location WHERE (location_coordinates IS NOT NULL AND location_coordinates!='') ) l
		LEFT JOIN state s ON s.state_id=l.state_id
		WHERE s.state_id!=0
	");
	$states=db_exec($stmt,array());
	
	# Lets reset the discipline for the top bar if needed
	set_disipline($discipline_id);
	
	$smarty->assign("locations",$locations);
	$smarty->assign("countries",$countries);
	$smarty->assign("states",$states);
	$smarty->assign("disciplines",get_disciplines());

	$smarty->assign("search",$GLOBALS['fsession']['search']);
	$smarty->assign("country_id",$GLOBALS['fsession']['country_id']);
	$smarty->assign("state_id",$GLOBALS['fsession']['state_id']);

	$maintpl=find_template("location/location_map.tpl");
	return $smarty->fetch($maintpl);
}
function location_calculate_records(){
	# Function to look at all of the events and calculate and save the records
	global $smarty;
	
	# Lets get all of the events so we can step through them
	$stmt=db_prep("
		SELECT e.event_name,e.event_start_date,e.event_type_id,l.location_id,l.location_name
		FROM event e
		LEFT JOIN location l ON e.location_id=l.location_id
		WHERE e.event_status=1
			AND e.event_type_id IN (1,2,3)
	");
	$results=db_exec($stmt,array());
	foreach($results as $e){
		# Ok, depending on the type of event, lets find the fastest time
		switch($e.event_type_id){
			case 1:
				# This is an F3F event
				$stmt=db_prep("
					SELECT e.event_name,erf.event_pilot_round_flight_seconds,ep.event_pilot_id,p.pilot_first_name,p.pilot_last_name,e.location_id
					FROM event_pilot_round_flight erf
					LEFT JOIN event_pilot_round epr ON erf.event_pilot_round_id=epr.event_pilot_round_id
					LEFT JOIN event_round er ON epr.event_round_id=er.event_round_id
					LEFT JOIN event_pilot ep ON epr.event_pilot_id=ep.event_pilot_id
					LEFT JOIN pilot p ON ep.pilot_id=p.pilot_id
					LEFT JOIN event e ON ep.event_id=e.event_id
					WHERE er.event_id=:event_id
						AND er.event_round_status=1
						AND erf.event_pilot_round_flight_status=1
						AND ep.event_pilot_status=1
						AND erf.event_pilot_round_flight_seconds!=0
					ORDER BY erf.event_pilot_round_flight_seconds
				");

				



			case 3:
				
		}
		
		
		
	}
	
	
	#	SELECT eprf.event_pilot_round_flight_seconds,eprf.event_pilot_round_flight_laps,ep.event_pilot_id,p.pilot_first_name,p.pilot_last_name,e.event_name
	#$results=db_exec($stmt,array());
	
	$smarty->assign("results",$results);
	$maintpl=find_template("admin_results.tpl");
	return $smarty->fetch($maintpl);
}
?>
