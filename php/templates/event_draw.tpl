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
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
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
}
</script>
{/literal}

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">{$event->info.event_name|escape} - Event Draw</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th align="right">Location</th>
			<td>
			<a href="?action=location&function=location_view&location_id={$event->info.location_id}">{$event->info.location_name|escape} - {$event->info.location_city|escape},{$event->info.state_code|escape} {$event->info.country_code|escape}</a>
			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			{$event->info.event_type_name|escape}
			</td>
			<th align="right">Event Contest Director</th>
			<td>
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape} - {$event->info.pilot_city|escape}
			</td>
		</tr>
		{if $event->info.series_name || $event->info.club_name}
		<tr>
			<th align="right">Part Of Series</th>
			<td>
			<a href="?action=series&function=series_view&series_id={$event->info.series_id}">{$event->info.series_name|escape}</a>
			</td>
			<th align="right">Club</th>
			<td>
			<a href="?action=club&function=club_view&club_id={$event->info.club_id}">{$event->info.club_name|escape}</a>
			</td>
		</tr>
		{/if}
		</table>
		
	</div>
	
	<br>
<h1 class="post-title entry-title">Draw Parameters</h1>
	
<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw_save">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%" nowrap>Current Number of Pilots</th>
	<td>
		{$event->pilots|count}
	</td>
</tr>
<tr>
	<th width="20%" nowrap>Current Number of Teams</th>
	<td>
		{$event->teams|count}
	</td>
</tr>
<tr>
	<th width="20%" nowrap>Optimum Pilots Per Team</th>
	<td>
		{round($event->pilots|count / $event->teams|count)}
	</td>
</tr>
<tr>
	<th width="20%" nowrap>Minimum Number of Flight Groups</th>
	<td>

	</td>
</tr>
<tr>
	<th width="20%" nowrap>Draws Currently in place</th>
	<td>

	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value=" Back To Event {if $event->info.event_id!=0}View{else}List{/if} " onClick="goback.submit();" class="block-button">
		<input type="submit" value=" Save Draw Parameters " class="block-button">
	</th>
</tr>
</table>
</form>

<h1 class="post-title entry-title">Printing Draws</h1>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
{foreach $event->flight_types as $ft}
<form name="print_{$ft.flight_type_id}" method="POST" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw_print">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="flight_type_id" value="{$ft.flight_type_id}">
<input type="hidden" name="print_type" value="">
<input type="hidden" name="use_print_header" value="1">
<tr>
	<th width="10%" nowrap>{$ft.flight_type_name}</th>
	<td>
		Rounds
		<select name="print_round_from">
		{foreach $event->rounds as $r}
		<option value="{$r.event_round_number}">{$r.event_round_number}</option>
		{/foreach}
		</select>
		To
		<select name="print_round_to">
		{foreach $event->rounds as $r}
		<option value="{$r.event_round_number}" {if $r@last}SELECTED{/if}>{$r.event_round_number}</option>
		{/foreach}
		</select>
		<select name="print_format">
		<option value="pdf">PDF</option>
		<option value="html">HTML</option>
		</select>
		<input type="button" value=" CD Recording Sheet " onClick="document.print_{$ft.flight_type_id}.print_type.value='cd';submit();" class="block-button">
		{if !$ft.flight_type_code|strstr:"speed" && !$ft.flight_type_code|strstr:"distance"}
		<input type="button" value=" Pilot Recording Sheets " onClick="document.print_{$ft.flight_type_id}.print_type.value='pilot';submit();" class="block-button">
		{/if}
		<input type="button" value=" Draw Table " onClick="document.print_{$ft.flight_type_id}.print_type.value='table';submit();" class="block-button">
		<input type="button" value=" Full Draw Matrix " onClick="document.print_{$ft.flight_type_id}.print_type.value='matrix';submit();" class="block-button">
	</td>
</tr>
</form>
{/foreach}
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>

</div>
</div>
</div>

