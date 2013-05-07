
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
			{if $event->info.event_type_code!='f3k'}
			{$cols=0}
			{foreach $event->flight_types as $ft}
				{$cols=$cols+4}
				{if $ft.flight_type_group}{$cols=$cols+1}{/if}
				{if $ft.flight_type_seconds}{$cols=$cols+1}{/if}
				{if $ft.flight_type_landing}{$cols=$cols+1}{/if}
				{if $ft.flight_type_laps}{$cols=$cols+1}{/if}	
			{/foreach}
			{else}
				{$cols=7}
			{/if}
			<th colspan="{$cols}" align="center" nowrap>Round Data</th>
			<th width="5%" nowrap>Total</th>
		</tr>
		{if $event->info.event_type_code!='f3k'}
		<tr>
			<th width="2%" align="left"></th>
			{foreach $event->flight_types as $ft}
				{$cols=4}
				{if $ft.flight_type_group}{$cols=$cols+1}{/if}
				{if $ft.flight_type_seconds}{$cols=$cols+1}{/if}
				{if $ft.flight_type_landing}{$cols=$cols+1}{/if}
				{if $ft.flight_type_laps}{$cols=$cols+1}{/if}	
				<th align="center" colspan="{$cols}" nowrap>{$ft.flight_type_name}</th>
			{/foreach}
			<th width="5%" nowrap></th>
		</tr>
		{/if}
		
		
		{if $event->info.event_type_code!='f3k'}
		<tr>
			<th width="2%" align="center"></th>
			{foreach $event->flight_types as $ft}
				{if $ft.flight_type_group}
					<th align="center">Group</th>
				{/if}
				{if $ft.flight_type_minutes || $ft.flight_type_seconds}
					<th align="center">Time</th>
				{/if}
				{if $ft.flight_type_landing}
					<th align="center">Landing</th>
				{/if}
				{if $ft.flight_type_laps}
					<th align="center">Laps</th>
				{/if}
				<th align="center">Raw</th>
				<th align="center">Score</th>
				<th align="center">Pen</th>
				<th align="center">Rank</th>
			{/foreach}
			<th width="5%" nowrap></th>
		</tr>
		{else}
		<tr>
			<th width="2%" align="center"></th>
			<th align="center">Task</th>
			<th align="center">Group</th>
			<th align="center">Time</th>
			<th align="center">Raw</th>
			<th align="center">Score</th>
			<th align="center">Pen</th>
			<th align="center">Rank</th>
			<th width="5%" nowrap></th>
		</tr>
		{/if}
		{$flyoff_label=0}
		{foreach $event->rounds as $r}
			{$round_pen=0}
			{$round_total=0}
			{if $r.event_round_flyoff!=0 && $flyoff_label==0}
			<tr>
				<th colspan="2" style="color:red;">Flyoffs</th>
			</tr>
			{$flyoff_label=1}
			{/if}
			<tr>
				{$round=$r@key}
				{$bgcolor='#9DCFF0'}
				<td align="center" style="background-color: {$bgcolor};">{$round}</td>
				{foreach $event->flight_types as $ft}
					{$flight_type_id = $ft@key}
					{if $event->info.event_type_code=='f3k' && $ft.flight_type_id!=$r.flight_type_id}
						{continue}
					{/if}
					{$values=$r.flights.$flight_type_id.pilots.$event_pilot_id}
					{if $values.event_pilot_round_flight_reflight_dropped==1}
						{foreach $r.reflights as $rf}
							{if $rf@key!=$flight_type_id}{continue}{/if}
							{foreach $rf.pilots as $rp}
								{if $rp@key!=$event_pilot_id}{continue}{/if}
								{if $rp.event_pilot_round_flight_reflight_dropped==0}
									{$values=$rp}
								{/if}
							{/foreach}
						{/foreach}
					{/if}

					{if $bgcolor=='white'}{$bgcolor='#9DCFF0'}{else}{$bgcolor='white'}{/if}
					{if $event->info.event_type_code=='f3k'}
						<th width="5%" align="left" nowrap style="background-color: {$bgcolor};">
							{$ft.flight_type_name}
						</th>
					{/if}
					{if $ft.flight_type_group}
						<td align="center" nowrap style="background-color: {$bgcolor};">
							{if $r.flights.$flight_type_id.event_round_flight_score==1}
							{$values.event_pilot_round_flight_group}{if $values.event_pilot_round_flight_reflight}(R){/if}
							{/if}
						</td>					
					{/if}
					{if $ft.flight_type_minutes || $ft.flight_type_seconds}
						<td align="right" nowrap style="background-color: {$bgcolor};">
							{if $r.flights.$flight_type_id.event_round_flight_score==1}
							
								{if $r.flights.$flight_type_id.flight_type_sub_flights!=0}
									{foreach $values.sub as $s}
									<span style="background-color: #9DCFF0;padding: 3px;">{$s.event_pilot_round_flight_sub_val}</span>
									{/foreach}
									= 
								{/if}
								{if $ft.flight_type_minutes}{$values.event_pilot_round_flight_minutes}m{/if}
								{if $ft.flight_type_seconds}{$values.event_pilot_round_flight_seconds}s{/if}
							{/if}
						</td>
					{/if}
					{if $ft.flight_type_landing}
						<td align="center" style="background-color: {$bgcolor};">
							{if $r.flights.$flight_type_id.event_round_flight_score==1}
								{$values.event_pilot_round_flight_landing}
							{/if}
						</td>
					{/if}
					{if $ft.flight_type_laps}
						<td align="center" style="background-color: {$bgcolor};">
							{if $r.flights.$flight_type_id.event_round_flight_score==1}
								{$values.event_pilot_round_flight_laps}
							{/if}
						</td>
					{/if}
					<td align="right" nowrap style="background-color: {$bgcolor};">
						{if $r.flights.$flight_type_id.event_round_flight_score==1}
							{if $ft.flight_type_code=='f3f_speed' OR $ft.flight_type_code=='f3b_speed'}
								{$values.event_pilot_round_flight_raw_score}
							{else}
								{$values.event_pilot_round_flight_raw_score|string_format:"%02.0f"}
							{/if}
						{/if}
					</td>
					<td align="right" nowrap style="background-color: {$bgcolor};">
						{if $r.flights.$flight_type_id.event_round_flight_score==1}
							{if $values.event_pilot_round_flight_dropped==1}<del><font color="red">{/if}
							{$values.event_pilot_round_flight_score|string_format:"%06.3f"}
							{if $values.event_pilot_round_flight_dropped==1}</font></del>{/if}
							{$round_total=$round_total+$values.event_pilot_round_flight_score}
						{/if}
					</td>
					<td align="center" nowrap style="background-color: {$bgcolor};">
						{if $r.flights.$flight_type_id.event_round_flight_score==1}
							{if $values.event_pilot_round_flight_penalty!=0}{$values.event_pilot_round_flight_penalty}{/if}
							{$round_pen=$round_pen+$values.event_pilot_round_flight_penalty}
						{/if}
					</td>
					<td align="center" nowrap style="background-color: {$bgcolor};">
						{if $r.flights.$flight_type_id.event_round_flight_score==1}
							{$values.event_pilot_round_flight_rank}
						{/if}
					</td>
				{/foreach}
				{foreach $event->totals.pilots as $p}
					{if $p.event_pilot_id==$event_pilot_id}
						{if $bgcolor=='white'}{$bgcolor='#9DCFF0'}{else}{$bgcolor='white'}{/if}
						{$round_total=$round_total-$round_pen}
						<td width="5%" nowrap style="background-color: {$bgcolor};">{$round_total|string_format:"%06.3f"}</td>
					{/if}
				{/foreach}
			</tr>
		{/foreach}
		</table>
		
		<br>
		<h1 class="post-title entry-title">Pilot Totals for {$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</h1>
		<table width="50%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Overall Rank</th>
			<td>{$event->pilots[$event_pilot_id]['event_pilot_position']}</td>
		</tr>
		<tr>
			<th>Total Points</th>
			<td>{$event->pilots[$event_pilot_id]['event_pilot_total_score']|string_format:"%06.3f"}</td>
		</tr>
		<tr>
			<th>Event Percentage</th>
			<td>{$event->pilots[$event_pilot_id]['event_pilot_total_percentage']|string_format:"%06.3f"} %</td>
		</tr>
		{if $event->pilots[$event_pilot_id]['event_pilot_total_laps']>0}
		<tr>
			<th>Total Distance Laps</th>
			<td>{$event->pilots[$event_pilot_id]['event_pilot_total_laps']} (rank {$event->pilots[$event_pilot_id]['event_pilot_lap_rank']})</td>
		</tr>
		{/if}
		{if $event->pilots[$event_pilot_id]['event_pilot_average_speed']>0}
		<tr>
			<th>Pilot Average Speed</th>
			<td>{$event->pilots[$event_pilot_id]['event_pilot_average_speed']|string_format:"%06.3f"} (rank {$event->pilots[$event_pilot_id]['event_pilot_average_speed_rank']})</td>
		</tr>
		{/if}
		</table>
<br>
<input type="button" value=" Back To Event View " onClick="goback.submit();" class="block-button">
<input type="button" value=" Print Pilot Results " onClick="print_pilot.submit();" class="block-button">
</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_edit" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="print_pilot" action="?" method="GET" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_pilot">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_pilot_id" value="{$event_pilot_id}">
<input type="hidden" name="use_print_header" value="1">
</form>
