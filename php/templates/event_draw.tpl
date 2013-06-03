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
});
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
	<h2 style="color:red;">Under Construction...</h2>
<h1 class="post-title entry-title">Draws
		<input type="button" value=" Back To Event View " onClick="goback.submit();" class="block-button">
</h1>
	
<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw_create">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="flight_type_id" value="0">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%" nowrap>Flight Type</th>
	<th width="5%" nowrap>Current</th>
	<th width="10%" nowrap>Round From</th>
	<th width="10%" nowrap>Round To</th>
	<th nowrap>Statistics</th>
	<th width="5%" nowrap>Action</th>
</tr>
{foreach $event->flight_types as $ft}
<tr>
	<th width="20%" nowrap>{$ft.flight_type_name}</th>
	{if $event->draws|count==0}
		<td colspan="4">No draws created</td>
	{else}
		<td align="center"><input type="checkbox"></td>
		<td></td>
		<td></td>
		<td></td>
	{/if}
	<td>
	</td>
</tr>
{/foreach}
<tr>
	<td colspan="6">
		{foreach $event->flight_types as $ft}
		<input type="button" value=" Create {$ft.flight_type_name} Draw " onClick="document.main.flight_type_id.value={$ft.flight_type_id};submit();" class="block-button">
		{/foreach}
	</td>
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
		<option value="html">HTML</option>
		<option value="pdf">PDF</option>
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

