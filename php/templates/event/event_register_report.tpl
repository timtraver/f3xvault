{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Event Registration Report for {$event->info.event_name}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">

		<h2 class="post-title entry-title">Pilots</h2>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
			<th width="2%" align="left"></th>
			<th width="5%" align="center">ORG#</th>
			<th width="5%" align="center" nowrap>FAI License</th>
			<th align="left" colspan="2">Pilot Name</th>
			<th align="left">Pilot Class</th>
			<th align="left">Pilot Reg Values</th>
			<th align="left">Event Team</th>
			<th align="left" align="right">Amount</th>
			<th align="left" align="right">Registration Balance</th>
			<th align="left" width="4%"></th>
		</tr>
		{assign var=num value=1}
		{foreach $event->pilots as $p}
		{$event_pilot_id=$p.event_pilot_id}
		{$total=0}
			<tr>
				<td valign="top">{$num}</td>
				<td valign="top" align="left" nowrap>
					{if $p.pilot_fai}
						{$p.pilot_fai|escape}
					{else}
						{$p.pilot_ama|escape}
					{/if}
				</td>
				<td valign="top" align="left" nowrap>
					{$p.pilot_fai_license|escape}
				</td>
				<td valign="top" width="10" nowrap>
					{if $p.country_code}<img src="/images/flags/countries-iso/shiny/16/{$p.country_code|escape}.png" class="inline_flag" title="{$p.country_code}">{/if}
				</td>
				<td valign="top">
					{if $p.event_pilot_bib!='' && $p.event_pilot_bib!=0}
						<div class="pilot_bib_number">{$p.event_pilot_bib}</div>
					{/if}
					{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}
				</td>
				<td valign="top">{$p.class_description|escape}</td>
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
				<td valign="top">{$p.event_pilot_team|escape}</td>
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
				<td valign="top" nowrap>
					<a href="/?action=event&function=event_pilot_edit&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Edit Event Pilot"><img width="16" src="/images/icon_edit_small.gif"></a>
					{if $user.user_id!=0 && ($permission==1 || $user.user_admin==1)}		
						<a href="/?action=event&function=event_pilot_remove&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Remove Event Pilot" onClick="return confirm('Are you sure you want to remove {$p.pilot_first_name|escape} from the event?');"><img width="14px" src="/images/del.gif"></a>
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
		
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
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
		<center>
		<input type="button" value=" Print Report " onClick="print_report.submit();" class="btn btn-primary btn-rounded">
		</center>
		<br>
		<br>
	</div>
</div>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="tab" value="">
</form>
<form name="print_report" method="POST" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_registration_report">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="use_print_header" value="1">
</form>

{/block}
