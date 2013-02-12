<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Event Creation</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Create New Event</h1>
<form name="getlocations" method="POST">
<input type="hidden" name="action" value="{$action|escape}">
<input type="hidden" name="function" value="event_new">

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Event Country</th>
	<td>
	<select name="country_id" onChange="document.getlocations.state_id.value=0;getlocations.submit();">
	<option value="0">Choose Country to Narrow Search</option>
	{foreach $countries as $country}
		<option value="{$country.country_id}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Event State</th>
	<td>
	<select name="state_id" onChange="getlocations.submit();">
	<option value="0">Choose State to Narrow Search</option>
	{foreach $states as $state}
		<option value="{$state.state_id}" {if $state_id==$state.state_id}SELECTED{/if}>{$state.state_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
</form>
<form name="main" method="POST">
<input type="hidden" name="action" value="{$action|escape}">
<input type="hidden" name="function" value="event_save_new">
<tr>
	<th>Event Location</th>
	<td>
	<select name="location_id">
	{foreach $locations as $l}
		<option value="{$l.location_id}" {if $location_id==$l.location_id}SELECTED{/if}>{$l.location_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Event Name</th>
	<td>
		<input type="text" size="60" name="event_name" value="">
	</td>
</tr>
<tr>
	<th>Event Dates</th>
	<td>
	{html_select_date prefix="event_start_date" start_year="-1" end_year="+1" day_format="%02d"} to 
	{html_select_date prefix="event_end_date" start_year="-1" end_year="+1" day_format="%02d"}
	</td>
</tr>
<tr>
	<th>Event Type</th>
	<td>
	<select name="event_type_id">
	{foreach $event_types as $t}
		<option value="{$t.event_type_id}">{$t.event_type_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value="Cancel Create" onClick="goback.submit();" class="block-button">
		<input type="submit" value="Create This Event" class="block-button">
	</th>
</tr>
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>

</div>
</div>
</div>

