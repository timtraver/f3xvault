		<!--# Now lets do the flyoff rounds -->
		{foreach $event->flyoff_totals as $t}
			{$flyoff_number=$t@key}
		<h1 class="post-title entry-title">Event Flyoff #{$flyoff_number} Rounds ({$t.total_rounds}) Overall Classification
		</h1>
		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<th width="10%" align="right" nowrap colspan="3"></th>
			<th colspan="{$t.total_rounds + 1}" align="center" nowrap>
				Completed Rounds ({if $t.round_drops==0}No{else}{$t.round_drops}{/if} Drop{if $t.round_drops!=1}s{/if} In Effect)
			</th>
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Drop</th>
			<th width="5%" nowrap>Pen</th>
			<th width="5%" nowrap>Total Score</th>
			<th width="5%" nowrap>Percent</th>
		</tr>
		<tr>
			<th width="10%" align="right" nowrap colspan="3">Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=$flyoff_number}
					{continue}
				{/if}
				<th class="info" width="5%" align="center" nowrap>
					<div style="position:relative;">
					<span>
						{$flight_type_id=$r.flight_type_id}
						{if $event->flight_types.$flight_type_id.flight_type_code|strstr:"f3k"}
							View Details of Round<br>{$event->flight_types.$flight_type_id.flight_type_name|escape}
						{else}
							View Details of Round {$r.event_round_number|escape}
						{/if}
					</span>
					<a href="/?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$r.event_round_id}" title="Edit Round">{if $r.event_round_score_status==0}<del><font color="red">{/if}Round {$r.event_round_number|escape}{if $r.event_round_score_status==0}</del></font>{/if}</a>
					</div>
				</th>
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{$previous=0}
		{$diff_to_lead=0}
		{$diff=0}
		{foreach $t.pilots as $e}
		{if $e.total>$previous}
			{$previous=$e.total}
		{else}
			{$diff=$previous-$e.total}
			{$diff_to_lead=$diff_to_lead+$diff}
		{/if}
		{$event_pilot_id=$e.event_pilot_id}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank}</td>
			<td>
				{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
					<div class="pilot_bib_number">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
				{/if}
			</td>
			<td align="right" nowrap>
				<a href="?action=event&function=event_pilot_rounds&event_pilot_id={$e.event_pilot_id}&event_id={$event->info.event_id}">{$e.pilot_first_name|escape} {$e.pilot_last_name|escape}</a>
				{if $e.country_code}<img src="/images/flags/countries-iso/shiny/16/{$e.country_code|escape}.png" style="vertical-align: middle;" title="{$e.country_name}">{/if}
				{if $e.state_name && $e.country_code=="US"}<img src="/images/flags/states/16/{$e.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;" title="{$e.state_name}">{/if}
			</td>
			{foreach $e.rounds as $r}
				{if $r@iteration <=9}
				<td align="center"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
					<div style="position:relative;">
					<a href="" class="tooltip_score" onClick="return false;">
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
						{if $r.event_pilot_round_total_score==1000}
							1000
						{else}
							{$r.event_pilot_round_total_score|string_format:$event->event_calc_accuracy_string}
						{/if}
					{if $drop==1}</font></del>{/if}
					{* lets determine the content to show on popup *}
						{include file="event/event_view_score_popup.tpl"}
					</a>
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td width="5%" nowrap align="right">{$e.subtotal|string_format:$event->event_calc_accuracy_string}</td>
			<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:$event->event_calc_accuracy_string}{/if}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap align="right">
				<a href="" class="tooltip_score_left" onClick="return false;">
					{$e.total|string_format:$event->event_calc_accuracy_string}
					<span>
					<b>Behind Prev</b> : {$diff|string_format:$event->event_calc_accuracy_string}<br>
					<b>Behind Lead</b> : {$diff_to_lead|string_format:$event->event_calc_accuracy_string}<br>
					</span>
				</a>
			</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:$event->event_calc_accuracy_string}%</td>
		</tr>
		{/foreach}
		{if $event->info.event_type_code=='f3f'}
		<tr>
			<th colspan="3" align="right">Round Fast Time</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=$flyoff_number}
					{continue}
				{/if}
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
					<th align="center">
						<a href="" class="tooltip_score" onClick="return false;">
						<img class="callout" src="/images/callout.gif">
						{$fast|escape}s
						<span>
							Fast Time : {$fast}s<br>
							{$event->pilots.$fast_id.pilot_first_name|escape} {$event->pilots.$fast_id.pilot_last_name|escape}
						</span>
						</a>
					</th>
			{/foreach}
		</tr>
		{/if}
		</table>
		{if !$t@last}
		<br style="page-break-after: always;">
		{/if}
		{/foreach}
		<!--# End of flyoff rounds -->
