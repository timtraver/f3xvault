<div id="post-1" class="post-1 post type-post status-publish format-standard hentry category-uncategorized clearfix post">
	<div class="entry clearfix">
		<h2 class="post-title entry-title">F3X Vault Admin area !</h2>
				<div class="entry-content clearfix">

				<form name="main" method="POST">
				<input type="hidden" name="action" value="admin">
				<input type="hidden" name="function" value="admin_plane_cat_save">
				<input type="hidden" name="plane_att_id" value="{$category.plane_att_cat_id}">
				
				<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
				<tr class="table-row-heading-left">
					<th colspan="2">Admin Plane Category Edit</th>
				</tr>
				<tr>
					<th>Attribute Category</th>
					<td>
						<input type="text" name="plane_att_cat_name" size="40" value="{$category.plane_att_cat_name}">
					</td>
				</tr>
				<tr>
					<th>Attribute Order</th>
					<td>
						<input type="text" name="plane_att_cat_order" size="5" value="{$category.plane_att_cat_order}">
					</td>
				</tr>
				<tr>
					<td colspan="2" class="table-data-heading-center">
					<input type="button" value=" Go Back " onclick="document.goback.submit();" class="button">
					<input type="button" value=" Save " onclick="document.main.submit();" class="button">
					</td>
				</tr>
				</table>
				</form>

				</div>
	</div>
</div>
 
<form name="goback" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_plane">
</form>
