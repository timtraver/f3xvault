{extends file='layout/layout_main.tpl'}

{block name="header"}
<script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDYRplmgH2DUnWhVS1WSJCTHYYpELFcG44&sensor=false"></script>

<script>
	var map;
	var latlong;
	var openedInfoWindow = null;
	function initialize(){ldelim}
		var bounds = new google.maps.LatLngBounds();
		var mapOptions = {ldelim}
			mapTypeId:google.maps.MapTypeId.HYBRID
		{rdelim};
		map=new google.maps.Map(document.getElementById("googleMap"),mapOptions);
	
		var markers = [];
		{foreach $locations as $l}
			{if $l.location_coordinates!=''}
				latlong=new google.maps.LatLng({$l.location_coordinates});
				var marker=new google.maps.Marker({ldelim}
					position: latlong,
					map: map
				{rdelim});
				var infowindow = new google.maps.InfoWindow({ldelim}
					content: '<div id="infowin"><div class="post-title entry-title"><a href="?action=location&function=location_view&location_id={$l.location_id}"><b>{$l.location_name|escape}</b></a></div><br>{$l.location_city|escape}, {$l.state_code|escape} {$l.country_code|escape}<br>Coordinates: <a href="http://maps.google.com/maps?q={$l.location_coordinates|escape:"url"}+({$l.location_name|escape})&t=h&z=14">{$l.location_coordinates}</a><br><center><a href="?action=location&function=location_view&location_id={$l.location_id}">View Site Details</a></center></div>'
				{rdelim});
				makeInfoWindowEvent(map, infowindow, marker);
				markers.push(marker);
				bounds.extend(latlong);
			{/if}
		{/foreach}
		map.fitBounds(bounds);
	{rdelim}
	function makeInfoWindowEvent(map, infowindow, marker) {ldelim}
	  google.maps.event.addListener(marker, 'click', function() {ldelim}
	    if (openedInfoWindow != null) openedInfoWindow.close();
	    infowindow.open(map, marker);
	    openedInfoWindow = infowindow;
	      google.maps.event.addListener(infowindow, 'closeclick', function() {ldelim}
	          openedInfoWindow = null;
		{rdelim});
	  {rdelim});
	{rdelim}
	
	google.maps.event.addDomListener(window, 'load', initialize);
</script>

{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Location Interactive Map</h2>
	</div>
	<div class="panel-body">

		<p>
	
			<div>
				<form name="search_form" method="POST">
				<input type="hidden" name="action" value="location">
				<input type="hidden" name="function" value="location_map">
				<table class="filter" cellpadding="2" cellspacing="2">
					<tr>
						<th colspan="2">Filter Results</th>
					</tr>
					<tr>
						<td align="right">Country</td>
						<td nowrap>
							<select name="country_id" onChange="document.search_form.state_id.value=0;search_form.submit();">
							<option value="0">Choose Country to Narrow Search</option>
							{foreach $countries as $country}
								<option value="{$country.country_id}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
							{/foreach}
							</select>
				
						</td>
					</tr>
					<tr>
						<td align="right">State</td>
						<td nowrap>
							<select name="state_id" onChange="search_form.submit();">
							<option value="0">Choose State to Narrow Search</option>
							{foreach $states as $state}
								<option value="{$state.state_id}" {if $state_id==$state.state_id}SELECTED{/if}>{$state.state_name}</option>
							{/foreach}
							</select>
						</td>
					</tr>
					<tr>
						<td align="right">Name</td>
						<td nowrap>
							<input type="text" name="search" size="20" value="{$search|escape}">
							<input type="submit" value=" Search " class="btn btn-primary btn-rounded">
							<input type="submit" value=" Reset " class="btn btn-primary btn-rounded" onClick="document.search_form.country_id.value=0;document.search_form.state_id.value=0;document.search_form.search.value='';search_form.submit();">
						</td>
					</tr>
				</table>
				</form>
			</div>
			<br>
			<center>
			<h4>Found {$locations|count} Location Entries with GPS Coordinates</h4>
			</center>
			<br>
			<div id="googleMap" style="height:600px;position:relative;overflow:hidden;"></div>
			<br>
	
		</p>
	</div>
</div>
{/block}
