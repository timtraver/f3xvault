<div id="post-1" class="post-1 post type-post status-publish format-standard hentry category-uncategorized clearfix post">
	<div class="entry clearfix">
		<h2 class="post-title entry-title">RC Vault Admin area !</h2>
				<div class="entry-content clearfix">

				<form name="main" method="POST">
				<input type="hidden" name="action" value="admin">
				<input type="hidden" name="function" value="admin_location_att_save">
				<input type="hidden" name="location_att_id" value="{$attribute.location_att_id}">
				
				<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
				<tr class="table-row-heading-left">
					<th colspan="2">Admin Location Attributes</th>
				</tr>
				<tr>
					<th>Attribute Category</th>
					<td>
						<select name="location_att_cat_id">
						{foreach $categories as $c}
						<option value="{$c.location_att_cat_id}"{if $c.location_att_cat_id==$attribute.location_att_cat_id} SELECTED{/if}>{$c.location_att_cat_name}</option>
						{/foreach}
						</select>
					</td>
				</tr>
				<tr>
					<th>Attribute Name</th>
					<td>
						<input type="text" name="location_att_name" size="40" value="{$attribute.location_att_name}">
					</td>
				</tr>
				<tr>
					<th>Attribute Description</th>
					<td>
						<textarea name="location_att_description" cols="80" rows="3">{$attribute.location_att_description}</textarea>
					</td>
				</tr>
				<tr>
					<th>Attribute Type</th>
					<td>
						<select name="location_att_type">
						<option value="boolean"{if $attribute.location_att_cat_id=='boolean'} SELECTED{/if}>Boolean Checkbox</option>
						<option value="text"{if $attribute.location_att_cat_id=='text'} SELECTED{/if}>Text Field</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>Attribute Size</th>
					<td>
						<input type="text" name="location_att_size" size="5" value="{$attribute.location_att_size}">
					</td>
				</tr>
				<tr>
					<th>Attribute Order</th>
					<td>
						<input type="text" name="location_att_order" size="5" value="{$attribute.location_att_order}">
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
<input type="hidden" name="function" value="admin_location">
</form>
