<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">{$event->info.event_name|escape}</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"}{if $event->info.event_end_date!=$event->info.event_start_date} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}{/if}
			</td>
		</tr>
		<tr>
			<th align="right">Location</th>
			<td>
			<a href="?action=location&function=location_view&location_id={$event->info.location_id}">{$event->info.location_name|escape} - {$event->info.state_code|escape} {$event->info.country_code|escape}</a>
			</td>
		</tr>
		<tr>
			<th align="right">Type</th>
			<td>
			{$event->info.event_type_name|escape}
			</td>
		</tr>
		<tr>
			<th align="right">CD</th>
			<td>
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape}
			</td>
		</tr>
		{if $event->series || $event->info.club_name}
		<tr>
			<th valign="top" align="right">Series</th>
			<td valign="top" align="right">
				{foreach $event->series as $s}
				<a href="?action=series&function=series_view&series_id={$s.series_id}">{$s.series_name|escape}</a>{if !$s@last}<br>{/if}
				{/foreach}
			</td>
		</tr>
		<tr>
			<th align="right">Club</th>
			<td>
			<a href="?action=club&function=club_view&club_id={$event->info.club_id}">{$event->info.club_name|escape}</a>
			</td>
		</tr>
		{/if}
		{if $event->info.event_reg_flag==1}
		<tr>
			<th align="right">Registration Status</th>
			<td>
				{if $event->info.event_reg_status==0 || 
					($event->pilots|count>=$event->info.event_reg_max && $event->info.event_reg_max!=0) ||
					$event_reg_passed==1
				}
					<font color="red"><b>Registration Currently Closed</b></font>
				{else}
					<font color="green"><b>Registration Currently Open</b></font>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="?action=event&function=event_register&event_id={$event->info.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if}>
					{if $registered==1}
					You Are Registered! Update Your Registration Info
					{else}
					Register Me Now!
					{/if}
					</a>
				{/if}
			</td>
		{/if}
		</table>
		
		<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="block-button">
	</div>
<br>
<h1 class="post-title entry-title">Draws</h1>

<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw_edit">
<input type="hidden" name="event_draw_id" value="0">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="flight_type_id" value="0">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%" nowrap>Flight Type</th>
	<th width="10%" nowrap>Round From</th>
	<th width="10%" nowrap>Round To</th>
	<th nowrap>View</th>
</tr>
{$f3k_first=0}
{foreach $event->flight_types as $ft}
	{if $f3k_first!=0}
		{continue}
	{/if}
	{$total=0}
	{foreach $event->draws as $d}
		{if $d.flight_type_id==$ft.flight_type_id}
			{$total=$total+1}
		{/if}
	{/foreach}
	{if $total==0}
		<tr>
			<th width="20%" nowrap>
				{if $event->info.event_type_code=='f3k'}
					F3K
				{else}
					{$ft.flight_type_name}
				{/if}
			</th>
			<td colspan="4">No draws created</td>
		</tr>
	{else}	
		{foreach $event->draws as $d}
			{if $d.flight_type_id!=$ft.flight_type_id || $d.event_draw_active==0}
				{continue}
			{/if}
			<tr>
			<th nowrap>
				{if $event->info.event_type_code=='f3k'}
					F3K
				{else}
					{$ft.flight_type_name}
				{/if}
			</th>
			<td align="center">{$d.event_draw_round_from}</td>
			<td align="center">{$d.event_draw_round_to}</td>
			<td align="center" nowrap>
				{if $ft.flight_type_code!="f3b_speed" && $ft.flight_type_code!="f3b_speed_only" && $ft.flight_type_code!="f3f_speed"}
				<input type="button" value="View Draw Stats" class="button" style="float:left;" onClick="location.href='?action=event&function=event_draw_stats&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}&flight_type_id={$d.flight_type_id}&from_event_view=1';">
				{/if}
				<input type="button" value="View Draw" class="button" style="float:left;" onClick="location.href='?action=event&function=event_draw_view&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}&flight_type_id={$d.flight_type_id}';">
			</td>
			</tr>
		{/foreach}
	{/if}
	{if $event->info.event_type_code=='f3k'}
		{$f3k_first=1}
	{/if}
{/foreach}
</table>
</form>



<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_draw" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>

</div>
</div>
</div>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

