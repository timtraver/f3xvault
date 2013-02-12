<?php /* Smarty version Smarty-3.1.11, created on 2012-08-11 18:01:46
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\register.tpl" */ ?>
<?php /*%%SmartyHeaderCode:112195026eea0ced0b4-23377927%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '9a0e5c32fb561ecf8a52408280b14b9f27bbc06e' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\register.tpl',
      1 => 1344733302,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '112195026eea0ced0b4-23377927',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_5026eea0d371a8_13635721',
  'variables' => 
  array (
    'user_first_name' => 0,
    'user_last_name' => 0,
    'user_email' => 0,
    'user_pass' => 0,
    'user_pass2' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5026eea0d371a8_13635721')) {function content_5026eea0d371a8_13635721($_smarty_tpl) {?><h1>Register with F3X Timing</h1>
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
		<input type="text" name="user_first_name" size="40" value="<?php echo $_smarty_tpl->tpl_vars['user_first_name']->value;?>
">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Last Name</td>
	<td colspan="2">
		<input type="text" name="user_last_name" size="40" value="<?php echo $_smarty_tpl->tpl_vars['user_last_name']->value;?>
">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Email Address (used for login)</td>
	<td colspan="2">
		<input type="text" name="user_email" size="40" value="<?php echo $_smarty_tpl->tpl_vars['user_email']->value;?>
">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Password</td>
	<td colspan="2">
		<input type="password" name="user_pass" size="40" value="<?php echo $_smarty_tpl->tpl_vars['user_pass']->value;?>
">
	</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>Password Verify</td>
	<td colspan="2">
		<input type="password" name="user_pass2" size="40" value="<?php echo $_smarty_tpl->tpl_vars['user_pass2']->value;?>
">
	</td>
</tr>
<tr>
	<td colspan="3" class="table-data-heading-center">
	<input type="submit" value=" Register Me ">
	</td>
</tr>
</table>
</form>
<?php }} ?>