<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;" id="8">
	<div class="entry clearfix" style="vertical-align:top;" id="9">                

	{if $lap_totals}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Total Distance Laps</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $lap_totals as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr>
				<td>
					{if $p.event_pilot_round_flight_laps!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_laps|escape}</td>
			</tr>
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_total_laps}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_laps}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Top 20 Distance Runs</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
			<th>Round</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $distance_laps as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr>
				<td>
					{if $p.event_pilot_round_flight_laps!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_laps|escape}</td>
				<td align="center">{$p.event_round_number|escape}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_laps}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $speed_averages}
		<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Top 20 Speed Runs</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Speed</th>
			<th>Round</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $speed_times as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr>
				<td>
					{if $p.event_pilot_round_flight_seconds!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.event_pilot_round_flight_seconds|string_format:$p.accuracy_string}</td>
				<td align="center">{$p.event_round_number|escape}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_seconds}
		{/foreach}
		</table>
	</div>
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Average Speeds</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{$oldscore=0}
		{foreach $speed_averages as $p}
			{$event_pilot_id=$p.event_pilot_id}
			{if $p.event_pilot_average_speed_rank!=0}
			<tr>
				<td>
					{if $p.event_pilot_average_speed!=$oldscore}
						{$p.event_pilot_average_speed_rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.event_pilot_average_speed|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{/if}
			{$oldscore=$p.event_pilot_average_speed}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $climbout_averages}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Climb Out Average</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Pilot</th>
			<th>Avg(s)</th>
		</tr>
		{foreach $climbout_averages as $event_pilot_id => $p}
			<tr>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>
					{$p.average|string_format:$event->event_calc_accuracy_string}
				</td>
			</tr>
		{/foreach}
		</table>
	</div>
	{/if}

	{if $first_lap_speeds}
		<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Top 20 First Lap Times</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Time</th>
			<th>Round</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $first_lap_speeds as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr>
				<td>
					{if $p.first_lap_speed!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.first_lap_speed|string_format:$p.accuracy_string}</td>
				<td align="center">{$p.event_round_number|escape}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.first_lap_speed}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $first_lap_averages}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">First Lap Average</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg(s)</th>
			<th>m/s</th>
			<th>mph</th>
		</tr>
		{$rank=1}
		{foreach $first_lap_averages as $event_pilot_id => $p}
			<tr>
				<td>
					{if $p.average!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>
					{$p.average|string_format:$event->event_calc_accuracy_string}
				</td>
				<td>{$p.average_speed_m|string_format:$p.accuracy_string}</td>
				<td>{$p.average_speed_mph|string_format:$p.accuracy_string}</td>
			</tr>
			{$oldscore=$p.average}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $top_landing}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Landing Averages</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $top_landing as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr>
				<td>
					{if $p.average_landing!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.average_landing|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.average_landing}
		{/foreach}
		</table>
	</div>
	{/if}

	{if $start_height}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Start Height Averages</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $start_height as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr>
				<td>
					{if $p.average_start_height!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.average_start_height|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.average_start_height}
		{/foreach}
		</table>
	</div>
	{/if}

	{if $event->planes|count>0}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-right: 10px;">                
		<h3 class="post-title">Plane Distribution</h3>
		<table cellpadding="2" cellspacing="1" class="table_bordered table-event">
		<tr>
			<th></th>
			<th>Pos</th>
			<th>Plane</th>
			<th>Total</th>
		</tr>
		{$rank=1}
		{foreach $event->planes as $pl}
		<tr style="background-color:#9DCFF0;">
			<td>{$rank}</td>
			<td nowrap colspan="2">{$pl.name}</td>
			<td>{$pl.total}</td>
		</tr>
			{foreach $pl.pilots as $event_pilot_id}
			<tr>
				<td></td>
				<td>{$event->pilots.$event_pilot_id.event_pilot_position|escape}</td>
				<td>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td></td>
			</tr>
			{/foreach}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	<br>
	<input type="button" value=" Print Event Statistics " onClick="print_stats.submit();" class="btn btn-primary btn-rounded">
	<br>
	</div>
</div>