{extends file='layout/layout_login.tpl'}

{block name="header"}
<script src='https://www.google.com/recaptcha/api.js'></script>
{/block}


{block name="content"}

	<div id="container" class="cls-container">
		<div class="cls-content">
			<div class="cls-content-sm panel">
				<div class="panel-body">
					<p style="font-size: x-large;"><h2 style="color:#337ab7;">F3X Vault Registration</h2></p>
						{if $messages}
							{include file="message/messages.tpl"}
						{/if}
						<p>
						Become a registered member of F3X Vault and be able to register for events, create and edit new events, series, clubs, planes and locations!<br>
						<br>
						Your email address WILL NOT be shared with ANYONE. It will only be used as communication to you from this site, for a forgotten password link or other administrative actions.<br>
						You can read the official privacy policy <a href="?action=main&function=main_privacy" style="color: red;">here</a>.
						</p>
						<form name="login" method="POST" autocomplete="off">
						<input type="hidden" name="action" value="register">
						<input type="hidden" name="function" value="save_registration">
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-envelope-o fa-fw"></i></div>
								<input type="text" name="user_email" class="form-control" placeholder="Email Address (will be your login)">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-user"></i></div>
								<input type="text" name="user_first_name" class="form-control" placeholder="First Name">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-user"></i></div>
								<input type="text" name="user_last_name" class="form-control" placeholder="Last Name">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-key fa-fw"></i></div>
								<input type="password" name="user_pass" class="form-control" placeholder="Password">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-key fa-fw"></i></div>
								<input type="password" name="user_pass2" class="form-control" placeholder="Confirm Password">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="g-recaptcha" data-sitekey="{$recaptcha_key|escape}"></div>
							</div>
						</div>
						<div class="row">
							<div class="form-group">
								<button class="btn btn-success text-uppercase" type="submit">Register Me</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
{/block}