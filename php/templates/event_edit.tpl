<script src="/includes/jquery.min.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#location_name").autocomplete({
		source: "/lookup.php?function=lookup_location",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_location');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.main.location_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.main.location_name.value==''){
				document.main.location_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_location');
			loading.style.display = "none";
   			var mes=document.getElementById('search_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new location.';
			}
		}
	});
	$("#event_cd_name").autocomplete({
		source: "/lookup.php?function=lookup_pilot",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_cd');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.main.event_cd.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.main.event_cd_name.value==''){
				document.main.event_cd.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_cd');
			loading.style.display = "none";
   			var mes=document.getElementById('cd_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new CD.';
			}
		}
	});
	$("#series_name").autocomplete({
		source: "/lookup.php?function=lookup_series",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_series');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.main.series_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.main.series_name.value==''){
				document.main.series_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_series');
			loading.style.display = "none";
   			var mes=document.getElementById('series_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new series.';
			}
		}
	});
	$("#club_name").autocomplete({
		source: "/lookup.php?function=lookup_club",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_club');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.main.club_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.main.club_name.value==''){
				document.main.club_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_club');
			loading.style.display = "none";
   			var mes=document.getElementById('club_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new club.';
			}
		}
	});
	$("#event_user_name").autocomplete({
		source: "/lookup.php?function=lookup_pilot",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_pilot');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.event_user_add.pilot_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.event_user_add.event_user_name.value==''){
				document.event_user_add.pilot.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_pilot');
			loading.style.display = "none";
   			var mes=document.getElementById('user_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
});
function copy_location_values(){
	document.create_new_location.location_name.value=document.main.location_name.value;
	document.create_new_location.from_event_name.value=document.main.event_name.value;
	document.create_new_location.from_event_start_dateMonth.value=document.main.event_start_dateMonth.value;
	document.create_new_location.from_event_start_dateDay.value=document.main.event_start_dateDay.value;
	document.create_new_location.from_event_start_dateYear.value=document.main.event_start_dateYear.value;
	document.create_new_location.from_event_end_dateMonth.value=document.main.event_end_dateMonth.value;
	document.create_new_location.from_event_end_dateDay.value=document.main.event_end_dateDay.value;
	document.create_new_location.from_event_end_dateYear.value=document.main.event_end_dateYear.value;
	document.create_new_location.from_event_type_id.value=document.main.event_type_id.value;
	document.create_new_location.from_event_cd.value=document.main.event_cd.value;
	document.create_new_location.from_event_cd_name.value=document.main.event_cd_name.value;
	document.create_new_location.from_series_id.value=document.main.series_id.value;
	document.create_new_location.from_series_name.value=document.main.series_name.value;
	document.create_new_location.from_club_id.value=document.main.club_id.value;
	document.create_new_location.from_club_name.value=document.main.club_name.value;
	document.create_new_location.from_event_reg_flag.value=document.main.event_reg_flag.value;
	document.create_new_location.from_event_notes.value=document.main.event_notes.value;
}
function copy_series_values(){
	document.create_new_series.series_name.value=document.main.series_name.value;
	document.create_new_series.from_location_name.value=document.main.location_name.value;
	document.create_new_series.from_location_id.value=document.main.location_id.value;
	document.create_new_series.from_event_name.value=document.main.event_name.value;
	document.create_new_series.from_event_start_dateMonth.value=document.main.event_start_dateMonth.value;
	document.create_new_series.from_event_start_dateDay.value=document.main.event_start_dateDay.value;
	document.create_new_series.from_event_start_dateYear.value=document.main.event_start_dateYear.value;
	document.create_new_series.from_event_end_dateMonth.value=document.main.event_end_dateMonth.value;
	document.create_new_series.from_event_end_dateDay.value=document.main.event_end_dateDay.value;
	document.create_new_series.from_event_end_dateYear.value=document.main.event_end_dateYear.value;
	document.create_new_series.from_event_type_id.value=document.main.event_type_id.value;
	document.create_new_series.from_event_cd.value=document.main.event_cd.value;
	document.create_new_series.from_event_cd_name.value=document.main.event_cd_name.value;
	document.create_new_series.from_club_id.value=document.main.club_id.value;
	document.create_new_series.from_club_name.value=document.main.club_name.value;
	document.create_new_series.from_event_reg_flag.value=document.main.event_reg_flag.value;
	document.create_new_series.from_event_notes.value=document.main.event_notes.value;
}
function copy_club_values(){
	document.create_new_club.club_name.value=document.main.club_name.value;
	document.create_new_club.from_location_name.value=document.main.location_name.value;
	document.create_new_club.from_location_id.value=document.main.location_id.value;
	document.create_new_club.from_event_name.value=document.main.event_name.value;
	document.create_new_club.from_event_start_dateMonth.value=document.main.event_start_dateMonth.value;
	document.create_new_club.from_event_start_dateDay.value=document.main.event_start_dateDay.value;
	document.create_new_club.from_event_start_dateYear.value=document.main.event_start_dateYear.value;
	document.create_new_club.from_event_end_dateMonth.value=document.main.event_end_dateMonth.value;
	document.create_new_club.from_event_end_dateDay.value=document.main.event_end_dateDay.value;
	document.create_new_club.from_event_end_dateYear.value=document.main.event_end_dateYear.value;
	document.create_new_club.from_event_type_id.value=document.main.event_type_id.value;
	document.create_new_club.from_event_cd.value=document.main.event_cd.value;
	document.create_new_club.from_event_cd_name.value=document.main.event_cd_name.value;
	document.create_new_club.from_series_id.value=document.main.series_id.value;
	document.create_new_club.from_series_name.value=document.main.series_name.value;
	document.create_new_club.from_event_reg_flag.value=document.main.event_reg_flag.value;
	document.create_new_club.from_event_notes.value=document.main.event_notes.value;
}
function copy_cd_values(){
	document.create_new_cd.pilot_name.value=document.main.event_cd_name.value;
	document.create_new_series.from_club_id.value=document.main.club_id.value;
	document.create_new_series.from_club_name.value=document.main.club_name.value;
	document.create_new_cd.from_location_name.value=document.main.location_name.value;
	document.create_new_cd.from_location_id.value=document.main.location_id.value;
	document.create_new_cd.from_event_name.value=document.main.event_name.value;
	document.create_new_cd.from_event_start_dateMonth.value=document.main.event_start_dateMonth.value;
	document.create_new_cd.from_event_start_dateDay.value=document.main.event_start_dateDay.value;
	document.create_new_cd.from_event_start_dateYear.value=document.main.event_start_dateYear.value;
	document.create_new_cd.from_event_end_dateMonth.value=document.main.event_end_dateMonth.value;
	document.create_new_cd.from_event_end_dateDay.value=document.main.event_end_dateDay.value;
	document.create_new_cd.from_event_end_dateYear.value=document.main.event_end_dateYear.value;
	document.create_new_cd.from_event_type_id.value=document.main.event_type_id.value;
	document.create_new_cd.from_series_id.value=document.main.series_id.value;
	document.create_new_cd.from_series_name.value=document.main.series_name.value;
	document.create_new_cd.from_event_reg_flag.value=document.main.event_reg_flag.value;
	document.create_new_cd.from_event_notes.value=document.main.event_notes.value;
}
function check_event(){
	if(document.main.location_id.value==0 || document.main.location_id.value==''){
		alert('You must choose or add a valid location for this event before saving it.');
		return false;
	}
	if((document.main.series_id.value==0 || document.main.series_id.value=='') && document.main.series_name.value!=''){
		alert('The series that you typed in does not exist. Please add a new series using the New Series button, or leave this field blank.');
		return false;
	}
	if((document.main.club_id.value==0 ||document.main.club_id.value=='') && document.main.club_name.value!=''){
		alert('The club that you typed in does not exist. Please add a new club using the New Club button, or leave this field blank.');
		return false;
	}
	return true;
}
function reg_check(){
	var reg=document.getElementById('reg_button');
	if(document.main.event_reg_flag.value==1){
		reg.style.display="inline";
	}else{
		reg.style.display="none";
	}
	return;
}
</script>
{/literal}

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">F3X Event Edit
			<input type="button" value=" Back To Event {if $event->info.event_id!=0}View{else}List{/if} " onClick="goback.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Basic Event Parameters</h1>
<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_save">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="location_id" value="{$event->info.location_id}">
<input type="hidden" name="event_cd" value="{$event->info.event_cd|escape}">
<input type="hidden" name="series_id" value="{$event->info.series_id}">
<input type="hidden" name="club_id" value="{$event->info.club_id}">
{if $event->info.event_id==0}
<input type="hidden" name="event_reg_flag" value="0">
<input type="hidden" name="event_notes" value="">
{/if}
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Event Name</th>
	<td>
		<input type="text" size="60" name="event_name" value="{$event->info.event_name|escape}">
	</td>
</tr>
<tr>
	<th>Location</th>
	<td>
		<input type="text" id="location_name" name="location_name" size="40" value="{$event->info.location_name|escape}">
		<img id="loading_location" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="search_message" style="font-style: italic;color: grey;">Start typing to search locations</span>
		<input type="button" value=" + New Location " class="block-button" onClick="copy_location_values(); create_new_location.submit();">
	</td>
</tr>
<tr>
	<th>Dates</th>
	<td>
	{html_select_date prefix="event_start_date" start_year="-15" end_year="+3" day_format="%02d" time=$event->info.event_start_date} to 
	{html_select_date prefix="event_end_date" start_year="-15" end_year="+3" day_format="%02d" time=$event->info.event_end_date}
	</td>
</tr>
<tr>
	<th>Type</th>
	<td>
	<select name="event_type_id">
	{foreach $event_types as $t}
		<option value="{$t.event_type_id}" {if $event->info.event_type_id==$t.event_type_id}SELECTED{/if}>{$t.event_type_name|escape}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Contest Director</th>
	<td>
		<input type="text" id="event_cd_name" name="event_cd_name" size="40" value="{if $event->info.event_cd_name!=''}{$event->info.event_cd_name|escape}{else}{if $event->info.pilot_first_name!=''}{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape}{/if}{/if}">
		<img id="loading_cd" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="cd_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
		<input type="button" value=" + New CD " class="block-button" onClick="copy_cd_values(); create_new_cd.submit();">
	</td>
</tr>
<tr>
	<th>Part of Series</th>
	<td>
		<input type="text" id="series_name" name="series_name" size="50" value="{$event->info.series_name}">
		<img id="loading_series" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="series_message" style="font-style: italic;color: grey;">Start typing to search series</span>
		<input type="button" value=" + New Series " class="block-button" onClick="copy_series_values(); create_new_series.submit();">
	</td>
</tr>
<tr>
	<th>Club Association</th>
	<td>
		<input type="text" id="club_name" name="club_name" size="50" value="{$event->info.club_name|escape}">
		<img id="loading_club" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="club_message" style="font-style: italic;color: grey;">Start typing to search clubs</span>
		<input type="button" value=" + New Club " class="block-button" onClick="copy_club_values(); create_new_club.submit();">
	</td>
</tr>
<tr>
	<th>Viewing Ability</th>
	<td>
	<select name="event_view_status">
		<option value="1" {if $event->info.event_view_status==1}SELECTED{/if}>&nbsp;Public Event : Viewable By All</option>
		<option value="2" {if $event->info.event_view_status==2}SELECTED{/if}>Private Event : Viewable Only By Participants</option>
		<option value="3" {if $event->info.event_view_status==3}SELECTED{/if}>Private Event : Viewable Only By Creator</option>
	</select>
	</td>
</tr>
{if $event->info.event_id!=0}
<tr>
	<th>Registration Status</th>
	<td>
	
	<select name="event_reg_flag" onChange="reg_check();">
		<option value="0" {if $event->info.event_reg_flag==0}SELECTED{/if}>Pilots Are Not Allowed to Register for this Event</option>
		<option value="1" {if $event->info.event_reg_flag==1}SELECTED{/if}>Pilots Are Allowed to Register for this Event</option>
	</select>
		<input type="button" id="reg_button" class="button" value=" Registration Parameters " style="float:right;" onclick="reg_params.submit();">
	</td>
</tr>
<tr>
	<th valign="top">Event Notes</th>
	<td>
	<textarea cols="70" rows="4" name="event_notes">{$event->info.event_notes}</textarea>
	</td>
</tr>
<tr>
	<th valign="top">Allowed Classes</th>
	<td>
		{foreach $classes as $c}
			<input type="checkbox" name="class_{$c.class_id}" {if $c.event_class_status==1}CHECKED{/if}> {$c.class_description}<br>
		{/foreach}
	</td>
</tr>
{/if}
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="submit" value=" Save This Event Info " class="block-button" onClick="return check_event();">
	</th>
</tr>
</table>
</form>

{if $event->info.event_id!=0}
<h1 class="post-title entry-title">Advanced Event Parameters</h1>
<form name="event_options" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_param_save">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th colspan="2" align="left">The Following Specific Parameters Are for this {$event->info.event_type_name|escape}</th>
</tr>
{foreach $event->options as $o}
<tr>
	<th align="right" width="30%">{$o.event_type_option_name|escape} (<a href="#" title="{$o.event_type_option_description|escape}">?</a>)</th>
	<td>
		{if $o.event_type_option_type == 'boolean'}
				<input type="checkbox" name="option_{$o.event_type_option_id}" {if $o.event_option_status==1 && $o.event_option_value ==1}CHECKED{/if}>
		{else}
				<input type="text" name="option_{$o.event_type_option_id}" size="{$o.event_type_option_size}" value="{$o.event_option_value|escape}"> 
		{/if}
	</td>
</tr>
{/foreach}
<tr>
	<th colspan="2">
		<input type="submit" value=" Save These Event Parameters " class="block-button">
		<input type="button" class="button" value=" Event Draws " style="float:right;" onclick="{if $event->pilots|count==0}alert('You must enter pilots before you can create a draw for this event.');{else}event_draw.submit();{/if}">
		{if $event->pilots|count==0 && $event->info.event_type_code=='f3f'}
			<input type="button" value=" Import F3F Event " class="block-button" onClick="document.import_f3f.submit();">
		{/if}
		{if $event->info.event_type_code=='f3k'}
			<input type="button" value=" Import F3K Rounds " class="block-button" onClick="document.import_f3k.submit();">
		{/if}
	</th>
</tr>

</table>
</form>

<h1 class="post-title entry-title">Event Admin Access</h1>
<form name="event_user_add" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_user_save">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="pilot_id" value="">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th colspan="2" align="left">The Following Users Have Access To Edit This Event</th>
</tr>
{foreach $event_users as $u}
<tr>
	<td>{$u.pilot_first_name|escape} {$u.pilot_last_name|escape} - {$u.pilot_city|escape}, {$u.state_code|escape} {$u.country_code|escape}</td>
	<td width="2%">
		<a href="?action=event&function=event_user_delete&event_id={$event->info.event_id}&event_user_id={$u.event_user_id}"><img src="/images/del.gif"></a></td>
</tr>
{/foreach}
<tr>
	<th colspan="2">
		Add New User 
		<input type="text" id="event_user_name" name="event_user_name" size="40">
		<img id="loading_pilot" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="user_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
		<input type="submit" value=" Add This User " class="block-button">
	</th>
</tr>
</table>
</form>
{/if}
<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
{if $event->info.event_id==0}
<input type="hidden" name="function" value="event_list">
{else}
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<script>
reg_check();
</script>
{/if}
</form>
<form name="import_f3f" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_import">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="import_f3k" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_import_f3k">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="create_new_location" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
<input type="hidden" name="location_name" value="">
<input type="hidden" name="from_action" value="event">
<input type="hidden" name="from_function" value="event_edit">
<input type="hidden" name="from_event_id" value="{$event->info.event_id}">
<input type="hidden" name="from_event_name" value="">
<input type="hidden" name="from_event_start_dateMonth" value="{$pilot.pilot_id}">
<input type="hidden" name="from_event_start_dateDay" value="">
<input type="hidden" name="from_event_start_dateYear" value="">
<input type="hidden" name="from_event_end_dateMonth" value="{$pilot.pilot_id}">
<input type="hidden" name="from_event_end_dateDay" value="">
<input type="hidden" name="from_event_end_dateYear" value="">
<input type="hidden" name="from_event_type_id" value="">
<input type="hidden" name="from_event_cd" value="">
<input type="hidden" name="from_event_cd_name" value="">
<input type="hidden" name="from_series_id" value="">
<input type="hidden" name="from_series_name" value="">
<input type="hidden" name="from_club_id" value="">
<input type="hidden" name="from_club_name" value="">
<input type="hidden" name="from_event_reg_flag" value="">
<input type="hidden" name="from_event_notes" value="">
</form>
<form name="create_new_series" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_edit">
<input type="hidden" name="series_id" value="0">
<input type="hidden" name="series_name" value="">
<input type="hidden" name="from_action" value="event">
<input type="hidden" name="from_function" value="event_edit">
<input type="hidden" name="from_event_id" value="{$event->info.event_id}">
<input type="hidden" name="from_event_name" value="">
<input type="hidden" name="from_event_start_dateMonth" value="{$pilot.pilot_id}">
<input type="hidden" name="from_event_start_dateDay" value="">
<input type="hidden" name="from_event_start_dateYear" value="">
<input type="hidden" name="from_event_end_dateMonth" value="{$pilot.pilot_id}">
<input type="hidden" name="from_event_end_dateDay" value="">
<input type="hidden" name="from_event_end_dateYear" value="">
<input type="hidden" name="from_event_type_id" value="">
<input type="hidden" name="from_event_cd" value="">
<input type="hidden" name="from_event_cd_name" value="">
<input type="hidden" name="from_location_id" value="">
<input type="hidden" name="from_location_name" value="">
<input type="hidden" name="from_club_id" value="">
<input type="hidden" name="from_club_name" value="">
<input type="hidden" name="from_event_reg_flag" value="">
<input type="hidden" name="from_event_notes" value="">
</form>
<form name="create_new_club" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_edit">
<input type="hidden" name="club_id" value="0">
<input type="hidden" name="club_name" value="">
<input type="hidden" name="from_action" value="event">
<input type="hidden" name="from_function" value="event_edit">
<input type="hidden" name="from_event_id" value="{$event->info.event_id}">
<input type="hidden" name="from_event_name" value="">
<input type="hidden" name="from_event_start_dateMonth" value="{$pilot.pilot_id}">
<input type="hidden" name="from_event_start_dateDay" value="">
<input type="hidden" name="from_event_start_dateYear" value="">
<input type="hidden" name="from_event_end_dateMonth" value="{$pilot.pilot_id}">
<input type="hidden" name="from_event_end_dateDay" value="">
<input type="hidden" name="from_event_end_dateYear" value="">
<input type="hidden" name="from_event_type_id" value="">
<input type="hidden" name="from_event_cd" value="">
<input type="hidden" name="from_event_cd_name" value="">
<input type="hidden" name="from_location_id" value="">
<input type="hidden" name="from_location_name" value="">
<input type="hidden" name="from_series_id" value="">
<input type="hidden" name="from_series_name" value="">
<input type="hidden" name="from_event_reg_flag" value="">
<input type="hidden" name="from_event_notes" value="">
</form>
<form name="create_new_cd" method="POST">
<input type="hidden" name="action" value="pilot">
<input type="hidden" name="function" value="pilot_add_cd">
<input type="hidden" name="pilot_id" value="0">
<input type="hidden" name="pilot_name" value="">
<input type="hidden" name="club_id" value="0">
<input type="hidden" name="club_name" value="">
<input type="hidden" name="from_action" value="event">
<input type="hidden" name="from_function" value="event_edit">
<input type="hidden" name="from_event_id" value="{$event->info.event_id}">
<input type="hidden" name="from_event_name" value="">
<input type="hidden" name="from_event_start_dateMonth" value="{$pilot.pilot_id}">
<input type="hidden" name="from_event_start_dateDay" value="">
<input type="hidden" name="from_event_start_dateYear" value="">
<input type="hidden" name="from_event_end_dateMonth" value="{$pilot.pilot_id}">
<input type="hidden" name="from_event_end_dateDay" value="">
<input type="hidden" name="from_event_end_dateYear" value="">
<input type="hidden" name="from_event_type_id" value="">
<input type="hidden" name="from_location_id" value="">
<input type="hidden" name="from_location_name" value="">
<input type="hidden" name="from_series_id" value="">
<input type="hidden" name="from_series_name" value="">
<input type="hidden" name="from_event_reg_flag" value="">
<input type="hidden" name="from_event_notes" value="">
</form>

<form name="event_draw" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="reg_params" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_reg_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>


</div>
</div>
</div>

