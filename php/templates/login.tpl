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
<table width="30%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="2">
		RC Vault Login
	</th>
</tr>
<tr>
	<td align="left" class="table-data-heading-center">
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
	<tr>
		<td colspan=2 align=center>
		<input type="submit" value=" Log In " class="button">
		</td>
	</tr>
	</table>
	<br>
	Don't have a login? <a href="?action=register">Register Here</a>
	<br><br>
	</center>
	</td>
</tr>
</table>
</form>



	</div>
</div>