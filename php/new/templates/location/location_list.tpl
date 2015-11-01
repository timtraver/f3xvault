{extends file='layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Browse F3X Locations</h2>
	</div>
	<div class="panel-body">
	<p>

	<div style="float:left;">
		<form name="search_form" method="POST">
		<input type="hidden" name="action" value="location">
		<input type="hidden" name="function" value="location_list">
		<table class="filter" cellpadding="2" cellspacing="2">
			<tr>
				<th colspan="2">Filter Results</th>
			</tr>
			<tr>
				<td align="right">Country</td>
				<td nowrap>
					<select name="country_id" onChange="document.search_form.state_id.value=0;search_form.submit();">
					<option value="0">Choose Country to Narrow Search</option>
					{foreach $countries as $country}
						<option value="{$country.country_id}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
					{/foreach}
					</select>
		
				</td>
			</tr>
			<tr>
				<td align="right">State</td>
				<td nowrap>
					<select name="state_id" onChange="search_form.submit();">
					<option value="0">Choose State to Narrow Search</option>
					{foreach $states as $state}
						<option value="{$state.state_id}" {if $state_id==$state.state_id}SELECTED{/if}>{$state.state_name}</option>
					{/foreach}
					</select>
				</td>
			</tr>
			<tr>
				<td align="right">Name</td>
				<td nowrap>
					<input type="text" name="search" size="20" value="{$search|escape}">
					<input type="submit" value=" Search " class="btn btn-primary btn-rounded">
					<input type="submit" value=" Reset " class="btn btn-primary btn-rounded" onClick="document.search_form.country_id.value=0;document.search_form.state_id.value=0;document.search_form.search_field.value='location_name';document.search_form.search_operator.value='contains';document.search_form.search.value='';search_form.submit();">
				</td>
			</tr>
		</table>
		</form>
	</div>
	<div style="float:right;overflow:hidden;">
		<input type="button" value=" Create New Location Entry " onclick="newlocation.submit();" class="btn btn-primary btn-rounded">
	</div>
	<br style="clear:left;">
<br>
<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
<tr class="table-row-heading-left" style="background-color: lightgray;">
	<th colspan="1" style="text-align: left;" nowrap>Locations (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
	<th colspan="6" nowrap>
		{include file="paging.tpl"}
	</th>
</tr>
<tbody>
	<tr>
		<th rowspan="2" valign="bottom" style="text-align: left;">Location Name</th>
		<th rowspan="2" style="text-align: left;">City</th>
		<th rowspan="2" style="text-align: left;">State</th>
		<th rowspan="2" style="text-align: left;">Country</th>
		<th rowspan="2" style="text-align: center;">Map Location</th>
		<th style="text-align: center;" colspan="2">Records</th>
	</tr>
	<tr>
		<th style="text-align: center;">Speed</th>
		<th style="text-align: center;">Distance</th>
	</tr>
	{foreach $locations as $location}
	<tr>
		<td>
			<a href="?action=location&function=location_view&location_id={$location.location_id|escape}" class="btn-link">{$location.location_name|escape}</a>
		</td>
		<td>{$location.location_city|escape}</td>
		<td>{if $location.state_name && $location.country_code=="US"}<img src="/images/flags/states/16/{$location.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if} {$location.state_name|escape}</td>
		<td>{if $location.country_code}<img src="/images/flags/countries-iso/shiny/16/{$location.country_code|escape}.png" style="vertical-align: middle;">{/if} {$location.country_name|escape}</td>
		<td align="center">{if $location.location_coordinates!=''}<a class="fancybox-map" href="http://maps.google.com/maps?q={$location.location_coordinates|escape:'url'}+({$location.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}</td>
		<td align="center">
			{if $location.location_record_speed!=0}
				<a href="?action=event&function=event_view&event_id={$location.pilot_speed_event_id}" class="tooltip_score_left">
				{$location.location_record_speed|escape}s
				<span>
					{if $location.pilot_speed_country_code}<img src="/images/flags/countries-iso/shiny/32/{$location.pilot_speed_country_code|escape}.png" class="inline_flag" title="{$location.pilot_speed_country_code}">{/if}
					<strong>{$location.pilot_speed_first_name} {$location.pilot_speed_last_name}</strong><br>
					{if $location.pilot_speed_event_type_code=="f3f"}F3F{else}F3B{/if} Speed Record<br>
					{$location.pilot_speed_event_name}<br>
					{$location.pilot_speed_event_start_date|date_format}
				</span>
				</a>
			{/if}
		</td>
		<td align="center">
			{if $location.location_record_distance!=0}
				<a href="?action=event&function=event_view&event_id={$location.pilot_laps_event_id}" class="tooltip_score_left">
				{$location.location_record_distance|escape} laps
				<span>
					{if $location.pilot_laps_country_code}<img src="/images/flags/countries-iso/shiny/32/{$location.pilot_laps_country_code|escape}.png" class="inline_flag" title="{$location.pilot_laps_country_code}">{/if}
					<strong>{$location.pilot_laps_first_name} {$location.pilot_laps_last_name}</strong><br>
					{if $location.pilot_distance_event_type_code=="f3f"}F3F{else}F3B{/if} Distance Record<br>
					{$location.pilot_laps_event_name}<br>
					{$location.pilot_laps_event_start_date|date_format}
				</span>
				</a>
			{/if}
		</td>
	</tr>
	{/foreach}
</tbody>
<tfoot>
	<tr style="background-color: lightgray;">
		<td colspan="7">
			{include file="paging.tpl"}
		</td>
	</tr>
</tfoot>
</table>

<center>
	<input type="button" value=" Create New Location Entry " onclick="newlocation.submit();" class="btn btn-primary btn-rounded">
</center>


<form name="newlocation" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
</form>


	</p>
	</div>
</div>

{/block}
