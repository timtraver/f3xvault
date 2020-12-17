{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">Club View - {$club.club_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li{if $tab==0} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-0" aria-expanded="true" {if $tab==0}aria-selected="true"{/if}>
							Club Info
						</a>
					</li>
					<li{if $tab==1} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-1" aria-expanded="false" {if $tab==1}aria-selected="true"{/if}>
							Club Locations
							<span class="badge badge-blue">{$club_locations|count}</span>
						</a>
					</li>
					<li{if $tab==2} class="active"{/if}>
						<a data-toggle="tab" href="#pilot-tab-2" aria-expanded="false" {if $tab==2}aria-selected="true"{/if}>
							Club Members
							<span class="badge badge-blue">{$pilots|count}</span>
						</a>
					</li>
				</ul>
				<div class="tab-content">
					<div id="pilot-tab-0" class="tab-pane fade{if $tab==0} active in{/if}">
						<h2 style="float:left;">Club General Info</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Edit Club Info " onClick="document.edit_club.submit();" class="btn btn-primary btn-rounded">
							<input type="button" value=" Back To Club List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
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
							{if $club.country_code}<img src="/images/flags/countries-iso/shiny/16/{$club.country_code|escape}.png" style="vertical-align: middle;">{/if}
							{if $club.state_name && $club.country_code=="US"}<img src="/images/flags/states/16/{$club.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
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
					<div id="pilot-tab-1" class="tab-pane fade{if $tab==1} active in{/if}">
						<h2 style="float:left;">Club Sanctioned Locations</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Club List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						<div class="btn-group btn-group-xs"><button class="btn btn-primary btn-rounded" type="button" onclick="add_location.submit();"> Add Location </button></div>
						<input type="text" id="location_name" name="location_name" size="40">
						    <img id="loading_location" src="/images/loading.gif" style="vertical-align: middle;display: none;">
						    <span id="location_message" style="font-style: italic;color: grey;"> Start typing to search locations</span>
						<div class="btn-group btn-group-xs"><button class="btn btn-primary btn-rounded" type="button" onclick="create_new_location.submit();"> + Create New Location </button></div>
						<br>
						<br>
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
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
							<td>{$cl.state_name|escape}
								{if $cl.state_name && $cl.country_code=="US"}<img src="/images/flags/states/16/{$cl.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
							</td>
							<td>{$cl.country_name|escape}
								{if $cl.country_code}<img src="/images/flags/countries-iso/shiny/16/{$cl.country_code|escape}.png" style="vertical-align: middle;">{/if}
							</td>
							<td align="center">{if $cl.location_coordinates!=''}<a class="fancybox-map" href="http://maps.google.com/maps?q={$cl.location_coordinates|escape:'url'}+({$cl.location_name|escape})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}</td>
							<td nowrap>
								<a href="/?action=club&function=club_location_remove&club_id={$club.club_id|escape:'url'}&club_location_id={$cl.club_location_id|escape:'url'}" title="Remove Club Location" onClick="{if $user.user_id==0}alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{else}return confirm('Are you sure you want to remove {$cl.location_name|escape} from this club?');"{/if}><img src="/images/del.gif"></a>
							</td>
						</tr>
						{/foreach}
						</table>


					</div>
					<div id="pilot-tab-2" class="tab-pane fade{if $tab==2} active in{/if}">
						<h2 style="float:left;">Club Members</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Club List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
		
						<div class="btn-group btn-group-xs"><button class="btn btn-primary btn-rounded" type="button" onclick="var name=document.getElementById('pilot_name');document.add_pilot.pilot_name.value=name.value;add_pilot.submit();"> Add Pilot </button></div>
						<input type="text" id="pilot_name" name="pilot_name" size="40">
						    <img id="loading_pilot" src="/images/loading.gif" style="vertical-align: middle;display: none;">
						    <span id="pilot_message" style="font-style: italic;color: grey;"> Start typing to search pilots</span>
						<br>
						<br>
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-bordered">
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
								<a href="?action=club&function=club_pilot_remove&club_id={$club.club_id|escape:'url'}&club_pilot_id={$p.club_pilot_id|escape:'url'}&tab=2" title="Remove Club Pilot" onClick="{if $user.user_id==0}alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{else}return confirm('Are you sure you want to remove {$p.pilot_first_name|escape} from the club?');"{/if}><img src="/images/del.gif"></a>
							</td>
						</tr>
						{assign var=num value=$num+1}
						{/foreach}
						</table>
					</div>
				</div>
			</div>

		</p>

	</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_list">
</form>
<form name="edit_club" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_edit">
<input type="hidden" name="club_id" value="{$club.club_id|escape}">
<input type="hidden" name="tab" value="0">
</form>
<form name="add_pilot" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_add_pilot">
<input type="hidden" name="club_id" value="{$club.club_id|escape}">
<input type="hidden" name="pilot_id" value="">
<input type="hidden" name="pilot_name" value="">
<input type="hidden" name="tab" value="2">
</form>
<form name="add_location" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_location_add">
<input type="hidden" name="club_id" value="{$club.club_id|escape}">
<input type="hidden" name="location_id" value="">
<input type="hidden" name="tab" value="1">
</form>
<form name="create_new_location" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
</form>

{/block}

{block name="footer"}
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
{/block}