<script src="/includes/jquery.min.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#plane_name").autocomplete({
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
			document.getElementById('search_message').innerHTML = ' Plane Selected';
			document.getElementById('create_button').disabled = true;
			$("#create_button").css({ opacity: 0.5 });
		},
   		change: function( event, ui ) {
   			if(document.main.plane_name.value==''){
				document.main.plane_id.value = 0;
				document.getElementById('search_message').innerHTML = ' Start typing to search plane database';
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "none";
   			var mes=document.getElementById('search_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Create button to add new model.';
				document.getElementById('create_button').disabled = false;
				$("#create_button").css({ opacity: 1 });
			}
		}
	});
});
function copy_plane_values(){
	document.create_new_plane.plane_name.value=document.main.plane_name.value;
	document.create_new_plane.from_pilot_plane_color.value=document.main.pilot_plane_color.value;
	document.create_new_plane.from_pilot_plane_serial.value=document.main.pilot_plane_serial.value;
	document.create_new_plane.from_pilot_plane_auw.value=document.main.pilot_plane_auw.value;
	document.create_new_plane.from_pilot_plane_auw_units.value=document.main.pilot_plane_auw_units.value;
}
</script>
{/literal}
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">My Pilot Profile</h1>
		<div class="entry-content clearfix">

<form name="main" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_plane_save">
<input type="hidden" name="pilot_plane_id" value="{$pilot_plane.pilot_plane_id}">
<input type="hidden" name="plane_id" value="{$pilot_plane.plane_id}">

<h1 class="post-title entry-title">
My Plane
<input type="button" value=" Back To My Pilot Profile " class="block-button" onclick="goback.submit();">
</h1>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
{if $pilot_plane.pilot_plane_id==0}
<tr>
	<th align="right" width="20%">Plane Model</th>
	<td>
		<input type="text" id="plane_name" name="plane_name" size="40" value="{$pilot_plane.plane_name|escape}">
		    <img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		    <span id="search_message" style="font-style: italic;color: grey;">Start typing to search plane database</span>
			<input id="create_button" type="button" value=" + Create New Model " class="block-button" onClick="copy_plane_values(); create_new_plane.submit();">
	</td>
</tr>
{else}
<tr>
	<th align="right" width="20%">Plane Model</th>
	<td>
		{$pilot_plane.plane_name|escape}
	</td>
</tr>
{/if}
<tr>
	<th align="right">Plane Color Scheme</th>
	<td><input type="text" size="50" name="pilot_plane_color" value="{$pilot_plane.pilot_plane_color|escape}"></td>
</tr>
<tr>
	<th align="right">Plane Serial Number</th>
	<td><input type="text" size="20" name="pilot_plane_serial" value="{$pilot_plane.pilot_plane_serial|escape}"></td>
</tr>
<tr>
	<th align="right">Plane Empty Weight</th>
	<td>
		<input type="text" size="10" name="pilot_plane_auw" value="{$pilot_plane.pilot_plane_auw|string_format:'%.1f'}">
		<select name="pilot_plane_auw_units">
		<option value="oz" {if $plane.pilot_plane_auw_units=="oz"}SELECTED{/if}>Ounces</option>
		<option value="gr" {if $plane.pilot_plane_auw_units=="gr"}SELECTED{/if}>Grams</option>
		</select>
	</td>
</tr>
</table>
<center>
<br>
{if $pilot_plane.pilot_plane_id==0}
	<input type="submit" value=" Add This Plane To My Quiver " class="block-button" onClick="if(document.main.plane_id.value==0){ldelim}alert('You must choose or add a valid plane before saving this record.');return false;{rdelim}">
{else}
	<input type="submit" value=" Save This Plane Info " class="block-button">
	<input type="button" value=" Delete This Plane From My Quiver " class="block-button" style="float: none;margin-left: 0;margin-right: auto;" onClick="return confirm('Are you sure you wish to delete this plane from your quiver?') && document.deleteplane.submit();">
{/if}
</center>
</form>

{if $pilot_plane.pilot_plane_id!=0}
<div id="media">
<h1 class="post-title entry-title">Plane Media</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;" width="20%">Media Type</th>
	<th style="text-align: left;">URL</th>
	<th style="text-align: left;">&nbsp;</th>
</tr>
{if $media}
	{foreach $media as $m}
	<tr bgcolor="{cycle values="white,lightgray"}">
		<td>{if $m.pilot_plane_media_type=='picture'}Picture{else}Video{/if}</td>
		{if $m.location_media_type=='picture'}
			<td><a href="{$m.pilot_plane_media_url}" rel="gallery" class="fancybox-button" title="{$m.location_media_caption|escape}">{$m.pilot_plane_media_url}</a></td>
		{else}
			<td><a href="{$m.pilot_plane_media_url}" rel="videos" class="fancybox-media" title="{$m.location_media_caption|escape}">{$m.pilot_plane_media_url}</a></td>
		{/if}
		<td> <a href="?action=my&function=my_plane_media_del&pilot_plane_id={$pilot_plane.pilot_plane_id}&pilot_plane_media_id={$m.pilot_plane_media_id}" title="Remove Media" onClick="confirm('Are you sure you wish to remove this media?')"><img src="images/del.gif"></a></td>
	</tr>
	{/foreach}
{else}
	<tr>
		<td colspan="4">You currently have no media entered.</td>
	</tr>
{/if}
</table>
<center>
<br>
<input type="button" name="media" value="Add New Plane Media" onClick="add_media.submit()" class="block-button" {if $pilot_plane.pilot_plane_id==0}disabled="disabled" style=""{/if}>
</center>
</div>

<form name="add_media" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_plane_media_edit">
<input type="hidden" name="pilot_plane_id" value="{$pilot_plane.pilot_plane_id}">
<input type="hidden" name="pilot_plane_media_id" value="0">
</form>
{/if}

<form name="goback" method="GET">
<input type="hidden" name="action" value="my">
</form>

<form name="deleteplane" method="GET">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_plane_del">
<input type="hidden" name="pilot_plane_id" value="{$pilot_plane.pilot_plane_id}">
</form>

<form name="create_new_plane" method="POST">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_edit">
<input type="hidden" name="plane_id" value="0">
<input type="hidden" name="plane_name" value="">
<input type="hidden" name="from_action" value="my">
<input type="hidden" name="from_function" value="my_plane_edit">
<input type="hidden" name="from_pilot_plane_color" value="">
<input type="hidden" name="from_pilot_plane_serial" value="">
<input type="hidden" name="from_pilot_plane_auw" value="">
<input type="hidden" name="from_pilot_plane_auw_units" value="">
</form>

</div>
</div>
</div>
