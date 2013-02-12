<?php /* Smarty version Smarty-3.1.11, created on 2012-11-02 05:52:20
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\event_edit.tpl" */ ?>
<?php /*%%SmartyHeaderCode:13754509358592223f0-41222946%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '8dcd6e50940577ff5eda1d61dfa9b0bc15b7fa28' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\event_edit.tpl',
      1 => 1351835504,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '13754509358592223f0-41222946',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_5093585952ae56_79084591',
  'variables' => 
  array (
    'action' => 0,
    'event' => 0,
    'countries' => 0,
    'country' => 0,
    'country_id' => 0,
    'states' => 0,
    'state' => 0,
    'state_id' => 0,
    'locations' => 0,
    'l' => 0,
    'event_types' => 0,
    't' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5093585952ae56_79084591')) {function content_5093585952ae56_79084591($_smarty_tpl) {?><?php if (!is_callable('smarty_function_html_select_date')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\function.html_select_date.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Event Edit</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Edit Event</h1>
<form name="getlocations" method="POST">
<input type="hidden" name="action" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="<?php echo $_smarty_tpl->tpl_vars['event']->value['event_id'];?>
">

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Event Country</th>
	<td>
	<select name="country_id" onChange="document.getlocations.state_id.value=0;getlocations.submit();">
	<option value="0">Choose Country to Narrow Search</option>
	<?php  $_smarty_tpl->tpl_vars['country'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['country']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['countries']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['country']->key => $_smarty_tpl->tpl_vars['country']->value){
$_smarty_tpl->tpl_vars['country']->_loop = true;
?>
		<option value="<?php echo $_smarty_tpl->tpl_vars['country']->value['country_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['country_id']->value==$_smarty_tpl->tpl_vars['country']->value['country_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['country']->value['country_name'];?>
</option>
	<?php } ?>
	</select>
	</td>
</tr>
<tr>
	<th>Event State</th>
	<td>
	<select name="state_id" onChange="getlocations.submit();">
	<option value="0">Choose State to Narrow Search</option>
	<?php  $_smarty_tpl->tpl_vars['state'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['state']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['states']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['state']->key => $_smarty_tpl->tpl_vars['state']->value){
$_smarty_tpl->tpl_vars['state']->_loop = true;
?>
		<option value="<?php echo $_smarty_tpl->tpl_vars['state']->value['state_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['state_id']->value==$_smarty_tpl->tpl_vars['state']->value['state_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['state']->value['state_name'];?>
</option>
	<?php } ?>
	</select>
	</td>
</tr>
</form>
<form name="main" method="POST">
<input type="hidden" name="action" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
">
<input type="hidden" name="function" value="event_save">
<input type="hidden" name="event_id" value="<?php echo $_smarty_tpl->tpl_vars['event']->value['event_id'];?>
">
<tr>
	<th>Event Location</th>
	<td>
	<select name="location_id">
	<?php  $_smarty_tpl->tpl_vars['l'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['l']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['locations']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['l']->key => $_smarty_tpl->tpl_vars['l']->value){
$_smarty_tpl->tpl_vars['l']->_loop = true;
?>
		<option value="<?php echo $_smarty_tpl->tpl_vars['l']->value['location_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['event']->value['location_id']==$_smarty_tpl->tpl_vars['l']->value['location_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['l']->value['location_name'];?>
</option>
	<?php } ?>
	</select>
	</td>
</tr>
<tr>
	<th>Event Name</th>
	<td>
		<input type="text" size="60" name="event_name" value="<?php echo $_smarty_tpl->tpl_vars['event']->value['event_name'];?>
">
	</td>
</tr>
<tr>
	<th>Event Dates</th>
	<td>
	<?php echo smarty_function_html_select_date(array('prefix'=>"event_start_date",'start_year'=>"-1",'end_year'=>"+1",'day_format'=>"%02d",'time'=>$_smarty_tpl->tpl_vars['event']->value['event_start_date']),$_smarty_tpl);?>
 to 
	<?php echo smarty_function_html_select_date(array('prefix'=>"event_end_date",'start_year'=>"-1",'end_year'=>"+1",'day_format'=>"%02d",'time'=>$_smarty_tpl->tpl_vars['event']->value['event_end_date']),$_smarty_tpl);?>

	</td>
</tr>
<tr>
	<th>Event Type</th>
	<td>
	<select name="event_type_id">
	<?php  $_smarty_tpl->tpl_vars['t'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['t']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['event_types']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['t']->key => $_smarty_tpl->tpl_vars['t']->value){
$_smarty_tpl->tpl_vars['t']->_loop = true;
?>
		<option value="<?php echo $_smarty_tpl->tpl_vars['t']->value['event_type_id'];?>
" <?php if ($_smarty_tpl->tpl_vars['event']->value['event_type_id']==$_smarty_tpl->tpl_vars['t']->value['event_type_id']){?>SELECTED<?php }?>><?php echo $_smarty_tpl->tpl_vars['t']->value['event_type_name'];?>
</option>
	<?php } ?>
	</select>
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value=" Cancel Changes " onClick="goback.submit();" class="block-button">
		<input type="submit" value=" Save Changes To This Event " class="block-button">
	</th>
</tr>
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>

</div>
</div>
</div>

<?php }} ?>