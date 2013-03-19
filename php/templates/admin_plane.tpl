<div id="post-1" class="post-1 post type-post status-publish format-standard hentry category-uncategorized clearfix post">
	<div class="entry clearfix">
		<h2 class="post-title entry-title">RC Vault Admin area !</h2>
				<div class="entry-content clearfix">
				
				<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
				<tr class="table-row-heading-left">
					<th colspan="8">Admin Plane Attributes</th>
				</tr>
				<tr>
					<th>Attribute Category</th>
					<th>Order</th>
					<th>Attribute Name</th>
					<th>Attribute Description</th>
					<th>Attribute Type</th>
					<th>Attribute Size</th>
					<th>Order</th>
					<th></th>
				</tr>
				{$cat_name=''}
				{foreach $attributes as $a}
				<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
					<td>
						{if $cat_name!=$a.plane_att_cat_name}
							<a href="?action=admin&function=admin_plane_cat_edit&plane_att_cat_id={$a.plane_att_cat_id}">{$a.plane_att_cat_name}</a>
						{/if}
					</td>
					<td>
						{if $cat_name!=$a.plane_att_cat_name}
							{$a.plane_att_cat_order}
						{/if}
					</td>
					<td>
						<a href="?action=admin&function=admin_plane_att_edit&plane_att_id={$a.plane_att_id}">{$a.plane_att_name}</a>
					</td>
					<td>{$a.plane_att_description|truncate:"50"}</td>
					<td>{$a.plane_att_type}</td>
					<td>{$a.plane_att_size}</td>
					<td>{$a.plane_att_order}</td>
					<td>
							<a href="?action=admin&function=admin_plane_att_del&plane_att_id={$a.plane_att_id}"><img src="images/del.gif"></a>
					</td>
				</tr>
				{$cat_name=$a.plane_att_cat_name}
				{/foreach}
				<tr>
					<td colspan="8" class="table-data-heading-center">
					<input type="button" value=" Create New Attribute " onclick="document.new_attribute.submit();" class="button">
					<input type="button" value=" Go Back " onclick="document.goback.submit();" class="button">
					</td>
				</tr>
				</table>
				
				<br>
				
				<table width="30%" cellpadding="2" cellspacing="1" class="tableborder">
				<tr class="table-row-heading-left">
					<th colspan="3">Admin Plane Attribute Categories</th>
				</tr>
				<tr>
					<th class="table-data-heading-left">Attribute Category</th>
					<th class="table-data-heading-left">Order</th>
					<th class="table-data-heading-left"></th>
				</tr>
				{foreach $categories as $c}
				<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
					<td>
							<a href="?action=admin&function=admin_plane_cat_edit&plane_att_cat_id={$c.plane_att_cat_id}">{$c.plane_att_cat_name}</a>
					</td>
					<td>
							{$c.plane_att_cat_order}
					</td>
					<td>
							<a href="?action=admin&function=admin_plane_cat_del&plane_att_cat_id={$c.plane_att_cat_id}"><img src="images/del.gif"></a>
					</td>
				</tr>
				{/foreach}
				<tr>
					<td colspan="3" class="table-data-heading-center">
					<input type="button" value=" Create New Category " onclick="document.new_category.submit();" class="button">
					<input type="button" value=" Go Back " onclick="document.goback.submit();" class="button">
					</td>
				</tr>
				</table>

				</div>
	</div>
</div>

 
<form name="goback" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_view">
</form>
<form name="new_attribute" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_plane_att_edit">
<input type="hidden" name="plane_att_id" value="0">
</form>
<form name="new_category" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_plane_cat_edit">
<input type="hidden" name="plane_att_cat_id" value="0">
</form>
