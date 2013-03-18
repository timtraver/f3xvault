<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                

<h1 class="post-title entry-title">Register with RC Vault</h1>
<form method="POST">
<input type="hidden" name="action" value="register">
<input type="hidden" name="function" value="save_registration">
<input type="hidden" name="from_show_pilots" value="1">
<br>
It looks like we may have you in the database already as a pilot from an event!<br>
<br>
Look down through this list and check the box that could be you.<br>
<br>
<table cellpadding="2" cellspacing="2" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="4">Possible Pilots</th>
</tr>
<tr>
	<th class="table-data-heading-left" nowrap>&nbsp;</th>
	<th class="table-data-heading-left" nowrap>Pilot Last Name</th>
	<th class="table-data-heading-left" nowrap>Pilot First Name</th>
	<th class="table-data-heading-left" nowrap>Last Event</th>
<tr>
{foreach $pilots as $pilot}
<tr>
	<td class="table-data-heading-left" nowrap>
		<input type="radio" name="pilot_id" value="{$pilot.pilot_id}">
	</td>
	<td>{$pilot.pilot_last_name}</td>
	<td>{$pilot.pilot_first_name}</td>
	<td>{$pilot.eventstring}</td>
</tr>
{/foreach}
<tr>
	<td class="table-data-heading-left" nowrap>
		<input type="radio" name="pilot_id" value="0" CHECKED>
	</td>
	<td colspan="3">I'm sorry, but none of these pilots are me.</td>
</tr>
<tr>
	<td colspan="4" class="table-data-heading-center">
	<input type="submit" value="Register Me" class="button">
	</td>
</tr>
</table>
<br><br><br>
<input type="hidden" name="user_name" value="{$user.user_name}">
<input type="hidden" name="user_first_name" value="{$user.user_first_name}">
<input type="hidden" name="user_last_name" value="{$user.user_last_name}">
<input type="hidden" name="user_email" value="{$user.user_email}">
<input type="hidden" name="user_pass" value="{$user.user_pass}">
<input type="hidden" name="user_pass2" value="{$user.user_pass2}">
</form>


	</div>
</div>

