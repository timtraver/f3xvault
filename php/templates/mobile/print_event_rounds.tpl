<div class="page type-page status-publish hentry clearfix post nodate" style="-webkit-print-color-adjust:exact;">
	<div class="entry clearfix">                
	{foreach $event->rounds as $r}
		{$round_number=$r.event_round_number}
		{if $round_number >= $round_from && $round_number <= $round_to}

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
		</table>
	</div>
		
		<h1 class="post-title entry-title">Round {$round_number} Detail Results</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		{foreach $event->flight_types as $ft}
			{$flight_type_id=$ft.flight_type_id}
			{if $event->info.event_type_flight_choice==1 AND $ft.flight_type_id!=$event->rounds.$round_number.flight_type_id}
				{continue}
			{/if}
			{$cols=7}
			{if $ft.flight_type_seconds}{$cols=$cols+1}{/if}
			{if $ft.flight_type_landing}{$cols=$cols+1}{/if}
			{if $ft.flight_type_laps}{$cols=$cols+1}{/if}
			<tr>
				<th align="left" colspan="{$cols}">
					{$ft.flight_type_name|escape}
				</th>
			</tr>
			<tr>
				<th width="2%" align="left"></th>
				<th align="left">Pilot Name</th>
				{if $ft.flight_type_group}
					<th align="center">Group</th>
				{else}
					<th align="center">Order</th>
				{/if}
				{if $ft.flight_type_minutes || $ft.flight_type_seconds}
					<th align="center">Time{if $ft.flight_type_sub_flights!=0}s{/if}{if $ft.flight_type_over_penalty}/Over{/if}</th>
				{/if}
				{if $ft.flight_type_landing}
					<th align="center">Landing</th>
				{/if}
				{if $ft.flight_type_laps}
					<th align="center">Laps</th>
				{/if}
				<th align="center">Raw Score</th>
				<th align="center">Normalized Score</th>
				<th align="center">Penalty</th>
				<th align="center">Flight Rank</th>
			</tr>
			{$num=1}
			{foreach $event->rounds.$round_number.flights as $f}
			{if $f@key!=$ft.flight_type_id}
				{continue}
			{/if}
			{$groupcolor='#9DCFF0'}
			{$oldgroup=''}
			{foreach $f.pilots as $p}
			{$event_pilot_id=$p@key}
			{if $oldgroup!=$p.event_pilot_round_flight_group}
				{if $groupcolor=='lightgrey'}{$groupcolor='#9DCFF0'}{else}{$groupcolor='lightgrey'}{/if}
				{$oldgroup=$p.event_pilot_round_flight_group|escape}
			{/if}
			{$time_disabled=0}
			<tr style="background-color: {$groupcolor};">
				<td style="background-color: lightgrey;">{$num}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
					{if $f.flight_type_group}
						<td align="center" nowrap>{$p.event_pilot_round_flight_group|escape}</td>					
					{else}
						<td align="center" nowrap>{$p.event_pilot_round_flight_order|escape}</td>					
					{/if}
					{if $f.flight_type_minutes || $f.flight_type_seconds}
						<td align="right" nowrap>
							{if $ft.flight_type_sub_flights!=0}
								{$time_disabled=1}
								{for $sub=1 to $ft.flight_type_sub_flights}
									{if $p.sub.$sub.event_pilot_round_flight_sub_val!='0:00'}
										<span style="background-color: #9DCFF0;padding: 1px;">{$p.sub.$sub.event_pilot_round_flight_sub_val|escape}</span>
									{else}
										<span style="background-color: #9DCFF0;padding: 1px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
									{/if} 
								{/for}
								= 
							{/if}
							{if $f.flight_type_minutes}
								{$p.event_pilot_round_flight_minutes|escape}m
							{/if}
							{if $f.flight_type_seconds}
								{$p.event_pilot_round_flight_seconds|escape}s
							{/if}
							{if $f.flight_type_over_penalty}
								<input type="checkbox" tabindex="{$tabindex}" name="pilot_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if} onChange="save_data(this);">
							{/if}
						</td>
					{/if}
					{if $f.flight_type_landing}
						<td align="center" nowrap>{$p.event_pilot_round_flight_landing|escape}</td>
					{/if}
					{if $f.flight_type_laps}
						<td align="center" nowrap>{$p.event_pilot_round_flight_laps|escape}</td>
					{/if}
					<td align="right" nowrap>
						{if $f.flight_type_code=='f3f_speed' OR $f.flight_type_code=='f3b_speed'}
						{$p.event_pilot_round_flight_raw_score|escape}
						{else}
						{$p.event_pilot_round_flight_raw_score|string_format:"%02.3f"}
						{/if}
					</td>
					<td align="right" nowrap>
					{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}<del><font color="red">{/if}
					{$p.event_pilot_round_flight_score}{if $p.event_pilot_round_flight_reflight_dropped}(R){/if}
					{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}</font></del>{/if}
					</td>
					<td align="center" nowrap>
						{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty|escape}{/if}
					</td>
					<td align="right" nowrap>
					{$p.event_pilot_round_flight_rank|escape}
					</td>
			</tr>
			{$num=$num+1}
			{/foreach}
			{/foreach}
			{if $ft.flight_type_reflight==1}
			{if $event->rounds.$round_number.reflights|count > 0}
			<tr>
				<th align="left" colspan="11">Reflights</th>
			</tr>
			{/if}
			{foreach $event->rounds.$round_number.reflights as $f}
				{if $f@key!=$ft.flight_type_id}
					{continue}
				{/if}
				{$groupcolor='#9DCFF0'}
				{$oldgroup=''}
				{foreach $f.pilots as $p}
				{$event_pilot_id=$p@key}
				{if $oldgroup!=$p.event_pilot_round_flight_group}
					{if $groupcolor=='lightgrey'}{$groupcolor='#9DCFF0'}{else}{$groupcolor='lightgrey'}{/if}
					{$oldgroup=$p.event_pilot_round_flight_group}
				{/if}
				<tr style="background-color: {$groupcolor};">
					<td style="background-color: lightgrey;">{$num}</td>
					<td style="background-color: #9DCFF0;" nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
						{if $f.flight_type_group}
							<td align="center" nowrap>{$p.event_pilot_round_flight_group|escape}</td>					
						{else}
							<td align="center" nowrap>{$p.event_pilot_round_flight_order|escape}</td>					
						{/if}
						{if $f.flight_type_minutes || $f.flight_type_seconds}
							<td align="right" nowrap>
								{if $f.flight_type_minutes}
									{$p.event_pilot_round_flight_minutes|escape}m
								{/if}
								{if $f.flight_type_seconds}
									{$p.event_pilot_round_flight_seconds|escape}s
								{/if}
								{if $f.flight_type_over_penalty}
									<input type="checkbox" tabindex="{$tabindex}" name="pilot_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if}>
								{/if}
							</td>
						{/if}
						{if $f.flight_type_landing}
							<td align="center" nowrap>{$p.event_pilot_round_flight_landing|escape}</td>
						{/if}
						{if $f.flight_type_laps}
							<td align="center" nowrap>{$p.event_pilot_round_flight_laps|escape}</td>
						{/if}
						<td align="right" nowrap>
							{if $f.flight_type_code=='f3f_speed' OR $f.flight_type_code=='f3b_speed'}
							{$p.event_pilot_round_flight_raw_score}
							{else}
							{$p.event_pilot_round_flight_raw_score|string_format:"%02.3f"}
							{/if}
						</td>
						<td align="right" nowrap>
						{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}<del><font color="red">{/if}
						{$p.event_pilot_round_flight_score}{if $p.event_pilot_round_flight_reflight_dropped}(R){/if}
						{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}</font></del>{/if}
						</td>
						<td align="center" nowrap>
							{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty|escape}{/if}
						</td>
						<td align="right" nowrap>
						{$p.event_pilot_round_flight_rank|escape}
						</td>
				</tr>
				{$num=$num+1}
				{/foreach}
			{/foreach}
			{/if}
		{/foreach}
		</table>

		{if !$r@last && $one_per_page==1}
			<br style="page-break-after: always;">
		{/if}


		{/if}
	{/foreach}
	</div>
</div>
<br>