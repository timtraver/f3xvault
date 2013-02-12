<?php /* Smarty version Smarty-3.1.11, created on 2013-02-12 09:20:02
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\event_view.tpl" */ ?>
<?php /*%%SmartyHeaderCode:10172511a0003df71e3-28151182%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '0e2f9df94bc143e410b85384dcf7272f8d7f6de6' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\event_view.tpl',
      1 => 1360660794,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '10172511a0003df71e3-28151182',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_511a0003e5ab84_14186044',
  'variables' => 
  array (
    'event' => 0,
    'pilots' => 0,
    'total_pilots' => 0,
    'p' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_511a0003e5ab84_14186044')) {function content_511a0003e5ab84_14186044($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_date_format')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\modifier.date_format.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Settings - <?php echo $_smarty_tpl->tpl_vars['event']->value['event_name'];?>
 <input type="button" value=" Edit " onClick="edit_event.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Event Dates</th>
			<td>
			<?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['event']->value['event_start_date'],"%Y-%m-%d");?>
 to <?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['event']->value['event_end_date'],"%Y-%m-%d");?>

			</td>
		</tr>
		<tr>
			<th>Location</th>
			<td>
			<?php echo $_smarty_tpl->tpl_vars['event']->value['location_name'];?>
 - <?php echo $_smarty_tpl->tpl_vars['event']->value['location_city'];?>
,<?php echo $_smarty_tpl->tpl_vars['event']->value['state_code'];?>
 <?php echo $_smarty_tpl->tpl_vars['event']->value['country_code'];?>

			</td>
		</tr>
		<tr>
			<th>Event Type</th>
			<td>
			<?php echo $_smarty_tpl->tpl_vars['event']->value['event_type_name'];?>

			</td>
		</tr>
		</table>

		<form name="edit_event" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_edit">
		<input type="hidden" name="event_id" value="<?php echo $_smarty_tpl->tpl_vars['event']->value['event_id'];?>
">
		</form>

	</div>
		<br>
		<h1 class="post-title entry-title">Event Pilots <?php if ($_smarty_tpl->tpl_vars['pilots']->value){?>(<?php echo $_smarty_tpl->tpl_vars['total_pilots']->value;?>
)<?php }?></h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Pilot #</th>
			<th>Pilot Name</th>
			<th>Pilot Team</th>
		</tr>
		<?php  $_smarty_tpl->tpl_vars['p'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['p']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['pilots']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['p']->key => $_smarty_tpl->tpl_vars['p']->value){
$_smarty_tpl->tpl_vars['p']->_loop = true;
?>
		<tr>
			<td></td>
			<td><?php echo $_smarty_tpl->tpl_vars['p']->value['pilot_first_name'];?>
 <?php echo $_smarty_tpl->tpl_vars['p']->value['pilot_last_name'];?>
</td>
			<td></td>
		</tr>
		<?php } ?>
		</table>


</div>
</div>

<?php }} ?>