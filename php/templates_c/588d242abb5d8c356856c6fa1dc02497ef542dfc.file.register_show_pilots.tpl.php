<?php /* Smarty version Smarty-3.1.11, created on 2012-08-12 23:10:16
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\register_show_pilots.tpl" */ ?>
<?php /*%%SmartyHeaderCode:32677502892304f75e9-47002687%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '588d242abb5d8c356856c6fa1dc02497ef542dfc' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\register_show_pilots.tpl',
      1 => 1344838205,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '32677502892304f75e9-47002687',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_50289230561d38_90141023',
  'variables' => 
  array (
    'pilots' => 0,
    'pilot' => 0,
    'user' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_50289230561d38_90141023')) {function content_50289230561d38_90141023($_smarty_tpl) {?><h1>Register with F3X Timing</h1>
<form method="POST">
<input type="hidden" name="action" value="register">
<input type="hidden" name="function" value="save_registration">
<input type="hidden" name="from_show_pilots" value="1">
It looks like we may have you in the database already as a pilot from an event!<br>
<br>
Look down through this list and check the box that could be you.<br>
<br>
<table width="50%" cellpadding="2" cellspacing="2" class="tableborder">
<tr class="table-row-heading-left">
	<td colspan="4">Possible Pilots</td>
</tr>
<tr>
	<td class="table-data-heading-left" nowrap>&nbsp;</td>
	<td class="table-data-heading-left" nowrap>Pilot Last Name</td>
	<td class="table-data-heading-left" nowrap>Pilot First Name</td>
	<td class="table-data-heading-left" nowrap>Last Event</td>
<tr>
<?php  $_smarty_tpl->tpl_vars['pilot'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['pilot']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['pilots']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['pilot']->key => $_smarty_tpl->tpl_vars['pilot']->value){
$_smarty_tpl->tpl_vars['pilot']->_loop = true;
?>
<tr>
	<td class="table-data-heading-left" nowrap>
		<input type="radio" name="pilot_id" value="<?php echo $_smarty_tpl->tpl_vars['pilot']->value['pilot_id'];?>
">
	</td>
	<td><?php echo $_smarty_tpl->tpl_vars['pilot']->value['pilot_last_name'];?>
</td>
	<td><?php echo $_smarty_tpl->tpl_vars['pilot']->value['pilot_first_name'];?>
</td>
	<td><?php echo $_smarty_tpl->tpl_vars['pilot']->value['eventstring'];?>
</td>
</tr>
<?php } ?>
<tr>
	<td class="table-data-heading-left" nowrap>
		<input type="radio" name="pilot_id" value="0" CHECKED>
	</td>
	<td colspan="3">I'm sorry, but none of these pilots are me.</td>
</tr>
<tr>
	<td colspan="4" class="table-data-heading-center">
	<input type="submit" value="Register Me">
	</td>
</tr>
</table>
<input type="hidden" name="user_first_name" value="<?php echo $_smarty_tpl->tpl_vars['user']->value['user_first_name'];?>
">
<input type="hidden" name="user_last_name" value="<?php echo $_smarty_tpl->tpl_vars['user']->value['user_last_name'];?>
">
<input type="hidden" name="user_email" value="<?php echo $_smarty_tpl->tpl_vars['user']->value['user_email'];?>
">
<input type="hidden" name="user_pass" value="<?php echo $_smarty_tpl->tpl_vars['user']->value['user_pass'];?>
">
<input type="hidden" name="user_pass2" value="<?php echo $_smarty_tpl->tpl_vars['user']->value['user_pass2'];?>
">
</form>
<?php }} ?>