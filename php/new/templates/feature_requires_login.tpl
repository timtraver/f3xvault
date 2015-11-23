{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Feature Requirement</h2>
	</div>
	<div class="panel-body">
		<p>
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
			</ul>
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
		<table width="30%" cellpadding="2" cellspacing="1" class="table table-condensed">
		<tr>
			<th align="center" colspan="2">
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
		<script>
			document.login.login.focus();
		</script>

			<input type="button" value=" Log Me In " class="btn btn-primary btn-rounded" onClick="document.login.submit();"> or 
			<input type="button" value=" Register Me " class="btn btn-primary btn-rounded" onClick="document.register.submit();">
	</center>
	<br>
</div>


<form name="register" method="GET">
<input type="hidden" name="action" value="register">
</form>

{/block}