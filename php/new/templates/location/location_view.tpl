{extends file='layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Location Details - {$location.location_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li class="active">
						<a data-toggle="tab" href="#location-tab-1" aria-expanded="true" aria-selected="true">
							Information
						</a>
					</li>
					<li class>
						<a data-toggle="tab" href="#location-tab-2" aria-expanded="false">
							Media
							<span class="badge badge-blue">{$media|count}</span>
						</a>
					</li>
					<li class>
						<a data-toggle="tab" href="#location-tab-3" aria-expanded="false">
							Comments
							<span class="badge badge-blue">{$comments|count}</span>
						</a>
					</li>
					<li class>
						<a data-toggle="tab" href="#location-tab-4" aria-expanded="false">
							Competitions
							<span class="badge badge-blue">{$events|count}</span>
						</a>
					</li>
				</ul>
				<div class="tab-content">
					<div id="location-tab-1" class="tab-pane fade active in">
						<h2 style="float:left;">Location Information</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Edit Location Information " class="btn btn-primary btn-rounded" onClick="location_edit.submit();">
							<input type="button" value=" Back To Location List " onClick="goback.submit();" class="btn btn-primary btn-rounded">
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
								<pre style="white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-wrap: break-word;">{$location.location_description|escape}</pre>
							</td>
						</tr>
						<tr>
							<th valign="top" nowrap>Detailed Directions</th>
							<td colspan="2">
								<pre style="white-space: pre-wrap;white-space: -moz-pre-wrap;white-space: -pre-wrap;white-space: -o-pre-wrap;word-wrap: break-word;">
									{$location.location_directions|escape}
								</pre>
							</td>
						</tr>
						<tr>
							<th valign="top" nowrap>Location Attributes</th>
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
										{/if}
										<tr style="border-style: none;">
											<td colspan="4" style="border-style: none;"><b>{$la.location_att_cat_name}</b></td> 
										{assign var='row' value='1'}
									{/if}
									{if $la.location_att_type == 'boolean'}
										<td><span title="{$la.location_att_description|escape}">{$la.location_att_name|escape}</span></td>
									{else}
										<td><span title="{$la.location_att_description|escape}">{$la.location_att_name|escape}</span> <input type="text" name="location_att_{$la.location_att_id}" size="{$la.location_att_size}" value="{$la.location_att_value_value|escape}"></td>
									{/if}
										</tr>
									{assign var='cat' value=$la.location_att_cat_name}
									{assign var='nextit' value=$smarty.foreach.las.index + 1}
									{if $location_attributes[$nextit].location_att_cat_name == $cat}
									&nbsp;-&nbsp; 
									{/if}
								{/foreach}
								</table>
								{else}
								This information has not been entered for this location.<br>
								Help us out and enter it!
								{/if}
							</td>
						</tr>
						</table>
						
						<form name="goback" method="GET">
						<input type="hidden" name="action" value="location">
						</form>
						<form name="location_edit" method="GET">
						<input type="hidden" name="action" value="location">
						<input type="hidden" name="function" value="location_edit">
						<input type="hidden" name="location_id" value="{$location.location_id}">
						</form>
					</div>
					<div id="location-tab-2" class="tab-pane fade">
						<h2 style="float:left;">Location Media</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Add New Location Media " class="btn btn-primary btn-rounded" onClick="add_media.submit();">
							<input type="button" value=" Back To Location List " onClick="goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						
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
										<img src="{$m.location_media_url}"><br>
									{else}
										<iframe width="640" height="480" src="{$m.location_media_url}?autoplay=1&html5=1"></iframe>
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
												
						<form name="add_media" method="GET">
						<input type="hidden" name="action" value="location">
						<input type="hidden" name="function" value="location_media_edit">
						<input type="hidden" name="location_id" value="{$location.location_id}">
						</form>
						
					</div>
					<div id="location-tab-3" class="tab-pane fade">
						<h2>Location Comments</h2>
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
						
						<form name="addcomment" method="GET">
						<input type="hidden" name="action" value="location">
						<input type="hidden" name="function" value="location_comment_add">
						<input type="hidden" name="location_id" value="{$location.location_id}">
						</form>
						
					</div>
					<div id="location-tab-4" class="tab-pane fade">
						<h2 style="float:left;">Location Competitions</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Edit Location Information " class="btn btn-primary btn-rounded" onClick="location_edit.submit();">
							<input type="button" value=" Back To Location List " onClick="goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
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
			</div>
		</p>
	</div>
</div>

{/block}


