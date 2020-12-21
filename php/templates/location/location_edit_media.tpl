{extends file='layout/layout_main.tpl'}

{block name="header"}
<script type="text/javascript">
	function showrows(){ldelim}
		if(document.main.location_media_type.value=="picture"){ldelim}
			document.getElementById("picture").style.display="";
			document.getElementById("media").style.display="none";
		{rdelim}else{ldelim}
			document.getElementById("picture").style.display="none";
			document.getElementById("media").style.display="";
		{rdelim}
	{rdelim}
</script>
{/block}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">F3X Location Details - {$location.location_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li>
						<a href="?action=location&function=location_view&location_id={$location.location_id|escape}&tab=0" aria-expanded="true">
							Information
						</a>
					</li>
					<li class="active">
						<a href="?action=location&function=location_view&location_id={$location.location_id|escape}&tab=1" aria-expanded="true" aria-selected="true">
							Media
							<span class="badge badge-blue">{$media|count}</span>
						</a>
					</li>
					<li>
						<a href="?action=location&function=location_view&location_id={$location.location_id|escape}&tab=2" aria-expanded="false">
							Comments
							<span class="badge badge-blue">{$comments|count}</span>
						</a>
					</li>
					<li>
						<a href="?action=location&function=location_view&location_id={$location.location_id|escape}&tab=3" aria-expanded="false">
							Competitions
							<span class="badge badge-blue">{$totalrecords|escape}</span>
						</a>
					</li>
				</ul>
				<div class="tab-content">
					<div id="location-tab-2" class="tab-pane fade active in">
						<h2 style="float:left;">Location Media Add</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Location View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
	
						<form name="main" method="POST" enctype="multipart/form-data">
						<input type="hidden" name="action" value="location">
						<input type="hidden" name="function" value="location_media_add">
						<input type="hidden" name="location_id" value="{$location.location_id|escape}">
						<input type="hidden" name="tab" value="1">
						<input type="hidden" name="MAX_FILE_SIZE" value="2000000">
						
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
						<tr>
							<th>Location</th>
							<td>
								{$location.location_name|escape}
							</td>
						</tr>
						<tr>
							<th>Media Type</th>
							<td>
							<select name="location_media_type" onChange="showrows();">
								<option value="picture" SELECTED>Picture or File</option>
								<option value="video">YouTube or Vimeo Video URL</option>
							</select>
							</td>
						</tr>
						<tbody id="picture" style="display: none;">
						<tr>
							<th>Upload Picture</th>
							<td><input type="file" size="50" name="uploaded_file" value=""></td>
						</tr>
						</tbody>
						<tbody id="media" style="display: none;">
						<tr>
							<th>URL</th>
							<td><input type="text" size="50" name="location_media_url" value=""></td>
						</tr>
						</tbody>
						<tr>
							<th>Media Caption</th>
							<td><input type="text" size="50" name="location_media_caption" value=""></td>
						</tr>
						</table>
						<center>
						<input type="submit" value=" Add This Media " class="btn btn-primary btn-rounded">
						</center>
						</form>
	
						<script type="text/javascript">
							document.getElementById("picture").style.display="";
							document.getElementById("media").style.display="none";
						</script>
			
						<form name="goback" method="GET">
						<input type="hidden" name="action" value="location">
						<input type="hidden" name="function" value="location_view">
						<input type="hidden" name="location_id" value="{$location.location_id|escape}">
						<input type="hidden" name="tab" value="1">
						</form>
			
					</div>
				</div>
				<br>
			</div>
		</p>
	</div>
</div>

{/block}