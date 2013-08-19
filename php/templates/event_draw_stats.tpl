<script src="/includes/highcharts/js/highcharts.js"></script>
<script>
$(function () {ldelim} 
    $('#chart_div').highcharts({ldelim}
        chart: {ldelim}
            type: 'bar'
        {rdelim},
        title: {ldelim}
        	text: 'Meeting Statistics',
        	x: -200
        {rdelim},
        xAxis: {ldelim}
            title: {ldelim}
            	text: 'Pilot To Pilot Meetings'
        	{rdelim},
        	tickInterval: 1,
        	tickPixelInterval: 1,
        	reversed: false,
        	plotBands: [{ldelim}
        		color: '#FCFFC5',
        		from : {$stat_totals.mean - $stat_totals.sd},
        		to: {$stat_totals.mean + $stat_totals.sd},
        		zIndex: 1,
        		label: {ldelim} text: 'Standard Deviation <br>±{$stat_totals.sd|string_format:"%0.3f"}', useHTML: true, align: 'right', x: 75, y: 25 {rdelim}
        	{rdelim}],
        	plotLines: [{ldelim}
        		value: {$stat_totals.mean - $stat_totals.sd},
        		dashStyle: 'ShortDashDot',
        		color: 'red',
        		width: 1,
        		zIndex: 40
        	{rdelim},{ldelim}
        		value: {$stat_totals.mean + $stat_totals.sd},
        		dashStyle: 'ShortDashDot',
        		color: 'red',
        		width: 1,
        		zIndex: 40
        	{rdelim},{ldelim}
        		value: {$stat_totals.mean},
        		color: 'green',
        		width: 2,
        		zIndex: 40,
        		label: {ldelim} text: 'Mean {$stat_totals.mean|string_format:"%0.3f"}', align: 'right', x: 75, y: 0 {rdelim}
        	{rdelim}]
        {rdelim},
        yAxis: {ldelim}
            title: {ldelim}
                text: 'Instances'
            {rdelim},
            min: 0
        {rdelim},
        legend: {ldelim}
        	align: 'right',
        	verticalAlign: 'top',
        	layout: 'vertical',
        	itemMarginTop: 2
        {rdelim},
        series: [{ldelim}
        	type: 'bar',
            name: 'Instances',
            borderRadius: 4,
            pointWidth: 15,
            yAxis: 0,
            zIndex: 50,
            data: [{foreach $stat_totals.totals as $s}{$meetings=$s@key}[{$meetings},{$s}]{if !$s@last},{/if}{/foreach}]
       	{rdelim}
       	]
    {rdelim});
{rdelim});
</script>

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                	
<h1 class="post-title entry-title">Draw Stats
		<input type="button" value=" Back To Event Draws " onClick="goback.submit();" class="block-button">
</h1>
	
<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw_save">
<input type="hidden" name="event_draw_id" value="{$event_draw_id}">
<input type="hidden" name="event_id" value="{$event_id}">
<input type="hidden" name="flight_type_id" value="{$ft.flight_type_id}">
<input type="hidden" name="event_draw_changed" value="0">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%" align="right" nowrap>Draw Flight Type</th>
	<td>
		{if $d->draw.event_type_code=='f3k'}
			F3K
		{else}
			{$d->draw.flight_type_name}
		{/if}
	</td>
</tr>
<tr>
	<th width="10%" align="right" nowrap>Round Range</th>
	<td>
		{$d->draw.event_draw_round_from} to {$d->draw.event_draw_round_to}
	</td>
</tr>
<tr>
	<th nowrap align="right">Team Protection</th>
	<td>
		{if $d->draw.event_draw_team_protection==1} ON{else}OFF{/if}
	</td>
</tr>
<tr>
	<th nowrap align="right" valign="top">Flight Groups</th>
	<td>
		There are currently <b>{$d->pilots|count}</b> Pilots in this event{if $d->teams|count > 0} on {$d->teams|count} teams{/if}.<br>
		You have selected to have {$d->draw.event_draw_number_groups} flight groups,
		resulting in {foreach $group_totals as $g}{$num_groups=$g@key}{$g} group{if $g>1}s{/if} of {$num_groups}{if !$g@last} and {/if}{/foreach}
	</td>
</tr>
<tr>
	<th align="right">Average # of Pilot-Pilot Meetings</th>
	<td>{$stat_totals.mean|string_format:"%0.3f"}</td>
</tr>
<tr>
	<th align="right">Standard Deviation</th>
	<td>{$stat_totals.sd|string_format:"%0.3f"}</td>
</tr>
<tr>
	<th nowrap align="right" valign="top">Graph</th>
	<td>	
		<br>
		<div id="chart_div" style="height: 300px; width: 600px;"></div>
	</td>
</tr>
<tr>
	<th nowrap align="right" valign="top">Matchup Details<br>(Mouse over for details)</th>
	<td>
		{foreach $d->pilots as $p}
			{$event_pilot_id=$p@key}
			<a href="" class="tooltip_stat">{$p.pilot_first_name} {$p.pilot_last_name}
				<span>
				<img class="callout_stat" src="/images/callout.gif">
				<strong>{$p.pilot_first_name} {$p.pilot_last_name}</strong> - {$p.event_pilot_team}
				<table>
				<tr>
					<th>Pilot</th>
					<th>Team</th>
					<th>Meetings</th>
				</tr>
				{foreach $stats.$event_pilot_id as $s}
					{$event_pilot_id2=$s@key}
					<tr>
						<td align="right" nowrap>
							{$d->pilots.$event_pilot_id2.pilot_first_name} {$d->pilots.$event_pilot_id2.pilot_last_name}
						</td>
						<td align="right" nowrap>
							{$d->pilots.$event_pilot_id2.event_pilot_team}
						</td>
						<td align="center">
							{$s}
						</td>
					</tr>
				{/foreach}
				</table>
				</span>
			</a><br>
		{/foreach}
	</td>
</tr>



</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw">
<input type="hidden" name="event_id" value="{$event_id}">
</form>

</div>
</div>

