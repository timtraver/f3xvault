	<span>
		<img class="callout" src="/images/callout.gif">
		{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
			<div class="pilot_bib_number_big">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
		{/if}
		{if $event->pilots.$event_pilot_id.country_code}<img src="/images/flags/countries-iso/shiny/48/{$event->pilots.$event_pilot_id.country_code|escape}.png" class="inline_flag_top" title="{$p.country_name}">{/if}
		<strong>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</strong><br>
		<table>
			<tr><th>Country</th><td> {$event->pilots.$event_pilot_id.country_name|escape}</td></tr>
			{if $event->pilots.$event_pilot_id.state_name!='Other'}
			<tr><th>State</th><td> {$event->pilots.$event_pilot_id.state_name|escape}</td></tr>
			{/if}
			{if $event->pilots.$event_pilot_id.event_pilot_team!=''}
			<tr><th>Team</th><td> {$event->pilots.$event_pilot_id.event_pilot_team|escape}</td></tr>
			{/if}
			<tr><th>Current Position</th><td>{$event->pilots.$event_pilot_id.event_pilot_position|ordinal}</td></tr>
			<tr><th>Flying Plane</th><td>{$event->pilots.$event_pilot_id.plane_name|escape}</td></tr>
		</table>
	</span>
