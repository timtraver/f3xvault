<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix" style="overflow:auto;">                

		<h1 class="post-title entry-title">{$event->info.event_name|escape}
			<input type="button" value=" Back To Event View " onClick="goback.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix" style="overflow:auto;">

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder" style="overflow:auto;">
<tr>
	<th>Location</th>
	<td align="left">
		<a href="?action=location&function=location_view&location_id={$event->info.location_id}">
		{$event->info.location_name|escape}</a> - 
		{$event->info.location_city|escape}, {$event->info.state_name|escape}		
	</td>
</tr>
<tr>
	<th>Dates</th>
	<td align="left">
	{$event->info.event_start_date|date_format:"%A %b %e, %Y"}{if $event->info.event_end_date!=$event->info.event_start_date} to <br>
	{$event->info.event_end_date|date_format:"%A %b %e, %Y"}{/if}
	</td>
</tr>
<tr>
	<th>Type</th>
	<td align="left">
		{$event->info.event_type_name|escape}
	</td>
</tr>
<tr>
	<th>Contest Director</th>
	<td align="left">
		{$cd.pilot_first_name|escape} {$cd.pilot_last_name|escape} - {$cd.pilot_city|escape}
	</td>
</tr>
{if $event->series}
<tr>
	<th valign="top" align="right">Series</th>
	<td valign="top" align="right">
		{foreach $event->series as $s}
		<a href="?action=series&function=series_view&series_id={$s.series_id}">{$s.series_name|escape}</a>{if !$s@last}<br>{/if}
		{/foreach}
	</td>
</tr>
{/if}
{if $event->info.club_name!=''}
<tr>
	<th>Club Association</th>
	<td align="left">
		{$event->info.club_name|escape}
	</td>
</tr>
{/if}
<tr>
	<th valign="top">Registration Status</th>
	<td align="left">
		{if $event->info.event_reg_flag==1}
			{if $event->info.event_reg_status==0 || 
				($event->pilots|count>=$event->info.event_reg_max && $event->info.event_reg_max!=0) ||
				$event_reg_passed==1
			}
				<font color="red"><b>Registration Currently Closed</b></font>
			{else}
				<font color="green"><b>Registration Currently Open</b></font>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="?action=event&function=event_register&event_id={$event->info.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if}>
				Register Me Now!
				</a>
			{/if}
		{else}
			There is no registration required for this event.
		{/if}
	</td>
</tr>
{if $event->reg_options}
<tr>
	<th valign="top">Available Registration Options</th>
	<td align="left">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		{foreach $event->reg_options as $r}
		<tr{if $r.event_reg_param_mandatory==1} style="background:lightgrey;"{/if}>
			<td>{$r.event_reg_param_name}</td>
			<td width="5%" align="right">{if $r.event_reg_param_units=="US Dollars"}{$r.event_reg_param_cost|string_format:"$%.2f"}
				{elseif $r.event_reg_param_units=="Euros"}{$r.event_reg_param_cost|string_format:"€%.2f"}
				{else}{$r.event_reg_param_cost|string_format:"%.2f"}
				{/if}
			</td>
			<td>{$r.event_reg_param_units}
				{if $r.event_reg_param_qty_flag==1} Each{/if}
			</td>
			<td>
				{if $r.event_reg_param_mandatory==1} Required {else} Optional {/if}
			</td>
			
		</tr>
		{/foreach}
		</table>
	</td>
</tr>
{/if}
<tr>
	<th valign="top">Event Notes</th>
	<td align="left">
		<pre style="white-space: pre-wrap;">{$event->info.event_notes|escape}</pre>
	</td>
</tr>
<tr>
	<th valign="top">Event Draws</th>
	<td align="left">
		{if $event->draws}
		
		{else}
		<font color="red">Draws Not Yet Created</font>
		{/if}
	</td>
</tr>

</table>
</form>


<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>


</div>
</div>
</div>

