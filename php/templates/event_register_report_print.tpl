<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Registration Report for {$event->info.event_name}</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Pilots</h1>
<table width="100%" cellpadding="3" cellspacing="0" style="border: 1px solid black;" class="tableborder">
<tr bgcolor="lightgray">
	<th width="2%" align="left"></th>
	<th width="10%" align="center">ORG#</th>
	<th align="left" colspan="2">Pilot Name</th>
	<th align="left">Pilot Class</th>
	<th align="left">Pilot Reg Values</th>
	<th align="left">Event Team</th>
	{if $event->info.event_reg_flag==1}
	<th align="left" align="right">Reg Status</th>
	{/if}
	<th align="left" width="4%"></th>
</tr>
{assign var=num value=1}
{foreach $event->pilots as $p}
{$event_pilot_id=$p.event_pilot_id}
{$total=0}
	<tr>
		<td valign="top" style="border-style:thin;">{$num}</td>
		<td valign="top" align="left" style="border-style:thin;">
			{if $p.pilot_fai}
				{$p.pilot_fai|escape}
			{else}
				{$p.pilot_ama|escape}
			{/if}
		</td>
		<td valign="top" width="10" nowrap style="border-style:thin;">
			{if $p.country_code}<img src="/images/flags/countries-iso/shiny/16/{$p.country_code|escape}.png" class="inline_flag" title="{$p.country_code}">{/if}
		</td>
		<td valign="top" style="border-style:thin;">
			{if $p.event_pilot_bib!='' && $p.event_pilot_bib!=0}
				<div class="pilot_bib_number">{$p.event_pilot_bib}</div>
			{/if}
			{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}
		</td>
		<td valign="top" style="border-style:thin;">{$p.class_description|escape}</td>
		<td valign="top" style="border-style:thin;">
			{foreach $pilot_reg_options.$event_pilot_id as $r}
			{$event_reg_param_id=$r.event_reg_param_id}
			{$total=$total+($r.event_pilot_reg_qty*$reg_options.$event_reg_param_id.event_reg_param_cost)}
			{if $r.event_pilot_reg_qty!=0}
			{$r.event_pilot_reg_qty} - {$reg_options.$event_reg_param_id.event_reg_param_name}<br>
			{/if}
			{/foreach}
		</td>
		<td valign="top" style="border-style:thin;">{$p.event_pilot_team|escape}</td>
		{if $event->info.event_reg_flag==1}
			<td valign="top" align="right" style="border-style:thin;">
				{$event->info.currency_html}{$total|string_format:"%.2f"}&nbsp;&nbsp;
				{if $p.event_pilot_paid_flag==1}
				<font color="green">PAID</font>
				{else}
				<font color="red">DUE</font>
				{/if}
			</td>
		{/if}
		<td valign="top" nowrap style="border-style:thin;">
			<a href="/?action=event&function=event_pilot_edit&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Edit Event Pilot"><img width="16" src="/images/icon_edit_small.gif"></a>
			{if $user.user_id!=0 && ($permission==1 || $user.user_admin==1)}		
				<a href="/?action=event&function=event_pilot_remove&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Remove Event Pilot" onClick="return confirm('Are you sure you want to remove {$p.pilot_first_name|escape} from the event?');"><img width="14px" src="/images/del.gif"></a>
			{/if}
		</td>
	</tr>
	{assign var=num value=$num+1}
{/foreach}
</table>



<h1 class="post-title entry-title">Totals For Registration Values</h1>

<table width="100%" cellpadding="2" cellspacing="1" style="border: 2px solid black;" class="printborder">
<tr bgcolor="lightgray">
	<th width="20%">Name</th>
	<th width="10%"> Qty</th>
	<th width="10%">Cost Per Unit</th>
	<th align="right" width="10%">Extended</th>
</tr>
{$total_collected=0}
{foreach $reg_options as $r}
{$reg_id=$r.event_reg_param_id}
<tr>
	<td align="right">
		{$r.event_reg_param_name}
	</td>
	<td align="center">
		{$r.qty}
	</td>
	<td align="right">
		{$event->info.currency_html}{$r.event_reg_param_cost|string_format:"%.2f"}
	</td>
	<td align="right">
		{$ext=$r.qty*$r.event_reg_param_cost}
		{$event->info.currency_html}{$ext|string_format:"%.2f"}
	</td>
</tr>
{$total_collected=$total_collected+$ext}
{/foreach}
<tr>
	<th align="right" colspan="3">Total Registration Fee ({$event->info.currency_name})</th>
	<th align="right" width="10%">
		{$event->info.currency_html}{$total_collected|string_format:"%.2f"}
	</th>
</tr>
</table>


</div>
</div>
</div>

