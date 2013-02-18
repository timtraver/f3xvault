<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Pilot Profile</h1>
		<div class="entry-content clearfix">

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%">Pilot Name</th>
	<td>{$pilot.pilot_first_name|escape} {$pilot.pilot_last_name|escape}</td>
</tr>
<tr>
	<th>Pilot Location</th>
	<td>{$pilot.pilot_city|escape}, {$pilot.state_name|escape} - {$pilot.country_name|escape}</td>
</tr>
<tr>
	<th>Pilot AMA Number</th>
	<td>{$pilot.pilot_ama|escape}</td>
</tr>
<tr>
	<th>Pilot FIA Number</th>
	<td>{$pilot.pilot_fia|escape}</td>
</tr>
</table>
<br>

<h1 class="post-title entry-title">Pilot Aircraft</h1>
	<table width="100%" cellpadding="2" cellspacing="1">
	<tr>
		<th style="text-align: left;">Plane</th>
		<th style="text-align: left;">Plane Type</th>
		<th style="text-align: left;">Plane Manufacturer</th>
		<th style="text-align: left;">Color Scheme</th>
	</tr>
	{if $pilot_planes}
		{foreach $pilot_planes as $pp}
			<tr bgcolor="{cycle values="white,lightgray"}">
			<td><a href="?action=plane&function=plane_view&plane_id={$pp.plane_id}" title="View Aircraft">{$pp.plane_name}</a></td>
			<td>{$pp.plane_type_short_name}</td>
			<td>{$pp.plane_manufacturer}</td>
			<td>{$pp.pilot_plane_color}</td>
		</tr>
		{/foreach}
	{else}
		<tr>
			<td colspan="5">This pilot currently has no planes in his quiver.</td>
		</tr>
	{/if}
	</table>
	<br>

<h1 class="post-title entry-title">Pilot RC Club Affiliations</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;">Club Name</th>
	<th style="text-align: left;">Club City</th>
	<th style="text-align: left;">State/Country</th>
</tr>
{if $pilot_clubs}
	{foreach $pilot_clubs as $pc}
	<tr bgcolor="{cycle values="white,lightgray"}">
		<td><a href="?action=club&function=club_view&club_id={$pc.club_id}" title="View This Club">{$pc.club_name}</a></td>
		<td>{$pc.club_city}</td>
		<td>{$pc.state_name}, {$pc.country_code}</td>
	</tr>
	{/foreach}
{else}
	<tr>
		<td colspan="4">This pilot currently has no club affiliations.</td>
	</tr>
{/if}
</table>
<br>

<h1 class="post-title entry-title">Pilot RC Flying Locations</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;">Location Name</th>
	<th style="text-align: left;">Location City</th>
	<th style="text-align: left;">State/Country</th>
	<th style="text-align: center;">Map</th>
</tr>
{if $pilot_locations}
	{foreach $pilot_locations as $pl}
	<tr bgcolor="{cycle values="white,lightgray"}">
		<td><a href="?action=location&function=location_view&location_id={$pl.location_id}" title="View This Location">{$pl.location_name}</a></td>
		<td>{$pl.location_city}</td>
		<td>{$pl.state_name}, {$pl.country_code}</td>
		<td align="center">{if $pl.location_coordinates!=''}<a class="fancybox-map" href="http://maps.google.com/maps?q={$pl.location_coordinates|escape:'url'}+({$pl.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/icons/world.png"></a>{/if}</td>
	</tr>
	{/foreach}
{else}
	<tr>
		<td colspan="4">This pilot currently has no selected locations.</td>
	</tr>
{/if}
</table>
<br>


<h1 class="post-title entry-title">Pilot RC Events</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;">Event Date</th>
	<th style="text-align: left;">Event Name</th>
	<th style="text-align: left;">Event Location</th>
	<th style="text-align: left;">State/Country</th>
</tr>
{if $pilot_events}
	{foreach $pilot_events as $pe}
	<tr bgcolor="{cycle values="white,lightgray"}">
		<td>{$pe.event_start_date|date_format:"Y-m-d"}</td>
		<td><a href="?action=event&function=event_view&event_id={$pe.event_id}" title="View This Event">{$pe.event_name}</a></td>
		<td><a href="?action=location&function=location_view&location_id={$pe.location_id}" title="View This Location">{$pe.location_name}</a></td>
		<td>{$pe.state_name}, {$pe.country_code}</td>
	</tr>
	{/foreach}
{else}
	<tr>
		<td colspan="4">This Pilot currently has no events.</td>
	</tr>
{/if}
</table>
<center>
<br>
</center>
</form>

</div>
</div>
</div>
