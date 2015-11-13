<div class="page type-page status-publish hentry clearfix post nodate" style="-webkit-print-color-adjust:exact;">
	<div class="entry clearfix">                
		<h2 class="post-title entry-title">Event - {$event->info.event_name|escape}</h2>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="3" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th align="right">Location</th>
			<td>
			{$event->info.location_name|escape} - {$event->info.location_city|escape},{$event->info.state_code|escape} {$event->info.country_code|escape}
			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			{$event->info.event_type_name|escape}
			</td>
			<th align="right">Event Contest Director</th>
			<td>
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape} - {$event->info.pilot_city|escape}
			</td>
		</tr>
		</table>
		
	</div>

	<h1 class="post-title entry-title">Event Individual and Team Rankings</h1>
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h1 class="post-title">Class Rankings</h1>
		<table cellpadding="2" cellspacing="1" class="tableborder" style="border:1px solid;">
			{foreach $event->classes as $c}
			{$rank=1}
					<tr>
						<th colspan="3" nowrap>{$c.class_description|escape} Rankings</th>
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
						<td nowrap>
							{include file="event_view_pilot_popup.tpl"}
						</td>
						<td>{$p.total|string_format:$event->event_calc_accuracy_string}</td>
					</tr>
					{$rank=$rank+1}
					{/if}
					{/foreach}
			{/foreach}
		</tr>
		</table>
	</div>

	{if $event->totals.teams}
	{$count=0}
	{foreach $event->options as $o}
		{if $o.event_type_option_code=='team_total_pilots'}
			{$count=$o.event_option_value}
		{/if}
	{/foreach}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h1 class="post-title">Team Rankings</h1>
		<table cellpadding="2" cellspacing="1" class="tableborder" style="border:1px solid;">
		<tr>
			<th></th>
			<th>Team</th>
			<th>Total</th>
		</tr>
		{$previous=0}
		{$diff_to_lead=0}
		{$diff=0}
		{foreach $event->totals.teams as $t}
		{if $t.total>$previous}
			{$previous=$t.total}
		{else}
			{$diff=$previous-$t.total}
			{$diff_to_lead=$diff_to_lead+$diff}
		{/if}
		<tr style="background-color:#9DCFF0;">
			<td>{$t.rank}</td>
			<td nowrap>{$t.team_name|escape}</td>
			<td>
				<a href="" class="tooltip_score_left" onClick="return false;">
				{$t.total|string_format:$event->event_calc_accuracy_string}
					<span>
						<b>Behind Prev</b> : {$diff|string_format:$event->event_calc_accuracy_string}<br>
						<b>Behind Lead</b> : {$diff_to_lead|string_format:$event->event_calc_accuracy_string}<br>
					</span>
				</a>
			</td>
		</tr>
			{$num=1}
			{foreach $event->totals.pilots as $p}
			{$event_pilot_id=$p.event_pilot_id}
			{if $event->pilots.$event_pilot_id.event_pilot_team==$t.team_name}
			<tr>
				<td>{if $count>0 && $num>$count}<img src="/images/icons/exclamation.png">{/if}</td>
				<td>
					{include file="event_view_pilot_popup.tpl"}
				</td>
				<td align="right">
						{$p.total|string_format:$event->event_calc_accuracy_string}
				</td>
				</a>
			</tr>
			{$num=$num+1}
			{/if}
			{/foreach}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $duration_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Duration Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder" style="border:1px solid;">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $duration_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_round_flight_score!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_score}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Distance Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder" style="border:1px solid;">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $distance_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_round_flight_score!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_score}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $speed_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Speed Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder" style="border:1px solid;">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{$oldscore=0}
		{foreach $speed_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>
					{if $p.event_pilot_round_flight_score!=$oldscore}
						{$rank}
					{/if}
				</td>
				<td nowrap>
					{include file="event_view_pilot_popup.tpl"}
				</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}</td>
			</tr>
			{$rank=$rank+1}
			{$oldscore=$p.event_pilot_round_flight_score}
		{/foreach}
		</table>
	</div>
	{/if}






	</div>
</div>
<br>