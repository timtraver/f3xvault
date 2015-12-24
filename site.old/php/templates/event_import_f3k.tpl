<script src="/includes/jquery.min.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
	$("#event_user_name").autocomplete({
		source: "/lookup.php?function=lookup_pilot",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_pilot');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.event_user_add.pilot_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.event_user_add.event_user_name.value==''){
				document.event_user_add.pilot.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_pilot');
			loading.style.display = "none";
   			var mes=document.getElementById('user_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
});
</script>
{/literal}

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">F3K Event Import Step 1</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Import File for Event</h1>
<br>
<p>This import process is experimental, and may not be for every discipline. It will work with F3F Times at the moment with a file that is saved in comma separated format only.<br>
The format is comma separated with the following fields<br>
Pilot Name,Group,subflight times (appropriate number of them),penalty<br>
</p>
<br>
{if $lines|count==0}
	<form name="main" method="POST" enctype="multipart/form-data">
	<input type="hidden" name="action" value="event">
	<input type="hidden" name="function" value="event_import_f3k">
	<input type="hidden" name="event_id" value="{$event->info.event_id}">
	<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
	<tr>
		<th>Import File</th>
		<td>
			<input type="hidden" name="MAX_FILE_SIZE" value="2000000">
			<input type="file" size="60" name="import_file" value="">
		</td>
	</tr>
	<tr>
		<th>Round To Import</th>
		<td>
			<input type="text" size="2" name="round" value="">
		</td>
	</tr>
	<tr>
		<th>Round Task</th>
		<td>
			<select name="flight_type_id">
			{foreach $event->flight_types as $ft}
			{$flight_type_id=$ft@key}
			<option value="{$flight_type_id}">{$ft.flight_type_name}</option>
			{/foreach}
			</select>
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
{else}
	<form name="main" method="POST">
	<input type="hidden" name="action" value="event">
	<input type="hidden" name="function" value="event_import_f3k_save">
	<input type="hidden" name="event_id" value="{$event->info.event_id}">
	<input type="hidden" name="round" value="{$round}">
	<input type="hidden" name="flight_type_id" value="{$flight_type_id}">

	Imported lines from csv file
	<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
	<tr>
		<th width="10">&nbsp;</th>
		<th width="1%">Row</th>
		<th>Pilot Name</th>
		<th>Pilot Lookup</th>
		<th>Group</th>
		{$subflights=$event->flight_types.$flight_type_id.flight_type_sub_flights}
		{for $i=1 to $subflights}
			<th>Time {$i}</th>
		{/for}
		<th>Penalty</th>
	</tr>
	{$line_number=1}
	{foreach $lines as $line}
	<tr>
		<th><input type="checkbox" name="line_import_{$line_number}" CHECKED></th>
		<th>{$line_number}</th>
		<td nowrap>
			{$line.fields.0}
			<input type="hidden" name="pilot_original_{$line_number}" value="{$line.fields.0}">
		</td>
		<td nowrap>
			{$found=0}
			<select name="pilot_id_{$line_number}">
			{foreach $line.pilots as $p}
				<option value="{$p.pilot_id}" {if $p.pilot_full_name==$line.fields.0}SELECTED{$found=1}{/if}>{$p.pilot_full_name}{if $p.pilot_id!=0} - {$p.pilot_city},{$p.state_code} {$p.country_code}{/if}</option>
			{/foreach}
			</select>
			{if $found}<img src="/images/icons/accept.png">{else}<img src="/images/icons/exclamation.png">{/if}
		</td>
		<td>
			{$line.fields.1}
			<input type="hidden" name="pilot_group_{$line_number}" value="{$line.fields.1}">
		</td>
		{$field_num=2}
		{for $i=1 to $event->flight_types.$flight_type_id.flight_type_sub_flights}
		<td>
			{$line.fields.$field_num}
			<input type="hidden" name="pilot_sub_{$line_number}_{$i}" value="{$line.fields.$field_num}">
		</td>
		{$field_num=$field_num+1}
		{/for}
		<td>
			{$line.fields.$field_num}
			<input type="hidden" name="pilot_penalty_{$line_number}" value="{$line.fields.$field_num}">
		</td>
	</tr>
	{$line_number=$line_number+1}
	{/foreach}
	<tr>
		<th colspan="{$subflights+8}">
		<input type="button" value=" Cancel Import " class="block-button" onClick="goback.submit();">
		<input type="submit" value=" Import This Data " class="block-button">
		</th>
	</tr>
	</table>
	</form>
{/if}


<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>



</div>
</div>
</div>

