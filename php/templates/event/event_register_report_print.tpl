{extends file='layout/layout_print.tpl'}

{block name="header"}
{/block}

{block name="content"}

<h1 class="post-title entry-title">Event Registration Report for {$event->info.event_name}</h1>

<h2>Pilots</h2>
<table width="100%" cellpadding="3" cellspacing="0" class="table table-condensed table-event">
<tr bgcolor="lightgray">
	<th width="2%" align="left"></th>
	<th width="5%" align="center">ORG#</th>
	<th width="5%" align="center" nowrap>FAI License</th>
	<th align="left" colspan="2">Pilot Name</th>
	<th align="left">Pilot Class</th>
	<th align="left">Pilot Reg Values</th>
	<th align="left">Event Team</th>
	<th align="left" align="right">Amount</th>
	<th align="left" align="right">Registration Balance</th>
</tr>
{assign var=num value=1}
{foreach $event->pilots as $p}
{$event_pilot_id=$p.event_pilot_id}
{$total=0}
	<tr>
		<td valign="top" style="border-style:thin;">{$num}</td>
		<td valign="top" align="left" style="border-style:thin;" nowrap>
			{if $p.pilot_fai}
				{$p.pilot_fai|escape}
			{else}
				{$p.pilot_ama|escape}
			{/if}
		</td>
		<td valign="top" align="left" style="border-style:thin;" nowrap>
			{$p.pilot_fai_license|escape}
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
		<td valign="top">
			{foreach $pilot_reg_options.$event_pilot_id as $r}
				{$event_reg_param_id=$r.event_reg_param_id}
				{$total=$total+($r.event_pilot_reg_qty*$reg_options.$event_reg_param_id.event_reg_param_cost)}
				{if $r.event_pilot_reg_qty!=0}
					{$r.event_pilot_reg_qty} - {$reg_options.$event_reg_param_id.event_reg_param_name}<br>
				{/if}
				{if $r.event_pilot_reg_choice_value!=''}
					{foreach $r.event_pilot_reg_choice_values as $v}
						&nbsp;&nbsp&nbsp;{$v}<br>
					{/foreach}
				{/if}
			{/foreach}
		</td>
		<td valign="top" style="border-style:thin;">{$p.event_pilot_team|escape}</td>
		<td valign="top">{$event->info.currency_html} {$total|string_format:"%.2f"}</td>
		<td valign="top" align="right">
			{foreach $payments.$event_pilot_id as $pay}
				{$pay.event_pilot_payment_type} Payment ({$pay.event_pilot_payment_date|date_format:"Y-m-d"})
				{$event->info.currency_html} {$pay.event_pilot_payment_amount|string_format:"%.2f"}
				<br>
			{/foreach}
			Amount Owed - {$event->info.currency_html} {$balances.$event_pilot_id|string_format:"%.2f"}
			<br>
			{if $p.event_pilot_paid_flag==1}
			<font color="green">PAID</font>
			{else}
			<font color="red">DUE</font>
			{/if}
		</td>
	</tr>
	{assign var=num value=$num+1}
	{if $p.event_pilot_reg_note!=''}
	<tr>
		<td colspan="3">&nbsp;</td>
		<td><font color="red">NOTES</font></td>
		<td colspan="5"><font color="red">{$p.event_pilot_reg_note}</font></td>
	</tr>
	{/if}
{/foreach}
</table>



<h2 class="post-title entry-title">Totals For Registration Values</h2>

<table width="100%" cellpadding="2" cellspacing="1" style="border: 2px solid black;" class="table table-condensed table-event">
<tr bgcolor="lightgray">
	<th width="20%">Name</th>
	<th width="10%">Qty</th>
	<th width="10%">Choice Values</th>
	<th width="10%">Cost Per Unit</th>
	<th align="right" width="10%">Extended</th>
</tr>
{$total_collected=0}
{foreach $reg_options as $r}
{$reg_id=$r.event_reg_param_id}
<tr>
	<td align="right" valign="top">
		{$r.event_reg_param_name}
	</td>
	<td align="center" valign="top">
		{$r.qty}
	</td>
	<td align="left" valign="top">
		{foreach $r.values as $v}
			{$v.qty} - {$v@key}<br>
		{/foreach}
	</td>
	<td align="right" valign="top">
		{$event->info.currency_html} {$r.event_reg_param_cost|string_format:"%.2f"}
	</td>
	<td align="right" valign="top">
		{$ext=$r.qty*$r.event_reg_param_cost}
		{$event->info.currency_html} {$ext|string_format:"%.2f"}
	</td>
</tr>
{$total_collected=$total_collected+$ext}
{/foreach}
		<tr>
			<th style="text-align: right;" colspan="4">Total Fees ({$event->info.currency_name})</th>
			<th style="text-align: right;" width="10%">
				{$event->info.currency_html} {$total_collected|string_format:"%.2f"}
			</th>
		</tr>
</table>

{/block}