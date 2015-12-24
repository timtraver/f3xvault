{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Event Export</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">


		<h2 class="post-title entry-title">{$event->info.event_name}</h2>
		<h3 class="post-title entry-title">{$event->info.event_type_name} Export Parameters</h3>
		<br>
		<form name="main" method="POST" enctype="multipart/form-data">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_export_export">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
		<tr>
			<th width="10%">Export Format</th>
			<td>
				<select name="export_format">
				<option value="csv_file"{if $export_format=="csv_file" || $export_format==""} SELECTED{/if}>CSV Saved File</option>
				<option value="csv_text"{if $export_format=="csv_text"} SELECTED{/if}>CSV Text</option>
			</td>
		</tr>
		<tr>
			<th>Export Field Separators</th>
			<td>
				<input type="radio" name="field_separator" value=","{if $field_separator=="," || $field_separator==""} CHECKED{/if}> Comma or 
				<input type="radio" name="field_separator" value=";"{if $field_separator==";"} CHECKED{/if}> Semicolon 
			</td>
		</tr>
		{if $export_content}
		<tr>
			<th>Export Text</th>
			<td>
				<textarea name="export_text" rows="40" cols="150">{$export_content}</textarea>
			</td>
		</tr>
		{/if}
		<tr>
			<td colspan="2" style="text-align: center;">
				<input type="button" value=" Back To Event View " class="btn btn-primary btn-rounded" onClick="document.goback.submit();">
				<input type="button" value=" Export Event Info " class="btn btn-primary btn-rounded" onClick="document.main.submit();">
			</td>
		</tr>
		</table>
		</form>
	
	
		<form name="goback" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_view">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		</form>
			
	</div>
</div>

{/block}