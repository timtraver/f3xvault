<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Feature Requirement</h1>		
		<div class="entry-content clearfix">
			<h3>You must be a registered member and logged in to use this feature!</h3>
			<p>In order to take full advantage of all of this sites features, you must be a registered user, and log in with your username and password.</p>
			<p>When logged in, you will be able to :
			<ul>
				<li>Edit your pilot profile which includes which planes you fly and your favorite locations</li>
				<li>Add comments to posts, locations, planes, etc...</li>
				<li>Add and edit F3X flying locations to the database</li>
				<li>Add and edit F3X planes to the database</li>
				<li>Use the event scoring system</li>
				<li>Edit club and series info</li>
			</p>
		</div>
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
		</form>
		</center>
		<script>
			document.login.login.focus();
		</script>

			<input type="button" value=" Log Me In " class="button" style="display:inline;float:none;" onClick="document.login.submit();"> or 
			<input type="button" value=" Register Me " class="button" style="display:inline;float:none;" onClick="document.register.submit();">
		</center>
		<br>
	</div>
</div>
<form name="register" method="GET">
<input type="hidden" name="action" value="register">
</form>
