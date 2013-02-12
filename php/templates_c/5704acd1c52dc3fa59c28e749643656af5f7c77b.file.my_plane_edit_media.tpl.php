<?php /* Smarty version Smarty-3.1.11, created on 2012-11-26 00:25:20
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\my_plane_edit_media.tpl" */ ?>
<?php /*%%SmartyHeaderCode:15142503477e415a097-85579809%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '5704acd1c52dc3fa59c28e749643656af5f7c77b' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\my_plane_edit_media.tpl',
      1 => 1346634795,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '15142503477e415a097-85579809',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_503477e41c1330_45155069',
  'variables' => 
  array (
    'action' => 0,
    'pilot_plane_id' => 0,
    'plane' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_503477e41c1330_45155069')) {function content_503477e41c1330_45155069($_smarty_tpl) {?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">My Pilot Profile</h1>
		<div class="entry-content clearfix">
		
<script type="text/javascript">
	function showrows(){
		if(document.main.pilot_plane_media_type.value=="picture"){
			document.getElementById("picture").style.display="";
			document.getElementById("media").style.display="none";
		}else{
			document.getElementById("picture").style.display="none";
			document.getElementById("media").style.display="";
		}
	}
</script>

<form name="main" method="POST" enctype="multipart/form-data">
<input type="hidden" name="action" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['action']->value, ENT_QUOTES, 'UTF-8', true);?>
">
<input type="hidden" name="function" value="my_plane_media_add">
<input type="hidden" name="pilot_plane_id" value="<?php echo $_smarty_tpl->tpl_vars['pilot_plane_id']->value;?>
">
<input type="hidden" name="MAX_FILE_SIZE" value="2000000">

<h1 class="post-title entry-title">Plane Media Edit</h1>

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Plane</th>
	<td>
		<?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_type_short_name'];?>
 - <?php echo $_smarty_tpl->tpl_vars['plane']->value['plane_name'];?>

	</td>
</tr>
<tr>
	<th>Media Type</th>
	<td>
	<select name="pilot_plane_media_type" onChange="showrows();">
		<option value="picture" SELECTED>Picture or File</option>
		<option value="video">YouTube or Vimeo Video URL</option>
	</select>
	</td>
</tr>
<tbody id="picture" style="display: none;">
<tr>
	<th>Upload Picture</th>
	<td><input type="file" size="50" name="uploaded_file" value=""></td>
</tr>
</tbody>
<tbody id="media" style="display: none;">
<tr>
	<th>URL</th>
	<td><input type="text" size="50" name="pilot_plane_media_url" value=""></td>
</tr>
</tbody>
<tr>
	<th>Media Caption</th>
	<td><input type="text" size="50" name="pilot_plane_media_caption" value=""></td>
</tr>
</table>
<center>
<br>
<input type="submit" value=" Add This Media " class="block-button">
<input type="button" value=" Back To My Plane Profile " class="block-button" onclick="goback.submit();">
</center>
</form>
<script type="text/javascript">
	document.getElementById("picture").style.display="";
	document.getElementById("media").style.display="none";
</script>
<form name="goback" method="GET">
<input type="hidden" name="action" value="my">
<input type="hidden" name="function" value="my_plane_edit">
<input type="hidden" name="pilot_plane_id" value="<?php echo $_smarty_tpl->tpl_vars['pilot_plane_id']->value;?>
">
</form>

</div>
</div>
</div>
<?php }} ?>