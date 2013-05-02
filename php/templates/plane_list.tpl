<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Browse F3X Plane Database</h1>
		<div class="entry-content clearfix">

<form method="POST" name="filter">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_list">
<table width="80%">
<tr>
	<th>Filter By Plane Discipline</th>
	<td colspan="3">
	<select name="discipline_id" onChange="filter.submit();">
	{foreach $disciplines as $d}
		<option value="{$d.discipline_id}" {if $discipline_id==$d.discipline_id}SELECTED{/if}>{$d.discipline_description}</option>
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
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="8" style="text-align: left;">Planes (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="4">
                {if $startrecord>1}[<a href="?action=plane&function=plane_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=plane&function=plane_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="4">PerPage
                [<a href="?action=plane&function=plane_list&&perpage=25">25</a>]
                [<a href="?action=plane&function=plane_list&&perpage=50">50</a>]
                [<a href="?action=plane&function=plane_list&&perpage=100">100</a>]
                [<a href="?action=plane&function=plane_list&page=1">First Page</a>]
                [<a href="?action=plane&function=plane_list&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<th style="text-align: left;">Plane Name</th>
	<th style="text-align: left;">Plane Type</th>
	<th style="text-align: center;">Info</th>
	<th style="text-align: left;">Manufacturer</th>
	<th style="text-align: left;">Year</th>
	<th style="text-align: left;">Wing Span</th>
	<th style="text-align: left;">Plane Weight Empty</th>
	<th style="text-align: left;">Action</th>
</tr>
{foreach $planes as $plane}
<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
	<td>
		<a href="?action={$action|escape}&function=plane_view&plane_id={$plane.plane_id|escape}">{$plane.plane_name|escape}</a>
	</td>
	<td>
	{foreach $plane.disciplines as $d}
	{$d.discipline_code_view}{if !$d@last},{/if}
	{/foreach}
	</td>
	<td align="center">{if $plane.plane_info=='good'}<img src="/images/icons/accept.png" title="We Have Good Info On This Model">{else}<img src="/images/icons/exclamation.png" title="We Need More Info About This Model">{/if}</td>
	<td>{$plane.plane_manufacturer|escape}</td>
	<td>{$plane.plane_year}</td>
	<td>{$plane.plane_wingspan|string_format:'%.1f'} {$plane.plane_wingspan_units}</td>
	<td>{$plane.plane_auw_from|escape} - {$plane.plane_auw_to|escape} {$plane.plane_auw_units}</td>
	<td><a href="?action={$action|escape}&function=plane_edit&plane_id={$plane.plane_id|escape}" title="Edit This Plane"><img src="/images/icon_edit_small.gif" width="20"></a>
	</td>
</tr>
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="4">
                {if $startrecord>1}[<a href="?action=plane&function=plane_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=plane&function=plane_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="4">PerPage
                [<a href="?action=plane&function=plane_list&perpage=25">25</a>]
                [<a href="?action=plane&function=plane_list&perpage=50">50</a>]
                [<a href="?action=plane&function=plane_list&perpage=100">100</a>]
                [<a href="?action=plane&function=plane_list&page=1">First Page</a>]
                [<a href="?action=plane&function=plane_list&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<td colspan="8" align="center">
		<input type="button" value=" Create New Plane Entry " onclick="newplane.submit();" class="block-button">
	</td>
</tr>
</table>

<form name="newplane" method="POST">
<input type="hidden" name="action" value="{$action|escape}">
<input type="hidden" name="function" value="plane_edit">
<input type="hidden" name="plane_id" value="0">
</form>


</div>
</div>
</div>

