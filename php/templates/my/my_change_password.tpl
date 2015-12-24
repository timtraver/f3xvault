{extends file='layout/layout_login.tpl'}

{block name="header"}
{/block}

{block name="content"}

	<div id="container" class="cls-container">
		<div class="cls-content">
			<div class="cls-content-sm panel">
				<div class="panel-body">
					<p style="font-size: x-large;"><h2 style="color:#337ab7;">F3X Vault User Password Change</h2></p>
						{if $messages}
							{include file="message/messages.tpl"}
						{/if}
						<form name="login" method="POST" autocomplete="off">
						<input type="hidden" name="action" value="my">
						<input type="hidden" name="function" value="change_password">
						<input type="hidden" name="user_id" value="{$user_info.user_id}">
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-key fa-fw"></i></div>
								<input type="password" name="pass" class="form-control" placeholder="Existing Password">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-key fa-fw"></i></div>
								<input type="password" name="pass1" class="form-control" placeholder="New Password">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon"><i class="fa fa-key fa-fw"></i></div>
								<input type="password" name="pass2" class="form-control" placeholder="Confirm Password">
							</div>
						</div>
						<div class="row">
							<div class="form-group">
								<button class="btn btn-success text-uppercase" type="submit">Change My Password</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

{/block}