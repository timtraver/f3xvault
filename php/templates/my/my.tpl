{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">Edit My Pilot Profile - {$pilot.pilot_first_name|escape} {$pilot.pilot_last_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			
		{if $is_pilotlist}
			<input type="hidden" name="connect" value="1">
			<p>It appears this is the first time you are logging in to edit your Pilot Profile, and we may already have a pilot in the database with your name that has attended an entered event.</p>
			<p>Are any of these pilots you?</p>
		
			<table width="100%" cellpadding="2" cellspacing="2" class="table table-condensed table-striped table-bordered">
			<tr class="table-row-heading-left">
				<th colspan="4" style="text-align: left;">Possible Pilots</td>
			</tr>
			<tr>
				<th nowrap>&nbsp;</th>
				<th nowrap style="text-align: left;">Pilot Last Name</th>
				<th nowrap style="text-align: left;">Pilot First Name</th>
			<th nowrap style="text-align: left;">Last Event</th>
			<tr>
			{foreach $pilotlist as $p}
			<tr>
				<th nowrap>
					<input type="radio" name="pilot_id" value="{$p.pilot_id}">
				</th>
				<td>{$p.pilot_last_name|escape}</td>
				<td>{$p.pilot_first_name|escape}</td>
				<td>{$p.eventstring|escape}</td>
			</tr>
			{/foreach}
			<tr>
				<th nowrap>
					<input type="radio" name="pilot_id" value="0" CHECKED>
				</th>
				<td colspan="3">Sorry, but none of these pilots are me. Please start with my default information.</td>
			</tr>
			<tr>
				<th colspan="4" style="text-align: center;">
				<input type="submit" value="Connect the Selected Pilot with My Account" class="btn btn-primary btn-rounded">
				</th>
			</tr>
			</table>
		{else}
			
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li{if $tab==0} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-0" aria-expanded="true" {if $tab==0}aria-selected="true"{/if}>
							General Profile
						</a>
					</li>
					<li{if $tab==1} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-1" aria-expanded="false" {if $tab==1}aria-selected="true"{/if}>
							My Aircraft
							<span class="badge badge-blue">{$pilot_planes|count}</span>
						</a>
					</li>
					<li{if $tab==2} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-2" aria-expanded="false" {if $tab==2}aria-selected="true"{/if}>
							My Club Affiliations
							<span class="badge badge-blue">{$pilot_clubs|count}</span>
						</a>
					</li>
					<li{if $tab==3} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-3" aria-expanded="true" {if $tab==3}aria-selected="true"{/if}>
							My Flying Locations
							<span class="badge badge-blue">{$pilot_locations|count}</span>
						</a>
					</li>
				</ul>
				<div class="tab-content">
					<div id="pilot-tab-0" class="tab-pane fade{if $tab==0} active in{/if}">
						<h2 style="float:left;">Pilot Profile</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						
						<form name="main" method="POST">
						<input type="hidden" name="action" value="my">
						<input type="hidden" name="function" value="my_user_save">
						<input type="hidden" name="pilot_id" value="{$pilot.pilot_id}">
						<input type="hidden" name="tab" value="0">
						
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
						<tr>
							<th align="right">First Name</th>
							<td><input type="text" size="30" name="pilot_first_name" value="{$pilot.pilot_first_name|escape}"></td>
						</tr>
						<tr>
							<th align="right">Last Name</th>
							<td><input type="text" size="30" name="pilot_last_name" value="{$pilot.pilot_last_name|escape}"></td>
						</tr>
						<tr>
							<th align="right">Email Address</th>
							<td><input type="text" size="30" name="pilot_email" value="{$pilot.pilot_email|escape}"></td>
						</tr>
						<tr>
							<th align="right">City</th>
							<td><input type="text" size="30" name="pilot_city" value="{$pilot.pilot_city|escape}"></td>
						</tr>
						<tr>
							<th align="right">State</th>
							<td>
								<select name="state_id">
								{foreach $states as $state}
									<option value="{$state.state_id}" {if $state.state_id==$pilot.state_id}SELECTED{/if}>{$state.state_name}</option>
								{/foreach}
								</select>
							</td>
						</tr>
						<tr>
							<th align="right">Country</th>
							<td>
								<select name="country_id">
								{foreach $countries as $country}
									<option value="{$country.country_id}" {if $country.country_id==$pilot.country_id}SELECTED{/if}>{$country.country_name}</option>
								{/foreach}
								</select>
							</td>
						</tr>
						<tr>
							<th align="right">AMA Number</th>
							<td><input type="text" size="10" name="pilot_ama" value="{$pilot.pilot_ama|escape}"></td>
						</tr>
						<tr>
							<th align="right">FAI Number</th>
							<td><input type="text" size="10" name="pilot_fai" value="{$pilot.pilot_fai|escape}"></td>
						</tr>
						</table>
						<center>
							<input type="submit" value=" Save My User Values " class="btn btn-primary btn-rounded">
							<input type="button" value=" Change My Password " class="btn btn-primary btn-rounded" onClick="document.change_pass.submit();">
						</center>
						</form>
					</div>
					<div id="pilot-tab-1" class="tab-pane fade{if $tab==1} active in{/if}">
						<h2 style="float:left;">My Planes</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th style="text-align: left;">Plane</th>
							<th style="text-align: left;">Plane Type</th>
							<th style="text-align: left;">Plane Manufacturer</th>
							<th style="text-align: left;">Color Scheme</th>
							<th style="text-align: left;">&nbsp;</th>
						</tr>
						{if $pilot_planes}
							{foreach $pilot_planes as $pp}
							<tr>
								<td><a href="?action=my&function=my_plane_edit&pilot_plane_id={$pp.pilot_plane_id}" title="Edit My Aircraft" class="btn-link">{$pp.plane_name|escape}</a></td>
								<td>
									{foreach $pp.disciplines as $d}
										{$d.discipline_code_view}{if !$d@last},{/if}
									{/foreach}
								</td>
								<td>{$pp.plane_manufacturer|escape}</td>
								<td>{$pp.pilot_plane_color|escape}</td>
								<td> <a href="?action=my&function=my_plane_del&pilot_plane_id={$pp.pilot_plane_id}&tab=1" title="Remove Plane" onClick="confirm('Are you sure you wish to remove this plane?')"><img src="images/del.gif"></a></td>
							</tr>
							{/foreach}
						{else}
							<tr>
								<td colspan="5">You currently have no planes in your quiver.</td>
							</tr>
						{/if}
						</table>
						<center>
							<input type="button" value="Add A New Plane to my Quiver" onClick="add_plane.submit()" class="btn btn-primary btn-rounded">
						</center>

					</div>
					<div id="pilot-tab-2" class="tab-pane fade{if $tab==2} active in{/if}">
						<h2 style="float:left;">My Clubs</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
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
								<td><a href="?action=club&function=club_view&club_id={$pc.club_id}" title="View This Club" class="btn-link">{$pc.club_name|escape}</a></td>
								<td>{$pc.club_city|escape}</td>
								<td>{$pc.state_name|escape}, {$pc.country_code|escape}
									{if $pc.country_code}<img src="/images/flags/countries-iso/shiny/16/{$pc.country_code|escape}.png" style="vertical-align: middle;">{/if}
									{if $pc.state_name && $pc.country_code=="US"}<img src="/images/flags/states/16/{$pc.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
								</td>
							</tr>
							{/foreach}
						{else}
							<tr>
								<td colspan="4">You currently have no club affiliations.</td>
							</tr>
						{/if}
						</table>

					</div>
					<div id="pilot-tab-3" class="tab-pane fade{if $tab==3} active in{/if}">
						<h2 style="float:left;">My Flying Locations</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">

						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
						<tr>
							<th style="text-align: left;">Location Name</th>
							<th style="text-align: left;">Location City</th>
							<th style="text-align: left;">State/Country</th>
							<th style="text-align: center;">Map</th>
							<th style="text-align: left;">&nbsp;</th>
						</tr>
						{if $pilot_locations}
							{foreach $pilot_locations as $pl}
							<tr>
								<td><a href="?action=location&function=location_view&location_id={$pl.location_id}" title="View This Location" class="btn-link">{$pl.location_name|escape}</a></td>
								<td>{$pl.location_city|escape}</td>
								<td>{$pl.state_name|escape} {$pl.country_code|escape}
									{if $pl.country_code}<img src="/images/flags/countries-iso/shiny/16/{$pl.country_code|escape}.png" style="vertical-align: middle;">{/if}
									{if $pl.state_name && $pl.country_code=="US"}<img src="/images/flags/states/16/{$pl.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
								</td>
								<td align="center">{if $pl.location_coordinates!=''}<a class="fancybox-map" href="http://maps.google.com/maps?q={$pl.location_coordinates|escape:'url'}+({$pl.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps." target="_blank"><img src="/images/icons/world.png"></a>{/if}</td>
								<td> <a href="?action=my&function=my_location_del&pilot_location_id={$pl.pilot_location_id}&tab=3" title="Remove Location" onClick="confirm('Are you sure you wish to remove this location?')"><img src="images/del.gif"></a></td>
							</tr>
							{/foreach}
						{else}
							<tr>
								<td colspan="4">You currently have no selected locations.</td>
							</tr>
						{/if}
						</table>
						<h2 style="float:left;">Add Flying Locations</h2>
						
						<form name="add_location" method="POST">
						<input type="hidden" name="action" value="my">
						<input type="hidden" name="function" value="my_location_add">
						<input type="hidden" name="location_id" value="">
						<input type="hidden" name="tab" value="3">

						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
						<tr>
							<th>Location</th>
							<td>
								<input type="text" id="location_name" name="location_name" size="60" value="">
								<img id="loading_location" src="/images/loading.gif" style="vertical-align: middle;display: none;">
								<span id="search_message" style="font-style: italic;color: grey;">Start typing to search locations</span>
							</td>
						</tr>
						</table>
						<center>
							<input type="button" value="Add This Location Where I fly" onClick="add_location.submit()" class="btn btn-primary btn-rounded">
						</center>
						</form>
					</div>
				</div>
			</div>
		</p>
	</div>
</div>

<form name="goback" method="POST">
<input type="hidden" name="action" value="pilot">
<input type="hidden" name="function" value="pilot_view">
<input type="hidden" name="pilot_id" value="{$pilot.pilot_id}">
<input type="hidden" name="tab" value="0">
</form>
<form name="add_plane" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_plane_edit">
<input type="hidden" name="pilot_plane_id" value="0">
</form>

{/if}

<form name="change_pass" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="show_change_password">
</form>

{/block}

{block name="footer"}
<!-- <script src="/includes/jquery.min.js"></script> -->
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#location_name").autocomplete({
		source: "/lookup.php?function=lookup_location",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_location');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.add_location.location_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.add_location.location_name.value==''){
				document.add_location.location_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_location');
			loading.style.display = "none";
   			var mes=document.getElementById('search_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new location.';
			}
		}
	});
});
</script>
{/literal}
{/block}