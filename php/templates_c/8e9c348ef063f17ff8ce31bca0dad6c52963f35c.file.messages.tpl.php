<?php /* Smarty version Smarty-3.1.11, created on 2012-08-20 06:40:27
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\messages.tpl" */ ?>
<?php /*%%SmartyHeaderCode:212865026ff921cf571-07288918%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '8e9c348ef063f17ff8ce31bca0dad6c52963f35c' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\messages.tpl',
      1 => 1345444824,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '212865026ff921cf571-07288918',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_5026ff92246284_22500441',
  'variables' => 
  array (
    'messages' => 0,
    'message_graphic' => 0,
    'message' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5026ff92246284_22500441')) {function content_5026ff92246284_22500441($_smarty_tpl) {?><?php if ($_smarty_tpl->tpl_vars['messages']->value){?>
<table width="100%" bgcolor="#lightblue" height="30" cellpadding="10">
<tr>
	<td align="left">
	<?php echo $_smarty_tpl->tpl_vars['message_graphic']->value;?>

	<?php  $_smarty_tpl->tpl_vars['message'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['message']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['messages']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['message']->key => $_smarty_tpl->tpl_vars['message']->value){
$_smarty_tpl->tpl_vars['message']->_loop = true;
?>
	<font color="<?php echo $_smarty_tpl->tpl_vars['message']->value['message_color'];?>
" size="-1">
	<?php echo $_smarty_tpl->tpl_vars['message']->value['message'];?>

	</font>
	<br>
	<?php } ?>
	</td>
</tr>
</table>
<br>
<?php }?>
<?php }} ?>