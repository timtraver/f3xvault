<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">F3X Plane Database</h1>
		<div class="entry-content clearfix">
		
<form name="main" method="POST">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_comment_save">
<input type="hidden" name="plane_id" value="{$plane_id}">

<h1 class="post-title entry-title">Plane Comment Add</h1>

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Plane</th>
	<td>
		{$plane.plane_name|escape}
	</td>
</tr>
<tr>
	<th valign="top">Comment</th>
	<td>
		<textarea cols="75" rows="8" name="plane_comment_string"></textarea>
	</td>
</tr>
</table>
<center>
<br>
<input type="submit" value=" Add This Comment " class="block-button">
<input type="button" value=" Back To Plane Profile " class="block-button" onclick="goback.submit();">
</center>
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_view">
<input type="hidden" name="plane_id" value="{$plane_id}">
</form>

</div>
</div>
</div>
