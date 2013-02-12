Welcome to F3X Timing {$user.user_first_name} !<br>
<br>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<td colspan="6" align="left">Your Recent Events</td>
</tr>
<tr>
	<td class="table-data-heading-left" width="10%" nowrap>Event Date</td>
	<td class="table-data-heading-left">Event Title</td>
	<td class="table-data-heading-left">Location</td>
</tr>
{foreach $events as $event}
<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
	<td>{$record.host|escape}</td>
	<td>{$record.type|escape}</td>
	<td>{$record.pri|escape}</td>
</tr>
{/foreach}
</table>