{extends file='layout/layout_print.tpl'}

{block name="content"}

{include file='print/print_event_header_info.tpl'}

<div style="-webkit-print-color-adjust:exact;">
		{$perpage=10}
		{if $event->info.event_type_code=='f3b'}
			{$perpage=8}
		{/if}
		{* Lets figure out how many flyoff and zero  rounds there are *}
		{$flyoff_rounds=0}
		{$zero_rounds=0}
		{foreach $event->rounds as $r}
			{if $r.event_round_flyoff!=0}
				{$flyoff_rounds=$flyoff_rounds+1}
			{/if}
			{if $r.event_round_number==0}
				{$zero_rounds=$zero_rounds+1}
			{/if}
		{/foreach}
		{$prelim_rounds=$event->rounds|count - $flyoff_rounds}
		{$pages=ceil($prelim_rounds / $perpage)}
		{if $pages==0}{$pages=1}{/if}
		{if $zero_rounds>0}
			{$start_round=0}
			{$end_round=$perpage - $zero_rounds}
			{if $end_round>=$prelim_rounds}
				{$end_round=$prelim_rounds - $zero_rounds}
			{/if}
			{$numrounds=$end_round-$start_round + $zero_rounds}
		{else}
			{$start_round=1}
			{$end_round=$perpage}
			{if $end_round>=$prelim_rounds}
				{$end_round=$prelim_rounds - $zero_rounds}
			{/if}
			{$numrounds=$end_round-$start_round + 1}
		{/if}
		
		{for $page_num=1 to $pages}
		{if $page_num>1}
			{$numrounds=$end_round-$start_round + 1}
		{/if}
		<h2>Event {if $event->flyoff_totals|count >0}Preliminary {/if}Rounds {if $event->rounds}({$start_round}-{$end_round}) {/if} Overall Classification</h2>
		<table width="100%" cellpadding="2" cellspacing="2" class="table table-condensed table-event table-striped">
		<tr>
			<th align="left" colspan="8"></th>
			<th colspan="{$numrounds+1}" align="center" nowrap>
				Completed Rounds ({if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drop{if $event->totals.round_drops!=1}s{/if} In Effect)
			</th>
			<th style="text-align: center;" nowrap colspan="4"></th>
		</tr>
		<tr>
			<th width="1%" style="text-align:center;" nowrap>#</th>
			<th width="1%" style="text-align:center;" nowrap>Bib</th>
			<th width="20%" style="text-align:center;" nowrap>Pilot Name</th>
			<th width="1%" style="text-align:center;" nowrap>FAI</th>
			<th width="1%" style="text-align:center;" nowrap>FAI License</th>
			<th style="text-align:center;" nowrap>Total</th>
			<th style="text-align:center;" nowrap>Diff</th>
			<th style="text-align:center;width:2px;" width="2" nowrap></th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=0}
					{continue}
				{/if}
				{$round_number=$r.event_round_number}
				{$flight_type_id=$r.flight_type_id}
				{if $round_number >= $start_round && $round_number <= $end_round}
				<th width="5%" align="center" nowrap>
					<div style="position:relative;">
					{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}<del><font color="red"> {/if}
						Round {$r.event_round_number|escape}
					{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}</del></font>{/if}
					</div>
				</th>
				{/if}
			{/foreach}
			<th>&nbsp;</th>
			<th width="5%" style="text-align: center;" nowrap>Sub</th>
			<th width="5%" style="text-align: center;" nowrap>Drop</th>
			<th width="5%" style="text-align: center;" nowrap>Pen</th>
			<th width="5%" style="text-align: center;" nowrap>Percent</th>
		</tr>
		{$previous=0}
		{$diff_to_lead=0}
		{$diff=0}
		{foreach $event->totals.pilots as $e}
		{if $e.total>$previous}
			{$previous=$e.total}
		{else}
			{$diff=$previous-$e.total}
			{$diff_to_lead=$diff_to_lead+$diff}
		{/if}
		{$event_pilot_id=$e.event_pilot_id}
		<tr>
			<td>{$e.overall_rank|escape}</td>
			<td>
				{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
					<div class="pilot_bib_number">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
				{/if}
			</td>
			<td align="right" nowrap>
				{$full_name=$e.pilot_first_name|cat:" "|cat:$e.pilot_last_name}
				{$full_name}
				{if $e.country_code}<img src="/images/flags/countries-iso/shiny/16/{$e.country_code|escape}.png" class="inline_flag" title="{$e.country_name}">{/if}
				{if $e.state_name && $e.country_code=="US"}<img src="/images/flags/states/16/{$e.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$e.state_name}">{/if}
			</td>
			<td width="5%" nowrap align="right">
				<div style="position:relative;">
					<b>{$event->pilots.$event_pilot_id.pilot_fai|escape}</b>
				</div>
			</td>
			<td width="5%" nowrap align="right">
				<div style="position:relative;">
					<b>{$event->pilots.$event_pilot_id.pilot_fai_license|escape}</b>
				</div>
			</td>
			<td width="5%" nowrap align="right">
				<div style="position:relative;">
					<b>{$e.total|string_format:$event->event_calc_accuracy_string}</b>
				</div>
			</td>
			<td width="5%" nowrap align="right">
				{if $diff>0}
				<div style="color:red;">-{$diff|string_format:$event->event_calc_accuracy_string}</div>
				{/if}
			</td>
			<td style="background: white;"></td>
			{foreach $e.rounds as $r}
				{$round_number=$r@key}
				{$flight_type_id=$event->rounds.$round_number.flight_type_id}
				{if $round_number >= $start_round && $round_number <= $end_round}
				<td align="center"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
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
						{if $r.event_pilot_round_total_score==1000}
							1000
						{else}
							{if $r.event_pilot_round_flight_dns==1}
								<font color="red">DNS</font>
							{elseif $r.event_pilot_round_flight_dnf==1}
								<font color="red">DNF</font>
							{else}
								{$r.event_pilot_round_total_score|string_format:$event->event_calc_accuracy_string}
							{/if}
						{/if}
					{if $drop==1}</font></del>{/if}
					{if $event->info.event_type_code=='f3f' || $event->info.event_type_code=='f3f_plus'}<br><font color="black">{$event->rounds.$round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_seconds}</font>{/if}
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td width="5%" nowrap align="right">{$e.subtotal|string_format:$event->event_calc_accuracy_string}</td>
			<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:$event->event_calc_accuracy_string}{/if}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties|escape}{/if}</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:$event->event_calc_accuracy_string}%</td>
		</tr>
		{$previous=$e.total}
		{/foreach}
		{if $event->info.event_type_code=='f3f' || $event->info.event_type_code=='f3f_plus'}
		<tr>
			<th colspan="8" align="right">Round Fast Time</th>
			{foreach $event->rounds as $r}
				{$round_number=$r.event_round_number}
				{if $round_number >= $start_round && $round_number <= $end_round}
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
					<th style="text-align: center;">
						{$fast|escape}s
					</th>
				{/if}
			{/foreach}
			<th colspan="5"></th>
		</tr>
		{/if}
		</table>
		{$start_round=$end_round+1}
		{$end_round=$start_round+$perpage - 1}
		{if $end_round>$prelim_rounds}
			{$end_round=$prelim_rounds - $zero_rounds}
		{/if}
		{if $page_num!=$pages || $flyoff_rounds!=0}
		<br style="page-break-after: always;">
		{/if}
		{/for}




		<!--# Now lets do the flyoff rounds -->
		{foreach $event->flyoff_totals as $t}
			{$flyoff_number=$t@key}
		<h2 class="post-title entry-title">Event Flyoff #{$flyoff_number} Rounds ({$t.total_rounds}) Overall Classification</h2>
		<table width="100%" cellpadding="2" cellspacing="2" class="table table-condensed table-event table-striped">
		<tr>
			<th align="left" colspan="6"></th>
			<th colspan="{$t.total_rounds+1}" align="center" nowrap>
				Completed Rounds ({if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drop{if $event->totals.round_drops!=1}s{/if} In Effect)
			</th>
			<th style="text-align: center;" nowrap colspan="4"></th>
		</tr>
		<tr>
			<th width="1%" style="text-align:center;" nowrap>#</th>
			<th width="1%" style="text-align:center;" nowrap>Bib</th>
			<th width="20%" style="text-align:center;" nowrap>Pilot Name</th>
			<th style="text-align:center;" nowrap>Total</th>
			<th style="text-align:center;" nowrap>Diff</th>
			<th style="text-align:center;width:2px;" width="2" nowrap></th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=$flyoff_number}
					{continue}
				{/if}
				<th width="5%" align="center" nowrap>
					<div style="position:relative;">
					{if $r.event_round_score_status==0}<del><font color="red">{/if}Round {$r.event_round_number|escape}{if $r.event_round_score_status==0}</del></font>{/if}
					</div>
				</th>
			{/foreach}
			<th>&nbsp;</th>
			<th width="5%" style="text-align: center;" nowrap>Sub</th>
			<th width="5%" style="text-align: center;" nowrap>Drop</th>
			<th width="5%" style="text-align: center;" nowrap>Pen</th>
			<th width="5%" style="text-align: center;" nowrap>Percent</th>
		</tr>
		{$previous=0}
		{$diff=0}
		{foreach $t.pilots as $e}
		{if $e.total>$previous}
			{$previous=$e.total}
		{else}
			{$diff=$previous-$e.total}
		{/if}
		{$event_pilot_id=$e.event_pilot_id}
		<tr>
			<td>{$e.overall_rank}</td>
			<td>
				{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
					<div class="pilot_bib_number">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
				{/if}
			</td>
			<td align="right" nowrap>
				{$e.pilot_first_name|escape} {$e.pilot_last_name|escape}
				{if $e.country_code}<img src="/images/flags/countries-iso/shiny/16/{$e.country_code|escape}.png" style="vertical-align: middle;" title="{$e.country_name}">{/if}
				{if $e.state_name && $e.country_code=="US"}<img src="/images/flags/states/16/{$e.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;" title="{$e.state_name}">{/if}
			</td>
			<td width="5%" nowrap align="right">
				<div style="position:relative;">
					<b>{$e.total|string_format:$event->event_calc_accuracy_string}</b>
				</div>
			</td>
			<td width="5%" nowrap align="right">
				{if $diff>0}
				<div style="color:red;">-{$diff|string_format:$event->event_calc_accuracy_string}</div>
				{/if}
			</td>
			<td style="background: white;"></td>
			{foreach $e.rounds as $r}
				{if $r@iteration <=9}
				<td align="center"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
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
						{if $r.event_pilot_round_total_score==1000}
							1000
						{else}
							{$r.event_pilot_round_total_score|string_format:$event->event_calc_accuracy_string}
						{/if}
					{if $drop==1}</font></del>{/if}
					{if $event->info.event_type_code=='f3f' || $event->info.event_type_code=='f3f_plus'}<br><font color="black">{$event->rounds.$round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_seconds}</font>{/if}
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td width="5%" nowrap align="right">{$e.subtotal|string_format:$event->event_calc_accuracy_string}</td>
			<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:$event->event_calc_accuracy_string}{/if}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:$event->event_calc_accuracy_string}%</td>
		</tr>
		{$previous=$e.total}
		{/foreach}
		{if $event->info.event_type_code=='f3f' || $event->info.event_type_code=='f3f_plus'}
		<tr>
			<th colspan="6" align="right">Round Fast Time</th>
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
				<th style="text-align: center;">
					{$fast}s
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

		<!-- Lets make a signture line -->
		<br><br><br>
		<table width="100%">
			<tr>
				<td height="20" width="5%" nowrap><b>Signature :</b></td>
				<td height="20" width="60%" style="border-bottom: 2px solid black;"> &nbsp;</td>
				<td height="20" width="5%" nowrap><b>Date :</b></td>
				<td height="20" style="border-bottom: 2px solid black;"> &nbsp;</td>
			</tr>
		</table>

	</div>
</div>
{/block}