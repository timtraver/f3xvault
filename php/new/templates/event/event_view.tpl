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
				{if $event->rounds|count>0 && ($event->classes|count > 1 || $event->totals.teams || $duration_rank || $speed_rank)}
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
				{if $event->rounds|count>0 && ($event->classes|count > 1 || $event->totals.teams || $duration_rank || $speed_rank)}
				<div id="pilot-tab-5" class="tab-pane fade{if $tab==5} active in{/if}">
					<h2 style="float:left;">Rankings</h2>
					<br style="clear:left;">
					{include file="event/event_view_rankings.tpl"}
				</div>
				{/if}
				{if $event->rounds|count>0 && ($lap_totals || $speed_averages || $top_landing || $event->planes|count>0)}
				<div id="pilot-tab-6" class="tab-pane fade{if $tab==6} active in{/if}">
					<h2 style="float:left;">Statistics</h2>
					<br style="clear:left;">
					{include file="event/event_view_stats.tpl"}
				</div>
				{/if}
			</div>
			<br>
		</div>
	</div>
</div>



<div id="print_round" style="overflow: hidden;">
		<form name="printround" method="POST" target="_blank">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_print_round">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="use_print_header" value="1">
		<div style="float: left;padding-right: 10px;">
			Print Round From :
			<select name="round_start_number">
			{foreach $event->rounds as $r}
			<option value="{$r.event_round_number}">{$r.event_round_number}</option>
			{/foreach}
			</select>
			To 
			<select name="round_end_number">
			{foreach $event->rounds as $r}
			<option value="{$r.event_round_number}">{$r.event_round_number}</option>
			{/foreach}
			</select><br>
			<br>
			Print One Round Per Page <input type="checkbox" name="oneper" CHECKED>
		</div>
		<br style="clear:both" />
		</form>
</div>

<script>
	document.getElementById('pilot_name').focus();
</script>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>
<form name="event_edit" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_view_info" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view_info">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_view_draws" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view_draws">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_delete" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_delete">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_pilot_add" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_pilot_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_pilot_id" value="0">
<input type="hidden" name="pilot_id" value="">
<input type="hidden" name="pilot_name" value="">
</form>
<form name="event_add_round" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_round_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_round_id" value="0">
<input type="hidden" name="zero_round" value="0">
<input type="hidden" name="flyoff_round" value="0">
</form>
<form name="print_overall" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_overall">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="use_print_header" value="1">
</form>
<form name="chart" method="GET" action="?">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_chart">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="print_stats" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_stats">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="use_print_header" value="1">
</form>
<form name="print_rank" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_rank">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="use_print_header" value="1">
</form>
<form name="registration_report" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_registration_report">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_export" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_export">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
{if $event->rounds}
<script>
	 document.getElementById('pilots').style.display = 'none';
	 document.getElementById('viewtoggle').innerHTML = 'Show Pilots';
</script>
{else}
<script>
	 document.getElementById('pilots').style.display = 'block';
	 document.getElementById('viewtoggle').innerHTML = 'Hide Pilots';
</script>
{/if}

{/block}
{block name="footer"}
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.dialog.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.button.js"></script>
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
   			var loading=document.getElementById('loading');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.event_pilot_add.pilot_id.value = ui.item.id;
			var name=document.getElementById('pilot_name');
			document.event_pilot_add.pilot_name.value=name.value;
			event_pilot_add.submit();
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
function toggle(element,tog) {
	var namestring="";
	if (element=='pilots') {
		namestring="Pilots";
	}
	if (element=="rankings") {
		namestring="Rankings";
	}
	if(element=="stats") {
		namestring="Statistics";
	}
	if (document.getElementById(element).style.display == 'none') {
		document.getElementById(element).style.display = 'block';
		tog.innerHTML = 'Hide ' + namestring;
	} else {
		document.getElementById(element).style.display = 'none';
		tog.innerHTML = 'Show ' + namestring;
	}
}
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
</script>
{/block}
