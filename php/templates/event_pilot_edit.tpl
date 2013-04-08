<script src="/includes/jquery.min.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
$(function() {ldelim}
	var teams = [
		{foreach $teams as $t}
		"{$t.event_pilot_team}"{if !$t@last},{/if}
		{/foreach}
	];
{literal}
	$("#event_pilot_team").autocomplete({
		source: teams,
		minLength: 0, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300
	});
	$("#event_plane").autocomplete({
		source: "/lookup.php?function=lookup_plane",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.main.plane_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.main.event_plane.value==''){
				document.main.plane_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "none";
   			var mes=document.getElementById('plane_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new plane.';
			}
		}
	});
});
{/literal}
function copy_plane_values(){ldelim}
	document.add_plane.plane_name.value=document.main.event_plane.value;
	{if $pilot.pilot_id==0}
	document.add_plane.from_pilot_first_name.value=document.main.pilot_first_name.value;
	document.add_plane.from_pilot_last_name.value=document.main.pilot_last_name.value;
	document.add_plane.from_pilot_city.value=document.main.pilot_city.value;
	document.add_plane.from_state_id.value=document.main.state_id.value;
	document.add_plane.from_country_id.value=document.main.country_id.value;
	document.add_plane.from_pilot_email.value=document.main.pilot_email.value;
	{/if}
	document.add_plane.from_pilot_ama.value=document.main.pilot_ama.value;
	document.add_plane.from_pilot_fai.value=document.main.pilot_fai.value;
	document.add_plane.from_class_id.value=document.main.class_id.value;
	document.add_plane.from_event_pilot_freq.value=document.main.event_pilot_freq.value;
	document.add_plane.from_event_pilot_team.value=document.main.event_pilot_team.value;
{rdelim}
</script>
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Pilot {if $pilot.event_pilot_id!=0}Edit{else}Add{/if}{if $pilot.pilot_id==0} (And Create New Pilot){/if}</h1>
		<div class="entry-content clearfix">

<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_pilot_save">
<input type="hidden" name="event_id" value="{$event.event_id}">
<input type="hidden" name="event_pilot_id" value="{$pilot.event_pilot_id}">
<input type="hidden" name="pilot_id" value="{$pilot.pilot_id}">
<input type="hidden" name="plane_id" value="{$pilot.plane_id}">
<table width="100%" cellpadding="2" cellspacing="2" class="tableborder">
<tr>
	<th colspan="3">Event Pilot Information</th>
</tr>
<tr>
	<th align="right" nowrap>Event</th>
	<td colspan="2">
		{$event.event_name}
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Entry Order</th>
	<td colspan="2">
		<input type="text" name="event_pilot_entry_order" size="3" value="{$pilot.event_pilot_entry_order}">
	</td>
</tr>
{if $pilot.pilot_id==0}
<tr>
	<th align="right" nowrap>Pilot First Name</th>
	<td colspan="2">
		{if $pilot.pilot_id==0}
		<input type="text" name="pilot_first_name" size="40" value="{$pilot.pilot_first_name}">
		{else}
		{$pilot.pilot_first_name}
		{/if}
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Last Name</th>
	<td colspan="2">
		{if $pilot.pilot_id==0}
		<input type="text" name="pilot_last_name" size="40" value="{$pilot.pilot_last_name}">
		{else}
		{$pilot.pilot_last_name}
		{/if}
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot City</th>
	<td colspan="2">
		<input type="text" name="pilot_city" size="40" value="{$pilot.pilot_city}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot State</th>
	<td colspan="2">
		<select name="state_id">
		{foreach $states as $state}
			<option value="{$state.state_id}" {if $pilot.state_id==$state.state_id}SELECTED{/if}>{$state.state_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Country</th>
	<td colspan="2">
		<select name="country_id">
		{foreach $countries as $country}
			<option value="{$country.country_id}" {if $pilot.country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Email</th>
	<td colspan="2">
		<input type="text" name="pilot_email" size="40" value="{$pilot.pilot_email}">
	</td>
</tr>
{else}
<tr>
	<th align="right" nowrap>Pilot Name</th>
	<td colspan="2">
		{$pilot.pilot_first_name} {$pilot.pilot_last_name}
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Location</th>
	<td colspan="2">
		{$pilot.pilot_city}, {$pilot.state_name} - {$pilot.country_code}
	</td>
</tr>
{/if}
<tr>
	<th align="right" nowrap>Pilot AMA #</th>
	<td colspan="2">
		<input type="text" name="pilot_ama" size="15" value="{$pilot.pilot_ama}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot FAI #</th>
	<td colspan="2">
		<input type="text" name="pilot_fai" size="15" value="{$pilot.pilot_fai}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Class</th>
	<td colspan="2">
		<select name="class_id">
		{foreach $classes as $c}
			<option value="{$c.class_id}" {if $pilot.class_id==$c.class_id}SELECTED{/if}>{$c.class_description}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Radio Frequency</th>
	<td colspan="2">
		<input type="text" name="event_pilot_freq" size="15" value="{$pilot.event_pilot_freq}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Team</th>
	<td colspan="2">
		<input type="text" id="event_pilot_team" name="event_pilot_team" size="40" value="{$pilot.event_pilot_team}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Plane</th>
	<td colspan="2">
		<input type="text" id="event_plane" name="event_plane" size="40" value="{$pilot.plane_name}">
		<img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="plane_message" style="font-style: italic;color: grey;">Start typing to search planes</span>
		<input type="button" value=" + New Plane " class="button" onClick="copy_plane_values(); add_plane.submit();">
	</td>
</tr>
<tr>
	<th valign="center" colspan="3">
	<input type="button" value=" Cancel " class="button" onClick="goback.submit();">
	<input type="submit" value=" Save Event Pilot Info " class="button">
	</th>
</tr>
</table>
</form>

<script>
{if $pilot.pilot_id==0}
	document.main.pilot_city.focus();
{else}
	document.main.pilot_ama.focus();
{/if}
</script>
<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event_id}">
</form>
<form name="add_plane" method="POST">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_edit">
<input type="hidden" name="plane_id" value="0">
<input type="hidden" name="plane_name" value="">
<input type="hidden" name="from_action" value="event">
<input type="hidden" name="from_function" value="event_pilot_edit">
<input type="hidden" name="from_event_id" value="{$event.event_id}">
<input type="hidden" name="from_event_pilot_id" value="{$pilot.event_pilot_id}">
<input type="hidden" name="from_pilot_id" value="{$pilot.pilot_id}">
<input type="hidden" name="from_pilot_first_name" value="">
<input type="hidden" name="from_pilot_last_name" value="">
<input type="hidden" name="from_pilot_city" value="">
<input type="hidden" name="from_state_id" value="">
<input type="hidden" name="from_country_id" value="">
<input type="hidden" name="from_pilot_email" value="">
<input type="hidden" name="from_pilot_ama" value="">
<input type="hidden" name="from_pilot_fai" value="">
<input type="hidden" name="from_class_id" value="">
<input type="hidden" name="from_event_pilot_freq" value="">
<input type="hidden" name="from_event_pilot_team" value="">
</form>

</div>
</div>
</div>
