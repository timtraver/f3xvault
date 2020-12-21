{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">
				
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr class="table-row-heading-left">
			<th colspan="8">Admin Location Attributes</th>
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
				{if $cat_name!=$a.location_att_cat_name}
					<a href="?action=admin&function=admin_location_cat_edit&location_att_cat_id={$a.location_att_cat_id|escape}" class="btn-link">{$a.location_att_cat_name|escape}</a>
				{/if}
			</td>
			<td>
				{if $cat_name!=$a.location_att_cat_name}
					{$a.location_att_cat_order|escape}
				{/if}
			</td>
			<td>
				<a href="?action=admin&function=admin_location_att_edit&location_att_id={$a.location_att_id|escape}" class="btn-link">{$a.location_att_name|escape}</a>
			</td>
			<td>{$a.location_att_description|truncate:"50"|escape}</td>
			<td>{$a.location_att_type|escape}</td>
			<td>{$a.location_att_size|escape}</td>
			<td>{$a.location_att_order|escape}</td>
			<td>
					<a href="?action=admin&function=admin_location_att_del&location_att_id={$a.location_att_id|escape:"URL"}"><img src="images/del.gif"></a>
			</td>
		</tr>
		{$cat_name=$a.location_att_cat_name}
		{/foreach}
		<tr>
			<td colspan="8" class="table-data-heading-center">
			<input type="button" value=" Create New Attribute " onclick="document.new_attribute.submit();" class="btn btn-primary btn-rounded">
			<input type="button" value=" Go Back " onclick="document.goback.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>
		
		<br>
		
		<table width="30%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr class="table-row-heading-left">
			<th colspan="3">Admin Location Attribute Categories</th>
		</tr>
		<tr>
			<th class="table-data-heading-left">Attribute Category</th>
			<th class="table-data-heading-left">Order</th>
			<th class="table-data-heading-left"></th>
		</tr>
		{foreach $categories as $c}
		<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
			<td>
					<a href="?action=admin&function=admin_location_cat_edit&location_att_cat_id={$c.location_att_cat_id|escape:"URL"}" class="btn-link">{$c.location_att_cat_name|escape}</a>
			</td>
			<td>
					{$c.location_att_cat_order|escape}
			</td>
			<td>
					<a href="?action=admin&function=admin_location_cat_del&location_att_cat_id={$c.location_att_cat_id|escape}"><img src="images/del.gif"></a>
			</td>
		</tr>
		{/foreach}
		<tr>
			<td colspan="3" class="table-data-heading-center">
			<input type="button" value=" Create New Category " onclick="document.new_category.submit();" class="btn btn-primary btn-rounded">
			<input type="button" value=" Go Back " onclick="document.goback.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>

	</div>
</div>

 
<form name="goback" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_view">
</form>
<form name="new_attribute" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_location_att_edit">
<input type="hidden" name="location_att_id" value="0">
</form>
<form name="new_category" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_location_cat_edit">
<input type="hidden" name="location_att_cat_id" value="0">
</form>
{/block}