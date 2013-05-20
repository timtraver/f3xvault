		<h2>{$event->info.event_name}</h2>           
		<table width="600" cellpadding="2" cellspacing="1" class="printborder">
		<tr>
			<th width="15%" align="right">Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th align="right">Location</th>
			<td>
			{$event->info.location_name|escape} - {$event->info.location_city|escape},{$event->info.state_code|escape} {$event->info.country_code|escape}
			</td>
		</tr>
		</table>
		<h2 class="post-title entry-title" style="margin:0px;">Draw Matrix - {$event->flight_types.$flight_type_id.flight_type_name}</h2>	
		{foreach $event->rounds as $r}
		{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to || $r.flights.$flight_type_id.event_round_flight_score==0}
			{continue}
		{/if}
		<table width="200" {if $r@iteration is not div by 5 && !$r@last}align="left"{/if} cellpadding="2" cellspacing="1" style="border: 1px solid black;font-size:12;">
		<tr bgcolor="lightgray">
			<th colspan="2">Round {$r.event_round_number}</th>
		</tr>
		<tr bgcolor="lightgray">
			{if $event->flight_types.$flight_type_id.flight_type_group}
				<th>Group</th>
			{else}
				<th>Order</th>
			{/if}
			<th>Pilot</th>
		</tr>
		{$oldgroup='1000'}
		{$bottom=0}
		{foreach $r.flights.$flight_type_id.pilots as $p}
		{$event_pilot_id=$p@key}
		{if $oldgroup!=$p.event_pilot_round_flight_group}
			{if $bgcolor=='white' || $r.flights.$flight_type_id.flight_type_code=='f3b_speed' || $r.flights.$flight_type_id.flight_type_code=='f3f_speed'}
				{$bgcolor='lightgray'}
			{else}
				{$bgcolor='white'}
			{/if}
			{$bottom=1}
		{/if}
		<tr>
			{if $event->flight_types.$flight_type_id.flight_type_group}
				<td align="center" bgcolor="{$bgcolor}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$p.event_pilot_round_flight_group}</td>
			{else}
				<td align="center" bgcolor="{$bgcolor}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$p.event_pilot_round_flight_order}</td>
			{/if}
			<td align="left" bgcolor="{$bgcolor}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</td>
		</tr>
		{$oldgroup=$p.event_pilot_round_flight_group}
		{$bottom=0}
		{/foreach}
		</table>
		{$total_rounds_shown=$total_rounds_shown+1}
		{if $r@iteration is div by 5}
			<br style="page-break-after: always;">
		{/if}
		{/foreach}