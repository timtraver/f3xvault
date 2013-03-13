<script src="/f3x/includes/jquery.min.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#pilot_name").autocomplete({
		source: "/f3x/lookup.php?function=lookup_pilot",
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
});
function toggle(element,tog) {
	 if (document.getElementById(element).style.display == 'none') {
	 	document.getElementById(element).style.display = 'block';
	 	tog.innerHTML = '(<u>hide pilots</u>)';
	 } else {
		 document.getElementById(element).style.display = 'none';
		 tog.innerHTML = '(<u>show pilots</u>)';
	 }
}
</script>
{/literal}

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Settings - {$event->info.event_name} <input type="button" value=" Edit Event Parameters " onClick="document.event_edit.submit();" class="block-button">
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
		<h1 class="post-title entry-title">Event Pilots {if $event->pilots}({$event->pilots|count}){/if} <span id="viewtoggle" onClick="toggle('pilots',this);">(<u>hide pilots</u>)</span></h1>
		<span id="pilots">
		<input type="button" value=" Add Pilot " onclick="var name=document.getElementById('pilot_name');document.event_pilot_add.pilot_name.value=name.value;event_pilot_add.submit();">
		<input type="text" id="pilot_name" name="pilot_name" size="40">
		    <img id="loading" src="/f3x/images/loading.gif" style="vertical-align: middle;display: none;">
		    <span id="search_message" style="font-style: italic;color: grey;"> Start typing to search pilots</span>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="center">AMA#</th>
			<th align="left">Pilot Name</th>
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
			<td align="center">{$p.pilot_ama}</td>
			<td>{$p.pilot_first_name} {$p.pilot_last_name}</td>
			<td>{$p.class_description}</td>
			<td>{$p.plane_name}</td>
			<td>{$p.event_pilot_freq}</td>
			<td>{$p.event_pilot_team}</td>
			<td nowrap>
				<a href="/f3x/?action=event&function=event_pilot_edit&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Edit Event Pilot"><img width="16" src="/f3x/images/icon_edit_small.gif"></a>
				<a href="/f3x/?action=event&function=event_pilot_remove&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Remove Event Pilot" onClick="return confirm('Are you sure you want to remove {$p.pilot_first_name} from the event?');"><img width="14px" src="/f3x/images/del.gif"></a>
			</td>
		</tr>
		{assign var=num value=$num+1}
		{/foreach}
		</table>
		</span>




		<br>
		<h1 class="post-title entry-title">Event Rounds {if $event->rounds}({$event->rounds|count}) {/if} Overall Classification
			<input type="button" value=" Add Zero Round " onClick="document.event_add_round.zero_round.value=1; document.event_add_round.submit();" class="block-button">
			<input type="button" value=" Add Round " onClick="document.event_add_round.submit();" class="block-button">
		</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<td width="2%" align="left"></td>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{if $event->rounds|count > 10}10{else}{$event->rounds|count}{/if}" align="center" nowrap>Completed Rounds ({if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drops In Effect)</th>
			<th></th>
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Penalties</th>
			<th width="5%" nowrap>Total Score</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r@iteration <=10}
				<th width="5%" align="center" nowrap><a href="/f3x/?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$r.event_round_id}" title="Edit Round">Round {$r.event_round_number}</a></th>
				{/if}
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{foreach $event->totals.pilots as $e}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank}</td>
			<td align="right" nowrap><a href="?action=event&function=event_pilot_rounds&event_pilot_id={$e.event_pilot_id}&event_id={$event->info.event_id}">{$e.pilot_first_name} {$e.pilot_last_name}</a></td>
			{foreach $e.rounds as $r}
				{if $r@iteration <=10}
				<td align="right"{if $r.event_pilot_round_rank==1} style="border-width: 3px;border-color: green;color:green;font-weight:bold;"{/if}>
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
						{$r.event_pilot_round_total_score|string_format:"%06.3f"}
					{if $drop==1}</font></del>{/if}
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td width="5%" nowrap>{$e.subtotal|string_format:"%06.3f"}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap>{$e.total|string_format:"%06.3f"}</td>
		</tr>
		{/foreach}
		</table>




		{if $event->rounds|count >10}
		<br>
		<h3 class="post-title entry-title">Event Rounds Continued</h3>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<td width="2%" align="left"></td>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{$event->rounds|count - 10}" align="center" nowrap>Completed Rounds</th>
			<th></th>
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Penalties</th>
			<th width="5%" nowrap>Total Score</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r@iteration >10}
				<th width="5%" align="center" nowrap><a href="/f3x/?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$r.event_round_id}" title="Edit Round">Round {$r.event_round_number}</a></th>
				{/if}
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{foreach $event->totals.pilots as $e}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank}</td>
			<td align="right" nowrap>{$e.pilot_first_name} {$e.pilot_last_name}</td>
			{foreach $e.rounds as $r}
				{if $r@iteration >10}
				<td align="right"{if $r.event_pilot_round_rank==1} style="border-width: 3px;border-color: green;color:green;font-weight:bold;"{/if}>
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
						{$r.event_pilot_round_total_score}
					{if $drop==1}</font></del>{/if}
				</td>
				{/if}
			{/foreach}
			<td></td>
			<td width="5%" nowrap>{$e.subtotal}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap>{$e.total}</td>
		</tr>
		{/foreach}
		</table>
		{/if}


<br>
<input type="button" value=" Back To Event List " onClick="goback.submit();" class="block-button" style="float: none;margin-left: auto;margin-right: auto;">
</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>
<form name="event_edit" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
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
</form>
{if $event->rounds}
<script>
	 document.getElementById('pilots').style.display = 'none';
	 document.getElementById('viewtoggle').innerHTML = '(<u>show pilots</u>)';
</script>
{/if}