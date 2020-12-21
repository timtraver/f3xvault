{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">Pilot Detail - {$pilot.pilot_first_name|escape} {$pilot.pilot_last_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li{if $tab==0} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-0" aria-expanded="true" {if $tab==0}aria-selected="true"{/if}>
							Profile
						</a>
					</li>
					<li{if $tab==1} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-1" aria-expanded="false" {if $tab==1}aria-selected="true"{/if}>
							Aircraft
							<span class="badge badge-blue">{$pilot_planes|count}</span>
						</a>
					</li>
					<li{if $tab==2} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-2" aria-expanded="false" {if $tab==2}aria-selected="true"{/if}>
							Club Affiliations
							<span class="badge badge-blue">{$pilot_clubs|count}</span>
						</a>
					</li>
					<li{if $tab==3} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-3" aria-expanded="true" {if $tab==3}aria-selected="true"{/if}>
							Flying Locations
							<span class="badge badge-blue">{$pilot_locations|count}</span>
						</a>
					</li>
					<li{if $tab==4} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-4" aria-expanded="true" {if $tab==4}aria-selected="true"{/if}>
							Competitions
							<span class="badge badge-blue">{$pilot_events|count}</span>
						</a>
					</li>
					{if $f3f_records}
					<li{if $tab==5} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-5" aria-expanded="true" {if $tab==5}aria-selected="true"{/if}>
							F3F Speeds 
						</a>
					</li>
					{/if}
					{if $f3b_records}
					<li{if $tab==6} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-6" aria-expanded="true" {if $tab==6}aria-selected="true"{/if}>
							F3B Speeds
						</a>
					</li>
					{/if}
					{if $f3b_distance}
					<li{if $tab==7} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-7" aria-expanded="true" {if $tab==7}aria-selected="true"{/if}>
							F3B Distances
						</a>
					</li>
					{/if}
				</ul>
				<div class="tab-content">
					<div id="pilot-tab-0" class="tab-pane fade{if $tab==0} active in{/if}">
						<h2 style="float:left;">Pilot Profile</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Edit Profile " onClick="document.pilot_edit.submit();" class="btn btn-primary btn-rounded">
							<input type="button" value=" Back To Pilot List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th width="20%">Pilot Name</th>
							<td>{$pilot.pilot_first_name|escape} {$pilot.pilot_last_name|escape}</td>
						</tr>
						<tr>
							<th>Pilot Location</th>
							<td>
								{$pilot.pilot_city|escape}, {$pilot.state_name|escape} - {$pilot.country_name|escape}
								{if $pilot.country_code}<img src="/images/flags/countries-iso/shiny/24/{$pilot.country_code|escape}.png" style="vertical-align: middle;">{/if}
								{if $pilot.state_name && $pilot.country_code=="US"}<img src="/images/flags/states/24/{$pilot.state_name|replace:' ':'-'}-Flag-24.png" style="vertical-align: middle;">{/if}
							</td>
						</tr>
						<tr>
							<th>Pilot AMA Number</th>
							<td>{$pilot.pilot_ama|escape}</td>
						</tr>
						<tr>
							<th>Pilot FAI Designation</th>
							<td>{$pilot.pilot_fai|escape}</td>
						</tr>
						<tr>
							<th>Pilot FAI License</th>
							<td>{$pilot.pilot_fai_license|escape}</td>
						</tr>
						</table>
					</div>
					<div id="pilot-tab-1" class="tab-pane fade{if $tab==1} active in{/if}">
						<h2 style="float:left;">Pilot Aircraft</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">

						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th style="text-align: left;">Plane</th>
							<th style="text-align: left;">Plane Type</th>
							<th style="text-align: left;">Plane Manufacturer</th>
							<th style="text-align: left;">Color Scheme</th>
						</tr>
						{if $pilot_planes}
							{foreach $pilot_planes as $pp}
								<tr bgcolor="{cycle values="white,lightgray"}">
								<td><a href="?action=plane&function=plane_view&plane_id={$pp.plane_id|escape:'url'}" title="View Aircraft" class="btn-link">{$pp.plane_name|escape}</a></td>
								<td>
									{foreach $pp.disciplines as $d}
										{$d.discipline_code_view|escape}{if !$d@last},{/if}
									{/foreach}
								</td>
								<td>{$pp.plane_manufacturer|escape}</td>
								<td>{$pp.pilot_plane_color|escape}</td>
							</tr>
							{/foreach}
						{else}
							<tr>
								<td colspan="5">This pilot currently has no planes in his quiver.</td>
							</tr>
						{/if}
						</table>
						<br>
						
						{if $media}
						<h2 style="float:left;">Plane Media</h2>
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
									{if $m.pilot_plane_media_type == 'picture'}
										<img src="{$m.pilot_plane_media_url|escape:'url'}"><br>
									{else}
										<div class="video-wrapper">
											<div class="video-container">
												<iframe src="{$m.pilot_plane_media_url|escape:'url'}" width="640" height="360" frameborder="0" allowfullscreen></iframe>
											</div>
										</div>
									{/if}
									<br>
									{$m.plane_name|escape}
									<br>
									{$m.plane_media_caption|escape}
									</center>
								</div>
								{/foreach}
								<a class="carousel-control left" data-slide="prev" href="#media-carousel"><i class="fa fa-chevron-left fa-2x"></i></a>
								<a class="carousel-control right" data-slide="next" href="#media-carousel"><i class="fa fa-chevron-right fa-2x"></i></a>
							</div>
						</div>
						{/if}
						
					</div>
					<div id="pilot-tab-2" class="tab-pane fade{if $tab==2} active in{/if}">
						<h2 style="float:left;">Pilot Club Affiliations</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">


						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th style="text-align: left;">Club Name</th>
							<th style="text-align: left;">Club City</th>
							<th style="text-align: left;">State/Country</th>
						</tr>
						{if $pilot_clubs}
							{foreach $pilot_clubs as $pc}
							<tr>
								<td><a href="?action=club&function=club_view&club_id={$pc.club_id|escape:'url'}" title="View This Club" class="btn-link">{$pc.club_name|escape}</a></td>
								<td>{$pc.club_city|escape}</td>
								<td>{$pc.state_name|escape}, {$pc.country_code|escape}
									{if $pc.country_code}<img src="/images/flags/countries-iso/shiny/16/{$pc.country_code|escape}.png" style="vertical-align: middle;">{/if}
									{if $pc.state_name && $pc.country_code=="US"}<img src="/images/flags/states/16/{$pc.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
								</td>
							</tr>
							{/foreach}
						{else}
							<tr>
								<td colspan="4">This pilot currently has no club affiliations.</td>
							</tr>
						{/if}
						</table>
					</div>
					<div id="pilot-tab-3" class="tab-pane fade{if $tab==3} active in{/if}">
						<h2 style="float:left;">Pilot Flying Locations</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">

						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th style="text-align: left;">Location Name</th>
							<th style="text-align: left;">Location City</th>
							<th style="text-align: left;">State/Country</th>
							<th style="text-align: center;">Map</th>
						</tr>
						{if $pilot_locations}
							{foreach $pilot_locations as $pl}
							<tr>
								<td><a href="?action=location&function=location_view&location_id={$pl.location_id|escape:'url'}" title="View This Location" class="btn-link">{$pl.location_name|escape}</a></td>
								<td>{$pl.location_city|escape}</td>
								<td>{$pl.state_name|escape}, {$pl.country_code|escape}
									{if $pl.country_code}<img src="/images/flags/countries-iso/shiny/16/{$pl.country_code|escape}.png" style="vertical-align: middle;">{/if}
									{if $pl.state_name && $pl.country_code=="US"}<img src="/images/flags/states/16/{$pl.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
								</td>
								<td align="center">{if $pl.location_coordinates!=''}<a class="fancybox-map" href="http://maps.google.com/maps?q={$pl.location_coordinates|escape:'url'}+({$pl.location_name|escape:'url'})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}</td>
							</tr>
							{/foreach}
						{else}
							<tr>
								<td colspan="4">This pilot currently has no selected locations.</td>
							</tr>
						{/if}
						</table>
					</div>
					<div id="pilot-tab-4" class="tab-pane fade{if $tab==4} active in{/if}">
						<h2 style="float:left;">Pilot Competitions</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">

						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th style="text-align: left;">Event Date</th>
							<th style="text-align: left;">Event Name</th>
							<th style="text-align: left;">Event Location</th>
							<th style="text-align: left;">State/Country</th>
							<th style="text-align: left;">Position</th>
							<th style="text-align: left;">Percentage</th>
						</tr>
						{if $pilot_events}
							{foreach $pilot_events as $pe}
							<tr>
								<td>{$pe.event_start_date|date_format:"Y-m-d"}</td>
								<td><a href="?action=event&function=event_view&event_id={$pe.event_id|escape:'url'}" title="View This Event" class="btn-link">{$pe.event_name|escape}</a></td>
								<td>
									<a href="?action=location&function=location_view&location_id={$pe.location_id|escape:'url'}" title="View This Location" class="btn-link">{$pe.location_name|escape}</a>
								</td>
								<td>{$pe.state_name|escape}, {$pe.country_code|escape}
									{if $pe.country_code}<img src="/images/flags/countries-iso/shiny/16/{$pe.country_code|escape}.png" style="vertical-align: middle;">{/if}
									{if $pe.state_name && $pe.country_code=="US"}<img src="/images/flags/states/16/{$pe.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
								</td>
								<td align="center">{$pe.event_pilot_position|escape}</td>
								<td align="right">{$pe.event_pilot_total_percentage|string_format:"%03.2f"}%</td>
							</tr>
							{/foreach}
						{else}
							<tr>
								<td colspan="4">This Pilot currently has no events.</td>
							</tr>
						{/if}
						</table>
					</div>
					{if $f3f_records}
					<div id="pilot-tab-5" class="tab-pane fade{if $tab==5} active in{/if}">
						<h2 style="float:left;">Pilot F3F Speeds</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th style="text-align: left;">Event Date</th>
							<th style="text-align: left;">Speed</th>
							<th style="text-align: left;">Event Name</th>
							<th style="text-align: left;">Location</th>
						</tr>
						{foreach $f3f_records as $f}
							<tr>
								<td>{$f.event_start_date|date_format:"Y-m-d"}</td>
								<td align="left"><font size="+1"><b>{$f.event_pilot_round_flight_seconds|string_format:"%03.2f"}</b></font></td>
								<td><a href="?action=event&function=event_view&event_id={$f.event_id|escape:'url'}" title="View This Event" class="btn-link">{$f.event_name|escape}</a></td>
								<td>
									{if $f.country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.country_code|escape}.png" style="vertical-align: middle;" title="{$f.country_code|escape}">{/if}
									<a href="?action=location&function=location_view&location_id={$f.location_id|escape:'url'}" title="View This Location" class="btn-link">{$f.location_name|escape}</a>,
									{$f.country_code|escape}
								</td>
							</tr>
						{/foreach}
						<tr style="background-color: lightgray;">
							<td colspan="4">
								{include file="paging.tpl" tab=5 label='main'}
							</td>
						</tr>
						</table>
					</div>
					{/if}
					{if $f3b_records}
					<div id="pilot-tab-6" class="tab-pane fade{if $tab==6} active in{/if}">
						<h2 style="float:left;">Pilot F3B Speeds</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th style="text-align: left;">Event Date</th>
							<th style="text-align: left;">Speed</th>
							<th style="text-align: left;">Event Name</th>
							<th style="text-align: left;">Location</th>
						</tr>
						{foreach $f3b_records as $f}
							<tr>
								<td>{$f.event_start_date|date_format:"Y-m-d"}</td>
								<td align="left"><font size="+1"><b>{$f.event_pilot_round_flight_seconds|string_format:"%03.2f"}</b></font></td>
								<td><a href="?action=event&function=event_view&event_id={$f.event_id|escape:'url'}" title="View This Event" class="btn-link">{$f.event_name|escape}</a></td>
								<td>
									{if $f.country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.country_code|escape}.png" style="vertical-align: middle;" title="{$f.country_code|escape}">{/if}
									<a href="?action=location&function=location_view&location_id={$f.location_id|escape:'url'}" title="View This Location" class="btn-link">{$f.location_name|escape}</a>,
									{$f.country_code|escape}
								</td>
							</tr>
						{/foreach}
						<tr style="background-color: lightgray;">
							<td colspan="4">
								{include file="paging.tpl" tab=6 label='main'}
							</td>
						</tr>
						</table>
					</div>
					{/if}
					{if $f3b_distance}
					<div id="pilot-tab-7" class="tab-pane fade{if $tab==7} active in{/if}">
						<h2 style="float:left;">Pilot F3B Distance</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">

						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th style="text-align: left;">Event Date</th>
							<th style="text-align: left;">Laps</th>
							<th style="text-align: left;">Event Name</th>
							<th style="text-align: left;">Location</th>
						</tr>
						{foreach $f3b_distance as $f}
							<tr>
								<td>{$f.event_start_date|date_format:"Y-m-d"}</td>
								<td align="left"><font size="+1"><b>{$f.event_pilot_round_flight_laps|string_format:"%d"}</b></font></td>
								<td><a href="?action=event&function=event_view&event_id={$f.event_id|escape:'url'}" title="View This Event" class="btn-link">{$f.event_name|escape}</a></td>
								<td>
									{if $f.country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.country_code|escape}.png" style="vertical-align: middle;" title="{$f.country_code|escape}">{/if}
									<a href="?action=location&function=location_view&location_id={$f.location_id|escape:'url'}" title="View This Location" class="btn-link">{$f.location_name|escape}</a>,
									{$f.country_code|escape}
								</td>
							</tr>
						{/foreach}
						<tr style="background-color: lightgray;">
							<td colspan="4">
								{include file="paging.tpl" tab=7 label='main'}
							</td>
						</tr>
						</table>

					</div>
					{/if}
				</div>
			</div>
		</p>
	</div>
</div>
<form name="pilot_edit" method="GET">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_user_show">
<input type="hidden" name="user_id" value="{$user.user_id|escape}">
<input type="hidden" name="tab" value="0">
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="pilot">
<input type="hidden" name="function" value="pilot_list">
</form>

{/block}

