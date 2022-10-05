{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}
<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Event Copy</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
</div>
<div class="panel" style="background-color:#337ab7;">
	<div class="panel-body">
		<div class="tab-base" style="margin-top: 10px;">
			<ul class="nav nav-tabs">
				<li{if $tab==0} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-0" aria-expanded="true" {if $tab==0}aria-selected="true"{/if}>
						Copy Event
					</a>
				</li>
			</ul>
			<div class="tab-content">
				<div id="pilot-tab-0" class="tab-pane fade{if $tab==0} active in{/if}">
					<h2 style="float:left;">Existing Event</h2>					
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
					<tr>
						<th width="15%" nowrap>Existing Event</th>
						<td>
							{$event->info.event_name|escape}
						</td>
					</tr>
					<tr>
						<th nowrap>Existing Date</th>
						<td>
							{$event->info.event_start_date|date_format:"Y-m-d"} to {$event->info.event_end_date|date_format:"Y-m-d"}
						</td>
					</tr>
					<tr>
						<th nowrap>Existing Location</th>
						<td>
							{$event->info.location_name}
						</td>
					</tr>
					<tr>
						<th nowrap>Existing Pilots</th>
						<td>
							{$event->pilots|count}
						</td>
					</tr>
					<tr>
						<th nowrap>Existing Scored Rounds</th>
						<td>
							{$event->rounds|count}
						</td>
					</tr>
					</table>
					<h2 style="float:left;">New Event</h2>					

					<form name="main" method="POST">
					<input type="hidden" name="action" value="event">
					<input type="hidden" name="function" value="event_copy">
					<input type="hidden" name="event_id" value="{$event->info.event_id}">
					<input type="hidden" name="location_id" value="{$event->info.location_id}">
					<input type="hidden" name="event_cd" value="{$event->info.event_cd|escape}">
					<input type="hidden" name="series_id" value="{$event->info.series_id}">
					<input type="hidden" name="club_id" value="{$event->info.club_id}">
					<input type="hidden" name="copy_event" value="1">
					<input type="hidden" name="event_reg_flag" value="0">
					<input type="hidden" name="event_notes" value="">
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
					<tr>
						<th width="15%" nowrap>Event Name</th>
						<td>
							<input type="text" size="60" name="event_name" value="{$event->info.event_name|escape} - Copy">
						</td>
					</tr>
					<tr>
						<th nowrap>Location</th>
						<td>
							<input type="text" id="location_name" name="location_name" size="40" value="{$event->info.location_name|escape}">
							<img id="loading_location" src="/images/loading.gif" style="vertical-align: middle;display: none;">
							<span id="search_message" style="font-style: italic;color: grey;">Start typing to search locations</span>
						</td>
					</tr>
					<tr>
						<th nowrap>Dates</th>
						<td>
							{html_select_date prefix="event_start_date" start_year="-15" end_year="+3" day_format="%02d" time=$event->info.event_start_date} to 
							{html_select_date prefix="event_end_date" start_year="-15" end_year="+3" day_format="%02d" time=$event->info.event_end_date}
						</td>
					</tr>
					<tr>
						<th nowrap>Type</th>
						<td>
						<select name="event_type_id">
						{foreach $event_types as $t}
							<option value="{$t.event_type_id}" {if $event->info.event_type_id==$t.event_type_id}SELECTED{/if}>{$t.event_type_name|escape}</option>
						{/foreach}
						</select>
						</td>
					</tr>
					<tr>
						<th nowrap>Contest Director</th>
						<td>
							<input type="text" id="event_cd_name" name="event_cd_name" size="40" value="{if $event->info.event_cd_name!=''}{$event->info.event_cd_name|escape}{else}{if $event->info.pilot_first_name!=''}{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape}{/if}{/if}">
							<img id="loading_cd" src="/images/loading.gif" style="vertical-align: middle;display: none;">
							<span id="cd_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
						</td>
					</tr>
					<tr>
						<th nowrap>Club Association</th>
						<td>
							<input type="text" id="club_name" name="club_name" size="50" value="{$event->info.club_name|escape}">
							<img id="loading_club" src="/images/loading.gif" style="vertical-align: middle;display: none;">
							<span id="club_message" style="font-style: italic;color: grey;">Start typing to search clubs</span>
						</td>
					</tr>
					<tr>
						<th nowrap>Viewing Ability</th>
						<td>
						<select name="event_view_status">
							<option value="1" {if $event->info.event_view_status==1}SELECTED{/if}>&nbsp;Public Event : Viewable By All</option>
							<option value="2" {if $event->info.event_view_status==2}SELECTED{/if}>Private Event : Viewable Only By Participants</option>
							<option value="3" {if $event->info.event_view_status==3}SELECTED{/if}>Private Event : Viewable Only By Creator</option>
						</select>
						</td>
					</tr>
					<tr>
						<th nowrap>Registration Status</th>
						<td>
						
						<select name="event_reg_flag">
							<option value="0" {if $event->info.event_reg_flag==0}SELECTED{/if}>Pilots Are Not Allowed to Register for this Event</option>
							<option value="1" {if $event->info.event_reg_flag==1}SELECTED{/if}>Pilots Are Allowed to Register for this Event</option>
						</select>
						</td>
					</tr>
					<tr>
						<th>Register Teams</th>
						<td>
							<input type="checkbox" name="event_reg_teams"{if $event->info.event_reg_teams} CHECKED{/if}> Allow Pilot to Enter Team Names During Registration
						</td>
					</tr>
					<tr>
						<th nowrap valign="top">Event Notes</th>
						<td>
						<textarea cols="100" rows="10" name="event_notes">{$event->info.event_notes}</textarea>
						</td>
					</tr>
					<tr>
						<th nowrap valign="top">Copy Options</th>
						<td>
							<input type="checkbox" name="copy_registration" CHECKED> Copy All Registration Parameters<br>
							{if $event->pilots|count > 0}
							<input type="checkbox" name="copy_pilots"> Copy All Pilots<br>
							{/if}
							{if $event->tasks|count > 0}
							<input type="checkbox" name="copy_tasks"> Copy All Tasks<br>
							{/if}
							{if $event->draws|count > 0}
							<input type="checkbox" name="copy_draws"> Copy All Draws<br>
							{/if}
							{if $event->rounds|count > 0}
							<input type="checkbox" name="copy_rounds"> Copy All Scoring Rounds<br>
							{/if}
							{if $event_users|count > 0}
							<input type="checkbox" name="copy_admin"> Copy All Admin Users<br>
							{/if}
						</td>
					</tr>
					<tr>
						<td colspan="3" style="text-align: center;">
							<input type="submit" value=" Copy This Event " class="btn btn-primary btn-rounded" onClick="return check_event();">
						</td>
					</tr>
					</table>
					</form>
				</div>

			</div>
		</div>
	</div>
	<br>
</div>
				
<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
{if $event->info.event_id==0}
<input type="hidden" name="function" value="event_list">
{else}
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="tab" value="">
{/if}
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
<input type="hidden" name="from_club_id" value="">
<input type="hidden" name="from_club_name" value="">
<input type="hidden" name="from_event_reg_flag" value="">
<input type="hidden" name="from_event_notes" value="">
</form>
<form name="create_new_series" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_edit">
<input type="hidden" name="series_id" value="0">
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
<input type="hidden" name="from_event_reg_flag" value="">
<input type="hidden" name="from_event_notes" value="">
</form>

{/block}
{block name="footer"}
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script src="/new/plugins/bootstrap-datepicker/bootstrap-datepicker.js"></script>
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
			document.event_series.series_id.value = ui.item.id;
		},
		   change: function( event, ui ) {
			   if(document.event_series.series_name.value==''){
				document.event_series.series_id.value = 0;
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
function check_event(){
	if(document.main.location_id.value==0 || document.main.location_id.value==''){
		alert('You must choose or add a valid location for this event before saving it.');
		return false;
	}
	if((document.main.club_id.value==0 ||document.main.club_id.value=='') && document.main.club_name.value!=''){
		alert('The club that you typed in does not exist. Please add a new club using the New Club button, or leave this field blank.');
		return false;
	}
	return true;
}
</script>
{/literal}
{/block}
