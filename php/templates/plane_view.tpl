<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Plane Database</h1>
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
function calc_weight(){ldelim}
	var current_units = '{$plane.plane_auw_units}';
	var current_value = {$plane.plane_auw};
	var multiple = 28.35;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'oz' || current_units == ''){ldelim}
		calc_value = multiple * current_value;
		calc_units = 'gr';
	{rdelim}else{ldelim}
		calc_value = current_value / multiple;
		calc_units = 'oz';
	{rdelim}
	document.getElementById('weight').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
{rdelim}
function calc_area(){ldelim}
	var current_units = '{$plane.plane_wing_area_units}';
	var current_value = {$plane.plane_wing_area};
	var multiple = 6.45;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'in2' || current_units == ''){ldelim}
		calc_value = multiple * current_value;
		calc_units = 'cm<sup>2</sup>';
	{rdelim}else{ldelim}
		calc_value = current_value / multiple;
		calc_units = 'in2';
	{rdelim}
	document.getElementById('area').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
{rdelim}
</script>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Plane Name</th>
	<td>{$plane.plane_name|escape}</td>
	<th style="text-align: center;">Plane Media</th>
</tr>
<tr>
	<th>Plane Classification</th>
	<td>
		{$plane.plane_type_short_name|escape} - {$plane.plane_type_description|escape}
	</td>
	<td rowspan="9" align="center">
	{if $media[$rand]}
	<img src="{$media[$rand].plane_media_url}" width="300"><br>
	<a href="{$media[$rand].plane_media_url}" rel="gallery" class="fancybox-button" title="{$media[$rand].pilot_first_name}, {$media[$rand].pilot_city} {$media[$rand].state_code} - {$media[$rand].plane_media_caption}">View Slide Show</a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="{$m.plane_media_url}" rel="videos" class="fancybox-media" title="View all of the Videos">View Videos</a>
	{else}
		There are currently No pictures or videos available<br>
		Help us out and add some!<br>
	{/if}
	</td>
</tr>
<tr>
	<th>Plane Wingspan</th>
	<td>
		{$plane.plane_wingspan|string_format:'%.1f'} {$plane.plane_wingspan_units}
		<span id="wingspan"></span>
	</td>
</tr>
<tr>
	<th>Plane Length</th>
	<td>
		{$plane.plane_length|string_format:'%.1f'} {$plane.plane_length_units}
		<span id="length"></span>		
	</td>
</tr>
<tr>
	<th>Plane AUW</th>
	<td>
		{$plane.plane_auw|string_format:'%.1f'} {$plane.plane_auw_units}
		<span id="weight"></span>		
	</td>
</tr>
<tr>
	<th>Plane Wing Area</th>
	<td>
		{$plane.plane_wing_area|string_format:'%.1f'} {if $plane.plane_wing_area_units == 'in2'}in<sup>2</sup>{else}cm<sup>2</sup>{/if}
		<span id="area"></span>		
	</td>
</tr>
<tr>
	<th>Plane Manufacturer</th>
	<td>{$plane.plane_manufacturer|escape}</td>
</tr>
<tr>
	<th>Manufacturer Country</th>
	<td>
		{$plane.country_name}
	</td>
</tr>
<tr>
	<th>Manufacturer Year</th>
	<td>{$plane.plane_year|escape}</td>
</tr>
<tr>
	<th>Manufacturer Web Site</th>
	<td><a href="{$plane.plane_website|escape}" target="_blank">{$plane.plane_website|escape}</a></td>
</tr>
<tr>
	<th valign="top">Plane Attributes</th>
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
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;">{$pa.plane_att_cat_name}</td></tr>
				<tr style="border-style: none;"><td style="border-style: none;">
				{assign var='row' value='1'}
			{/if}
			{if $pa.plane_att_type == 'boolean'}
				{$pa.plane_att_name}
			{else}
				{$pa.plane_att_name} <input type="text" name="plane_att_{$pa.plane_att_id}" size="{$pa.plane_att_size}" value="{$pa.plane_att_value_value}">
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
	calc_length();
	calc_weight();
	calc_area();
</script>
<form name="goback" method="GET">
<input type="hidden" name="action" value="plane">
</form>


<h1 class="post-title entry-title">Plane Media</h1>
{if !$user.user_id}Log In To Add Media{/if}
{foreach $media as $m}
	{if $m.plane_media_type == 'picture'}
		<a href="{$m.plane_media_url}" rel="gallery" class="fancybox-button" title="{$m.pilot_first_name}, {$m.pilot_city} {$m.state_code} - {$m.plane_media_caption}"><img src="/images/icons/picture.png" style="border-style: none;"></a>
	{else}
		<a href="{$m.plane_media_url}" rel="videos" class="fancybox-media" title="{$m.pilot_first_name}, {$m.pilot_city} {$m.state_code} - {$m.plane_media_caption}"><img src="/images/icons/webcam.png" style="border-style: none;"></a>
	{/if}
{/foreach}
</div>
</div>
</div>

<div id="comments" class="clearfix no-ping">
<h4 class="comments gutter-left current">{$comments_num} Plane Comments</h4>
<ol class="clearfix" id="comments_list">
		{foreach $comments as $c}
			<li class="comment byuser bypostauthor even thread-even depth-1 clearfix" style="padding-left: 10px;">
			<div class="comment-avatar-wrap">{$c.avatar}</div>
			<h5 class="comment-author">{$c.user_first_name} {$c.user_last_name}</h5>
			<div class="comment-meta"><p class="commentmetadata">{$c.plane_comment_date|date_format:"%B %e, %Y - %I:%M %p"}</p></div>
			<div class="comment-entry"><p>{$c.plane_comment_string}</p></div>
			</li>
		{/foreach}
	</ol>
<center>
	<input type="button" value="Add A Comment About This Plane" onClick="addcomment.submit();" class="block-button">
</center>
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

