<?php /* Smarty version Smarty-3.1.11, created on 2012-08-12 01:51:49
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\main.tpl" */ ?>
<?php /*%%SmartyHeaderCode:261645027414da86857-25683712%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '76b4be7791b2c7ee590ae788ed37d2579363ca97' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\main.tpl',
      1 => 1344761505,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '261645027414da86857-25683712',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_5027414de350c5_24713239',
  'variables' => 
  array (
    'user' => 0,
    'events' => 0,
    'record' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5027414de350c5_24713239')) {function content_5027414de350c5_24713239($_smarty_tpl) {?><?php if (!is_callable('smarty_function_cycle')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\function.cycle.php';
?>Welcome to F3X Timing <?php echo $_smarty_tpl->tpl_vars['user']->value['user_first_name'];?>
 !<br>
<br>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<td colspan="6" align="left">Your Recent Events</td>
</tr>
<tr>
	<td class="table-data-heading-left" width="10%" nowrap>Event Date</td>
	<td class="table-data-heading-left">Event Title</td>
	<td class="table-data-heading-left">Location</td>
</tr>
<?php  $_smarty_tpl->tpl_vars['event'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['event']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['events']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['event']->key => $_smarty_tpl->tpl_vars['event']->value){
$_smarty_tpl->tpl_vars['event']->_loop = true;
?>
<tr bgcolor="<?php echo smarty_function_cycle(array('values'=>"#FFFFFF,#E8E8E8"),$_smarty_tpl);?>
">
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['record']->value['host'], ENT_QUOTES, 'UTF-8', true);?>
</td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['record']->value['type'], ENT_QUOTES, 'UTF-8', true);?>
</td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['record']->value['pri'], ENT_QUOTES, 'UTF-8', true);?>
</td>
</tr>
<?php } ?>
</table><?php }} ?>