<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Plane Database</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Plane Information Edit</h1>
<script type="text/javascript">
function calc_wingspan(){ldelim}
	var current_units = document.main.plane_wingspan_units.value;
	var current_value = document.main.plane_wingspan.value;
	var multiple = 2.54;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'in' || current_units == ''){ldelim}
		calc_value = multiple * current_value;
		calc_units = 'cm';
	{rdelim}else{ldelim}
		calc_value = current_value / multiple;
		calc_units = 'in';
	{rdelim}
	document.getElementById('wingspan').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
{rdelim}
function calc_length(){ldelim}
	var current_units = document.main.plane_length_units.value;
	var current_value = document.main.plane_length.value;
	var multiple = 2.54;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'in' || current_units == ''){ldelim}
		calc_value = multiple * current_value;
		calc_units = 'cm';
	{rdelim}else{ldelim}
		calc_value = current_value / multiple;
		calc_units = 'in';
	{rdelim}
	document.getElementById('length').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
{rdelim}
function calc_auw(){ldelim}
	var current_units = document.main.plane_auw_units.value;
	var current_from_value = document.main.plane_auw_from.value;
	var current_to_value = document.main.plane_auw_to.value;
	var multiple = 28.35;
	var calc_from_value = 0;
	var calc_to_value = 0;
	var calc_units = '';
	if(current_units == 'oz' || current_units == ''){ldelim}
		calc_from_value = multiple * current_from_value;
		calc_to_value = multiple * current_to_value;
		calc_units = 'grams';
	{rdelim}else{ldelim}
		calc_from_value = current_from_value / multiple;
		calc_to_value = current_to_value / multiple;
		calc_units = 'ounces';
	{rdelim}
	document.getElementById('auwrange').innerHTML = ' = ' + calc_from_value.toFixed(2) + ' To ' + calc_to_value.toFixed(2) + ' ' + calc_units;
{rdelim}
function calc_area(){ldelim}
	var current_units = document.main.plane_wing_area_units.value;
	var current_wing_value = document.main.plane_wing_area.value;
	var current_tail_value = document.main.plane_tail_area.value;
	var multiple = .0645;
	var calc_wing_value = 0;
	var calc_tail_value = 0;
	var calc_units = '';
	if(current_units == 'in2' || current_units == ''){ldelim}
		calc_wing_value = multiple * current_wing_value;
		calc_tail_value = multiple * current_tail_value;
		calc_units = 'Decimeters Squared';
	{rdelim}else{ldelim}
		calc_wing_value = current_wing_value / multiple;
		calc_tail_value = current_tail_value / multiple;
		calc_units = 'Inches Squared';
	{rdelim}
	var totalarea = (current_wing_value*1) + (current_tail_value*1);
	document.getElementById('wingarea').innerHTML = ' = ' + calc_wing_value.toFixed(2) + ' ' + calc_units;
	document.getElementById('tailarea').innerHTML = ' = ' + calc_tail_value.toFixed(2) + ' ' + calc_units;
	document.getElementById('totalarea').innerHTML = totalarea + ' ' + current_units;
{rdelim}
</script>
<form name="main" method="POST">
<input type="hidden" name="action" value="{$action|escape}">
<input type="hidden" name="function" value="plane_save">
<input type="hidden" name="plane_id" value="{$plane.plane_id|escape}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Plane Name</th>
	<td><input type="text" size="40" name="plane_name" value="{$plane.plane_name|escape}"></td>
	<th>Plane Disciplines</th>
</tr>
<tr>
	<th>Plane Wingspan</th>
	<td>
		<input type="text" size="10" name="plane_wingspan" value="{$plane.plane_wingspan|string_format:'%.1f'}" onChange="calc_wingspan();">
		<select name="plane_wingspan_units" onChange="calc_wingspan();">
		<option value="in" {if $plane.plane_wingspan_units=="in"}SELECTED{/if}>Inches</option>
		<option value="cm" {if $plane.plane_wingspan_units=="cm"}SELECTED{/if}>Centimeters</option>
		</select>
		<span id="wingspan"></span>
	</td>
	<td rowspan="6">
	{foreach $disciplines as $d}
	<input type="checkbox" name="disc_{$d.discipline_id}"{if $d.discipline_selected}CHECKED{/if}> {$d.discipline_description}<br>
	{/foreach}
	</td>
</tr>
<tr>
	<th>Plane Length</th>
	<td>
		<input type="text" size="10" name="plane_length" value="{$plane.plane_length|string_format:'%.1f'}" onChange="calc_length();">
		<select name="plane_length_units" onChange="calc_length();">
		<option value="in" {if $plane.plane_length_units=="in"}SELECTED{/if}>Inches</option>
		<option value="cm" {if $plane.plane_length_units=="cm"}SELECTED{/if}>Centimeters</option>
		</select>
		<span id="length"></span>		
	</td>
</tr>
<tr>
	<th>Plane AUW Range (Empty)</th>
	<td>
		<input type="text" size="10" name="plane_auw_from" value="{$plane.plane_auw_from|string_format:'%.1f'}" onChange="calc_auw();">
		To 
		<input type="text" size="10" name="plane_auw_to" value="{$plane.plane_auw_to|string_format:'%.1f'}" onChange="calc_auw();">
		<select name="plane_auw_units" onChange="calc_auw();">
		<option value="oz" {if $plane.plane_auw_from_units=="oz"}SELECTED{/if}>Ounces</option>
		<option value="gr" {if $plane.plane_auw_from_units=="gr"}SELECTED{/if}>Grams</option>
		</select>
		<span id="auwrange"></span>		
	</td>
</tr>
<tr>
	<th>Plane Wing Area</th>
	<td>
		<input type="text" size="10" name="plane_wing_area" value="{$plane.plane_wing_area|string_format:'%.2f'}" onChange="calc_area();">
		<select name="plane_wing_area_units" onChange="calc_area();">
		<option value="in2" {if $plane.plane_wing_area_units=="in2"}SELECTED{/if}>Inches squared</option>
		<option value="dm2" {if $plane.plane_wing_area_units=="dm2"}SELECTED{/if}>Decimeters squared</option>
		</select>
		<span id="wingarea"></span>		
	</td>
</tr>
<tr>
	<th>Plane Tail Area</th>
	<td>
		<input type="text" size="10" name="plane_tail_area" value="{$plane.plane_tail_area|string_format:'%.2f'}" onChange="calc_area();">
		<span id="tailarea"></span>		
	</td>
</tr>
<tr>
	<th>Plane Total Area</th>
	<td>
		<span id="totalarea"></span>		
	</td>
</tr>
<tr>
	<th>Plane Manufacturer</th>
	<td><input type="text" size="40" name="plane_manufacturer" value="{$plane.plane_manufacturer|escape}"></td>
</tr>
<tr>
	<th>Manufactured In</th>
	<td>
		<select name="country_id">
		{foreach $countries as $country}
			<option value="{$country.country_id}" {if $country.country_id==$plane.country_id}SELECTED{/if}>{$country.country_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th>Manufacturer Year</th>
	<td colspan="2"><input type="text" size="10" name="plane_year" value="{$plane.plane_year|escape}"></td>
</tr>
<tr>
	<th>Manufacturer Web Site</th>
	<td colspan="2"><input type="text" size="60" name="plane_website" value="{$plane.plane_website|escape}"></td>
</tr>
<tr>
	<th valign="top">Plane Attributes</th>
	<td colspan="2">
		<table width="100%" cellspacing="0" cellspadding="1" style="border-style: none;">
		{assign var='cat' value=''}
		{foreach $plane_attributes as $pa}
			{if $pa.plane_att_cat_name != $cat}
				{if $pa.plane_att_cat_name != ''}
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><hr></td></tr>
				{/if}
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><b>{$pa.plane_att_cat_name}</b></td></tr>
				<tr style="border-style: none;">
				{assign var='col' value='1'}
			{/if}
			{if $pa.plane_att_type == 'boolean'}
				<td style="border-style: none;" nowrap>
					<input type="checkbox" name="plane_att_{$pa.plane_att_id}" {if $pa.plane_att_value_status==1 && $pa.plane_att_value_value ==1}CHECKED{/if}> {$pa.plane_att_name}
				</td>
			{else}
				<td style="border-style: none;" nowrap>
					{$pa.plane_att_name} <input type="text" name="plane_att_{$pa.plane_att_id}" size="{$pa.plane_att_size}" value="{if $pa.plane_att_value_status==1}{$pa.plane_att_value_value}{/if}"> 
				</td>
			{/if}
			{if $col > 3}
			</tr><tr style="border-style: none;">
			{assign var='col' value="0"}
			{/if}
			{assign var='col' value=$col + 1}
			{assign var='cat' value=$pa.plane_att_cat_name}
		{/foreach}
		</tr>
		</table>
	</td>
</tr>



<tr>
	<th colspan="3" style="text-align: center;">
		<input type="submit" value="Save Plane Values{if $from} and Return{/if}" class="block-button">
		<input type="button" value="Back To Plane View" onClick="backtoview.submit();" class="block-button">
		<input type="button" value="Back To Plane List" onClick="backtolist.submit();" class="block-button">
	</th>
</tr>
</table>
{foreach $from as $f}
<input type="hidden" name="{$f.key}" value="{$f.value}">
{/foreach}
</form>

<script type="text/javascript">
	calc_wingspan();
	calc_length();
	calc_auw();
	calc_area();
</script>

<div id="media">
<h1 class="post-title entry-title">Plane Media</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;" width="20%">Media Type</th>
	<th style="text-align: left;">URL</th>
	<th style="text-align: left;">&nbsp;</th>
</tr>
{if $media}
	{foreach $media as $m}
	<tr bgcolor="{cycle values="white,lightgray"}">
		<td>{if $m.plane_media_type=='picture'}Picture{else}Video{/if}</td>
		{if $m.plane_media_type=='picture'}
			<td><a href="{$m.plane_media_url}" rel="gallery" class="fancybox-button" title="{if $m.user_id!=0}{$m.pilot_first_name}, {$m.pilot_city} - {/if}{$m.plane_media_caption}">{$m.plane_media_url}</a></td>
		{else}
			<td><a href="{$m.plane_media_url}" rel="videos" class="fancybox-media" title="{if $m.user_id!=0}{$m.pilot_first_name}, {$m.pilot_city} - {/if}{$m.plane_media_caption}">{$m.plane_media_url}</a></td>
		{/if}
		<td> <a href="?action=plane&function=plane_media_del&plane_id={$plane.plane_id}&plane_media_id={$m.plane_media_id}" title="Remove Media" onClick="confirm('Are you sure you wish to remove this media?')"><img src="images/del.gif"></a></td>
	</tr>
	{/foreach}
{else}
	<tr>
		<td colspan="4">There is currently no media entered.</td>
	</tr>
{/if}
</table>
<center>
<br>
<input type="button" name="media" value="Add New Plane Media" onClick="add_media.submit()" class="block-button" {if $plane.plane_id==0}disabled="disabled" style=""{/if}>
</center>
</div>

<form name="add_media" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_media_edit">
<input type="hidden" name="plane_id" value="{$plane.plane_id}">
</form>

<form name="backtoview" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_view">
<input type="hidden" name="plane_id" value="{$plane.plane_id}">
</form>
<form name="backtolist" method="GET">
<input type="hidden" name="action" value="plane">
</form>

</div>
</div>
</div>

