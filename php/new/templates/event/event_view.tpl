{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel" style="min-width:1100px;">
	<div class="panel-heading" style="min-width:1100px;">
		<h2 class="heading">{$event->info.event_name|escape}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">

		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed" style="margin-bottom: 10px;">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"}{if $event->info.event_end_date!=$event->info.event_start_date} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}{/if}
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
			<th align="right" valign="top">Part Of Series</th>
			<td valign="top">
				{foreach $event->series as $s}
				<a href="?action=series&function=series_view&series_id={$s.series_id}">{$s.series_name|escape}</a>{if !$s@last}<br>{/if}
				{/foreach}
			</td>
			<th align="right" valign="top">Club</th>
			<td valign="top">
			<a href="?action=club&function=club_view&club_id={$event->info.club_id}">{$event->info.club_name|escape}</a>
			</td>
		</tr>
		{/if}
		{if $event->info.event_reg_flag==1}
		<tr>
			<th align="right">Registration Status</th>
			<td colspan="3">
				{if $event->info.event_reg_status==0 || 
					($event->pilots|count>=$event->info.event_reg_max && $event->info.event_reg_max!=0) ||
					$event_reg_passed==1
				}
					<font color="red"><b>Registration Currently Closed</b></font>
				{else}
					<font color="green"><b>Registration Currently Open</b></font>
					<a href="?action=event&function=event_register&event_id={$event->info.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if}>
					Register Me Now!
					</a>
				{/if}
					&nbsp;&nbsp;&nbsp;&nbsp;
					{if $registered==1}
					<a href="?action=event&function=event_register&event_id={$event->info.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if}>
					You Are Registered! Update Your Registration Info
					</a>
					{/if}
			</td>
		{/if}
		</table>
		{if $user.user_id!=0 && ($permission==1 || $user.user_admin==1)}
		<input type="button" value=" Event Settings " onClick="if(check_permission()){ldelim}document.event_edit.submit();{rdelim}" style="float:right;margin-left:10px;" class="btn btn-primary btn-rounded">
		{/if}
		<input type="button" value=" View Full Event Info " onClick="document.event_view_info.submit();" style="float:right;margin-left:10px;" class="btn btn-primary btn-rounded">
		{if $active_draws}
		<input type="button" value=" View Draws " onClick="document.event_view_draws.submit();" style="float:right;margin-left:10px;" class="btn btn-primary btn-rounded">
		{/if}
		{if ($permission==1 || $user.user_admin==1) && $event->info.event_reg_status!=0}
		<input type="button" class="btn btn-primary btn-rounded" value=" Registration Report " style="float:right;margin-left:10px;" onclick="if(check_permission()){ldelim}registration_report.submit();{rdelim}">
		{/if}
		{if $event->info.event_id!=0}
		<input type="button" class="btn btn-primary btn-rounded" value=" Export Event Info " style="float:right;margin-left:10px;" onclick="event_export.submit();">
		{/if}
		<br>
		<br>
	</div>
</div>


<div class="panel" style="min-width:1100px;background-color:#337ab7;">
	<div class="panel-body">
		<div class="tab-base" style="margin-top: 10px;">
			<ul class="nav nav-tabs">
				<li{if $tab==0} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-0" aria-expanded="true" {if $tab==0}aria-selected="true"{/if}>
						Preliminary Rounds
						<span class="badge badge-blue">{$event->rounds|count}</span>
					</a>
				</li>
				<li{if $tab==1} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-1" aria-expanded="true" {if $tab==1}aria-selected="true"{/if}>
						Flyoff Rounds
						<span class="badge badge-blue">{$event->rounds|count}</span>
					</a>
				</li>
				<li{if $tab==2} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-2" aria-expanded="false" {if $tab==2}aria-selected="true"{/if}>
						Pilots
						<span class="badge badge-blue">{$event->pilots|count}</span>
					</a>
				</li>
				<li{if $tab==3} class="active"{/if}>
					<a data-toggle="tab" href="#pilot-tab-3" aria-expanded="false" {if $tab==3}aria-selected="true"{/if}>
						Position Chart
					</a>
				</li>
			</ul>
			<div class="tab-content">
				<div id="pilot-tab-0" class="tab-pane fade{if $tab==0} active in{/if}">
					<h2 style="float:left;">Preliminary Overall Standings</h2>
					<div style="float:right;overflow:hidden;">
						<input type="button" value=" Add Scoring Round " onClick="document.edit_club.submit();" class="btn btn-primary btn-rounded">
					</div>
					<br style="clear:left;">
					{include file="event/event_view_prelim_rounds.tpl"}

				</div>
				<div id="pilot-tab-1" class="tab-pane fade{if $tab==1} active in{/if}">
					<h2 style="float:left;">Flyoff Overall Standings</h2>
					<div style="float:right;overflow:hidden;">
						<input type="button" value=" Add Flyoff Scoring Round " onClick="document.edit_club.submit();" class="btn btn-primary btn-rounded">
					</div>
					<br style="clear:left;">
					{include file="event/event_view_flyoff_rounds.tpl"}

				</div>
				<div id="pilot-tab-2" class="tab-pane fade{if $tab==2} active in{/if}">
					<h2 style="float:left;">Pilot Roster</h2>
					<br style="clear:left;">
					{include file="event/event_view_pilot_list.tpl"}
				</div>



			</div>
		</div>
	</div>
</div>





<br>
<input type="button" value=" Print Overall Classification " onClick="print_overall.submit();" class="block-button">
<input id="printround" type="button" value=" Print Round Detail " onClick="$('#print_round').dialog('open');" class="block-button">
<input type="button" value=" View Position Chart " onClick="chart.submit();" class="block-button">
{if $user.user_id!=0 && $user.user_id==$event->info.user_id || $user.user_admin==1}
<input type="button" value=" Delete Event " onClick="confirm('Are you sure you wish to delete this event?') && event_delete.submit();" class="block-button" style="float:none;margin-right:auto;">
{/if}

{if $event->rounds|count>0 && ($event->classes|count > 1 || $event->totals.teams || $duration_rank || $speed_rank)}
<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;" id="6">
	<div class="entry clearfix" style="vertical-align:top;" id="7">                
		<h1 class="post-title entry-title header_drop">Contest Ranking Reports
			<span id="viewtoggle" style="float: right;font-size: 22px;vertical-align: middle;padding-right: 4px;" onClick="toggle('rankings',this);">Show Rankings</span>
		</h1>
		<br>
	<span id="rankings" style="display: none;">
	{if $event->classes|count > 1}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h1 class="post-title">Class Rankings</h1>
		<table cellpadding="2" cellspacing="1" class="tableborder">
			{foreach $event->classes as $c}
			{$rank=1}
					<tr>
						<th colspan="3" nowrap>{$c.class_description|escape} Rankings</th>
					</tr>
					<tr>
						<th></th>
						<th>Pilot</th>
						<th>Total</th>
					</tr>
					{foreach $event->totals.pilots as $p}
					{$event_pilot_id=$p.event_pilot_id}
					{if $event->pilots.$event_pilot_id.class_id==$c.class_id}
					<tr style="background-color: {cycle values="#9DCFF0,white"};">
						<td>{$rank}</td>
						<td nowrap>
							{include file="event/event_view_pilot_popup.tpl"}
						</td>
						<td>{$p.total|string_format:$event->event_calc_accuracy_string}</td>
					</tr>
					{$rank=$rank+1}
					{/if}
					{/foreach}
			{/foreach}
		</tr>
		</table>
	</div>
	{/if}
	{if $event->totals.teams}
	{$count=0}
	{foreach $event->options as $o}
		{if $o.event_type_option_code=='team_total_pilots'}
			{$count=$o.event_option_value}
		{/if}
	{/foreach}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h1 class="post-title">Team Rankings</h1>
		<table cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Team</th>
			<th>Total</th>
		</tr>
		{$previous=0}
		{$diff_to_lead=0}
		{$diff=0}
		{foreach $event->totals.teams as $t}
		{if $t.total>$previous}
			{$previous=$t.total}
		{else}
			{$diff=$previous-$t.total}
			{$diff_to_lead=$diff_to_lead+$diff}
		{/if}
		<tr style="background-color:#9DCFF0;">
			<td>{$t.rank}</td>
			<td nowrap>{$t.team_name|escape}</td>
			<td>
				<a href="" class="tooltip_score_left" onClick="return false;">
				{$t.total|string_format:$event->event_calc_accuracy_string}
					<span>
						<b>Behind Prev</b> : {$diff|string_format:$event->event_calc_accuracy_string}<br>
						<b>Behind Lead</b> : {$diff_to_lead|string_format:$event->event_calc_accuracy_string}<br>
					</span>
				</a>
			</td>
		</tr>
			{$num=1}
			{foreach $event->totals.pilots as $p}
			{$event_pilot_id=$p.event_pilot_id}
			{if $event->pilots.$event_pilot_id.event_pilot_team==$t.team_name}
			<tr>
				<td>{if $count>0 && $num>$count}<img src="/images/icons/exclamation.png">{/if}</td>
				<td>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td align="right">
						{$p.total|string_format:$event->event_calc_accuracy_string}
				</td>
				</a>
			</tr>
			{$num=$num+1}
			{/if}
			{/foreach}
		{$previous=$t.total}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $duration_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Duration Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $duration_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_round_flight_score!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="ecvent/event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_score}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Distance Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $distance_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_round_flight_score!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_score}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $speed_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Speed Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $speed_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_round_flight_score!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_score}
		{/foreach}
		</table>
	</div>
	{/if}
	<br>
		<input type="button" value=" Print Event Rankings " onClick="print_rank.submit();" class="block-button">
	</span>
	</div><!-- end of 7 -->
</div><!-- end of 6 -->
{/if}
<!-- Lets figure out if there are reports for speed or laps -->
{if $event->rounds|count>0 && ($lap_totals || $speed_averages || $top_landing || $event->planes|count>0)}
<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;" id="8">
	<div class="entry clearfix" style="vertical-align:top;" id="9">                
		<h1 class="post-title entry-title header_drop">Event Statistics
			<span id="viewtoggle" style="float: right;font-size: 22px;vertical-align: middle;padding-right: 4px;" onClick="toggle('stats',this);">Show Statistics</span>
		</h1>
		<br>
	<span id="stats" style="display: none;">
	{if $lap_totals}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Total Distance Laps</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $lap_totals as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_round_flight_laps!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_laps|escape}</td>
			</tr>
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_total_laps}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_laps}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Top 20 Distance Runs</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
			<th>Round</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $distance_laps as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_round_flight_laps!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_laps|escape}</td>
				<td align="center">{$p.event_round_number|escape}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_laps}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $speed_averages}
		<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Top 20 Speed Runs</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Speed</th>
			<th>Round</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $speed_times as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_round_flight_seconds!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.event_pilot_round_flight_seconds|string_format:$p.accuracy_string}</td>
				<td align="center">{$p.event_round_number|escape}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_seconds}
		{/foreach}
		</table>
	</div>
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Average Speeds</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{$oldscore=0}
		{foreach $speed_averages as $p}
			{$event_pilot_id=$p.event_pilot_id}
			{if $p.event_pilot_average_speed_rank!=0}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_average_speed!=$oldscore}
						{$p.event_pilot_average_speed_rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.event_pilot_average_speed|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{/if}
			{$oldscore=$p.event_pilot_average_speed}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $top_landing}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Landing Averages</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $top_landing as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.average_landing!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.average_landing|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.average_landing}
		{/foreach}
		</table>
	</div>
	{/if}

	{if $event->planes|count>0}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h1 class="post-title">Plane Distribution</h1>
		<table cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pos</th>
			<th>Plane</th>
			<th>Total</th>
		</tr>
		{$rank=1}
		{foreach $event->planes as $pl}
		<tr style="background-color:#9DCFF0;">
			<td>{$rank}</td>
			<td nowrap colspan="2">{$pl.name}</td>
			<td>{$pl.total}</td>
		</tr>
			{foreach $pl.pilots as $event_pilot_id}
			<tr>
				<td></td>
				<td>{$event->pilots.$event_pilot_id.event_pilot_position|escape}</td>
				<td>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td></td>
			</tr>
			{/foreach}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	<br>
	<input type="button" value=" Print Event Statistics " onClick="print_stats.submit();" class="block-button">
	</div><!-- end of 9 -->
</div><!-- end of 8 -->
{/if}

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
