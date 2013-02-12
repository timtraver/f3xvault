<?php /* Smarty version Smarty-3.1.11, created on 2012-09-03 23:43:21
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\plane_edit.tpl" */ ?>
<?php /*%%SmartyHeaderCode:13224502b5be40f49b1-65729537%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '2c8d1afe4845b0aa9bef05820085e8cabc38ab55' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\plane_edit.tpl',
      1 => 1346715661,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '13224502b5be40f49b1-65729537',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_502b5be419b806_33416944',
  'variables' => 
  array (
    'action' => 0,
    'plane' => 0,
    'plane_types' => 0,
    'plane_type' => 0,
    'countries' => 0,
    'country' => 0,
    'plane_attributes' => 0,
    'pa' => 0,
    'cat' => 0,
    'col' => 0,
    'media' => 0,
    'm' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_502b5be419b806_33416944')) {function content_502b5be419b806_33416944($_smarty_tpl) {?><?php if (!is_callable('smarty_function_cycle')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\function.cycle.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Plane Database</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Plane Information Edit</h1>
<script type="text/javascript">
function calc_wingspan(){
	var current_units = document.main.plane_wingspan_units.value;
	var current_value = document.main.plane_wingspan.value;
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
	var current_units = document.main.plane_length_units.value;
	var current_value = document.main.plane_length.value;
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
	var current_units = document.main.plane_auw_units.value;
	var current_value = document.main.plane_auw.value;
	var multiple = 28.35;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'oz' || current_units == ''){
		calc_value = multiple * current_value;
		calc_units = 'grams';
	}else{
		calc_value = current_value / multiple;
		calc_units = 'ounces';
	}
	document.getElementById('weight').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
}
function calc_area(){
	var current_units = document.main.plane_wing_area_units.value;
	var current_value = document.main.plane_wing_area.value;
	var multiple = 6.45;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'in2' || current_units == ''){
		calc_value = multiple * current_value;
		calc_units = 'Centimeters Squared';
	}else{
		calc_value = current_value / multiple;
		calc_units = 'Inches Squared';
	}
	document.getElementById('area').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
}
</script>
<form name="main" method="POST">
<input type="hidden" name="action" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
">
<input type="hidden" name="function" value="plane_save">
<input type="hidden" name="plane_id" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_id'], ENT_QUOTES, 'UTF-8', true);?>
">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Plane Name</th>
	<td><input type="text" size="40" name="plane_name" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_name'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>Plane Classification</th>
	<td>
		<select name="plane_type_id">
		<?php  $_smarty_tpl->tpl_vars['plane_type'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['plane_type']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['plane_types']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['plane_type']->key => $_smarty_tpl->tpl_vars['plane_type']->value){
$_smarty_tpl->tpl_vars['plane_type']->_loop = true;
?>
			<option value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane_type']->value['plane_type_id'], ENT_QUOTES, 'UTF-8', true);?>
" <?php if ($_smarty_tpl->tpl_vars['plane_type']->value['plane_type_id']==$_smarty_tpl->tpl_vars['plane']->value['plane_type_id']){?>SELECTED<?php }?>><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane_type']->value['plane_type_short_name'], ENT_QUOTES, 'UTF-8', true);?>
 - <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane_type']->value['plane_type_description'], ENT_QUOTES, 'UTF-8', true);?>
</option>
		<?php } ?>
		</select>
	</td>
</tr>
<tr>
	<th>Plane Wingspan</th>
	<td>
		<input type="text" size="10" name="plane_wingspan" value="<?php echo sprintf('%.1f',$_smarty_tpl->tpl_vars['plane']->value['plane_wingspan']);?>
" onChange="calc_wingspan();">
		<select name="plane_wingspan_units" onChange="calc_wingspan();">
		<option value="in" <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_wingspan_units']=="in"){?>SELECTED<?php }?>>Inches</option>
		<option value="cm" <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_wingspan_units']=="cm"){?>SELECTED<?php }?>>Centimeters</option>
		</select>
		<span id="wingspan"></span>
	</td>
</tr>
<tr>
	<th>Plane Length</th>
	<td>
		<input type="text" size="10" name="plane_length" value="<?php echo sprintf('%.1f',$_smarty_tpl->tpl_vars['plane']->value['plane_length']);?>
" onChange="calc_length();">
		<select name="plane_length_units" onChange="calc_length();">
		<option value="in" <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_length_units']=="in"){?>SELECTED<?php }?>>Inches</option>
		<option value="cm" <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_length_units']=="cm"){?>SELECTED<?php }?>>Centimeters</option>
		</select>
		<span id="length"></span>		
	</td>
</tr>
<tr>
	<th>Plane AUW</th>
	<td>
		<input type="text" size="10" name="plane_auw" value="<?php echo sprintf('%.1f',$_smarty_tpl->tpl_vars['plane']->value['plane_auw']);?>
" onChange="calc_weight();">
		<select name="plane_auw_units" onChange="calc_weight();">
		<option value="oz" <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_auw_units']=="oz"){?>SELECTED<?php }?>>Ounces</option>
		<option value="gr" <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_auw_units']=="gr"){?>SELECTED<?php }?>>Grams</option>
		</select>
		<span id="weight"></span>		
	</td>
</tr>
<tr>
	<th>Plane Wing Area</th>
	<td>
		<input type="text" size="10" name="plane_wing_area" value="<?php echo sprintf('%.1f',$_smarty_tpl->tpl_vars['plane']->value['plane_wing_area']);?>
" onChange="calc_area();">
		<select name="plane_wing_area_units" onChange="calc_area();">
		<option value="in2" <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_wing_area_units']=="in2"){?>SELECTED<?php }?>>Inches squared</option>
		<option value="cm2" <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_wing_area_units']=="cm2"){?>SELECTED<?php }?>>Centimeters squared</option>
		</select>
		<span id="area"></span>		
	</td>
</tr>
<tr>
	<th>Plane Manufacturer</th>
	<td><input type="text" size="40" name="plane_manufacturer" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_manufacturer'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>Manufactured In</th>
	<td>
		<select name="country_id">
		<?php  $_smarty_tpl->tpl_vars['country'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['country']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['countries']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['country']->key => $_smarty_tpl->tpl_vars['country']->value){
$_smarty_tpl->tpl_vars['country']->_loop = true;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['country']->value['country_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['country']->value['country_id']==$_smarty_tpl->tpl_vars['plane']->value['country_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['country']->value['country_name'];?>
</option>
		<?php } ?>
		</select>
	</td>
</tr>
<tr>
	<th>Manufacturer Year</th>
	<td><input type="text" size="10" name="plane_year" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_year'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>Manufacturer Web Site</th>
	<td><input type="text" size="60" name="plane_website" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_website'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th valign="top">Plane Attributes</th>
	<td>
		<table width="100%" cellspacing="0" cellspadding="1" style="border-style: none;">
		<?php $_smarty_tpl->tpl_vars['cat'] = new Smarty_variable('', null, 0);?>
		<?php  $_smarty_tpl->tpl_vars['pa'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['pa']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['plane_attributes']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['pa']->key => $_smarty_tpl->tpl_vars['pa']->value){
$_smarty_tpl->tpl_vars['pa']->_loop = true;
?>
			<?php if ($_smarty_tpl->tpl_vars['pa']->value['plane_att_cat_name']!=$_smarty_tpl->tpl_vars['cat']->value){?>
				<?php if ($_smarty_tpl->tpl_vars['pa']->value['plane_att_cat_name']!=''){?>
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><hr></td></tr>
				<?php }?>
				<tr style="border-style: none;"><td colspan="4" style="border-style: none;"><b><?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_cat_name'];?>
</b></td></tr>
				<tr style="border-style: none;">
				<?php $_smarty_tpl->tpl_vars['col'] = new Smarty_variable('1', null, 0);?>
			<?php }?>
			<?php if ($_smarty_tpl->tpl_vars['pa']->value['plane_att_type']=='boolean'){?>
				<td style="border-style: none;" nowrap>
					<input type="checkbox" name="plane_att_<?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['pa']->value['plane_att_value_status']==1&&$_smarty_tpl->tpl_vars['pa']->value['plane_att_value_value']==1){?>CHECKED<?php }?>> <?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_name'];?>

				</td>
			<?php }else{ ?>
				<td style="border-style: none;" nowrap>
					<?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_name'];?>
 <input type="text" name="plane_att_<?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_id'];?>
" size="<?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_size'];?>
" value="<?php if ($_smarty_tpl->tpl_vars['pa']->value['plane_att_value_status']==1){?><?php echo $_smarty_tpl->tpl_vars['pa']->value['plane_att_value_value'];?>
<?php }?>"> 
				</td>
			<?php }?>
			<?php if ($_smarty_tpl->tpl_vars['col']->value>3){?>
			</tr><tr style="border-style: none;">
			<?php $_smarty_tpl->tpl_vars['col'] = new Smarty_variable("0", null, 0);?>
			<?php }?>
			<?php $_smarty_tpl->tpl_vars['col'] = new Smarty_variable($_smarty_tpl->tpl_vars['col']->value+1, null, 0);?>
			<?php $_smarty_tpl->tpl_vars['cat'] = new Smarty_variable($_smarty_tpl->tpl_vars['pa']->value['plane_att_cat_name'], null, 0);?>
		<?php } ?>
		</tr>
		</table>
	</td>
</tr>



<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value="Cancel Edit" onClick="goback.submit();" class="block-button">
		<input type="submit" value="Save Plane Values" class="block-button">
	</th>
</tr>
</table>

</form>

<script type="text/javascript">
	calc_wingspan();
	calc_length();
	calc_weight();
	calc_area();
</script>

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
		<td><?php if ($_smarty_tpl->tpl_vars['m']->value['plane_media_type']=='picture'){?>Picture<?php }else{ ?>Video<?php }?></td>
		<?php if ($_smarty_tpl->tpl_vars['m']->value['plane_media_type']=='picture'){?>
			<td><a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_url'];?>
" rel="gallery" class="fancybox-button" title="<?php if ($_smarty_tpl->tpl_vars['m']->value['wp_user_id']!=0){?><?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_city'];?>
 - <?php }?><?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_caption'];?>
"><?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_url'];?>
</a></td>
		<?php }else{ ?>
			<td><a href="<?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_url'];?>
" rel="videos" class="fancybox-media" title="<?php if ($_smarty_tpl->tpl_vars['m']->value['wp_user_id']!=0){?><?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_first_name'];?>
, <?php echo $_smarty_tpl->tpl_vars['m']->value['pilot_city'];?>
 - <?php }?><?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_caption'];?>
"><?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_url'];?>
</a></td>
		<?php }?>
		<td> <a href="?action=plane&function=plane_media_del&plane_id=<?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_id'];?>
&plane_media_id=<?php echo $_smarty_tpl->tpl_vars['m']->value['plane_media_id'];?>
" title="Remove Media" onClick="confirm('Are you sure you wish to remove this media?')"><img src="images/del.gif"></a></td>
	</tr>
	<?php } ?>
<?php }else{ ?>
	<tr>
		<td colspan="4">There is currently no media entered.</td>
	</tr>
<?php }?>
</table>
<center>
<br>
<input type="button" name="media" value="Add New Plane Media" onClick="add_media.submit()" class="block-button" <?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_id']==0){?>disabled="disabled" style=""<?php }?>>
</center>
</div>

<form name="add_media" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_media_edit">
<input type="hidden" name="plane_id" value="<?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_id'];?>
">
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="plane">
</form>

</div>
</div>
</div>

<?php }} ?>