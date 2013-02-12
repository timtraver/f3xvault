<?php /* Smarty version Smarty-3.1.11, created on 2012-09-09 06:04:27
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\plane_view.tpl" */ ?>
<?php /*%%SmartyHeaderCode:6695039b78ce225a2-14950549%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '886eb54e95d5e4e1584d2e7382f394a772fc7c8e' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\plane_view.tpl',
      1 => 1347170395,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '6695039b78ce225a2-14950549',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_5039b78d023b18_20921490',
  'variables' => 
  array (
    'plane' => 0,
    'rand' => 0,
    'media' => 0,
    'm' => 0,
    'plane_attributes' => 0,
    'pa' => 0,
    'cat' => 0,
    'row' => 0,
    'nextit' => 0,
    'comments_num' => 0,
    'comments' => 0,
    'c' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5039b78d023b18_20921490')) {function content_5039b78d023b18_20921490($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_date_format')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\modifier.date_format.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Plane Database</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Plane Details</h1>
<script type="text/javascript">
function calc_wingspan(){
	var current_units = '<?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_wingspan_units'];?>
';
	var current_value = <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_wingspan'];?>
;
	var multiple = 2.54;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'in' || current_units == ''){
		calc_value = multiple * current_value;
		calc_units = 'cm';
	}else{
		calc_value = current_value / multiple;
		calc_units = 'in';
	}
	document.getElementById('wingspan').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
}
function calc_length(){
	var current_units = '<?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_length_units'];?>
';
	var current_value = <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_length'];?>
;
	var multiple = 2.54;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'in' || current_units == ''){
		calc_value = multiple * current_value;
		calc_units = 'cm';
	}else{
		calc_value = current_value / multiple;
		calc_units = 'in';
	}
	document.getElementById('length').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
}
function calc_weight(){
	var current_units = '<?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_auw_units'];?>
';
	var current_value = <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_auw'];?>
;
	var multiple = 28.35;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'oz' || current_units == ''){
		calc_value = multiple * current_value;
		calc_units = 'gr';
	}else{
		calc_value = current_value / multiple;
		calc_units = 'oz';
	}
	document.getElementById('weight').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
}
function calc_area(){
	var current_units = '<?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_wing_area_units'];?>
';
	var current_value = <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_wing_area'];?>
;
	var multiple = 6.45;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'in2' || current_units == ''){
		calc_value = multiple * current_value;
		calc_units = 'cm<sup>2</sup>';
	}else{
		calc_value = current_value / multiple;
		calc_units = 'in2';
	}
	document.getElementById('area').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
}
</script>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Plane Name</th>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_name'], ENT_QUOTES, 'UTF-8', true);?>
</td>
	<th style="text-align: center;">Plane Media</th>
</tr>
<tr>
	<th>Plane Classification</th>
	<td>
		<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_type_short_name'], ENT_QUOTES, 'UTF-8', true);?>
 - <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_type_description'], ENT_QUOTES, 'UTF-8', true);?>

	</td>
	<td rowspan="9" align="center">
	<?php if ($_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]){?>
	<img src="<?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['plane_media_url'];?>
" width="300"><br>
	<a href="<?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['plane_media_url'];?>
" rel="gallery" class="fancybox-button" title="<?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['pilot_city'];?>
 <?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['state_code'];?>
 - <?php echo $_smarty_tpl->tpl_vars['media']->value[$_smarty_tpl->tpl_vars['rand']->value]['plane_media_caption'];?>
">View Slide Show</a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_url'];?>
" rel="videos" class="fancybox-media" title="View all of the Videos">View Videos</a>
	<?php }else{ ?>
		There are currently No pictures or videos available<br>
		Help us out and add some!<br>
	<?php }?>
	</td>
</tr>
<tr>
	<th>Plane Wingspan</th>
	<td>
		<?php echo sprintf('%.1f',$_smarty_tpl->tpl_vars['plane']->value['plane_wingspan']);?>
 <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_wingspan_units'];?>

		<span id="wingspan"></span>
	</td>
</tr>
<tr>
	<th>Plane Length</th>
	<td>
		<?php echo sprintf('%.1f',$_smarty_tpl->tpl_vars['plane']->value['plane_length']);?>
 <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_length_units'];?>

		<span id="length"></span>		
	</td>
</tr>
<tr>
	<th>Plane AUW</th>
	<td>
		<?php echo sprintf('%.1f',$_smarty_tpl->tpl_vars['plane']->value['plane_auw']);?>
 <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_auw_units'];?>

		<span id="weight"></span>		
	</td>
</tr>
<tr>
	<th>Plane Wing Area</th>
	<td>
		<?php echo sprintf('%.1f',$_smarty_tpl->tpl_vars['plane']->value['plane_wing_area']);?>
 <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_wing_area_units']=='in2'){?>in<sup>2</sup><?php }else{ ?>cm<sup>2</sup><?php }?>
		<span id="area"></span>		
	</td>
</tr>
<tr>
	<th>Plane Manufacturer</th>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_manufacturer'], ENT_QUOTES, 'UTF-8', true);?>
</td>
</tr>
<tr>
	<th>Manufacturer Country</th>
	<td>
		<?php echo $_smarty_tpl->tpl_vars['plane']->value['country_name'];?>

	</td>
</tr>
<tr>
	<th>Manufacturer Year</th>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_year'], ENT_QUOTES, 'UTF-8', true);?>
</td>
</tr>
<tr>
	<th>Manufacturer Web Site</th>
	<td><a href="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_website'], ENT_QUOTES, 'UTF-8', true);?>
" target="_blank"><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_website'], ENT_QUOTES, 'UTF-8', true);?>
</a></td>
</tr>
<tr>
	<th valign="top">Plane Attributes</th>
	<td colspan="3">
		<?php if ($_smarty_tpl->tpl_vars['plane_attributes']->value){?>
		<table width="100%" cellspacing="0" cellspadding="1" style="border-style: none;">
		<?php $_smarty_tpl->tpl_vars['cat'] = new Smarty_variable('', null, 0);?>
		<?php $_smarty_tpl->tpl_vars['row'] = new Smarty_variable('0', null, 0);?>
		<?php  $_smarty_tpl->tpl_vars['pa'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['pa']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['plane_attributes']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
 $_smarty_tpl->tpl_vars['smarty']->value['foreach']["pas"]['index']=-1;
foreach ($_from as $_smarty_tpl->tpl_vars['pa']->key => $_smarty_tpl->tpl_vars['pa']->value){
$_smarty_tpl->tpl_vars['pa']->_loop = true;
 $_smarty_tpl->tpl_vars['smarty']->value['foreach']["pas"]['index']++;
?>
			<?php if ($_smarty_tpl->tpl_vars['pa']->value['plane_att_cat_name']!=$_smarty_tpl->tpl_vars['cat']->value){?>
				<?php if ($_smarty_tpl->tpl_vars['pa']->value['plane_att_cat_name']!=''){?>
					<?php if ($_smarty_tpl->tpl_vars['row']->value!=0){?>
					</td></tr>
					<?php }?>
					<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><hr></td></tr>							
				<?php }?>
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_cat_name'];?>
</td></tr>
				<tr style="border-style: none;"><td style="border-style: none;">
				<?php $_smarty_tpl->tpl_vars['row'] = new Smarty_variable('1', null, 0);?>
			<?php }?>
			<?php if ($_smarty_tpl->tpl_vars['pa']->value['plane_att_type']=='boolean'){?>
				<?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_name'];?>

			<?php }else{ ?>
				<?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_name'];?>
 <input type="text" name="plane_att_<?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_id'];?>
" size="<?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_size'];?>
" value="<?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_value_value'];?>
">
			<?php }?>
			<?php $_smarty_tpl->tpl_vars['cat'] = new Smarty_variable($_smarty_tpl->tpl_vars['pa']->value['plane_att_cat_name'], null, 0);?>
			<?php $_smarty_tpl->tpl_vars['nextit'] = new Smarty_variable($_smarty_tpl->getVariable('smarty')->value['foreach']['pas']['index']+1, null, 0);?>
			<?php if ($_smarty_tpl->tpl_vars['plane_attributes']->value[$_smarty_tpl->tpl_vars['nextit']->value]['plane_att_cat_name']==$_smarty_tpl->tpl_vars['cat']->value){?>
			&nbsp;-&nbsp; 
			<?php }?>
		<?php } ?>
		</td></tr>
		</table>
		<?php }else{ ?>
		This information has not been entered for this plane.<br>
		Help us out and enter it!
		<?php }?>
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value="Back To Plane List" onClick="goback.submit();" class="block-button">
	</th>
</tr>
</table>
<script type="text/javascript">
	calc_wingspan();
	calc_length();
	calc_weight();
	calc_area();
</script>
<form name="goback" method="GET">
<input type="hidden" name="action" value="plane">
</form>


<h1 class="post-title entry-title">Plane Media</h1>
<?php  $_smarty_tpl->tpl_vars['m'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['m']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['media']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['m']->key => $_smarty_tpl->tpl_vars['m']->value){
$_smarty_tpl->tpl_vars['m']->_loop = true;
?>
	<?php if ($_smarty_tpl->tpl_vars['m']->value['plane_media_type']=='picture'){?>
		<a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_url'];?>
" rel="gallery" class="fancybox-button" title="<?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_city'];?>
 <?php echo $_smarty_tpl->tpl_vars['m']->value['state_code'];?>
 - <?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_caption'];?>
"><img src="/icons/picture.png" style="border-style: none;"></a>
	<?php }else{ ?>
		<a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_url'];?>
" rel="videos" class="fancybox-media" title="<?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_city'];?>
 <?php echo $_smarty_tpl->tpl_vars['m']->value['state_code'];?>
 - <?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_caption'];?>
"><img src="/icons/webcam.png" style="border-style: none;"></a>
	<?php }?>
<?php } ?>
</div>
</div>
</div>

<div id="comments" class="clearfix no-ping">
<h4 class="comments gutter-left current"><?php echo $_smarty_tpl->tpl_vars['comments_num']->value;?>
 Plane Comments</h4>
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
			<div class="comment-meta"><p class="commentmetadata"><?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['c']->value['plane_comment_date'],"%B %e, %Y - %I:%M %p");?>
</p></div>
			<div class="comment-entry"><p><?php echo $_smarty_tpl->tpl_vars['c']->value['plane_comment_string'];?>
</p></div>
			</li>
		<?php } ?>
	</ol>
<center>
	<input type="button" value="Add A Comment About This Plane" onClick="addcomment.submit();" class="block-button">
</center>
</div>

<form name="addcomment" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_comment_add">
<input type="hidden" name="plane_id" value="<?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_id'];?>
">
</form>

<?php }} ?>