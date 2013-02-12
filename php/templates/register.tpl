<h1>Register with F3X Timing</h1>
<form method="POST">
<input type="hidden" name="action" value="register">
<input type="hidden" name="function" value="save_registration">
Become a registered member of F3X Timing and be able to create and view F3X events!<br>
<br>
<table width="50%" cellpadding="2" cellspacing="2" class="tableborder">
<tr class="table-row-heading-left">
	<td colspan="3">Registration Information</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>First Name</td>
	<td colspan="2">
		<input type="text" name="user_first_name" size="40" value="{$user_first_name}">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Last Name</td>
	<td colspan="2">
		<input type="text" name="user_last_name" size="40" value="{$user_last_name}">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Email Address (used for login)</td>
	<td colspan="2">
		<input type="text" name="user_email" size="40" value="{$user_email}">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Password</td>
	<td colspan="2">
		<input type="password" name="user_pass" size="40" value="{$user_pass}">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Password Verify</td>
	<td colspan="2">
		<input type="password" name="user_pass2" size="40" value="{$user_pass2}">
	</td>
</tr>
<tr>
	<td colspan="3" class="table-data-heading-center">
	<input type="submit" value=" Register Me ">
	</td>
</tr>
</table>
</form>
