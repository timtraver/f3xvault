<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Pilot Quick Add</h1>
		<div class="entry-content clearfix">

<form method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="save_pilot_quick_add">
<input type="hidden" name="event_id" value="{$event.event_id}">
<table width="50%" cellpadding="2" cellspacing="2" class="tableborder">
<tr class="table-row-heading-left">
	<td colspan="3">Pilot Information</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Pilot First Name</td>
	<td colspan="2">
		<input type="text" name="pilot_first_name" size="40" value="{$pilot_first_name}">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Pilot Last Name</td>
	<td colspan="2">
		<input type="text" name="pilot_last_name" size="40" value="{$pilot_last_name}">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Pilot City</td>
	<td colspan="2">
		<input type="text" name="pilot_city" size="40" value="">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Pilot State</td>
	<td colspan="2">
		<select name="state_id">
		{foreach $states as $state}
			<option value="{$state.state_id}">{$state.state_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Pilot Country</td>
	<td colspan="2">
		<select name="country_id">
		{foreach $countries as $country}
			<option value="{$country.country_id}">{$country.country_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Pilot AMA #</td>
	<td colspan="2">
		<input type="text" name="pilot_ama" size="15" value="">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Pilot FIA #</td>
	<td colspan="2">
		<input type="text" name="pilot_fia" size="15" value="">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Email Address</td>
	<td colspan="2">
		<input type="text" name="pilot_email" size="40" value="">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Pilot Class</td>
	<td colspan="2">
		<select name="class_id">
		{foreach $classes as $c}
			<option value="{$c.class_id}">{$c.class_description}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<td valign="center" colspan="3" class="table-data-heading-center">
	<br>
	<input type="submit" value=" Add New Pilot To This Event " class="button">
	</td>
</tr>
</table>
</form>


</div>
</div>
</div>
