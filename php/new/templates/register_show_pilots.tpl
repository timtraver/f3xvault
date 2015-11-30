{extends file='layout/layout_login.tpl'}

{block name="header"}
{/block}

{block name="content"}

	<div id="container" class="cls-container">
		<div class="cls-content">
			<div class="cls-content-lg panel">
				<div class="panel-body">
					<p style="font-size: x-large;"><h2 style="color:#337ab7;">F3X Vault Registration</h2></p>
						{if $messages}
							{include file="message/messages.tpl"}
						{/if}
						<p>
						It looks like we may have you in the database already as a pilot from an event!<br>
						<br>
						Look down through this list and check the box that could be you, and we will associate your account.<br>
						<br>
						</p>
						<form name="login" method="POST" autocomplete="off">
						<input type="hidden" name="action" value="register">
						<input type="hidden" name="function" value="save_registration">
						<input type="hidden" name="from_show_pilots" value="1">
						<div class="form-group">
							<center>
							<div class="input-group">
							<table cellpadding="2" cellspacing="2" class="table">
							<tr>
								<th nowrap>&nbsp;</th>
								<th nowrap>Pilot Name</th>
								<th nowrap>Last Event</th>
							<tr>
							{foreach $pilots as $pilot}
							<tr>
								<td nowrap>
									<input type="radio" name="pilot_id" value="{$pilot.pilot_id}">
								</td>
								<td>{$pilot.pilot_first_name|escape} {$pilot.pilot_last_name|escape}</td>
								<td>{$pilot.eventstring|escape}</td>
							</tr>
							{/foreach}
							<tr>
								<td nowrap>
									<input type="radio" name="pilot_id" value="0" CHECKED>
								</td>
								<td colspan="3">I'm sorry, but none of these pilots are me.</td>
							</tr>
							</table>
							</div>
							</center>
						</div>
						<div class="row">
							<div class="form-group">
								<button class="btn btn-success text-uppercase" type="submit">Register Me</button>
							</div>
						</div>
						
						<input type="hidden" name="user_first_name" value="{$user.user_first_name|escape}">
						<input type="hidden" name="user_last_name" value="{$user.user_last_name|escape}">
						<input type="hidden" name="user_email" value="{$user.user_email|escape}">
						<input type="hidden" name="user_pass" value="{$user.user_pass|escape}">
						<input type="hidden" name="user_pass2" value="{$user.user_pass2|escape}">
						<input type="hidden" name="recaptcha_challenge_field" value="{$recaptcha_challenge_field|escape}">
						<input type="hidden" name="recaptcha_response_field" value="{$recaptcha_response_field|escape}">
						
					</form>
				</div>
			</div>
		</div>
	</div>

{/block}
