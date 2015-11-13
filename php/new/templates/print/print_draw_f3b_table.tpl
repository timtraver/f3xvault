		<h2>{$event->info.event_name}</h2>           
		<table width="900" cellpadding="2" cellspacing="1" class="printborder">
		<tr>
			<th width="15%" align="right">Event Dates</th>
			<td nowrap>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th align="right">Location</th>
			<td nowrap>
			{$event->info.location_name|escape} - {$event->info.location_city|escape},{$event->info.state_code|escape} {$event->info.country_code|escape}
			</td>
		</tr>
		</table>
		{$bgcolor="lightgray"}
		{$oldteam="nada"}
		<h2 class="post-title entry-title">Pilot Matrix List - F3B Combined Task Matrix</h2>		
		<table cellpadding="3" cellspacing="1" style="border: 1px solid black;">
		<tr bgcolor="lightgray">
			<th colspan="2"></th>
			<th colspan="{$event->rounds|count * 3}">Event Round and Tasks</th>
		</tr>
		<tr bgcolor="lightgray">
			<th rowspan="2">Pilot</th>
			<th rowspan="2">Team</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to  || $r.flights.$flight_type_id.event_round_flight_score==0}
					{continue}
				{/if}
			<th align="center" colspan="3">{$r.event_round_number}</th>
			{/foreach}
		</tr>
		<tr bgcolor="lightgray">
			{foreach $event->rounds as $r}
				{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to  || $r.flights.$flight_type_id.event_round_flight_score==0}
					{continue}
				{/if}
			<th align="center">A</th>
			<th align="center">B</th>
			<th align="center">C</th>
			{/foreach}
		</tr>
		{foreach $event->pilots as $p}
		{$event_pilot_id=$p@key}
		{if $oldteam!=$p.event_pilot_team || $oldteam==""}
			{if $bgcolor=="white"}
				{$bgcolor="lightgray"}
			{else}
				{$bgcolor="white"}
			{/if}
		{/if}
		{$bgcolor_column=""}
		<tr bgcolor="{$bgcolor}">
			<td nowrap>
				{if $p.event_pilot_bib!='' && $p.event_pilot_bib!=0}
					<div class="pilot_bib_number_print">{$p.event_pilot_bib}</div>
					&nbsp;
				{/if}
				{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}
			</td>
			<td>{$p.event_pilot_team|escape}</td>
			{foreach $event->rounds as $r}
				{if $bgcolor_column=="" || $bgcolor_column=="lightgray"}
					{$bgcolor_column="steelblue"}
				{else}
					{$bgcolor_column=""}
				{/if}
				{$event_round_number=$r.event_round_number}
				{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to || $r.flights.$flight_type_id.event_round_flight_score==0}
					{continue}
				{/if}
				{foreach $event->flight_types as $ft}
					{$flight_type_id=$ft.flight_type_id}
					<td width="25" bgcolor="{$bgcolor_column}" align="center" nowrap>
					{if $event->flight_types.$flight_type_id.flight_type_group==1}
						{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_group}{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_lane}
					{else}
						{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_order}
					{/if}
					</td>
				{/foreach}
			{/foreach}
		</tr>
		{$oldteam=$p.event_pilot_team}
		{/foreach}
		</table>