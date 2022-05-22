{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}
<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Event Edit</h2>
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
						Basic Event Parameters
					</a>
				</li>
				{if $event->info.event_id!=0}
				<li{if $tab==1} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-1" aria-expanded="true" {if $tab==1}aria-selected="true"{/if}>
						Advanced Parameters
					</a>
				</li>
				{/if}
				{if $event->info.event_reg_flag != 0}
				<li>
					<a href="#pilot-tab-4" onclick="document.main.function.value = 'event_reg_edit';document.main.submit();">
						Registration Parameters
					</a>
				</li>
				{/if}
				{if $event->info.event_id!=0}
				<li{if $tab==2} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-2" aria-expanded="false" {if $tab==2}aria-selected="true"{/if}>
						Event Series
					</a>
				</li>
				<li{if $tab==3} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-3" aria-expanded="false" {if $tab==3}aria-selected="true"{/if}>
						Admin Access
					</a>
				</li>
				{/if}
			</ul>
			<div class="tab-content">
				<div id="pilot-tab-0" class="tab-pane fade{if $tab==0} active in{/if}">
					<h2 style="float:left;">Basic Event Parameters</h2>
					<form name="main" method="POST">
					<input type="hidden" name="action" value="event">
					<input type="hidden" name="function" value="event_save">
					<input type="hidden" name="event_id" value="{$event->info.event_id}">
					<input type="hidden" name="location_id" value="{$event->info.location_id}">
					<input type="hidden" name="event_cd" value="{$event->info.event_cd|escape}">
					<input type="hidden" name="series_id" value="{$event->info.series_id}">
					<input type="hidden" name="club_id" value="{$event->info.club_id}">
					<input type="hidden" name="tab" value="0">
					<input type="hidden" name="save_first" value="1">
					{if $event->info.event_id==0}
					<input type="hidden" name="event_reg_flag" value="0">
					<input type="hidden" name="event_notes" value="">
					{/if}
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
					<tr>
						<th nowrap>Event Name</th>
						<td>
							<input type="text" size="60" name="event_name" value="{$event->info.event_name|escape}">
						</td>
					</tr>
					<tr>
						<th nowrap>Location</th>
						<td>
							<input type="text" id="location_name" name="location_name" size="40" value="{$event->info.location_name|escape}">
							<img id="loading_location" src="/images/loading.gif" style="vertical-align: middle;display: none;">
							<span id="search_message" style="font-style: italic;color: grey;">Start typing to search locations</span>
							<div class="btn-group btn-group-xs" style="float: right;"><button class="btn btn-primary btn-rounded" type="button" onclick="copy_location_values(); create_new_location.submit();"> + Create New Location </button></div>
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
							<div class="btn-group btn-group-xs" style="float: right;"><button class="btn btn-primary btn-rounded" type="button" onclick="copy_cd_values(); create_new_cd.submit();"> + New CD </button></div>
						</td>
					</tr>
					<tr>
						<th nowrap>Club Association</th>
						<td>
							<input type="text" id="club_name" name="club_name" size="50" value="{$event->info.club_name|escape}">
							<img id="loading_club" src="/images/loading.gif" style="vertical-align: middle;display: none;">
							<span id="club_message" style="font-style: italic;color: grey;">Start typing to search clubs</span>
							<div class="btn-group btn-group-xs" style="float: right;"><button class="btn btn-primary btn-rounded" type="button" onclick="copy_club_values(); create_new_club.submit();"> + New Club </button></div>
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
					{if $event->info.event_id!=0}
					<tr>
						<th nowrap>Registration Status</th>
						<td>
						
						<select name="event_reg_flag" onChange="reg_check();">
							<option value="0" {if $event->info.event_reg_flag==0}SELECTED{/if}>Pilots Are Not Allowed to Register for this Event</option>
							<option value="1" {if $event->info.event_reg_flag==1}SELECTED{/if}>Pilots Are Allowed to Register for this Event</option>
						</select>
							<div class="btn-group btn-group-xs" style="float: right;"><button class="btn btn-primary btn-rounded" id="reg_button" type="button" onclick="document.main.function.value = 'event_reg_edit';document.main.submit();"> Registration Parameters </button></div>
						</td>
					</tr>
					<tr>
						<th nowrap valign="top">Event Notes</th>
						<td>
						<textarea cols="100" rows="15" name="event_notes">{$event->info.event_notes}</textarea>
						</td>
					</tr>
					<tr>
						<th nowrap valign="top">Allowed Classes</th>
						<td>
							{foreach $classes as $c}
								<input type="checkbox" name="class_{$c.class_id}" {if $c.event_class_status==1}CHECKED{/if}> {$c.class_description}<br>
							{/foreach}
						</td>
					</tr>
					{/if}
					<tr>
						<td colspan="3" style="text-align: center;">
							<input type="submit" value=" Save This Event Info " class="btn btn-primary btn-rounded" onClick="return check_event();">
						</td>
					</tr>
					</table>
					</form>
				</div>
				{if $event->info.event_id!=0}
				<div id="pilot-tab-1" class="tab-pane fade{if $tab==1} active in{/if}">
					<h2 style="float:left;">Advanced Parameters</h2>
					<form name="event_options" method="POST">
					<input type="hidden" name="action" value="event">
					<input type="hidden" name="function" value="event_param_save">
					<input type="hidden" name="event_id" value="{$event->info.event_id}">
					<input type="hidden" name="tab" value="1">
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
					<tr>
						<th colspan="2" align="left">The Following Specific Parameters Are for this {$event->info.event_type_name|escape} Event</th>
					</tr>
					{foreach $event->options as $o}
					<tr>
						<th align="right" width="30%">
							{$o.event_type_option_name|escape} - <a href="#" class="tooltip_e" onClick="return false;">(?)
								<span>
								<img class="callout" src="/images/callout.gif">
								<strong>Parameter Detail</strong>
								<table>
								<tr>
									<td>{$o.event_type_option_description|escape}</td>
								</tr>
								</table>
								</span>
								</a>
						</th>
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
						<td colspan="2" style="text-align: center;">
							<input type="submit" value=" Save These Event Parameters " class="btn btn-primary btn-rounded">
						</td>
					</tr>
					
					</table>
					</form>
				</div>
				{/if}
				<div id="pilot-tab-2" class="tab-pane fade{if $tab==2} active in{/if}">
					<h2 style="float:left;">Event Series Parameters</h2>
					<form name="event_series" method="POST">
					<input type="hidden" name="action" value="event">
					<input type="hidden" name="function" value="event_series_save">
					<input type="hidden" name="event_id" value="{$event->info.event_id}">
					<input type="hidden" name="series_id" value="">
					<input type="hidden" name="tab" value="2">
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
					<tr>
						<th align="left">Series Name</th>
						<th align="left">Action</th>
					</tr>
					{if !$event->series}
					<tr>
						<td colspan="2" align="left" bgcolor="white"><b>Not currently linked to any series.</b></td>
					</tr>
					{/if}
					{foreach $event->series as $s}
					<tr>
						<td align="left" bgcolor="white">{$s.series_name|escape}</td>
						<td bgcolor="white">
							<a href="?action=event&function=event_series_delete&event_id={$event->info.event_id}&event_series_id={$s.event_series_id}&tab=2"><img src="/images/del.gif"></a>
						</td>
					</tr>
					{/foreach}
					<tr>
						<th align="left" colspan="2">
						<b>Add To Series : </b>
							<input type="text" id="series_name" name="series_name" size="50" value="">
							<img id="loading_series" src="/images/loading.gif" style="vertical-align: middle;display: none;">
							<span id="series_message" style="font-style: italic;color: grey;">Start typing to search series</span>
							<div class="btn-group btn-group-xs" style="float: right;"><button class="btn btn-primary btn-rounded" type="button" onclick="create_new_series.submit();"> + Create New Series </button></div>
						</th>
					</tr>
					<tr>
						<td colspan="2" style="text-align: center;">
							<input type="submit" value=" Save Event Series " class="btn btn-primary btn-rounded">
						</td>
					</tr>
					
					</table>
					</form>
				</div>
				<div id="pilot-tab-3" class="tab-pane fade{if $tab==3} active in{/if}">
					<h2 style="float:left;">Event Admin Access</h2>
					<form name="event_user_add" method="POST">
					<input type="hidden" name="action" value="event">
					<input type="hidden" name="function" value="event_user_save">
					<input type="hidden" name="event_id" value="{$event->info.event_id}">
					<input type="hidden" name="pilot_id" value="">
					<input type="hidden" name="tab" value="3">
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
					<tr>
						<th colspan="2" align="left">The Following Users Have Access To Edit This Event</th>
					</tr>
					{foreach $event_users as $u}
					<tr>
						<td bgcolor="white">{$u.pilot_first_name|escape} {$u.pilot_last_name|escape} - {$u.pilot_city|escape}, {$u.state_code|escape} {$u.country_code|escape}</td>
						<td width="2%" bgcolor="white">
							{if $user['user_id'] == $u['user_id']}
								Event Owner
							{elseif $u['user_id'] == $event->info.event_cd}
								Contest Director
							{else}
								<a href="?action=event&function=event_user_delete&event_id={$event->info.event_id}&event_user_id={$u.event_user_id}&tab=3"><img src="/images/del.gif"></a>
							{/if}
						</td>
					</tr>
					{/foreach}
					<tr>
						<th colspan="2">
							Add New User 
							<input type="text" id="event_user_name" name="event_user_name" size="40">
							<img id="loading_pilot" src="/images/loading.gif" style="vertical-align: middle;display: none;">
							<span id="user_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
							<div class="btn-group btn-group-xs" style="float: right;"><button class="btn btn-primary btn-rounded" type="button" onclick="document.event_user_add.submit();"> Add This User </button></div>
						</th>
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
	document.create_new_location.from_club_id.value=document.main.club_id.value;
	document.create_new_location.from_club_name.value=document.main.club_name.value;
	document.create_new_location.from_event_reg_flag.value=document.main.event_reg_flag.value;
	document.create_new_location.from_event_notes.value=document.main.event_notes.value;
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
	document.create_new_cd.from_event_reg_flag.value=document.main.event_reg_flag.value;
	document.create_new_cd.from_event_notes.value=document.main.event_notes.value;
}
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
<script>
reg_check();
</script>
{/literal}
{/block}
