<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Event Settings - {$event.event_name}</h1>
		<div class="entry-content clearfix">
<form name="main" method="POST">
<input type="hidden" name="action" value="{$action|escape}">
<input type="hidden" name="function" value="event_save">
<input type="hidden" name="event_id" value="{$event.event_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Event Dates</th>
	<td>
	{$event.event_start_date|date_format:"%Y-%m-%d"} to {$event.event_end_date|date_format:"%Y-%m-%d"}
	</td>
</tr>



<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value=" Cancel Changes " onClick="goback.submit();" class="block-button">
		<input type="submit" value=" Save Changes To This Event " class="block-button">
	</th>
</tr>
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>

		</div>
		<br>
		<h1 class="post-title entry-title">Event Pilots</h1>



</div>
</div>

