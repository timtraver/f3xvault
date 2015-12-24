<div>                
	<h2 class="post-title entry-title">Event - {$event->info.event_name|escape}</h2>
	<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="3" class="table table-condensed table-event">
		<tr>
			<th width="10%" align="right" nowrap>Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th width="10%" align="right" nowrap>Location</th>
			<td>
			{$event->info.location_name|escape} - {$event->info.location_city|escape},{$event->info.state_code|escape} {$event->info.country_code|escape}
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Event Type</th>
			<td>
			{$event->info.event_type_name|escape}
			</td>
			<th align="right" nowrap>Event Contest Director</th>
			<td>
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape} {if $event->info.pilot_city}- {$event->info.pilot_city|escape}{/if}
			</td>
		</tr>
		</table>
	</div>
</div>
