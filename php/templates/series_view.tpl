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
});
</script>
{/literal}

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Series Settings - {$series.series_name} <input type="button" value=" Edit Series Parameters " onClick="document.edit_series.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Series Name</th>
			<td>
			{$series.series_name}
			</td>
		</tr>
		<tr>
			<th align="right">Location</th>
			<td>
			{$series.series_area},{$series.state_code} {$series.country_code}
			</td>
		</tr>
		<tr>
			<th align="right">Series Web URL</th>
			<td><a href="{$series.series_url}" target="_new">{$series.series_url}</a></td>
		</tr>
		</table>
		
	</div>
		<br>
		<h1 class="post-title entry-title">Series Events</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th align="left">Event Name</th>
			<th align="left">Location</th>
			<th align="left">State</th>
			<th align="left">Country</th>
			<th align="left">Map Location</th>
		</tr>
		{foreach $events as $e}
		<tr>
			<td>
				<a href="?action=event&function=event_view&event_id={$e.event_id}">{$e.event_name}</a>
			</td>
			<td>{$e.location_name}</td>
			<td>{$e.state_name}</td>
			<td>{$e.country_name}</td>
			<td nowrap>
			</td>
		</tr>
		{/foreach}
		</table>


<br>


<input type="button" value=" Back To Series List " onClick="goback.submit();" class="block-button" style="float: none;margin-left: auto;margin-right: auto;">

</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_list">
</form>
<form name="edit_series" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_edit">
<input type="hidden" name="series_id" value="{$series.series_id}">
</form>
<form name="add_pilot" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_add_pilot">
<input type="hidden" name="series_id" value="{$series.series_id}">
<input type="hidden" name="pilot_id" value="">
<input type="hidden" name="pilot_name" value="">
</form>
<form name="add_location" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_location_add">
<input type="hidden" name="series_id" value="{$series.series_id}">
<input type="hidden" name="location_id" value="">
</form>
<form name="create_new_location" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
</form>

