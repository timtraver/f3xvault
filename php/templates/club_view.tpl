<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#pilot_name").autocomplete({
		source: "/lookup.php?function=lookup_pilot",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_pilot');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
			document.add_pilot.pilot_id.value = ui.item.id;
			document.add_pilot.pilot_name.value = id.value;
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
   			if(id.value==''){
				document.add_pilot.pilot_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_pilot');
			loading.style.display = "none";
   			var mes=document.getElementById('pilot_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
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
   			var id=document.getElementById('location_name');
   			if(id.value==''){
				document.add_location.location_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_location');
			loading.style.display = "none";
   			var mes=document.getElementById('location_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
});
</script>
{/literal}

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Club Settings - {$club.club_name|escape} <input type="button" value=" Edit Club Parameters " onClick="document.edit_club.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Club Name</th>
			<td>
			{$club.club_name|escape}
			</td>
		</tr>
		<tr>
			<th align="right">Location</th>
			<td>
			{$club.club_city|escape},{$club.state_code|escape} {$club.country_code|escape}
			</td>
		</tr>
		<tr>
			<th align="right">Club Charter Date</th>
			<td>{$club.club_charter_date|date_format:"Y-m-d"}</td>
		</tr>
		<tr>
			<th align="right">Club Web URL</th>
			<td><a href="{$club.club_url}" target="_blank">{$club.club_url|escape}</a></td>
		</tr>
		</table>
		
	</div>
		<br>
		<h1 class="post-title entry-title">Club Sanctioned Locations</h1>
		<input type="button" value=" Add Location " onclick="add_location.submit();">
		<input type="text" id="location_name" name="location_name" size="40">
		    <img id="loading_location" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		    <span id="location_message" style="font-style: italic;color: grey;"> Start typing to search locations</span>
		<input type="button" value=" + New Location " class="block-button" onClick="create_new_location.submit();">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th align="left">Location Name</th>
			<th align="left">Location City</th>
			<th align="left">State</th>
			<th align="left">Country</th>
			<th align="left">Map Location</th>
			<th align="left"></th>
		</tr>
		{foreach $club_locations as $cl}
		<tr>
			<td>{$cl.location_name|escape}</td>
			<td>{$cl.location_city|escape}</td>
			<td>{$cl.state_name|escape}</td>
			<td>{$cl.country_name|escape}</td>
			<td align="center">{if $cl.location_coordinates!=''}<a class="fancybox-map" href="http://maps.google.com/maps?q={$cl.location_coordinates|escape:'url'}+({$cl.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}</td>
			<td nowrap>
				<a href="/?action=club&function=club_location_remove&club_id={$club.club_id}&club_location_id={$cl.club_location_id}" title="Remove Club Location" onClick="return confirm('Are you sure you want to remove {$cl.location_name} from this club?');"><img src="/images/del.gif"></a>
			</td>
		</tr>
		{/foreach}
		</table>

		<br>
		<h1 class="post-title entry-title">Club Members {if $pilots}({$total_pilots}){/if}</h1>
		<input type="button" value=" Add Pilot " onclick="var name=document.getElementById('pilot_name');document.add_pilot.pilot_name.value=name.value;add_pilot.submit();">
		<input type="text" id="pilot_name" name="pilot_name" size="40">
		    <img id="loading_pilot" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		    <span id="pilot_message" style="font-style: italic;color: grey;"> Start typing to search pilots</span>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="center">AMA#</th>
			<th align="left">Pilot Name</th>
			<th align="left">Pilot City</th>
			<th align="left">State</th>
			<th align="left">Country</th>
			<th align="left" width="4%"></th>
		</tr>
		{assign var=num value=1}
		{foreach $pilots as $p}
		<tr>
			<td>{$num}</td>
			<td align="center">{$p.pilot_ama|escape}</td>
			<td>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
			<td>{$p.pilot_city|escape}</td>
			<td>{$p.state_name|escape}</td>
			<td>{$p.country_name|escape}</td>
			<td nowrap>
				<a href="/?action=club&function=club_pilot_remove&club_id={$club.club_id}&club_pilot_id={$p.club_pilot_id}" title="Remove Club Pilot" onClick="return confirm('Are you sure you want to remove {$p.pilot_first_name} from the club?');"><img src="/images/del.gif"></a>
			</td>
		</tr>
		{assign var=num value=$num+1}
		{/foreach}
		</table>

<br>


<input type="button" value=" Back To Club List " onClick="goback.submit();" class="block-button" style="float: none;margin-left: auto;margin-right: auto;">

</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_list">
</form>
<form name="edit_club" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_edit">
<input type="hidden" name="club_id" value="{$club.club_id}">
</form>
<form name="add_pilot" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_add_pilot">
<input type="hidden" name="club_id" value="{$club.club_id}">
<input type="hidden" name="pilot_id" value="">
<input type="hidden" name="pilot_name" value="">
</form>
<form name="add_location" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_location_add">
<input type="hidden" name="club_id" value="{$club.club_id}">
<input type="hidden" name="location_id" value="">
</form>
<form name="create_new_location" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
</form>

