<table cellspacing="2" cellpadding="1">
<tr>
{foreach $draw_rounds as $r}
{$round_number = $r.event_round_number}
{$flight_type_id = $r.flight_type_id}
{$bgcolor=''}
{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' ||
	$event->flight_types.$flight_type_id.flight_type_code=='td_duration' ||
	$event->flight_types.$flight_type_id.flight_type_code=='f3b_distance' ||
	$event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'}
	{$size=3}
{else}
	{$size=2}
{/if}

<td>
	<table cellpadding="2" cellspacing="1" style="border: 1px solid black;font-size:12;margin-right: 10px;margin-bottom: 10px;border-collapse:separate;" class="table-event">
	<tr>
		<th colspan="{$size}"><strong>Round {$r.event_round_number}</strong></th>
	</tr>
	{if $event->info.event_type_code=='f3k'}
		{$ftid=$r.flight_type_id}
		<tr bgcolor="white">
			<td colspan="2">{$event->flight_types.$ftid.flight_type_name_short}</td>
		</tr>
	{/if}
	{if $event->info.event_type_code=='f3j' || $event->info.event_type_code=='td'}
		{$ftid=$r.flight_type_id}
		<tr bgcolor="white">
			<td colspan="2">{$event->flight_types.$ftid.flight_type_name_short} {$event->tasks.$round_number.event_task_time_choice} min</td>
		</tr>
	{/if}
	<tr>
		{if $event->flight_types.$flight_type_id.flight_type_group && $event->flight_types.$flight_type_id.flight_type_code!='f3f_speed'}
			<th width="30">Group</th>
		{else}
			<th>&nbsp;#&nbsp;</th>
		{/if}
		<th>Pilot</th>
		{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' 
			|| $event->flight_types.$flight_type_id.flight_type_code=='td_duration'}
			<th>Spot</th>
		{elseif $event->flight_types.$flight_type_id.flight_type_code=='f3b_distance'
			|| $event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'}
			<th>Lane</th>
		{/if}
		
	</tr>
	{$oldgroup='1000'}
	{$bottom=0}
	{foreach $r.flights.$flight_type_id.pilots as $p}
		{$event_pilot_id=$p@key}
		{if $oldgroup!=$p.event_pilot_round_flight_group}
			{if $r.flights.$flight_type_id.flight_type_code=='f3b_speed' || $r.flights.$flight_type_id.flight_type_code=='f3f_speed'}
				{$bgcolor="white"}
			{else}
				{if $bgcolor=='white'}
					{$bgcolor='lightgray'}
				{else}
					{$bgcolor='white'}
				{/if}
			{/if}
			{$bottom=1}
		{/if}
		{if $event->pilots.$event_pilot_id.event_pilot_team==$highlight}
			{$highlighted=1}
		{else}
			{$highlighted=0}
		{/if}
		<tr>
			{if $event->flight_types.$flight_type_id.flight_type_group && $event->flight_types.$flight_type_id.flight_type_code!='f3f_speed'}
				<td align="center" bgcolor="{if $highlighted}{$highlight_color}{else}{$bgcolor}{/if}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$p.event_pilot_round_flight_group}</td>
			{else}
				<td align="center" bgcolor="{if $highlighted}{$highlight_color}{else}{$bgcolor}{/if}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$p.event_pilot_round_flight_order}</td>
			{/if}
			<td align="left" nowrap bgcolor="{if $highlighted}{$highlight_color}{else}{$bgcolor}{/if}" {if $bottom}style="border-top: 2px solid black;"{/if}>
				{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
					<div class="pilot_bib_number_print">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
					&nbsp;
				{/if}
				{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}
			</td>
		{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' 
			|| $event->flight_types.$flight_type_id.flight_type_code=='td_duration'
			|| $event->flight_types.$flight_type_id.flight_type_code=='f3b_distance'
			|| $event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'}
			<td align="center" bgcolor="{if $highlighted}{$highlight_color}{else}{$bgcolor}{/if}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$p.event_pilot_round_flight_lane}</td>
		{/if}
		</tr>
		{$oldgroup=$p.event_pilot_round_flight_group}
		{$bottom=0}
	{/foreach}
	</table>
</td>
{$total_rounds_shown=$total_rounds_shown+1}
{if $r@iteration is div by 4}
	</tr>
	<tr>
{/if}
{/foreach}
</tr>
</table>

{if $event->flight_types.$flight_type_id.flight_type_code!='f3f_speed'}
<h2 style="float:left;">Draw Statistics</h2>
<br style="clear:left;">

<table width="100%" cellpadding="2" cellspacing="1" class="table-event table-bordered">
<tr>
	<th width="20%" align="right" nowrap>Draw Flight Type</th>
	<td>
		{if $draw_info.event_type_code=='f3k'}
			F3K
		{else}
			{$draw_info.flight_type_name}
		{/if}
	</td>
</tr>
<tr>
	<th width="10%" align="right" nowrap>Round Range</th>
	<td>
		{$draw_info.event_draw_round_from} to {$draw_info.event_draw_round_to}
	</td>
</tr>
<tr>
	<th nowrap align="right">Team Protection</th>
	<td>
		{if $draw_info.event_draw_team_protection==1} ON{else}OFF{/if}
	</td>
</tr>
<tr>
	<th nowrap align="right" valign="top">Flight Groups</th>
	<td>
		There are currently <b>{$stats|count}</b> Pilots in this event{if $draw_info.teams|count > 1} on {$draw_info.teams|count} teams{/if}.<br>
		You have selected to have {$draw_info.event_draw_number_groups} flight groups,
		resulting in {foreach $draw_info.group_totals as $g}{$num_groups=$g@key}{$g} group{if $g>1}s{/if} of {$num_groups}{if !$g@last} and {/if}{/foreach}
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
		<div id="stat_chart_div" style="height: 300px; width: 600px;"></div>
	</td>
</tr>
<tr>
	<th nowrap align="right" valign="top">Matchup Details<br>(Mouse over for details)</th>
	<td>
		{foreach $stats as $p}
			{$event_pilot_id=$p@key}
			<a href="" class="tooltip_stat">{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}
				<span>
				<img class="callout_stat" src="/images/callout.gif">
				<strong>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</strong> - {$event->pilots.$event_pilot_id.event_pilot_team}
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
							{$event->pilots.$event_pilot_id2.pilot_first_name} {$event->pilots.$event_pilot_id2.pilot_last_name}
						</td>
						<td align="right" nowrap>
							{$event->pilots.$event_pilot_id2.event_pilot_team}
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
{/if}




