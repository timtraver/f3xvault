{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">

		<h2 class="post-title entry-title">Pilot Comparison and Merge</h2>

		<form name="main" method="POST">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_user_merge">
		
		
		{foreach $pilots as $pilot}
		<input type="hidden" name="pilot_{$pilot.pilot_id}" value="1">
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
		<tr>
			<th>Make Primary</th>
			<td colspan="3" bgcolor="lightgrey"><input type="radio" name="make_primary" value="{$pilot.pilot_id}" CHECKED> Pilot ID {$pilot.pilot_id}</td>
		</tr>
		<tr>
			<th width="20%">Pilot Name</th>
			<td>{$pilot.pilot_first_name|escape} {$pilot.pilot_last_name|escape}</td>
			<th>Pilot Location</th>
			<td>
				{$pilot.pilot_city|escape}, {$pilot.state_name|escape} - {$pilot.country_name|escape}
				{if $pilot.country_code}<img src="/images/flags/countries-iso/shiny/24/{$pilot.country_code|escape}.png" style="vertical-align: middle;">{/if}
				{if $pilot.state_name && $pilot.country_code=="US"}<img src="/images/flags/states/24/{$pilot.state_name|replace:' ':'-'}-Flag-24.png" style="vertical-align: middle;">{/if}
			</td>
		</tr>
		<tr>
			<th>Pilot AMA/FAI Number/License</th>
			<td>{$pilot.pilot_ama|escape}/{$pilot.pilot_fai|escape}/{$pilot.pilot_fai_license|escape}</td>
			<th>Pilot FAI Number</th>
			<td></td>
		</tr>
		<tr>
			<th>User Login</th>
			<td>{$pilot.user_name|escape}</td>
			<th>User Name</th>
			<td>{$pilot.user_first_name|escape} {$pilot.user_last_name|escape}</td>
		</tr>
		<tr>
			<th>Pilot Airplanes</th>
			<td colspan="3">
			<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
			<tr>
				<th style="text-align: left;">Plane</th>
				<th style="text-align: left;">Plane Type</th>
				<th style="text-align: left;">Plane Manufacturer</th>
				<th style="text-align: left;">Color Scheme</th>
			</tr>
			{if $pilot.pilot_planes}
				{foreach $pilot.pilot_planes as $pp}
					<tr>
					<td><a href="?action=plane&function=plane_view&plane_id={$pp.plane_id}" title="View Aircraft">{$pp.plane_name|escape}</a></td>
					<td>
						{foreach $pp.disciplines as $d}
							{$d.discipline_code_view}{if !$d@last},{/if}
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
			</td>
		</tr>
		<tr>
			<th>Pilot Clubs</th>
			<td colspan="3">
			<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
			<tr>
				<th style="text-align: left;">Club Name</th>
				<th style="text-align: left;">Club City</th>
				<th style="text-align: left;">State/Country</th>
			</tr>
			{if $pilot.pilot_clubs}
				{foreach $pilot.pilot_clubs as $pc}
				<tr>
					<td><a href="?action=club&function=club_view&club_id={$pc.club_id}" title="View This Club">{$pc.club_name|escape}</a></td>
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
			</td>
		</tr>
		<tr>
			<th>Pilot Locations</th>
			<td colspan="3">
			<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
			<tr>
				<th style="text-align: left;">Location Name</th>
				<th style="text-align: left;">Location City</th>
				<th style="text-align: left;">State/Country</th>
				<th style="text-align: center;">Map</th>
			</tr>
			{if $pilot.pilot_locations}
				{foreach $pilot.pilot_locations as $pl}
				<tr>
					<td><a href="?action=location&function=location_view&location_id={$pl.location_id}" title="View This Location">{$pl.location_name|escape}</a></td>
					<td>{$pl.location_city|escape}</td>
					<td>{$pl.state_name|escape}, {$pl.country_code|escape}
						{if $pl.country_code}<img src="/images/flags/countries-iso/shiny/16/{$pl.country_code|escape}.png" style="vertical-align: middle;">{/if}
						{if $pl.state_name && $pl.country_code=="US"}<img src="/images/flags/states/16/{$pl.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
					</td>
					<td align="center">{if $pl.location_coordinates!=''}<a class="fancybox-map" href="http://maps.google.com/maps?q={$pl.location_coordinates|escape:'url'}+({$pl.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}</td>
				</tr>
				{/foreach}
			{else}
				<tr>
					<td colspan="4">This pilot currently has no selected locations.</td>
				</tr>
			{/if}
			</table>
			</td>
		</tr>
		<tr>
			<th>Pilot Events</th>
			<td colspan="3">
			<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
			<tr>
				<th style="text-align: left;">Event Date</th>
				<th style="text-align: left;">Event Name</th>
				<th style="text-align: left;">Event Location</th>
				<th style="text-align: left;">State/Country</th>
				<th style="text-align: left;">Position</th>
				<th style="text-align: left;">Percentage</th>
			</tr>
			{if $pilot.pilot_events}
				{foreach $pilot.pilot_events as $pe}
				<tr>
					<td>{$pe.event_start_date|date_format:"Y-m-d"}</td>
					<td><a href="?action=event&function=event_view&event_id={$pe.event_id}" title="View This Event">{$pe.event_name|escape}</a></td>
					<td>
						<a href="?action=location&function=location_view&location_id={$pe.location_id}" title="View This Location">{$pe.location_name|escape}</a>
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
			</td>
		</tr>
		</table>
		<br>
		{/foreach}

		<input type="button" value=" Merge To Selected Primary Pilot ID " onclick="main.submit();" class="btn btn-primary btn-rounded">

		</form>

	</div>
</div>
{/block}