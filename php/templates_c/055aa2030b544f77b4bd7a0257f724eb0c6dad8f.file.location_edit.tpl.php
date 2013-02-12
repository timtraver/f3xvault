<?php /* Smarty version Smarty-3.1.11, created on 2012-09-03 20:42:54
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\location_edit.tpl" */ ?>
<?php /*%%SmartyHeaderCode:17767504252b2b2c601-59413431%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '055aa2030b544f77b4bd7a0257f724eb0c6dad8f' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\location_edit.tpl',
      1 => 1346704967,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '17767504252b2b2c601-59413431',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_504252b2c470c5_86564536',
  'variables' => 
  array (
    'location' => 0,
    'countries' => 0,
    'country' => 0,
    'states' => 0,
    'state' => 0,
    'location_attributes' => 0,
    'la' => 0,
    'cat' => 0,
    'col' => 0,
    'media' => 0,
    'm' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_504252b2c470c5_86564536')) {function content_504252b2c470c5_86564536($_smarty_tpl) {?><?php if (!is_callable('smarty_function_cycle')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\function.cycle.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Location Database</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Location Information Edit</h1>
<form name="main" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_save">
<input type="hidden" name="location_id" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_id'], ENT_QUOTES, 'UTF-8', true);?>
">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Location Name</th>
	<td><input type="text" size="50" name="location_name" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_name'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>Location City</th>
	<td>
		<input type="text" size="50" name="location_city" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_city'], ENT_QUOTES, 'UTF-8', true);?>
">
	</td>
</tr>
<tr>
	<th>Location Country</th>
	<td>
		<select name="country_id">
		<?php  $_smarty_tpl->tpl_vars['country'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['country']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['countries']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['country']->key => $_smarty_tpl->tpl_vars['country']->value){
$_smarty_tpl->tpl_vars['country']->_loop = true;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['country']->value['country_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['country']->value['country_id']==$_smarty_tpl->tpl_vars['location']->value['country_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['country']->value['country_name'];?>
</option>
		<?php } ?>
		</select>
	</td>
</tr>
<tr>
	<th>Location State</th>
	<td>
		<select name="state_id">
		<?php  $_smarty_tpl->tpl_vars['state'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['state']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['states']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['state']->key => $_smarty_tpl->tpl_vars['state']->value){
$_smarty_tpl->tpl_vars['state']->_loop = true;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['state']->value['state_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['state']->value['state_id']==$_smarty_tpl->tpl_vars['location']->value['state_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['state']->value['state_name'];?>
</option>
		<?php } ?>
		</select>
	</td>
</tr>
<tr>
	<th>Map Coordinates</th>
	<td><input type="text" size="30" name="location_coordinates" value="<?php echo preg_replace("%(?<!\\\\)'%", "\'",$_smarty_tpl->tpl_vars['location']->value['location_coordinates']);?>
"></td>
</tr>
<tr>
	<th>Local RC Club</th>
	<td><input type="text" size="50" name="location_club" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_club'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>RC Club Website URL</th>
	<td><input type="text" size="50" name="location_club_url" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_club_url'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th valign="top">Location Description</th>
	<td><textarea cols="70" rows="10" name="location_description"><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_description'], ENT_QUOTES, 'UTF-8', true);?>
</textarea></td>
</tr>
<tr>
	<th valign="top">Location Detailed Directions</th>
	<td><textarea cols="70" rows="10" name="location_directions"><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_directions'], ENT_QUOTES, 'UTF-8', true);?>
</textarea></td>
</tr>
<tr>
	<th valign="top">Location Attributes</th>
	<td>
		<table width="100%" cellspacing="0" cellspadding="1" style="border-style: none;">
		<?php $_smarty_tpl->tpl_vars['cat'] = new Smarty_variable('', null, 0);?>
		<?php  $_smarty_tpl->tpl_vars['la'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['la']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['location_attributes']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['la']->key => $_smarty_tpl->tpl_vars['la']->value){
$_smarty_tpl->tpl_vars['la']->_loop = true;
?>
			<?php if ($_smarty_tpl->tpl_vars['la']->value['location_att_cat_name']!=$_smarty_tpl->tpl_vars['cat']->value){?>
				<?php if ($_smarty_tpl->tpl_vars['la']->value['location_att_cat_name']!=''){?>
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><hr></td></tr>
				<?php }?>
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><b><?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_cat_name'];?>
</b></td></tr>
				<tr style="border-style: none;">
				<?php $_smarty_tpl->tpl_vars['col'] = new Smarty_variable('1', null, 0);?>
			<?php }?>
			<?php if ($_smarty_tpl->tpl_vars['la']->value['location_att_type']=='boolean'){?>
				<td style="border-style: none;" nowrap>
					<input type="checkbox" name="location_att_<?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['la']->value['location_att_value_status']==1&&$_smarty_tpl->tpl_vars['la']->value['location_att_value_value']==1){?>CHECKED<?php }?>> <?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_name'];?>

				</td>
			<?php }else{ ?>
				<td style="border-style: none;" nowrap>
					<?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_name'];?>
 <input type="text" name="location_att_<?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_id'];?>
" size="<?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_size'];?>
" value="<?php if ($_smarty_tpl->tpl_vars['la']->value['location_att_value_status']==1){?><?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_value_value'];?>
<?php }?>"> 
				</td>
			<?php }?>
			<?php if ($_smarty_tpl->tpl_vars['col']->value>2){?>
			</tr><tr style="border-style: none;">
			<?php $_smarty_tpl->tpl_vars['col'] = new Smarty_variable("0", null, 0);?>
			<?php }?>
			<?php $_smarty_tpl->tpl_vars['col'] = new Smarty_variable($_smarty_tpl->tpl_vars['col']->value+1, null, 0);?>
			<?php $_smarty_tpl->tpl_vars['cat'] = new Smarty_variable($_smarty_tpl->tpl_vars['la']->value['location_att_cat_name'], null, 0);?>
		<?php } ?>
		</tr>
		</table>
	</td>
</tr>



<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value="Cancel Edit" onClick="goback.submit();" class="block-button">
		<input type="submit" value="Save Location Values" class="block-button">
	</th>
</tr>
</table>

</form>

<div id="media">
<h1 class="post-title entry-title">Location Media</h1>
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
		<td><?php if ($_smarty_tpl->tpl_vars['m']->value['location_media_type']=='picture'){?>Picture<?php }else{ ?>Video<?php }?></td>
		<?php if ($_smarty_tpl->tpl_vars['m']->value['location_media_type']=='picture'){?>
			<td><a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_url'];?>
" rel="gallery" class="fancybox-button" title="<?php if ($_smarty_tpl->tpl_vars['m']->value['wp_user_id']!=0){?><?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_city'];?>
 - <?php }?><?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_caption'];?>
"><?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_url'];?>
</a></td>
		<?php }else{ ?>
			<td><a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_url'];?>
" rel="videos" class="fancybox-media" title="<?php if ($_smarty_tpl->tpl_vars['m']->value['wp_user_id']!=0){?><?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_city'];?>
 - <?php }?><?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_caption'];?>
"><?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_url'];?>
</a></td>
		<?php }?>
		<td> <a href="?action=location&function=location_media_del&location_id=<?php echo $_smarty_tpl->tpl_vars['location']->value['location_id'];?>
&location_media_id=<?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_id'];?>
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
<input type="button" name="media" value="Add New Location Media" onClick="add_media.submit()" class="block-button" <?php if ($_smarty_tpl->tpl_vars['location']->value['location_id']==0){?>disabled="disabled" style=""<?php }?>>
</center>
</div>

<form name="add_media" method="GET">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_media_edit">
<input type="hidden" name="location_id" value="<?php echo $_smarty_tpl->tpl_vars['location']->value['location_id'];?>
">
</form>


<form name="goback" method="GET">
<input type="hidden" name="action" value="location">
</form>

</div>
</div>
</div>

<?php }} ?>