<?php /* Smarty version Smarty-3.1.11, created on 2012-11-02 06:37:26
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\event_settings.tpl" */ ?>
<?php /*%%SmartyHeaderCode:968509367ec8d5344-92448589%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '6bf53acf137d8559ef4ef1b60c3eef43edc2c412' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\event_settings.tpl',
      1 => 1351838240,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '968509367ec8d5344-92448589',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_509367ec926471_88288417',
  'variables' => 
  array (
    'event' => 0,
    'action' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_509367ec926471_88288417')) {function content_509367ec926471_88288417($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_date_format')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\modifier.date_format.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Event Settings - <?php echo $_smarty_tpl->tpl_vars['event']->value['event_name'];?>
</h1>
		<div class="entry-content clearfix">
<form name="main" method="POST">
<input type="hidden" name="action" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
">
<input type="hidden" name="function" value="event_save">
<input type="hidden" name="event_id" value="<?php echo $_smarty_tpl->tpl_vars['event']->value['event_id'];?>
">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Event Dates</th>
	<td>
	<?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['event']->value['event_start_date'],"%Y-%m-%d");?>
 to <?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['event']->value['event_end_date'],"%Y-%m-%d");?>

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
		<br>
		<h1 class="post-title entry-title">Event Pilots</h1>



</div>
</div>

<?php }} ?>