<?php /* Smarty version Smarty-3.1.11, created on 2012-08-15 00:39:27
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\menu.tpl" */ ?>
<?php /*%%SmartyHeaderCode:2144450276b2304f6b1-00541714%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'ed8c39da89dcefed680dc91d89fa4b09dd4b7179' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\menu.tpl',
      1 => 1345016364,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '2144450276b2304f6b1-00541714',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_50276b23099dc7_68248539',
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_50276b23099dc7_68248539')) {function content_50276b23099dc7_68248539($_smarty_tpl) {?><table cellpadding="1" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<td width="100" class="table-data-heading-left">
		<a href="?action=my">My Profile</a>
	</td>
	<td width="100" class="table-data-heading-left">
		<a href="?action=events" class="leftmenu">Events</a>
	</td>
	<td width="100" class="table-data-heading-left">
		<a href="?action=locations">Flying Locations</a>
	</td>
	<td width="100" class="table-data-heading-left">
		<a href="?action=plane&search=&plane_type_id=0">Plane Database</a>
	</td>
</tr>
</table>
<?php }} ?>