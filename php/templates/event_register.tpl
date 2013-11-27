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
	{if $event->info.event_reg_paypal_address!=''}
	document.paypal.amount.value = total.toFixed(2);
	{/if}
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
	<th colspan="3" style="text-align: center;">
		<input type="submit" value=" Save Registration Parameters " class="block-button" onClick="return check_event();">
	</th>
</tr>
</table>

{if $event->reg_options}
<h1 class="post-title entry-title">Additional Registration Values</h1>
Currency is in {$event->info.currency_name}s
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="20%">Name</th>
	<th width="10%"> Qty</th>
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
	<td align="right">
		{$event->info.currency_html}{$r.event_reg_param_cost|string_format:"%.2f"}
	</td>
	<td align="right">
		<span id="extended_{$r.event_reg_param_id}"></span>
	</td>
</tr>
{/foreach}
<tr>
	<th align="right" colspan="3">Total Registration Fee ({$event->info.currency_name})</th>
	<th align="right" width="10%">
		<span id="total"></span>
	</th>
</tr>
<tr>
	<th align="right" colspan="3">Status</th>
	<th align="right" width="10%">
	{if $event_pilot.event_pilot_paid_flag==1}
	<font color="green"><b>PAID</b></font>
	{else}
	<font color="red"><b>DUE</b></font>
	{/if}
	</th>
</tr>
{if $event->info.event_reg_paypal_address!=''}
<tr>
	<th colspan="4">
		<input type="button" value=" Pay With Paypal Account Now " class="block-button" onClick="calc_totals();paypal.submit();">
	</th>
</tr>
{/if}
<tr>
	<th colspan="4">
		<input type="submit" value=" Save Registration Parameters " class="block-button" onClick="return check_event();">
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
{if $event->info.event_reg_paypal_address!=''}
<form name="paypal" method="GET" action="https://www.paypal.com/cgi-bin/webscr" target="_blank">
<input name="cmd" type="hidden" value="_xclick">
<input name="business" type="hidden" value="{$event->info.event_reg_paypal_address}">
<input name="lc" type="hidden" value="{$event->info.country_code}">
<input name="item_name" type="hidden" value="F3XVault Registration for {$event->info.event_name}">
<input name="amount" type="hidden" value="">
<input type="hidden" name="currency_code" value="{$event->info.currency_code}">
<input type="hidden" name="button_subtype" value="services">
<input type="hidden" name="bn" value="PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted">
</form>
{/if}

</div>
</div>
</div>

