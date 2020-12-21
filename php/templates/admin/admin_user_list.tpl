{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">

		<h2 class="post-title entry-title">Browse Pilot Profiles</h2>

		<form name="searchform" method="POST">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_user_list">
		
		<table>
		<tr>
			<th>Filter By Country</th>
			<td>
			<select name="country_id" onChange="document.searchform.state_id.value=0;searchform.submit();">
			<option value="0">Choose Country to Narrow Search</option>
			{foreach $countries as $country}
				<option value="{$country.country_id|escape}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name|escape}</option>
			{/foreach}
			</select>
			</td>
			<th>Filter By State</th>
			<td>
			<select name="state_id" onChange="searchform.submit();">
			<option value="0">Choose State to Narrow Search</option>
			{foreach $states as $state}
				<option value="{$state.state_id|escape}" {if $state_id==$state.state_id}SELECTED{/if}>{$state.state_name|escape}</option>
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
				<option value="pilot_first_name" {if $search_field=="pilot_first_name"}SELECTED{/if}>Pilot First Name</option>
				<option value="pilot_last_name" {if $search_field=="pilot_last_name"}SELECTED{/if}>Pilot Last Name</option>
				<option value="pilot_city" {if $search_field=="pilot_city"}SELECTED{/if}>Pilot City</option>
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

		<form name="main" method="POST">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_user_compare">
		
		<br>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr class="table-row-heading-left">
			<th colspan="7" style="text-align: left;">Pilots (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
		</tr>
		<tr style="background-color: lightgray;">
			<td colspan="7">
				{include file="paging.tpl"}
			</td>
		</tr>
		<tr>
			<th style="text-align: left;"></th>
			<th style="text-align: left;">Pilot Name</th>
			<th style="text-align: left;">AMA/FAI/License</th>
			<th style="text-align: left;">Login Name</th>
			<th style="text-align: left;">User Full Name</th>
			<th style="text-align: left;">User Email</th>
			<th style="text-align: left;">Pilot Location</th>
		</tr>
		{foreach $pilots as $p}
		<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
			<td>
				<input type="checkbox" name="pilot_{$p.pilot_id|escape}">
			</td>
			<td>
				<a href="?action=admin&function=admin_user_view&pilot_id={$p.pilot_id|escape}" class="btn-link">{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</a>
			</td>
			<td>
				{$p.pilot_ama|escape}/{$p.pilot_fai|escape}/{$p.pilot_fai_license|escape}
			</td>
			<td>
				<a href="?action=admin&function=pilot_view&pilot_id={$p.pilot_id|escape}" class="btn-link">{$p.user_name|escape}</a>
			</td>
			<td>
				{$p.user_first_name|escape} {$p.user_last_name|escape}
			</td>
			<td>
				{$p.user_email|escape}
			</td>
			<td>{$p.pilot_city|escape}, {$p.state_code|escape} {$p.country_code|escape}</td>
		</tr>
		{/foreach}
		<tr style="background-color: lightgray;">
			<td colspan="7">
				{include file="paging.tpl"}
			</td>
		</tr>
		<tr>
			<td colspan="7" align="center">
				<input type="button" value=" Combine Selected Pilots " onclick="main.submit();" class="btn btn-primary btn-rounded">
				<input type="button" value=" Create New Pilot Entry " onclick="newpilot.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>
		</form>
		<form name="newpilot" method="POST">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_user_view">
		<input type="hidden" name="pilot_id" value="0">
		</form>

	</div>
</div>
{/block}
