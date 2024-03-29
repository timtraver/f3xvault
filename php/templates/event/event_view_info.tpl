{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Event Info for {$event->info.event_name|escape}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">

		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
			<th>Location</th>
			<td>
				<a href="?action=location&function=location_view&location_id={$event->info.location_id}">
				{$event->info.location_name|escape}</a> - 
				{$event->info.location_city|escape}, {$event->info.state_name|escape}		
				{if $event->info.country_code}<img src="/images/flags/countries-iso/shiny/16/{$event->info.country_code|escape}.png" class="inline_flag" title="{$event->info.country_name}">{/if}
				{if $event->info.state_name && $event->info.country_code=="US"}<img src="/images/flags/states/16/{$event->info.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$event->info.state_name}">{/if}
				{if $event->info.location_coordinates!=''} - <a class="fancybox-map" href="https://maps.google.com/maps?q={$event->info.location_coordinates|escape:'url'}+({$event->info.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}
			</td>
		</tr>
		<tr>
			<th>Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%A %b %e, %Y"}{if $event->info.event_end_date!=$event->info.event_start_date} to 
			{$event->info.event_end_date|date_format:"%A %b %e, %Y"}{/if}
			</td>
		</tr>
		<tr>
			<th>Type</th>
			<td>
				{$event->info.event_type_name|escape}
			</td>
		</tr>
		<tr>
			<th>Contest Director</th>
			<td>
				{$cd.pilot_first_name|escape} {$cd.pilot_last_name|escape} - {$cd.pilot_city|escape}
				{if $cd.country_code}<img src="/images/flags/countries-iso/shiny/16/{$cd.country_code|escape}.png" class="inline_flag" title="{$cd.country_name}">{/if}
				{if $cd.state_name && $event->info.country_code=="US"}<img src="/images/flags/states/16/{$cd.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$cd.state_name}">{/if}
				{if $cd.user_id!=0}<a href="?action=message&function=message_edit&to_user_id={$cd.user_id}" class="btn-link">Send Message</a>{/if}
			</td>
		</tr>
		{if $event->series}
		<tr>
			<th valign="top">Part of Series</th>
			<td valign="top">
				{foreach $event->series as $s}
					<a href="?action=series&function=series_view&series_id={$s.series_id}">{$s.series_name|escape}</a>{if !$s@last}<br>{/if}
				{/foreach}
			</td>
		</tr>
		{/if}
		{if $event->info.club_name!=''}
		<tr>
			<th>Club Association</th>
			<td>
				{$event->info.club_name|escape}
			</td>
		</tr>
		{/if}
		{if $event->info.event_reg_flag==1}
		<tr>
			<th align="right">Registration Status</th>
			<td colspan="3">
				{if $event->info.event_reg_status == 0 || 
					($event->pilots|count >= $event->info.event_reg_max && $event->info.event_reg_max != 0) ||
					($event->info.event_reg_close_on == 1 && time() > $event->info.event_reg_close_date_stamp) ||
					($event->info.event_reg_status == 2 && time() < $event->info.event_reg_open_date_stamp)
				}
					<font color="red"><b>Registration Currently Closed {if $event->pilots|count>=$event->info.event_reg_max && $event->info.event_reg_max != 0} Due To Max Pilots{/if}</b></font>
					{if $event->info.event_reg_status == 2 && time() < $event->info.event_reg_open_date_stamp}
					<font color="green">(Registration opens on {date("Y-m-d h:i a",$event->info.event_reg_open_date_stamp)} - {$event->info.event_reg_open_tz|escape} Tim Zone)</font>
					{/if}
				{else}
					<font color="green"><b>Registration Currently Open</b></font>
					&nbsp;&nbsp;&nbsp;&nbsp;
					{if $registered==0}
						<a href="?action=event&function=event_register&event_id={$event->info.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if} class="btn btn-success btn-rounded">
						Register Me Now!
						</a>
					{/if}
				{/if}
				{if $registered == 1}
					You Are Currently Registered For This Event! &nbsp;&nbsp;&nbsp;&nbsp;
					<a href="?action=event&function=event_register&event_id={$event->info.event_id}" class="btn btn-success btn-rounded">
						 Update Your Registration Info Here
					</a>
					<a href="?action=event&function=event_register_cancel&event_id={$event->info.event_id}" class="btn btn-danger btn-rounded" onClick="return confirm('Are you sure you wish to unregister yourself from this event?');">
						 Cancel My Registration
					</a>
				{/if}
			</td>
		</tr>
		{/if}
		
		
		{if $event->reg_options}
		<tr>
			<th valign="top">Available Registration Options</th>
			<td>
				<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
				{foreach $event->reg_options as $r}
				<tr{if $r.event_reg_param_mandatory==1} style="background:lightgrey;"{/if}>
					<td>
						{$r.event_reg_param_name} 
						<a href="" class="tooltip" onClick="return false;">(detail description)
							<span>
								<img class="callout" src="/images/callout.gif">
								<strong>Registration Item Detail</strong><br>
								<table>
								<tr>
									<td>{$r.event_reg_param_description}</td>
								</tr>
								</table>
							</span>
						</a>
					
					
					</td>
					<td width="5%" align="right">{$event->info.currency_html}{$r.event_reg_param_cost|string_format:"%.2f"}</td>
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
			<td>
				<div style="white-space: pre-wrap;">{$event->info.event_notes|escape}</div>
			</td>
		</tr>
		{if $event->info.event_type_code=='f3k'}
		<tr>
			<th valign="top">Event Tasks</th>
			<td>
				{if $event->tasks}
				<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
				<tr>
					<th>Round Type</th>
					<th>Round</th>
					<th>Task</th>
				</tr>
				{foreach $event->tasks as $t}
				{$ft=$t.flight_type_id}
				<tr style="background:lightgrey;">
					<td width="10%">
						{if $t.event_task_round_type=='prelim'}Preliminary{else}Flyoff{/if}
					</td>
					<td width="5%" align="right">
						{$t.event_task_round}
					</td>
					<td>
						{$event->flight_types.$ft.flight_type_name}
					</td>
				</tr>
				{/foreach}
				</table>
				{else}
				<font color="red">Tasks Not Yet Determined</font>
				{/if}
			</td>
		</tr>
		{/if}
		</table>
		</form>
		
		
		<form name="goback" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_view">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="tab" value="">
		</form>


	</div>
</div>
{/block}

