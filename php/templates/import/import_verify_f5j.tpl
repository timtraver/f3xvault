{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">F3X Event Import Step 2</h2>
	</div>
	<div class="panel-body">

		<h3 class="post-title entry-title">Verify Import</h3>
		<form name="main" method="POST">
		<input type="hidden" name="action" value="import">
		<input type="hidden" name="function" value="import_import_gliderscore_f5j">
		<input type="hidden" name="event_id" value="{$event.event_id|escape}">
		<input type="hidden" name="event_type_id" value="{$event.event_type_id|escape}">
		<input type="hidden" name="event_type_code" value="{$event.event_type_code|escape}">
		<input type="hidden" name="event_zero_round" value="{$event.event_zero_round|escape}">
		<input type="hidden" name="event_start_date" value="{$event.event_start_date|escape}">
		<input type="hidden" name="event_end_date" value="{$event.event_end_date|escape}">
		<input type="hidden" name="event_cd" value="{$event.event_cd|escape}">
		<input type="hidden" name="location_id" value="{$event.location_id|escape}">
		<input type="hidden" name="club_id" value="{$event.club_id|escape}">
		<input type="hidden" name="series_id" value="0">
		
		Verify the imported information from the file and set additional information.
		
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
			<th colspan="2">Event Type</th>
			<td colspan="5">
				{$event.event_type_code|escape} - {$event.event_type_name|escape} {if $event.f3f_group == 1} (with groups){/if}
			</td>
		</tr>
		<tr>
			<th colspan="2">Event Name</th>
			<td colspan="5">
				<input type="text" id="event_name" name="event_name" size="60" value="{$event.event_name|escape}"> 
				<img id="loading_event" src="/images/loading.gif" style="vertical-align: middle;display: none;">
				{if $event.event_id != 0}
					<font color="green">Matches Existing Event</font>
				{else}
					<span id="event_message" style="font-style: italic;color: grey;">Start typing to search events</span>
				{/if}
			</td>
		</tr>
		<tr>
			<th colspan="2">Event Dates</th>
			<td colspan="5">
				{html_select_date prefix="event_start_date" start_year="-15" end_year="+3" day_format="%02d" time=$event.event_start_date} to 
				{html_select_date prefix="event_end_date" start_year="-15" end_year="+3" day_format="%02d" time=$event.event_end_date}
			</td>
		</tr>
		<tr>
			<th colspan="2">Contest Director</th>
			<td colspan="5">
				<input type="text" id="event_cd_name" name="event_cd_name" size="40" value="{$event.cd_name|escape}">
				<img id="loading_cd" src="/images/loading.gif" style="vertical-align: middle;display: none;">
				<span id="cd_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
			</td>
		</tr>
		<tr>
			<th colspan="2">Event Location</th>
			<td colspan="5">
				<input type="text" id="location_name" name="location_name" size="40" value="{$event.location_name|escape}">
				<img id="loading_location" src="/images/loading.gif" style="vertical-align: middle;display: none;">
				<span id="location_message" style="font-style: italic;color: grey;">Start typing to search locations</span>
			</td>
		</tr>
		<tr>
			<th colspan="2">Event Club</th>
			<td colspan="5">
				<input type="text" id="club_name" name="club_name" size="40" value="{$event.club_name|escape}">
				<img id="loading_club" src="/images/loading.gif" style="vertical-align: middle;display: none;">
				<span id="club_message" style="font-style: italic;color: grey;">Start typing to search clubs</span>
			</td>
		</tr>
		<tr>
			<th colspan="2">Event Series</th>
			<td colspan="5">
				<input type="text" id="series_name" name="series_name" size="40" value="">
				<img id="loading_series" src="/images/loading.gif" style="vertical-align: middle;display: none;">
				<span id="series_message" style="font-style: italic;color: grey;">Start typing to search series</span>
			</td>
		</tr>
		{if $event.event_type_code=='f3k' || $event.event_type_code=='f3j' || $event.event_type_code=='td' || $event.event_type_code=='f5j'}
		<tr>
			<th colspan="2">Flyoff Rounds</th>
			<td colspan="5">
				<input type="checkbox" name="flyoff"> Import this file as a set of flyoff rounds
			</td>
		</tr>
		{/if}
		{if $event.event_type_code=='f3f'}
		<tr>
			<th colspan="2">Zero Round</th>
			<td colspan="5">
				<input type="checkbox" name="event_zero_round"> This event has a zero round
			</td>
		</tr>
		{/if}
		<tr>
			<th colspan="4" style="text-align: center">Data Import</th>
			<th colspan="5" style="text-align: center">Example Import Round 1</th>
		</tr>
		<tr>
			<th></th>
			<th>Pilot Name</th>
			<th>Pilot Lookup</th>
			<th>Pilot Class</th>
			<th style="text-align: right;">Grp</th>
			<th style="text-align: right;">Flight</th>
			<th style="text-align: right;">Land</th>
			<th style="text-align: right;">Height</th>
			<th style="text-align: right;">Pen</th>
		</tr>
		{$line_number=1}
		{foreach $pilots as $p}
		<tr>
			<th>{$line_number|escape}</th>
			<td>
				{$p.pilot_name|escape}
				<input type="hidden" name="pilot_name_{$line_number|escape}" value="{$p.pilot_name|escape}">
				{foreach $p.rounds as $r}
					{$round=$r@key}
					<input type="hidden" name="pilot_{$line_number|escape}_round_{$round|escape}_group" value="{$r.group|escape}">
					<input type="hidden" name="pilot_{$line_number|escape}_round_{$round|escape}_time" value="{$r.time|escape}">
					<input type="hidden" name="pilot_{$line_number|escape}_round_{$round|escape}_land" value="{$r.land|escape}">
					<input type="hidden" name="pilot_{$line_number|escape}_round_{$round|escape}_height" value="{$r.height|escape}">
					<input type="hidden" name="pilot_{$line_number|escape}_round_{$round|escape}_pen" value="{$r.penalty|escape}">
				{/foreach}
			</td>
			<td>
				{if $p.found==1}<img src="/images/icons/accept.png">{else}<img src="/images/icons/exclamation.png">{/if}
				<select name="pilot_id_{$line_number|escape}">
				{foreach $p.potentials as $pt}
					<option value="{$pt.pilot_id|escape}" {if $pt.pilot_full_name==$p.pilot_name}SELECTED{/if}>{$pt.pilot_full_name|escape}{if $pt.pilot_id!=0} - {$pt.pilot_city|escape},{$pt.state_code|escape} {$pt.country_code|escape}{/if}</option>
				{/foreach}
				</select>
			</td>
			<td>
				<select name="pilot_class_id_{$line_number|escape}">
				{foreach $classes as $c}
					<option value="{$c.class_id|escape}" {if $c.class_id==$p.class_id}SELECTED{/if}>{$c.class_description|escape}</option>
				{/foreach}
				</select>
			</td>
			<td align="right">{$p.rounds.1.group|escape}</td>
			<td align="right">{$p.rounds.1.time}</td>
			<td align="right">{$p.rounds.1.land|escape}</td>
			<td align="right">{$p.rounds.1.height|escape}</td>
			<td align="right">{$p.rounds.1.penalty|escape}</td>
		</tr>
		{$line_number=$line_number+1}
		{/foreach}
		</table>
		<center>
			<input type="button" value=" Cancel Import " class="btn btn-primary btn-rounded" onClick="goback.submit();">
			<input type="submit" value=" Import This Data " class="btn btn-primary btn-rounded">
		</center>
		</form>
		<br>
		
		<form name="goback" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_list">
		</form>

	</div>
</div>
{/block}
{block name="footer"}
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
{literal}
<script>
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
   			var mes=document.getElementById('location_message');
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
				mes.innerHTML = ' No Results Found.';
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
				mes.innerHTML = ' No Results Found.';
			}
		}
	});
});
</script>
{/literal}
{/block}
