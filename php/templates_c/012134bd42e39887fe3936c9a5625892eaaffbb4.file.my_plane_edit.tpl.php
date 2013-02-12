<?php /* Smarty version Smarty-3.1.11, created on 2012-09-03 21:46:37
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\my_plane_edit.tpl" */ ?>
<?php /*%%SmartyHeaderCode:1142750332bc5238d10-92041329%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '012134bd42e39887fe3936c9a5625892eaaffbb4' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\my_plane_edit.tpl',
      1 => 1346708789,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '1142750332bc5238d10-92041329',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_50332bc52d24e3_21483530',
  'variables' => 
  array (
    'action' => 0,
    'pilot_plane' => 0,
    'planes' => 0,
    'p' => 0,
    'media' => 0,
    'm' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_50332bc52d24e3_21483530')) {function content_50332bc52d24e3_21483530($_smarty_tpl) {?><?php if (!is_callable('smarty_function_cycle')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\function.cycle.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">My Pilot Profile</h1>
		<div class="entry-content clearfix">

<form name="main" method="POST">
<input type="hidden" name="action" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
">
<input type="hidden" name="function" value="my_plane_save">
<input type="hidden" name="pilot_plane_id" value="<?php echo $_smarty_tpl->tpl_vars['pilot_plane']->value['pilot_plane_id'];?>
">

<h1 class="post-title entry-title">My Plane</h1>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Plane</th>
	<td>
	<select name="plane_id">
	<?php  $_smarty_tpl->tpl_vars['p'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['p']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['planes']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['p']->key => $_smarty_tpl->tpl_vars['p']->value){
$_smarty_tpl->tpl_vars['p']->_loop = true;
?>
		<option value="<?php echo $_smarty_tpl->tpl_vars['p']->value['plane_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['p']->value['plane_id']==$_smarty_tpl->tpl_vars['pilot_plane']->value['plane_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['p']->value['plane_type_short_name'];?>
 - <?php echo $_smarty_tpl->tpl_vars['p']->value['plane_name'];?>
</option>
	<?php } ?>
	</select>
		<input type="button" value=" I Dont See Mine " class="block-button" onClick="create_new_plane.submit();">
	</td>
</tr>
<tr>
	<th>Plane Color Scheme</th>
	<td><input type="text" size="50" name="pilot_plane_color" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['pilot_plane']->value['pilot_plane_color'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
</table>
<center>
<br>
<?php if ($_smarty_tpl->tpl_vars['pilot_plane']->value['pilot_plane_id']==0){?>
	<input type="submit" value=" Add This Plane To My Quiver " class="block-button">
<?php }else{ ?>
	<input type="submit" value=" Save This Plane Info " class="block-button">
<?php }?>
<input type="button" value=" Back To My Pilot Profile " class="block-button" onclick="goback.submit();">
</center>
</form>

<div id="media">
<h1 class="post-title entry-title">Plane Media</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;" width="20%">Media Type</th>
	<th style="text-align: left;">URL</th>
	<th style="text-align: left;">&nbsp;</th>
</tr>
<?php if ($_smarty_tpl->tpl_vars['media']->value){?>
	<?php  $_smarty_tpl->tpl_vars['m'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['m']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['media']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['m']->key => $_smarty_tpl->tpl_vars['m']->value){
$_smarty_tpl->tpl_vars['m']->_loop = true;
?>
	<tr bgcolor="<?php echo smarty_function_cycle(array('values'=>"white,lightgray"),$_smarty_tpl);?>
">
		<td><?php if ($_smarty_tpl->tpl_vars['m']->value['pilot_plane_media_type']=='picture'){?>Picture<?php }else{ ?>Video<?php }?></td>
		<?php if ($_smarty_tpl->tpl_vars['m']->value['location_media_type']=='picture'){?>
			<td><a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_plane_media_url'];?>
" rel="gallery" class="fancybox-button" title="<?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_caption'];?>
"><?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_plane_media_url'];?>
</a></td>
		<?php }else{ ?>
			<td><a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_plane_media_url'];?>
" rel="videos" class="fancybox-media" title="<?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_caption'];?>
"><?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_plane_media_url'];?>
</a></td>
		<?php }?>
		<td> <a href="?action=my&function=my_plane_media_del&pilot_plane_id=<?php echo $_smarty_tpl->tpl_vars['pilot_plane']->value['pilot_plane_id'];?>
&pilot_plane_media_id=<?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_plane_media_id'];?>
" title="Remove Media" onClick="confirm('Are you sure you wish to remove this media?')"><img src="images/del.gif"></a></td>
	</tr>
	<?php } ?>
<?php }else{ ?>
	<tr>
		<td colspan="4">You currently have no media entered.</td>
	</tr>
<?php }?>
</table>
<center>
<br>
<input type="button" name="media" value="Add New Plane Media" onClick="add_media.submit()" class="block-button" <?php if ($_smarty_tpl->tpl_vars['pilot_plane']->value['pilot_plane_id']==0){?>disabled="disabled" style=""<?php }?>>
</center>
</div>

<form name="add_media" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_plane_media_edit">
<input type="hidden" name="pilot_plane_id" value="<?php echo $_smarty_tpl->tpl_vars['pilot_plane']->value['pilot_plane_id'];?>
">
<input type="hidden" name="pilot_plane_media_id" value="0">
</form>
<form name="goback" method="GET">
<input type="hidden" name="action" value="my">
</form>

<form name="create_new_plane" method="POST">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_edit">
<input type="hidden" name="plane_id" value="0">
</form>

</div>
</div>
</div>
<?php }} ?>