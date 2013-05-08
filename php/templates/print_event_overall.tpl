<div class="page type-page status-publish hentry clearfix post nodate" style="-webkit-print-color-adjust:exact;">
	<div class="entry clearfix">                
		<h2 class="post-title entry-title">Event - {$event->info.event_name}</h2>
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
		<h1 class="post-title entry-title">Event {if $event->flyoff_totals|count >0}Preliminary {/if}Rounds {if $event->rounds}({$event->totals.total_rounds}) {/if} Overall Classification
		</h1>
		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<td width="2%" align="left"></td>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{if $event->totals.total_rounds > 9}10{else}{$event->totals.total_rounds + 1}{/if}" align="center" nowrap>
				Completed Rounds ({if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drop{if $event->totals.round_drops!=1}s{/if} In Effect)
			</th>
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Pen</th>
			<th width="5%" nowrap>Total Score</th>
			<th width="5%" nowrap>Percent</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=0}
					{continue}
				{/if}
				{if $r@iteration <=9}
				<th class="info" width="5%" align="center" nowrap>
					<div style="position:relative;">
					<span>
						{$flight_type_id=$r.flight_type_id}
						{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}
							<font color="red"><b>Round Not Currently Scored</b></font><br>
						{/if}
						{if $event->flight_types.$flight_type_id.flight_type_code|strstr:"f3k"}
							View Details of Round<br>{$event->flight_types.$flight_type_id.flight_type_name}
						{else}
							View Details of Round {$r.event_round_number}
						{/if}
					</span>
					{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}<del><font color="red">{/if}Round {$r.event_round_number}{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}</del></font>{/if}
					</div>
				</th>
				{/if}
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{foreach $event->totals.pilots as $e}
		{$event_pilot_id=$e.event_pilot_id}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank}</td>
			<td align="right" nowrap>{$e.pilot_first_name} {$e.pilot_last_name}</td>
			{foreach $e.rounds as $r}
				{if $r@iteration <=9}
				<td class="info" align="right"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
					<div style="position:relative;">
					{$dropval=0}
					{$dropped=0}
					{foreach $r.flights as $f}
						{if $f.event_pilot_round_flight_dropped}
							{$dropval=$dropval+$f.event_pilot_round_total_score}
							{$dropped=1}
						{/if}
					{/foreach}
					{$drop=0}
					{if $dropped==1 && $dropval==$r.event_pilot_round_total_score}{$drop=1}{/if}
					{if $drop==1}<del><font color="red">{/if}
						{$r.event_pilot_round_total_score|string_format:"%06.3f"}
					{if $drop==1}</font></del>{/if}
					{* lets determine the content to show on popup *}
						<span>
							{$event_round_number=$r@key}
							{foreach $event->rounds.$event_round_number.flights as $f}
								{if $f.flight_type_code|strstr:'duration' || $f.flight_type_code|strstr:'f3k'}
									{if $f.flight_type_code=='f3b_duration'}A - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_minutes}:{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds}{if $f.flight_type_landing} - {$f.pilots.$event_pilot_id.event_pilot_round_flight_landing}{/if}<br>
								{/if}
								{if $f.flight_type_code|strstr:'distance'}
									{if $f.flight_type_code=='f3b_distance'}B - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_laps} Laps<br>
								{/if}
								{if $f.flight_type_code|strstr:'speed'}
									{if $f.flight_type_code=='f3b_speed'}C - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds}s
								{/if}
							{/foreach}
						</span>
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td width="5%" nowrap align="right">{$e.subtotal|string_format:"%06.3f"}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap align="right">{$e.total|string_format:"%06.3f"}</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:"%03.2f"}%</td>
		</tr>
		{/foreach}
		{if $event->info.event_type_code=='f3f'}
		<tr>
			<th colspan="2" align="right">Round Fast Time</th>
			{foreach $event->rounds as $r}
				{if $r@iteration <=9}
					{$fast=1000}
					{$fast_id=0}
					{foreach $r.flights as $f}
						{foreach $f.pilots as $p}
						{if $p.event_pilot_round_flight_seconds<$fast && $p.event_pilot_round_flight_seconds!=0}
							{$fast=$p.event_pilot_round_flight_seconds}
							{$fast_id=$p.event_pilot_id}
						{/if}
						{/foreach}
					{/foreach}
					{if $fast==1000}{$fast=0}{/if}
					<th class="info" align="center">
						<div style="position:relative;">
						{$fast}s
						<span>
							Fast Time : {$fast}s<br>
							{$event->pilots.$fast_id.pilot_first_name} {$event->pilots.$fast_id.pilot_last_name}
						</span>
						</div>
					</th>
				{/if}
			{/foreach}
		</tr>
		{/if}
		</table>

		{if $event->totals.total_rounds >9}
		<br>
		<h1 class="post-title entry-title">Event {if $event->flyoff_totals|count >0}Preliminary {/if}Rounds {if $event->rounds}({$event->totals.total_rounds}) {/if} Overall Classification
		</h1>
		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<td width="2%" align="left"></td>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{$event->totals.total_rounds - 8}" align="center" nowrap>
				Completed Rounds ({if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drop{if $event->totals.round_drops!=1}s{/if} In Effect)
			</th>
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Pen</th>
			<th width="5%" nowrap>Total Score</th>
			<th width="5%" nowrap>Percent</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=0}
					{continue}
				{/if}
				{if $r@iteration >9}
				<th class="info" width="5%" align="center" nowrap>
					<div style="position:relative;">
					<span>
						{$flight_type_id=$r.flight_type_id}
						{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}
							<font color="red"><b>Round Not Currently Scored</b></font><br>
						{/if}
						{if $event->flight_types.$flight_type_id.flight_type_code|strstr:"f3k"}
							View Details of Round<br>{$event->flight_types.$flight_type_id.flight_type_name}
						{else}
							View Details of Round {$r.event_round_number}
						{/if}
					</span>
					{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}<del><font color="red">{/if}Round {$r.event_round_number}{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}</del></font>{/if}
					</div>
				</th>
				{/if}
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{foreach $event->totals.pilots as $e}
		{$event_pilot_id=$e.event_pilot_id}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank}</td>
			<td align="right" nowrap>{$e.pilot_first_name} {$e.pilot_last_name}</td>
			{foreach $e.rounds as $r}
				{if $r@iteration>9}
				<td class="info" align="right"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
					<div style="position:relative;">
					{$dropval=0}
					{$dropped=0}
					{foreach $r.flights as $f}
						{if $f.event_pilot_round_flight_dropped}
							{$dropval=$dropval+$f.event_pilot_round_total_score}
							{$dropped=1}
						{/if}
					{/foreach}
					{$drop=0}
					{if $dropped==1 && $dropval==$r.event_pilot_round_total_score}{$drop=1}{/if}
					{if $drop==1}<del><font color="red">{/if}
						{$r.event_pilot_round_total_score|string_format:"%06.3f"}
					{if $drop==1}</font></del>{/if}
					{* lets determine the content to show on popup *}
						<span>
							{$event_round_number=$r@key}
							{foreach $event->rounds.$event_round_number.flights as $f}
								{if $f.flight_type_code|strstr:'duration' || $f.flight_type_code|strstr:'f3k'}
									{if $f.flight_type_code=='f3b_duration'}A - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_minutes}:{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds}{if $f.flight_type_landing} - {$f.pilots.$event_pilot_id.event_pilot_round_flight_landing}{/if}<br>
								{/if}
								{if $f.flight_type_code|strstr:'distance'}
									{if $f.flight_type_code=='f3b_distance'}B - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_laps} Laps<br>
								{/if}
								{if $f.flight_type_code|strstr:'speed'}
									{if $f.flight_type_code=='f3b_speed'}C - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds}s
								{/if}
							{/foreach}
						</span>
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td width="5%" nowrap align="right">{$e.subtotal|string_format:"%06.3f"}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap align="right">{$e.total|string_format:"%06.3f"}</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:"%03.2f"}%</td>
		</tr>
		{/foreach}
		{if $event->info.event_type_code=='f3f'}
		<tr>
			<th colspan="2" align="right">Round Fast Time</th>
			{foreach $event->rounds as $r}
				{if $r@iteration>9}
					{$fast=1000}
					{$fast_id=0}
					{foreach $r.flights as $f}
						{foreach $f.pilots as $p}
						{if $p.event_pilot_round_flight_seconds<$fast && $p.event_pilot_round_flight_seconds!=0}
							{$fast=$p.event_pilot_round_flight_seconds}
							{$fast_id=$p.event_pilot_id}
						{/if}
						{/foreach}
					{/foreach}
					{if $fast==1000}{$fast=0}{/if}
					<th class="info" align="center">
						<div style="position:relative;">
						<a href="" onClick="return false;">{$fast}s</a>
						<span>
							Fast Time : {$fast}s<br>
							{$event->pilots.$fast_id.pilot_first_name} {$event->pilots.$fast_id.pilot_last_name}
						</span>
						</div>
					</th>
				{/if}
			{/foreach}
		</tr>
		{/if}
		</table>
		{/if}




		<!--# Now lets do the flyoff rounds -->
		{foreach $event->flyoff_totals as $t}
			<br>
			{$flyoff_number=$t@key}
		<h1 class="post-title entry-title">Event Flyoff #{$flyoff_number} Rounds ({$t.total_rounds}) Overall Classification
		</h1>
		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<td width="2%" align="left"></td>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{$t.total_rounds + 1}" align="center" nowrap>
				Completed Rounds ({if $t.round_drops==0}No{else}{$t.round_drops}{/if} Drop{if $t.round_drops!=1}s{/if} In Effect)
			</th>
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Pen</th>
			<th width="5%" nowrap>Total Score</th>
			<th width="5%" nowrap>Percent</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=$flyoff_number}
					{continue}
				{/if}
				<th class="info" width="5%" align="center" nowrap>
					<div style="position:relative;">
					<span>
						{$flight_type_id=$r.flight_type_id}
						{if $event->flight_types.$flight_type_id.flight_type_code|strstr:"f3k"}
							View Details of Round<br>{$event->flight_types.$flight_type_id.flight_type_name}
						{else}
							View Details of Round {$r.event_round_number}
						{/if}
					</span>
					{if $r.event_round_score_status==0}<del><font color="red">{/if}Round {$r.event_round_number}{if $r.event_round_score_status==0}</del></font>{/if}
					</div>
				</th>
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{foreach $t.pilots as $e}
		{$event_pilot_id=$e.event_pilot_id}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank}</td>
			<td align="right" nowrap>{$e.pilot_first_name} {$e.pilot_last_name}</td>
			{foreach $e.rounds as $r}
				{if $r@iteration <=9}
				<td class="info" align="right"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
					<div style="position:relative;">
					{$dropval=0}
					{$dropped=0}
					{foreach $r.flights as $f}
						{if $f.event_pilot_round_flight_dropped}
							{$dropval=$dropval+$f.event_pilot_round_total_score}
							{$dropped=1}
						{/if}
					{/foreach}
					{$drop=0}
					{if $dropped==1 && $dropval==$r.event_pilot_round_total_score}{$drop=1}{/if}
					{if $drop==1}<del><font color="red">{/if}
						{$r.event_pilot_round_total_score|string_format:"%06.3f"}
					{if $drop==1}</font></del>{/if}
					{* lets determine the content to show on popup *}
						<span>
							{$event_round_number=$r@key}
							{foreach $event->rounds.$event_round_number.flights as $f}
								{if $f.flight_type_code|strstr:'duration' || $f.flight_type_code|strstr:'f3k'}
									{if $f.flight_type_code=='f3b_duration'}A - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_minutes}:{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds}{if $f.flight_type_landing} - {$f.pilots.$event_pilot_id.event_pilot_round_flight_landing}{/if}<br>
								{/if}
								{if $f.flight_type_code|strstr:'distance'}
									{if $f.flight_type_code=='f3b_distance'}B - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_laps} Laps<br>
								{/if}
								{if $f.flight_type_code|strstr:'speed'}
									{if $f.flight_type_code=='f3b_speed'}C - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds}s
								{/if}
							{/foreach}
						</span>
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td width="5%" nowrap align="right">{$e.subtotal|string_format:"%06.3f"}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap align="right">{$e.total|string_format:"%06.3f"}</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:"%03.2f"}%</td>
		</tr>
		{/foreach}
		{if $event->info.event_type_code=='f3f'}
		<tr>
			<th colspan="2" align="right">Round Fast Time</th>
			{foreach $event->rounds as $r}
				{if $r@iteration <=9}
					{$fast=1000}
					{$fast_id=0}
					{foreach $r.flights as $f}
						{foreach $f.pilots as $p}
						{if $p.event_pilot_round_flight_seconds<$fast && $p.event_pilot_round_flight_seconds!=0}
							{$fast=$p.event_pilot_round_flight_seconds}
							{$fast_id=$p.event_pilot_id}
						{/if}
						{/foreach}
					{/foreach}
					{if $fast==1000}{$fast=0}{/if}
					<th class="info" align="center">
						<div style="position:relative;">
						<a href="" onClick="return false;">{$fast}s</a>
						<span>
							Fast Time : {$fast}s<br>
							{$event->pilots.$fast_id.pilot_first_name} {$event->pilots.$fast_id.pilot_last_name}
						</span>
						</div>
					</th>
				{/if}
			{/foreach}
		</tr>
		{/if}
		</table>
		
		
		{/foreach}
		<!--# End of flyoff rounds -->


	</div>
</div>
<br>