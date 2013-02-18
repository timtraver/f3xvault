<?php /* Smarty version Smarty-3.1.11, created on 2013-02-18 09:20:28
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\event_view.tpl" */ ?>
<?php /*%%SmartyHeaderCode:32280511ca384f1fcf3-21943121%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '0e2f9df94bc143e410b85384dcf7272f8d7f6de6' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\event_view.tpl',
      1 => 1361179221,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '32280511ca384f1fcf3-21943121',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_511ca3850d27c4_25618471',
  'variables' => 
  array (
    'event' => 0,
    'total_pilots' => 0,
    'num' => 0,
    'p' => 0,
    'r' => 0,
    'ep' => 0,
    'f' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_511ca3850d27c4_25618471')) {function content_511ca3850d27c4_25618471($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_date_format')) include 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\libraries\\smarty\\libs\\plugins\\modifier.date_format.php';
?><script src="/f3x/includes/jquery.min.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>

$(function() {
	$("#pilot_name").autocomplete({
		source: "/f3x/?action=lookup&function=lookup_pilot",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.add_pilot.pilot_id.value = ui.item.id;
			var name=document.getElementById('pilot_name');
			document.add_pilot.pilot_name.value=name.value;
			add_pilot.submit();
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
   			if(id.value==''){
				document.add_pilot.pilot_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "none";
   			var mes=document.getElementById('search_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
});
</script>


<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Settings - <?php echo $_smarty_tpl->tpl_vars['event']->value['event_name'];?>
 <input type="button" value=" Edit Event Parameters " onClick="document.edit_event.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			<?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['event']->value['event_start_date'],"%Y-%m-%d");?>
 to <?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['event']->value['event_end_date'],"%Y-%m-%d");?>

			</td>
		</tr>
		<tr>
			<th align="right">Location</th>
			<td>
			<?php echo $_smarty_tpl->tpl_vars['event']->value['location_name'];?>
 - <?php echo $_smarty_tpl->tpl_vars['event']->value['location_city'];?>
,<?php echo $_smarty_tpl->tpl_vars['event']->value['state_code'];?>
 <?php echo $_smarty_tpl->tpl_vars['event']->value['country_code'];?>

			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			<?php echo $_smarty_tpl->tpl_vars['event']->value['event_type_name'];?>

			</td>
		</tr>
		<tr>
			<th align="right">Event Contest Director</th>
			<td>
			<?php echo $_smarty_tpl->tpl_vars['event']->value['pilot_first_name'];?>
 <?php echo $_smarty_tpl->tpl_vars['event']->value['pilot_last_name'];?>
 - <?php echo $_smarty_tpl->tpl_vars['event']->value['pilot_city'];?>

			</td>
		</tr>
		</table>
		
	</div>
		<br>
		<h1 class="post-title entry-title">Event Pilots <?php if ($_smarty_tpl->tpl_vars['event']->value['pilots']){?>(<?php echo $_smarty_tpl->tpl_vars['total_pilots']->value;?>
)<?php }?></h1>
		<input type="button" value=" Add Pilot " onclick="var name=document.getElementById('pilot_name');document.add_pilot.pilot_name.value=name.value;add_pilot.submit();">
		<input type="text" id="pilot_name" name="pilot_name" size="40">
		    <img id="loading" src="/f3x/images/loading.gif" style="vertical-align: middle;display: none;">
		    <span id="search_message" style="font-style: italic;color: grey;"> Start typing to search pilots</span>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="center">AMA#</th>
			<th align="left">Pilot Name</th>
			<th align="left">Pilot Class</th>
			<th align="left">Pilot Plane</th>
			<th align="left">Pilot Freq</th>
			<th align="left">Event Team</th>
			<th align="left" width="4%"></th>
		</tr>
		<?php $_smarty_tpl->tpl_vars['num'] = new Smarty_variable(1, null, 0);?>
		<?php  $_smarty_tpl->tpl_vars['p'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['p']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['event']->value['pilots']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['p']->key => $_smarty_tpl->tpl_vars['p']->value){
$_smarty_tpl->tpl_vars['p']->_loop = true;
?>
		<tr>
			<td><?php echo $_smarty_tpl->tpl_vars['num']->value;?>
</td>
			<td align="center"><?php echo $_smarty_tpl->tpl_vars['p']->value['pilot_ama'];?>
</td>
			<td><?php echo $_smarty_tpl->tpl_vars['p']->value['pilot_first_name'];?>
 <?php echo $_smarty_tpl->tpl_vars['p']->value['pilot_last_name'];?>
</td>
			<td><?php echo $_smarty_tpl->tpl_vars['p']->value['class_description'];?>
</td>
			<td><?php echo $_smarty_tpl->tpl_vars['p']->value['plane_name'];?>
</td>
			<td><?php echo $_smarty_tpl->tpl_vars['p']->value['event_pilot_freq'];?>
</td>
			<td><?php echo $_smarty_tpl->tpl_vars['p']->value['event_pilot_team'];?>
</td>
			<td nowrap>
				<a href="/f3x/?action=event&function=event_pilot_edit&event_id=<?php echo $_smarty_tpl->tpl_vars['event']->value['event_id'];?>
&event_pilot_id=<?php echo $_smarty_tpl->tpl_vars['p']->value['event_pilot_id'];?>
" title="Edit Event Pilot"><img width="18" src="/f3x/images/icon_edit_small.gif"></a>
				<a href="/f3x/?action=event&function=event_pilot_remove&event_id=<?php echo $_smarty_tpl->tpl_vars['event']->value['event_id'];?>
&event_pilot_id=<?php echo $_smarty_tpl->tpl_vars['p']->value['event_pilot_id'];?>
" title="Remove Event Pilot" onClick="return confirm('Are you sure you want to remove <?php echo $_smarty_tpl->tpl_vars['p']->value['pilot_first_name'];?>
 from the event?');"><img src="/f3x/images/del.gif"></a>
			</td>
		</tr>
		<?php $_smarty_tpl->tpl_vars['num'] = new Smarty_variable($_smarty_tpl->tpl_vars['num']->value+1, null, 0);?>
		<?php } ?>
		</table>
		
		<br>
		<h1 class="post-title entry-title">Event Rounds <?php if ($_smarty_tpl->tpl_vars['event']->value['rounds']){?>(<?php echo count($_smarty_tpl->tpl_vars['event']->value['rounds']);?>
)<?php }?></h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap></th>
			<th colspan="<?php echo count($_smarty_tpl->tpl_vars['event']->value['rounds']);?>
" align="center" nowrap>Completed Rounds</th>
			<th></th>
			<th width="5%" nowrap>Total Score</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			<?php  $_smarty_tpl->tpl_vars['r'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['r']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['event']->value['rounds']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['r']->key => $_smarty_tpl->tpl_vars['r']->value){
$_smarty_tpl->tpl_vars['r']->_loop = true;
?>
				<th width="5%" align="left" nowrap>Round <?php echo $_smarty_tpl->tpl_vars['r']->value['event_round_number'];?>
</th>
			<?php } ?>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		<?php $_smarty_tpl->tpl_vars['num'] = new Smarty_variable(1, null, 0);?>
		<?php  $_smarty_tpl->tpl_vars['ep'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['ep']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['event']->value['pilots']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['ep']->key => $_smarty_tpl->tpl_vars['ep']->value){
$_smarty_tpl->tpl_vars['ep']->_loop = true;
?>
		<tr>
			<td><?php echo $_smarty_tpl->tpl_vars['num']->value;?>
</td>
			<td align="right" nowrap><?php echo $_smarty_tpl->tpl_vars['ep']->value['pilot_first_name'];?>
 <?php echo $_smarty_tpl->tpl_vars['ep']->value['pilot_last_name'];?>
</td>
			<?php  $_smarty_tpl->tpl_vars['r'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['r']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['event']->value['rounds']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['r']->key => $_smarty_tpl->tpl_vars['r']->value){
$_smarty_tpl->tpl_vars['r']->_loop = true;
?>
				<td align="right">
				<?php  $_smarty_tpl->tpl_vars['f'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['f']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['r']->value['flights']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['f']->key => $_smarty_tpl->tpl_vars['f']->value){
$_smarty_tpl->tpl_vars['f']->_loop = true;
?>
					<?php if ($_smarty_tpl->tpl_vars['f']->value['event_pilot_id']==$_smarty_tpl->tpl_vars['ep']->value['event_pilot_id']){?>
					<?php echo $_smarty_tpl->tpl_vars['f']->value['event_round_flight_score'];?>

					<?php }?>
				<?php } ?>
				</td>
			<?php } ?>
			<td></td>
		</tr>
		<?php $_smarty_tpl->tpl_vars['num'] = new Smarty_variable($_smarty_tpl->tpl_vars['num']->value+1, null, 0);?>
		<?php } ?>
		</table>

<br>
<input type="button" value=" Back To Event List " onClick="goback.submit();" class="block-button" style="float: none;margin-left: auto;margin-right: auto;">
</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>
<form name="edit_event" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="<?php echo $_smarty_tpl->tpl_vars['event']->value['event_id'];?>
">
</form>
<form name="add_pilot" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="add_pilot">
<input type="hidden" name="event_id" value="<?php echo $_smarty_tpl->tpl_vars['event']->value['event_id'];?>
">
<input type="hidden" name="pilot_id" value="">
<input type="hidden" name="pilot_name" value="">
</form>
<?php }} ?>