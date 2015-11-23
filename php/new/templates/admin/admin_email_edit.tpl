{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">

		<h2>System Email Edit</h2>
		<form method="POST" name="main" enctype="multipart/form-data">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_email_save">
		<input type="hidden" name="email_id" value="{$email.email_id}">
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
		<tr class="table-row-heading-left">
			<td colspan="2">Email Edit</td>
		</tr>
		<tr>
			<td class="table-data-heading-left">Email Name</td>
			<td><input type="text" size="40" name="email_name" value="{$email.email_name|escape}"></td>
		</tr>
		<tr>
			<td class="table-data-heading-left">Email From Name</td>
			<td><input type="text" size="40" name="email_from_name" value="{$email.email_from_name|escape}"></td>
		</tr>
		<tr>
			<td class="table-data-heading-left">Email From Address</td>
			<td><input type="text" size="40" name="email_from_address" value="{$email.email_from_address|escape}"></td>
		</tr>
		<tr>
			<td class="table-data-heading-left">Email Subject</td>
			<td><input type="text" size="40" name="email_subject" value="{$email.email_subject|escape}"></td>
		</tr>
		<tr>
			<td class="table-data-heading-left">Email Content</td>
			<td>
				<textarea cols="80" rows="40" name="email_html">{$email.email_html}</textarea>
			</td>
		</tr>
		<tr>
			<td class="table-data-heading-left">Email Embedded Images</td>
			<td>
				{foreach $images as $i}
				{$i.email_image}
				{$i.email_image_name} <a href="?action=admin&function=admin_email_del_image&email_id={$email.email_id}&email_image_id={$i.email_image_id}"><img src="/images/del.gif"></a><br>
				{/foreach}
				<br>
				Upload an Image : <input type="hidden" name="MAX_FILE_SIZE" value="5000000">
				<input type="file" name="uploadfile" size="60" class="btn btn-primary btn-rounded"><br>
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
<input type="hidden" name="function" value="admin_email">
</form>
{/block}