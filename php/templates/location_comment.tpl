<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">RC Location Database</h1>
		<div class="entry-content clearfix">
		
<form name="main" method="POST">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_comment_save">
<input type="hidden" name="location_id" value="{$location_id}">

<h1 class="post-title entry-title">Location Comment Add</h1>

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Location</th>
	<td>
		{$location.location_name}
	</td>
</tr>
<tr>
	<th valign="top">Comment</th>
	<td>
		<textarea cols="75" rows="8" name="location_comment_string"></textarea>
	</td>
</tr>
</table>
<center>
<br>
<input type="submit" value=" Add This Comment " class="block-button">
<input type="button" value=" Back To Location Profile " class="block-button" onclick="goback.submit();">
</center>
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="location">
<input type="hidden" name="function" value="location_view">
<input type="hidden" name="location_id" value="{$location_id}">
</form>

</div>
</div>
</div>
