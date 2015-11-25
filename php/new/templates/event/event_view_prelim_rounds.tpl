{$perpage=8}
{* Lets figure out how many flyoff and zero rounds there are *}
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
<h2 class="post-title entry-title">Rounds {if $event->rounds}({$start_round}-{$end_round}) {/if}
	{if $page_num==1}
		{if $user.user_id!=0 && ($permission==1 || $user.user_admin==1)}		
			{if $event->info.event_type_flyoff==1}<input type="button" value=" Add Flyoff Round " onClick="{if $event->pilots|count==0}alert('You must enter pilots before you add a round.');{else}if(check_permission()){ldelim}document.event_add_round.flyoff_round.value=1; document.event_add_round.submit();{rdelim}{/if}" class="btn btn-primary btn-rounded">{/if}
			{if $event->info.event_type_zero_round==1}<input type="button" value=" Add Zero Round " onClick="{if $event->pilots|count==0}alert('You must enter pilots before you add a round.');{else}if(check_permission()){ldelim}document.event_add_round.zero_round.value=1; document.event_add_round.submit();{rdelim}{/if}" class="btn btn-primary btn-rounded">{/if}
			<input type="button" value=" Add Round " onClick="{if $event->pilots|count==0}alert('You must enter pilots before you add a round.');{else}if(check_permission()){ldelim}document.event_add_round.submit();{rdelim}{/if}" class="btn btn-primary btn-rounded">
		{/if}
	{/if}
</h2>
<table width="100%" cellpadding="2" cellspacing="1" class="table">
<tr>
	<th width="2%" align="left" colspan="2"></th>
	<th width="10%" align="right" nowrap></th>
	<th colspan="{$numrounds+1}" align="center" nowrap style="text-align: center;">
		Completed Rounds ({if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drop{if $event->totals.round_drops!=1}s{/if} In Effect)
	</th>
	<th width="5%" nowrap>SubTotal</th>
	<th width="5%" nowrap>Drop</th>
	<th width="5%" nowrap>Pen</th>
	<th width="5%" nowrap>Total Score</th>
	<th width="5%" nowrap>Percent</th>
</tr>
<tr>
	<th width="10%" style="text-align:right;" nowrap colspan="3">Pilot Name</th>
	{foreach $event->rounds as $r}
		{if $r.event_round_flyoff!=0}
			{continue}
		{/if}
		{$round_number=$r.event_round_number}
		{if $round_number >= $start_round && $round_number <= $end_round}
		<th class="info" width="5%" align="center" nowrap>
			<div style="position:relative;">
			<span>
				{$flight_type_id=$r.flight_type_id}
				{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}
					<font color="red"><b>Round Not Currently Scored</b></font><br>
				{/if}
				{if $event->flight_types.$flight_type_id.flight_type_code|strstr:"f3k"}
					View Details of Round<br>{$event->flight_types.$flight_type_id.flight_type_name|escape}
				{else}
					View Details of Round {$r.event_round_number|escape}
				{/if}
			</span>
			<a href="/?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$r.event_round_id}" title="Edit Round">{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}<del><font color="red">{/if}Round {$r.event_round_number|escape}{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}</del></font>{/if}</a>
			</div>
		</th>
		{/if}
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
{foreach $event->totals.pilots as $e}
{if $e.total>$previous}
	{$previous=$e.total}
{else}
	{$diff=$previous-$e.total}
	{$diff_to_lead=$diff_to_lead+$diff}
{/if}
{$event_pilot_id=$e.event_pilot_id}
<tr style="background-color: {cycle values="#9DCFF0,white"};">
	<td>{$e.overall_rank|escape}</td>
	<td>
		{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
			<div class="pilot_bib_number">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
		{/if}
	</td>
	<td style="text-align:right;" nowrap>
		{$full_name=$e.pilot_first_name|cat:" "|cat:$e.pilot_last_name}
		<a href="?action=event&function=event_pilot_rounds&event_pilot_id={$e.event_pilot_id}&event_id={$event->info.event_id}" title="{$full_name}" class="tooltip">{$full_name|truncate:20:"...":true:true}
			{include file="event/event_view_pilot_main_popup.tpl"}
		</a>
		{if $e.country_code}<img src="/images/flags/countries-iso/shiny/16/{$e.country_code|escape}.png" class="inline_flag" title="{$e.country_name}">{/if}
		{if $e.state_name && $e.country_code=="US"}<img src="/images/flags/states/16/{$e.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$e.state_name}">{/if}
	</td>
	{foreach $e.rounds as $r}
		{$round_number=$r@key}
		{if $round_number >= $start_round && $round_number <= $end_round}
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
					{if $r.event_pilot_round_flight_dns==1}
						<font color="red">DNS</font>
					{elseif $r.event_pilot_round_flight_dnf==1}
						<font color="red">DNF</font>
					{else}
						{$r.event_pilot_round_total_score|string_format:$event->event_calc_accuracy_string}
					{/if}
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
	<td class="info" width="5%" nowrap align="right">{$e.subtotal|string_format:$event->event_calc_accuracy_string}</td>
	<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:$event->event_calc_accuracy_string}{/if}</td>
	<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties|escape}{/if}</td>
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
{$previous=$e.total}
{/foreach}
{if $event->info.event_type_code=='f3f'}
<tr>
	<th colspan="3" align="right">Round Fast Time</th>
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
			<th align="center">
				<a href="" class="tooltip_score" onClick="return false;">
				{$fast|escape}s
				<span>
					<img class="callout" src="/images/callout.gif">
					Fast Time : {$fast}s<br>
					{$event->pilots.$fast_id.pilot_first_name|escape} {$event->pilots.$fast_id.pilot_last_name|escape}
				</span>
				</a>
			</th>
		{/if}
	{/foreach}
</tr>
{/if}
</table>
{$start_round=$end_round+1}
{$end_round=$start_round+$perpage - 1}
{if $end_round>=$prelim_rounds}
	{$end_round=$prelim_rounds - $zero_rounds}
{/if}
{if $page_num!=$pages || $flyoff_rounds!=0}
<br style="page-break-after: always;">
{/if}
{/for}
