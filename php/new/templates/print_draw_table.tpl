		<h2>{$event->info.event_name}</h2>           
		<table width="600" cellpadding="2" cellspacing="1" class="printborder">
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
		<h2 class="post-title entry-title">Pilot Matrix List{if $event->info.event_type_code!="f3k"} - {$event->flight_types.$flight_type_id.flight_type_name}{/if}</h2>		
		<table width="550" cellpadding="3" cellspacing="1" style="border: 1px solid black;">
		<tr bgcolor="lightgray">
			<th width="250" colspan="2"></th>
			<th colspan="{$event->rounds|count}">Event Round / Group
			{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' 
						|| $event->flight_types.$flight_type_id.flight_type_code=='td_duration'}
				/ Spot
			{elseif $event->flight_types.$flight_type_id.flight_type_code=='f3b_distance'
						|| $event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'}
				/ Lane
			{else}
				/ Order
			{/if}
			</th>
		</tr>
		<tr bgcolor="lightgray">
			<th width="150">Pilot</th>
			<th width="100">Team</th>
			{foreach $event->rounds as $r}
				{if $event->info.event_type_code=="f3k"}
					{$flight_type_id=$r.flight_type_id}
				{/if}
				{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to  || $r.flights.$flight_type_id.event_round_flight_score==0}
					{continue}
				{/if}
			<th width="25" align="center">{$r.event_round_number}</th>
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
				{if $event->info.event_type_code=="f3k"}
					{$flight_type_id=$r.flight_type_id}
				{/if}
				{$event_round_number=$r.event_round_number}
				{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to || $r.flights.$flight_type_id.event_round_flight_score==0}
					{continue}
				{/if}
				<td align="center">
				{if $event->flight_types.$flight_type_id.flight_type_group==1}
					{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_group}{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' 
						|| $event->flight_types.$flight_type_id.flight_type_code=='td_duration'
						|| $event->flight_types.$flight_type_id.flight_type_code=='f3b_distance'
						|| $event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'}{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_lane}{/if}
				{else}
					{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_order}
				{/if}
				</td>
			{/foreach}
		</tr>
		{$oldteam=$p.event_pilot_team}
		{/foreach}
		</table>