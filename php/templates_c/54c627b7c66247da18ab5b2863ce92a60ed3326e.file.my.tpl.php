<?php /* Smarty version Smarty-3.1.11, created on 2012-09-03 22:31:51
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\my.tpl" */ ?>
<?php /*%%SmartyHeaderCode:214505028aca924cfa8-52922995%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '54c627b7c66247da18ab5b2863ce92a60ed3326e' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\my.tpl',
      1 => 1346711501,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '214505028aca924cfa8-52922995',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_5028aca9315835_44704006',
  'variables' => 
  array (
    'action' => 0,
    'is_pilotlist' => 0,
    'pilotlist' => 0,
    'p' => 0,
    'pilot' => 0,
    'states' => 0,
    'state' => 0,
    'countries' => 0,
    'country' => 0,
    'pilot_planes' => 0,
    'pp' => 0,
    'pilot_locations' => 0,
    'pl' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5028aca9315835_44704006')) {function content_5028aca9315835_44704006($_smarty_tpl) {?><?php if (!is_callable('smarty_function_cycle')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\function.cycle.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">My Pilot Profile</h1>
		<div class="entry-content clearfix">

<form name="main" method="POST">
<input type="hidden" name="action" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
">
<input type="hidden" name="function" value="my_user_save">

<?php if ($_smarty_tpl->tpl_vars['is_pilotlist']->value){?>
	<input type="hidden" name="connect" value="1">
	<p>It appears this is the first time you are logging in to edit your Pilot Profile, and we may already have a pilot in the database with your name that has attended an entered event.</p>
	<p>Are any of these pilots you?</p>

	<table width="100%" cellpadding="2" cellspacing="2" class="tableborder">
	<tr class="table-row-heading-left">
		<th colspan="4" style="text-align: left;">Possible Pilots</td>
	</tr>
	<tr>
		<th nowrap>&nbsp;</th>
		<th nowrap style="text-align: left;">Pilot Last Name</th>
		<th nowrap style="text-align: left;">Pilot First Name</th>
	<th nowrap style="text-align: left;">Last Event</th>
	<tr>
	<?php  $_smarty_tpl->tpl_vars['p'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['p']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['pilotlist']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['p']->key => $_smarty_tpl->tpl_vars['p']->value){
$_smarty_tpl->tpl_vars['p']->_loop = true;
?>
	<tr>
		<th nowrap>
			<input type="radio" name="pilot_id" value="<?php echo $_smarty_tpl->tpl_vars['p']->value['pilot_id'];?>
">
		</th>
		<td><?php echo $_smarty_tpl->tpl_vars['p']->value['pilot_last_name'];?>
</td>
		<td><?php echo $_smarty_tpl->tpl_vars['p']->value['pilot_first_name'];?>
</td>
		<td><?php echo $_smarty_tpl->tpl_vars['p']->value['eventstring'];?>
</td>
	</tr>
	<?php } ?>
	<tr>
		<th nowrap>
			<input type="radio" name="pilot_id" value="0" CHECKED>
		</th>
		<td colspan="3">I'm sorry, but none of these pilots are me. Please start with my default information.</td>
	</tr>
	<tr>
		<th colspan="4" style="text-align: center;">
		<input type="submit" value="Connect the Selected Pilot with My Account" class="block-button">
		</th>
	</tr>
	</table>
<?php }else{ ?>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Pilot First Name</th>
	<td><input type="text" size="30" name="pilot_first_name" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['pilot']->value['pilot_first_name'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>Pilot Last Name</th>
	<td><input type="text" size="30" name="pilot_last_name" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['pilot']->value['pilot_last_name'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>Pilot Email</th>
	<td><input type="text" size="30" name="pilot_email" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['pilot']->value['pilot_email'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>Pilot City</th>
	<td><input type="text" size="30" name="pilot_city" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['pilot']->value['pilot_city'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>Pilot State</th>
	<td>
		<select name="state_id">
		<?php  $_smarty_tpl->tpl_vars['state'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['state']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['states']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['state']->key => $_smarty_tpl->tpl_vars['state']->value){
$_smarty_tpl->tpl_vars['state']->_loop = true;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['state']->value['state_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['state']->value['state_id']==$_smarty_tpl->tpl_vars['pilot']->value['state_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['state']->value['state_name'];?>
</option>
		<?php } ?>
		</select>
	</td>
</tr>
<tr>
	<th>Pilot Country</th>
	<td>
		<select name="country_id">
		<?php  $_smarty_tpl->tpl_vars['country'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['country']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['countries']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['country']->key => $_smarty_tpl->tpl_vars['country']->value){
$_smarty_tpl->tpl_vars['country']->_loop = true;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['country']->value['country_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['country']->value['country_id']==$_smarty_tpl->tpl_vars['pilot']->value['country_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['country']->value['country_name'];?>
</option>
		<?php } ?>
		</select>
	</td>
</tr>
<tr>
	<th>Pilot AMA Number</th>
	<td><input type="text" size="10" name="pilot_ama" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['pilot']->value['pilot_ama'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
<tr>
	<th>Pilot FIA Number</th>
	<td><input type="text" size="10" name="pilot_fia" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['pilot']->value['pilot_fia'], ENT_QUOTES, 'UTF-8', true);?>
"></td>
</tr>
</table>
<center>
<br>
<input type="submit" value=" Save My User Values " class="block-button">
</center>
<?php if ($_smarty_tpl->tpl_vars['pilot']->value['pilot_id']!=0){?>
<h1 class="post-title entry-title">My Aircraft</h1>
	<table width="100%" cellpadding="2" cellspacing="1">
	<tr>
		<th style="text-align: left;">Plane</th>
		<th style="text-align: left;">Plane Type</th>
		<th style="text-align: left;">Plane Manufacturer</th>
		<th style="text-align: left;">Color Scheme</th>
		<th style="text-align: left;">&nbsp;</th>
	</tr>
	<?php if ($_smarty_tpl->tpl_vars['pilot_planes']->value){?>
		<?php  $_smarty_tpl->tpl_vars['pp'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['pp']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['pilot_planes']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['pp']->key => $_smarty_tpl->tpl_vars['pp']->value){
$_smarty_tpl->tpl_vars['pp']->_loop = true;
?>
			<tr bgcolor="<?php echo smarty_function_cycle(array('values'=>"white,lightgray"),$_smarty_tpl);?>
">
			<td><a href="?action=my&function=my_plane_edit&pilot_plane_id=<?php echo $_smarty_tpl->tpl_vars['pp']->value['pilot_plane_id'];?>
" title="Edit My Aircraft"><?php echo $_smarty_tpl->tpl_vars['pp']->value['plane_name'];?>
</a></td>
			<td><?php echo $_smarty_tpl->tpl_vars['pp']->value['plane_type_short_name'];?>
</td>
			<td><?php echo $_smarty_tpl->tpl_vars['pp']->value['plane_manufacturer'];?>
</td>
			<td><?php echo $_smarty_tpl->tpl_vars['pp']->value['pilot_plane_color'];?>
</td>
			<td> <a href="?action=my&function=my_plane_del&pilot_plane_id=<?php echo $_smarty_tpl->tpl_vars['pp']->value['pilot_plane_id'];?>
" title="Remove Plane" onClick="confirm('Are you sure you wish to remove this plane?')"><img src="images/del.gif"></a></td>
		</tr>
		<?php } ?>
	<?php }else{ ?>
		<tr>
			<td colspan="5">You currently have no planes in your quiver.</td>
		</tr>
	<?php }?>
	</table>
	<center>
	<br>
	<input type="button" value="Add A New Plane to my Quiver" onClick="add_plane.submit()" class="block-button">
	</center>
</form>
<h1 class="post-title entry-title">My RC Flying Locations</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;">Location Name</th>
	<th style="text-align: left;">Location City</th>
	<th style="text-align: left;">State/Country</th>
	<th style="text-align: left;">&nbsp;</th>
</tr>
<?php if ($_smarty_tpl->tpl_vars['pilot_locations']->value){?>
	<?php  $_smarty_tpl->tpl_vars['pl'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['pl']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['pilot_locations']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['pl']->key => $_smarty_tpl->tpl_vars['pl']->value){
$_smarty_tpl->tpl_vars['pl']->_loop = true;
?>
	<tr bgcolor="<?php echo smarty_function_cycle(array('values'=>"white,lightgray"),$_smarty_tpl);?>
">
		<td><a href="?action=location&function=location_view&location_id=<?php echo $_smarty_tpl->tpl_vars['pl']->value['location_id'];?>
" title="View This Location"><?php echo $_smarty_tpl->tpl_vars['pl']->value['location_name'];?>
</a></td>
		<td><?php echo $_smarty_tpl->tpl_vars['pl']->value['location_city'];?>
</td>
		<td><?php echo $_smarty_tpl->tpl_vars['pl']->value['state_name'];?>
 <?php echo $_smarty_tpl->tpl_vars['pl']->value['country_code'];?>
</td>
		<td> <a href="?action=my&function=my_location_del&pilot_location_id=<?php echo $_smarty_tpl->tpl_vars['pl']->value['pilot_location_id'];?>
" title="Remove Location" onClick="confirm('Are you sure you wish to remove this location?')"><img src="images/del.gif"></a></td>
	</tr>
	<?php } ?>
<?php }else{ ?>
	<tr>
		<td colspan="4">You currently have no selected locations.</td>
	</tr>
<?php }?>
</table>
<center>
<br>
<input type="button" value="Add A New Location Where I fly" onClick="add_location.submit()" class="block-button">
</center>
</form>

<form name="add_plane" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_plane_edit">
<input type="hidden" name="pilot_plane_id" value="0">
</form>
<form name="add_location" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_location_edit">
<input type="hidden" name="pilot_location_id" value="0">
</form>
<?php }?>
<?php }?>
</div>
</div>
</div>
<?php }} ?>