<script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDYRplmgH2DUnWhVS1WSJCTHYYpELFcG44&sensor=true"></script>
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Location Interactive Map</h1>
		<div class="entry-content clearfix">
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
				content: '<div id="infowin"><div class="post-title entry-title"><a href="?action=location&function=location_view&location_id={$l.location_id}">{$l.location_name|escape}</a></div><br>{$l.location_city|escape}, {$l.state_code|escape} {$l.country_code|escape}<br>Coordinates: <a href="http://maps.google.com/maps?q={$l.location_coordinates|escape:'url'}+({$l.location_name|escape})&t=h&z=14">{$l.location_coordinates}</a><br><center><a href="?action=location&function=location_view&location_id={$l.location_id}">View Site Details</a></center></div>'
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

<form name="searchform" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_map">
<table width="80%">
<tr>
	<th>Filter By Site Discipline</th>
	<td colspan="3">
	<select name="discipline_id" onChange="searchform.submit();">
	{foreach $disciplines as $d}
		<option value="{$d.discipline_id}" {if $discipline_id==$d.discipline_id}SELECTED{/if}>{$d.discipline_description|escape}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Filter By Country</th>
	<td>
	<select name="country_id" onChange="document.searchform.state_id.value=0;searchform.submit();">
	<option value="0">Choose Country to Narrow Search</option>
	{foreach $countries as $country}
		<option value="{$country.country_id}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
	{/foreach}
	</select>
	</td>
	<th>Filter By State</th>
	<td>
	<select name="state_id" onChange="searchform.submit();">
	<option value="0">Choose State to Narrow Search</option>
	{foreach $states as $state}
		<option value="{$state.state_id}" {if $state_id==$state.state_id}SELECTED{/if}>{$state.state_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th nowrap>	
		And Search on Field : 
	</th>
	<td valign="center" colspan="3">
		<select name="search_field">
		<option value="location_name" {if $search_field=="location_name"}SELECTED{/if}>Location Name</option>
		<option value="location_city" {if $search_field=="location_city"}SELECTED{/if}>City</option>
		</select>
		<select name="search_operator">
		<option value="contains" {if $search_operator=="contains"}SELECTED{/if}>Contains</option>
		<option value="exactly" {if $search_operator=="exactly"}SELECTED{/if}>Is Exactly</option>
		</select>
		<input type="text" name="search" size="30" value="{$search|escape}">
		<input type="submit" value=" Search " class="block-button">
		<input type="submit" value=" Reset " class="block-button" onClick="document.searchform.country_id.value=0;document.searchform.state_id.value=0;document.searchform.search_field.value='location_name';document.searchform.search_operator.value='contains';document.searchform.search.value='';searchform.submit();">
		</form>
	</td>
</tr>
</table>
</form>



<br>

 <div id="googleMap" style="width:900px;height:600px;"></div>
 
 <br>

</div>
</div>
</div>

