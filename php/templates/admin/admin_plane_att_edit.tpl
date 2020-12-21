{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">

		<h2 class="post-title entry-title">Admin Plane Attributes Edit</h2>


		<form name="main" method="POST">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_plane_att_save">
		<input type="hidden" name="plane_att_id" value="{$attribute.plane_att_id|escape}">
		
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
		<tr class="table-row-heading-left">
			<th colspan="2">Admin Plane Attributes</th>
		</tr>
		<tr>
			<th>Attribute Category</th>
			<td>
				<select name="plane_att_cat_id">
				{foreach $categories as $c}
				<option value="{$c.plane_att_cat_id|escape}"{if $c.plane_att_cat_id==$attribute.plane_att_cat_id} SELECTED{/if}>{$c.plane_att_cat_name|escape}</option>
				{/foreach}
				</select>
			</td>
		</tr>
		<tr>
			<th>Attribute Name</th>
			<td>
				<input type="text" name="plane_att_name" size="40" value="{$attribute.plane_att_name|escape}">
			</td>
		</tr>
		<tr>
			<th>Attribute Description</th>
			<td>
				<textarea name="plane_att_description" cols="80" rows="3">{$attribute.plane_att_description|escape}</textarea>
			</td>
		</tr>
		<tr>
			<th>Attribute Type</th>
			<td>
				<select name="plane_att_type">
				<option value="boolean"{if $attribute.plane_att_cat_id=='boolean'} SELECTED{/if}>Boolean Checkbox</option>
				<option value="text"{if $attribute.plane_att_cat_id=='text'} SELECTED{/if}>Text Field</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>Attribute Size</th>
			<td>
				<input type="text" name="plane_att_size" size="5" value="{$attribute.plane_att_size|escape}">
			</td>
		</tr>
		<tr>
			<th>Attribute Order</th>
			<td>
				<input type="text" name="plane_att_order" size="5" value="{$attribute.plane_att_order|escape}">
			</td>
		</tr>
		<tr>
			<td colspan="2" class="table-data-heading-center">
			<input type="button" value=" Go Back " onclick="document.goback.submit();" class="btn btn-primary btn-rounded">
			<input type="button" value=" Save " onclick="document.main.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>
		</form>

	</div>
</div>
 
<form name="goback" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_plane">
</form>
{/block}
