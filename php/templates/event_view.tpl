<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.dialog.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.button.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#pilot_name").autocomplete({
		source: "/lookup.php?function=lookup_pilot",
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
			document.event_pilot_add.pilot_id.value = ui.item.id;
			var name=document.getElementById('pilot_name');
			document.event_pilot_add.pilot_name.value=name.value;
			event_pilot_add.submit();
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
   			if(id.value==''){
				document.event_pilot_add.pilot_id.value = 0;
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
	$("#pilot_name").keyup(function(event) { 
		if (event.keyCode == 13) { 
			//For enter.
			var name=document.getElementById('pilot_name');
			document.event_pilot_add.pilot_name.value=name.value;
			event_pilot_add.submit();
        }
    });
	$( "#print_round" ).dialog({
		title: "Print Individual Round Details",
		autoOpen: false,
		height: 150,
		width: 350,
		modal: true,
		buttons: {
			"Print Rounds": function() {
				document.printround.submit();
				$( this ).dialog( "close" );
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		},
		close: function() {
		}
	});
	$( "#printroundoff" )
		.button()
		.click(function() {
		$( "#print_round" ).dialog( "open" );
	});
});
function toggle(element,tog) {
	 if (document.getElementById(element).style.display == 'none') {
	 	document.getElementById(element).style.display = 'block';
	 	tog.innerHTML = '(<u>Hide Pilot List</u>)';
	 } else {
		 document.getElementById(element).style.display = 'none';
		 tog.innerHTML = '(<u>Show Pilot List</u>)';
	 }
}
{/literal}
function check_permission() {ldelim}
	{if $permission!=1}
		alert('Sorry, but you do not have permission to edit this event. Contact the event owner if you need access to edit this event.');
		return 0;
	{else}
		return 1;
	{/if}
{rdelim}
</script>

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">{$event->info.event_name|escape} <input type="button" value=" Edit Event Parameters " onClick="if(check_permission()){ldelim}document.event_edit.submit();{rdelim}" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th align="right">Location</th>
			<td>
			<a href="?action=location&function=location_view&location_id={$event->info.location_id}">{$event->info.location_name|escape} - {$event->info.location_city|escape},{$event->info.state_code|escape} {$event->info.country_code|escape}</a>
			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			{$event->info.event_type_name|escape}
			</td>
			<th align="right">Event Contest Director</th>
			<td>
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape} - {$event->info.pilot_city|escape}
			</td>
		</tr>
		{if $event->info.series_name || $event->info.club_name}
		<tr>
			<th align="right">Part Of Series</th>
			<td>
			<a href="?action=series&function=series_view&series_id={$event->info.series_id}">{$event->info.series_name|escape}</a>
			</td>
			<th align="right">Club</th>
			<td>
			<a href="?action=club&function=club_view&club_id={$event->info.club_id}">{$event->info.club_name|escape}</a>
			</td>
		</tr>
		{/if}
		</table>
		
	</div>
		<br>
		<h1 class="post-title entry-title">Event Pilots {if $event->pilots}({$event->pilots|count}){/if} <span id="viewtoggle" onClick="toggle('pilots',this);">(<u>Hide Pilot List</u>)</span>
			<input type="button" class="button" value=" Event Draw " style="float:right;" onclick="event_draw.submit();">
		</h1>
		<span id="pilots">
		<input type="button" class="button" value=" Add New Pilot " style="float:right;" onclick="if(check_permission()){ldelim}var name=document.getElementById('pilot_name');document.event_pilot_add.pilot_name.value=name.value;event_pilot_add.submit();{rdelim}">
		<input type="text" id="pilot_name" name="pilot_name" size="40">
		    <img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		    <span id="search_message" style="font-style: italic;color: grey;"> Start typing to search pilot to Add</span>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="center">AMA#</th>
			<th align="left" colspan="2">Pilot Name</th>
			<th align="left">Pilot Class</th>
			<th align="left">Pilot Plane</th>
			<th align="left">Pilot Freq</th>
			<th align="left">Event Team</th>
			<th align="left" width="4%"></th>
		</tr>
		{assign var=num value=1}
		{foreach $event->pilots as $p}
		<tr>
			<td>{$num}</td>
			<td align="center">{$p.pilot_ama|escape}</td>
			<td>
			{if $p.country_code}<img src="/images/flags/countries-iso/shiny/16/{$p.country_code|escape}.png" style="vertical-align: middle;" title="{$p.country_code}">{/if}
			{if $p.state_name && $p.country_code=="US"}<img src="/images/flags/states/16/{$p.state_name|escape}-Flag-16.png" style="vertical-align: middle;" title="{$p.state_name}">{/if} 
			</td>
			<td>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
			<td>{$p.class_description|escape}</td>
			<td>{$p.plane_name|escape}</td>
			<td>{$p.event_pilot_freq|escape}</td>
			<td>{$p.event_pilot_team|escape}</td>
			<td nowrap>
				<a href="/?action=event&function=event_pilot_edit&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Edit Event Pilot"><img width="16" src="/images/icon_edit_small.gif"></a>
				<a href="/?action=event&function=event_pilot_remove&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Remove Event Pilot" onClick="return confirm('Are you sure you want to remove {$p.pilot_first_name|escape} from the event?');"><img width="14px" src="/images/del.gif"></a>
			</td>
		</tr>
		{assign var=num value=$num+1}
		{/foreach}
		</table>
		</span>
		<br>


		{$perpage=8}
		{* Lets figure out how many flyoff and zero  rounds there are *}
		{$flyoff_rounds=0}
		{$zero_rounds=0}
		{foreach $event->rounds as $r}
			{if $r.event_round_flyoff!=0}
				{$flyoff_rounds=$flyoff_rounds+1}
			{/if}
			{if $r.event_round_number==0}
				{$zero_rounds=$zero_rounds+1}
			{/if}
		{/foreach}
		{$prelim_rounds=$event->rounds|count - $flyoff_rounds}
		{$pages=ceil($prelim_rounds / $perpage)}
		{if $pages==0}{$pages=1}{/if}
		{if $zero_rounds>0}
			{$start_round=0}
			{$end_round=$perpage - $zero_rounds}
			{if $end_round>=$prelim_rounds}
				{$end_round=$prelim_rounds - $zero_rounds}
			{/if}
			{$numrounds=$end_round-$start_round + $zero_rounds}
		{else}
			{$start_round=1}
			{$end_round=$perpage}
			{if $end_round>=$prelim_rounds}
				{$end_round=$prelim_rounds - $zero_rounds}
			{/if}
			{$numrounds=$end_round-$start_round + 1}
		{/if}
		
		{for $page_num=1 to $pages}
		{if $page_num>1}
			{$numrounds=$end_round-$start_round + 1}
		{/if}
		<h1 class="post-title entry-title">Event {if $event->flyoff_totals|count >0}Preliminary {/if}Rounds {if $event->rounds}({$start_round}-{$end_round}) {/if} Overall Classification
			{if $page_num==1}
				{if $event->info.event_type_flyoff==1}<input type="button" value=" Add Flyoff Round " onClick="if(check_permission()){ldelim}document.event_add_round.flyoff_round.value=1; document.event_add_round.submit();{rdelim}" class="block-button">{/if}
				{if $event->info.event_type_zero_round==1}<input type="button" value=" Add Zero Round " onClick="if(check_permission()){ldelim}document.event_add_round.zero_round.value=1; document.event_add_round.submit();{rdelim}" class="block-button">{/if}
				<input type="button" value=" Add Round " onClick="if(check_permission()){ldelim}document.event_add_round.submit();{rdelim}" class="block-button">
			{/if}
		</h1>
		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<td width="2%" align="left"></td>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{$numrounds+1}" align="center" nowrap>
				Completed Rounds ({if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drop{if $event->totals.round_drops!=1}s{/if} In Effect)
			</th>
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Drop</th>
			<th width="5%" nowrap>Pen</th>
			<th width="5%" nowrap>Total Score</th>
			<th width="5%" nowrap>Percent</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=0}
					{continue}
				{/if}
				{$round_number=$r.event_round_number}
				{if $round_number >= $start_round && $round_number <= $end_round}
				<th class="info" width="5%" align="center" nowrap>
					<div style="position:relative;">
					<span>
						{$flight_type_id=$r.flight_type_id}
						{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}
							<font color="red"><b>Round Not Currently Scored</b></font><br>
						{/if}
						{if $event->flight_types.$flight_type_id.flight_type_code|strstr:"f3k"}
							View Details of Round<br>{$event->flight_types.$flight_type_id.flight_type_name|escape}
						{else}
							View Details of Round {$r.event_round_number|escape}
						{/if}
					</span>
					<a href="/?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$r.event_round_id}" title="Edit Round">{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}<del><font color="red">{/if}Round {$r.event_round_number|escape}{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}</del></font>{/if}</a>
					</div>
				</th>
				{/if}
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{$previous=0}
		{$diff_to_lead=0}
		{$diff=0}
		{foreach $event->totals.pilots as $e}
		{if $e.total>$previous}
			{$previous=$e.total}
		{else}
			{$diff=$previous-$e.total}
			{$diff_to_lead=$diff_to_lead+$diff}
		{/if}
		{$event_pilot_id=$e.event_pilot_id}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank|escape}</td>
			<td align="right" nowrap>
				{$full_name=$e.pilot_first_name|cat:" "|cat:$e.pilot_last_name}
				<a href="?action=event&function=event_pilot_rounds&event_pilot_id={$e.event_pilot_id}&event_id={$event->info.event_id}" title="{$full_name}">{$full_name|truncate:20:"...":true:true}</a>
				{if $e.country_code}<img src="/images/flags/countries-iso/shiny/16/{$e.country_code|escape}.png" style="vertical-align: middle;" title="{$e.country_name}">{/if}
				{if $e.state_name && $e.country_code=="US"}<img src="/images/flags/states/16/{$e.state_name|escape}-Flag-16.png" style="vertical-align: middle;" title="{$e.state_name}">{/if}
			</td>
			{foreach $e.rounds as $r}
				{$round_number=$r@key}
				{if $round_number >= $start_round && $round_number <= $end_round}
				<td class="info" align="center"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
					<div style="position:relative;">
					{$dropval=0}
					{$dropped=0}
					{foreach $r.flights as $f}
						{if $f.event_pilot_round_flight_dropped}
							{$dropval=$dropval+$f.event_pilot_round_total_score}
							{$dropped=1}
						{/if}
					{/foreach}
					{$drop=0}
					{if $dropped==1 && $dropval==$r.event_pilot_round_total_score}{$drop=1}{/if}
					{if $drop==1}<del><font color="red">{/if}
						{if $r.event_pilot_round_total_score==1000}
							1000
						{else}
							{if $r.event_pilot_round_flight_dns==1}
								<font color="red">DNS</font>
							{elseif $r.event_pilot_round_flight_dnf==1}
								<font color="red">DNF</font>
							{else}
								{$r.event_pilot_round_total_score|string_format:"%06.3f"}
							{/if}
						{/if}
					{if $drop==1}</font></del>{/if}
					{* lets determine the content to show on popup *}
						<span>
							{$event_round_number=$r@key}
							{foreach $event->rounds.$event_round_number.flights as $f}
								{if $f.flight_type_code|strstr:'duration' || $f.flight_type_code|strstr:'f3k'}
									{if $f.flight_type_code=='f3b_duration'}A - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_minutes|escape}:{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}{if $f.flight_type_landing} - {$f.pilots.$event_pilot_id.event_pilot_round_flight_landing|escape}{/if}<br>
								{/if}
								{if $f.flight_type_code|strstr:'distance'}
									{if $f.flight_type_code=='f3b_distance'}B - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_laps|escape} Laps<br>
								{/if}
								{if $f.flight_type_code|strstr:'speed'}
									{if $f.flight_type_code=='f3b_speed'}C - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}s
								{/if}
							{/foreach}
						</span>
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td class="info" width="5%" nowrap align="right">{$e.subtotal|string_format:"%06.3f"}</td>
			<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:"%06.3f"}{/if}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties|escape}{/if}</td>
			<td class="info" width="5%" nowrap align="right">
				<div style="position:relative;">
					{$e.total|string_format:"%06.3f"}
					<span>
					Behind Prev : {$diff|string_format:"%06.3f"}<br>
					Behind Lead : {$diff_to_lead|string_format:"%06.3f"}<br>
					</span>
				</div>
			</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:"%03.2f"}%</td>
		</tr>
		{$previous=$e.total}
		{/foreach}
		{if $event->info.event_type_code=='f3f'}
		<tr>
			<th colspan="2" align="right">Round Fast Time</th>
			{foreach $event->rounds as $r}
				{$round_number=$r.event_round_number}
				{if $round_number >= $start_round && $round_number <= $end_round}
					{$fast=1000}
					{$fast_id=0}
					{foreach $r.flights as $f}
						{foreach $f.pilots as $p}
						{if $p.event_pilot_round_flight_seconds<$fast && $p.event_pilot_round_flight_seconds!=0}
							{$fast=$p.event_pilot_round_flight_seconds}
							{$fast_id=$p.event_pilot_id}
						{/if}
						{/foreach}
					{/foreach}
					{if $fast==1000}{$fast=0}{/if}
					<th class="info" align="center">
						<div style="position:relative;">
						{$fast|escape}s
						<span>
							Fast Time : {$fast}s<br>
							{$event->pilots.$fast_id.pilot_first_name|escape} {$event->pilots.$fast_id.pilot_last_name|escape}
						</span>
						</div>
					</th>
				{/if}
			{/foreach}
		</tr>
		{/if}
		</table>
		{$start_round=$end_round+1}
		{$end_round=$start_round+$perpage - 1}
		{if $end_round>$prelim_rounds}
			{$end_round=$prelim_rounds - $zero_rounds}
		{/if}
		{if $page_num!=$pages || $flyoff_rounds!=0}
		<br style="page-break-after: always;">
		{/if}
		{/for}





		<!--# Now lets do the flyoff rounds -->
		{foreach $event->flyoff_totals as $t}
			{$flyoff_number=$t@key}
		<h1 class="post-title entry-title">Event Flyoff #{$flyoff_number} Rounds ({$t.total_rounds}) Overall Classification
		</h1>
		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<td width="2%" align="left"></td>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{$t.total_rounds + 1}" align="center" nowrap>
				Completed Rounds ({if $t.round_drops==0}No{else}{$t.round_drops}{/if} Drop{if $t.round_drops!=1}s{/if} In Effect)
			</th>
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Drop</th>
			<th width="5%" nowrap>Pen</th>
			<th width="5%" nowrap>Total Score</th>
			<th width="5%" nowrap>Percent</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=$flyoff_number}
					{continue}
				{/if}
				<th class="info" width="5%" align="center" nowrap>
					<div style="position:relative;">
					<span>
						{$flight_type_id=$r.flight_type_id}
						{if $event->flight_types.$flight_type_id.flight_type_code|strstr:"f3k"}
							View Details of Round<br>{$event->flight_types.$flight_type_id.flight_type_name|escape}
						{else}
							View Details of Round {$r.event_round_number|escape}
						{/if}
					</span>
					<a href="/?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$r.event_round_id}" title="Edit Round">{if $r.event_round_score_status==0}<del><font color="red">{/if}Round {$r.event_round_number|escape}{if $r.event_round_score_status==0}</del></font>{/if}</a>
					</div>
				</th>
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{foreach $t.pilots as $e}
		{$event_pilot_id=$e.event_pilot_id}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank}</td>
			<td align="right" nowrap>
				<a href="?action=event&function=event_pilot_rounds&event_pilot_id={$e.event_pilot_id}&event_id={$event->info.event_id}">{$e.pilot_first_name|escape} {$e.pilot_last_name|escape}</a>
				{if $e.country_code}<img src="/images/flags/countries-iso/shiny/16/{$e.country_code|escape}.png" style="vertical-align: middle;" title="{$e.country_name}">{/if}
				{if $e.state_name && $e.country_code=="US"}<img src="/images/flags/states/16/{$e.state_name|escape}-Flag-16.png" style="vertical-align: middle;" title="{$e.state_name}">{/if}
			</td>
			{foreach $e.rounds as $r}
				{if $r@iteration <=9}
				<td class="info" align="center"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
					<div style="position:relative;">
					{$dropval=0}
					{$dropped=0}
					{foreach $r.flights as $f}
						{if $f.event_pilot_round_flight_dropped}
							{$dropval=$dropval+$f.event_pilot_round_total_score}
							{$dropped=1}
						{/if}
					{/foreach}
					{$drop=0}
					{if $dropped==1 && $dropval==$r.event_pilot_round_total_score}{$drop=1}{/if}
					{if $drop==1}<del><font color="red">{/if}
						{if $r.event_pilot_round_total_score==1000}
							1000
						{else}
							{$r.event_pilot_round_total_score|string_format:"%06.3f"}
						{/if}
					{if $drop==1}</font></del>{/if}
					{* lets determine the content to show on popup *}
						<span>
							{$event_round_number=$r@key}
							{foreach $event->rounds.$event_round_number.flights as $f}
								{if $f.flight_type_code|strstr:'duration' || $f.flight_type_code|strstr:'f3k'}
									{if $f.flight_type_code=='f3b_duration'}A - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_minutes|escape}:{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}{if $f.flight_type_landing} - {$f.pilots.$event_pilot_id.event_pilot_round_flight_landing|escape}{/if}<br>
								{/if}
								{if $f.flight_type_code|strstr:'distance'}
									{if $f.flight_type_code=='f3b_distance'}B - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_laps|escape} Laps<br>
								{/if}
								{if $f.flight_type_code|strstr:'speed'}
									{if $f.flight_type_code=='f3b_speed'}C - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}s
								{/if}
							{/foreach}
						</span>
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td width="5%" nowrap align="right">{$e.subtotal|string_format:"%06.3f"}</td>
			<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:"%06.3f"}{/if}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap align="right">{$e.total|string_format:"%06.3f"}</td>
			<td width="5%" nowrap align="right">{$e.event_pilot_total_percentage|string_format:"%03.2f"}%</td>
		</tr>
		{/foreach}
		{if $event->info.event_type_code=='f3f'}
		<tr>
			<th colspan="2" align="right">Round Fast Time</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=$flyoff_number}
					{continue}
				{/if}
				{$fast=1000}
				{$fast_id=0}
				{foreach $r.flights as $f}
					{foreach $f.pilots as $p}
						{if $p.event_pilot_round_flight_seconds<$fast && $p.event_pilot_round_flight_seconds!=0}
							{$fast=$p.event_pilot_round_flight_seconds}
							{$fast_id=$p.event_pilot_id}
						{/if}
					{/foreach}
				{/foreach}
				{if $fast==1000}{$fast=0}{/if}
				<th class="info" align="center">
					<div style="position:relative;">
					{$fast}s
					<span>
						Fast Time : {$fast}s<br>
						{$event->pilots.$fast_id.pilot_first_name|escape} {$event->pilots.$fast_id.pilot_last_name|escape}
					</span>
					</div>
				</th>
			{/foreach}
		</tr>
		{/if}
		</table>
		{if !$t@last}
		<br style="page-break-after: always;">
		{/if}
		{/foreach}
		<!--# End of flyoff rounds -->



<br>
<input type="button" value=" Back To Event List " onClick="goback.submit();" class="block-button">
<input type="button" value=" Print Overall Classification " onClick="print_overall.submit();" class="block-button">
<input id="printround" type="button" value=" Print Round Detail " onClick="$('#print_round').dialog('open');" class="block-button">
<input type="button" value=" View Position Chart " onClick="chart.submit();" class="block-button">
{if $user.user_id!=0 && $user.user_id==$event->info.user_id || $user.user_admin==1}
<input type="button" value=" Delete Event " onClick="confirm('Are you sure you wish to delete this event?') && event_delete.submit();" class="block-button" style="float:none;margin-right:auto;">
{/if}
	</div>
</div>

{if $event->classes|count > 1 || $event->totals.teams || $duration_rank || $speed_rank}
<h1 class="post-title">Contest Ranking Reports
<input type="button" value=" Print Event Rankings " onClick="print_rank.submit();" class="block-button">
</h1>
<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;">
	{if $event->classes|count > 1}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h1 class="post-title">Class Rankings</h1>
		<table cellpadding="2" cellspacing="1" class="tableborder">
			{foreach $event->classes as $c}
			{$rank=1}
					<tr>
						<th colspan="3" nowrap>{$c.class_description|escape} Rankings</th>
					</tr>
					<tr>
						<th></th>
						<th>Pilot</th>
						<th>Total</th>
					</tr>
					{foreach $event->totals.pilots as $p}
					{$event_pilot_id=$p.event_pilot_id}
					{if $event->pilots.$event_pilot_id.class_id==$c.class_id}
					<tr style="background-color: {cycle values="#9DCFF0,white"};">
						<td>{$rank}</td>
						<td nowrap>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
						<td>{$p.total|string_format:"%06.3f"}</td>
					</tr>
					{$rank=$rank+1}
					{/if}
					{/foreach}
			{/foreach}
		</tr>
		</table>
	</div>
	{/if}
	{if $event->totals.teams}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h1 class="post-title">Team Rankings</h1>
		<table cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Team</th>
			<th>Total</th>
		</tr>
		{foreach $event->totals.teams as $t}
		<tr style="background-color:#9DCFF0;">
			<td>{$t.rank}</td>
			<td nowrap>{$t.team_name|escape}</td>
			<td>{$t.total|string_format:"%06.3f"}</td>
		</tr>
			{foreach $event->totals.pilots as $p}
			{$event_pilot_id=$p.event_pilot_id}
			{if $event->pilots.$event_pilot_id.event_pilot_team==$t.team_name}
			<tr>
				<td></td>
				<td>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
				<td align="right">{$p.total|string_format:"%06.3f"}</td>
			</tr>
			{/if}
			{/foreach}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $duration_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Duration Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{foreach $duration_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:"%06.3f"}</td>
			</tr>
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Distance Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{foreach $distance_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:"%06.3f"}</td>
			</tr>
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $speed_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Speed Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{foreach $speed_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:"%06.3f"}</td>
			</tr>
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
</div>
{/if}

<!-- Lets figure out if there are reports for speed or laps -->
{if $lap_totals || $speed_averages || $top_landing}
<h1 class="post-title">Statistics Reports
<input type="button" value=" Print Event Statistics " onClick="print_stats.submit();" class="block-button">
</h1>
<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;">
	{if $lap_totals}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Total Distance Laps</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
		</tr>
		{foreach $lap_totals as $p}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$p.event_pilot_lap_rank|escape}</td>
				<td nowrap>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_total_laps|escape}</td>
			</tr>
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_laps}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Top 20 Distance Runs</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
		</tr>
		{$rank=1}
		{foreach $distance_laps as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_round_flight_laps|escape}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $speed_averages}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Average Speeds</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{foreach $speed_averages as $p}
			{if $p.event_pilot_average_speed_rank!=0}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$p.event_pilot_average_speed_rank}</td>
				<td nowrap>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
				<td>{$p.event_pilot_average_speed|string_format:"%06.3f"}</td>
			</tr>
			{/if}
		{/foreach}
		</table>
	</div>
	
		<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Top 20 Speed Runs</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Speed</th>
			<th>Round</th>
		</tr>
		{$rank=1}
		{foreach $speed_times as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td>{$p.event_pilot_round_flight_seconds|string_format:"%06.3f"}</td>
				<td align="center">{$p.event_round_number|escape}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $top_landing}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Landing Averages</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{$rank=1}
		{foreach $top_landing as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td>{$p.average_landing|string_format:"%02.2f"}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
</div>
{/if}

<div id="print_round" style="overflow: hidden;">
		<form name="printround" method="POST" target="_blank">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_print_round">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="use_print_header" value="1">
		<div style="float: left;padding-right: 10px;">
			Print Round From :
			<select name="round_start_number">
			{foreach $event->rounds as $r}
			<option value="{$r.event_round_number}">{$r.event_round_number}</option>
			{/foreach}
			</select>
			To 
			<select name="round_end_number">
			{foreach $event->rounds as $r}
			<option value="{$r.event_round_number}">{$r.event_round_number}</option>
			{/foreach}
			</select><br>
			<br>
			Print One Round Per Page <input type="checkbox" name="oneper" CHECKED>
		</div>
		<br style="clear:both" />
		</form>
</div>

<script>
	document.getElementById('pilot_name').focus();
</script>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>
<form name="event_edit" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_draw" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_delete" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_delete">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_pilot_add" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_pilot_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_pilot_id" value="0">
<input type="hidden" name="pilot_id" value="">
<input type="hidden" name="pilot_name" value="">
</form>
<form name="event_add_round" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_round_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_round_id" value="0">
<input type="hidden" name="zero_round" value="0">
<input type="hidden" name="flyoff_round" value="0">
</form>
<form name="print_overall" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_overall">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="use_print_header" value="1">
</form>
<form name="chart" method="GET" action="?">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_chart">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="print_stats" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_stats">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="use_print_header" value="1">
</form>
<form name="print_rank" method="GET" action="?" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_rank">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="use_print_header" value="1">
</form>
{if $event->rounds}
<script>
	 document.getElementById('pilots').style.display = 'none';
	 document.getElementById('viewtoggle').innerHTML = '(<u>Show Pilot List</u>)';
</script>
{/if}