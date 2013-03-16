<div class="page type-page status-publish hentry clearfix post nodate"  style="-webkit-print-color-adjust:exact;">
	<div class="entry clearfix">                
		<h2 class="post-title entry-title">Event - {$event->info.event_name}</h2>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" border="solid">
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

{if $event->classes|count > 1 || $event->totals.teams || $duration_rank || $speed_rank}
<h2 class="post-title">Contest Ranking Reports</h2>
<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;">
	{if $event->classes|count > 1}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h2 class="post-title">Class Rankings</h2>
		<table cellpadding="2" cellspacing="1" class="tableborder">
			{foreach $event->classes as $c}
			{$rank=1}
					<tr>
						<th colspan="3" nowrap>{$c.class_description} Rankings</th>
					</tr>
					<tr>
						<th></th>
						<th>Pilot</th>
						<th>Total</th>
					</tr>
					{foreach $event->totals.pilots as $p}
					{$event_pilot_id=$p.event_pilot_id}
					{if $event->pilots.$event_pilot_id.class_id==$c.class_id}
					<tr style="background-color: {cycle values="#9DCFF0,white"};">
						<td>{$rank}</td>
						<td nowrap>{$p.pilot_first_name} {$p.pilot_last_name}</td>
						<td>{$p.total|string_format:"%06.3f"}</td>
					</tr>
					{$rank=$rank+1}
					{/if}
					{/foreach}
			{/foreach}
		</tr>
		</table>
	</div>
	{/if}
	{if $event->totals.teams}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h2 class="post-title">Team Rankings</h2>
		<table cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Team</th>
			<th>Total</th>
		</tr>
		{foreach $event->totals.teams as $t}
		<tr style="background-color:#9DCFF0;">
			<td>{$t.rank}</td>
			<td nowrap>{$t.team_name}</td>
			<td>{$t.total|string_format:"%06.3f"}</td>
		</tr>
			{foreach $event->totals.pilots as $p}
			{$event_pilot_id=$p.event_pilot_id}
			{if $event->pilots.$event_pilot_id.event_pilot_team==$t.team_name}
			<tr>
				<td></td>
				<td>{$p.pilot_first_name} {$p.pilot_last_name}</td>
				<td align="right">{$p.total|string_format:"%06.3f"}</td>
			</tr>
			{/if}
			{/foreach}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $duration_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h2 class="post-title">Duration Ranking</h2>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{foreach $duration_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:"%06.3f"}</td>
			</tr>
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $speed_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h2 class="post-title">Speed Ranking</h2>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{foreach $speed_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:"%06.3f"}</td>
			</tr>
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h2 class="post-title">Distance Ranking</h2>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{foreach $distance_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:"%06.3f"}</td>
			</tr>
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
	
</div>
{/if}

<!-- Lets figure out if there are reports for speed or laps -->
{if $lap_totals || $speed_averages || $top_landing}
<h1 class="post-title" style="page-break-before: always">Statistics Reports</h1>
<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;">
	{if $lap_totals}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h2 class="post-title">Total Distance Laps</h2>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
		</tr>
		{foreach $lap_totals as $p}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$p.event_pilot_lap_rank}</td>
				<td nowrap>{$p.pilot_first_name} {$p.pilot_last_name}</td>
				<td align="center">{$p.event_pilot_total_laps}</td>
			</tr>
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_laps}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h2 class="post-title">Top 20 Distance Runs</h2>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
		</tr>
		{$rank=1}
		{foreach $distance_laps as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</td>
				<td align="center">{$p.event_pilot_round_flight_laps}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $speed_averages}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h2 class="post-title">Average Speeds</h2>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{foreach $speed_averages as $p}
			{if $p.event_pilot_average_speed_rank!=0}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$p.event_pilot_average_speed_rank}</td>
				<td nowrap>{$p.pilot_first_name} {$p.pilot_last_name}</td>
				<td>{$p.event_pilot_average_speed|string_format:"%06.3f"}</td>
			</tr>
			{/if}
		{/foreach}
		</table>
	</div>
	
		<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h2 class="post-title">Top 20 Speed Runs</h2>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Speed</th>
			<th>Round</th>
		</tr>
		{$rank=1}
		{foreach $speed_times as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</td>
				<td>{$p.event_pilot_round_flight_seconds|string_format:"%06.3f"}</td>
				<td align="center">{$p.event_round_number}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $top_landing}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h2 class="post-title">Landing Averages</h2>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{$rank=1}
		{foreach $top_landing as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</td>
				<td>{$p.average_landing|string_format:"%02.2f"}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
</div>
{/if}
