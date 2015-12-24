{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">
		<br>
		<div class="entry-content clearfix">
			<ul>
				<li><a href="?action=admin&function=admin_email" class="btn-link">Email Admin</a></li>
				<li><a href="?action=admin&function=admin_location" class="btn-link">Location Attributes Admin</a></li>
				<li><a href="?action=admin&function=admin_plane" class="btn-link">Plane Attributes Admin</a></li>
				<li><a href="?action=admin&function=admin_user_list" class="btn-link">User Admin</a></li>
				<li><a href="?action=admin&function=admin_plane_list" class="btn-link">Plane Admin</a></li>
				<li><a href="?action=admin&function=admin_activity" class="btn-link">Site Activity</a></li>
				<li><a href="?action=location&function=location_calculate_records" class="btn-link">Calculate Location Records</a></li>
			</ul>
		</div>
	</div>
</div>
{/block}
 
