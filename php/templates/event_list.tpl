<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Browse F3X Event List</h1>
		<div class="entry-content clearfix">

<form name="searchform" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
<table width="80%">
<tr>
	<th>Filter By Event Discipline</th>
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
		<option value="{$country.country_id}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name|escape}</option>
	{/foreach}
	</select>
	</td>
	<th>Filter By State</th>
	<td>
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
		And Search on Field : 
	</th>
	<td valign="center" colspan="3">
		<select name="search_field">
		<option value="event_name" {if $search_field=="event_name"}SELECTED{/if}>Event Name</option>
		<option value="event_type_name" {if $search_field=="event_type_name"}SELECTED{/if}>Event Type</option>
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
<div style="border-style:solid;border-width:1px;width:110px;background:lightblue;float:left;text-align:center;">Future Event</div>
<div style="border-style:solid;border-width:1px;width:110px;background:lightgreen;float:left;text-align:center;">Current Event</div>
<div style="border-style:solid;border-width:1px;width:110px;background:#C8F7C8;float:left;text-align:center;">Recent Event</div>
<div style="border-style:solid;border-width:1px;width:110px;background:white;float:left;text-align:center;">Completed Event</div>

<br>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="6" style="text-align: left;">Events (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $startrecord>1}[<a href="?action=event&function=event_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=event&function=event_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
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
	<th style="text-align: center;">Status</th>
</tr>
{foreach $events as $event}
<tr style="background:{if $event.time_status==2}lightblue{elseif $event.time_status==1}lightgreen{elseif $event.time_status==0}#C8F7C8{else}white{/if};">
	<td nowrap>{$event.event_start_date|date_format:"%Y-%m-%d"}</td>
	<td>
		<a href="?action=event&function=event_view&event_id={$event.event_id|escape}">{$event.event_name|escape}</a>
	</td>
	<td nowrap>{$event.event_type_name|escape}</td>
	<td nowrap>{if $event.country_code}<img src="/images/flags/countries-iso/shiny/16/{$event.country_code|escape}.png" style="vertical-align: middle;" title="{$event.country_name}">{/if} 
		{if $event.state_name && $event.country_id==226}<img src="/images/flags/states/16/{$event.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;" title="{$event.state_name}">{/if} 
		{$event.location_name|escape}
	</td>
	<td align="center">{if $event.location_coordinates!=''}<a class="fancybox-map" href="https://maps.google.com/maps?q={$event.location_coordinates|escape:'url'}+({$event.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}</td>
	<td nowrap>
		{if $event.event_reg_flag==1 && ($event.time_status!=-1 && $event.time_status!=0)}
			{if $event.event_reg_status==0 || 
				($event->pilots|count>=$event.event_reg_max && $event.event_reg_max!=0) ||
				$event_reg_passed==1
			}
				<font color="red"><b>Registration Closed</b></font>
			{else}
				<font color="green"><b>Registration Open</b></font>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="?action=event&function=event_register&event_id={$event.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if}>
				Register Me Now!
				</a>
			{/if}
		{else}
			{if $event.time_status==2}
			Scheduled
			{elseif $event.time_status==1}
			In Progress
			{else}
			Completed
			{/if}
		{/if}
	</td>
</tr>
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $startrecord>1}[<a href="?action=event&function=event_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=event&function=event_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=event&function=event_list&perpage=25">25</a>]
                [<a href="?action=event&function=event_list&perpage=50">50</a>]
                [<a href="?action=event&function=event_list&perpage=100">100</a>]
                [<a href="?action=event&function=event_list&page=1">First Page</a>]
                [<a href="?action=event&function=event_list&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<td colspan="6" align="center">
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

