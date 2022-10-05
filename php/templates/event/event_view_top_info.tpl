<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">{$event->info.event_name|escape}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Reload " onClick="document.event_view.submit();" class="btn btn-primary btn-rounded" style"float:right;">
			<input type="button" value=" Back To Event List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">

		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered" style="margin-bottom: 10px;">
		<tr>
			<th align="right">Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"}{if $event->info.event_end_date!=$event->info.event_start_date} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}{/if}
			</td>
			<th align="right">Location</th>
			<td>
			<a href="?action=location&function=location_view&location_id={$event->info.location_id}">{$event->info.location_name|escape} - {$event->info.location_city|escape},{$event->info.state_code|escape} {$event->info.country_code|escape}</a>
			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			{$event->info.event_type_name|escape}
			</td>
			<th align="right">Contest Director</th>
			<td>
				{if $event->info.pilot_id != 0}
					{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape} - {$event->info.pilot_city|escape} &nbsp;&nbsp;&nbsp;&nbsp;
					<a href="?action=event_message&function=event_message_send&event_id={$event->info.event_id}&to=cd" class="btn btn-success btn-rounded" style="height: 20px;margin: 0px;padding-top: 0px;">
						 Send Message To CD
					</a>
				{/if}
			</td>
		</tr>
		{if $event->series || $event->info.club_name}
		<tr>
			<th align="right" valign="top">Part Of Series</th>
			<td valign="top">
				{foreach $event->series as $s}
				<a href="?action=series&function=series_view&series_id={$s.series_id}">{$s.series_name|escape}</a>{if !$s@last}<br>{/if}
				{/foreach}
			</td>
			<th align="right" valign="top">Club</th>
			<td valign="top">
			<a href="?action=club&function=club_view&club_id={$event->info.club_id}">{$event->info.club_name|escape}</a>
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
					<font color="green">(Registration opens on {date("Y-m-d h:i a",$event->info.event_reg_open_date_stamp)} - {$event->info.event_reg_open_tz|escape} Time Zone)</font>
					{/if}
					<br>
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
		</table>
		
		<div class="btn-group" style="float: right;width: 200px;">
			<button class="btn btn-primary dropdown-toggle btn-rounded" data-toggle="dropdown" type="button" style="width: 200px;font-size: 16px;">
				Select Event Action <i class="dropdown-caret fa fa-chevron-down"></i>
			</button>
			<ul class="dropdown-menu dropdown-menu-right" style="width: 200px;">
				<li class="dropdown-header">Main Functions</li>
				<li><a href="#" onClick="if(check_permission()){ldelim}document.event_edit.submit();{rdelim}">Event Settings</a></li>
				<li><a href="#" onClick="document.event_view_info.submit();">View Full Event Info</a></li>
				{if $event->info.event_type_code == 'f3k'}
				<li><a href="#" onClick="if(check_permission()){ldelim}document.event_tasks.submit();{rdelim}">Set F3K Tasks</a></li>
				{/if}
				{if $event->info.event_type_code == 'gps'}
				<li><a href="#" onClick="if(check_permission()){ldelim}document.event_tasks.submit();{rdelim}">Set GPS Tasks</a></li>
				{/if}
				{if $event->info.event_type_code == 'f3j'}
				<li><a href="#" onClick="if(check_permission()){ldelim}document.event_tasks.submit();{rdelim}">Set F3J Tasks</a></li>
				{/if}
				{if $event->info.event_type_code == 'f5j'}
				<li><a href="#" onClick="if(check_permission()){ldelim}document.event_tasks.submit();{rdelim}">Set F5J Tasks</a></li>
				{/if}
				{if $event->info.event_type_code == 'td'}
				<li><a href="#" onClick="if(check_permission()){ldelim}document.event_tasks.submit();{rdelim}">Set TD Tasks</a></li>
				{/if}
				{if ($permission==1 || $user.user_admin==1) && $event->rounds|count > 0}
				<li><a href="#" onClick="document.recalculate.submit();">Recalculate All Rounds</a></li>
				{/if}
				{if $active_draws || $event->pilots|count >0}
				<li><a href="#" onClick="if(check_permission()){ldelim}{if $event->pilots|count==0}alert('You must enter pilots before you can create a draw for this event.');{else}event_draw.submit();{/if}{rdelim}">Manage Event Draws</a></li>
				{/if}
				{if ($permission==1 || $user.user_admin==1) && $event->info.event_reg_flag!=0}
				<li><a href="#" onClick="if(check_permission()){ldelim}registration_report.submit();{rdelim}">View Registration Report</a></li>
				{/if}
				{if $event->info.event_id!=0}
				<li><a href="#" onClick="document.event_export.submit();">Export Event Info</a></li>
				{/if}
				
				<li class="dropdown-header">Printing Functions</li>
				<li><a href="#" onClick="document.print_pilot_list.submit();">Print Pilot List</a></li>
				{if $event->rounds|count > 0}
				<li><a href="#" onClick="document.print_overall.submit();">Print Overall Classification (Basic)</a></li>
				<li><a href="#" onClick="document.print_overall_full.submit();">Print Overall Classification (Full)</a></li>
				<li><a href="#" onClick="document.print_position.submit();">Print Position Chart</a></li>
				<li><a href="#" onClick="$('#print_round').dialog('open');">Print Round Detail</a></li>
				<li><a href="#" onClick="document.print_rank.submit();">Print Class Rankings</a></li>
				<li><a href="#" onClick="document.print_stats.submit();">Print Statistics</a></li>
				{/if}
				{if $active_draws}
				<li><a href="#" onClick="document.event_draw.submit();">Print Draws</a></li>
				{/if}
				{if $user.user_id!=0 && $user.user_id==$event->info.user_id || $user.user_admin==1}
				<li class="divider"></li>
				<li><a href="#" onClick="event_copy.submit();">Copy Event</a></li>
				<li><a href="#" onClick="confirm('Are you sure you wish to delete this event?') && event_delete.submit();">Delete Event</a></li>
				{/if}
			</ul>
		</div>
		<br>
		<br>
		<br>
	</div>
</div>
<!-- If this event has a self entry, then show a big button for them to use -->
{if $self_entry == 1}
<div class="panel">
	<h2 style="float: left;">Self Score Entry</h2>
	<div style="float:right;overflow:hidden;margin-top:10px;margin-bottom: 10px;margin-right: 10px;">
		<input type="button" value=" Enter My Scores " onClick="document.event_self_entry.submit();" class="btn btn-success btn-rounded" style="float:right;font-size: 16px;margin-bottom: 10px;">
	</div>
	<br>
	<br>
	<br>
	
</div>
{/if}

<!-- All the forms for the action list -->
<form name="event_view" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_edit" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="tab" value="0">
</form>
<form name="event_view_info" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view_info">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_view_draws" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view_draws">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_delete" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_delete">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_copy" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_copy">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_pilot_add" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_pilot_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_pilot_id" value="0">
<input type="hidden" name="pilot_id" value="">
<input type="hidden" name="pilot_name" value="">
</form>
<form name="event_add_round" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_round_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_round_id" value="0">
<input type="hidden" name="zero_round" value="0">
<input type="hidden" name="flyoff_round" value="0">
</form>
<form name="recalculate" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="recalculate" value="1">
</form>
<form name="print_overall" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_overall">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="full" value="0">
</form>
<form name="print_overall_full" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_overall">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="full" value="1">
</form>
<form name="print_pilot_list" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_pilot_list">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="chart" method="GET" action="?">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_chart">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="print_stats" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_stats">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="print_rank" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_rank">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="print_position" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_position_chart">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="registration_report" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_registration_report">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_export" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_export">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_draw" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_tasks" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_tasks">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>

<form name="event_self_entry" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_self_entry">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>

<div id="print_round" style="overflow: hidden;display: none;">
		<form name="printround" method="POST" target="_blank">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_print_round">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<div style="float: left;padding-right: 10px;">
			Print Round From :
			<select name="round_start_number">
			{foreach $event->rounds as $r}
			<option value="{$r.event_round_number}">{$r.event_round_number}</option>
			{/foreach}
			</select>
			To 
			<select name="round_end_number">
			{foreach $event->rounds as $r}
			<option value="{$r.event_round_number}">{$r.event_round_number}</option>
			{/foreach}
			</select><br>
			<br>
			Print One Round Per Page <input type="checkbox" name="oneper" CHECKED>
		</div>
		<br style="clear:both" />
		</form>
</div>
