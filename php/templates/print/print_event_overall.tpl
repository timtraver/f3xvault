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
		
		<h2>Event Preliminary Overall Classification ({$prelim_rounds|escape} Rounds - {if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drop{if $event->totals.round_drops!=1}s{/if} In Effect)</h2>
		<table width="100%" cellpadding="2" cellspacing="2" class="table table-condensed table-event table-striped">
		<tr>
			<th width="1%" style="text-align:center;" nowrap>#</th>
			<th width="1%" style="text-align:center;" nowrap>Bib</th>
			<th width="20%" style="text-align:left;" nowrap>Pilot Name</th>
			<th width="1%" style="text-align:left;" nowrap>FAI ID</th>
			<th width="1%" style="text-align:left;" nowrap>FAI License</th>
			<th width="1%" style="text-align:left;" nowrap>Country</th>
			<th style="text-align:center;" nowrap>Total Points</th>
			<th style="text-align:center;" nowrap>Difference</th>
			<th style="text-align:center;width:2px;" width="2" nowrap></th>
			<th width="5%" style="text-align: center;" nowrap>Sub Total</th>
			<th width="5%" style="text-align: center;" nowrap>Drop</th>
			<th width="5%" style="text-align: center;" nowrap>Penalties</th>
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
			<td align="left" nowrap>
				{$full_name=$e.pilot_first_name|cat:" "|cat:$e.pilot_last_name}
				{if $e.country_code}<img src="/images/flags/countries-iso/shiny/16/{$e.country_code|escape}.png" class="inline_flag" title="{$e.country_name}">{/if}
				{if $e.state_name && $e.country_code=="US"}<img src="/images/flags/states/16/{$e.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$e.state_name}">{/if}
				{$full_name}
			</td>
			<td width="5%" nowrap align="left">
				<div style="position:relative;">
					<b>{$event->pilots.$event_pilot_id.pilot_fai|escape}</b>
				</div>
			</td>
			<td width="5%" nowrap align="left">
				<div style="position:relative;">
					<b>{$event->pilots.$event_pilot_id.pilot_fai_license|escape}</b>
				</div>
			</td>
			<td width="5%" nowrap align="left">
				<div style="position:relative;">
					<b>{$event->pilots.$event_pilot_id.country_name|escape}</b>
				</div>
			</td>
			<td width="5%" nowrap align="right" style="border: 2px solid">
				<div style="position:relative;">
					<b>{$e.total|string_format:$event->event_calc_accuracy_string}</b>
				</div>
			</td>
			<td width="5%" nowrap align="right">
				{if $diff>0}
				<div style="color:red;">-{$diff|string_format:$event->event_calc_accuracy_string}</div>
				{/if}
			</td>
			<td></td>
			<td width="5%" nowrap align="right">{$e.subtotal|string_format:$event->event_calc_accuracy_string}</td>
			<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:$event->event_calc_accuracy_string}{/if}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties|escape}{/if}</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:$event->event_calc_accuracy_string}%</td>
		</tr>
		{$previous=$e.total}
		{/foreach}
		</table>
		{$start_round=$end_round+1}
		{$end_round=$start_round+$perpage - 1}
		{if $end_round>$prelim_rounds}
			{$end_round=$prelim_rounds - $zero_rounds}
		{/if}
		{if $page_num!=$pages || $flyoff_rounds!=0}
		<br style="page-break-after: always;">
		{/if}




		<!--# Now lets do the flyoff rounds -->
		{foreach $event->flyoff_totals as $t}
			{$flyoff_number=$t@key}
		<h2 class="post-title entry-title">Event Flyoff #{$flyoff_number} Overall Classification ({$t.total_rounds|escape} Rounds  - {if $t.round_drops==0}No{else}{$t.round_drops}{/if} Drop{if $t.round_drops!=1}s{/if} In Effect)</h2>
		<table width="100%" cellpadding="2" cellspacing="2" class="table table-condensed table-event table-striped">
		<tr>
			<th width="1%" style="text-align:center;" nowrap>#</th>
			<th width="1%" style="text-align:center;" nowrap>Bib</th>
			<th width="20%" style="text-align:center;" nowrap>Pilot Name</th>
			<th width="1%" style="text-align:left;" nowrap>FAI ID</th>
			<th width="1%" style="text-align:left;" nowrap>FAI License</th>
			<th width="1%" style="text-align:left;" nowrap>Country</th>
			<th style="text-align:center;" nowrap>Total Points</th>
			<th style="text-align:center;" nowrap>Difference</th>
			<th>&nbsp;</th>
			<th width="5%" style="text-align: center;" nowrap>SubTotal</th>
			<th width="5%" style="text-align: center;" nowrap>Drop</th>
			<th width="5%" style="text-align: center;" nowrap>Penalties</th>
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
			<td width="5%" nowrap align="left">
				<div style="position:relative;">
					<b>{$event->pilots.$event_pilot_id.pilot_fai|escape}</b>
				</div>
			</td>
			<td width="5%" nowrap align="left">
				<div style="position:relative;">
					<b>{$event->pilots.$event_pilot_id.pilot_fai_license|escape}</b>
				</div>
			</td>
			<td width="5%" nowrap align="left">
				<div style="position:relative;">
					<b>{$event->pilots.$event_pilot_id.country_name|escape}</b>
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
			<td></td>
			<td width="5%" nowrap align="right">{$e.subtotal|string_format:$event->event_calc_accuracy_string}</td>
			<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:$event->event_calc_accuracy_string}{/if}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:$event->event_calc_accuracy_string}%</td>
		</tr>
		{$previous=$e.total}
		{/foreach}
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