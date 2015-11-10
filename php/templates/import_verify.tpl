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
	$("#event_name").autocomplete({
		source: "/lookup.php?function=lookup_event",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_event');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.main.event_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.main.event_name.value==''){
				document.main.event_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_event');
			loading.style.display = "none";
   			var mes=document.getElementById('event_message');
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
	
	
	
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">F3X Event Import Step 1</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Import File for Event</h1>
<br>
<form name="main" method="POST">
<input type="hidden" name="action" value="import">
<input type="hidden" name="function" value="import_import">
<input type="hidden" name="event_id" value="{$event.event_id}">
<input type="hidden" name="event_type_id" value="{$event.event_type_id}">
<input type="hidden" name="event_type_code" value="{$event.event_type_code}">
<input type="hidden" name="event_zero_round" value="{$event.event_zero_round}">
<input type="hidden" name="event_start_date" value="{$event.event_start_date}">
<input type="hidden" name="event_end_date" value="{$event.event_end_date}">
<input type="hidden" name="event_cd" value="{$event.event_cd}">
<input type="hidden" name="location_id" value="{$event.location_id}">
{foreach $rounds as $r}
{$round=$r@key}
<input type="hidden" name="event_round_{$round}" value="{$r.flight_type_id}">
{if $r.target}
<input type="hidden" name="event_round_{$round}_target" value="{$r.target}">
{/if}
{/foreach}

Verify the imported information from the file and set additional information.

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th colspan="2">Event Type</th>
	<td colspan="5">
		{$event.event_type_code} - {$event.event_type_name}
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
	<th colspan="2">Event Location</th>
	<td colspan="5">
		<input type="text" id="location_name" name="location_name" size="40" value="{$event.location_name|escape}">
		<img id="loading_location" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="search_message" style="font-style: italic;color: grey;">Start typing to search locations</span>
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
{if $event.event_type_code=='f3k' || $event.event_type_code=='f3j' || $event.event_type_code=='td'}
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
{$num_cols=3}
{if $rounds.1.flight_type_landing==1}
	{$num_cols = $num_cols + 1}
{/if}
{if $rounds.1.flight_type_over_penalty==1}
	{$num_cols = $num_cols + 1}
{/if}
{$total_cols = 4 + $num_cols}
<tr>
	<th colspan="4">Data Import</th>
	<th colspan="{$num_cols}">Example Import Round 1</th>
</tr>
<tr>
	<th></th>
	<th>Pilot Name</th>
	<th>Pilot Lookup</th>
	<th>Pilot Class</th>
	<th>Grp</th>
	<th>Flight</th>
	{if $rounds.1.flight_type_landing==1}
	<th>Land</th>
	{/if}
	{if $rounds.1.flight_type_over_penalty==1}
	<th>Over</th>
	{/if}
	<th>Pen</th>
</tr>
{$line_number=1}
{foreach $pilots as $p}
<tr>
	<th>{$line_number}</th>
	<td>
		{$p.pilot_name}
		<input type="hidden" name="pilot_name_{$line_number}" value="{$p.pilot_name}">
		<input type="hidden" name="pilot_freq_{$line_number}" value="{$p.pilot_freq}">
		<input type="hidden" name="pilot_team_{$line_number}" value="{$p.pilot_team}">
		{foreach $p.rounds as $r}
			{$round=$r@key}
			<input type="hidden" name="pilot_{$line_number}_round_{$round}_group" value="{$r.group}">
			{foreach $r.flights.sub as $s}
				{$subnum=$s@key}
				<input type="hidden" name="pilot_{$line_number}_round_{$round}_sub_{$subnum}" value="{$s}">
			{/foreach}
			<input type="hidden" name="pilot_{$line_number}_round_{$round}_min" value="{$r.min}">
			<input type="hidden" name="pilot_{$line_number}_round_{$round}_sec" value="{$r.sec}">
			{if $rounds.1.flight_type_landing==1}
				<input type="hidden" name="pilot_{$line_number}_round_{$round}_land" value="{$r.land}">
			{/if}
			{if $rounds.1.flight_type_over_penalty==1}
				<input type="hidden" name="pilot_{$line_number}_round_{$round}_over" value="{$r.over}">
			{/if}
			<input type="hidden" name="pilot_{$line_number}_round_{$round}_pen" value="{$r.penalty}">
		{/foreach}
	</td>
	<td>
		{if $p.found==1}<img src="/images/icons/accept.png">{else}<img src="/images/icons/exclamation.png">{/if}
		<select name="pilot_id_{$line_number}">
		{foreach $p.potentials as $pt}
			<option value="{$pt.pilot_id}" {if $pt.pilot_full_name==$p.pilot_name}SELECTED{/if}>{$pt.pilot_full_name}{if $pt.pilot_id!=0} - {$pt.pilot_city},{$pt.state_code} {$pt.country_code}{/if}</option>
		{/foreach}
		</select>
	</td>
	<td>
		<select name="pilot_class_id_{$line_number}">
		{foreach $classes as $c}
			<option value="{$c.class_id}" {if $c.class_id==$p.class_id}SELECTED{/if}>{$c.class_description}</option>
		{/foreach}
		</select>
	</td>
	
	<td align="center">{$p.rounds.1.group}</td>
	<td align="center">
		{if $event.event_type_code=='f3j' || $event.event_type_code=='td'}
			{$p.rounds.1.min|string_format:"%d"}:{$p.rounds.1.sec|string_format:"%05.2f"}
		{else}
			{if $p.rounds.1.flights.sub}
				{foreach $p.rounds.1.flights.sub as $s}
					{$s}{if !$s@last},{/if}
				{/foreach}
			{else}
				{$p.rounds.1.flights.1}
			{/if}
		{/if}
	</td>
	{if $rounds.1.flight_type_landing==1}
	<td>{$p.rounds.1.land}</td>
	{/if}
	{if $rounds.1.flight_type_over_penalty==1}
	<td>{if $p.rounds.1.over}YES{/if}</td>
	{/if}
	<td align="center">{$p.rounds.1.penalty}</td>
</tr>
{$line_number=$line_number+1}
{/foreach}
<tr>
	<th colspan="{$total_cols}">
	<input type="button" value=" Cancel Import " class="block-button" onClick="goback.submit();">
	<input type="submit" value=" Import This Data " class="block-button">
	</th>
</tr>
</table>
</form>


<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>



</div>
</div>
</div>

