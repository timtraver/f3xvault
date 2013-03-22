<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                

<h1 class="post-title entry-title">RC Vault User Password Change</h1>
<br \>
<center>
<form name="login" method="POST" autocomplete="off">
<input type="hidden" name="action" value="main">
<input type="hidden" name="function" value="pass_recovery_save">
<input type="hidden" name="user_id" value="{$user_info.user_id}">
<input type="hidden" name="hash" value="hash">
<table width="30%" cellpadding="2" cellspacing="1">
<tr>
	<th colspan="2">
		RC Vault Password Recovery
	</th>
</tr>
<tr>
	<td align="left">
	<center>        
	<table cellpadding="3" cellspacing="1">        
	<tr>
		<th valign="top">New Password</th>
		<td>
			<input type="password" name="pass1" size="30" class="text" autocomplete="off"><br>
		</td>
	</tr>
	<tr>
		<th valign="top">Verify New Password</th>
		<td>
			<input type="password" name="pass2" size="30" class="text" autocomplete="off"><br>
		</td>
	</tr>
	</table>
		<div style="padding-top:5px;"><input type="submit" value=" Change My Password " class="button"></div>
	</center>
	</td>
</tr>
</table>
</form>
</center>


	</div>
</div>