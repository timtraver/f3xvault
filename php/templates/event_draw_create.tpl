<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                	
	<br>
	<h2 style="color:red;">Under Construction...</h2>
<h1 class="post-title entry-title">Draw Create
		<input type="button" value=" Back To Event Draws " onClick="goback.submit();" class="block-button">
</h1>
	
<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw_save">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="flight_type_id" value="{$flight_type_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%" nowrap>Draw Flight Type</th>
	<td>
		{$ft.flight_type_name}
	</td>
</tr>
<tr>
	<th width="10%" nowrap>Round Start</th>
	<td>
		<input type="text" name="round_from" size="2">
	</td>
</tr>
<tr>
	<th width="10%" nowrap>Round Finish</th>
	<td>
		<input type="text" name="round_to" size="2">
	</td>
</tr>
<tr>
	<th nowrap>Draw Type</th>
	<td>
	<select name="draw_type">
	{if $ft.flight_type_group==1}
		<option value="group">Standard Modified Random Group Draw</option>
	{else}
		<option value="order">Random Order Draw Every Round</option>
		<option value="order">Random Order Initial with Stagger</option>
	{/if}
	</select>
	</td>
</tr>
{if $ft.flight_type_group==1}
<tr>
	<th nowrap>Team Protection</th>
	<td>
		<input type="checkbox" name="team_protection">
	</td>
</tr>
<tr>
	<th nowrap>Desired Number of Flight Groups</th>
	<td>
		<input type="text" name="flight_groups" size="2">
	</td>
</tr>
{/if}
<tr>
	<td colspan="2">
		<input type="submit" value=" Create {$ft.flight_type_name} Draw " class="block-button">
	</td>
</tr>
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw">
<input type="hidden" name="event_id" value="{$event_id}">
</form>

</div>
</div>
</div>

