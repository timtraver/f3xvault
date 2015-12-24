{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:600px;">
	<div class="panel-heading">
		<h2 class="heading">Browse F3X Planes</h2>
	</div>
	<div class="panel-body">
	<p>

	<div style="float:left;">
		<form name="search_form" method="POST">
		<input type="hidden" name="action" value="plane">
		<input type="hidden" name="function" value="plane_list">
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
				<td align="right">Name/Mfr</td>
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
		<input type="button" value=" Create New Plane Entry " onclick="newplane.submit();" class="btn btn-primary btn-rounded">
	</div>
	<br style="clear:left;">
<br>


<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
<tr class="table-row-heading-left" style="background-color: lightgray;">
	<th colspan="2" style="text-align: left;" nowrap>Planes (records {$paging.main.startrecord|escape} - {$paging.main.endrecord|escape} of {$paging.main.totalrecords|escape})</th>
	<th colspan="5" nowrap>
		{include file="paging.tpl"}
	</th>
</tr>
<tr>
	<th style="text-align: left;">Plane Name</th>
	<th style="text-align: left;">Plane Type</th>
	<th style="text-align: center;">Info</th>
	<th style="text-align: left;">Manufacturer</th>
	<th style="text-align: left;">Year</th>
	<th style="text-align: left;">Wing Span</th>
	<th style="text-align: left;">Plane Weight Empty</th>
</tr>
{foreach $planes as $plane}
<tr>
	<td>
		<a href="?action={$action|escape}&function=plane_view&plane_id={$plane.plane_id|escape}" class="btn-link">{$plane.plane_name|escape}</a>
	</td>
	<td>
	{foreach $plane.disciplines as $d}
	{$d.discipline_code_view}{if !$d@last},{/if}
	{/foreach}
	</td>
	<td align="center">{if $plane.plane_info=='good'}<img src="/images/icons/accept.png" title="We Have Good Info On This Model">{else}<img src="/images/icons/exclamation.png" title="We Need More Info About This Model">{/if}</td>
	<td>
		{if $plane.country_code}<img src="/images/flags/countries-iso/shiny/16/{$plane.country_code|escape}.png" style="vertical-align: middle;" title="{$plane.country_name}">{/if}
		{$plane.plane_manufacturer|escape}
	</td>
	<td>{$plane.plane_year|escape}</td>
	<td>{$plane.plane_wingspan|string_format:'%.1f'} {$plane.plane_wingspan_units|escape}</td>
	<td>{$plane.plane_auw_from|escape} - {$plane.plane_auw_to|escape} {$plane.plane_auw_units|escape}</td>
</tr>
{/foreach}
	<tr style="background-color: lightgray;">
		<td colspan="7">
			{include file="paging.tpl"}
		</td>
	</tr>
</table>

<form name="newplane" method="POST">
<input type="hidden" name="action" value="{$action|escape}">
<input type="hidden" name="function" value="plane_edit">
<input type="hidden" name="plane_id" value="0">
</form>


	</p>
	</div>
</div>

{/block}
