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
   		select: function( event, ui ) {
			document.main.location_id.value = ui.item.id;
		},
   		response: function( event, ui ) {
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
   		select: function( event, ui ) {
			document.main.event_cd.value = ui.item.id;
		},
   		response: function( event, ui ) {
   			var mes=document.getElementById('cd_message');
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
		<span id="cd_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value=" Cancel " onClick="goback.submit();" class="block-button">
		<input type="submit" value=" Save This Event " class="block-button">
	</th>
</tr>
</table>
</form>

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

