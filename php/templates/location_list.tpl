<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Browse F3X Location Database</h1>
		<div class="entry-content clearfix">

<form name="searchform" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_list">
<table width="80%">
<tr>
	<th>Filter By Site Discipline</th>
	<td colspan="3">
	<select name="discipline_id" onChange="searchform.submit();">
	{foreach $disciplines as $d}
		<option value="{$d.discipline_id}" {if $discipline_id==$d.discipline_id}SELECTED{/if}>{$d.discipline_description|escape}</option>
	{/foreach}
	</select>
	</td>
</tr>
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
	<td valign="center" colspan="3">
		<select name="search_field">
		<option value="location_name" {if $search_field=="location_name"}SELECTED{/if}>Location Name</option>
		<option value="location_city" {if $search_field=="location_city"}SELECTED{/if}>City</option>
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
	<th colspan="6" style="text-align: left;">Locations (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $startrecord>1}[<a href="?action=location&function=location_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=location&function=location_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=location&function=location_list&&perpage=25">25</a>]
                [<a href="?action=location&function=location_list&&perpage=50">50</a>]
                [<a href="?action=location&function=location_list&&perpage=100">100</a>]
                [<a href="?action=location&function=location_list&page=1">First Page</a>]
                [<a href="?action=location&function=location_list&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<th style="text-align: left;">Location Name</th>
	<th style="text-align: left;">City</th>
	<th style="text-align: left;">State</th>
	<th style="text-align: left;">Country</th>
	<th style="text-align: center;">Map Location</th>
	<th style="text-align: left;">Action</th>
</tr>
{foreach $locations as $location}
<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
	<td>
		<a href="?action=location&function=location_view&location_id={$location.location_id|escape}">{$location.location_name|escape}</a>
	</td>
	<td>{$location.location_city|escape}</td>
	<td>{$location.state_name|escape}</td>
	<td>{$location.country_name|escape}</td>
	<td align="center">{if $location.location_coordinates!=''}<a class="fancybox-map" href="http://maps.google.com/maps?q={$location.location_coordinates|escape:'url'}+({$location.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}</td>
	<td><a href="?action=location&function=location_edit&location_id={$location.location_id|escape}" title="Edit This Location"><img src="images/icon_edit_small.gif" width="20"></a>
	</td>
</tr>
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $startrecord>1}[<a href="?action=location&function=location_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=location&function=location_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=location&function=location_list&perpage=25">25</a>]
                [<a href="?action=location&function=location_list&perpage=50">50</a>]
                [<a href="?action=location&function=location_list&perpage=100">100</a>]
                [<a href="?action=location&function=location_list&page=1">First Page</a>]
                [<a href="?action=location&function=location_list&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<td colspan="6" align="center">
		<input type="button" value=" Create New Location Entry " onclick="newlocation.submit();" class="block-button">
	</td>
</tr>
</table>

<form name="newlocation" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
</form>


</div>
</div>
</div>

