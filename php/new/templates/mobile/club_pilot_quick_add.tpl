
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Club Pilot Quick Add</h1>
		<div class="entry-content clearfix">

<form name="main" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_save_pilot_quick_add">
<input type="hidden" name="club_id" value="{$club.club_id}">
<table width="100%" cellpadding="2" cellspacing="2" class="tableborder">
<tr>
	<th colspan="3">Pilot Information</th>
</tr>
<tr>
	<th nowrap>Pilot First Name</th>
	<td colspan="2">
		<input type="text" name="pilot_first_name" size="40" value="{$pilot_first_name|escape}">
	</td>
</tr>
<tr>
	<th nowrap>Pilot Last Name</th>
	<td colspan="2">
		<input type="text" name="pilot_last_name" size="40" value="{$pilot_last_name|escape}">
	</td>
</tr>
<tr>
	<th nowrap>Pilot City</th>
	<td colspan="2">
		<input type="text" name="pilot_city" size="40" value="">
	</td>
</tr>
<tr>
	<th nowrap>Pilot State</th>
	<td colspan="2">
		<select name="state_id">
		{foreach $states as $state}
			<option value="{$state.state_id}">{$state.state_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th nowrap>Pilot Country</th>
	<td colspan="2">
		<select name="country_id">
		{foreach $countries as $country}
			<option value="{$country.country_id}">{$country.country_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th nowrap>Pilot AMA #</th>
	<td colspan="2">
		<input type="text" name="pilot_ama" size="15" value="">
	</td>
</tr>
<tr>
	<th nowrap>Pilot FAI #</th>
	<td colspan="2">
		<input type="text" name="pilot_fai" size="15" value="">
	</td>
</tr>
<tr>
	<th nowrap>Email Address</th>
	<td colspan="2">
		<input type="text" name="pilot_email" size="40" value="">
	</td>
</tr>
<tr>
	<td valign="center" colspan="3">
	<br>
	<input type="button" value=" Cancel " class="button" onClick="goback.submit();">
	<input type="submit" value=" Add New Pilot To This Club " class="button">
	</td>
</tr>
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_view">
<input type="hidden" name="club_id" value="{$club.club_id}">
</form>

</div>
</div>
</div>
