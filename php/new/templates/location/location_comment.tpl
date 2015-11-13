{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Location Details - {$location.location_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
		<div class="tab-base">
			<ul class="nav nav-tabs">
				<li>
					<a href="?action=location&function=location_view&location_id={$location.location_id|escape}&tab=0" aria-expanded="false">
						Information
					</a>
				</li>
				<li>
					<a href="?action=location&function=location_view&location_id={$location.location_id|escape}&tab=1" aria-expanded="false">
						Media
						<span class="badge badge-blue">{$media|count}</span>
					</a>
				</li>
				<li class="active">
					<a href="?action=location&function=location_view&location_id={$location.location_id|escape}&tab=2" aria-expanded="true" aria-selected="true">
						Comments
						<span class="badge badge-blue">{$comments|count}</span>
					</a>
				</li>
				<li>
					<a href="?action=location&function=location_view&location_id={$location.location_id|escape}&tab=3" aria-expanded="false">
						Competitions
						<span class="badge badge-blue">{$totalrecords}</span>
					</a>
				</li>
			</ul>
			<div class="tab-content">
				<div id="location-tab-3" class="tab-pane fade active in">
					<h2 style="float:left;">Location Comment Add</h2>
					<div style="float:right;overflow:hidden;">
						<input type="button" value=" Back To Location View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
					</div>
					<br style="clear:left;">


					<form name="main" method="POST">
					<input type="hidden" name="action" value="location">
					<input type="hidden" name="function" value="location_comment_save">
					<input type="hidden" name="location_id" value="{$location.location_id}">
					<input type="hidden" name="tab" value="2">
					
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
					<tr>
						<th>Location</th>
						<td>
							{$location.location_name|escape}
						</td>
					</tr>
					<tr>
						<th valign="top">Comment</th>
						<td>
							<textarea cols="75" rows="8" name="location_comment_string"></textarea>
						</td>
					</tr>
					</table>
					<center>
						<input type="submit" value=" Add This Comment " class="btn btn-primary btn-rounded">
					</center>
					</form>

					<form name="goback" method="GET">
					<input type="hidden" name="action" value="location">
					<input type="hidden" name="function" value="location_view">
					<input type="hidden" name="location_id" value="{$location.location_id}">
					<input type="hidden" name="tab" value="2">
					</form>

				</div>
			</div>
			<br>
		</div>
	</div>
</div>

{/block}