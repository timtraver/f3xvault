<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">F3X Plane Database</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Plane Details  <input type="button" value=" Edit Plane Information " class="button" onClick="plane_edit.submit();"></h1>
<script type="text/javascript">
function calc_wingspan(){ldelim}
	var current_units = '{$plane.plane_wingspan_units}';
	var current_value = {$plane.plane_wingspan};
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
function calc_aspect(){ldelim}
	var length={$plane.plane_wingspan};
	var width={$plane.plane_root_chord_length};
	var calc_aspect=0;
	if(width!=0 && length!=0){ldelim}
		calc_aspect = length / width;
	{rdelim}
	document.getElementById('aspect').innerHTML = calc_aspect.toFixed(2);
{rdelim}
function calc_length(){ldelim}
	var current_units = '{$plane.plane_length_units}';
	var current_value = {$plane.plane_length};
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
	var current_units = '{$plane.plane_auw_units}';
	var current_from_value = {$plane.plane_auw_from};
	var current_to_value = {$plane.plane_auw_to};
	var multiple = 28.35;
	var calc_from_value = 0;
	var calc_to_value = 0;
	var calc_units = '';
	if(current_units == 'oz' || current_units == ''){ldelim}
		calc_from_value = multiple * current_from_value;
		calc_to_value = multiple * current_to_value;
		calc_units = 'gr';
	{rdelim}else{ldelim}
		calc_from_value = current_from_value / multiple;
		calc_to_value = current_to_value / multiple;
		calc_units = 'oz';
	{rdelim}
	document.getElementById('auwrange').innerHTML = '  =  ' + calc_from_value.toFixed(2) + ' To ' + calc_to_value.toFixed(2) + ' ' + calc_units;
{rdelim}
function calc_max_weight(){ldelim}
	var current_units = '{$plane.plane_wing_area_units}';
	var current_value = {$plane.plane_wing_area + $plane.plane_tail_area};
	var multiple = 28.35;
	var calc_value = 0;
	var calc_to = 0;
	var calc_units = '';
	var calc_to_units = '';
	if(current_units == 'in2' || current_units == ''){ldelim}
		calc_value = 0.17 * current_value;
		calc_units = 'oz';
		calc_to = multiple * calc_value;
		calc_to_units = 'gr';
	{rdelim}else{ldelim}
		calc_value = 75 * current_value;
		calc_units = 'gr';
		calc_to = calc_value / multiple;
		calc_to_units = 'oz';
	{rdelim}
	document.getElementById('max_weight').innerHTML = calc_value.toFixed(2) + ' ' + calc_units + ' = ' + calc_to.toFixed(2) + ' ' + calc_to_units;
{rdelim}
function calc_area(){ldelim}
	var current_units = '{$plane.plane_wing_area_units}';
	var current_wing_value = {$plane.plane_wing_area};
	var current_tail_value = {$plane.plane_tail_area};
	var multiple = .0645;
	var calc_wing_value = 0;
	var calc_tail_value = 0;
	var calc_total_value = 0;
	var calc_units = '';
	if(current_units == 'in2' || current_units == ''){ldelim}
		calc_wing_value = multiple * current_wing_value;
		calc_tail_value = multiple * current_tail_value;
		calc_total_value = calc_wing_value +  calc_tail_value;
		current_units = 'in<sup>2</sup>';
		calc_units = 'dm<sup>2</sup>';
	{rdelim}else{ldelim}
		calc_wing_value = current_wing_value / multiple;
		calc_tail_value = current_tail_value / multiple;
		calc_total_value = calc_wing_value +  calc_tail_value;
		current_units = 'dm<sup>2</sup>';
		calc_units = 'in<sup>2</sup>';
	{rdelim}
	var totalarea = (current_wing_value*1) + (current_tail_value*1);
	document.getElementById('wingarea').innerHTML = ' = ' + calc_wing_value.toFixed(2) + ' ' + calc_units;
	document.getElementById('tailarea').innerHTML = ' = ' + calc_tail_value.toFixed(2) + ' ' + calc_units;
	document.getElementById('totalarea').innerHTML = totalarea.toFixed(2) + ' ' + current_units + ' = ' + calc_total_value.toFixed(2) + ' ' + calc_units;
{rdelim}
</script>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th align="left">Plane Name</th>
	<td>{$plane.plane_name|escape}</td>
	<th style="text-align: center;">Plane Media</th>
</tr>
<tr>
	<th align="left" valign="top">Plane Flying Disciplines</th>
	<td>
		{$calc_max=0}
		{foreach $disciplines as $d}
		{$d.discipline_description}<br>
		{if $d.discipline_code=='f3b' || $d.discipline_code=='f3f' || $d.discipline_code=='f3j'}
			{$calc_max=1}
		{/if} 
		{/foreach}
	</td>
	<td rowspan="10" align="center">
	{if $media[$rand]}
	<a data-trigger-rel="gallery" class="fancybox-trigger" href="{$media[$rand].plane_media_url}" title="{$media[$rand].pilot_first_name|escape}, {$media[$rand].pilot_city|escape} {$media[$rand].state_code|escape} - {$media[$rand].plane_media_caption|escape}"><img src="{$media[$rand].plane_media_url}" width="300"></a><br>
	<a data-trigger-rel="gallery" class="fancybox-trigger" href="{$media[$rand].plane_media_url}" title="{$media[$rand].pilot_first_name|escape}, {$media[$rand].pilot_city|escape} {$media[$rand].state_code|escape} - {$media[$rand].plane_media_caption|escape}">View Slide Show</a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a data-trigger-rel="videos" class="fancybox-trigger" href="{$m.plane_media_url}" title="View all of the Videos">View Videos</a>
	{else}
		There are currently No pictures or videos available<br>
		Help us out and add some!<br>
	{/if}
	</td>
</tr>
<tr>
	<th align="left">Plane Wingspan</th>
	<td>
		{$plane.plane_wingspan|string_format:'%.1f'} {$plane.plane_wingspan_units|escape}
		<span id="wingspan"></span>
	</td>
</tr>
<tr>
	<th align="left">Plane Length</th>
	<td>
		{$plane.plane_length|string_format:'%.1f'} {$plane.plane_length_units|escape}
		<span id="length"></span>		
	</td>
</tr>
<tr>
	<th align="left">Plane Root Chord Length</th>
	<td>
		{$plane.plane_root_chord_length|string_format:'%.1f'} {$plane.plane_wingspan_units|escape}
		<span id="length"></span>		
	</td>
</tr>
<tr>
	<th align="left">Plane Aspect Ratio</th>
	<td bgcolor="lightgrey">
		<span id="aspect"></span>
	</td>
</tr>
<tr>
	<th align="left">Plane AUW Range (Empty)</th>
	<td>
		{$plane.plane_auw_from|string_format:'%.1f'} To {$plane.plane_auw_to|string_format:'%.1f'} {$plane.plane_auw_units|escape}
		<span id="auwrange"></span>
	</td>
</tr>
<tr>
	<th align="left">Plane Wing Area</th>
	<td>
		{$plane.plane_wing_area|string_format:'%.2f'} {if $plane.plane_wing_area_units == 'in2'}in<sup>2</sup>{else}dm<sup>2</sup>{/if}
		<span id="wingarea"></span>		
	</td>
</tr>
<tr>
	<th align="left">Plane Tail Area</th>
	<td>
		{$plane.plane_tail_area|string_format:'%.2f'} {if $plane.plane_wing_area_units == 'in2'}in<sup>2</sup>{else}dm<sup>2</sup>{/if}
		<span id="tailarea"></span>		
	</td>
</tr>
<tr>
	<th align="left">Plane Total Area</th>
	<td bgcolor="lightgrey">
		<span id="totalarea"></span>
	</td>
</tr>
{if $calc_max}
<tr>
	<th align="left">FAI Max Wing Loading (By Rule For Class)</th>
	<td bgcolor="lightgrey">
		{if $plane.plane_wing_area_units == 'in2'}
			0.17 oz/in<sup>2</sup> = 75 g/dm<sup>2</sup>
		{else}
			75 g/dm<sup>2</sup> = 0.17 oz/in<sup>2</sup>
		{/if}
	</td>
</tr>
<tr>
	<th align="left">Maximum FAI Weight</th>
	<td bgcolor="lightgrey">
	<span id="max_weight"></span>
	</td>
</tr>
{/if}
<tr>
	<th align="left">Plane Manufacturer</th>
	<td>{$plane.plane_manufacturer|escape}</td>
</tr>
<tr>
	<th align="left">Manufacturer Country</th>
	<td>
		{if $plane.country_code}<img src="/images/flags/countries-iso/shiny/24/{$plane.country_code|escape}.png" style="vertical-align: middle;">{/if}
		{$plane.country_name|escape}
	</td>
</tr>
<tr>
	<th align="left">Manufacturer Year</th>
	<td>{$plane.plane_year|escape}</td>
</tr>
<tr>
	<th align="left">Manufacturer Web Site</th>
	<td><a href="{$plane.plane_website|escape}" target="_blank">{$plane.plane_website|escape}</a></td>
</tr>
<tr>
	<th align="left" valign="top">Plane Attributes</th>
	<td colspan="3">
		{if $plane_attributes}
		<table width="100%" cellspacing="0" cellspadding="1" style="border-style: none;">
		{assign var='cat' value=''}
		{assign var='row' value='0'}
		{foreach $plane_attributes as $pa name="pas"}
			{if $pa.plane_att_cat_name != $cat}
				{if $pa.plane_att_cat_name != ''}
					{if $row != 0}
					</td></tr>
					{/if}
					<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><hr></td></tr>							
				{/if}
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><b>{$pa.plane_att_cat_name|escape}</b></td></tr>
				<tr style="border-style: none;"><td style="border-style: none;">
				{assign var='row' value='1'}
			{/if}
			{if $pa.plane_att_type == 'boolean'}
				{$pa.plane_att_name}
			{else}
				{$pa.plane_att_name} <input type="text" name="plane_att_{$pa.plane_att_id}" size="{$pa.plane_att_size}" value="{$pa.plane_att_value_value|escape}">
			{/if}
			{assign var='cat' value=$pa.plane_att_cat_name}
			{assign var='nextit' value=$smarty.foreach.pas.index + 1}
			{if $plane_attributes[$nextit].plane_att_cat_name == $cat}
			&nbsp;-&nbsp; 
			{/if}
		{/foreach}
		</td></tr>
		</table>
		{else}
		This information has not been entered for this plane.<br>
		Help us out and enter it!
		{/if}
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value="Back To Plane List" onClick="goback.submit();" class="block-button">
	</th>
</tr>
</table>
<script type="text/javascript">
	calc_wingspan();
	calc_aspect();
	calc_length();
	calc_auw();
	calc_area();
	calc_max_weight();
</script>
<form name="goback" method="GET">
<input type="hidden" name="action" value="plane">
</form>


<h1 class="post-title entry-title">Plane Media</h1>
{if !$user.user_id}Log In To Add Media{/if}
{foreach $media as $m}
	{if $m.plane_media_type == 'picture'}
		<a href="{$m.plane_media_url}" rel="gallery" class="fancybox-button" title="{$m.pilot_first_name|escape}, {$m.pilot_city|escape} {$m.state_code|escape} - {$m.plane_media_caption|escape}"><img src="/images/icons/picture.png" style="border-style: none;"></a>
	{else}
		<a href="{$m.plane_media_url}" rel="videos" class="fancybox-media" title="{$m.pilot_first_name|escape}, {$m.pilot_city|escape} {$m.state_code|escape} - {$m.plane_media_caption|escape}"><img src="/images/icons/webcam.png" style="border-style: none;"></a>
	{/if}
{/foreach}
</div>
</div>
</div>

<div id="comments" class="clearfix no-ping">
<h4 class="comments gutter-left current">{$comments_num} Plane Comments</h4>
	<input type="button" value="Add A Comment About This Plane" onClick="addcomment.submit();" class="block-button">
<ol class="clearfix" id="comments_list">
		{foreach $comments as $c}
			<li class="comment byuser bypostauthor even thread-even depth-1 clearfix" style="padding-left: 10px;">
			<h5 class="comment-author">{$c.user_first_name|escape} {$c.user_last_name|escape}</h5>
			<div class="comment-meta"><p class="commentmetadata">{$c.plane_comment_date|date_format:"%B %e, %Y - %I:%M %p"}</p></div>
			<div class="comment-entry"><p>{$c.plane_comment_string|escape}</p></div>
			</li>
		{/foreach}
	</ol>
</div>

<form name="addcomment" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_comment_add">
<input type="hidden" name="plane_id" value="{$plane.plane_id}">
</form>
<form name="plane_edit" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_edit">
<input type="hidden" name="plane_id" value="{$plane.plane_id}">
</form>

