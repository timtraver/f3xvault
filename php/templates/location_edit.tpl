<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Location Database</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Location Information Edit</h1>
<form name="main" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_save">
<input type="hidden" name="location_id" value="{$location.location_id|escape}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Location Name</th>
	<td><input type="text" size="50" name="location_name" value="{$location.location_name|escape}"></td>
</tr>
<tr>
	<th>Location City</th>
	<td>
		<input type="text" size="50" name="location_city" value="{$location.location_city|escape}">
	</td>
</tr>
<tr>
	<th>Location State</th>
	<td>
		<select name="state_id">
		{foreach $states as $state}
			<option value="{$state.state_id}" {if $state.state_id==$location.state_id}SELECTED{/if}>{$state.state_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th>Location Country</th>
	<td>
		<select name="country_id">
		{foreach $countries as $country}
			<option value="{$country.country_id}" {if $country.country_id==$location.country_id}SELECTED{/if}>{$country.country_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th>Map Coordinates</th>
	<td><input type="text" size="30" name="location_coordinates" value="{$location.location_coordinates|escape:'quotes'}"></td>
</tr>
<tr>
	<th>Local RC Club</th>
	<td><input type="text" size="50" name="location_club" value="{$location.location_club|escape}"></td>
</tr>
<tr>
	<th>RC Club Website URL</th>
	<td><input type="text" size="50" name="location_club_url" value="{$location.location_club_url|escape}"></td>
</tr>
<tr>
	<th valign="top">Location Description</th>
	<td><textarea cols="70" rows="10" name="location_description">{$location.location_description|escape}</textarea></td>
</tr>
<tr>
	<th valign="top">Location Detailed Directions</th>
	<td><textarea cols="70" rows="10" name="location_directions">{$location.location_directions|escape}</textarea></td>
</tr>
<tr>
	<th valign="top">Location Attributes</th>
	<td>
		<table width="100%" cellspacing="0" cellspadding="1" style="border-style: none;">
		{assign var='cat' value=''}
		{foreach $location_attributes as $la}
			{if $la.location_att_cat_name != $cat}
				{if $la.location_att_cat_name != ''}
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><hr></td></tr>
				{/if}
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><b>{$la.location_att_cat_name}</b></td></tr>
				<tr style="border-style: none;">
				{assign var='col' value='1'}
			{/if}
			{if $la.location_att_type == 'boolean'}
				<td style="border-style: none;" nowrap>
					<input type="checkbox" name="location_att_{$la.location_att_id}" {if $la.location_att_value_status==1 && $la.location_att_value_value ==1}CHECKED{/if}> <span title="{$la.location_att_description}">{$la.location_att_name}</span>
				</td>
			{else}
				<td style="border-style: none;" nowrap>
					<span title="{$la.location_att_description}">{$la.location_att_name}</span> <input type="text" name="location_att_{$la.location_att_id}" size="{$la.location_att_size}" value="{if $la.location_att_value_status==1}{$la.location_att_value_value}{/if}"> 
				</td>
			{/if}
			{if $col > 2}
			</tr><tr style="border-style: none;">
			{assign var='col' value="0"}
			{/if}
			{assign var='col' value=$col + 1}
			{assign var='cat' value=$la.location_att_cat_name}
		{/foreach}
		</tr>
		</table>
	</td>
</tr>



<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value="Cancel Edit" onClick="goback.submit();" class="block-button">
		<input type="submit" value="Save Location Values{if $from} and Return{/if}" class="block-button">
	</th>
</tr>
</table>
{foreach $from as $f}
<input type="hidden" name="{$f.key}" value="{$f.value}">
{/foreach}
</form>

<div id="media">
<h1 class="post-title entry-title">Location Media</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;" width="20%">Media Type</th>
	<th style="text-align: left;">URL</th>
	<th style="text-align: left;">&nbsp;</th>
</tr>
{if $media}
	{foreach $media as $m}
	<tr bgcolor="{cycle values="white,lightgray"}">
		<td>{if $m.location_media_type=='picture'}Picture{else}Video{/if}</td>
		{if $m.location_media_type=='picture'}
			<td><a href="{$m.location_media_url}" rel="gallery" class="fancybox-button" title="{if $m.user_id!=0}{$m.pilot_first_name}, {$m.pilot_city} - {/if}{$m.location_media_caption}">{$m.location_media_url}</a></td>
		{else}
			<td><a href="{$m.location_media_url}" rel="videos" class="fancybox-media" title="{if $m.user_id!=0}{$m.pilot_first_name}, {$m.pilot_city} - {/if}{$m.location_media_caption}">{$m.location_media_url}</a></td>
		{/if}
		<td> <a href="?action=location&function=location_media_del&location_id={$location.location_id}&location_media_id={$m.location_media_id}" title="Remove Media" onClick="confirm('Are you sure you wish to remove this media?')"><img src="images/del.gif"></a></td>
	</tr>
	{/foreach}
{else}
	<tr>
		<td colspan="4">You currently have no media entered.</td>
	</tr>
{/if}
</table>
<center>
<br>
<input type="button" name="media" value="Add New Location Media" onClick="add_media.submit()" class="block-button" {if $location.location_id==0}disabled="disabled" style=""{/if}>
</center>
</div>

<form name="add_media" method="GET">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_media_edit">
<input type="hidden" name="location_id" value="{$location.location_id}">
</form>


<form name="goback" method="GET">
<input type="hidden" name="action" value="location">
</form>

</div>
</div>
</div>

