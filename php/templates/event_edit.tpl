<script src="/f3x/includes/jquery.min.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#location_name").autocomplete({
		source: "/f3x/?action=lookup&function=lookup_location",
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
			document.main.location_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.main.location_name.value==''){
				document.main.location_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_location');
			loading.style.display = "none";
   			var mes=document.getElementById('search_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
	$("#event_cd_name").autocomplete({
		source: "/f3x/?action=lookup&function=lookup_pilot",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_cd');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.main.event_cd.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.main.event_cd_name.value==''){
				document.main.event_cd.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_cd');
			loading.style.display = "none";
   			var mes=document.getElementById('cd_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
	$("#event_user_name").autocomplete({
		source: "/f3x/?action=lookup&function=lookup_pilot",
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
			document.event_user_add.pilot_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.event_user_add.event_user_name.value==''){
				document.event_user_add.pilot.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_pilot');
			loading.style.display = "none";
   			var mes=document.getElementById('user_message');
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
		<h1 class="post-title entry-title">RC Event Edit</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Edit Basic Event Parameters</h1>
<form name="main" method="POST">
<input type="hidden" name="action" value="{$action|escape}">
<input type="hidden" name="function" value="event_save">
<input type="hidden" name="event_id" value="{$event.event_id}">
<input type="hidden" name="location_id" value="{$event.location_id}">
<input type="hidden" name="event_cd" value="{$event.event_cd}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Location</th>
	<td>
		<input type="text" id="location_name" name="location_name" size="40" value="{$event.location_name}">
		<img id="loading_location" src="/f3x/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="search_message" style="font-style: italic;color: grey;">Start typing to search locations</span>
		<input type="button" value=" + New Location " class="block-button" onClick="create_new_location.submit();">
	</td>
</tr>
<tr>
	<th>Name</th>
	<td>
		<input type="text" size="60" name="event_name" value="{$event.event_name}">
	</td>
</tr>
<tr>
	<th>Dates</th>
	<td>
	{html_select_date prefix="event_start_date" start_year="-1" end_year="+1" day_format="%02d" time=$event.event_start_date} to 
	{html_select_date prefix="event_end_date" start_year="-1" end_year="+1" day_format="%02d" time=$event.event_end_date}
	</td>
</tr>
<tr>
	<th>Type</th>
	<td>
	<select name="event_type_id">
	{foreach $event_types as $t}
		<option value="{$t.event_type_id}" {if $event.event_type_id==$t.event_type_id}SELECTED{/if}>{$t.event_type_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Contest Director</th>
	<td>
		<input type="text" id="event_cd_name" name="event_cd_name" size="40" value="{if $event.pilot_first_name!=''}{$event.pilot_first_name} {$event.pilot_last_name}{/if}">
		<img id="loading_cd" src="/f3x/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="cd_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value=" Back To Event View " onClick="goback.submit();" class="block-button">
		<input type="submit" value=" Save This Event " class="block-button">
	</th>
</tr>
</table>
</form>

{if $event.event_id!=0}
<h1 class="post-title entry-title">Edit Advanced Event Parameters</h1>
<form name="event_options" method="POST">
<input type="hidden" name="action" value="{$action|escape}">
<input type="hidden" name="function" value="event_param_save">
<input type="hidden" name="event_id" value="{$event.event_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th colspan="2" align="left">The Following Specific Parameters Are for this {$event.event_type_name}</th>
</tr>
{foreach $options as $o}
<tr>
	<th width="15%">{$o.event_type_option_name} (<a href="#" title="{$o.event_type_option_description}">?</a>)</th>
	<td>
		{if $o.event_type_option_type == 'boolean'}
				<input type="checkbox" name="option_{$o.event_type_option_id}" {if $o.event_option_status==1 && $o.event_option_value ==1}CHECKED{/if}>
		{else}
				<input type="text" name="option_{$o.event_type_option_id}" size="{$o.event_type_option_size}" value="{if $o.event_option_status==1}{$o.event_option_value}{/if}"> 
		{/if}
	</td>
</tr>
{/foreach}
<tr>
	<th colspan="2">
		<input type="submit" value=" Save These Event Parameters " class="block-button">
	</th>
</tr>

</table>
</form>

<h1 class="post-title entry-title">Edit Event Access</h1>
<form name="event_user_add" method="POST">
<input type="hidden" name="action" value="{$action|escape}">
<input type="hidden" name="function" value="event_user_save">
<input type="hidden" name="event_id" value="{$event.event_id}">
<input type="hidden" name="pilot_id" value="">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th colspan="2" align="left">The Following Users Have Access To Edit This Event</th>
</tr>
{foreach $event_users as $u}
<tr>
	<td>{$u.pilot_first_name} {$u.pilot_last_name} - {$u.pilot_city}, {$u.state_code} {$u.country_code}</td>
	<td width="2%">
		<a href="?action=event&function=event_user_delete&event_id={$event.event_id}&event_user_id={$u.event_user_id}"><img src="/f3x/images/del.gif"></a></td>
</tr>
{/foreach}
<tr>
	<th colspan="2">
		Add New User 
		<input type="text" id="event_user_name" name="event_user_name" size="40">
		<img id="loading_pilot" src="/f3x/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="user_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
		<input type="submit" value=" Add This User " class="block-button">
	</th>
</tr>

</table>
</form>
{/if}
<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
{if $event.event_id==0}
<input type="hidden" name="function" value="event_list">
{else}
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event.event_id}">
{/if}
</form>
<form name="create_new_location" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
</form>

</div>
</div>
</div>

