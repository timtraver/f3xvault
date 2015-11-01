<script src="/includes/highcharts/js/highcharts.js"></script>

<script>
$(function () {ldelim} 
    $('#chart_div').highcharts({ldelim}
        chart: {ldelim}
            type: 'line'
        {rdelim},
        title: {ldelim}
            text: 'Position Movement Chart'
        {rdelim},
        xAxis: {ldelim}
            title: {ldelim}
            	text: 'Round'
        	{rdelim},
        	tickInterval: 1,
        	tickPixelInterval: 10
        {rdelim},
        yAxis: {ldelim}
            title: {ldelim}
                text: 'Overall Position'
            {rdelim},
            reversed: true,
            min: 1,
        	tickInterval: 1
        {rdelim},
        legend: {ldelim}
        	align: 'right',
        	verticalAlign: 'top',
        	layout: 'vertical',
        	y: 15,
        	itemMarginTop: 2
        {rdelim},
        series: [
        	{foreach $event->totals.pilots as $p}
        	{ldelim}
            name: '{$p.pilot_first_name} {$p.pilot_last_name}',
            data: [{foreach $p.rounds as $r}{if $r.event_round_score_status==0}{continue}{/if}[{$r@key},{$r.event_round_upto_rank}]{if !$r@last},{/if}{/foreach}]
        	{rdelim}{if !$p@last},{/if}
        	{/foreach}
       	]
    {rdelim});
{rdelim});
</script>

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">{$event->info.event_name|escape}</h1>
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
		{if $event->series || $event->info.club_name}
		<tr>
			<th valign="top" align="right">Part Of Series</th>
			<td valign="top">
				{foreach $event->series as $s}
				<a href="?action=series&function=series_view&series_id={$s.series_id}">{$s.series_name|escape}</a>{if !$s@last}<br>{/if}
				{/foreach}
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
	<h1 class="post-title entry-title">Event Preliminary Round Position Chart</h1>

    <div id="chart_div" style="width: 900px;height: {30*$event->pilots|count}px;"></div>




<br>
<input type="button" value=" Back To Event " onClick="goback.submit();" class="block-button">
	</div>
</div>


<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
