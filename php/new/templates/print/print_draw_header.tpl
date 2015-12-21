<h2>{$event->info.event_name}</h2>           
<table width="600" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
<tr>
	<th width="10%">Event Dates</th>
	<td nowrap>
	{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
	</td>
	<th width="10%">Location</th>
	<td nowrap>
	{$event->info.location_name|escape} - {$event->info.location_city|escape},{$event->info.state_code|escape} {$event->info.country_code|escape}
	</td>
</tr>
</table>