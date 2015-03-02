<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">F3X Event Import Step 1</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Import File for Event</h1>
<p>This import process is experimental, and may not be for every discipline yet.</p>
<br>

<form name="main" method="POST" enctype="multipart/form-data">
<input type="hidden" name="action" value="import">
<input type="hidden" name="function" value="import_verify">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
	{if $event->info.event_id!=0}
	<tr>
		<th>Event Name</th>
		<td>
			{$event->info.event_name}
		</td>
	</tr>
	{/if}
	<tr>
		<th>Import File</th>
		<td>
			<input type="hidden" name="MAX_FILE_SIZE" value="2000000">
			<input type="file" size="60" name="import_file" value="">
		</td>
	</tr>
	<tr>
		<th>Import Field Separator</th>
		<td>
			<input type="radio" name="field_separator" value="," CHECKED> Comma or 
			<input type="radio" name="field_separator" value=";"> Semicolon 
		</td>
	</tr>
	<tr>
		<th>Decimal Type</th>
		<td>
			<input type="radio" name="decimal_type" value="." CHECKED> Period or 
			<input type="radio" name="decimal_type" value=","> Comma 
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<input type="button" value=" Back To Event Edit " class="block-button" onClick="goback.submit();">
			<input type="submit" value=" Submit Initial Import File " class="block-button">
		</td>
	</tr>
</table>
</form>

</div>
</div>
</div>

