<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Event List</h1>
		<div class="entry-content clearfix">

<form name="searchform" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
<table>
<tr>
	<th>Filter By Country</th>
	<td>
	<select name="country_id" onChange="document.searchform.state_id.value=0;searchform.submit();">
	<option value="0">Choose Country to Narrow Search</option>
	{foreach $countries as $country}
		<option value="{$country.country_id}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Filter By State</th>
	<td>
	<select name="state_id" onChange="searchform.submit();">
	<option value="0">Choose State to Narrow Search</option>
	{foreach $states as $state}
		<option value="{$state.state_id}" {if $state_id==$state.state_id}SELECTED{/if}>{$state.state_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th nowrap>	
		And Search on Field : 
	</th>
	<td valign="center">
		<select name="search_field">
		<option value="event_name" {if $search_field=="event_name"}SELECTED{/if}>Event Name</option>
		<option value="event_start_date" {if $search_field=="event_start_date"}SELECTED{/if}>Start Date</option>
		</select>
		<select name="search_operator">
		<option value="contains" {if $search_operator=="contains"}SELECTED{/if}>Contains</option>
		<option value="exactly" {if $search_operator=="exactly"}SELECTED{/if}>Is Exactly</option>
		</select>
		<input type="text" name="search" size="30" value="{$search|escape}">
		<input type="submit" value=" Search " class="block-button">
		<input type="submit" value=" Reset " class="block-button" onClick="document.searchform.country_id.value=0;document.searchform.state_id.value=0;document.searchform.search_field.value='location_name';document.searchform.search_operator.value='contains';document.searchform.search.value='';searchform.submit();">
		</form>
	</td>
</tr>
</table>
</form>
<br>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="7" style="text-align: left;">Events (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $startrecord>1}[<a href="?action=event&function=event_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=event&function=event_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="4">PerPage
                [<a href="?action=event&function=event_list&&perpage=25">25</a>]
                [<a href="?action=event&function=event_list&&perpage=50">50</a>]
                [<a href="?action=event&function=event_list&&perpage=100">100</a>]
                [<a href="?action=event&function=event_list&page=1">First Page</a>]
                [<a href="?action=event&function=event_list&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<th style="text-align: left;">Event Date</th>
	<th style="text-align: left;">Event Name</th>
	<th style="text-align: left;">Event Type</th>
	<th style="text-align: left;">Event Location</th>
	<th style="text-align: center;">Map</th>
	<th style="text-align: left;"></th>
</tr>
{foreach $events as $event}
<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
	<td>{$event.event_start_date|date_format:"%Y-%m-%d"}</td>
	<td>
		<a href="?action=event&function=event_view&event_id={$event.event_id|escape}">{$event.event_name|escape}</a>
	</td>
	<td>{$event.event_type_name|escape}</td>
	<td>{$event.location_name|escape}, {$event.state_code|escape} - {$event.country_code|escape}</td>
	<td align="center">{if $event.location_coordinates!=''}<a class="fancybox-map" href="https://maps.google.com/maps?q={$event.location_coordinates|escape:'url'}+({$event.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/icons/world.png"></a>{/if}</td>
	<td><a href="?action=event&function=event_view&event_id={$event.event_id|escape}" title="Edit This Event"><img src="images/icon_edit_small.gif" width="20"></a>
	</td>
</tr>
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $startrecord>1}[<a href="?action=event&function=event_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=event&function=event_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="4">PerPage
                [<a href="?action=event&function=event_list&perpage=25">25</a>]
                [<a href="?action=event&function=event_list&perpage=50">50</a>]
                [<a href="?action=event&function=event_list&perpage=100">100</a>]
                [<a href="?action=event&function=event_list&page=1">First Page</a>]
                [<a href="?action=event&function=event_list&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<td colspan="7" align="center">
		<br>
		<input type="button" value=" Create New Event " onclick="newevent.submit();" class="block-button">
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

