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
		
			<div class="cls-content-sm panel" style="width: 400px;">
				<div>
					<p style="font-size: x-large;"><h2 style="color:#337ab7;">F3X Vault Login</h2></p>
						{if $messages}
							{include file="message/messages.tpl"}
						{/if}
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
	
							<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-user"></i></div>
								<input type="text" name="login" class="form-control" placeholder="Username or Email Address">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-key fa-fw"></i></div>
								<input type="password" name="password" class="form-control" placeholder="Password">
							</div>
						</div>
						<div class="row">
							<div class="form-group">
								<button class="btn btn-success text-uppercase" type="submit">Sign In</button>
							</div>
						</div>
					</form>
				</div>
			</div>
			<div class="pad-ver">
				<a href="?action=main&function=forgot" class="btn-link mar-rgt">Forgot password ?</a>
				<a href="?action=register" class="btn-link mar-lft">Create a new account</a>
			</div>

		<script>
			document.login.login.focus();
		</script>

	</center>
	<br>


<form name="register" method="GET">
<input type="hidden" name="action" value="register">
</form>

{/block}