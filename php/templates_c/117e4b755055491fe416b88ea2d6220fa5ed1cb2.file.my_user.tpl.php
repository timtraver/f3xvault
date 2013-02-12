<?php /* Smarty version Smarty-3.1.11, created on 2012-08-12 01:52:25
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\my_user.tpl" */ ?>
<?php /*%%SmartyHeaderCode:1840150276ec9410427-24632952%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '117e4b755055491fe416b88ea2d6220fa5ed1cb2' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\my_user.tpl',
      1 => 1341358060,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '1840150276ec9410427-24632952',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'action' => 0,
    'user_info' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_50276ec947ac71_15571732',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_50276ec947ac71_15571732')) {function content_50276ec947ac71_15571732($_smarty_tpl) {?><h1>My User Information</h1>
<form method="POST">
<input type="hidden" name="action" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
">
<input type="hidden" name="function" value="my_user_save">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<td colspan="2">User</td>
</tr>
<tr>
	<td class="table-data-heading-left">User Name</td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['user_info']->value['user_name'], ENT_QUOTES, 'UTF-8', true);?>
</td>
</tr>
<tr>
	<td class="table-data-heading-left">User Full Name</td>
	<td><input type="text" size="30" name="user_full_name" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['user_info']->value['user_full_name'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<td colspan="2" class="table-data-heading-center">
	<input type="submit" value=" Save User Values ">
	</td>
</tr>
</form>
<tr>
	<td colspan="2" class="table-data-heading-center">
	<input type="button" value=" Back " onClick="goback.submit();">
	</td>
</tr>
</table>

<form method="POST" action="/" name="goback">
</form>
<?php }} ?>