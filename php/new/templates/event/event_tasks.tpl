{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Event Tasks for {$event->info.event_name|escape}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">
		<h3 class="post-title entry-title">F3K Round Tasks</h3>
		
		<form name="main" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_tasks_save">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="add_round" value="0">
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
			<th width="10%" nowrap style="text-align: center;">Round Number</th>
			<th width="20%" nowrap>Round Type</th>
			<th width="65%" nowrap>Task</th>
			<th width="5%" nowrap>Action</th>
		</tr>
		{if $event->tasks}
		{foreach $event->tasks as $t}
			<tr>
				<th width="20%" nowrap style="text-align: center;">
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
		{else}
			<tr>
				<td colspan="4">There are currently no tasks set for this event.</td>
			</tr>
		{/if}
		<tr>
			<td colspan="4" style="text-align: right;padding-top:10px;">
				<input type="button" value=" Add Task Round " onClick="document.main.add_round.value=1;document.main.submit();" class="btn btn-primary btn-rounded">
				<input type="button" value=" Save Task Rounds " onClick="document.main.submit();" class="btn btn-primary btn-rounded">
				
				<input type="button" value=" Print Blank Pilot Sheets " onClick="document.print_pilot_blank_tasks.submit();" class="btn btn-primary btn-rounded">
				<input type="button" value=" Print Pilot Sheets " onClick="document.print_pilot_tasks.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>
		</form>
		
		<br>
		<h3 class="post-title entry-title">Audio Playlist Generation <font color="red">(Not Yet Implemented)</font></h3>
		<form name="audio" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_tasks_audio">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		We can generate a contest play list to run the task announcements. Select from the following options.<br>
		<br>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
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
			<td colspan="2" style="text-align: center;padding-top:10px;">
				<input type="button" value=" Generate Audio Playlist " onClick="document.audio.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>
		</form>
		
		<form name="goback" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_view">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		</form>
		<form name="print_pilot_blank_tasks" method="POST" target="_blank">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_print_blank_task">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="use_print_header" value="1">
		<input type="hidden" name="blank" value="1">
		</form>
		<form name="print_pilot_tasks" method="POST" target="_blank">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_print_blank_task">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="use_print_header" value="1">
		<input type="hidden" name="blank" value="0">
		</form>

	</div>
</div>
{/block}
