<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#pilot_name").autocomplete({
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
   			var id=document.getElementById('pilot_name');
			document.add_pilot.pilot_id.value = ui.item.id;
			document.add_pilot.pilot_name.value = id.value;
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
   			if(id.value==''){
				document.add_pilot.pilot_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_pilot');
			loading.style.display = "none";
   			var mes=document.getElementById('pilot_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
});
</script>
{/literal}

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Series Settings - {$series->info.series_name|escape} <input type="button" value=" Edit Series Parameters " onClick="document.edit_series.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Series Name</th>
			<td>
			{$series->info.series_name|escape}
			</td>
		</tr>
		<tr>
			<th align="right">Location</th>
			<td>
			{$series->info.series_area|escape},{$series->info.state_code|escape} {$series->info.country_code|escape}
			{if $series->info.country_code}<img src="/images/flags/countries-iso/shiny/24/{$series->info.country_code|escape}.png" style="vertical-align: middle;">{/if}
			{if $series->info.state_name && $series->info.country_code=="US"}<img src="/images/flags/states/24/{$series->info.state_name|escape}-Flag-24.png" style="vertical-align: middle;">{/if}
			</td>
		</tr>
		<tr>
			<th align="right">Series Web URL</th>
			<td><a href="{$series->info.series_url}" target="_new">{$series->info.series_url}</a></td>
		</tr>
		</table>
		
	</div>
		<br>
		<h1 class="post-title entry-title">Series Events</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th align="center">#</th>
			<th align="left" width="10%">Date</th>
			<th align="left">Event Name</th>
			<th align="left">Location</th>
			<th align="left">State</th>
			<th align="left">Country</th>
			<th align="left">Pilots</th>
		</tr>
		{$num=1}
		{foreach $series->events as $e}
		<tr>
			<td align="center">{$num}</td>
			<td nowrap>{$e.event_start_date|date_format:"Y-m-d"}</td>
			<td>
				<a href="?action=event&function=event_view&event_id={$e.event_id}">{$e.event_name|escape}</a>
			</td>
			<td>{$e.location_name|escape}</td>
			<td>
				{if $e.state_name && $e.country_code=="US"}<img src="/images/flags/states/16/{$e.state_name|escape}-Flag-16.png" style="vertical-align: middle;">{/if}
				{$e.state_name|escape}
			</td>
			<td>
				{if $e.country_code}<img src="/images/flags/countries-iso/shiny/16/{$e.country_code|escape}.png" style="vertical-align: middle;">{/if}
				{$e.country_name|escape}
			</td>
			<td nowrap>{$e.total_pilots|escape}</td>
		</tr>
		{$num=$num+1}
		{/foreach}
		</table>



		<br>
		{$event_num=1}
		<h1 class="post-title entry-title">Series Overall Classification</h1>
		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<td width="2%" align="left"></td>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{$series->totals.total_events + 1}" align="center" nowrap>
				Completed Events ({if $series->totals.round_drops==0}No{else}{$series->totals.round_drops}{/if} Drop{if $series->totals.round_drops!=1}s{/if} In Effect)
			</th>
			<th width="5%" nowrap>Total Score</th>
			<th width="5%" nowrap>Percentage</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $series->events as $e}
				<th class="info" width="5%" align="center" nowrap>
					<div style="position:relative;">
					<span>
						{$e.event_name|escape}
					</span>
					<a href="/?action=event&function=event_view&event_id={$e.event_id}">Event {$event_num}</a>
					</div>
				</th>
				{$event_num=$event_num+1}
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{foreach $series->totals.pilots as $p}
		{$pilot_id=$p@key}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$p.overall_rank}</td>
			<td align="right" nowrap><a href="?action=series&function=series_pilot_view&pilot_id={$pilot_id}&series_id={$series->info.series_id}">{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</a></td>
			{foreach $series->events as $e}
				{$event_id=$e.event_id}
				<td class="info" align="right"{if $e.pilots.$pilot_id.event_pilot_position==1} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
					<div style="position:relative;">
						{$drop=$p.events.$event_id.dropped}
						{if $drop==1}<del><font color="red">{/if}
						{if $p.events.$event_id.event_score!=0}
						{$p.events.$event_id.event_score|string_format:"%03.0f"}
						{else}
						0
						{/if}
						{if $drop==1}</font></del>{/if}
						<span>
						{$p.events.$event_id.event_score|string_format:"%06.3f"}
						</span>
					</div>
				</td>
			{/foreach}
			<td></td>
			<td width="5%" nowrap align="right">{$p.total_score|string_format:"%06.3f"}</td>
			<td width="5%" nowrap align="right">{$p.pilot_total_percentage|string_format:"%03.2f"}%</td>
		</tr>
		{/foreach}
		</table>




<br>


<input type="button" value=" Back To Series List " onClick="goback.submit();" class="block-button">

</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_list">
</form>
<form name="edit_series" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_edit">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
</form>
<form name="add_pilot" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_add_pilot">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
<input type="hidden" name="pilot_id" value="">
<input type="hidden" name="pilot_name" value="">
</form>
<form name="add_location" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_location_add">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
<input type="hidden" name="location_id" value="">
</form>
<form name="create_new_location" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
</form>

