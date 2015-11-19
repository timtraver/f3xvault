{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:600px;">
	<div class="panel-heading">
		<h2 class="heading">Browse F3X Clubs</h2>
	</div>
	<div class="panel-body">
	<p>

	<div style="float:left;">
		<form name="search_form" method="POST">
		<input type="hidden" name="action" value="club">
		<input type="hidden" name="function" value="club_list">
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
				<td align="right">Name/City</td>
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
		<input type="button" value=" Create New Club Entry " onclick="newclub.submit();" class="btn btn-primary btn-rounded">
	</div>
	<br style="clear:left;">
	<br>
	
	<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
	<tr class="table-row-heading-left">
		<th colspan="3" style="text-align: left;" nowrap>Clubs (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
		<th colspan="3" nowrap>
			{include file="paging.tpl"}
		</th>
	</tr>
	<tr>
		<th style="text-align: left;">Club Name</th>
		<th style="text-align: left;">City</th>
		<th style="text-align: left;">State</th>
		<th style="text-align: left;">Country</th>
		<th style="text-align: left;">Total Members</th>
	</tr>
	{foreach $clubs as $c}
	<tr>
		<td>
			<a href="?action=club&function=club_view&club_id={$c.club_id|escape}" class="btn-link">{$c.club_name|escape}</a>
		</td>
		<td>{$c.club_city|escape}</td>
		<td>{$c.state_name|escape}
			{if $c.state_name && $c.country_code=="US"}<img src="/images/flags/states/16/{$c.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
		</td>
		<td>{$c.country_name|escape}
			{if $c.country_code}<img src="/images/flags/countries-iso/shiny/16/{$c.country_code|escape}.png" style="vertical-align: middle;">{/if}
		</td>
		<td>{$c.club_total_members|escape}</td>
	</tr>
	{/foreach}
	<tr>
		<th colspan="6">
			{include file="paging.tpl"}
		</th>
	</tr>
	</table>
	
	<form name="newclub" method="POST">
	<input type="hidden" name="action" value="club">
	<input type="hidden" name="function" value="club_edit">
	<input type="hidden" name="club_id" value="0">
	</form>


	</p>
	</div>
</div>

{/block}

