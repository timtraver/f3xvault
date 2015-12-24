<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                

<h1 class="post-title entry-title">F3X Vault User Login</h1>
<br \>
<center>
<form name="login" method="POST">
<input type="hidden" name="action" value="main">
<input type="hidden" name="function" value="user_login">
<input type="hidden" name="redirect_action" value="{$redirect_action}">
<input type="hidden" name="redirect_function" value="{$redirect_function}">
{foreach $request as $key=>$value}
	{if $key!='action' && $key!='function' && $key!='login' && $key!='password' && $key!='redirect_action' && $key!='redirect_function'}
	<input type="hidden" name="{$key}" value="{$value}">
	{/if}
{/foreach}
<table width="30%" cellpadding="2" cellspacing="1">
<tr>
	<th colspan="2">
		F3X Vault Login
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
			<input type="password" name="password" size="30" class="text"><br>
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
<script>
	document.login.login.focus();
</script>

	</div>
</div>