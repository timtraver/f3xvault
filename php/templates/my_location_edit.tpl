<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">My Pilot Profile</h1>
		<div class="entry-content clearfix">

<form name="searchform" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_location_edit">

<h1 class="post-title entry-title">Search For A Flying Location To Add
<input type="button" value=" + Create New Location " class="block-button" onClick="create_new_location.submit();">
</h1>
<table width="70%" cellpadding="1" cellspacing="1">
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
	<td colspan="3" valign="center">
		<select name="search_field">
		<option value="location_name" {if $search_field=="location_name"}SELECTED{/if}>Location Name</option>
		<option value="location_city" {if $search_field=="location_city"}SELECTED{/if}>City</option>
		</select>
		<select name="search_operator">
		<option value="contains" {if $search_operator=="contains"}SELECTED{/if}>Contains</option>
		<option value="exactly" {if $search_operator=="exactly"}SELECTED{/if}>Is Exactly</option>
		</select>
		
		<input type="text" name="search" size="30" value="{$search|escape}">
		<input type="submit" value=" Search " class="block-button" style="float: right;">
		<input type="submit" value=" Reset " class="block-button" style="clear:both;" onClick="document.searchform.country_id.value=0;document.searchform.state_id.value=0;document.searchform.search_field.value='location_name';document.searchform.search_operator.value='contains';document.searchform.search.value='';searchform.submit();">
	</td>
</tr>
</table>
</form>

<form name="addlocations" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_location_add">

<h1 class="post-title entry-title">Results</h1>

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="6" style="text-align: left;">Locations (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $startrecord>1}[<a href="?action=my&function=my_location_edit&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=my&function=my_location_edit&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=my&function=my_location_edit&&perpage=25">25</a>]
                [<a href="?action=my&function=my_location_edit&&perpage=50">50</a>]
                [<a href="?action=my&function=my_location_edit&&perpage=100">100</a>]
                [<a href="?action=my&function=my_location_edit&page=1">First Page</a>]
                [<a href="?action=my&function=my_location_edit&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<th style="text-align: left;">Add</th>
	<th style="text-align: left;">Location Name</th>
	<th style="text-align: left;">City</th>
	<th style="text-align: left;">State</th>
	<th style="text-align: left;">Country</th>
	<th style="text-align: center;">Map Location</th>
</tr>
{foreach $locations as $location}
<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
	<td>
		<input type="checkbox" name="location_{$location.location_id}">
	</td>
	<td>{$location.location_name|escape}</td>
	<td>{$location.location_city|escape}</td>
	<td>{$location.state_name|escape}</td>
	<td>{$location.country_name|escape}</td>
	<td align="center">{if $location.location_coordinates!=''}<a class="fancybox-map" href="https://maps.google.com/maps?q={$location.location_coordinates|escape:'url'}+({$location.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}</td>
</tr>
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $startrecord>1}[<a href="?action=my&function=my_location_edit&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=my&function=my_location_edit&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=my&function=my_location_edit&perpage=25">25</a>]
                [<a href="?action=my&function=my_location_edit&perpage=50">50</a>]
                [<a href="?action=my&function=my_location_edit&perpage=100">100</a>]
                [<a href="?action=my&function=my_location_edit&page=1">First Page</a>]
                [<a href="?action=my&function=my_location_edit&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
</table>
<br>
<center>
<input type="submit" value=" Add Selected Locations to My Experience " class="block-button">
<input type="button" value=" Back To My Pilot Profile " class="block-button" onclick="goback.submit();">
</center>
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="my">
</form>

<form name="create_new_location" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
<input type="hidden" name="location_name" value="">
<input type="hidden" name="from_action" value="my">
<input type="hidden" name="from_function" value="my_location_edit">
<input type="hidden" name="from_pilot_location_id" value="">
</form>


</div>
</div>
</div>
