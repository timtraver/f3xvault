{extends file='layout/layout_login.tpl'}

{block name="header"}
{/block}

{block name="content"}

	<div id="container" class="cls-container">
		<div class="cls-content">
			<div class="cls-content-sm panel">
				<div class="panel-body">
					<p style="font-size: x-large;"><h2 style="color:#337ab7;">F3X Vault User Forgot Password Recovery</h2></p>
						{if $messages}
							{include file="message/messages.tpl"}
						{/if}
						<p>Enter the email address that you have associated with your account, and a temporary password will be sent to that address to allow you to log in and reset your password.
						</p>
						<form name="login" method="POST" autocomplete="off">
						<input type="hidden" name="action" value="main">
						<input type="hidden" name="function" value="forgot_send">
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-envelope-o fa-fw"></i></div>
								<input type="text" name="email" class="form-control" placeholder="Email Address">
							</div>
						</div>
						<div class="row">
							<div class="form-group">
								<button class="btn btn-success text-uppercase" type="submit">Send Me A Recovery Link</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div style="position: fixed;bottom: 0;width: 100%;margin-bottom: 50px;text-align: center;">
		<h1 style="font-size: 60px;font-weight: 900; color:#337ab7;"><a href="/new/?">Enter</a></h1>
	</div>
{/block}