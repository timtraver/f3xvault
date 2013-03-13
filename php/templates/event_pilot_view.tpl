
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Settings - {$event->info.event_name} <input type="button" value=" Edit Event Parameters " onClick="document.event_edit.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th align="right">Location</th>
			<td>
			{$event->info.location_name} - {$event->info.location_city},{$event->info.state_code} {$event->info.country_code}
			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			{$event->info.event_type_name}
			</td>
			<th align="right">Event Contest Director</th>
			<td>
			{$event->info.pilot_first_name} {$event->info.pilot_last_name} - {$event->info.pilot_city}
			</td>
		</tr>
		</table>
		
	</div>

		<br>
		<h1 class="post-title entry-title">Pilot Round Detail for {$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="left">Round</th>
			<th colspan="{$event->flight_types|count}" align="center" nowrap>Round Types</th>
			<th width="5%" nowrap></th>
			<th width="5%" nowrap></th>
			<th width="5%" nowrap></th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			{foreach $event->flight_types as $ft}
			<th width="10%" align="center" nowrap>{$ft.flight_type_name}</th>
			{/foreach}
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Penalties</th>
			<th width="5%" nowrap>Total Score</th>
		</tr>
		<tr>
			<th width="2%" align="center"></th>
			{foreach $event->flight_types as $ft}
				<th width="10%" align="right" nowrap>{$ft.flight_type_name}</th>
			{/foreach}
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Penalties</th>
			<th width="5%" nowrap>Total Score</th>
		</tr>
		{foreach $event->rounds as $r}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				{$round=$r@key}
				<td>{$round}</td>
				{foreach $event->flight_types as $ft}
					{$flight_type_id = $ft@key}
					<td align="right" nowrap>
						{if $r.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_dropped==1}<del><font color="red">{/if}
						{$r.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_score|string_format:"%06.3f"}
						{if $r.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_dropped==1}</font></del>{/if}
					</td>
				{/foreach}
				{foreach $event->totals.pilots as $p}
					{if $p.event_pilot_id==$event_pilot_id}
						<td width="5%" align="right" nowrap>{$p.rounds.$round.event_pilot_round_total_score|string_format:"%06.3f"}</td>
						<td width="5%" align="center" nowrap></td>
						<td width="5%" nowrap></td>
					{/if}
				{/foreach}
			</tr>
		{/foreach}
		</table>


<br>
<input type="button" value=" Back To Event List " onClick="goback.submit();" class="block-button" style="float: none;margin-left: auto;margin-right: auto;">
</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>
<form name="event_edit" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
