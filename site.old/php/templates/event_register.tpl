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
});
{/literal}
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
function check_event(){ldelim}
	var all_selected=1;
	var temp_value='';
	{foreach $event->reg_options as $r}
		{$reg_id=$r.event_reg_param_id}
		{if $r.event_reg_param_choice_name!=''}
			{for $x=0 to $params.$reg_id.event_pilot_reg_qty-1}
				temp_value=document.main.event_reg_param_{$r.event_reg_param_id}_choice_value_{$x}.value;
				if(temp_value.indexOf("Select") !=-1){ldelim}
					all_selected=0;
				{rdelim}
			{/for}
		{/if}
	{/foreach}
	if(all_selected){ldelim}
		return 1;
	{rdelim}else{ldelim}
		alert("Please make selections for all of your parameter choices.");
		return 0;
	{rdelim}	
{rdelim}

</script>

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Registration for {$event->info.event_name}
			<input type="button" value=" Back To Event View " onClick="goback.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Registration Parameters</h1>
<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_register_save">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_pilot_id" value="{$event_pilot.event_pilot_id}">
<input type="hidden" name="plane_id" value="{$event_pilot.plane_id}">
<input type="hidden" name="go_to_paypal" value="0">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th align="right" width="20%">Pilot</th>
	<td>
		{$user.user_first_name} {$user.user_last_name}
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot AMA #</th>
	<td colspan="2">
		<input type="text" name="pilot_ama" size="15" value="{$user.pilot_ama|escape}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot FAI #</th>
	<td colspan="2">
		<input type="text" name="pilot_fai" size="15" value="{$user.pilot_fai|escape}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Class</th>
	<td colspan="2">
		<select name="class_id">
		{foreach $classes as $c}
			{if $c.event_class_status==0}
				{continue}
			{else}
				<option value="{$c.class_id}" {if $event_pilot.class_id==$c.class_id}SELECTED{/if}>{$c.class_description|escape}</option>
			{/if}
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th align="right" nowrap>Pilot Radio Frequency</th>
	<td colspan="2">
		<input type="text" name="event_pilot_freq" size="15" value="{$event_pilot.event_pilot_freq|escape}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Team</th>
	<td colspan="2">
		<input type="text" id="event_pilot_team" name="event_pilot_team" size="40" value="{$event_pilot.event_pilot_team|escape}">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Primary Plane</th>
	<td colspan="2">
		<input type="text" id="event_plane" name="event_plane" size="40" value="{$event_pilot.plane_name|escape}">
		<img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="plane_message" style="font-style: italic;color: grey;">Start typing to search planes</span>
		<input type="button" value=" + New Plane " class="button" onClick="copy_plane_values(); add_plane.submit();">
	</td>
</tr>
<tr>
	<th align="right" nowrap>Event Registration Notes</th>
	<td colspan="2">
		<textarea name="event_pilot_reg_note" cols="60" rows="2">{$event_pilot.event_pilot_reg_note|escape}</textarea>
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="submit" value=" Save Registration Parameters " class="block-button" onClick="return check_event();">
	</th>
</tr>
</table>

{if $event->reg_options}
<h1 class="post-title entry-title">Additional Registration Values</h1>
Currency is in {$event->info.currency_name}s
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
	<td align="right" valign="top">
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
	<td align="center" valign="top">
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
	<td align="right" valign="top">
		{$event->info.currency_html}{$r.event_reg_param_cost|string_format:"%.2f"}
	</td>
	<td align="right" valign="top">
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
	{if $event_pilot.event_pilot_paid_flag==1}
	<font color="green"><b>PAID</b></font>
	{else}
		{if $go_to_paypal==1}
		<font color="orange"><b>PENDING</b></font>
		{else}
		<font color="red"><b>DUE</b></font>
		{/if}
	{/if}
	</th>
</tr>
{if $event->info.event_reg_paypal_address!='' && $go_to_paypal!=1}
<tr>
	<th colspan="{$cols}">
		<input type="button" value=" Pay With Paypal Account Now " class="block-button" onClick="calc_totals();document.main.go_to_paypal.value=1;main.submit();">
	</th>
</tr>
{/if}
<tr>
	<th colspan="{$cols}">
		<input type="button" value=" Save Registration Parameters " class="block-button" onClick="return check_event() && main.submit();">
	</th>
</tr>
</table>
{/if}
</form>
<script>
calc_totals();
</script>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>

{if $go_to_paypal==1}
<form name="paypal" method="GET" action="https://www.paypal.com/cgi-bin/webscr">
<input type="hidden" name="cmd" value="_xclick">
<input type="hidden" name="business" value="{$event->info.event_reg_paypal_address}">
<input type="hidden" name="receiver_email" value="{$event->info.event_reg_paypal_address}">
<input type="hidden" name="lc" value="{$event->info.country_code}">
<input type="hidden" name="item_name" value="F3XVault Registration for {$event->info.event_name} for pilot {$user.user_first_name} {$user.user_last_name}">
<input type="hidden" name="custom" value="{$event_pilot.event_pilot_id}">
<input type="hidden" name="amount" value="{$total|string_format:"%.2f"}">
<input type="hidden" name="currency_code" value="{$event->info.currency_code}">
<input type="hidden" name="button_subtype" value="services">
<input type="hidden" name="bn" value="PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted">
<input type="hidden" name="notify_url" value="http://www.f3xvault.com/paypal_ipn.php">
<input type="hidden" name="return" value="http://www.f3xvault.com/?action=event&function=event_view&event_id={$event->info.event_id}">
</form>
<script type="text/javascript">
<!--
        document.paypal.submit();
-->
</script>
{/if}

</div>
</div>
</div>

