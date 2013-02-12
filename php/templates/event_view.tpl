<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Settings - {$event.event_name} <input type="button" value=" Edit " onClick="edit_event.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Event Dates</th>
			<td>
			{$event.event_start_date|date_format:"%Y-%m-%d"} to {$event.event_end_date|date_format:"%Y-%m-%d"}
			</td>
		</tr>
		<tr>
			<th>Location</th>
			<td>
			{$event.location_name} - {$event.location_city},{$event.state_code} {$event.country_code}
			</td>
		</tr>
		<tr>
			<th>Event Type</th>
			<td>
			{$event.event_type_name}
			</td>
		</tr>
		</table>

		<form name="edit_event" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_edit">
		<input type="hidden" name="event_id" value="{$event.event_id}">
		</form>

	</div>
		<br>
		<h1 class="post-title entry-title">Event Pilots {if $pilots}({$total_pilots}){/if}</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Pilot #</th>
			<th>Pilot Name</th>
			<th>Pilot Team</th>
		</tr>
		{foreach $pilots as $p}
		<tr>
			<td></td>
			<td>{$p.pilot_first_name} {$p.pilot_last_name}</td>
			<td></td>
		</tr>
		{/foreach}
		</table>


</div>
</div>

