<?php /* Smarty version Smarty-3.1.11, created on 2012-09-09 06:04:32
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\plane_comment.tpl" */ ?>
<?php /*%%SmartyHeaderCode:12449504c31703f0637-55859710%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'fa9d1001b9559fa8f5e51a9268aaabcadca1c6ef' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\plane_comment.tpl',
      1 => 1347170307,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '12449504c31703f0637-55859710',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'plane_id' => 0,
    'plane' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_504c317042c9d1_23212008',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_504c317042c9d1_23212008')) {function content_504c317042c9d1_23212008($_smarty_tpl) {?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Plane Database</h1>
		<div class="entry-content clearfix">
		
<form name="main" method="POST">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_comment_save">
<input type="hidden" name="plane_id" value="<?php echo $_smarty_tpl->tpl_vars['plane_id']->value;?>
">

<h1 class="post-title entry-title">Plane Comment Add</h1>

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Plane</th>
	<td>
		<?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_name'];?>

	</td>
</tr>
<tr>
	<th valign="top">Comment</th>
	<td>
		<textarea cols="75" rows="8" name="plane_comment_string"></textarea>
	</td>
</tr>
</table>
<center>
<br>
<input type="submit" value=" Add This Comment " class="block-button">
<input type="button" value=" Back To Plane Profile " class="block-button" onclick="goback.submit();">
</center>
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_view">
<input type="hidden" name="plane_id" value="<?php echo $_smarty_tpl->tpl_vars['plane_id']->value;?>
">
</form>

</div>
</div>
</div>
<?php }} ?>