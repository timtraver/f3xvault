<script>
var changed=0;
function set_changed(){ldelim}
	changed=1;
	document.main.event_draw_changed.value=1;
{rdelim}
function check_draw_step(){ldelim}
	if(document.main.event_draw_type.value=="random_step"){ldelim}
		document.getElementById("draw_step").style.display="block";
	{rdelim}else{ldelim}
		document.getElementById("draw_step").style.display="none";
	{rdelim}
{rdelim}
</script>

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                	
	<br>
	<h2 style="color:red;">Under Construction...</h2>
<h1 class="post-title entry-title">Draw Create
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
		{$ft.flight_type_name}
	</td>
</tr>
<tr>
	<th width="10%" nowrap>Round Start</th>
	<td>
		<input type="text" name="event_draw_round_from" size="2" value="{$draw.event_draw_round_from}" onChange="set_changed();">
	</td>
</tr>
<tr>
	<th width="10%" nowrap>Round Finish</th>
	<td>
		<input type="text" name="event_draw_round_to" size="2" value="{$draw.event_draw_round_to}" onChange="set_changed();">
	</td>
</tr>
<tr>
	<th nowrap>Draw Type</th>
	<td>
	<select name="event_draw_type" onChange="set_changed();check_draw_step();">
	{if $ft.flight_type_group==1}
		<option value="group" {if $draw.event_draw_type=="group"}SELECTED{/if}>Standard Modified Random Group Draw</option>
	{else}
		<option value="random" {if $draw.event_draw_type=="random"}SELECTED{/if}>Random Order Draw Every Round</option>
		<option value="random_step" {if $draw.event_draw_type=="random_step"}SELECTED{/if}>Random Order First Round With Stepped Progression</option>
	{/if}
	</select>
	{if $ft.flight_type_group!=1}
		<span id="draw_step" style="{if $draw.event_draw_type=="random_step"}display:block;{else}display:none;{/if}">
			Step Size <input type="text" name="event_draw_step_size" size="2" value="{$draw.event_draw_step_size}" onChange="set_changed();">  This is the number of pilots to skip every round.
		</span>
	{/if}
	</td>
</tr>
{if $ft.flight_type_group==1}
<tr>
	<th nowrap>Team Protection</th>
	<td>
		<input type="checkbox" name="event_draw_team_protection"{if $draw.event_draw_team_protection==1} CHECKED{/if} onChange="set_changed();"> This will not have team pilots matched up against each other.
	</td>
</tr>
<tr>
	<th nowrap>Desired Number of Flight Groups</th>
	<td>
		<span id="no_protection">
			<select name="groups">
			</select>
		</span>
		<span id="with_protection">
			<select name="groups">
			</select>
		</span>
		<input type="hidden" name="event_draw_number_groups" value="">
	</td>
</tr>

{else}
<tr>
	<th nowrap>Team Separation</th>
	<td>
		<input type="checkbox" name="event_draw_team_separation"{if $draw.event_draw_team_separation==1} CHECKED{/if} onChange="set_changed();"> This will make sure team pilots are separated by at least one pilot.
	</td>
</tr>
{/if}
<tr>
	<td colspan="2">
		<input type="button" value=" {if $event_draw_id==0}Create{else}Save{/if} {$ft.flight_type_name} Draw " class="block-button" onClick="if(changed==1 && document.main.event_draw_id.value!=0){ldelim}confirm('You have changed the draw values. Do you wish to re-calculate the draw?') && document.main.submit();{rdelim}else{ldelim}document.main.submit();{rdelim}">
	</td>
</tr>
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw">
<input type="hidden" name="event_id" value="{$event_id}">
</form>

</div>
</div>

