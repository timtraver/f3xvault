<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                

<h1 class="post-title entry-title">RC Vault User Login</h1>
<br \>
<center>
{if $errorstring != ''}
	<font color=red>{$errorstring}</font>
<br>
<br>
{/if}
<form name="login" method="POST" autocomplete="off">
<input type="hidden" name="action" value="main">
<input type="hidden" name="function" value="user_login">
<table width="30%" cellpadding="2" cellspacing="1">
<tr>
	<th colspan="2">
		RC Vault Login
	</th>
</tr>
<tr>
	<td align="left">
	<center>        
	<table cellpadding="3" cellspacing="1">        
	<tr>        
		<th nowrap>User Name</th>
		<td>
			<input type="text" name="login" size="30" class="text">
		</td>
	</tr>
	<tr>
		<th valign="top">Password</th>
		<td>
			<input type="password" name="password" size="30" class="text" autocomplete="off"><br>
			<a href="?action=main&function=forgot">Forgot your password?</a>
		</td>
	</tr>
	</table>
		<div style="padding-top:5px;"><input type="submit" value=" Log In " class="button"></div>
	</center>
	</td>
</tr>
</table>
Don't have a login? <a href="?action=register">Register Here</a>
</form>
</center>


	</div>
</div>