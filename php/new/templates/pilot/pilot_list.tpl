{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:600px;">
	<div class="panel-heading">
		<h2 class="heading">Browse F3X Pilots</h2>
	</div>
	<div class="panel-body">
	<p>

	<div style="float:left;">
		<form name="search_form" method="POST">
		<input type="hidden" name="action" value="pilot">
		<input type="hidden" name="function" value="pilot_list">
		<table class="filter" cellpadding="2" cellspacing="2">
			<tr>
				<th colspan="2">Filter Results</th>
			</tr>
			<tr>
				<td align="right">Country</td>
				<td nowrap>
					<select name="country_id" onChange="search_form.submit();">
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
				<td align="right">Name/City</td>
				<td nowrap>
					<input type="text" name="search" size="20" value="{$search|escape}">
					<input type="submit" value=" Search " class="btn btn-primary btn-rounded">
					<input type="submit" value=" Reset " class="btn btn-primary btn-rounded" onClick="document.search_form.country_id.value=0;document.search_form.search.value='';search_form.submit();">
				</td>
			</tr>
		</table>
		</form>
	</div>
	<div style="float:right;overflow:hidden;">
		<input type="button" value=" Create New Pilot Entry " onclick="newpilot.submit();" class="btn btn-primary btn-rounded">
	</div>
	<br style="clear:left;">
	<br>

	<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
	<tr class="table-row-heading-left" style="background-color: lightgray;">
		<th colspan="2" style="text-align: left;" nowrap>Pilots (records {$paging.main.startrecord|escape} - {$paging.main.endrecord|escape} of {$paging.main.totalrecords|escape})</th>
		<th colspan="2" nowrap>
			{include file="paging.tpl"}
		</th>
	</tr>
	<tr>
		<th style="text-align: left;">Pilot Name</th>
		<th style="text-align: left;">City</th>
		<th style="text-align: left;">State</th>
		<th style="text-align: left;">Country</th>
	</tr>
	{foreach $pilots as $p}
	<tr>
		<td>
			<a href="?action=pilot&function=pilot_view&pilot_id={$p.pilot_id|escape}" class="btn-link">{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</a>
		</td>
		<td>{$p.pilot_city|escape}</td>
		<td>
			{if $p.state_name && $p.country_code=="US"}<img src="/images/flags/states/16/{$p.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
			{$p.state_name|escape}
		</td>
		<td>
			{if $p.country_code}<img src="/images/flags/countries-iso/shiny/16/{$p.country_code|escape}.png" style="vertical-align: middle;">{/if}
			{$p.country_name|escape}
		</td>
	</tr>
	{/foreach}
	<tr style="background-color: lightgray;">
		<td colspan="4">
			{include file="paging.tpl"}
		</td>
	</tr>
	</table>
	
	<form name="newpilot" method="POST">
	<input type="hidden" name="action" value="pilot">
	<input type="hidden" name="function" value="pilot_edit">
	<input type="hidden" name="location_id" value="0">
	</form>


	</p>
	</div>
</div>

{/block}
