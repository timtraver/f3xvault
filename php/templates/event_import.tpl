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
		<h1 class="post-title entry-title">F3X Event Import Step 1</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Import File for Event</h1>
<br>
<p>This import process is experimental, and may not be for every discipline. It will work with F3F Times at the moment with a file that is saved in comma separated format only. The format has to be the pilot name followed by the round times only.
</p>
<br>
{if $lines|count==0}
	<form name="main" method="POST" enctype="multipart/form-data">
	<input type="hidden" name="action" value="event">
	<input type="hidden" name="function" value="event_import">
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
		<th>Event has a Zero Round</th>
		<td>
			<input type="checkbox" name="event_zero_round">
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
	<input type="hidden" name="function" value="event_import_save">
	<input type="hidden" name="event_id" value="{$event->info.event_id}">
	<input type="hidden" name="event_zero_round" value="{$event_zero_round}">

	Imported lines from csv file
	<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
	<tr>
		<th>Row</th>
		{if $event_zero_round==1}
			{$round=0}
		{else}
			{$round=1}
		{/if}
		{foreach $columns as $c}
		<th>
			{if $c=='alpha'}
			Pilot Name
			</th>
			<th>
			Pilot Lookup
			{/if}
			{if $c=='numeric'}
			Round {$round}
			{$round=$round+1}
			{/if}
		</th>
		{/foreach}
	</tr>
	{$line_number=1}
	{foreach $lines as $line}
	<tr>
		<th>{$line_number}</th>
		{$round=1}
		{foreach $line as $l}
		{$key=$l@key}
		{if !$columns.$key}
			{continue}
		{/if}
		<td>
			{if $columns.$key=='alpha'}
				{$l}
				<input type="hidden" name="pilot_original_{$line_number}" value="{$l}">
				</td>
				<td>
				{$found=0}
				<select name="pilot_id_{$line_number}">
				{foreach $line.pilots as $p}
				<option value="{$p.pilot_id}" {if $p.pilot_full_name==$l}SELECTED{$found=1}{/if}>{$p.pilot_full_name}{if $p.pilot_id!=0} - {$p.pilot_city},{$p.state_code} {$p.country_code}{/if}</option>
				{/foreach}
				</select>
				{if $found}<img src="/images/icons/accept.png">{else}<img src="/images/icons/exclamation.png">{/if}
			{else}
				{$l}
				<input type="hidden" name="round_{$line_number}_{$round}" value="{$l}">
				{$round=$round+1}
			{/if}
		</td>
		{/foreach}
	</tr>
	{$line_number=$line_number+1}
	{/foreach}
	<tr>
		<th colspan="{$columns|count + 2}">
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

