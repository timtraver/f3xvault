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
		<h3 class="post-title">Top Distance Runs</h3>
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
			{if $rank==$show_top}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_laps}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $speed_averages}
		<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Top Speed Runs</h3>
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
			{if $rank==$show_top}{break}{/if}
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
		<h3 class="post-title">Top First Lap Times</h3>
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
			{if $rank==$show_top}{break}{/if}
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
			{if $rank==$show_top}{break}{/if}
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
			{if $rank==$show_top}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.average_start_height}
		{/foreach}
		</table>
	</div>
	{/if}

	{if $made_time_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Made 95% Time</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Rnds</th>
			<th>%</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $made_time_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr>
				<td>
					{if $p.percent_made!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.event_pilot_made_time|escape}</td>
				<td>{$p.percent_made|string_format:$event->event_calc_accuracy_string}%</td>
			</tr>
			{if $rank==$show_top}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.percent_made}
		{/foreach}
		</table>
	</div>
	{/if}

	{if $height_time_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Height Avg of 95% Times</h3>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Rnds</th>
			<th>Avg(m)</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $height_time_rank as $p}
			{if $p.average_height == 0}{continue}{/if}
			{$event_pilot_id=$p.event_pilot_id}
			<tr>
				<td>
					{if $p.average_height!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.number_rounds|escape}</td>
				<td>{$p.average_height|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{if $rank==$show_top}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.average_height}
		{/foreach}
		</table>
	</div>
	{/if}

	{if $aggressive_index}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">                
		<h3 class="post-title">Aggression Index</h3>
		<h4 class="post-title">Lower = More Aggressive</h4>
		<h4 class="post-title">Average == 1</h4>
		<table align="center" cellpadding="2" cellspacing="1" class="table_bordered table-event table-striped">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
			<th>Pos</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $aggressive_index as $p}
			{if $p.average == 0}{continue}{/if}
			{$event_pilot_id=$p.event_pilot_id}
			<tr>
				<td>
					{if $p.average!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event/event_view_pilot_popup.tpl"}
				</td>
				<td>{$p.average|string_format:$event->event_calc_accuracy_string}</td>
				<td>{$event->pilots.$event_pilot_id.event_pilot_position}</td>
			</tr>
			{if $rank==$show_top}{break}{/if}
			{$rank=$rank+1}
			{$oldscore=$p.average}
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
	<div style=";padding-left: 10px;">                
		<h3 class="post-title">Stats Glossary</h3>
		<table style="border-spacing: 3px;" class="table table-conddensed table-bordered">
		<tr>
			<th>Stat Name</th>
			<th>Description</th>
		</tr>
		{if $lap_totals}
			<tr>
				<th nowrap>Total Distance Laps</th>
				<td>The total number of distance laps over the course of the event.</td>
			</tr>
		{/if}
		{if $distance_laps}
			<tr>
				<th nowrap>Top Distance Runs</th>
				<td>Individual distance runs in rounds. Round of recorded flight included.</td>
			</tr>
		{/if}
		{if $speed_averages}
			<tr>
				<th nowrap >Top Speed Runs</th>
				<td>Time of speed round in seconds. Round of recorded time included.</td>
			</tr>
		{/if}
		{if $speed_averages}
			<tr>
				<th nowrap >Average Speed</th>
				<td>Average speeds of all F3F runs for a pilot.</td>
			</tr>
		{/if}
		{if $climbout_averages}
			<tr>
				<th nowrap >Climb Out Average</th>
				<td>Average time taken before coming on course to start an F3F run.</td>
			</tr>
		{/if}
		{if $first_lap_speeds}
			<tr>
				<th nowrap >Top First Lap Times</th>
				<td>Time in seconds of the first lap in an F3F run. Round the speed was recorded in is included.</td>
			</tr>
		{/if}
		{if $first_lap_averages}
			<tr>
				<th nowrap >First Lap Average</th>
				<td>Average time in seconds of the first lap in an F3F run. Meters/second and MPH are calculated</td>
			</tr>
		{/if}
		{if $top_landing}
			<tr>
				<th nowrap >Landing Averages</th>
				<td>Average landing score when a landing was attempted. Does not include zero flights or dropped rounds. It does include rounds where a time is made but the landing is zero.</td>
			</tr>
		{/if}
		{if $start_height}
			<tr>
				<th nowrap>Start Height Averages</th>
				<td>Average start height of rounds. Zero and dropped rounds are not included.</td>
			</tr>
		{/if}
		{if $made_time_rank}
			<tr>
				<th nowrap>Made 95% Time</th>
				<td>Simple statistic of how many rounds a pilot has made 95% of the time. 95% of time is equivalent to 9:30 or better. Does not drop ANY rounds.</td>
			</tr>
		{/if}
		{if $height_time_rank}
			<tr>
				<th nowrap>Height Avg of 95% Times</th>
				<td>Of the pilots rounds where they achieved 95% of the working time, the average of their start height. I believe that the pilot that made more of their total times should score higher in this index, which is why the order is sorted by number of 95% rounds and then start height.</td>
			</tr>
		{/if}
		{if $aggressive_index}
			<tr>
				<th nowrap>Aggression Index</th>
				<td>Average start heights in each group are calculated and the sum of the pilots percentage deviations from the average are calculated and averaged. A score of 1 means the pilot launched to average height. This stat does not include zero flights or dropped rounds.</td>
			</tr>
		{/if}
		{if $event->planes|count>0}
			<tr>
				<th nowrap>Plane Distribution</th>
				<td>How many pilots are flying the specified plane types.</td>
			</tr>
		{/if}
		</table>
	</div>
	<br>
	<input type="button" value=" Print Event Statistics " onClick="print_stats.submit();" class="btn btn-primary btn-rounded">
	<br>
	</div>
</div>