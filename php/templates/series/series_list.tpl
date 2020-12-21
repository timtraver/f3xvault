{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Browse F3X Series</h2>
	</div>
	<div class="panel-body">
		<br style="clear:left;">

		<div style="float:left;">
			<form name="search_form" method="POST">
			<input type="hidden" name="action" value="series">
			<input type="hidden" name="function" value="series_list">
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
							<option value="{$country.country_id|escape}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name|escape}</option>
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
							<option value="{$state.state_id|escape}" {if $state_id==$state.state_id}SELECTED{/if}>{$state.state_name|escape}</option>
						{/foreach}
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">Name</td>
					<td nowrap>
						<input type="text" name="search" size="20" value="{$search|escape}">
						<input type="submit" value=" Search " class="btn btn-primary btn-rounded">
						<input type="submit" value=" Reset " class="btn btn-primary btn-rounded" onClick="document.search_form.country_id.value=0;document.search_form.state_id.value=0;document.search_form.search.value='';search_form.submit();">
					</td>
				</tr>
			</table>
			</form>
		</div>
		<div style="float:right;overflow:hidden;">
			<input type="button" value=" Create New Series " onclick="{if $user.user_id!=0}newseries.submit();{else}alert('You must be registered and logged in to create a new event.');{/if}" class="btn btn-primary btn-rounded">
		</div>
		<br style="clear:left;">
		<br>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
		<tr class="table-row-heading-left">
			<th colspan="2" style="text-align: left;" nowrap>Events (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
			<th colspan="5" nowrap>
				{include file="paging.tpl"}
			</th>
		</tr>
		<tr>
			<th style="text-align: left;">Series Name</th>
			<th style="text-align: left;">Series Area</th>
			<th style="text-align: left;">State</th>
			<th style="text-align: left;">Country</th>
			<th style="text-align: left;">Total Events</th>
		</tr>
		{foreach $series as $s}
		<tr>
			<td>
				<a href="?action=series&function=series_view&series_id={$s.series_id|escape}" class="btn-link">{$s.series_name|escape}</a>
			</td>
			<td>{$s.series_area|escape}</td>
			<td>
				{if $s.state_name && $s.country_code=="US"}<img src="/images/flags/states/16/{$s.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if} 
				{$s.state_name|escape}
			</td>
			<td>
				{if $s.country_code}<img src="/images/flags/countries-iso/shiny/16/{$s.country_code|escape}.png" style="vertical-align: middle;">{/if}
				{$s.country_name|escape}
			</td>
			<td>{$s.series_total_events|escape}</td>
		</tr>
		{/foreach}
		<tr class="table-row-heading-left" style="background-color: lightgray;">
			<th colspan="7" nowrap>
				{include file="paging.tpl"}
			</th>
		</tr>
		</table>
		
		<form name="newseries" method="POST">
		<input type="hidden" name="action" value="series">
		<input type="hidden" name="function" value="series_edit">
		<input type="hidden" name="series_id" value="0">
		</form>

	</div>
</div>
{/block}