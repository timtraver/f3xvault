{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

{include file="event/event_view_top_info.tpl"}

<div class="panel" style="min-width:1100px;background-color:#337ab7;">
	<div class="panel-body">
		<div class="tab-base" style="margin-top: 10px;">
			<ul class="nav nav-tabs">
				<li{if $tab==0} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-0" aria-expanded="true" {if $tab==0}aria-selected="true"{/if}>
						Preliminary Rounds
						<span class="badge badge-blue">{$total_prelim_rounds}</span>
					</a>
				</li>
				{if $total_flyoff_rounds>0}
				<li{if $tab==1} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-1" aria-expanded="true" {if $tab==1}aria-selected="true"{/if}>
						Flyoff Rounds
						<span class="badge badge-blue">{$total_flyoff_rounds}</span>
					</a>
				</li>
				{/if}
				<li{if $tab==2} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-2" aria-expanded="false" {if $tab==2}aria-selected="true"{/if}>
						Pilots
						<span class="badge badge-blue">{$event->pilots|count}</span>
					</a>
				</li>
				{if $active_draws}
				<li{if $tab==3} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-3" aria-expanded="false" {if $tab==3}aria-selected="true"{/if}>
						Draw
					</a>
				</li>
				{/if}
				{if $event->rounds|count>0}
				<li{if $tab==4} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-4" aria-expanded="false" {if $tab==4}aria-selected="true"{/if}>
						Position Chart
					</a>
				</li>
				{/if}
				{if $event->rounds|count>0 && ($event->classes|count > 1 || $event->totals.teams || $duration_rank || $speed_rank || $round_wins)}
				<li{if $tab==5} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-5" aria-expanded="false" {if $tab==5}aria-selected="true"{/if}>
						Rankings
					</a>
				</li>
				{/if}
				{if $event->rounds|count>0 && ($lap_totals || $speed_averages || $top_landing || $event->planes|count>0)}
				<li{if $tab==6} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-6" aria-expanded="false" {if $tab==6}aria-selected="true"{/if}>
						Stats
					</a>
				</li>
				{/if}
				{if $event->rounds|count>0 && $graphs}
				<li{if $tab==7} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-7" aria-expanded="false" {if $tab==7}aria-selected="true"{/if}>
						Graphs
					</a>
				</li>
				{/if}
				<li{if $tab==8} class="active"{/if}>
					<a href="?action=event_message&function=event_message_send&event_id={$event->info.event_id}&tab=8">
						Send Messages
					</a>
				</li>
			</ul>
			<div class="tab-content">
				<div id="pilot-tab-0" class="tab-pane fade{if $tab==0} active in{/if}">
					<h2 style="float:left;">Preliminary Overall Standings</h2>
					<div style="float:right;">
						<div class="btn-group">
							<button class="btn btn-primary dropdown-toggle btn-rounded" data-toggle="dropdown" type="button">
								Add Scoring Round <i class="dropdown-caret fa fa-caret-down"></i>
							</button>
							<ul class="dropdown-menu dropdown-menu-right">
								{if $event->info.event_type_zero_round==1}
								<li><a href="#" onClick="{if $event->pilots|count==0}alert('You must enter pilots before you add a round.');{else}if(check_permission()){ldelim}document.event_add_round.zero_round.value=1;document.event_add_round.submit();{rdelim}{/if}">Add Zero Round</a>
								</li>
								{/if}
								<li><a href="#" onClick="{if $event->pilots|count==0}alert('You must enter pilots before you add a round.');{else}if(check_permission()){ldelim}document.event_add_round.flyoff_round.value=0;document.event_add_round.submit();{rdelim}{/if}">Add Preliminary Round</a>
								</li>
								<li><a href="#" onclick="{if $event->pilots|count==0}alert('You must enter pilots before you add a round.');{else}if(check_permission()){ldelim}document.event_add_round.flyoff_round.value=1;document.event_add_round.submit();{rdelim}{/if}">Add Flyoff Round</a>
								</li>
							</ul>
						</div>
					</div>
					<br style="clear:left;">
					{include file="event/event_view_prelim_rounds.tpl"}

				</div>
				{if $total_flyoff_rounds>0}
				<div id="pilot-tab-1" class="tab-pane fade{if $tab==1} active in{/if}">
					<h2 style="float:left;">Flyoff Overall Standings</h2>
					<div style="float:right;">
						<div class="btn-group">
							<button class="btn btn-primary dropdown-toggle btn-rounded" data-toggle="dropdown" type="button">
								Add Scoring Round <i class="dropdown-caret fa fa-caret-down"></i>
							</button>
							<ul class="dropdown-menu dropdown-menu-right">
								{if $event->info.event_type_zero_round==1}
								<li><a href="#" onClick="{if $event->pilots|count==0}alert('You must enter pilots before you add a round.');{else}if(check_permission()){ldelim}document.event_add_round.zero_round.value=1;document.event_add_round.submit();{rdelim}{/if}">Add Zero Round</a>
								</li>
								{/if}
								<li><a href="#" onClick="{if $event->pilots|count==0}alert('You must enter pilots before you add a round.');{else}if(check_permission()){ldelim}document.event_add_round.flyoff_round.value=0;document.event_add_round.submit();{rdelim}{/if}">Add Preliminary Round</a>
								</li>
								<li><a href="#" onclick="{if $event->pilots|count==0}alert('You must enter pilots before you add a round.');{else}if(check_permission()){ldelim}document.event_add_round.flyoff_round.value=1;document.event_add_round.submit();{rdelim}{/if}">Add Flyoff Round</a>
								</li>
							</ul>
						</div>
					</div>
					<br style="clear:left;">
					{include file="event/event_view_flyoff_rounds.tpl"}

				</div>
				{/if}
				<div id="pilot-tab-2" class="tab-pane fade{if $tab==2} active in{/if}">
					<h2 style="float:left;">Pilot Roster</h2>
					<br style="clear:left;">
					{include file="event/event_view_pilot_list.tpl"}
				</div>
				{if $active_draws}
				<div id="pilot-tab-3" class="tab-pane fade{if $tab==3} active in{/if}">
					<h2 style="float:left;">Event Active Draw</h2>
					<br style="clear:left;">
					<div>
						<div>                
							<button class="btn btn-primary btn-rounded" id="change_pilot_info_button" type="button" onclick="window.open('?action=event&function=event_draw_view&event_draw_id={$draw_info.event_draw_id}&event_id={$event->info.event_id}&use_print_header=1','_blank');"> Print Draw </button>
							{include file="event/event_view_draw.tpl"}
							<br>
						</div>
					</div>
				</div>
				{/if}
				{if $event->rounds|count>0}
				<div id="pilot-tab-4" class="tab-pane fade{if $tab==4} active in{/if}">
					<h2 style="float:left;">Position Chart</h2>
					<br style="clear:left;">
					<div>
						<div>                
							<div id="chart_div" style="width: 900px;height: {30*$event->pilots|count}px;"></div>
							<br>
						</div>
					</div>
				</div>
				{/if}
				{if $event->rounds|count>0 && ($event->classes|count > 1 || $event->totals.teams || $duration_rank || $speed_rank || $round_wins)}
				<div id="pilot-tab-5" class="tab-pane fade{if $tab==5} active in{/if}">
					<h2 style="float:left;">Rankings</h2>
					<br style="clear:left;">
					{include file="event/event_view_rankings.tpl"}
				</div>
				{/if}
				{if $event->rounds|count>0 && ($lap_totals || $speed_averages || $top_landing || $event->planes|count>0 || $start_height || $height_time_rank || $made_time_rank)}
				<div id="pilot-tab-6" class="tab-pane fade{if $tab==6} active in{/if}">
					<h2 style="float:left;">Statistics</h2>
					<br style="clear:left;">
					<h3 style="float:left;">
						Show Top
						<select name="show_top" onChange='document.getElementById("show_top").value = this.value;document.event_view_update_stats.submit();'>
						<option	value="10"{if $show_top == 10} SELECTED{/if}>10</option>
						<option	value="20"{if $show_top == 20} SELECTED{/if}>20</option>
						<option	value="30"{if $show_top == 30} SELECTED{/if}>30</option>
						<option	value="40"{if $show_top == 40} SELECTED{/if}>40</option>
						<option	value="50"{if $show_top == 50} SELECTED{/if}>50</option>
						<option	value="60"{if $show_top == 60} SELECTED{/if}>60</option>
						<option	value="70"{if $show_top == 70} SELECTED{/if}>70</option>
						<option	value="80"{if $show_top == 80} SELECTED{/if}>80</option>
						<option	value="90"{if $show_top == 90} SELECTED{/if}>90</option>
						<option	value="100"{if $show_top == 100} SELECTED{/if}>100</option>
						</select>
					</h3>
					<br style="clear:left;">
					{include file="event/event_view_stats.tpl"}
					<form name="event_view_update_stats" method="POST">
					<input type="hidden" name="action" value="event">
					<input type="hidden" name="function" value="event_view">
					<input type="hidden" name="event_id" value="{$event->info.event_id}">
					<input type="hidden" id="show_top" name="show_top" value="{$show_top|escape}">
					<input type="hidden" name="tab" value="6">
					</form>

				</div>
				{/if}
				{if $event->rounds|count>0 && $graphs}
				<div id="pilot-tab-7" class="tab-pane fade{if $tab==7} active in{/if}">
					<h2 style="float:left;">Flight Graphs</h2>
					<br style="clear:left;">
					{include file="event/event_view_graphs.tpl"}
				</div>
				{/if}
			</div>
			<br>
		</div>
	</div>
</div>

<script>
	document.getElementById('pilot_name').focus();
</script>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>

{/block}
{block name="footer"}
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.dialog.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.button.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script src="/includes/highcharts/js/highcharts.js"></script>

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
   			var loading=document.getElementById('loading');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.event_pilot_add.pilot_id.value = ui.item.id;
			var name=document.getElementById('pilot_name');
			document.event_pilot_add.pilot_name.value=name.value;
			document.event_pilot_add.pilot_add_type.value='quick';
			if( event.keyCode != 13 ){
				event_pilot_add.submit();
			}
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
   			if(id.value==''){
				document.event_pilot_add.pilot_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "none";
   			var mes=document.getElementById('search_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
	$("#pilot_name").keyup(function(event) { 
		if (event.keyCode == 13) { 
			//For enter.
			var name=document.getElementById('pilot_name');
			document.event_pilot_add.pilot_name.value=name.value;
			event_pilot_add.submit();
        }
    });
	$( "#print_round" ).dialog({
		title: "Print Individual Round Details",
		autoOpen: false,
		height: 150,
		width: 350,
		modal: true,
		buttons: {
			"Print Rounds": function() {
				document.printround.submit();
				$( this ).dialog( "close" );
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		},
		close: function() {
		}
	});
	$( "#printroundoff" )
		.button()
		.click(function() {
		$( "#print_round" ).dialog( "open" );
	});
});
{/literal}
function check_permission() {ldelim}
	{if $permission!=1}
		alert('Sorry, but you do not have permission to edit this event. Contact the event owner if you need access to edit this event.');
		return 0;
	{else}
		return 1;
	{/if}
{rdelim}
</script>
{/block}
{block name="footer2"}
{if $event->rounds|count>0 || $event->draw_rounds|count>0}
<script>
{if $event->rounds|count>0}
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
            name: '{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}',
            data: [{foreach $p.rounds as $r}{if $r.event_round_score_status==0}{continue}{/if}[{$r@key},{$r.event_round_upto_rank}]{if !$r@last},{/if}{/foreach}]
        	{rdelim}{if !$p@last},{/if}
        	{/foreach}
       	]
    {rdelim});
{rdelim});
{/if}
{if $event->draw_rounds|count>0}
$(function () {ldelim} 
    $('#stat_chart_div').highcharts({ldelim}
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
{/if}
{if $event->rounds|count>0 && $graphs}
$(function () {ldelim} 
    $('#event_chart_div').highcharts({ldelim}
        chart: {ldelim}
            type: 'line'
        {rdelim},
        colors: [
			'#2f7ed8', 
			'#8bbc21'
		],
        title: {ldelim}
            text: 'Overall Contest Wind Graph'
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
                text: 'Wind Speed (m/s)'
            {rdelim},
            min: 0,
        	tickInterval: 1
        {rdelim},
        {ldelim}
            title: {ldelim}
                text: 'Wind Direction (Degrees)'
            {rdelim},
			opposite: true,
            min: -20,
            max: 20,
        	tickInterval: 5,
        	plotLines: [{ldelim}
        		value: 0,
        		color: 'green',
        		width: 2,
        		zIndex: 40,
        		label: {ldelim} text: 'Straight In', align: 'right', x: 5, y: 0 {rdelim}
        	{rdelim}]

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
            name: 'Average Wind Speed',
            yAxis: 0,
            data: [
            {foreach $event->rounds as $r}
				{$round=$r@key}
						[{$round},{$r.average_wind_speed}]{if !$r@last},{/if}
			{/foreach}
				]
        	{rdelim},
        	{ldelim}
        	type: 'areaspline',
            name: 'Average Wind Direction From Straight In',
            yAxis: 1,
            data: [
            {foreach $event->rounds as $r}
				{$round=$r@key}
				[{$round},{$r.average_wind_dir}]{if !$r@last},{/if}
			{/foreach}
				]
        	{rdelim}
       	]
    {rdelim});
    /* Each Round Graph */
    {foreach $event->rounds as $r}
    {$round_number = $r.event_round_number}
    {$flight_type_id = $r.flight_type_id}
    $('#round{$r.event_round_number}_chart_div').highcharts({ldelim}
        chart: {ldelim}
            type: 'line'
        {rdelim},
        colors: [
			'#2f7ed8', 
			'#8bbc21'
		],
        title: {ldelim}
            text: 'Round Flights'
        {rdelim},
        xAxis: {ldelim}
            title: {ldelim}
            	text: 'Flight Order'
        	{rdelim},
        	tickInterval: 1,
        	tickPixelInterval: 10,
			gridLineWidth: 1
        {rdelim},
        yAxis: [{ldelim}
            title: {ldelim}
                text: 'Wind Speed (m/s)'
            {rdelim},
            min: 0,
        	tickInterval: 1
        {rdelim},
        {ldelim}
            title: {ldelim}
                text: 'Flight Time (s)'
            {rdelim},
			opposite: true,
            min: {$r.round_min_flight_time -5},
            max: {$r.round_max_flight_time +5},
        	tickInterval: 2
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
            name: 'Average Flight Wind Speed',
            yAxis: 0,
            data: [
            {foreach $r.flights.$flight_type_id.pilots as $f}
				{$flight=$f.event_pilot_round_flight_order}
				{if $flight}
						[{$flight},{if $f.event_pilot_round_flight_wind_avg}{$f.event_pilot_round_flight_wind_avg}{else}0{/if}]{if !$f@last},{/if}{/if}
			{/foreach}
				]
        	{rdelim},
        	{ldelim}
        	type: 'line',
            name: 'Flight Time',
            yAxis: 1,
            data: [
            {foreach $r.flights.$flight_type_id.pilots as $f} {$flight=$f.event_pilot_round_flight_order}{$epid = $f.event_pilot_id}
				{if $flight}
						{ldelim}name:'{$event->pilots.$epid.pilot_first_name|escape} {$event->pilots.$epid.pilot_last_name|escape}',
						{if $f.event_pilot_round_flight_seconds == $r.round_min_flight_time}radius: 10,fillColor: '#BF0B23',{/if}
						x:{if $flight}{$flight}{else}1{/if},
						y:{if $f.event_pilot_round_flight_seconds}{$f.event_pilot_round_flight_seconds}{else}0{/if}
						{rdelim}{if !$f@last},{/if}
				{/if}
			{/foreach}
			]
        	{rdelim}
       	]
    {rdelim});
    {/foreach}
{rdelim});
{/if}
{/if}
</script>
{if $event->info.event_reg_teams == 1 || $event->info.event_use_teams == 1}
<script type="text/javascript">
function save_team_field(element) {ldelim}
	$.ajax({ldelim}
		type: "POST",
		url: "/",
		data: {ldelim}
			action: "event",
			function: "event_save_pilot_team",
			field_name: element.name,
			field_value: element.value
		{rdelim}
	{rdelim});
	return;
{rdelim}
</script>
{/if}
{/block}
