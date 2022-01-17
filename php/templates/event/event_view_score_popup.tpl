<span>
	<img class="callout" src="/images/callout.gif">
	<strong>Flight Detail</strong><br>
	<table>
	{$event_round_number=$r@key}
	{foreach $event->rounds.$event_round_number.flights as $f}
		{if $f.flight_type_code|strstr:'duration' || $f.flight_type_code|strstr:'f3k'}
			<tr><th nowrap="nowrap">{$f.flight_type_name}</th>
			<td nowrap="nowrap">
				{$f.pilots.$event_pilot_id.event_pilot_round_flight_minutes|escape}:{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}
				{if $f.flight_type_landing} - {$f.pilots.$event_pilot_id.event_pilot_round_flight_landing|escape}{/if}
				{if $f.flight_type_start_height} - {$f.pilots.$event_pilot_id.event_pilot_round_flight_start_height|escape}{/if}
			</td>
			</tr>
		{/if}
		{if $f.flight_type_code|strstr:'distance'}
			<tr><th nowrap="nowrap">{$f.flight_type_name}</th>
			<td nowrap="nowrap">
				{$f.pilots.$event_pilot_id.event_pilot_round_flight_laps|escape} Laps
			</td>
			</tr>
		{/if}
		{if $f.flight_type_code|strstr:'position'}
			<tr><th nowrap="nowrap">{$f.flight_type_name}</th>
			<td nowrap="nowrap">
				{if $f.pilots.$event_pilot_id.event_pilot_round_flight_dnf == 1}
					<font color="red">DNF</font>
				{else}
					{$f.pilots.$event_pilot_id.event_pilot_round_flight_position|escape}
				{/if}
			</td>
			</tr>
			<tr><th nowrap="nowrap">Score</th>
			<td nowrap="nowrap">
				{$f.pilots.$event_pilot_id.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}
			</td>
			</tr>
		{/if}
		{if $f.flight_type_code|strstr:'speed' || $f.flight_type_code|strstr:'f3f'}
			<tr><th nowrap="nowrap">{$f.flight_type_name}</th>
			<td nowrap="nowrap">
				{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}s
			</td>
			</tr>
		{/if}
		{if $drop==1}
			<tr>
				<td colspan="2" align="center" nowrap="nowrap"><div style="color:red;">Score Dropped</div></td>
			</tr>
		{/if}
	{/foreach}
	</table>
</span>
