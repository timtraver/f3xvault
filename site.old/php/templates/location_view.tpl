<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">F3X Location Database</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Location Details <input type="button" value=" Edit Location Information " class="button" onClick="location_edit.submit();"></h1>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th nowrap>Site Name</th>
	<td>{$location.location_name|escape}</td>
	<th style="text-align: center;">Location Media</th>
</tr>
<tr>
	<th>Location</th>
	<td>
		{$location.location_city|escape} - {$location.state_code|escape}, {$location.country_code|escape}
		{if $location.country_code}<img src="/images/flags/countries-iso/shiny/24/{$location.country_code|escape}.png" style="vertical-align: middle;">{/if}
		{if $location.state_name && $location.country_code=="US"}<img src="/images/flags/states/24/{$location.state_name|replace:' ':'-'}-Flag-24.png" style="vertical-align: middle;">{/if}
	</td>
	<td rowspan="4" align="center">
	{if $media[$rand]}
	<a data-trigger-rel="gallery" class="fancybox-trigger" href="{$media[$rand].location_media_url}" title="{if $media[$rand].user_id!=0}{$media[$rand].pilot_first_name|escape}, {$media[$rand].pilot_city|escape} - {/if}{$media[$rand].location_media_caption|escape}"><img src="{$media[$rand].location_media_url}" width="300"></a><br>
	<a data-trigger-rel="gallery" class="fancybox-trigger" href="{$media[$rand].location_media_url}" title="{if $media[$rand].user_id!=0}{$media[$rand].pilot_first_name|escape}, {$media[$rand].pilot_city|escape} - {/if}{$media[$rand].location_media_caption|escape}">View Slide Show</a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	{assign var="found" value="0"}
	{foreach $media as $m}
		{if $m.location_media_type=='video' && $found==0}
			<a data-trigger-rel="videos" class="fancybox-trigger" href="{$m.location_media_url}" title="{if $m.user_id!=0}{$m.pilot_first_name|escape}, {$m.pilot_city|escape} - {/if}{$m.location_media_caption|escape}">View Videos</a>
			{assign var="found" value="1"}
		{/if}
	{/foreach}
	{else}
		There are currently No pictures or videos available<br>
		Help us out and add some!<br>
	{/if}
	</td>
</tr>
<tr>
	<th nowrap>Map Coordinates</th>
	<td>
		{$location.location_coordinates|escape} {if $location.location_coordinates!=''}<a class="fancybox-map" href="https://maps.google.com/maps?q={$location.location_coordinates|escape:'url'}+({$location.location_name|escape})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}
	</td>
</tr>
<tr>
	<th valign="top">Flying Disciplines</th>
	<td>
		{foreach $disciplines as $d}
		{$d.discipline_description|escape}<br>
		{/foreach}
	</td>
</tr>
<tr>
	<th>Local RC Club</th>
	<td>
		{$location.location_club|escape}
	</td>
</tr>
<tr>
	<th>Local RC Club Website</th>
	<td>
		<a href="{$location.location_club_url|escape}" target="_blank">{$location.location_club_url|escape}</a>
	</td>
</tr>
<tr>
	<th valign="top">Full Location Description</th>
	<td colspan="2">
		<pre style="white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-wrap: break-word;">{$location.location_description|escape}</pre>
	</td>
</tr>
<tr>
	<th valign="top">Location Directions</th>
	<td colspan="2">
		<pre style="white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-wrap: break-word;">{$location.location_directions|escape}</pre>
	</td>
</tr>
<tr>
	<th valign="top">Attributes</th>
	<td colspan="3">
		{if $location_attributes}
		<table width="100%" cellspacing="0" cellspadding="1" style="border-style: none;">
		{assign var='cat' value=''}
		{assign var='row' value='0'}
		{foreach $location_attributes as $la name="las"}
			{if $la.location_att_cat_name != $cat}
				{if $la.location_att_cat_name != ''}
					{if $row != 0}
					</td></tr>
					{/if}
					<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><hr></td></tr>							
				{/if}
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><b>{$la.location_att_cat_name}</b> : 
				{assign var='row' value='1'}
			{/if}
			{if $la.location_att_type == 'boolean'}
				<span title="{$la.location_att_description|escape}">{$la.location_att_name|escape}</span>
			{else}
				<span title="{$la.location_att_description|escape}">{$la.location_att_name|escape}</span> <input type="text" name="location_att_{$la.location_att_id}" size="{$la.location_att_size}" value="{$la.location_att_value_value|escape}">
			{/if}
			{assign var='cat' value=$la.location_att_cat_name}
			{assign var='nextit' value=$smarty.foreach.las.index + 1}
			{if $location_attributes[$nextit].location_att_cat_name == $cat}
			&nbsp;-&nbsp; 
			{/if}
		{/foreach}
		</td></tr>
		</table>
		{else}
		This information has not been entered for this location.<br>
		Help us out and enter it!
		{/if}
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value="Back To Location List" onClick="goback.submit();" class="block-button">
	</th>
</tr>
</table>

<form name="goback" method="GET">
<input type="hidden" name="action" value="location">
</form>

<h1 class="post-title entry-title">Location Media</h1>
{if !$user.user_id}Log In To Add Media{/if}
{foreach $media as $m}
	{if $m.location_media_type == 'picture'}
		<a href="{$m.location_media_url}" rel="gallery" class="fancybox-button" title="{if $m.user_id!=0}{$m.pilot_first_name|escape}, {$m.pilot_city|escape} - {/if}{$m.location_media_caption|escape}"><img src="/images/icons/picture.png" style="border-style: none;"></a>
	{else}
		<a href="{$m.location_media_url}" rel="videos" class="fancybox-media" title="{if $m.user_id!=0}{$m.pilot_first_name|escape}, {$m.pilot_city|escape} - {/if}{$m.location_media_caption|escape}"><img src="/images/icons/webcam.png" style="border-style: none;"></a>
	{/if}
{/foreach}

<input type="button" name="media" value="Add New Location Media" onClick="add_media.submit()" class="block-button" {if $location.location_id==0}disabled="disabled" style=""{/if}>

<form name="add_media" method="GET">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_media_edit">
<input type="hidden" name="location_id" value="{$location.location_id}">
</form>

</div>

<br>
<h1 class="post-title entry-title">Recent Competitions At This Location</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;">Event Date</th>
	<th style="text-align: left;">Event Name</th>
	<th style="text-align: left;">Event Type</th>
	<th style="text-align: left;">Pilots</th>
</tr>
{if $events}
	{foreach $events as $e}
	<tr bgcolor="{cycle values="white,lightgray"}">
		<td>{$e.event_start_date|date_format:"Y-m-d"}</td>
		<td><a href="?action=event&function=event_view&event_id={$e.event_id}" title="View This Event">{$e.event_name|escape}</a></td>
		<td align="left">{$e.event_type_name|escape}</td>
		<td align="left">{$e.total_pilots}</td>
	</tr>
	{/foreach}
	<tr style="background-color: lightgray;">
        <td align="left" colspan="2">
                {if $page>1}[<a href="?action=location&function=location_view&location_id={$location.location_id}&page={$page-1}"> &lt;&lt; Prev Page</a>]{/if}
                [<a href="?action=location&function=location_view&location_id={$location.location_id}&page={$page+1}">Next Page &gt;&gt</a>]
        </td>
        <td align="right" colspan="2">PerPage
                [<a href="?action=location&function=location_view&location_id={$location.location_id}&perpage=20">20</a>]
                [<a href="?action=location&function=location_view&location_id={$location.location_id}&perpage=40">40</a>]
                [<a href="?action=location&function=location_view&location_id={$location.location_id}&perpage=60">60</a>]
                [<a href="?action=location&function=location_view&location_id={$location.location_id}&page=1">First Page</a>]
        </td>
	</tr>
{else}
	<tr>
		<td colspan="4">We currently do not have any competition events in the system for this location.</td>
	</tr>
{/if}
</table>
<br>

</div>
</div>

<div id="comments" class="clearfix no-ping">
<h4 class="comments gutter-left current">{$comments_num} Location Comments</h4>
<ol class="clearfix" id="comments_list">
		{foreach $comments as $c}
			<li class="comment byuser bypostauthor even thread-even depth-1 clearfix" style="padding-left: 10px;">
			<div class="comment-avatar-wrap">{$c.avatar}</div>
			<h5 class="comment-author">{$c.user_first_name|escape} {$c.user_last_name|escape}</h5>
			<div class="comment-meta"><p class="commentmetadata">{$c.location_comment_date|date_format:"%B %e, %Y - %I:%M %p"}</p></div>
			<div class="comment-entry"><p>{$c.location_comment_string|escape}</p></div>
			</li>
		{/foreach}
	</ol>
<center>
	<input type="button" value="Add A Comment About This Location" onClick="addcomment.submit();" class="block-button">
</center>
</div>

<form name="addcomment" method="GET">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_comment_add">
<input type="hidden" name="location_id" value="{$location.location_id}">
</form>
<form name="location_edit" method="GET">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="{$location.location_id}">
</form>



