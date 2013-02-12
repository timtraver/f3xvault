<?php /* Smarty version Smarty-3.1.11, created on 2012-08-11 22:45:32
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\login.tpl" */ ?>
<?php /*%%SmartyHeaderCode:8642502359d9c13bf0-25114788%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '40b2f69861dadea83fab6f0c8dc84bc60d9467d1' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\login.tpl',
      1 => 1344750325,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '8642502359d9c13bf0-25114788',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_502359d9c5f2b8_40747699',
  'variables' => 
  array (
    'errorstring' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_502359d9c5f2b8_40747699')) {function content_502359d9c5f2b8_40747699($_smarty_tpl) {?><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
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
<?php if ($_smarty_tpl->tpl_vars['errorstring']->value!=''){?>
	<font color=red><?php echo $_smarty_tpl->tpl_vars['errorstring']->value;?>
</font>
<br>
<br>
<?php }?>
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
<?php }} ?>