{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:600px;">
	<div class="panel-heading">
		<h2 class="heading">F3X Location Details - {$location.location_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li{if $tab==0} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-1" aria-expanded="true" {if $tab==0}aria-selected="true"{/if}>
							Information
						</a>
					</li>
					<li{if $tab==1} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-2" aria-expanded="false" {if $tab==1}aria-selected="true"{/if}>
							Media
							<span class="badge badge-blue">{$media|count}</span>
						</a>
					</li>
					<li{if $tab==2} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-3" aria-expanded="false" {if $tab==2}aria-selected="true"{/if}>
							Comments
							<span class="badge badge-blue">{$comments|count}</span>
						</a>
					</li>
					<li{if $tab==3} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-4" aria-expanded="true" {if $tab==3}aria-selected="true"{/if}>
							Competitions
							<span class="badge badge-blue">{$totalrecords|escape}</span>
						</a>
					</li>
				</ul>
				<div class="tab-content">
					<div id="location-tab-1" class="tab-pane fade{if $tab==0} active in{/if}">
						<h2 style="float:left;">Location Information</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Edit Location Information " class="btn btn-primary btn-rounded" onClick="location_edit.submit();">
							<input type="button" value=" Back To Location List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
						<tr>
							<th nowrap>Site Name</th>
							<td>{$location.location_name|escape}</td>
						</tr>
						<tr>
							<th nowrap>Location</th>
							<td>
								{$location.location_city|escape}<br>
								{$location.state_name|escape} {if $location.state_name && $location.country_code=="US"}<img src="/images/flags/states/24/{$location.state_name|replace:' ':'-'}-Flag-24.png" style="vertical-align: middle;">{/if}<br>
								{$location.country_name|escape}
								{if $location.country_code}<img src="/images/flags/countries-iso/shiny/24/{$location.country_code|escape}.png" style="vertical-align: middle;">{/if}
							</td>
						</tr>
						<tr>
							<th nowrap>Map Coordinates</th>
							<td>
								{$location.location_coordinates|escape} {if $location.location_coordinates!=''}<a class="fancybox-map" href="https://maps.google.com/maps?q={$location.location_coordinates|escape:'url'}+({$location.location_name|escape})&t=h&z=14" target="_blank" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}
							</td>
						</tr>
						<tr>
							<th valign="top" nowrap>Flying Disciplines</th>
							<td>
								{foreach $disciplines as $d}
								{$d.discipline_description|escape}<br>
								{/foreach}
							</td>
						</tr>
						<tr>
							<th nowrap>Local RC Club Name</th>
							<td>
								{$location.location_club|escape}
							</td>
						</tr>
						<tr>
							<th nowrap>Local RC Club Website</th>
							<td>
								<a href="{$location.location_club_url|escape}" target="_blank">{$location.location_club_url|escape}</a>
							</td>
						</tr>
						<tr>
							<th valign="top" nowrap>Full Description</th>
							<td colspan="2">
								<pre style="white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-wrap: break-word;word-break: keep-all;">{$location.location_description|escape}</pre>
							</td>
						</tr>
						<tr>
							<th valign="top" nowrap>Detailed Directions</th>
							<td colspan="2">
								<pre style="white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-wrap: break-word;word-break: keep-all;">{$location.location_directions|escape}</pre>
							</td>
						</tr>
						<tr>
							<th valign="top" nowrap>Location Attributes</th>
							<td colspan="3">
								{if $location_attributes}
								<table cellspacing="2" cellpadding="2" class="table table-condensed">
								{assign var='cat' value=''}
								{assign var='row' value='0'}
								{foreach $location_attributes as $la name="las"}
									{if $la.location_att_cat_name != $cat}
										{if $la.location_att_cat_name != ''}
											{if $row != 0}
											</td></tr>
											{/if}
										{/if}
										<tr style="border-style: none;">
											<th width="20%" nowrap><b>{$la.location_att_cat_name|escape}</b></th> 
										{assign var='row' value='1'}
									{else}
										<th></th>
									{/if}
									{if $la.location_att_type == 'boolean'}
										<td><span title="{$la.location_att_description|escape}">{$la.location_att_name|escape}</span></td>
									{else}
										<td><span title="{$la.location_att_description|escape}">{$la.location_att_name|escape}</span> <input type="text" name="location_att_{$la.location_att_id|escape}" size="{$la.location_att_size|escape}" value="{$la.location_att_value_value|escape}"></td>
									{/if}
										</tr>
									{assign var='cat' value=$la.location_att_cat_name}
								{/foreach}
								</table>
								{else}
								This information has not been entered for this location.<br>
								Help us out and enter it!
								{/if}
							</td>
						</tr>
						</table>
					</div>
					<div id="location-tab-2" class="tab-pane fade{if $tab==1} active in{/if}">
						<h2 style="float:left;">Location Media</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Add New Location Media " class="btn btn-primary btn-rounded" onClick="add_media.submit();">
							<input type="button" value=" Back To Location List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						{if $media}
						<div id="media-carousel" class="carousel slide" data-ride="carousel">
							<ol class="carousel-indicators dark out">
								{foreach $media as $m}
								<li class="{if $m@index == 0}active{/if}" data-slide-to="{$m@index}" data-target="#media-carousel"></li>
								{/foreach}
							</ol>
							<div class="carousel-inner">
								{foreach $media as $m}
								<div class="item{if $m@index == 0} active{/if}">
									<center>
									{if $m.location_media_type == 'picture'}
										<img src="{$m.location_media_url|escape:"URL"}"><br>
									{else}
										<div class="video-wrapper">
											<div class="video-container">
												<iframe src="{$m.location_media_url|escape:"URL"}" width="640" height="360" frameborder="0" allowfullscreen></iframe>
											</div>
										</div>
									{/if}
									<br>
									<br>
									{if $m.user_id!=0}
										{$m.pilot_first_name|escape}, {$m.pilot_city|escape}<br>
									{/if}
									{$m.location_media_caption|escape}
									</center>
								</div>
								{/foreach}
								<a class="carousel-control left" data-slide="prev" href="#media-carousel"><i class="fa fa-chevron-left fa-2x"></i></a>
								<a class="carousel-control right" data-slide="next" href="#media-carousel"><i class="fa fa-chevron-right fa-2x"></i></a>
							</div>
						</div>
						{else}
						Currently No Media for this Location
						{/if}
												
						<form name="add_media" method="GET">
						<input type="hidden" name="action" value="location">
						<input type="hidden" name="function" value="location_media_edit">
						<input type="hidden" name="location_id" value="{$location.location_id|escape}">
						</form>
						
					</div>
					<div id="location-tab-3" class="tab-pane fade{if $tab==2} active in{/if}">
						<h2>Location Comments</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Add Comment " class="btn btn-primary btn-rounded" onClick="addcomment.submit();">
							<input type="button" value=" Back To Location List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						
						<h4 class="comments gutter-left current">{$comments_num|escape} Location Comments</h4>
							{foreach $comments as $c}
							<div class="panel panel-primary">
					
								<!--Panel heading-->
								<div class="panel-heading">
									<div class="panel-control">
										<em class="text-muted"><small>{$c.location_comment_date|date_format:"%B %e, %Y - %I:%M %p"}</small></em>
									</div>
									<h4 class="panel-title"><b>{$c.user_first_name|escape} {$c.user_last_name|escape}</b>
										{if $c.pilot_city}{$c.pilot_city|escape}, {/if}
										{if $c.state_name && $c.country_code=="US"}
											<img src="/images/flags/states/24/{$c.state_name|replace:' ':'-'}-Flag-24.png" style="vertical-align: middle;">
											{$c.state_name|escape}
										{/if}
										{if $c.country_code}
											<img src="/images/flags/countries-iso/shiny/16/{$c.country_code|escape}.png" style="vertical-align: middle;" title="{$c.country_code|escape}">
											{$c.country_name|escape}
										{/if}
									</h4>
								</div>
								<!--Panel body-->
								<div class="panel-body">
									<p>{$c.location_comment_string|escape}</p>
								</div>
							</div>
							{/foreach}
						
					</div>
					<div id="location-tab-4" class="tab-pane fade{if $tab==3} active in{/if}">
						<h2 style="float:left;">Location Competitions</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Location List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr class="table-row-heading-left" style="background-color: lightgray;">
							<th colspan="1" style="text-align: left;" nowrap>Locations (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
							<th colspan="6" nowrap>
								{include file="paging.tpl" tab=3}
							</th>
						</tr>
						<tr>
							<th width="20%" style="text-align: left;">Event Date</th>
							<th style="text-align: left;">Event Name</th>
							<th style="text-align: left;">Event Type</th>
							<th style="text-align: left;">Pilots</th>
						</tr>
						{if $events}
							{foreach $events as $e}
							<tr>
								<td>{$e.event_start_date|date_format:"Y-m-d"}</td>
								<td><a href="?action=event&function=event_view&event_id={$e.event_id|escape:"URL"}" class="btn-link" title="View This Event">{$e.event_name|escape}</a></td>
								<td align="left">{$e.event_type_name|escape}</td>
								<td align="left">{$e.total_pilots|escape}</td>
							</tr>
							{/foreach}
							<tr style="background-color: lightgray;">
								<td colspan="4">
									{include file="paging.tpl" tab=3}
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
			</div>
		</p>
		
		<form name="goback" method="GET">
		<input type="hidden" name="action" value="location">
		</form>
		
		<form name="location_edit" method="GET">
		<input type="hidden" name="action" value="location">
		<input type="hidden" name="function" value="location_edit">
		<input type="hidden" name="location_id" value="{$location.location_id|escape}">
		</form>
		
		<form name="addcomment" method="GET">
		<input type="hidden" name="action" value="location">
		<input type="hidden" name="function" value="location_comment_add">
		<input type="hidden" name="location_id" value="{$location.location_id|escape}">
		</form>

	</div>
</div>

{/block}


