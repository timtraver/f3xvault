{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">

		<h2 class="post-title entry-title">Browse Planes</h2>

		<form method="POST" name="filter">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_plane_list">
		<table width="80%">
		<tr>
			<th>Filter By Plane Discipline</th>
			<td colspan="3">
			<select name="discipline_id" onChange="filter.submit();">
			{foreach $disciplines as $d}
				<option value="{$d.discipline_id}" {if $discipline_id==$d.discipline_id}SELECTED{/if}>{$d.discipline_description|escape}</option>
			{/foreach}
			</select>
			</td>
		</tr>
		<tr>
			<th nowrap>	
				And Search on Field 
			</th>
			<td valign="center">
				<select name="search_field">
				<option value="plane_name" {if $search_field=="plane_name"}SELECTED{/if}>Plane Name</option>
				<option value="plane_manufacturer" {if $search_field=="plane_manufacturer"}SELECTED{/if}>Manufacturer</option>
				<option value="plane_year" {if $search_field=="plane_year"}SELECTED{/if}>Plane Year</option>
				<option value="plane_wing_type" {if $search_field=="plane_wing_type"}SELECTED{/if}>Plane Wing Type</option>
				<option value="plane_tail_type" {if $search_field=="plane_tail_type"}SELECTED{/if}>Plane Tail Type</option>
				</select>
				<select name="search_operator">
				<option value="contains" {if $search_operator=="contains"}SELECTED{/if}>Contains</option>
				<option value="greater" {if $search_operator=="greater"}SELECTED{/if}>Greater Than</option>
				<option value="less" {if $search_operator=="less"}SELECTED{/if}>Less Than</option>
				<option value="exactly" {if $search_operator=="exactly"}SELECTED{/if}>Is Exactly</option>
				</select>
				<input type="text" name="search" size="20" value="{$search|escape}">
				<input type="submit" value=" Search " class="block-button">
				<input type="submit" value=" Reset " class="block-button" onClick="document.filter.search_field.value='plane_name';document.filter.search_operator.value='contains';document.filter.search.value='';filter.submit();">
			</td>
		</tr>
		</table>
		</form>
		
		<form name="main" method="POST">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_plane_compare">
		
		
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr class="table-row-heading-left">
			<th colspan="8" style="text-align: left;">Planes (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
		</tr>
		<tr style="background-color: lightgray;">
			<td colspan="8">
				{include file="paging.tpl"}
			</td>
		</tr>
		<tr>
			<th style="text-align: left;"></th>
			<th style="text-align: left;">Plane Name</th>
			<th style="text-align: left;">Plane Type</th>
			<th style="text-align: center;">Info</th>
			<th style="text-align: left;">Manufacturer</th>
			<th style="text-align: left;">Year</th>
			<th style="text-align: left;">Wing Span</th>
			<th style="text-align: left;">Plane Weight Empty</th>
		</tr>
		{foreach $planes as $p}
		<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
			<td>
				<input type="checkbox" name="plane_{$p.plane_id}">
			</td>
			<td>
				<a href="?action=admin&function=admin_plane_view&plane_id={$p.plane_id|escape}" class="btn-link">{$p.plane_name|escape}</a>
			</td>
			<td>
			{foreach $p.disciplines as $d}
			{$d.discipline_code_view}{if !$d@last},{/if}
			{/foreach}
			</td>
			<td align="center">{if $p.plane_info=='good'}<img src="/images/icons/accept.png" title="We Have Good Info On This Model">{else}<img src="/images/icons/exclamation.png" title="We Need More Info About This Model">{/if}</td>
			<td>
				{if $p.country_code}<img src="/images/flags/countries-iso/shiny/16/{$p.country_code|escape}.png" style="vertical-align: middle;" title="{$p.country_name}">{/if}
				{$p.plane_manufacturer|escape}
			</td>
			<td>{$p.plane_year|escape}</td>
			<td>{$p.plane_wingspan|string_format:'%.1f'} {$p.plane_wingspan_units|escape}</td>
			<td>{$p.plane_auw_from|escape} - {$p.plane_auw_to|escape} {$p.plane_auw_units|escape}</td>
		</tr>
		{/foreach}
		<tr style="background-color: lightgray;">
			<td colspan="8">
				{include file="paging.tpl"}
			</td>
		</tr>
		<tr>
			<td colspan="8" align="center">
				<input type="button" value=" Combine Selected Planes " onclick="main.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>
		</form>

	</div>
</div>
{/block}
