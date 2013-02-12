<?php /* Smarty version Smarty-3.1.11, created on 2012-09-09 05:35:46
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\location_comment.tpl" */ ?>
<?php /*%%SmartyHeaderCode:26991504c224a69f043-63988232%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'c97854f2d89bf1ba4cb8d164bb1d41b20e98c833' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\location_comment.tpl',
      1 => 1347167058,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '26991504c224a69f043-63988232',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_504c224a6ef078_60433699',
  'variables' => 
  array (
    'location_id' => 0,
    'location' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_504c224a6ef078_60433699')) {function content_504c224a6ef078_60433699($_smarty_tpl) {?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Location Database</h1>
		<div class="entry-content clearfix">
		
<form name="main" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_comment_save">
<input type="hidden" name="location_id" value="<?php echo $_smarty_tpl->tpl_vars['location_id']->value;?>
">

<h1 class="post-title entry-title">Location Comment Add</h1>

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Location</th>
	<td>
		<?php echo $_smarty_tpl->tpl_vars['location']->value['location_name'];?>

	</td>
</tr>
<tr>
	<th valign="top">Comment</th>
	<td>
		<textarea cols="75" rows="8" name="location_comment_string"></textarea>
	</td>
</tr>
</table>
<center>
<br>
<input type="submit" value=" Add This Comment " class="block-button">
<input type="button" value=" Back To Location Profile " class="block-button" onclick="goback.submit();">
</center>
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_view">
<input type="hidden" name="location_id" value="<?php echo $_smarty_tpl->tpl_vars['location_id']->value;?>
">
</form>

</div>
</div>
</div>
<?php }} ?>