
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Series - {$series->info.series_name|escape}</h1>

		<br>
		<h1 class="post-title entry-title">Pilot Event Detail for {$series->totals.pilots.$pilot_id.pilot_first_name|escape} {$series->totals.pilots.$pilot_id.pilot_last_name|escape}</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="center">Number</th>
			<th align="left">Event Name</th>
			<th width="10%" align="right">Event Score</th>
			<th width="5%" nowrap>Event Rank</th>
		</tr>
		{$num=1}
		{foreach $series->events as $e}
			<tr>
				{$event_id=$e@key}
				{$bgcolor='#9DCFF0'}
				<td align="center">{$num}</td>
				<td align="left">{$e.event_name|escape}</td>
				<td align="right" nowrap>
					{if $series->totals.pilots.$pilot_id.events.$event_id.dropped==1}<del><font color="red">{/if}
						{$series->totals.pilots.$pilot_id.events.$event_id.event_score|string_format:"%06.3f"}
					{if $series->totals.pilots.$pilot_id.events.$event_id.dropped==1}</font></del>{/if}
				</td>
				<td align="right" nowrap>
					{$series->totals.pilots.$pilot_id.events.$event_id.event_pilot_position}
				</td>
			</tr>
			{$num=$num+1}
		{/foreach}
		</table>
		
		<br>
		<h1 class="post-title entry-title">Pilot Totals for {$series->totals.pilots.$pilot_id.pilot_first_name|escape} {$series->totals.pilots.$pilot_id.pilot_last_name|escape}</h1>
		<table width="50%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Overall Rank</th>
			<td>{$series->totals.pilots.$pilot_id.overall_rank}</td>
		</tr>
		<tr>
			<th>Total Points</th>
			<td>{$series->totals.pilots.$pilot_id.total_score|string_format:"%06.3f"}</td>
		</tr>
		<tr>
			<th>Event Percentage</th>
			<td>{$series->totals.pilots.$pilot_id.pilot_total_percentage|string_format:"%06.3f"} %</td>
		</tr>
		</table>
<br>
<input type="button" value=" Back To Series View " onClick="goback.submit();" class="block-button">
<input type="button" value=" Print Pilot Series Results " onClick="print_pilot.submit();" class="block-button">
</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_view">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
</form>
<form name="print_pilot" action="?" method="GET" target="_blank">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_print_pilot">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
<input type="hidden" name="pilot_id" value="{$pilot_id}">
<input type="hidden" name="use_print_header" value="1">
</form>
