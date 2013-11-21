
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Registration Parameters
			<input type="button" value=" Back To Event Edit " onClick="goback.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Registration Parameters</h1>
<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_reg_save">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%">Registration Status</th>
	<td>
		<select name="event_reg_status">
		<option value="0"{if $event->info.event_reg_status==0} SELECTED{/if}>Registration Currently Closed</option>
		<option value="1"{if $event->info.event_reg_status==1} SELECTED{/if}>Registration Currently Open</option>
		<option value="2"{if $event->info.event_reg_status==2} SELECTED{/if}>Registration Open Until Date</option>
		</select>
	</td>
</tr>
<tr>
	<th>Registration Till Date</th>
	<td>
	{html_select_date prefix="event_reg_date" end_year="+3" day_format="%02d" time=$event->info.event_reg_date} 
	</td>
</tr>
<tr>
	<th>Registration Max Participants</th>
	<td>
		<input type="text" size="3" name="event_reg_max" value="{$event->info.event_reg_max}"> 0=unlimited
	</td>
</tr>
<tr>
	<th>Registration Requires Payment</th>
	<td>
		<input type="checkbox" name="event_reg_pay_flag"{if $event->info.event_reg_pay_flag==1} CHECKED{/if}>
	</td>
</tr>
<tr>
	<th>Payment Currency</th>
	<td>
		<select name="currency_id">
		{foreach $currencies as $c}
		<option value="{$c.currency_id}"{if $event->info.currency_id==$c.currency_id} SELECTED{/if}>{$c.currency_name} {$c.currency_html}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th>PayPal Link Email</th>
	<td>
		<input type="text" size="40" name="event_reg_paypal_address" value="{$event->info.event_reg_paypal_address}">
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="submit" value=" Save Registration Parameters " class="block-button" onClick="return check_event();">
	</th>
</tr>
</table>

<h1 class="post-title entry-title">Additional Registration Values</h1>
<select name="event_reg_add_name" style="float:left;">
<option value="0">Select From This list for Common Registration values to add</option>
<option value="">Blank Entry For Customization</option>
<option value="Event Registration Fee">Event Registration Fee</option>
<option value="Battery Rental">Battery Rental</option>
<option value="T-Shirt Purchase">T-Shirt Purchase</option>
<option value="Breakfast Meal">Breakfast Meal</option>
<option value="Lunch Meal">Lunch Meal</option>
<option value="Dinner Meal">Dinner Meal</option>
<option value="Opening Banquet">Opening Banquet</option>
<option value="Closing Banquet">Closing Banquet</option>
<option value="Team Pilot Credential">Team Pilot Credential</option>
<option value="Team Manager Credential">Team Manager Credential</option>
<option value="Team Helper Credential">Team Helper Credential</option>
</select>&nbsp;&nbsp;
<input type="button" value=" Add New Value " class="block-button" style="float:left;" onClick="main.submit();">

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="5%">Mandatory</th>
	<th width="20%">Name</th>
	<th>Full Description (For Details if necessary)</th>
	<th width="10%">Allow Qty</th>
	<th width="10%">Cost Per Unit</th>
	<th width="1%"></th>
</tr>
{if $event->reg_options}
{foreach $event->reg_options as $r}
<tr>
	<th valign="top">
		<input type="checkbox" name="reg_param_{$r.event_reg_param_id}_man"{if $r.event_reg_param_mandatory==1} CHECKED{/if}>
	</th>
	<th valign="top">
		<input type="text" name="reg_param_{$r.event_reg_param_id}_name" size="40" value="{$r.event_reg_param_name}">
	</th>
	<th>
		<textarea name="reg_param_{$r.event_reg_param_id}_desc" cols="40" rows="2">{$r.event_reg_param_description}</textarea>
	</th>
	<th>
		<input type="checkbox" name="reg_param_{$r.event_reg_param_id}_qty"{if $r.event_reg_param_qty_flag==1} CHECKED{/if}>
	</th>
	<th>
		<input type="text" name="reg_param_{$r.event_reg_param_id}_cost" size="6" value="{$r.event_reg_param_cost}">
	</th>
	<th>
		<a title="Delete" href="?action=event&function=event_reg_del&event_id={$event->info.event_id}&event_reg_param_id={$r.event_reg_param_id}"><img src="/images/del.gif"></a>
	</th>
</tr>
{/foreach}
{else}
<tr>
	<td colspan="6">
		This event currently has no additional registration parameters
	</td>
</tr>
{/if}
</table>
</form>


<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>



</div>
</div>
</div>

