<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                

<h1 class="post-title entry-title">Register with RC Vault</h1>
<form method="POST">
<input type="hidden" name="action" value="register">
<input type="hidden" name="function" value="save_registration">
<p>
Become a registered member of RC Vault and be able to create and Edit Events, Series, Clubs, Planes and Locations!<br>
<br>
You will be sent a verification email and will have to follow the link given to verify your email address.<br>
<br>
Your email address WILL NOT be shared with ANYONE. It will only be used as communication to you from this site, for a forgotten password link or other administrative actions. You will have the option to allow your club or series affiliations to send reminders if you select that option in your preferences.<br>
</p>
<br>
<table width="50%" cellpadding="2" cellspacing="2" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="2">Registration Information</th>
</tr>
<tr>
	<th class="table-data-heading-left" nowrap>User Login</th>
	<td>
		<input type="text" name="user_name" size="40" value="{$user.user_name}">
	</td>
</tr>
<tr>
	<th class="table-data-heading-left" nowrap>First Name</th>
	<td>
		<input type="text" name="user_first_name" size="40" value="{$user.user_first_name}">
	</td>
</tr>
<tr>
	<th class="table-data-heading-left" nowrap>Last Name</th>
	<td>
		<input type="text" name="user_last_name" size="40" value="{$user.user_last_name}">
	</td>
</tr>
<tr>
	<th class="table-data-heading-left" nowrap>Email Address</th>
	<td>
		<input type="text" name="user_email" size="40" value="{$user.user_email}">
	</td>
</tr>
<tr>
	<th class="table-data-heading-left" nowrap>Password</th>
	<td>
		<input type="password" name="user_pass" size="40" value="{$user.user_pass}">
	</td>
</tr>
<tr>
	<th class="table-data-heading-left" nowrap>Password Verify</th>
	<td>
		<input type="password" name="user_pass2" size="40" value="{$user.user_pass2}">
	</td>
</tr>
<tr>
	<th class="table-data-heading-left" nowrap>Human Test</th>
	<td>
		{$recaptcha_html}
	</td>
</tr>
<tr>
	<td colspan="2" class="table-data-heading-center">
	<input type="submit" value=" Register Me " class="button">
	</td>
</tr>
</table>
<br><br><br>
</form>


	</div>
</div>
