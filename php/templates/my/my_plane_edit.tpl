{extends file='layout/layout_main.tpl'}

{block name="header"}
{if $pilot_plane.pilot_plane_id!=0}
{literal}
<script type="text/javascript">
	function showrows(){
		if(document.add_media.pilot_plane_media_type.value=="picture"){
			document.getElementById("picture").style.display="";
			document.getElementById("mediaurl").style.display="none";
		}else{
			document.getElementById("picture").style.display="none";
			document.getElementById("mediaurl").style.display="";
		}
	}
</script>
{/literal}
{/if}
{/block}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">Edit My Pilot Profile - {$pilot.pilot_first_name|escape} {$pilot.pilot_last_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li>
						<a href="?action=my&function=my_user_show&tab=0">
							General Profile
						</a>
					</li>
					<li class="active">
						<a href="?action=my&function=my_user_show&tab=1" aria-expanded="true" aria-selected="true">
							My Aircraft
							<span class="badge badge-blue">{$pilot_planes|count}</span>
						</a>
					</li>
					<li>
						<a href="?action=my&function=my_user_show&tab=2">
							My Club Affiliations
							<span class="badge badge-blue">{$pilot_clubs|count}</span>
						</a>
					</li>
					<li>
						<a href="?action=my&function=my_user_show&tab=3">
							My Flying Locations
							<span class="badge badge-blue">{$pilot_locations|count}</span>
						</a>
					</li>
				</ul>
				<div class="tab-content">
					<div id="pilot-tab-1" class="tab-pane fade active in">
						<h2 style="float:left;">Edit My Plane</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Pilot View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						

						<form name="main" method="POST">
						<input type="hidden" name="action" value="my">
						<input type="hidden" name="function" value="my_plane_save">
						<input type="hidden" name="pilot_plane_id" value="{$pilot_plane.pilot_plane_id}">
						<input type="hidden" name="plane_id" value="{$pilot_plane.plane_id}">
						
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
						{if $pilot_plane.pilot_plane_id==0}
						<tr>
							<th align="right" width="20%">Plane Model</th>
							<td>
								<input type="text" id="plane_name" name="plane_name" size="40" value="{$pilot_plane.plane_name|escape}">
								    <img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
								    <span id="search_message" style="font-style: italic;color: grey;">Start typing to search plane database</span>
								    <button id="create_button" class="btn btn-primary btn-labeled fa fa-plane btn-rounded" style="float:right;" type="button" onClick="copy_plane_values(); document.create_new_plane.submit();">Create New Model</button>
							</td>
						</tr>
						{else}
						<tr>
							<th width="20%" valign="center">Plane Model</th>
							<td>
								{$pilot_plane.plane_name|escape}
							</td>
						</tr>
						{/if}
						<tr>
							<th>Plane Color Scheme</th>
							<td><input type="text" size="50" name="pilot_plane_color" value="{$pilot_plane.pilot_plane_color|escape}"></td>
						</tr>
						<tr>
							<th>Plane Serial Number</th>
							<td><input type="text" size="20" name="pilot_plane_serial" value="{$pilot_plane.pilot_plane_serial|escape}"></td>
						</tr>
						<tr>
							<th>Plane Empty Weight</th>
							<td>
								<input type="text" size="10" name="pilot_plane_auw" value="{$pilot_plane.pilot_plane_auw|string_format:'%.1f'}">
								<select name="pilot_plane_auw_units">
								<option value="oz" {if $pilot_plane.pilot_plane_auw_units=="oz"}SELECTED{/if}>Ounces</option>
								<option value="gr" {if $pilot_plane.pilot_plane_auw_units=="gr"}SELECTED{/if}>Grams</option>
								</select>
							</td>
						</tr>
						</table>
						<center>
						{if $pilot_plane.pilot_plane_id==0}
							<input type="submit" value=" Add This Plane To My Quiver " class="btn btn-primary btn-rounded" onClick="if(document.main.plane_id.value==0){ldelim}alert('You must choose or add a valid plane before saving this record.');return false;{rdelim}">
						{else}
							<input type="submit" value=" Save This Plane Info " class="btn btn-primary btn-rounded">
							<input type="button" value=" Delete This Plane From My Quiver " class="btn btn-primary btn-rounded" style="float: none;margin-left: 0;margin-right: auto;" onClick="return confirm('Are you sure you wish to delete this plane from your quiver?') && document.deleteplane.submit();">
						{/if}
						</center>
						</form>

						{if $pilot_plane.pilot_plane_id!=0}
						<div id="media">
						<h2 style="float:left;">Plane Media</h2>
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
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
									<td><a href="{$m.pilot_plane_media_url}" title="{$m.location_media_caption|escape}" class="btn-link" target="_blank">{$m.pilot_plane_media_url}</a></td>
								{else}
									<td><a href="{$m.pilot_plane_media_url}" title="{$m.location_media_caption|escape}" class="btn-link" target="_blank">{$m.pilot_plane_media_url}</a></td>
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
						
						
						<form name="add_media" method="POST" enctype="multipart/form-data">
						<input type="hidden" name="action" value="my">
						<input type="hidden" name="function" value="my_plane_media_add">
						<input type="hidden" name="pilot_plane_id" value="{$pilot_plane.pilot_plane_id}">
						<input type="hidden" name="MAX_FILE_SIZE" value="5000000">
						<input type="hidden" name="pilot_plane_media_id" value="0">
						<h2 style="float:left;">Add Plane Media</h2>
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
						<tr>
							<th>Media Type</th>
							<td>
							<select name="pilot_plane_media_type" onChange="showrows();">
								<option value="picture" SELECTED>Picture or File</option>
								<option value="video">YouTube or Vimeo Video URL</option>
							</select>
							</td>
						</tr>
						<tr id="picture" style="display: none;">
							<th>Upload Picture</th>
							<td><input type="file" size="50" name="uploaded_file" value="" style="display: inline;">(Max of 5 Mbytes)</td>
						</tr>
						<tr id="mediaurl" style="display: none;">
							<th>URL</th>
							<td><input type="text" size="50" name="pilot_plane_media_url" value=""></td>
						</tr>
						<tr>
							<th>Media Caption</th>
							<td><input type="text" size="50" name="pilot_plane_media_caption" value=""></td>
						</tr>
						</table>
						
						<input type="button" name="media" value="Add New Plane Media" onClick="add_media.submit()" class="btn btn-primary btn-rounded">
						</center>
						</form>

						</div>
						{/if}

					</div>
				</div>
			</div>
		</p>
	</div>
</div>

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
{/block}

{block name="footer"}
{if $pilot_plane.pilot_plane_id==0}
<script src="/includes/jquery.min.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	document.getElementById('create_button').disabled = true;
	$("#create_button").css({ opacity: 0.5 });

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
{/if}
{if $pilot_plane.pilot_plane_id!=0}
<script type="text/javascript">
	document.getElementById("picture").style.display="";
	document.getElementById("mediaurl").style.display="none";
</script>
{/if}
{/block}
