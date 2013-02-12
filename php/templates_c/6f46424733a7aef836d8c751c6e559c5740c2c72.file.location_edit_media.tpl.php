<?php /* Smarty version Smarty-3.1.11, created on 2012-09-03 01:09:53
         compiled from "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\php\templates\location_edit_media.tpl" */ ?>
<?php /*%%SmartyHeaderCode:298465043f0a1081ea9-25434146%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '6f46424733a7aef836d8c751c6e559c5740c2c72' => 
    array (
      0 => 'C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\php\\templates\\location_edit_media.tpl',
      1 => 1346634507,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '298465043f0a1081ea9-25434146',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.11',
  'unifunc' => 'content_5043f0a10cbe84_84753154',
  'variables' => 
  array (
    'location_id' => 0,
    'location' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5043f0a10cbe84_84753154')) {function content_5043f0a10cbe84_84753154($_smarty_tpl) {?><div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Location Database</h1>
		<div class="entry-content clearfix">
		
<script type="text/javascript">
	function showrows(){
		if(document.main.location_media_type.value=="picture"){
			document.getElementById("picture").style.display="";
			document.getElementById("media").style.display="none";
		}else{
			document.getElementById("picture").style.display="none";
			document.getElementById("media").style.display="";
		}
	}
</script>

<form name="main" method="POST" enctype="multipart/form-data">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_media_add">
<input type="hidden" name="location_id" value="<?php echo $_smarty_tpl->tpl_vars['location_id']->value;?>
">
<input type="hidden" name="MAX_FILE_SIZE" value="2000000">

<h1 class="post-title entry-title">Location Media Edit</h1>

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Location</th>
	<td>
		<?php echo $_smarty_tpl->tpl_vars['location']->value['location_name'];?>

	</td>
</tr>
<tr>
	<th>Media Type</th>
	<td>
	<select name="location_media_type" onChange="showrows();">
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
	<td><input type="text" size="50" name="location_media_url" value=""></td>
</tr>
</tbody>
<tr>
	<th>Media Caption</th>
	<td><input type="text" size="50" name="location_media_caption" value=""></td>
</tr>
</table>
<center>
<br>
<input type="submit" value=" Add This Media " class="block-button">
<input type="button" value=" Back To Location Profile " class="block-button" onclick="goback.submit();">
</center>
</form>

<script type="text/javascript">
	document.getElementById("picture").style.display="";
	document.getElementById("media").style.display="none";
</script>

<form name="goback" method="GET">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_edit">
<input type="hidden" name="location_id" value="<?php echo $_smarty_tpl->tpl_vars['location_id']->value;?>
">
</form>

</div>
</div>
</div>
<?php }} ?>