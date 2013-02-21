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
		source: "/f3x/?action=lookup&function=lookup_pilot",
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
			document.add_pilot.pilot_id.value = ui.item.id;
			var name=document.getElementById('pilot_name');
			document.add_pilot.pilot_name.value=name.value;
			add_pilot.submit();
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
   			if(id.value==''){
				document.add_pilot.pilot_id.value = 0;
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
</script>
{/literal}

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Settings - {$event.event_name} <input type="button" value=" Edit Event Parameters " onClick="document.edit_event.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event.event_start_date|date_format:"%Y-%m-%d"} to {$event.event_end_date|date_format:"%Y-%m-%d"}
			</td>
		</tr>
		<tr>
			<th align="right">Location</th>
			<td>
			{$event.location_name} - {$event.location_city},{$event.state_code} {$event.country_code}
			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			{$event.event_type_name}
			</td>
		</tr>
		<tr>
			<th align="right">Event Contest Director</th>
			<td>
			{$event.pilot_first_name} {$event.pilot_last_name} - {$event.pilot_city}
			</td>
		</tr>
		</table>
		
	</div>
		<br>
		<h1 class="post-title entry-title">Event Pilots {if $event.pilots}({$event.pilots|count}){/if}</h1>
		<input type="button" value=" Add Pilot " onclick="var name=document.getElementById('pilot_name');document.add_pilot.pilot_name.value=name.value;add_pilot.submit();">
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
		{foreach $event.pilots as $p}
		<tr>
			<td>{$num}</td>
			<td align="center">{$p.pilot_ama}</td>
			<td>{$p.pilot_first_name} {$p.pilot_last_name}</td>
			<td>{$p.class_description}</td>
			<td>{$p.plane_name}</td>
			<td>{$p.event_pilot_freq}</td>
			<td>{$p.event_pilot_team}</td>
			<td nowrap>
				<a href="/f3x/?action=event&function=event_pilot_edit&event_id={$event.event_id}&event_pilot_id={$p.event_pilot_id}" title="Edit Event Pilot"><img width="16" src="/f3x/images/icon_edit_small.gif"></a>
				<a href="/f3x/?action=event&function=event_pilot_remove&event_id={$event.event_id}&event_pilot_id={$p.event_pilot_id}" title="Remove Event Pilot" onClick="return confirm('Are you sure you want to remove {$p.pilot_first_name} from the event?');"><img width="14px" src="/f3x/images/del.gif"></a>
			</td>
		</tr>
		{assign var=num value=$num+1}
		{/foreach}
		</table>
		
		<br>
		<h1 class="post-title entry-title">Event Rounds {if $event.rounds}({$event.rounds|count}) {/if} Overall Classification
			<input type="button" value=" Add Round " onClick="document.add_round.submit();" class="block-button">
		</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{$event.rounds|count}" align="center" nowrap>Completed Rounds</th>
			<th></th>
			<th width="5%" nowrap>SubTotal</th>
			<th width="5%" nowrap>Penalties</th>
			<th width="5%" nowrap>Total Score</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event.rounds as $r}
				<th width="5%" align="center" nowrap><a href="/f3x/?action=event&function=event_round_edit&event_id={$event.event_id}&event_round_id={$r.event_round_id}" title="Edit Round">Round {$r.event_round_number}</a></th>
			{/foreach}
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		{foreach $event.totals as $e}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank}</td>
			<td align="right" nowrap>{$e.pilot_first_name} {$e.pilot_last_name}</td>
			{foreach $e.rounds as $r}
				<td align="right">
					{$r}
				</td>
			{/foreach}
			<td></td>
			<td width="5%" nowrap>{$e.subtotal}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties}{/if}</td>
			<td width="5%" nowrap>{$e.total}</td>
		</tr>
		{/foreach}
		</table>

<br>
<input type="button" value=" Back To Event List " onClick="goback.submit();" class="block-button" style="float: none;margin-left: auto;margin-right: auto;">
</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>
<form name="edit_event" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event.event_id}">
</form>
<form name="add_pilot" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="add_pilot">
<input type="hidden" name="event_id" value="{$event.event_id}">
<input type="hidden" name="pilot_id" value="">
<input type="hidden" name="pilot_name" value="">
</form>
<form name="add_round" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_round_edit">
<input type="hidden" name="event_id" value="{$event.event_id}">
<input type="hidden" name="event_round_id" value="0">
</form>
