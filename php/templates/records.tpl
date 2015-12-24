{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:600px;">
	<div class="panel-heading">
		<h2 class="heading">F3F and F3B Records</h2>
	</div>
	<div class="panel-body">



		<form name="searchform" method="POST">
		<input type="hidden" name="action" value="records">
		<input type="hidden" name="function" value="records_list">
		
		<table cellpadding="1" cellspacing="1" class="table table-condensed">
		<tr>
			<th width="10%" nowrap>Filter Records By Country</th>
			<td>
			<select name="country_id" onChange="searchform.submit();">
			<option value="0">Choose Country to Narrow Search (ALL)</option>
			{foreach $countries as $country}
				<option value="{$country.country_id}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
			{/foreach}
			</select>
			</td>
		</tr>
		</table>
		</form>
		
		{if $page==0}
			{$page=1}
		{/if}
		<h3 class="post-title entry-title">Top F3F Speeds ({$start_record} - {$end_record})</h3>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr>
			<th style="text-align: left;"></th>
			<th style="text-align: left;">Event Date</th>
			<th style="text-align: left;">Speed</th>
			<th style="text-align: left;">Pilot</th>
			<th style="text-align: left;">Plane</th>
			<th style="text-align: left;">Event Name</th>
			<th style="text-align: left;">Location</th>
		</tr>
		{$rank=$start_record}
		{$last=0}
		{foreach $f3f_records as $f}
			<tr>
				<td align="right" bgcolor="lightgrey">
					{if $f.event_pilot_round_flight_seconds!=$last}
						{$rank}
					{/if}
				</td>
				<td>{$f.event_start_date|date_format:"Y-m-d"}</td>
				<td align="left"><font size="+1"><b>{$f.event_pilot_round_flight_seconds|string_format:"%03.2f"}</b></font></td>
				<td>
					{if $f.pilot_country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.pilot_country_code|escape}.png" style="vertical-align: middle;" title="{$f.pilot_country_code}">{/if}
					<a href="?action=pilot&function=pilot_view&pilot_id={$f.record_pilot_id}">{$f.pilot_first_name} {$f.pilot_last_name}</a>
				</td>
				<td><a href="?action=plane&function=plane_view&plane_id={$f.plane_id}" title="View This Plane">{$f.plane_name|escape}</a></td>
				<td><a href="?action=event&function=event_view&event_id={$f.event_id}" title="View This Event">{$f.event_name|escape}</a></td>
				<td>
					{if $f.country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.country_code|escape}.png" style="vertical-align: middle;" title="{$f.country_code}">{/if}
					<a href="?action=location&function=location_view&location_id={$f.location_id}" title="View This Location">{$f.location_name|escape}</a>,
					{$f.country_code|escape}
				</td>
			</tr>
			{$rank=$rank+1}
			{$last=$f.event_pilot_round_flight_seconds}
		{/foreach}
		<tr class="table-row-heading-left" style="background-color: lightgray;">
			<th colspan="7" nowrap>
				{include file="paging.tpl"}
			</th>
		</tr>
		</table>
		
		
		<h3 class="post-title entry-title">Top F3B Speeds ({$start_record} - {$end_record})</h3>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr>
			<th style="text-align: left;"></th>
			<th style="text-align: left;">Event Date</th>
			<th style="text-align: left;">Speed</th>
			<th style="text-align: left;">Pilot</th>
			<th style="text-align: left;">Plane</th>
			<th style="text-align: left;">Event Name</th>
			<th style="text-align: left;">Location</th>
		</tr>
		{$rank=$start_record}
		{$last=0}
		{foreach $f3b_records as $f}
			<tr>
				<td align="right" bgcolor="lightgrey">
					{if $f.event_pilot_round_flight_seconds!=$last}
						{$rank}
					{/if}
				</td>
				<td>{$f.event_start_date|date_format:"Y-m-d"}</td>
				<td align="left"><font size="+1"><b>{$f.event_pilot_round_flight_seconds|string_format:"%03.2f"}</b></font></td>
				<td>
					{if $f.pilot_country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.pilot_country_code|escape}.png" style="vertical-align: middle;" title="{$f.pilot_country_code}">{/if}
					<a href="?action=pilot&function=pilot_view&pilot_id={$f.record_pilot_id}">{$f.pilot_first_name} {$f.pilot_last_name}</a>
				</td>
				<td><a href="?action=plane&function=plane_view&plane_id={$f.plane_id}" title="View This Plane">{$f.plane_name|escape}</a></td>
				<td><a href="?action=event&function=event_view&event_id={$f.event_id}" title="View This Event">{$f.event_name|escape}</a></td>
				<td>
					{if $f.country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.country_code|escape}.png" style="vertical-align: middle;" title="{$f.country_code}">{/if}
					<a href="?action=location&function=location_view&location_id={$f.location_id}" title="View This Location">{$f.location_name|escape}</a>,
					{$f.country_code|escape}
				</td>
			</tr>
			{$rank=$rank+1}
			{$last=$f.event_pilot_round_flight_seconds}
		{/foreach}
		<tr class="table-row-heading-left" style="background-color: lightgray;">
			<th colspan="7" nowrap>
				{include file="paging.tpl"}
			</th>
		</tr>
		</table>
		
		<h3 class="post-title entry-title">Top F3B Distance Runs ({$start_record} - {$end_record})</h3>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr>
			<th style="text-align: left;"></th>
			<th style="text-align: left;">Event Date</th>
			<th style="text-align: left;">Laps</th>
			<th style="text-align: left;">Pilot</th>
			<th style="text-align: left;">Plane</th>
			<th style="text-align: left;">Event Name</th>
			<th style="text-align: left;">Location</th>
		</tr>
		{$rank=$start_record}
		{$last=0}
		{foreach $f3b_distance as $f}
			<tr>
				<td align="right" bgcolor="lightgrey">
					{if $f.event_pilot_round_flight_laps!=$last}
						{$rank}
					{/if}
				</td>
				<td>{$f.event_start_date|date_format:"Y-m-d"}</td>
				<td align="left"><font size="+1"><b>{$f.event_pilot_round_flight_laps|string_format:"%3.0f"}</b></font></td>
				<td>
					{if $f.pilot_country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.pilot_country_code|escape}.png" style="vertical-align: middle;" title="{$f.pilot_country_code}">{/if}
					<a href="?action=pilot&function=pilot_view&pilot_id={$f.record_pilot_id}">{$f.pilot_first_name} {$f.pilot_last_name}</a>
				</td>
				<td><a href="?action=plane&function=plane_view&plane_id={$f.plane_id}" title="View This Plane">{$f.plane_name|escape}</a></td>
				<td><a href="?action=event&function=event_view&event_id={$f.event_id}" title="View This Event">{$f.event_name|escape}</a></td>
				<td>
					{if $f.country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.country_code|escape}.png" style="vertical-align: middle;" title="{$f.country_code}">{/if}
					<a href="?action=location&function=location_view&location_id={$f.location_id}" title="View This Location">{$f.location_name|escape}</a>,
					{$f.country_code|escape}
				</td>
			</tr>
			{$rank=$rank+1}
			{$last=$f.event_pilot_round_flight_laps}
		{/foreach}
		<tr class="table-row-heading-left" style="background-color: lightgray;">
			<th colspan="7" nowrap>
				{include file="paging.tpl"}
			</th>
		</tr>
		</table>
		<br>
		<br>
	</div>
</div>
{/block}
