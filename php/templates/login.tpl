<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title>F3X Timing : Login</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body onLoad="document.login.login.focus();">
<table width="100%" height="50" background="images/vampire_launch.jpg">
<tr>
	<td align="left" valign="center">
		<font size="+2"><b>F3X Timing</b></font><br>&copy;Tim Traver 2012
	</td>
</tr>
</table>
<br \>
<br \>
<center>
{if $errorstring != ''}
	<font color=red>{$errorstring}</font>
<br>
<br>
{/if}
<form name="login" method="POST" autocomplete="off">
<input type="hidden" name="action" value="main">
<table width="30%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<td colspan="2">F3X Timing Login
	</td>
</tr>
<tr>
	<td align="left" class="table-data-heading-center">
	<center>        
	<table cellpadding="3" cellspacing="1">        
	<tr>        
		<td nowrap><b>User Name</b>
		</td>       
		<td><input type="text" name="login" size="30" class="text">
		</td>
	</tr>
	<tr>
		<td><b>Password</b>
		</td>
		<td>
		<input type="password" name="password" size="30" class="text" autocomplete="off"><br>
		<a href="?action=forgot">Forgot your password?</a>
		</td>
	</tr>
	<tr>
		<td colspan=2 align=center>
		<input type="submit" value="Login" class="button">
		</td>
	</tr>
	</table>
	<br>
	Don't have a login? <a href="?action=register">Register Here</a>
	<br><br>
	</center>
	</td>
</tr>
</table>
</form>
