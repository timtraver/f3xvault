<?php /* Smarty version Smarty-3.1.11, created on 2012-09-04 02:13:54
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\location_list.tpl" */ ?>
<?php /*%%SmartyHeaderCode:3105150417e169add01-26435960%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'ad7f1b63942fa16edc127340a89d70362e684737' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\location_list.tpl',
      1 => 1346724827,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '3105150417e169add01-26435960',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_50417e16abf000_63236305',
  'variables' => 
  array (
    'countries' => 0,
    'country' => 0,
    'country_id' => 0,
    'states' => 0,
    'state' => 0,
    'state_id' => 0,
    'search_field' => 0,
    'search_operator' => 0,
    'search' => 0,
    'startrecord' => 0,
    'endrecord' => 0,
    'totalrecords' => 0,
    'prevpage' => 0,
    'nextpage' => 0,
    'totalpages' => 0,
    'locations' => 0,
    'location' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_50417e16abf000_63236305')) {function content_50417e16abf000_63236305($_smarty_tpl) {?><?php if (!is_callable('smarty_function_cycle')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\function.cycle.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Location Database</h1>
		<div class="entry-content clearfix">

<form name="searchform" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_list">

<h1 class="post-title entry-title">Browse Locations</h1>
<table>
<tr>
	<th>Filter By Country</th>
	<td>
	<select name="country_id" onChange="document.searchform.state_id.value=0;searchform.submit();">
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
	<th>Filter By State</th>
	<td>
	<select name="state_id" onChange="searchform.submit();">
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
<tr>
	<th nowrap>	
		And Search on Field : 
	</th>
	<td valign="center">
		<select name="search_field">
		<option value="location_name" <?php if ($_smarty_tpl->tpl_vars['search_field']->value=="location_name"){?>SELECTED<?php }?>>Location Name</option>
		<option value="location_city" <?php if ($_smarty_tpl->tpl_vars['search_field']->value=="location_city"){?>SELECTED<?php }?>>City</option>
		</select>
		<select name="search_operator">
		<option value="contains" <?php if ($_smarty_tpl->tpl_vars['search_operator']->value=="contains"){?>SELECTED<?php }?>>Contains</option>
		<option value="exactly" <?php if ($_smarty_tpl->tpl_vars['search_operator']->value=="exactly"){?>SELECTED<?php }?>>Is Exactly</option>
		</select>
		<input type="text" name="search" size="30" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['search']->value, ENT_QUOTES, 'UTF-8', true);?>
">
		<input type="submit" value=" Search " class="block-button">
		<input type="submit" value=" Reset " class="block-button" onClick="document.searchform.country_id.value=0;document.searchform.state_id.value=0;document.searchform.search_field.value='location_name';document.searchform.search_operator.value='contains';document.searchform.search.value='';searchform.submit();">
		</form>
	</td>
</tr>
</table>
</form>
<br>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="6" style="text-align: left;">Locations (records <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['startrecord']->value, ENT_QUOTES, 'UTF-8', true);?>
 - <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['endrecord']->value, ENT_QUOTES, 'UTF-8', true);?>
 of <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['totalrecords']->value, ENT_QUOTES, 'UTF-8', true);?>
)</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                <?php if ($_smarty_tpl->tpl_vars['startrecord']->value>1){?>[<a href="?action=location&function=location_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['prevpage']->value, ENT_QUOTES, 'UTF-8', true);?>
"> &lt;&lt; Prev Page</a>]<?php }?>
                <?php if ($_smarty_tpl->tpl_vars['endrecord']->value<$_smarty_tpl->tpl_vars['totalrecords']->value){?>[<a href="?action=location&function=location_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['nextpage']->value, ENT_QUOTES, 'UTF-8', true);?>
">Next Page &gt;&gt</a>]<?php }?>
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=location&function=location_list&&perpage=25">25</a>]
                [<a href="?action=location&function=location_list&&perpage=50">50</a>]
                [<a href="?action=location&function=location_list&&perpage=100">100</a>]
                [<a href="?action=location&function=location_list&page=1">First Page</a>]
                [<a href="?action=location&function=location_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['totalpages']->value, ENT_QUOTES, 'UTF-8', true);?>
">Last Page</a>]
        </td>
</tr>
<tr>
	<th style="text-align: left;">Location Name</th>
	<th style="text-align: left;">City</th>
	<th style="text-align: left;">State</th>
	<th style="text-align: left;">Country</th>
	<th style="text-align: center;">Map Location</th>
	<th style="text-align: left;">Action</th>
</tr>
<?php  $_smarty_tpl->tpl_vars['location'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['location']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['locations']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['location']->key => $_smarty_tpl->tpl_vars['location']->value){
$_smarty_tpl->tpl_vars['location']->_loop = true;
?>
<tr bgcolor="<?php echo smarty_function_cycle(array('values'=>"#FFFFFF,#E8E8E8"),$_smarty_tpl);?>
">
	<td>
		<a href="?action=location&function=location_view&location_id=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_id'], ENT_QUOTES, 'UTF-8', true);?>
"><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_name'], ENT_QUOTES, 'UTF-8', true);?>
</a>
	</td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_city'], ENT_QUOTES, 'UTF-8', true);?>
</td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['state_name'], ENT_QUOTES, 'UTF-8', true);?>
</td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['country_name'], ENT_QUOTES, 'UTF-8', true);?>
</td>
	<td align="center"><?php if ($_smarty_tpl->tpl_vars['location']->value['location_coordinates']!=''){?><a class="fancybox-map" href="https://maps.google.com/maps?q=<?php echo rawurlencode($_smarty_tpl->tpl_vars['location']->value['location_coordinates']);?>
+(<?php echo $_smarty_tpl->tpl_vars['location']->value['location_name'];?>
)&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/icons/world.png"></a><?php }?></td>
	<td><a href="?action=location&function=location_edit&location_id=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_id'], ENT_QUOTES, 'UTF-8', true);?>
" title="Edit This Location"><img src="images/icon_edit_small.gif" width="20"></a>
	</td>
</tr>
<?php } ?>
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                <?php if ($_smarty_tpl->tpl_vars['startrecord']->value>1){?>[<a href="?action=location&function=location_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['prevpage']->value, ENT_QUOTES, 'UTF-8', true);?>
"> &lt;&lt; Prev Page</a>]<?php }?>
                <?php if ($_smarty_tpl->tpl_vars['endrecord']->value<$_smarty_tpl->tpl_vars['totalrecords']->value){?>[<a href="?action=location&function=location_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['nextpage']->value, ENT_QUOTES, 'UTF-8', true);?>
">Next Page &gt;&gt</a>]<?php }?>
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=location&function=location_list&perpage=25">25</a>]
                [<a href="?action=location&function=location_list&perpage=50">50</a>]
                [<a href="?action=location&function=location_list&perpage=100">100</a>]
                [<a href="?action=location&function=location_list&page=1">First Page</a>]
                [<a href="?action=location&function=location_list&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['totalpages']->value, ENT_QUOTES, 'UTF-8', true);?>
">Last Page</a>]
        </td>
</tr>
<tr>
	<td colspan="6" align="center">
		<input type="button" value=" Create New Location Entry " onclick="newlocation.submit();" class="block-button">
	</td>
</tr>
</table>

<form name="newlocation" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="0">
</form>


</div>
</div>
</div>

<?php }} ?>