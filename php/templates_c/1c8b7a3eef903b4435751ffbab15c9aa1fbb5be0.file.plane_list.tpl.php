<?php /* Smarty version Smarty-3.1.11, created on 2012-09-10 02:29:46
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\plane_list.tpl" */ ?>
<?php /*%%SmartyHeaderCode:27053502b497ec830d4-44910715%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '1c8b7a3eef903b4435751ffbab15c9aa1fbb5be0' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\plane_list.tpl',
      1 => 1347244169,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '27053502b497ec830d4-44910715',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_502b497ee51d11_03600174',
  'variables' => 
  array (
    'plane_type' => 0,
    'plane_type_id' => 0,
    'plane_types' => 0,
    'search_field' => 0,
    'search_operator' => 0,
    'search' => 0,
    'startrecord' => 0,
    'endrecord' => 0,
    'totalrecords' => 0,
    'prevpage' => 0,
    'nextpage' => 0,
    'totalpages' => 0,
    'planes' => 0,
    'action' => 0,
    'plane' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_502b497ee51d11_03600174')) {function content_502b497ee51d11_03600174($_smarty_tpl) {?><?php if (!is_callable('smarty_function_cycle')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\function.cycle.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Plane Database</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Browse Database</h1>
<table>
<tr>
	<th>
		<form method="POST" name="filter">
		<input type="hidden" name="action" value="plane">
		<input type="hidden" name="function" value="plane_list">
		Filter on Plane Type : 
	</th>
	<td>
		<select name="plane_type_id" onChange="filter.submit();">
		<option value="0" <?php if ($_smarty_tpl->tpl_vars['plane_type']->value['plane_type_id']==$_smarty_tpl->tpl_vars['plane_type_id']->value){?>SELECTED<?php }?>>All Planes</option>
		<?php  $_smarty_tpl->tpl_vars['plane_type'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['plane_type']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['plane_types']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['plane_type']->key => $_smarty_tpl->tpl_vars['plane_type']->value){
$_smarty_tpl->tpl_vars['plane_type']->_loop = true;
?>
			<option value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane_type']->value['plane_type_id'], ENT_QUOTES, 'UTF-8', true);?>
" <?php if ($_smarty_tpl->tpl_vars['plane_type']->value['plane_type_id']==$_smarty_tpl->tpl_vars['plane_type_id']->value){?>SELECTED<?php }?>><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane_type']->value['plane_type_short_name'], ENT_QUOTES, 'UTF-8', true);?>
 - <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane_type']->value['plane_type_description'], ENT_QUOTES, 'UTF-8', true);?>
</option>
		<?php } ?>
		</select>
	</td>
</tr>
<tr>
	<th nowrap>	
		And Search on Field : 
	</th>
	<td valign="center">
		<select name="search_field">
		<option value="plane_name" <?php if ($_smarty_tpl->tpl_vars['search_field']->value=="plane_name"){?>SELECTED<?php }?>>Plane Name</option>
		<option value="plane_manufacturer" <?php if ($_smarty_tpl->tpl_vars['search_field']->value=="plane_manufacturer"){?>SELECTED<?php }?>>Manufacturer</option>
		<option value="plane_year" <?php if ($_smarty_tpl->tpl_vars['search_field']->value=="plane_year"){?>SELECTED<?php }?>>Plane Year</option>
		<option value="plane_wing_type" <?php if ($_smarty_tpl->tpl_vars['search_field']->value=="plane_wing_type"){?>SELECTED<?php }?>>Plane Wing Type</option>
		<option value="plane_tail_type" <?php if ($_smarty_tpl->tpl_vars['search_field']->value=="plane_tail_type"){?>SELECTED<?php }?>>Plane Tail Type</option>
		</select>
		<select name="search_operator">
		<option value="contains" <?php if ($_smarty_tpl->tpl_vars['search_operator']->value=="contains"){?>SELECTED<?php }?>>Contains</option>
		<option value="greater" <?php if ($_smarty_tpl->tpl_vars['search_operator']->value=="greater"){?>SELECTED<?php }?>>Greater Than</option>
		<option value="less" <?php if ($_smarty_tpl->tpl_vars['search_operator']->value=="less"){?>SELECTED<?php }?>>Less Than</option>
		<option value="exactly" <?php if ($_smarty_tpl->tpl_vars['search_operator']->value=="exactly"){?>SELECTED<?php }?>>Is Exactly</option>
		</select>
		<input type="text" name="search" size="20" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['search']->value, ENT_QUOTES, 'UTF-8', true);?>
">
		<input type="submit" value=" Search " class="block-button">
		<input type="submit" value=" Reset " class="block-button" onClick="document.filter.plane_type_id.value=0;document.filter.search_field.value='plane_name';document.filter.search_operator.value='contains';document.filter.search.value='';filter.submit();">
		</form>
	</td>
</tr>
</table>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="8" style="text-align: left;">Planes (records <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['startrecord']->value, ENT_QUOTES, 'UTF-8', true);?>
 - <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['endrecord']->value, ENT_QUOTES, 'UTF-8', true);?>
 of <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['totalrecords']->value, ENT_QUOTES, 'UTF-8', true);?>
)</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="4">
                <?php if ($_smarty_tpl->tpl_vars['startrecord']->value>1){?>[<a href="?action=plane&function=plane_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['prevpage']->value, ENT_QUOTES, 'UTF-8', true);?>
"> &lt;&lt; Prev Page</a>]<?php }?>
                <?php if ($_smarty_tpl->tpl_vars['endrecord']->value<$_smarty_tpl->tpl_vars['totalrecords']->value){?>[<a href="?action=plane&function=plane_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['nextpage']->value, ENT_QUOTES, 'UTF-8', true);?>
">Next Page &gt;&gt</a>]<?php }?>
        </td>
        <td align="right" colspan="4">PerPage
                [<a href="?action=plane&function=plane_list&&perpage=25">25</a>]
                [<a href="?action=plane&function=plane_list&&perpage=50">50</a>]
                [<a href="?action=plane&function=plane_list&&perpage=100">100</a>]
                [<a href="?action=plane&function=plane_list&page=1">First Page</a>]
                [<a href="?action=plane&function=plane_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['totalpages']->value, ENT_QUOTES, 'UTF-8', true);?>
">Last Page</a>]
        </td>
</tr>
<tr>
	<th style="text-align: left;">Plane Name</th>
	<th style="text-align: left;">Plane Type</th>
	<th style="text-align: left;">Info</th>
	<th style="text-align: left;">Manufacturer</th>
	<th style="text-align: left;">Year</th>
	<th style="text-align: left;">Wing Span</th>
	<th style="text-align: left;">Plane Weight</th>
	<th style="text-align: left;">Action</th>
</tr>
<?php  $_smarty_tpl->tpl_vars['plane'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['plane']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['planes']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['plane']->key => $_smarty_tpl->tpl_vars['plane']->value){
$_smarty_tpl->tpl_vars['plane']->_loop = true;
?>
<tr bgcolor="<?php echo smarty_function_cycle(array('values'=>"#FFFFFF,#E8E8E8"),$_smarty_tpl);?>
">
	<td>
		<a href="?action=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
&function=plane_view&plane_id=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_id'], ENT_QUOTES, 'UTF-8', true);?>
"><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_name'], ENT_QUOTES, 'UTF-8', true);?>
</a>
	</td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_type_short_name'], ENT_QUOTES, 'UTF-8', true);?>
</td>
	<td><?php if ($_smarty_tpl->tpl_vars['plane']->value['plane_info']=='good'){?><img src="/icons/accept.png" title="We Have Good Info On This Model"><?php }else{ ?><img src="/icons/exclamation.png" title="We Need More Info About This Model"><?php }?></td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_manufacturer'], ENT_QUOTES, 'UTF-8', true);?>
</td>
	<td><?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_year'];?>
</td>
	<td><?php echo sprintf('%.1f',$_smarty_tpl->tpl_vars['plane']->value['plane_wingspan']);?>
 <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_wingspan_units'];?>
</td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_auw'], ENT_QUOTES, 'UTF-8', true);?>
 <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_auw_units'];?>
</td>
	<td><a href="?action=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
&function=plane_edit&plane_id=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['plane']->value['plane_id'], ENT_QUOTES, 'UTF-8', true);?>
" title="Edit This Plane"><img src="images/icon_edit_small.gif" width="20"></a>
	</td>
</tr>
<?php } ?>
<tr style="background-color: lightgray;">
        <td align="left" colspan="4">
                <?php if ($_smarty_tpl->tpl_vars['startrecord']->value>1){?>[<a href="?action=plane&function=plane_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['prevpage']->value, ENT_QUOTES, 'UTF-8', true);?>
"> &lt;&lt; Prev Page</a>]<?php }?>
                <?php if ($_smarty_tpl->tpl_vars['endrecord']->value<$_smarty_tpl->tpl_vars['totalrecords']->value){?>[<a href="?action=plane&function=plane_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['nextpage']->value, ENT_QUOTES, 'UTF-8', true);?>
">Next Page &gt;&gt</a>]<?php }?>
        </td>
        <td align="right" colspan="4">PerPage
                [<a href="?action=plane&function=plane_list&perpage=25">25</a>]
                [<a href="?action=plane&function=plane_list&perpage=50">50</a>]
                [<a href="?action=plane&function=plane_list&perpage=100">100</a>]
                [<a href="?action=plane&function=plane_list&page=1">First Page</a>]
                [<a href="?action=plane&function=plane_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['totalpages']->value, ENT_QUOTES, 'UTF-8', true);?>
">Last Page</a>]
        </td>
</tr>
<tr>
	<td colspan="8" align="center">
		<input type="button" value=" Create New Plane Entry " onclick="newplane.submit();" class="block-button">
	</td>
</tr>
</table>

<form name="newplane" method="POST">
<input type="hidden" name="action" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
">
<input type="hidden" name="function" value="plane_edit">
<input type="hidden" name="plane_id" value="0">
</form>


</div>
</div>
</div>

<?php }} ?>