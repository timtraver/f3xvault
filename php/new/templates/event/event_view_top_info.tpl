<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">{$event->info.event_name|escape}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
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
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape} - {$event->info.pilot_city|escape}
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
				{if $event->info.event_reg_status==0 || 
					($event->pilots|count>=$event->info.event_reg_max && $event->info.event_reg_max!=0) ||
					$event_reg_passed==1
				}
					<font color="red"><b>Registration Currently Closed</b></font>
				{else}
					<font color="green"><b>Registration Currently Open</b></font>
					<a href="?action=event&function=event_register&event_id={$event->info.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if}>
					Register Me Now!
					</a>
				{/if}
					&nbsp;&nbsp;&nbsp;&nbsp;
					{if $registered==1}
					<a href="?action=event&function=event_register&event_id={$event->info.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if}>
					You Are Registered! Update Your Registration Info
					</a>
					{/if}
			</td>
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
				<li><a href="#" onClick="document.event_tasks.submit();">Set F3K Tasks</a></li>
				{/if}
				{if $active_draws || $event->pilots|count >0}
				<li><a href="#" onClick="{if $event->pilots|count==0}alert('You must enter pilots before you can create a draw for this event.');{else}event_draw.submit();{/if}">Manage Event Draws</a></li>
				{/if}
				{if ($permission==1 || $user.user_admin==1) && $event->info.event_reg_status!=0}
				<li><a href="#" onClick="if(check_permission()){ldelim}registration_report.submit();{rdelim}">View Registration Report</a></li>
				{/if}
				{if $event->info.event_id!=0}
				<li><a href="#" onClick="document.event_export.submit();">Export Event Info</a></li>
				{/if}
				
				<li class="dropdown-header">Printing Functions</li>
				<li><a href="#" onClick="document.print_pilot_list.submit();">Print Pilot List</a></li>
				{if $event->rounds|count > 0}
				<li><a href="#" onClick="document.print_overall.submit();">Print Overall Classification</a></li>
				<li><a href="#" onClick="$('#print_round').dialog('open');">Print Round Detail</a></li>
				<li><a href="#" onClick="document.print_rank.submit();">Print Class Rankings</a></li>
				{/if}
				{if $active_draws}
				<li><a href="#" onClick="document.print_overall.submit();">Print Draw</a></li>
				{/if}
				{if $user.user_id!=0 && $user.user_id==$event->info.user_id || $user.user_admin==1}
				<li class="divider"></li>
				<li><a href="#" onClick="confirm('Are you sure you wish to delete this event?') && event_delete.submit();">Delete Event</a></li>
				{/if}
			</ul>
		</div>
		<br>
		<br>
		<br>
	</div>
</div>
