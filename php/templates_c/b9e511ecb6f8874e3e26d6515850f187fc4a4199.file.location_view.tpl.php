<?php /* Smarty version Smarty-3.1.11, created on 2012-09-09 05:52:13
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\location_view.tpl" */ ?>
<?php /*%%SmartyHeaderCode:255115042616d6a9e72-10744525%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'b9e511ecb6f8874e3e26d6515850f187fc4a4199' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\location_view.tpl',
      1 => 1347169930,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '255115042616d6a9e72-10744525',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_5042616d842767_90469358',
  'variables' => 
  array (
    'location' => 0,
    'rand' => 0,
    'media' => 0,
    'm' => 0,
    'var' => 0,
    'location_attributes' => 0,
    'la' => 0,
    'cat' => 0,
    'row' => 0,
    'nextit' => 0,
    'comments_num' => 0,
    'comments' => 0,
    'c' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5042616d842767_90469358')) {function content_5042616d842767_90469358($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_date_format')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\modifier.date_format.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Location Database</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Location Details</h1>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Location Name</th>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_name'], ENT_QUOTES, 'UTF-8', true);?>
</td>
	<th style="text-align: center;">Location Media</th>
</tr>
<tr>
	<th>Location</th>
	<td>
		<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_city'], ENT_QUOTES, 'UTF-8', true);?>
 - <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['state_code'], ENT_QUOTES, 'UTF-8', true);?>
, <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['country_code'], ENT_QUOTES, 'UTF-8', true);?>

	</td>
	<td rowspan="4" align="center">
	<?php if ($_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]){?>
	<img src="<?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['location_media_url'];?>
" width="300"><br>
	<a href="<?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['location_media_url'];?>
" rel="gallery" class="fancybox-button" title="<?php if ($_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['wp_user_id']!=0){?><?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['pilot_city'];?>
 - <?php }?><?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['location_media_caption'];?>
">View Slide Show</a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<?php $_smarty_tpl->tpl_vars["found"] = new Smarty_variable("0", null, 0);?>
	<?php  $_smarty_tpl->tpl_vars['m'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['m']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['media']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['m']->key => $_smarty_tpl->tpl_vars['m']->value){
$_smarty_tpl->tpl_vars['m']->_loop = true;
?>
		<?php if ($_smarty_tpl->tpl_vars['m']->value['location_media_type']=='video'&&$_smarty_tpl->tpl_vars['var']->value==0){?>
			<a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_url'];?>
" rel="videos" class="fancybox-media" title="<?php if ($_smarty_tpl->tpl_vars['m']->value['wp_user_id']!=0){?><?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_city'];?>
 - <?php }?><?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_caption'];?>
">View Videos</a>
			<?php $_smarty_tpl->tpl_vars["found"] = new Smarty_variable("1", null, 0);?>
		<?php }?>
	<?php } ?>
	<?php }else{ ?>
		There are currently No pictures or videos available<br>
		Help us out and add some!<br>
	<?php }?>
	</td>
</tr>
<tr>
	<th>Location Map Coordinates</th>
	<td>
		<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_coordinates'], ENT_QUOTES, 'UTF-8', true);?>
 <?php if ($_smarty_tpl->tpl_vars['location']->value['location_coordinates']!=''){?><a class="fancybox-map" href="https://maps.google.com/maps?q=<?php echo rawurlencode($_smarty_tpl->tpl_vars['location']->value['location_coordinates']);?>
+(<?php echo $_smarty_tpl->tpl_vars['location']->value['location_name'];?>
)&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/icons/world.png"></a><?php }?>
	</td>
</tr>
<tr>
	<th>Local RC Club</th>
	<td>
		<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_club'], ENT_QUOTES, 'UTF-8', true);?>

	</td>
</tr>
<tr>
	<th>Local RC Club Website</th>
	<td>
		<a href="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_club_url'], ENT_QUOTES, 'UTF-8', true);?>
" target="_blank"><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_club_url'], ENT_QUOTES, 'UTF-8', true);?>
</a>
	</td>
</tr>
<tr>
	<th valign="top">Full Location Description</th>
	<td colspan="2">
		<?php echo $_smarty_tpl->tpl_vars['location']->value['location_description'];?>

	</td>
</tr>
<tr>
	<th valign="top">Location Directions</th>
	<td colspan="2">
		<?php echo $_smarty_tpl->tpl_vars['location']->value['location_directions'];?>

	</td>
</tr>
<tr>
	<th valign="top">Location Attributes</th>
	<td colspan="3">
		<?php if ($_smarty_tpl->tpl_vars['location_attributes']->value){?>
		<table width="100%" cellspacing="0" cellspadding="1" style="border-style: none;">
		<?php $_smarty_tpl->tpl_vars['cat'] = new Smarty_variable('', null, 0);?>
		<?php $_smarty_tpl->tpl_vars['row'] = new Smarty_variable('0', null, 0);?>
		<?php  $_smarty_tpl->tpl_vars['la'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['la']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['location_attributes']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
 $_smarty_tpl->tpl_vars['smarty']->value['foreach']["las"]['index']=-1;
foreach ($_from as $_smarty_tpl->tpl_vars['la']->key => $_smarty_tpl->tpl_vars['la']->value){
$_smarty_tpl->tpl_vars['la']->_loop = true;
 $_smarty_tpl->tpl_vars['smarty']->value['foreach']["las"]['index']++;
?>
			<?php if ($_smarty_tpl->tpl_vars['la']->value['location_att_cat_name']!=$_smarty_tpl->tpl_vars['cat']->value){?>
				<?php if ($_smarty_tpl->tpl_vars['la']->value['location_att_cat_name']!=''){?>
					<?php if ($_smarty_tpl->tpl_vars['row']->value!=0){?>
					</td></tr>
					<?php }?>
					<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><hr></td></tr>							
				<?php }?>
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><b><?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_cat_name'];?>
</b> : 
				<?php $_smarty_tpl->tpl_vars['row'] = new Smarty_variable('1', null, 0);?>
			<?php }?>
			<?php if ($_smarty_tpl->tpl_vars['la']->value['location_att_type']=='boolean'){?>
				<?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_name'];?>

			<?php }else{ ?>
				<?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_name'];?>
 <input type="text" name="location_att_<?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_id'];?>
" size="<?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_size'];?>
" value="<?php echo $_smarty_tpl->tpl_vars['la']->value['location_att_value_value'];?>
">
			<?php }?>
			<?php $_smarty_tpl->tpl_vars['cat'] = new Smarty_variable($_smarty_tpl->tpl_vars['la']->value['location_att_cat_name'], null, 0);?>
			<?php $_smarty_tpl->tpl_vars['nextit'] = new Smarty_variable($_smarty_tpl->getVariable('smarty')->value['foreach']['las']['index']+1, null, 0);?>
			<?php if ($_smarty_tpl->tpl_vars['location_attributes']->value[$_smarty_tpl->tpl_vars['nextit']->value]['location_att_cat_name']==$_smarty_tpl->tpl_vars['cat']->value){?>
			&nbsp;-&nbsp; 
			<?php }?>
		<?php } ?>
		</td></tr>
		</table>
		<?php }else{ ?>
		This information has not been entered for this location.<br>
		Help us out and enter it!
		<?php }?>
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value="Back To Location List" onClick="goback.submit();" class="block-button">
	</th>
</tr>
</table>

<form name="goback" method="GET">
<input type="hidden" name="action" value="location">
</form>

<h1 class="post-title entry-title">Location Media</h1>
<?php  $_smarty_tpl->tpl_vars['m'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['m']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['media']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['m']->key => $_smarty_tpl->tpl_vars['m']->value){
$_smarty_tpl->tpl_vars['m']->_loop = true;
?>
	<?php if ($_smarty_tpl->tpl_vars['m']->value['location_media_type']=='picture'){?>
		<a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_url'];?>
" rel="gallery" class="fancybox-button" title="<?php if ($_smarty_tpl->tpl_vars['m']->value['wp_user_id']!=0){?><?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_city'];?>
 - <?php }?><?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_caption'];?>
"><img src="/icons/picture.png" style="border-style: none;"></a>
	<?php }else{ ?>
		<a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_url'];?>
" rel="videos" class="fancybox-media" title="<?php if ($_smarty_tpl->tpl_vars['m']->value['wp_user_id']!=0){?><?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_city'];?>
 - <?php }?><?php echo $_smarty_tpl->tpl_vars['m']->value['location_media_caption'];?>
"><img src="/icons/webcam.png" style="border-style: none;"></a>
	<?php }?>
<?php } ?>
</div>
</div>
</div>

<div id="comments" class="clearfix no-ping">
<h4 class="comments gutter-left current"><?php echo $_smarty_tpl->tpl_vars['comments_num']->value;?>
 Location Comments</h4>
<ol class="clearfix" id="comments_list">
		<?php  $_smarty_tpl->tpl_vars['c'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['c']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['comments']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['c']->key => $_smarty_tpl->tpl_vars['c']->value){
$_smarty_tpl->tpl_vars['c']->_loop = true;
?>
			<li class="comment byuser bypostauthor even thread-even depth-1 clearfix" style="padding-left: 10px;">
			<div class="comment-avatar-wrap"><?php echo $_smarty_tpl->tpl_vars['c']->value['avatar'];?>
</div>
			<h5 class="comment-author"><?php echo $_smarty_tpl->tpl_vars['c']->value['user_first_name'];?>
 <?php echo $_smarty_tpl->tpl_vars['c']->value['user_last_name'];?>
</h5>
			<div class="comment-meta"><p class="commentmetadata"><?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['c']->value['location_comment_date'],"%B %e, %Y - %I:%M %p");?>
</p></div>
			<div class="comment-entry"><p><?php echo $_smarty_tpl->tpl_vars['c']->value['location_comment_string'];?>
</p></div>
			</li>
		<?php } ?>
	</ol>
<center>
	<input type="button" value="Add A Comment About This Location" onClick="addcomment.submit();" class="block-button">
</center>
</div>

<form name="addcomment" method="GET">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_comment_add">
<input type="hidden" name="location_id" value="<?php echo $_smarty_tpl->tpl_vars['location']->value['location_id'];?>
">
</form>



<?php }} ?>