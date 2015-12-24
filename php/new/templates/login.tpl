{extends file='layout/layout_login.tpl'}

{block name="header"}
{/block}

{block name="content"}

	<div id="container" class="cls-container">
		<div class="cls-content">
			<div class="cls-content-sm panel">
				<div class="panel-body">
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
		</div>
	</div>
	<div style="position: fixed;bottom: 0;width: 100%;margin-bottom: 50px;text-align: center;">
		<h1 style="font-size: 60px;font-weight: 900; color:#337ab7;"><a href="/new/?">Enter</a></h1>
	</div>
{/block}