<?php /* Smarty version Smarty-3.1.11, created on 2012-09-04 02:20:04
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\my_location_edit.tpl" */ ?>
<?php /*%%SmartyHeaderCode:116725035d1b5c14044-67674475%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'd63edf53405c3cdfcd689a1523f91bec45fd72e4' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\my_location_edit.tpl',
      1 => 1346725199,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '116725035d1b5c14044-67674475',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_5035d1b5cc0fc8_28102579',
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
<?php if ($_valid && !is_callable('content_5035d1b5cc0fc8_28102579')) {function content_5035d1b5cc0fc8_28102579($_smarty_tpl) {?><?php if (!is_callable('smarty_function_cycle')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\function.cycle.php';
?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">My Pilot Profile</h1>
		<div class="entry-content clearfix">

<form name="searchform" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_location_edit">

<h1 class="post-title entry-title">Search For A Flying Location</h1>
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

<form name="addlocations" method="POST">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_location_add">

<h1 class="post-title entry-title">Results</h1>

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="6" style="text-align: left;">Locations (records <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['startrecord']->value, ENT_QUOTES, 'UTF-8', true);?>
 - <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['endrecord']->value, ENT_QUOTES, 'UTF-8', true);?>
 of <?php echo htmlspecialchars($_smarty_tpl->tpl_vars['totalrecords']->value, ENT_QUOTES, 'UTF-8', true);?>
)</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                <?php if ($_smarty_tpl->tpl_vars['startrecord']->value>1){?>[<a href="?action=my&function=my_location_edit&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['prevpage']->value, ENT_QUOTES, 'UTF-8', true);?>
"> &lt;&lt; Prev Page</a>]<?php }?>
                <?php if ($_smarty_tpl->tpl_vars['endrecord']->value<$_smarty_tpl->tpl_vars['totalrecords']->value){?>[<a href="?action=my&function=my_location_edit&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['nextpage']->value, ENT_QUOTES, 'UTF-8', true);?>
">Next Page &gt;&gt</a>]<?php }?>
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=my&function=my_location_edit&&perpage=25">25</a>]
                [<a href="?action=my&function=my_location_edit&&perpage=50">50</a>]
                [<a href="?action=my&function=my_location_edit&&perpage=100">100</a>]
                [<a href="?action=my&function=my_location_edit&page=1">First Page</a>]
                [<a href="?action=my&function=my_location_edit&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['totalpages']->value, ENT_QUOTES, 'UTF-8', true);?>
">Last Page</a>]
        </td>
</tr>
<tr>
	<th style="text-align: left;">Add</th>
	<th style="text-align: left;">Location Name</th>
	<th style="text-align: left;">City</th>
	<th style="text-align: left;">State</th>
	<th style="text-align: left;">Country</th>
	<th style="text-align: center;">Map Location</th>
</tr>
<?php  $_smarty_tpl->tpl_vars['location'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['location']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['locations']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['location']->key => $_smarty_tpl->tpl_vars['location']->value){
$_smarty_tpl->tpl_vars['location']->_loop = true;
?>
<tr bgcolor="<?php echo smarty_function_cycle(array('values'=>"#FFFFFF,#E8E8E8"),$_smarty_tpl);?>
">
	<td>
		<input type="checkbox" name="location_<?php echo $_smarty_tpl->tpl_vars['location']->value['location_id'];?>
">
	</td>
	<td><?php echo htmlspecialchars($_smarty_tpl->tpl_vars['location']->value['location_name'], ENT_QUOTES, 'UTF-8', true);?>
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
</tr>
<?php } ?>
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                <?php if ($_smarty_tpl->tpl_vars['startrecord']->value>1){?>[<a href="?action=my&function=my_location_edit&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['prevpage']->value, ENT_QUOTES, 'UTF-8', true);?>
"> &lt;&lt; Prev Page</a>]<?php }?>
                <?php if ($_smarty_tpl->tpl_vars['endrecord']->value<$_smarty_tpl->tpl_vars['totalrecords']->value){?>[<a href="?action=my&function=my_location_edit&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['nextpage']->value, ENT_QUOTES, 'UTF-8', true);?>
">Next Page &gt;&gt</a>]<?php }?>
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=my&function=my_location_edit&perpage=25">25</a>]
                [<a href="?action=my&function=my_location_edit&perpage=50">50</a>]
                [<a href="?action=my&function=my_location_edit&perpage=100">100</a>]
                [<a href="?action=my&function=my_location_edit&page=1">First Page</a>]
                [<a href="?action=my&function=my_location_edit&page=<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['totalpages']->value, ENT_QUOTES, 'UTF-8', true);?>
">Last Page</a>]
        </td>
</tr>
</table>
<br>
<center>
<input type="submit" value=" Add Selected Locations to My Experience " class="block-button">
<input type="button" value=" Back To My Pilot Profile " class="block-button" onclick="goback.submit();">
</center>
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="my">
</form>


</div>
</div>
</div>
<?php }} ?>