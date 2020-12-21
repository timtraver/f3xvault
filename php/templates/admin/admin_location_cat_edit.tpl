{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">

		<form name="main" method="POST">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_location_cat_save">
		<input type="hidden" name="location_att_id" value="{$category.location_att_cat_id|escape}">
		
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
		<tr class="table-row-heading-left">
			<th colspan="2">Admin Location Category Edit</th>
		</tr>
		<tr>
			<th>Attribute Category</th>
			<td>
				<input type="text" name="location_att_cat_name" size="40" value="{$category.location_att_cat_name|escape}">
			</td>
		</tr>
		<tr>
			<th>Attribute Order</th>
			<td>
				<input type="text" name="location_att_cat_order" size="5" value="{$category.location_att_cat_order|escape}">
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
<input type="hidden" name="function" value="admin_location">
</form>
{/block}