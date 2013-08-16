
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                	
	<br>
	<h2 style="color:red;">Under Construction...</h2>
<h1 class="post-title entry-title">Draw Stats
		<input type="button" value=" Back To Event Draws " onClick="goback.submit();" class="block-button">
</h1>
	
<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw_save">
<input type="hidden" name="event_draw_id" value="{$event_draw_id}">
<input type="hidden" name="event_id" value="{$event_id}">
<input type="hidden" name="flight_type_id" value="{$ft.flight_type_id}">
<input type="hidden" name="event_draw_changed" value="0">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%" nowrap>Draw Flight Type</th>
	<td>
		{if $event->info.event_type_code=='f3k'}
			F3K
		{else}
			{$ft.flight_type_name}
		{/if}
	</td>
</tr>
<tr>
	<th width="10%" nowrap>Round Range</th>
	<td>
		{$draw.event_draw_round_from} to {$draw.event_draw_round_to}
	</td>
</tr>
<tr>
	<th nowrap>Team Protection</th>
	<td>
		{if $draw.event_draw_team_protection==1} ON{else}OFF{/if}
	</td>
</tr>
<tr>
	<th nowrap valign="top">Flight Groups</th>
	<td>
		There are currently <b>{$event->pilots|count}</b> Pilots in this event{if $event->teams|count > 0} on {$event->teams|count} teams{/if}.<br>
		With {$draw.event_draw_number_groups} Chosen
	</td>
</tr>
<tr>
	<th nowrap valign="top">Graph</th>
	<td>
	
	
	
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

