<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.dialog.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.button.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
function save_data(element) {ldelim}
	$.ajax({ldelim}
		type: "POST",
		url: "/",
		data: {ldelim}
			action: "event",
			function: "save_individual_flight",
			event_id: "{$event->info.event_id}",
			event_round_id: "{$event_round_id}",
			event_round_number: "{$round_number}",
			flight_type_id: document.main.flight_type_id.value,
			event_round_time_choice: document.main.event_round_time_choice.value,
			event_round_score_status: document.main.event_round_score_status.value,
			field_name: element.name,
			field_value: element.value
		{rdelim}
	{rdelim});
{rdelim}
$(function() {ldelim}
	var pilots = [
		{foreach $event->pilots as $p}
		{ldelim}"id":{$p.event_pilot_id},"label":"{$p.pilot_first_name} {$p.pilot_last_name}","value":"{$p.pilot_first_name} {$p.pilot_last_name}"{rdelim}{if !$t@last},{/if}
		{/foreach}
	];
{literal}
	$( "#add_reflight" ).dialog({
		title: "Add A Pilot To A Reflight Group",
		autoOpen: false,
		height: 150,
		width: 350,
		modal: true,
		buttons: {
			"Add This Pilot": function() {
				document.reflight.submit();
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		},
		close: function() {
		}
	});
	$( "#addreflightoff" )
		.button()
		.click(function() {
		$( "#add_reflight" ).dialog( "open" );
		});
	$("#pilot_name").autocomplete({
		source: pilots,
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
			document.reflight.event_pilot_id.value = ui.item.id;
			var name=document.getElementById('pilot_name');
			document.reflight.pilot_name.value=name.value;
			reflight.submit();
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
   			if(id.value==''){
				document.reflight.pilot_id.value = 0;
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
{/literal}
</script>

<div id="add_reflight" style="overflow: hidden;">
		<form name="reflight" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_round_add_reflight">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="event_round_id" value="{$event_round_id}">
		<input type="hidden" name="event_round_number" value="{$round_number}">
		<input type="hidden" name="flight_type_id" value="">
		<input type="hidden" name="event_pilot_id" value="">
		<div style="float: left;padding-right: 10px;">
			<input type="text" name="group" size="2"><br>
			<span style="font-style: italic;color: grey;"> Group </span>
		</div>
		<div>
			<input id="pilot_name" type="text" name="pilot_name" size="30"><br>
			<img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
			<span id="search_message" style="font-style: italic;color: grey;"> Start typing to search pilots</span>
		</div>
		<br style="clear:both" />
		</form>
</div>


<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Settings - {$event->info.event_name}</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th align="right">Location</th>
			<td>
			{$event->info.location_name} - {$event->info.location_city},{$event->info.state_code} {$event->info.country_code}
			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			{$event->info.event_type_name}
			</td>
			<th align="right">Event Contest Director</th>
			<td>
			{$event->info.pilot_first_name} {$event->info.pilot_last_name} - {$event->info.pilot_city}
			</td>
		</tr>
		</table>
		
	</div>
		<br>
		<form name="main" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_round_save">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="event_round_id" value="{$event_round_id}">
		<input type="hidden" name="event_round_number" value="{$round_number}">
		<input type="hidden" name="create_new_round" value="0">
		
		<h1 class="post-title entry-title">Event Round {$round_number}</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" nowrap>Event Round Type</th>
			<td>
				{if $event->info.event_type_flight_choice==1}
					<select name="flight_type_id">
					{foreach $flight_types as $ft}
					<option value="{$ft.flight_type_id}" {if $ft.flight_type_id==$event->rounds.$round_number.flight_type_id}SELECTED{/if}>{$ft.flight_type_name}</option>
					{/foreach}
					</select>
				{else}
					{foreach $flight_types as $ft}
						{$ft.flight_type_name}{if $ft.flight_type_landing} + Landing{/if}{if !$ft@last},&nbsp;{/if}
					{/foreach}
					<input type="hidden" name="flight_type_id" value="0">
				{/if}
			</td>
			{if $event->info.event_type_time_choice==1}
			<th>
				Max Flight Time
			</th>
			<td>
				{if $event->info.event_type_time_choice==1}
					<input type="text" size="5" name="event_round_time_choice" value="{$event->rounds.$round_number.event_round_time_choice}"> Minutes
				{else}
					<input type="hidden" name="event_round_time_choice" value="0">
				{/if}
			</td>
			{else}
			<th colspan="2">&nbsp;</th>
			{/if}
		</tr>
		<tr>
			<th nowrap>Event Round Sort By</th>
			<td>
				<select name="sort_by" onChange="document.sort_round.sort_by.value=document.main.sort_by.value; sort_round.submit();">
				<option value="round_rank"{if $sort_by=='round_rank'} SELECTED{/if}>Round Rank</option>
				<option value="entry_order"{if $sort_by=='entry_order'} SELECTED{/if}>Entry Order</option>
				<option value="flight_order"{if $sort_by=='flight_order'} SELECTED{/if}>Round Flight Order</option>
				<option value="alphabetical_first"{if $sort_by=='alphabetical_first'} SELECTED{/if}>Alphabetical Order - First Name</option>
				<option value="alphabetical_last"{if $sort_by=='alphabetical_last'} SELECTED{/if}>Alphabetical Order - Last Name</option>
				</select>
			</td>
			<th nowrap>Include This Round In Final Results</th>
			<td align="left">
				<input type="checkbox" name="event_round_score_status"{if $event->rounds.$round_number.event_round_score_status==1} CHECKED{/if}>
			</td>
		</tr>
		<tr>
			<th nowrap>Flyoff Number</th>
			<td colspan="3">
				<input type="text" size="2" name="event_round_flyoff" value="{$event->rounds.$round_number.event_round_flyoff}"> Update this number if there will be multiple flyoff rounds or to 0 for normal round
			</td>
		</tr>
		</table>
		<br>
		<input type="button" value=" Save Event Round Info " onClick="main.submit();" class="block-button">
		<input type="button" value=" Back To Event " onClick="goback.submit();" class="block-button">
		{if $event_round_id !=0}
			<input type="button" value=" Delete This Round " class="block-button" style="float: none;margin-left: 0;margin-right: auto;" onClick="return confirm('Are you sure you wish to delete this round?') && document.delete_round.submit();">
		{/if}
		<br>
		
		<h1 class="post-title entry-title">Round Flights</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		{$tabindex=2}
		{foreach $flight_types as $ft}
			{$flight_type_id=$ft.flight_type_id}
			{if $event->info.event_type_flight_choice==1 AND $ft.flight_type_id!=$event->rounds.$round_number.flight_type_id}
				{continue}
			{/if}
			{$cols=3}
			{if $ft.flight_type_group}{$cols=$cols+1}{/if}
			{if $ft.flight_type_seconds}{$cols=$cols+1}{/if}
			{if $ft.flight_type_landing}{$cols=$cols+1}{/if}
			{if $ft.flight_type_laps}{$cols=$cols+1}{/if}
			<tr>
				<th colspan="3">Round {$round_number}</th>
				<th colspan="{$cols}">
					{$ft.flight_type_name}
				</th>
				<th>
					Include <input type="checkbox" name="event_round_flight_score_{$ft.flight_type_id}"{if $event->rounds.$round_number.flights.$flight_type_id.event_round_flight_score==1 || $event_round_id==0 || empty($event->rounds.$round_number.flights.$flight_type_id)} CHECKED{/if}>
				</th>
			</tr>
			<tr>
				<th width="2%" align="left"></th>
				<th align="left">Pilot Name</th>
				<th align="left">Team</th>
				{if $ft.flight_type_group}
					<th align="center">Group</th>
				{/if}
				{if $ft.flight_type_minutes || $ft.flight_type_seconds}
					<th align="center">Time{if $ft.flight_type_sub_flights!=0}s{/if}{if $ft.flight_type_over_penalty}/Over{/if}</th>
				{/if}
				{if $ft.flight_type_landing}
					<th align="center">Landing</th>
				{/if}
				{if $ft.flight_type_laps}
					<th align="center">Laps</th>
				{/if}
				<th align="center">Raw Score</th>
				<th align="center">Normalized Score</th>
				<th align="center">Penalty</th>
				<th align="center">Flight Rank</th>
			</tr>
			{$num=1}
			{foreach $event->rounds.$round_number.flights as $f}
			{if $f@key!=$ft.flight_type_id}
				{continue}
			{/if}
			{$groupcolor='lightgrey'}
			{$oldgroup=''}
			{foreach $f.pilots as $p}
			{$event_pilot_id=$p@key}
			{if $oldgroup!=$p.event_pilot_round_flight_group}
				{if $groupcolor=='white'}{$groupcolor='lightgrey'}{else}{$groupcolor='white'}{/if}
				{$oldgroup=$p.event_pilot_round_flight_group}
			{/if}
			{$time_disabled=0}
			<tr style="background-color: {$groupcolor};">
				<td style="background-color: lightgrey;">{$num}</td>
				<td style="background-color: white;" nowrap>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</td>
				<td style="background-color: white;" nowrap>{$event->pilots.$event_pilot_id.event_pilot_team}</td>
					{if $f.flight_type_group}
						<td align="center" nowrap><input tabindex="1" autocomplete="off" type="text" size="1" style="width:10px;" name="pilot_group_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_group}" onChange="save_data(this);"></td>					
					{/if}
					{if $f.flight_type_minutes || $f.flight_type_seconds}
						<td align="center" nowrap>
							{if $ft.flight_type_sub_flights!=0}
								{$time_disabled=1}
								{for $sub=1 to $ft.flight_type_sub_flights}
									<input tabindex="{$tabindex}" autocomplete="off" type="text" size="4" style="width:35px;text-align: right;" name="pilot_sub_flight_{$sub}_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{if $p.sub.$sub.event_pilot_round_flight_sub_val!='0:00'}{$p.sub.$sub.event_pilot_round_flight_sub_val}{/if}" onChange="save_data(this);"> {if $sub!=$ft.flight_type_sub_flights},{/if} 
									{$tabindex=$tabindex+1}
								{/for}
								= Total
							{/if}
							{if $f.flight_type_minutes}
								<input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:15px;text-align: right;" name="pilot_min_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_minutes}" onChange="save_data(this);" {if $time_disabled==1}disabled{/if}>m
								{$tabindex=$tabindex+1}
							{/if}
							{if $f.flight_type_seconds}
								<input tabindex="{$tabindex}" autocomplete="off" type="text" size="6" style="width:{$ft.accuracy*10 + 20}px;text-align: right;" name="pilot_sec_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_seconds}" onChange="save_data(this);" {if $time_disabled==1}disabled{/if}>s
								{$tabindex=$tabindex+1}
							{/if}
							{if $f.flight_type_over_penalty}
								<input type="checkbox" tabindex="{$tabindex}" name="pilot_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if} onChange="save_data(this);">
								{$tabindex=$tabindex+1}
							{/if}
						</td>
					{/if}
					{if $f.flight_type_landing}
						<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:25px;text-align: right;" name="pilot_land_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_landing}" onChange="save_data(this);"></td>
						{$tabindex=$tabindex+1}
					{/if}
					{if $f.flight_type_laps}
						<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:15px;" name="pilot_laps_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_laps}" onChange="save_data(this);"></td>
						{$tabindex=$tabindex+1}
					{/if}
					<td align="right" nowrap>
						{if $f.flight_type_code=='f3f_speed' OR $f.flight_type_code=='f3b_speed'}
						{$p.event_pilot_round_flight_raw_score}
						{else}
						{$p.event_pilot_round_flight_raw_score|string_format:"%02.3f"}
						{/if}
					</td>
					<td align="right" nowrap>
					{if $p.event_pilot_round_flight_dropped}<del><font color="red">{/if}
					{$p.event_pilot_round_flight_score}
					{if $p.event_pilot_round_flight_dropped}</font></del>{/if}
					</td>
					<td align="center" nowrap>
						<input tabindex="1000" autocomplete="off" type="text" size="4" style="width:25px;text-align: right;" name="pilot_pen_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty}{/if}" onChange="save_data(this);">
					</td>
					<td align="right" nowrap>
					{$p.event_pilot_round_flight_rank}
					</td>
			</tr>
			{$num=$num+1}
			{/foreach}
			{/foreach}
			{if $ft.flight_type_reflight==1}
			<tr>
			<th colspan="3">Reflights</th>
			<th colspan="8">
				<input id="addreflight" type="button" class="button" value=" Add Reflight Entry " onClick="document.reflight.flight_type_id.value={$ft.flight_type_id};$('#add_reflight').dialog('open');">
			</th>
			</tr>
			{foreach $event->rounds.$round_number.reflights as $f}
				{if $f@key!=$ft.flight_type_id}
					{continue}
				{/if}
				{$groupcolor='lightgrey'}
				{$oldgroup=''}
				{foreach $f.pilots as $p}
				{$event_pilot_id=$p@key}
				{if $oldgroup!=$p.event_pilot_round_flight_group}
					{if $groupcolor=='white'}{$groupcolor='lightgrey'}{else}{$groupcolor='white'}{/if}
					{$oldgroup=$p.event_pilot_round_flight_group}
				{/if}
				<tr style="background-color: {$groupcolor};">
					<td style="background-color: lightgrey;">{$num}</td>
					<td style="background-color: white;" nowrap>{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}</td>
					<td style="background-color: white;" nowrap>{$event->pilots.$event_pilot_id.event_pilot_team}</td>
						{if $f.flight_type_group}
							<td align="center" nowrap><input tabindex="1" autocomplete="off" type="text" size="1" style="width:10px;" name="pilot_group_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_group}" onChange="save_data(this);"></td>					
						{/if}
						{if $f.flight_type_minutes || $f.flight_type_seconds}
							<td align="center" nowrap>
								{if $f.flight_type_minutes}
									<input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:15px;text-align: right;" name="pilot_min_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_minutes}" onChange="save_data(this);">m
									{$tabindex=$tabindex+1}
								{/if}
								{if $f.flight_type_seconds}
									<input tabindex="{$tabindex}" autocomplete="off" type="text" size="6" style="width:{$ft.accuracy*10 + 20}px;text-align: right;" name="pilot_sec_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_seconds}" onChange="save_data(this);">s
									{$tabindex=$tabindex+1}
								{/if}
								{if $f.flight_type_over_penalty}
									<input type="checkbox" tabindex="{$tabindex}" name="pilot_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if} onChange="save_data(this);">
									{$tabindex=$tabindex+1}
								{/if}
							</td>
						{/if}
						{if $f.flight_type_landing}
							<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:25px;text-align: right;" name="pilot_land_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_landing}" onChange="save_data(this);"></td>
							{$tabindex=$tabindex+1}
						{/if}
						{if $f.flight_type_laps}
							<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:15px;" name="pilot_laps_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{$p.event_pilot_round_flight_laps}" onChange="save_data(this);"></td>
							{$tabindex=$tabindex+1}
						{/if}
						<td align="right" nowrap>
							{if $f.flight_type_code=='f3f_speed' OR $f.flight_type_code=='f3b_speed'}
							{$p.event_pilot_round_flight_raw_score}
							{else}
							{$p.event_pilot_round_flight_raw_score|string_format:"%02.3f"}
							{/if}
						</td>
						<td align="right" nowrap>
						{if $p.event_pilot_round_flight_dropped}<del><font color="red">{/if}
						{$p.event_pilot_round_flight_score}
						{if $p.event_pilot_round_flight_dropped}</font></del>{/if}
						</td>
						<td align="center" nowrap>
							<input tabindex="1000" autocomplete="off" type="text" size="4" style="width:25px;text-align: right;" name="pilot_pen_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}" value="{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty}{/if}" onChange="save_data(this);">
						</td>
						<td align="right" nowrap>
						{$p.event_pilot_round_flight_rank}
						</td>
						<td align="right" nowrap>
						<a href="?action=event&function=event_round_flight_delete&event_id={$event->info.event_id}&event_round_id={$event_round_id}&event_round_number={$round_number}&event_pilot_round_flight_id={$p.event_pilot_round_flight_id}" onClick="return confirm('Are you sure you wish to remove this pilot reflight?');"><img src="/images/icons/delete.png"></a>
						</td>
				</tr>
				{$num=$num+1}
				{/foreach}
			{/foreach}
			
			{/if}
		{/foreach}
		</table>




		</form>
<br>
<input type="button" value=" Save Event Round " onClick="main.submit();" class="block-button">
<input type="button" value=" Save And Create New Round " onClick="document.main.create_new_round.value=1;main.submit();" class="block-button">
<input type="button" value=" Back To Event " onClick="goback.submit();" class="block-button">
{if $event_round_id !=0}
<input type="button" value=" Delete This Round " class="block-button" style="float: none;margin-left: 0;margin-right: auto;" onClick="return confirm('Are you sure you wish to delete this round?') && document.delete_round.submit();">
{/if}


</div>

<form name="sort_round" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_round_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_round_id" value="{$event_round_id}">
<input type="hidden" name="sort_by" value="">
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>

<form name="delete_round" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_round_delete">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_round_id" value="{$event_round_id}">
<input type="hidden" name="event_round_number" value="{$round_number}">
</form>
