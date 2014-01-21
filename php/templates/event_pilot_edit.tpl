<script src="/includes/jquery.min.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
$(function() {ldelim}
	var teams = [
		{foreach $teams as $t}
		"{$t.event_pilot_team}"{if !$t@last},{/if}
		{/foreach}
	];
{literal}
	$("#event_pilot_team").autocomplete({
		source: teams,
		minLength: 0, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300
	});
	$("#event_plane").autocomplete({
		source: "/lookup.php?function=lookup_plane",
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
			document.main.plane_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.main.event_plane.value==''){
				document.main.plane_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "none";
   			var mes=document.getElementById('plane_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new plane.';
			}
		}
	});
	$("#pilot_name").autocomplete({
		source: "/lookup.php?function=lookup_pilot",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var pilot_loading=document.getElementById('pilot_loading');
			pilot_loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.main.pilot_id.value = ui.item.id;
			var name=document.getElementById('pilot_name');
			document.main.pilot_name.value=name.value;
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('pilot_loading');
			pilot_loading.style.display = "none";
   			var mes=document.getElementById('pilot_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found.';
			}
		}
	});
});
{/literal}
function copy_plane_values(){ldelim}
	document.add_plane.plane_name.value=document.main.event_plane.value;
	{if $pilot.pilot_id==0}
	document.add_plane.from_pilot_first_name.value=document.main.pilot_first_name.value;
	document.add_plane.from_pilot_last_name.value=document.main.pilot_last_name.value;
	document.add_plane.from_pilot_city.value=document.main.pilot_city.value;
	document.add_plane.from_state_id.value=document.main.state_id.value;
	document.add_plane.from_country_id.value=document.main.country_id.value;
	document.add_plane.from_pilot_email.value=document.main.pilot_email.value;
	{/if}
	document.add_plane.from_pilot_ama.value=document.main.pilot_ama.value;
	document.add_plane.from_pilot_fai.value=document.main.pilot_fai.value;
	document.add_plane.from_class_id.value=document.main.class_id.value;
	document.add_plane.from_event_pilot_freq.value=document.main.event_pilot_freq.value;
	document.add_plane.from_event_pilot_team.value=document.main.event_pilot_team.value;
	document.add_plane.from_event_pilot_bib.value=document.main.event_pilot_bib.value;
	document.add_plane.from_event_pilot_draw_status.value=document.main.event_pilot_draw_status.value;
{rdelim}
function change_pilot(){ldelim}
	var pilot_search=document.getElementById('pilot_search');
	pilot_search.style.display = "inline";
	var change_pilot_button=document.getElementById('change_pilot_button');
	change_pilot_button.style.display = "none";
	var change_pilot_info_button=document.getElementById('change_pilot_info_button');
	change_pilot_info_button.style.display = "none";
	var pilot_message=document.getElementById('pilot_message');
	pilot_message.style.display = "inline";
{rdelim}
function calc_totals(){ldelim}
	var total=0;
{foreach $event->reg_options as $r}
	{if $r.event_reg_param_mandatory==1}
		var qty_{$r.event_reg_param_id} = 1;
	{else}
		var qty_{$r.event_reg_param_id} = 0;
		{if $r.event_reg_param_qty_flag!=1}
			if(document.main.event_reg_param_{$r.event_reg_param_id}_qty.checked==true){ldelim}
				var qty_{$r.event_reg_param_id} = 1;
			{rdelim}
		{else}
			var qty_{$r.event_reg_param_id} = document.main.event_reg_param_{$r.event_reg_param_id}_qty.value;
		{/if}
	{/if}
	var id_{$r.event_reg_param_id} = document.getElementById('extended_{$r.event_reg_param_id}');
	var temp_extended=qty_{$r.event_reg_param_id}*{$r.event_reg_param_cost};
	id_{$r.event_reg_param_id}.innerHTML = '{$event->info.currency_html}'+temp_extended.toFixed(2);
	total=total + temp_extended;
{/foreach}
	var id_total=document.getElementById('total');
	id_total.innerHTML = '{$event->info.currency_html}'+total.toFixed(2);
{rdelim}
</script>
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Pilot {if $pilot.event_pilot_id!=0}Edit{else}Add{/if}{if $pilot.pilot_id==0} (And Create New Pilot){/if}</h1>
		<div class="entry-content clearfix">

<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_pilot_save">
<input type="hidden" name="event_id" value="{$event_id}">
<input type="hidden" name="event_pilot_id" value="{$pilot.event_pilot_id}">
<input type="hidden" name="pilot_id" value="{$pilot.pilot_id}">
<input type="hidden" name="plane_id" value="{$pilot.plane_id}">
<input type="hidden" name="event_pilot_edit" value="1">
<table width="100%" cellpadding="2" cellspacing="2" class="tableborder">
<tr>
	<th colspan="3">Event Pilot Information</th>
</tr>
<tr>
	<th align="right" nowrap>Event</th>
	<td colspan="2">
		{$event->info.event_name|escape}
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Entry Order</th>
	<td colspan="2">
		<input type="text" name="event_pilot_entry_order" size="3" value="{$pilot.event_pilot_entry_order|escape}">
	</td>
</tr>
{if $pilot.pilot_id==0}
<tr>
	<th align="right" nowrap>Pilot First Name</th>
	<td colspan="2">
		{if $pilot.pilot_id==0}
		<input type="text" name="pilot_first_name" size="40" value="{$pilot.pilot_first_name|escape}">
		{else}
		{$pilot.pilot_first_name|escape}
		{/if}
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Last Name</th>
	<td colspan="2">
		{if $pilot.pilot_id==0}
		<input type="text" name="pilot_last_name" size="40" value="{$pilot.pilot_last_name|escape}">
		{else}
		{$pilot.pilot_last_name|escape}
		{/if}
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot City</th>
	<td colspan="2">
		<input type="text" name="pilot_city" size="40" value="{$pilot.pilot_city|escape}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot State</th>
	<td colspan="2">
		<select name="state_id">
		{foreach $states as $state}
			<option value="{$state.state_id}" {if $pilot.state_id==$state.state_id}SELECTED{/if}>{$state.state_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Country</th>
	<td colspan="2">
		<select name="country_id">
		{foreach $countries as $country}
			<option value="{$country.country_id}" {if $pilot.country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Email</th>
	<td colspan="2">
		<input type="text" name="pilot_email" size="40" value="{$pilot.pilot_email|escape}">
	</td>
</tr>
{else}
<tr>
	<th align="right" nowrap>Pilot Name</th>
	<td colspan="2">
		{$pilot.pilot_first_name|escape} {$pilot.pilot_last_name|escape}
		<span id="pilot_search" style="vertical-align: middle;display: none;">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---> Change Pilot To
			<input type="text" id="pilot_name" name="pilot_name" size="40" value="">
			<img id="pilot_loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
			<span id="pilot_message" style="font-style: italic;color: grey;display: none;">Start typing to search pilots</span>
		</span>
		<input type="button" id="change_pilot_button" value=" Change Pilot " class="button" onClick="change_pilot();">
		<input type="button" id="change_pilot_info_button" value=" Edit Pilot Info " class="button" onClick="edit_pilot.submit();">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Location</th>
	<td colspan="2">
		{$pilot.pilot_city|escape}, {$pilot.state_name|escape} - {$pilot.country_code|escape}
	</td>
</tr>
{/if}
<tr>
	<th align="right" nowrap>Event Pilot Bib Number</th>
	<td colspan="2">
		<input type="text" name="event_pilot_bib" size="2" value="{$pilot.event_pilot_bib|escape}"> Leave blank if not using bibs
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot AMA #</th>
	<td colspan="2">
		<input type="text" name="pilot_ama" size="15" value="{$pilot.pilot_ama|escape}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot FAI #</th>
	<td colspan="2">
		<input type="text" name="pilot_fai" size="15" value="{$pilot.pilot_fai|escape}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Class</th>
	<td colspan="2">
		<select name="class_id">
		{foreach $classes as $c}
			<option value="{$c.class_id}" {if $pilot.class_id==$c.class_id}SELECTED{/if}>{$c.class_description|escape}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Radio Frequency</th>
	<td colspan="2">
		<input type="text" name="event_pilot_freq" size="15" value="{$pilot.event_pilot_freq|escape}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Team</th>
	<td colspan="2">
		<input type="text" id="event_pilot_team" name="event_pilot_team" size="40" value="{$pilot.event_pilot_team|escape}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Plane</th>
	<td colspan="2">
		<input type="text" id="event_plane" name="event_plane" size="40" value="{$pilot.plane_name|escape}">
		<img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="plane_message" style="font-style: italic;color: grey;">Start typing to search planes</span>
		<input type="button" value=" + New Plane " class="button" onClick="copy_plane_values(); add_plane.submit();">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Pilot Draw Status</th>
	<td colspan="2">
		<input type="radio" value="1" name="event_pilot_draw_status"{if $pilot.event_pilot_draw_status==1} CHECKED{/if}> On
		<input type="radio" value="0" name="event_pilot_draw_status"{if $pilot.event_pilot_draw_status==0} CHECKED{/if}> Off
	</td>
</tr>
<tr>
	<th valign="center" colspan="3">
	<input type="button" value=" Cancel " class="button" onClick="goback.submit();">
	<input type="submit" value=" Save Event Pilot Info " class="button">
	</th>
</tr>
</table>

{if $event->reg_options}
<h1 class="post-title entry-title">Registration Values</h1>
{if $has_sizes}{$cols=5}{else}{$cols=4}{/if}

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%">Name</th>
	<th width="10%"> Qty</th>
	{if $has_sizes}
	<th width="20%">Parameter Choice</th>
	{/if}
	<th width="10%">Cost Per Unit</th>
	<th align="right" width="10%">Extended</th>
</tr>
{foreach $event->reg_options as $r}
{$reg_id=$r.event_reg_param_id}
<tr>
	<td align="right">
		{$r.event_reg_param_name} - <a href="" class="tooltip" onClick="return false;">(detail description)
		<span>
		<img class="callout" src="/images/callout.gif">
		<strong>Registration Item Detail</strong><br>
		<table>
		<tr>
			<td>{$r.event_reg_param_description}</td>
		</tr>
		</table>
		</span>
		</a>
	</td>
	<td align="center">
		{if $r.event_reg_param_mandatory==1}
		1<input type="hidden" name="event_reg_param_{$r.event_reg_param_id}_qty" value="1">
		{elseif $r.event_reg_param_qty_flag==1}
			<input type="text" size="1" name="event_reg_param_{$r.event_reg_param_id}_qty" value="{$params.$reg_id.event_pilot_reg_qty}" onChange="calc_totals();">
		{else}
			<input type="checkbox" name="event_reg_param_{$r.event_reg_param_id}_qty"{if $params.$reg_id.event_pilot_reg_qty==1} CHECKED{/if} onChange="calc_totals();">
		{/if}
	</td>
	{if $has_sizes}
	<td align="right" valign="top">
		{if $r.event_reg_param_choice_name!=''}
		{for $x=0 to $params.$reg_id.event_pilot_reg_qty-1}
			<select name="event_reg_param_{$r.event_reg_param_id}_choice_value_{$x}">
			{foreach $r.choices as $c}
			<option value="{$c}"{if $params.$reg_id.event_pilot_reg_choice_values.$x==$c} SELECTED{/if}>{$c}</option>
			{/foreach}
			</select>
		{/for}
		{/if}
	</td>
	{/if}
	<td align="right">
		{$event->info.currency_html}{$r.event_reg_param_cost|string_format:"%.2f"}
	</td>
	<td align="right">
		<span id="extended_{$r.event_reg_param_id}"></span>
	</td>
</tr>
{/foreach}
<tr>
	<th align="right" colspan="{$cols-1}">Total Registration Fee ({$event->info.currency_name})</th>
	<th align="right" width="10%">
		<span id="total"></span>
	</th>
</tr>
<tr>
	<th align="right" colspan="{$cols-1}">Status</th>
	<th align="right" width="10%">
	{if $pilot.event_pilot_paid_flag==1}
	<font color="green"><b>PAID</b></font>
	{else}
	<font color="red"><b>DUE</b></font>
	{/if}
	</th>
</tr>
<tr>
	<th align="right" colspan="{$cols-1}">Set Status</th>
	<th align="right" width="10%">
	<select name="event_pilot_paid_flag">
	<option value="0"{if $pilot.event_pilot_paid_flag==0} SELECTED{/if}>DUE</option>
	<option value="1"{if $pilot.event_pilot_paid_flag==1} SELECTED{/if}>PAID</option>
	</th>
</tr>
<tr>
	<th colspan="{$cols}" style="text-align: center;">
		<input type="submit" value=" Save Registration Parameters " class="block-button" onClick="return check_event();">
	</th>
</tr>
</table>
{/if}
</form>
<script>
calc_totals();
</script>




<script>
{if $pilot.pilot_id==0}
	document.main.pilot_city.focus();
{else}
	document.main.event_pilot_bib.focus();
{/if}
</script>
<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event_id}">
</form>
<form name="add_plane" method="POST">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_edit">
<input type="hidden" name="plane_id" value="0">
<input type="hidden" name="plane_name" value="">
<input type="hidden" name="from_action" value="event">
<input type="hidden" name="from_function" value="event_pilot_edit">
<input type="hidden" name="from_event_id" value="{$event_id}">
<input type="hidden" name="from_event_pilot_id" value="{$pilot.event_pilot_id}">
<input type="hidden" name="from_pilot_id" value="{$pilot.pilot_id}">
<input type="hidden" name="from_pilot_first_name" value="">
<input type="hidden" name="from_pilot_last_name" value="">
<input type="hidden" name="from_pilot_city" value="">
<input type="hidden" name="from_state_id" value="">
<input type="hidden" name="from_country_id" value="">
<input type="hidden" name="from_pilot_email" value="">
<input type="hidden" name="from_pilot_ama" value="">
<input type="hidden" name="from_pilot_fai" value="">
<input type="hidden" name="from_class_id" value="">
<input type="hidden" name="from_event_pilot_freq" value="">
<input type="hidden" name="from_event_pilot_team" value="">
<input type="hidden" name="from_event_pilot_bib" value="">
<input type="hidden" name="from_event_pilot_draw_status" value="">
</form>
<form name="edit_pilot" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_pilot_edit_pilot">
<input type="hidden" name="event_id" value="{$event_id}">
<input type="hidden" name="event_pilot_id" value="{$pilot.event_pilot_id}">
</form>

</div>
</div>
</div>
