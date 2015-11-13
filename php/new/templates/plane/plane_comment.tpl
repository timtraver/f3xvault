{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">Plane Details - {$plane.plane_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li>
						<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id|escape}&tab=0" aria-expanded="false">
							Information
						</a>
					</li>
					<li>
						<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id|escape}&tab=1" aria-expanded="false">
							Media
							<span class="badge badge-blue">{$media_total}</span>
						</a>
					</li>
					<li class="active">
						<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id|escape}&tab=2" aria-selected="true" aria-expanded="true">
							Comments
							<span class="badge badge-blue">{$comment_total}</span>
						</a>
					</li>
					<li>
						<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id|escape}&tab=3" aria-expanded="false">
							Competitions
							<span class="badge badge-blue">{$event_total}</span>
						</a>
					</li>
					<li>
						<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id|escape}&tab=4" aria-expanded="false">
							Pilots
							<span class="badge badge-blue">{$pilot_total}</span>
						</a>
					</li>
					{if $f3f_records}
					<li>
						<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id|escape}&tab=5" aria-expanded="false">
							F3F Speed
						</a>
					</li>
					{/if}
					{if $f3b_records}
					<li>
						<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id|escape}&tab=6" aria-expanded="false">
							F3B Speed
						</a>
					</li>
					{/if}
					{if $f3b_distance}
					<li>
						<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id|escape}&tab=7" aria-expanded="false">
							F3B Distance
						</a>
					</li>
					{/if}
				</ul>
				<div class="tab-content">
				<div id="location-tab-2" class="tab-pane fade active in">
					<h2 style="float:left;">Plane Comment Add</h2>
					<div style="float:right;overflow:hidden;">
						<input type="button" value=" Back To Plane View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
					</div>
					<br style="clear:left;">

					<form name="main" method="POST">
					<input type="hidden" name="action" value="plane">
					<input type="hidden" name="function" value="plane_comment_save">
					<input type="hidden" name="plane_id" value="{$plane.plane_id}">
										
					<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
					<tr>
						<th>Plane</th>
						<td>
							{$plane.plane_name|escape}
						</td>
					</tr>
					<tr>
						<th valign="top">Comment</th>
						<td>
							<textarea cols="75" rows="8" name="plane_comment_string"></textarea>
						</td>
					</tr>
					</table>
					<center>
						<input type="submit" value=" Add This Comment " class="btn btn-primary btn-rounded">
					</center>
					</form>

					<form name="goback" method="GET">
					<input type="hidden" name="action" value="plane">
					<input type="hidden" name="function" value="plane_view">
					<input type="hidden" name="plane_id" value="{$plane.plane_id}">
					<input type="hidden" name="tab" value="2">
					</form>

				</div>
			</div>
			<br>
		</div>
	</div>
</div>

{/block}