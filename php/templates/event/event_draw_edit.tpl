{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Draw {if $event_draw_id==0}Create{else}Edit{/if}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event Draws " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">


		{$highlight_color="yellow"}
			
		<form name="main" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_draw_save">
		<input type="hidden" name="event_draw_id" value="{$event_draw_id}">
		<input type="hidden" name="event_id" value="{$event_id}">
		<input type="hidden" name="flight_type_id" value="{$ft.flight_type_id}">
		<input type="hidden" name="event_draw_changed" value="0">
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
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
		<tr>
			<th nowrap>Group Naming</th>
			<td>
				<input type="radio" name="event_draw_group_name" value="alpha"{if $draw->draw.event_draw_group_name == 'alpha' || $draw->draw.event_draw_group_name == NULL} CHECKED{/if}> Use Alpha characters for groups ( A,B,C, etc... )<br>
				<input type="radio" name="event_draw_group_name" value="numeric"{if $draw->draw.event_draw_group_name == 'numeric'} CHECKED{/if}> Use Numeric characters for groups ( 1,2,3, etc... )
			</td>
		</tr>
		{if $event->teams|count > 0}
		<tr>
			<th nowrap>Team Protection</th>
			<td>
				<input type="checkbox" id="event_draw_team_protection" name="event_draw_team_protection"{if $draw->draw.event_draw_team_protection==1 || $event_draw_id==0} CHECKED{/if} onChange="set_changed();check_protection();calc_groups();"> This will make it so that team pilots will NOT be matched up against each other in the same group.
			</td>
		</tr>
		{/if}
		<tr>
			<th nowrap valign="top">Desired Number of Flight Groups</th>
			<td>
				There are currently <b>{$draw_pilots|count}</b> Active Pilots in this event{if $draw_teams|count > 0} on {$draw_teams|count} teams{/if}.<br>
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
				<input type="checkbox" name="event_draw_team_separation"{if $draw->draw.event_draw_team_separation==1} CHECKED{/if} onChange="set_changed();"> This will make sure team pilots are separated by the lowest team size for clear separation.
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
		<tr>
			<td colspan="2" style="text-align: center;">
				<input type="button" value=" {if $event_draw_id==0}Create{else}Save{/if} Draw " class="btn btn-primary btn-rounded" onClick="if(changed==1 && document.main.event_draw_id.value!=0){ldelim}confirm('You have changed the draw values. Are you sure you wish to save the draw?') && document.main.submit();{rdelim}else{ldelim}document.main.submit();{rdelim}">
			</td>
		</tr>
		</table>
		</form>
		
		{if $draw->rounds}
		<h2 class="post-title entry-title">Draw Manual Edit (Rounds {$draw->draw.event_draw_round_from} - {$draw->draw.event_draw_round_to})</h2>
		
		{if $event->teams|count >0}
		<form name="mainhl">
		Team Highlight :
		<select name="highlight" onChange="document.hl.highlight.value=document.mainhl.highlight.value;document.hl.submit();">
		<option value="">None</option>
		{foreach $event->teams as $t}
		<option value="{$t.event_pilot_team}"{if $highlight==$t.event_pilot_team} SELECTED{/if}>{$t.event_pilot_team}</option>
		{/foreach}
		</select>
		</form>
		{/if}
		
		<form name="draw_edit" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_draw_manual_save">
		<input type="hidden" name="event_draw_id" value="{$event_draw_id}">
		<input type="hidden" name="event_id" value="{$event_id}">

		<table cellspacing="2">
		<tr>
			{foreach $event->rounds as $r}
			{$round_number = $r.event_round_number}
			{$flight_type_id = $r.flight_type_id}
			{$bgcolor=''}
			{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' ||
				$event->flight_types.$flight_type_id.flight_type_code=='td_duration' ||
				$event->flight_types.$flight_type_id.flight_type_code=='f3b_distance' ||
				$event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'}
				{$size=3}
			{else}
				{$size=2}
			{/if}
			
			<td>
				<table cellpadding="1" cellspacing="1" style="border: 1px solid black;font-size:12;">
				<tr bgcolor="lightgray">
					<td colspan="{$size}"><strong>Round {$r.event_round_number}</strong></td>
				</tr>
				{if $event->info.event_type_code=='f3k'}
					{$ftid=$r.flight_type_id}
					<tr bgcolor="white">
						<td colspan="2">{$event->flight_types.$ftid.flight_type_name_short}</td>
					</tr>
				{/if}
				{if $event->info.event_type_code=='f3j'}
					{$ftid=$r.flight_type_id}
					<tr bgcolor="white">
						<td colspan="3">{$event->flight_types.$ftid.flight_type_name_short} {$event->tasks.$round_number.event_task_time_choice} min</td>
					</tr>
				{/if}
				<tr bgcolor="lightgray">
					{if $event->flight_types.$flight_type_id.flight_type_group}
						<td width="30">Group</td>
					{else}
						<td>&nbsp;#&nbsp;</td>
					{/if}
					<td>Pilot</td>
					{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' 
						|| $event->flight_types.$flight_type_id.flight_type_code=='td_duration'}
						<td>Spot</td>
					{elseif $event->flight_types.$flight_type_id.flight_type_code=='f3b_distance'
						|| $event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'}
						<td>Lane</td>
					{/if}
					
				</tr>
				{$oldgroup='1000'}
				{$bottom=0}
				{foreach $r.flights.$flight_type_id.pilots as $p}
					{$event_pilot_id=$p@key}
					{if $oldgroup!=$p.event_pilot_round_flight_group}
						{if $r.flights.$flight_type_id.flight_type_code=='f3b_speed' || $r.flights.$flight_type_id.flight_type_code=='f3f_speed'}
							{$bgcolor="white"}
						{else}
							{if $bgcolor=='white'}
								{$bgcolor='lightgray'}
							{else}
								{$bgcolor='white'}
							{/if}
							{$bottom=1}
						{/if}
					{/if}
					{if $event->pilots.$event_pilot_id.event_pilot_team==$highlight}
						{$highlighted=1}
					{else}
						{$highlighted=0}
					{/if}
					<tr>
						{if $event->flight_types.$flight_type_id.flight_type_group}
							<td align="center" bgcolor="{if $highlighted}{$highlight_color}{else}{$bgcolor}{/if}" {if $bottom}style="border-top: 2px solid black;"{/if}>
								<input type="text" size="1" name="draw_group_{$r.event_round_number}_{$event_pilot_id}" value="{$p.event_pilot_round_flight_group}">
							</td>
						{else}
							<td align="center" bgcolor="{if $highlighted}{$highlight_color}{else}{$bgcolor}{/if}" {if $bottom}style="border-top: 2px solid black;"{/if}>
								<input type="text" size="1" name="draw_order_{$r.event_round_number}_{$event_pilot_id}" value="{$p.event_pilot_round_flight_order}">
							</td>
						{/if}
						<td align="left" nowrap bgcolor="{if $highlighted}{$highlight_color}{else}{$bgcolor}{/if}" {if $bottom}style="border-top: 2px solid black;"{/if}>
							{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
								<div class="pilot_bib_number_print">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
								&nbsp;
							{/if}
							{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}
						</td>
					{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' 
						|| $event->flight_types.$flight_type_id.flight_type_code=='td_duration'
						|| $event->flight_types.$flight_type_id.flight_type_code=='f3b_distance'
						|| $event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'}
						<td align="center" bgcolor="{if $highlighted}{$highlight_color}{else}{$bgcolor}{/if}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$p.event_pilot_round_flight_lane}</td>
					{/if}
					</tr>
					{$oldgroup=$p.event_pilot_round_flight_group}
					{$bottom=0}
				{/foreach}
				</table>
			</td>
			{$total_rounds_shown=$total_rounds_shown+1}
			{if $r@iteration is div by 4}
				</tr>
				<tr>
			{/if}
			{/foreach}
			</tr>
			</table>
			<div style="text-align: center;">
				<input type="button" value=" Save Draw Edits " class="btn btn-primary btn-rounded" onClick="confirm('Are you sure you wish to save these draw edits?') && document.draw_edit.submit();">
			</div>
		</form>
		<br>
		{/if}

		<form name="hl" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_draw_edit">
		<input type="hidden" name="event_id" value="{$event_id}">
		<input type="hidden" name="event_draw_id" value="{$event_draw_id}">
		<input type="hidden" name="flight_type_id" value="{$ft.flight_type_id}">
		<input type="hidden" name="highlight" value="">
		</form>

		<form name="goback" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_draw">
		<input type="hidden" name="event_id" value="{$event_id}">
		</form>
	</div>
</div>
{/block}
{block name="footer"}
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
			//	document.getElementById("radio_recalc").checked=true;
			{rdelim}
		{else}
			var original_separation={$draw->draw.event_draw_team_separation};
			if(original_separation==1 && document.main.event_draw_team_separation.checked==false){ldelim}
			//	document.getElementById("radio_recalc").checked=true;
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
	var num_pilots={$draw_pilots|count};
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
<script>
	setTimeout(function(){ldelim}
		{if $event->teams|count > 0}
		check_protection();
		{/if}
		calc_groups();
	{rdelim});
</script>
{/block}
