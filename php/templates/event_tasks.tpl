<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Tasks for {$event->info.event_name|escape}
				<input type="button" value=" Back To Event Edit " onClick="goback.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
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
			<th align="right">Event Contest Director</th>
			<td>
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape} - {$event->info.pilot_city|escape}
			</td>
		</tr>
		{if $event->info.series_name || $event->info.club_name}
		<tr>
			<th align="right">Part Of Series</th>
			<td>
			<a href="?action=series&function=series_view&series_id={$event->info.series_id}">{$event->info.series_name|escape}</a>
			</td>
			<th align="right">Club</th>
			<td>
			<a href="?action=club&function=club_view&club_id={$event->info.club_id}">{$event->info.club_name|escape}</a>
			</td>
		</tr>
		{/if}
		</table>
		
	</div>
<br>
<h1 class="post-title entry-title">F3K Round Tasks</h1>

<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_tasks_save">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="add_round" value="0">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="10%" nowrap>Round Number</th>
	<th width="20%" nowrap>Round Type</th>
	<th width="65%" nowrap>Task</th>
	<th width="5%" nowrap>Action</th>
</tr>
{foreach $event->tasks as $t}
	<tr>
		<th width="20%" nowrap>
			{if $t.event_task_round_type=='flyoff'}
				{$t.event_task_round-$last_prelim_round}
			{else}
				{$t.event_task_round}
			{/if}
		</th>
		<th width="20%" nowrap>
			<select name="event_task_round_type_{$t.event_task_id}">
			<option value="prelim" {if $t.event_task_round_type=='prelim'}SELECTED{/if}>Preliminary Round</option>
			<option value="flyoff" {if $t.event_task_round_type=='flyoff'}SELECTED{/if}>Flyoff Round</option>
			</select>
		</th>
		<th width="20%" nowrap>
			<select name="flight_type_id_{$t.event_task_id}">
			{foreach $event->flight_types as $ft}
				<option value="{$ft.flight_type_id}"{if $ft.flight_type_id==$t.flight_type_id} SELECTED{/if}>{$ft.flight_type_name}</option>
			{/foreach}
			</select>
		</th>
		<th>
		{if $t@last}
			<a href="?action=event&function=event_task_del&event_id={$event->info.event_id}&event_task_id={$t.event_task_id}" title="Remove Task" onClick="confirm('Are you sure you wish to remove this task?');"><img src="images/del.gif"></a>
		{/if}
		</th>
	</tr>
{/foreach}
<tr>
	<td colspan="4" style="padding-top:10px;">
		<input type="button" value=" Save Rounds " onClick="document.main.submit();" class="block-button">
		<input type="button" value=" Add Round " onClick="document.main.add_round.value=1;document.main.submit();" class="block-button">
		<input type="button" value=" Print Blank Pilot Sheets " onClick="document.print_pilot_tasks.submit();" class="block-button">
	</td>
</tr>
</table>
</form>

<br>
<h1 class="post-title entry-title">Audio Playlist Generation <font color="red">(Not Yet Implemented)</font></h1>
<form name="audio" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_tasks_audio">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
We can generate a contest play list to run the task announcements. Select from the following options.<br>
<br>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="10%" align="right" nowrap>Location of Audio Files</th>
	<td>
	<input type="file" name="audio_location"> Select any file inside the directory that has all of the files
	</td>
</tr>
<tr>
	<th width="10%" align="right" nowrap>Use Pilot Name Sound Files</th>
	<td>
	<input type="file" name="audio_location"> Select any file inside the directory that has all of the files
	</td>
</tr>
<tr>
	<th width="10%" align="right" nowrap>Preparation Time Before Each Task</th>
	<td>
	<select name"delay_round">
	<option value="60">1 Minute</option>
	<option value="120" SELECTED>2 Minutes</option>
	<option value="180">3 Minutes</option>
	</select>
	</td>
</tr>
<tr>
	<th width="10%" align="right" nowrap>Delay In Between Rounds</th>
	<td>
	<select name"delay_round">
	<option value="0">No Delay</option>
	<option value="30">30 Seconds</option>
	<option value="60">1 Minute</option>
	<option value="90">1 Minute 30 Seconds</option>
	<option value="120">2 Minutes</option>
	<option value="180">3 Minutes</option>
	<option value="240">4 Minutes</option>
	<option value="300">5 Minutes</option>
	</select>
	</td>
</tr>
<tr>
	<th width="10%" align="right" nowrap>Delay In Between Round Groups</th>
	<td>
	<select name"delay_group">
	<option value="0">No Delay</option>
	<option value="15">15 Seconds</option>
	<option value="30">30 Seconds</option>
	<option value="45">45 Seconds</option>
	<option value="60">1 Minute</option>
	<option value="90">1 Minute 30 Seconds</option>
	<option value="120">2 Minutes</option>
	<option value="180">3 Minutes</option>
	<option value="240">4 Minutes</option>
	<option value="300">5 Minutes</option>
	</select>
	</td>
</tr>
<tr>
	<th width="10%" align="right" nowrap>Type of Playlist</th>
	<td>
	<select name"playlist_type">
	<option value="itunes">Apple iTunes Playlist</option>
	<option value="mp3">Generic MP3 Playlist</option>
	</select>
	</td>
</tr>
<tr>
	<td colspan="2" style="padding-top:10px;">
		<input type="button" value=" Generate Audio Playlist " onClick="document.audio.submit();" class="block-button">
	</td>
</tr>
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="print_pilot_tasks" method="POST" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_blank_task">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="use_print_header" value="1">
</form>

</div>
</div>
</div>

