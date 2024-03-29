{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">{$event->info.event_name}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">


		<h2 class="post-title entry-title">Pilot Round Detail for {$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}
			{if $event->pilots.$event_pilot_id.country_code}<img src="/images/flags/countries-iso/shiny/24/{$event->pilots.$event_pilot_id.country_code|escape}.png" style="vertical-align: middle;" title="{$event->pilots.$event_pilot_id.country_name}">{/if}
			{if $event->pilots.$event_pilot_id.state_name && $event->pilots.$event_pilot_id.country_code=="US"}<img src="/images/flags/states/24/{$event->pilots.$event_pilot_id.state_name|replace:' ':'-'}-Flag-24.png" style="vertical-align: middle;" title="{$event->pilots.$event_pilot_id.state_name}">{/if}
		</h2>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
			<th width="2%" align="left">Round</th>
			{if $event->info.event_type_code!='f3k'}
			{$cols=1}
			{foreach $event->flight_types as $ft}
				{$cols=$cols+4}
				{if $ft.flight_type_group}{$cols=$cols+1}{/if}
				{if $ft.flight_type_start_penalty}{$cols=$cols+1}{/if}
				{if $ft.flight_type_start_height}{$cols=$cols+1}{/if}
				{if $ft.flight_type_seconds}{$cols=$cols+1}{/if}
				{if $ft.flight_type_landing}{$cols=$cols+1}{/if}
				{if $ft.flight_type_laps}{$cols=$cols+1}{/if}	
				{if $ft.flight_type_position}{$cols=$cols+1}{/if}	
			{/foreach}
			{else}
				{$cols=7}
			{/if}
			{$cols=$cols+1}
			<th colspan="{$cols}" align="center" nowrap>Round Data</th>
		</tr>
		{if $event->info.event_type_code!='f3k'}
		<tr>
			<th width="2%" align="left"></th>
			{foreach $event->flight_types as $ft}
				{$cols=4}
				{if $ft.flight_type_group}{$cols=$cols+1}{/if}
				{if $ft.flight_type_start_penalty}{$cols=$cols+1}{/if}
				{if $ft.flight_type_start_height}{$cols=$cols+1}{/if}
				{if $ft.flight_type_seconds}{$cols=$cols+1}{/if}
				{if $ft.flight_type_landing}{$cols=$cols+1}{/if}
				{if $ft.flight_type_laps}{$cols=$cols+1}{/if}	
				{if $ft.flight_type_position}{$cols=$cols+1}{/if}	
				{$cols=$cols+1}
			<th align="center" colspan="{$cols}" nowrap>{$ft.flight_type_name|escape}</th>
			{/foreach}
		</tr>
		{/if}
		
		
		{if $event->info.event_type_code!='f3k'}
		<tr>
			<th width="2%" align="center"></th>
			{foreach $event->flight_types as $ft}
				{if $ft.flight_type_group}
					<th align="right">Group</th>
				{/if}
				{if $ft.flight_type_start_penalty}
					<th align="right">Start Penalty</th>
				{/if}
				{if $ft.flight_type_minutes || $ft.flight_type_seconds}
					<th align="right">Time</th>
				{/if}
				{if $ft.flight_type_landing}
					<th align="right">Landing</th>
				{/if}
				{if $ft.flight_type_start_height}
					<th align="right">Start Height</th>
				{/if}
				{if $ft.flight_type_laps}
					<th align="right">Laps</th>
				{/if}
				<th align="right">Raw</th>
				<th align="right">Score</th>
				<th align="right">Pen</th>
				<th align="right">Rank</th>
				<th align="right">SE</th>
			{/foreach}
		</tr>
		{else}
		<tr>
			<th width="2%" align="center"></th>
			<th align="center">Task</th>
			<th align="center">Group</th>
			<th align="center">Time</th>
			<th align="center">Raw</th>
			<th align="center">Score</th>
			<th align="center">Pen</th>
			<th align="center">Rank</th>
			<th align="center">SE</th>
		</tr>
		{/if}
		{$flyoff_label=0}
		{foreach $event->rounds as $r}
			{$round_pen=0}
			{$round_total=0}
			{if $r.event_round_flyoff!=0 && $flyoff_label==0}
			<tr>
				<th colspan="2" style="color:red;">Flyoffs</th>
			</tr>
			{$flyoff_label=1}
			{/if}
			<tr>
				{$round=$r@key}
				{$bgcolor='#9DCFF0'}
				<td align="center" style="background-color: {$bgcolor};"><a href="?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$r.event_round_id}">{$round}</a></td>
				{foreach $event->flight_types as $ft}
					{$flight_type_id = $ft@key}
					{if $event->info.event_type_code=='f3k' && $ft.flight_type_id!=$r.flight_type_id}
						{continue}
					{/if}
					{$values=$r.flights.$flight_type_id.pilots.$event_pilot_id}
					{if $values.event_pilot_round_flight_reflight_dropped==1}
						{foreach $r.reflights as $rf}
							{if $rf@key!=$flight_type_id}{continue}{/if}
							{foreach $rf.pilots as $rp}
								{if $rp@key!=$event_pilot_id}{continue}{/if}
								{if $rp.event_pilot_round_flight_reflight_dropped==0}
									{$values=$rp}
								{/if}
							{/foreach}
						{/foreach}
					{/if}

					{if $bgcolor=='white'}{$bgcolor='#9DCFF0'}{else}{$bgcolor='white'}{/if}
					{if $event->info.event_type_code=='f3k'}
						<th width="5%" align="left" nowrap style="background-color: {$bgcolor};">
							{$ft.flight_type_name|escape}
						</th>
					{/if}
					{if $ft.flight_type_group}
						<td align="left" nowrap style="background-color: {$bgcolor};">
							{$values.event_pilot_round_flight_group|escape}{if $values.event_pilot_round_flight_reflight}(R){/if}
						</td>					
					{/if}
					{if $ft.flight_type_start_penalty}
						<td align="left" nowrap style="background-color: {$bgcolor};">
							{$values.event_pilot_round_flight_start_penalty|escape}
						</td>
					{/if}
					{if $ft.flight_type_minutes || $ft.flight_type_seconds}
						<td align="left" nowrap style="background-color: {$bgcolor};">
							
								{if $r.flights.$flight_type_id.flight_type_sub_flights!=0}
									{foreach $values.sub as $s}
									<span style="background-color: #9DCFF0;padding: 3px;">{$s.event_pilot_round_flight_sub_val|escape}</span>
									{/foreach}
									= 
								{/if}
								{if $ft.flight_type_minutes}{$values.event_pilot_round_flight_minutes|escape}m{/if}
								{if $ft.flight_type_seconds}{$values.event_pilot_round_flight_seconds|escape}s{/if}
						</td>
					{/if}
					{if $ft.flight_type_landing}
						<td align="left" style="background-color: {$bgcolor};">
							{$values.event_pilot_round_flight_landing|escape}
						</td>
					{/if}
					{if $ft.flight_type_start_height}
						<td align="left" style="background-color: {$bgcolor};">
							{$values.event_pilot_round_flight_start_height|escape}
						</td>
					{/if}
					{if $ft.flight_type_laps}
						<td align="left" style="background-color: {$bgcolor};">
							{$values.event_pilot_round_flight_laps|escape}
						</td>
					{/if}
					<td align="left" nowrap style="background-color: {$bgcolor};">
						{if $ft.flight_type_code=='f3f_speed' OR $ft.flight_type_code=='f3b_speed'}
							{$values.event_pilot_round_flight_raw_score|escape}
						{else}
							{$values.event_pilot_round_flight_raw_score|string_format:$event->event_calc_accuracy_string}
						{/if}
					</td>
					<td align="left" nowrap style="background-color: {$bgcolor};">
						{if $values.event_pilot_round_flight_dropped==1}<del><font color="red">{/if}
						{$values.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}
						{if $values.event_pilot_round_flight_dropped==1}</font></del>{/if}
						{$round_total=$round_total+$values.event_pilot_round_flight_score}
					</td>
					<td align="left" nowrap style="background-color: {$bgcolor};">
						{if $values.event_pilot_round_flight_penalty!=0}{$values.event_pilot_round_flight_penalty|escape}{/if}
						{$round_pen=$round_pen+$values.event_pilot_round_flight_penalty}
					</td>
					<td align="left" nowrap style="background-color: {$bgcolor};">
						{$values.event_pilot_round_flight_rank|escape}
					</td>
					<td align="left" nowrap style="background-color: {$bgcolor};">
						{if $values.event_pilot_round_flight_entered == 1}
							<img height="20" src="/images/icons/bullet_green.png" />
						{/if}
					</td>
				{/foreach}
			</tr>
		{/foreach}
		</table>
		
		{if $event->info.event_type_code=='f3f' || $event->info.event_type_code=='f3f_plus' || $event->info.event_type_code=='f3b_speed'}
			<br>
			<h1 class="post-title entry-title">Round Performance Chart</h1>
		
		    <div id="chart_div" style="width: 900px;"></div>
		{/if}
		{if $event->info.event_type_code=='f3b'}
			<br>
			<h1 class="post-title entry-title">Round Performance Charts</h1>
		
		    <div id="chart_div_f3b" style="width: 900px;"></div>
		{/if}
		{if $event->info.event_type_code=='f3k'}
			<br>
			<h1 class="post-title entry-title">Round Performance Charts</h1>
		
		    <div id="chart_div_f3k" style="width: 900px;"></div>
		{/if}
		
		
		<br>
		<h2 class="post-title entry-title">Pilot Totals for {$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</h2>
		<table width="50%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
			<th width="20%">Overall Rank</th>
			<td>{$event->pilots.$event_pilot_id.event_pilot_position|escape}</td>
		</tr>
		<tr>
			<th>Total Points</th>
			<td>{$event->pilots.$event_pilot_id.event_pilot_total_score|string_format:$event->event_calc_accuracy_string}</td>
		</tr>
		<tr>
			<th>Event Percentage</th>
			<td>{$event->pilots.$event_pilot_id.event_pilot_total_percentage|string_format:$event->event_calc_accuracy_string} %</td>
		</tr>
		{if $event->pilots.$event_pilot_id.event_pilot_total_laps>0}
		<tr>
			<th>Total Distance Laps</th>
			<td>{$event->pilots.$event_pilot_id.event_pilot_total_laps|escape} (rank {$event->pilots.$event_pilot_id.event_pilot_lap_rank|escape})</td>
		</tr>
		{/if}
		{if $event->pilots.$event_pilot_id.event_pilot_average_speed>0}
		<tr>
			<th>Pilot Average Speed</th>
			<td>{$event->pilots.$event_pilot_id.event_pilot_average_speed|string_format:$event->event_calc_accuracy_string} (rank {$event->pilots.$event_pilot_id.event_pilot_average_speed_rank})</td>
		</tr>
		{/if}
		</table>
		<input type="button" value=" Print Pilot Results " onClick="print_pilot.submit();" class="btn btn-primary btn-rounded">
		<br>
		<br>
	</div>
	{if $event->info.event_type_code=='f3f_plus'}
	<div class="panel-body">
		<h2 class="post-title entry-title">Round Detail Graphs</h2>
		{foreach $event->rounds as $r}
			<div>
				<h4>Round {$r.event_round_number}</h4>
				<div id="round{$r.event_round_number}_chart_div" style="width: 900px;height: 300px;"></div>
				<br>
			</div>
		{/foreach}
		<br>
	</div>
	{/if}
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id|escape}">
<input type="hidden" name="tab" value="">
</form>
<form name="event_edit" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id|escape}">
</form>
<form name="print_pilot" action="?" method="GET" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_pilot">
<input type="hidden" name="event_id" value="{$event->info.event_id|escape}">
<input type="hidden" name="event_pilot_id" value="{$event_pilot_id|escape}">
<input type="hidden" name="use_print_header" value="1">
</form>
{/block}
{block name="footer"}
<script src="/includes/highcharts/js/highcharts.js"></script>

{if $event->info.event_type_code=='f3f' || $event->info.event_type_code=='f3f_plus' || $event->info.event_type_code=='f3b_speed'}
<script>
$(function () {ldelim} 
    $('#chart_div').highcharts({ldelim}
        chart: {ldelim}
            type: 'line'
        {rdelim},
        colors: [
			'#2f7ed8', 
			'#8bbc21', 
			'#FF0000', 
			'#1aadce', 
			'#492970',
			'#f28f43', 
			'#77a1e5', 
			'#c42525', 
			'#a6c96a'
		],
        title: {ldelim}
            text: 'Round Chart'
        {rdelim},
        xAxis: {ldelim}
            title: {ldelim}
            	text: 'Round'
        	{rdelim},
        	tickInterval: 1,
        	tickPixelInterval: 10
        {rdelim},
        yAxis: [{ldelim}
            title: {ldelim}
                text: 'Time (s)'
            {rdelim},
            min: 25,
        	tickInterval: 2
        {rdelim},
        	{ldelim}
            title: {ldelim}
                text: 'Points'
            {rdelim},
			opposite: true,
			tickInterval: 25,
			min: 0
        {rdelim}],
        legend: {ldelim}
        	align: 'right',
        	verticalAlign: 'top',
        	layout: 'vertical',
        	itemMarginTop: 2
        {rdelim},
        series: [
        	{ldelim}
        	type: 'column',
            name: 'Fastest Time',
            yAxis: 0,
            data: [
            {foreach $event->rounds as $r}
				{$round=$r@key}
				{foreach $event->flight_types as $ft}
					{$flight_type_id = $ft@key}
					{$values=$r.flights.$flight_type_id.pilots.$event_pilot_id}
						{$fast=($values.event_pilot_round_flight_score*$values.event_pilot_round_flight_seconds)/1000}
						[{$round},{$fast|string_format:$event->event_calc_accuracy_string}]{if !$r@last},{/if}
				{/foreach}
			{/foreach}
				]
        	{rdelim},
        	{ldelim}
        	type: 'line',
            name: 'Flight Time',
            yAxis: 0,
            data: [
            {foreach $event->rounds as $r}
				{$round=$r@key}
				{foreach $event->flight_types as $ft}
					{$flight_type_id = $ft@key}
					{$values=$r.flights.$flight_type_id.pilots.$event_pilot_id}
						[{$round},{$values.event_pilot_round_flight_seconds|escape}]{if !$r@last},{/if}
				{/foreach}
			{/foreach}
				]
        	{rdelim},
        	{ldelim}
        	type: 'line',
            name: 'Points Lost',
            yAxis: 1,
            data: [
            {foreach $event->rounds as $r}
				{$round=$r@key}
				{foreach $event->flight_types as $ft}
					{$flight_type_id = $ft@key}
					{$values=$r.flights.$flight_type_id.pilots.$event_pilot_id}
						{$lost=1000 - $values.event_pilot_round_flight_score}
						[{$round},{$lost|string_format:$event->event_calc_accuracy_string}]{if !$r@last},{/if}
				{/foreach}
			{/foreach}
				]
        	{rdelim}
       	]
    {rdelim});
{rdelim});
</script>
{/if}
{if $event->info.event_type_code=='f3b'}
<script>
$(function () {ldelim} 
    $('#chart_div_f3b').highcharts({ldelim}
        chart: {ldelim}
            type: 'line'
        {rdelim},
        colors: [
			'#2f7ed8', 
			'#8bbc21', 
			'#FF0000', 
			'#1aadce', 
			'#492970',
			'#f28f43', 
			'#77a1e5', 
			'#c42525', 
			'#a6c96a'
		],
        title: {ldelim}
            text: 'Round Performance'
        {rdelim},
        xAxis: {ldelim}
            title: {ldelim}
            	text: 'Round'
        	{rdelim},
        	tickInterval: 1,
        	tickPixelInterval: 10
        {rdelim},
        yAxis: [{ldelim}
            title: {ldelim}
                text: 'Points'
            {rdelim},
            min: 0,
        	tickInterval: 50
        {rdelim},
        	{ldelim}
            title: {ldelim}
                text: 'Points'
            {rdelim},
			opposite: true,
			tickInterval: 50,
			min: 0
        {rdelim}],
        legend: {ldelim}
        	align: 'right',
        	verticalAlign: 'top',
        	layout: 'vertical'
        {rdelim},
        series: [
        	{ldelim}
        	type: 'column',
            name: 'Duration Score',
            yAxis: 0,
            data: [
            {foreach $event->rounds as $r}
				{$round=$r@key}
				{foreach $event->flight_types as $ft}
					{if $ft.flight_type_code!='f3b_duration'}
						{continue}
					{/if}
					{$flight_type_id = $ft@key}
					{$values=$r.flights.$flight_type_id.pilots.$event_pilot_id}
						{$fast=$values.event_pilot_round_flight_score}
						[{$round},{$fast|string_format:$event->event_calc_accuracy_string}]{if !$r@last},{/if}
				{/foreach}
			{/foreach}
				]
        	{rdelim},
        	{ldelim}
        	type: 'column',
            name: 'Distance Score',
            yAxis: 0,
            data: [
            {foreach $event->rounds as $r}
				{$round=$r@key}
				{foreach $event->flight_types as $ft}
					{if $ft.flight_type_code!='f3b_distance'}
						{continue}
					{/if}
					{$flight_type_id = $ft@key}
					{$values=$r.flights.$flight_type_id.pilots.$event_pilot_id}
					{if $values.event_pilot_round_flight_reflight_dropped==1}
						{foreach $r.reflights as $rf}
							{if $rf@key!=$flight_type_id}{continue}{/if}
							{foreach $rf.pilots as $rp}
								{if $rp@key!=$event_pilot_id}{continue}{/if}
								{if $rp.event_pilot_round_flight_reflight_dropped==0}
									{$values=$rp}
								{/if}
							{/foreach}
						{/foreach}
					{/if}
						[{$round},{$values.event_pilot_round_flight_score|escape}]{if !$r@last},{/if}
				{/foreach}
			{/foreach}
				]
        	{rdelim},
        	{ldelim}
        	type: 'column',
            name: 'Speed Score',
            yAxis: 1,
            data: [
            {foreach $event->rounds as $r}
				{$round=$r@key}
				{foreach $event->flight_types as $ft}
					{if $ft.flight_type_code!='f3b_speed'}
						{continue}
					{/if}
					{$flight_type_id = $ft@key}
					{$values=$r.flights.$flight_type_id.pilots.$event_pilot_id}
						[{$round},{$values.event_pilot_round_flight_score|escape}]{if !$r@last},{/if}
				{/foreach}
			{/foreach}
				]
        	{rdelim}
       	]
    {rdelim});
{rdelim});
</script>
{/if}
{if $event->info.event_type_code=='f3k'}
<script>
$(function () {ldelim} 
    $('#chart_div_f3k').highcharts({ldelim}
        chart: {ldelim}
            type: 'line'
        {rdelim},
        colors: [
			'#2f7ed8', 
			'#8bbc21', 
			'#FF0000', 
			'#1aadce', 
			'#492970',
			'#f28f43', 
			'#77a1e5', 
			'#c42525', 
			'#a6c96a'
		],
        title: {ldelim}
            text: 'Round Performance'
        {rdelim},
        xAxis: {ldelim}
            title: {ldelim}
            	text: 'Round'
        	{rdelim},
        	tickInterval: 1,
        	tickPixelInterval: 10
        {rdelim},
        yAxis: [{ldelim}
            title: {ldelim}
                text: 'Points'
            {rdelim},
            min: 0,
        	tickInterval: 50
        {rdelim}],
        legend: {ldelim}
        	align: 'right',
        	verticalAlign: 'top',
        	layout: 'vertical'
        {rdelim},
        series: [
        	{ldelim}
        	type: 'column',
            name: 'Score',
            yAxis: 0,
            data: [
            {foreach $event->rounds as $r}
				{$round=$r@key}
					{$flight_type_id = $r.flight_type_id}
					{$values=$r.flights.$flight_type_id.pilots.$event_pilot_id}
						{$fast=$values.event_pilot_round_flight_score}
						[{$round},{$fast|string_format:$event->event_calc_accuracy_string}]{if !$r@last},{/if}
			{/foreach}
				]
        	{rdelim}
       	]
    {rdelim});
{rdelim});
</script>
{/if}
{if $event->info.event_type_code=='f3f_plus'}
<script>
$(function () {ldelim} 
    {foreach $event->rounds as $r} {$round_number = $r.event_round_number} {$flight_type_id = $r.flight_type_id}
    $('#round{$r.event_round_number}_chart_div').highcharts({ldelim}
        chart: {ldelim}
            type: 'areaspline'
        {rdelim},
        colors: [
			'#2f7ed8'
		],
        title: {ldelim}
            text: 'Flight Lap Times'
        {rdelim},
        xAxis: {ldelim}
            title: {ldelim}
            	text: 'Laps'
        	{rdelim},
        	tickInterval: 1,
        	tickPixelInterval: 5,
			gridLineWidth: 1
        {rdelim},
        yAxis: [{ldelim}
            title: {ldelim}
                text: 'Time (s)'
            {rdelim},
            min: 0,
            max: 10,
        	tickInterval: 1
        {rdelim}],
        legend: {ldelim}
        	align: 'right',
        	verticalAlign: 'top',
        	layout: 'vertical',
        	itemMarginTop: 2
        {rdelim},
        series: [
        	{ldelim}
        	type: 'areaspline',
            name: 'Flight {$r.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_seconds}',
            yAxis: 0,
            data: [{foreach $r.flights.$flight_type_id.pilots.$event_pilot_id.sub as $s}{$sub=$s.event_pilot_round_flight_sub_num}
				{ldelim}name:'Lap {$sub - 1}',x:{$sub - 1},y:{if $s.event_pilot_round_flight_sub_val}{$s.event_pilot_round_flight_sub_val}{else}0{/if}{rdelim}{if !$s@last},{/if}
			{/foreach}
			]
        	{rdelim}
       	]
    {rdelim});
    {/foreach}

{rdelim});
</script>
{/if}
{/block}