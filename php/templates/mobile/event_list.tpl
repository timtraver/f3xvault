<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Search F3X Event List</h1>
		<div class="entry-content clearfix">

<form name="searchform" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
<input type="hidden" name="discipline_id" value="{$discipline_id}">
<table>
<tr>
	<th>Filter By Country</th>
	<td align="left" style="text-align: left;">
		<select name="country_id" onChange="document.searchform.state_id.value=0;searchform.submit();">
		<option value="0">Choose Country to Narrow Search</option>
		{foreach $countries as $country}
			<option value="{$country.country_id}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name|escape}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th>Filter By State</th>
	<td align="left" style="text-align: left;">
		<select name="state_id" onChange="searchform.submit();">
		<option value="0">Choose State to Narrow Search</option>
		{foreach $states as $state}
			<option value="{$state.state_id}" {if $state_id==$state.state_id}SELECTED{/if}>{$state.state_name|escape}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th nowrap>	
		Search on : 
	</th>
	<td align="left" valign="center" colspan="3" nowrap style="text-align: left;">
			<select name="search_field" style="display:inline;">
				<option value="event_name" {if $search_field=="event_name"}SELECTED{/if}>Event Name</option>
				<option value="event_type_name" {if $search_field=="event_type_name"}SELECTED{/if}>Event Type</option>
				<option value="event_start_date" {if $search_field=="event_start_date"}SELECTED{/if}>Start Date</option>
			</select>
			<select name="search_operator" style="display:inline;">
				<option value="contains" {if $search_operator=="contains"}SELECTED{/if}>Contains</option>
				<option value="exactly" {if $search_operator=="exactly"}SELECTED{/if}>Is Exactly</option>
			</select>
			<input type="text" name="search" size="10" value="{$search|escape}" style="display:inline;">
			<br>
			<input type="submit" value=" Search " class="block-button">
			<input type="submit" value=" Reset " class="block-button" onClick="document.searchform.country_id.value=0;document.searchform.state_id.value=0;document.searchform.search_field.value='location_name';document.searchform.search_operator.value='contains';document.searchform.search.value='';searchform.submit();">
	</td>
</tr>
</table>
</form>
<br>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="7" style="text-align: left;">Events (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
</tr>
<tr>
	<th style="text-align: center;">Date</th>
	<th style="text-align: center;">Event Name</th>
	<th style="text-align: left;">Type</th>
	<th style="text-align: left;">Location</th>
	<th style="text-align: center;">Map</th>
</tr>
{foreach $events as $event}
<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
	<td>{$event.event_start_date|date_format:"%m/%d/%y"}</td>
	<td>
		<a href="?action=event&function=event_view&event_id={$event.event_id|escape}">{$event.event_name|escape}</a>
	</td>
	<td>{$event.event_type_code|upper}</td>
	<td>{$event.location_name|escape}, {$event.state_code|escape} - {$event.country_code|escape}</td>
	<td align="center">
		{if $event.location_coordinates!=''}<a class="fancybox-map" href="https://maps.google.com/maps?q={$event.location_coordinates|escape:'url'}+({$event.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}
		&nbsp;&nbsp;
		&nbsp;&nbsp;
		&nbsp;&nbsp;
	</td>
</tr>
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="2">
                {if $startrecord>1}[<a href="?action=event&function=event_list&page={$prevpage|escape}" style="display:inline;"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=event&function=event_list&page={$nextpage|escape}" style="display:inline;">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">
                [<a href="?action=event&function=event_list&page=1" style="display:inline;">First Page</a>]
                [<a href="?action=event&function=event_list&page={$totalpages|escape}" style="display:inline;">Last Page</a>]
        </td>
</tr>
<tr>
	<td colspan="7" align="center">
		<br>
		<input type="button" value=" Create New Event " onclick="{if $user.user_id!=0}newevent.submit();{else}alert('You must be registered and logged in to create a new event.');{/if}" class="block-button">
	</td>
</tr>
</table>

<form name="newevent" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="0">
</form>


</div>
</div>
</div>

