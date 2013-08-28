<script>
var changed=0;
function set_changed(){ldelim}
	changed=1;
	document.main.event_draw_changed.value=1;
	check_changed();
{rdelim}
function check_changed(){ldelim}
	{if $event_draw_id!=0}
		{if $ft.flight_type_group==1}
			{if $event->teams|count > 0}
				var original_protect={$draw->draw.event_draw_team_protection};
			{/if}
			var original_groups={$draw->draw.event_draw_number_groups};
			if({if $event->teams|count > 0}(original_protect==1 && document.main.event_draw_team_protection.checked==false)
				|| (original_protect==0 && document.main.event_draw_team_protection.checked==true)
				|| {/if}(original_groups!=document.main.event_draw_number_groups.value)
			){ldelim}
				document.getElementById("radio_recalc").checked=true;
			{rdelim}
		{else}
			var original_separation={$draw->draw.event_draw_team_separation};
			if(original_separation==1 && document.main.event_draw_team_separation.checked==false){ldelim}
				document.getElementById("radio_recalc").checked=true;
			{rdelim}
		{/if}
	{/if}
{rdelim}
function check_draw_step(){ldelim}
	if(document.main.event_draw_type.value=="random_step"){ldelim}
		document.getElementById("draw_step").style.display="block";
	{rdelim}else{ldelim}
		document.getElementById("draw_step").style.display="none";
	{rdelim}
{rdelim}
function check_protection(){ldelim}
	if(document.main.event_draw_team_protection.checked==true){ldelim}
		document.getElementById("no_protection").style.display="none";
		document.getElementById("with_protection").style.display="block";
	{rdelim}else{ldelim}
		document.getElementById("no_protection").style.display="block";
		document.getElementById("with_protection").style.display="none";
	{rdelim}
{rdelim}
function calc_groups(){ldelim}
	if(document.getElementById("event_draw_team_protection")){ldelim}
		if(document.getElementById("event_draw_team_protection").checked==true){ldelim}
			var num_groups=parseInt(document.getElementById("groups_p").value);
		{rdelim}else{ldelim}
			var num_groups=parseInt(document.getElementById("groups_np").value);
		{rdelim}
	{rdelim}else{ldelim}
		var num_groups=parseInt(document.getElementById("groups_np").value);
	{rdelim}
	document.getElementById("event_draw_number_groups").value=num_groups;
	var num_pilots={$event->pilots|count};
	var per_group=Math.floor(num_pilots/num_groups);
	var left_over=num_pilots%num_groups;
	if(left_over==0){ldelim}
		document.getElementById("per_group").innerHTML=num_groups + " groups of " + per_group;
	{rdelim}else{ldelim}
		var left_over_string=' groups of ';
		var num_groups_string=' groups of ';
		if(left_over==1){ldelim}
			left_over_string=' group of ';
		{rdelim}
		if((num_groups-left_over)==1){ldelim}
			num_groups_string=' group of ';
		{rdelim}
		if(left_over > (num_groups-left_over)){ldelim}
			document.getElementById("per_group").innerHTML=left_over + left_over_string + (per_group+1) + ", and <br>" + (num_groups-left_over) + num_groups_string + per_group;
		{rdelim}else{ldelim}
			document.getElementById("per_group").innerHTML=(num_groups-left_over) + num_groups_string + per_group + ", and <br>" + left_over + left_over_string + (per_group+1);
		{rdelim}
	{rdelim}

{rdelim}
</script>

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                	
	<br>
<h1 class="post-title entry-title">Draw {if $event_draw_id==0}Create{else}Edit{/if}
		<input type="button" value=" Back To Event Draws " onClick="goback.submit();" class="block-button">
</h1>
	
<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw_save">
<input type="hidden" name="event_draw_id" value="{$event_draw_id}">
<input type="hidden" name="event_id" value="{$event_id}">
<input type="hidden" name="flight_type_id" value="{$ft.flight_type_id}">
<input type="hidden" name="event_draw_changed" value="0">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%" nowrap>Draw Flight Type</th>
	<td>
		{if $event->info.event_type_code=='f3k'}
			F3K
		{else}
			{$ft.flight_type_name}
		{/if}
	</td>
</tr>
<tr>
	<th width="10%" nowrap>Round Start</th>
	<td>
		<input type="text" name="event_draw_round_from" size="2" value="{$draw->draw.event_draw_round_from}" onChange="set_changed();" autocomplete="off">
	</td>
</tr>
<tr>
	<th width="10%" nowrap>Round Finish</th>
	<td>
		<input type="text" name="event_draw_round_to" size="2" value="{$draw->draw.event_draw_round_to}" onChange="set_changed();" autocomplete="off">
	</td>
</tr>
<tr>
	<th nowrap>Draw Type</th>
	<td>
	<select name="event_draw_type" onChange="check_draw_step();set_changed();">
	{if $ft.flight_type_group==1}
		<option value="group" {if $draw->event_draw_type=="group"}SELECTED{/if}>Standard Random Group Draw with Frequency Weighting</option>
	{else}
		<option value="random" {if $draw->event_draw_type=="random"}SELECTED{/if}>Random Order Draw Every Round</option>
		<option value="random_step" {if $draw->event_draw_type=="random_step"}SELECTED{/if}>Random Order First Round With Stepped Progression</option>
	{/if}
	</select>
	{if $ft.flight_type_group!=1}
		<span id="draw_step" style="{if $draw->draw.event_draw_type=="random_step"}display:block;{else}display:none;{/if}">
			Step Size <input type="text" name="event_draw_step_size" size="2" value="{$draw->draw.event_draw_step_size}" onChange="set_changed();">  This is the number of pilots to skip every round.
		</span>
	{/if}
	</td>
</tr>
{if $ft.flight_type_group==1}
{if $event->teams|count > 0}
<tr>
	<th nowrap>Team Protection</th>
	<td>
		<input type="checkbox" id="event_draw_team_protection" name="event_draw_team_protection"{if $draw->draw.event_draw_team_protection==1 || $event_draw_id==0} CHECKED{/if} onChange="set_changed();check_protection();calc_groups();"> This will make it so that team pilots will NOT be matched up against each other.
	</td>
</tr>
{/if}
<tr>
	<th nowrap valign="top">Desired Number of Flight Groups</th>
	<td>
		There are currently <b>{$event->pilots|count}</b> Pilots in this event{if $event->teams|count > 0} on {$event->teams|count} teams{/if}.<br>
		<span id="no_protection">
			Using  
			<select id="groups_np" name="groups" onChange="calc_groups();set_changed();">
			{for $x=$min_groups_np;$x<=$max_groups_np;$x++}
			<option value="{$x}"{if $draw->draw.event_draw_number_groups==$x} SELECTED{/if}>{$x}</option>
			{/for}
			</select>
			Flight Groups{if $event->teams|count > 0} with No Team Protection{/if} will result in<br>
		</span>
		<span id="with_protection" style="display:none;">
			Using  
			<select id="groups_p" name="groups" onChange="calc_groups();set_changed();">
			{for $x=$min_groups_p;$x<=$max_groups_p;$x++}
			<option value="{$x}"{if $draw->draw.event_draw_number_groups==$x} SELECTED{/if}>{$x}</option>
			{/for}
			</select>
			Flight Groups{if $event->teams|count > 0} with Team Protection{/if} will result in<br>
		</span>
		<br><p style="padding-left: 20px;"><span id="per_group"></span></p>
		<input type="hidden" id="event_draw_number_groups" name="event_draw_number_groups" value="">
	</td>
</tr>

{else}
<tr>
	<th nowrap>Team Separation</th>
	<td>
		<input type="checkbox" name="event_draw_team_separation"{if $draw->draw.event_draw_team_separation==1} CHECKED{/if} onChange="set_changed();"> This will make sure team pilots are separated by at least one pilot.
	</td>
</tr>
{/if}
{if $event_draw_id!=0}
<tr>
	<th nowrap>Save Parameters</th>
	<td>
		<input type="radio" id="radio_grow" name="recalc" value="grow" onChange="set_changed();" CHECKED> Grow or shrink rounds keeping existing rounds intact<br>
		<input type="radio" id="radio_recalc" name="recalc" value="recalc" onChange="set_changed();"> Recalculate draw with new draw values
	</td>
</tr>
{else}
<input type="hidden" name="recalc" value="recalc">
{/if}
{if $event_draw_id!=0 && $event->info.event_type_code=='f3k'}
<tr>
	<th nowrap>F3K Draw Round Flight Types</th>
	<td>
		<table>
		<tr>
			<th>Round</th><th>F3K Flight Type</th>
		</tr>
		{foreach $draw->rounds as $r}
			{$round_number=$r@key}
			<tr>
				<th>{$round_number}</th>
				<td>
					<select name="round_flight_type_{$round_number}">
					<option value="0">Choose a flight type</option>
					{foreach $event->flight_types as $ft}
						<option value="{$ft.flight_type_id}"{if $ft.flight_type_id==$draw->round_flight_types.$round_number.flight_type_id} SELECTED{/if}>{$ft.flight_type_name}</option>
					{/foreach}
					</select>
				</td>
			</tr>
		{/foreach}
		</table>
	</td>
</tr>
{/if}
<tr>
	<td colspan="2">
		<input type="button" value=" {if $event_draw_id==0}Create{else}Save{/if} Draw " class="block-button" onClick="if(changed==1 && document.main.event_draw_id.value!=0){ldelim}confirm('You have changed the draw values. Are you sure you wish to save the draw?') && document.main.submit();{rdelim}else{ldelim}document.main.submit();{rdelim}">
	</td>
</tr>
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw">
<input type="hidden" name="event_id" value="{$event_id}">
</form>
<script>
{if $event->teams|count > 0}
check_protection();
{/if}
calc_groups();
</script>
</div>
</div>

