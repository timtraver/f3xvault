{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Event Registration</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">

		<h3 class="post-title entry-title">Registration Parameters</h3>

		<form name="main" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_register_save">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="event_pilot_id" value="{$event_pilot.event_pilot_id}">
		<input type="hidden" name="plane_id" value="{$event_pilot.plane_id}">
		<input type="hidden" name="go_to_paypal" value="0">
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
			<th align="right" width="10%">Event</th>
			<td>
				{$event->info.event_name}
			</td>
		</tr>
		<tr>
			<th align="right" width="10%">Pilot</th>
			<td>
				{$user.user_first_name} {$user.user_last_name}
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot AMA #</th>
			<td>
				<input type="text" name="pilot_ama" size="15" value="{$user.pilot_ama|escape}">
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot FAI Designation</th>
			<td>
				<input type="text" name="pilot_fai" size="15" value="{$user.pilot_fai|escape}">
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot FAI License</th>
			<td>
				<input type="text" name="pilot_fai_license" size="15" value="{$user.pilot_fai_license|escape}">
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot Class</th>
			<td>
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
			<th align="right" nowrap>Radio Freq</th>
			<td>
				<input type="text" name="event_pilot_freq" size="15" value="{$event_pilot.event_pilot_freq|escape}">
			</td>
		</tr>
		{if $event->info.event_reg_teams == 1}
		<tr>
			<th align="right" nowrap>Event Team</th>
			<td>
				<input type="text" id="event_pilot_team" name="event_pilot_team" size="40" value="{$event_pilot.event_pilot_team|escape}">
			</td>
		</tr>
		{/if}
		<tr>
			<th align="right" nowrap>Event Plane</th>
			<td>
				<input type="text" id="event_plane" name="event_plane" size="40" value="{$event_pilot.plane_name|escape}">
				<img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
				<span id="plane_message" style="font-style: italic;color: grey;">Start typing to search planes</span>
				<div class="btn-group btn-group-xs" style="float: right;margin-left: 15px;"><button class="btn btn-primary btn-rounded" id="change_pilot_info_button" type="button" onclick="copy_plane_values(); add_plane.submit();"> + New Plane </button></div>
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Notes</th>
			<td>
				<textarea name="event_pilot_reg_note" cols="40" rows="3">{$event_pilot.event_pilot_reg_note|escape}</textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2" style="text-align: center;">
				<input type="button" value=" Save Registration Parameters " class="btn btn-primary btn-rounded" onClick="return check_event() && main.submit();;">
			</td>
		</tr>
		</table>
		
		{if $event->reg_options}
			<h3 class="post-title entry-title">Additional Registration Values</h3>
			Currency is in {$event->info.currency_name}s
			{if $has_sizes}{$cols=5}{else}{$cols=4}{/if}
			<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
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
				<td align="left" valign="top">
					{$r.event_reg_param_name} - <a href="" class="tooltip_e" onClick="return false;">(detail description)
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
				<td align="left" valign="top">
					{if $r.event_reg_param_mandatory==1}
					1<input type="hidden" name="event_reg_param_{$r.event_reg_param_id}_qty" value="1">
					{elseif $r.event_reg_param_qty_flag==1}
						<input type="text" size="3" id="event_reg_param_{$r.event_reg_param_id}_qty" name="event_reg_param_{$r.event_reg_param_id}_qty" value="{$params.$reg_id.event_pilot_reg_qty}" onChange="calc_totals();">
					{else}
						<input type="checkbox" name="event_reg_param_{$r.event_reg_param_id}_qty"{if $params.$reg_id.event_pilot_reg_qty==1} CHECKED{/if} onChange="calc_totals();">
					{/if}
				</td>
				{if $has_sizes}
				<td align="right" valign="top">
					{if $r.event_reg_param_choice_name!=''}
					<div>
					{for $x=0 to $params.$reg_id.event_pilot_reg_qty-1}
						<select name="event_reg_param_{$r.event_reg_param_id}_choice_value_{$x}">
						{foreach $r.choices as $c}
						<option value="{$c}"{if $params.$reg_id.event_pilot_reg_choice_values.$x==$c} SELECTED{/if}>{$c}</option>
						{/foreach}
						</select>
						<br>
					{/for}
					</div>
					{/if}
					<div id="choices_{$r.event_reg_param_id}"></div>
				</td>
				{/if}
				<td align="right" valign="top">
					{$event->info.currency_html} {$r.event_reg_param_cost|string_format:"%.2f"}
				</td>
				<td align="right" valign="top">
					<span id="extended_{$r.event_reg_param_id}"></span>
				</td>
			</tr>
			{/foreach}
			{foreach $payments as $p}
			<tr>
				<td style="text-align: right;" colspan="{$cols-1}">
					{$p.event_pilot_payment_type} Payment ({$p.event_pilot_payment_date|date_format:"Y-m-d"})
				</td>
				<td style="text-align: right;" width="10%">
					<font color="green">({$event->info.currency_html} {$p.event_pilot_payment_amount|string_format:"%.2f"})</font>
				</td>
			</tr>
			{/foreach}
			<tr>
				<th style="text-align: right;" colspan="{$cols-1}">Total Fees Owed ({$event->info.currency_name} {$event->info.currency_html})</th>
				<th style="text-align: right;" width="10%">
					<span id="total"></span>
				</th>
			</tr>
			<tr>
				<th style="text-align: right;" colspan="{$cols-1}">Status</th>
				<th style="text-align: right;" width="10%">
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
					<td colspan="{$cols}" style="text-align: right;">
						<input type="image" id="paypal" src="https://www.paypalobjects.com/webstatic/en_US/i/buttons/buy-logo-small.png" alt="Buy now with PayPal"  onClick="calc_totals();document.main.go_to_paypal.value=1;return check_event() && main.submit();" />

					</td>
				</tr>
			{/if}
			<tr>
				<td colspan="{$cols}" style="text-align: right;">
					<input type="button" value=" Save Registration Parameters " class="btn btn-primary btn-rounded" onClick="return check_event() && main.submit();">
				</td>
			</tr>
			</table>
		{/if}
		</form>
		
		{if $go_to_paypal==1}
			<form name="paypal" method="POST" action="https://www.paypal.com/cgi-bin/webscr">
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
			<input type="hidden" name="notify_url" value="https://www.f3xvault.com/paypal_ipn.php">
			<input type="hidden" name="return" value="https://www.f3xvault.com/?action=event&function=event_view&event_id={$event->info.event_id}">
			</form>
			<script type="text/javascript">
			<!--
			        document.paypal.submit();
			-->
			</script>
		{/if}
		
		<form name="goback" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_view">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="tab" value="">
		</form>
	</div>
</div>
{/block}
{block name="footer"}
<!-- <script src="/includes/jquery.min.js"></script> -->
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{if $event->reg_options}
$(document).ready(function() {ldelim}
	{foreach $event->reg_options as $r}
		{$reg_id=$r.event_reg_param_id}
		{if $r.event_reg_param_choice_name!=''}
			$('#event_reg_param_{$reg_id}_qty').keyup(
				function() {ldelim}
					var current_{$reg_id} = {if $params.$reg_id.event_pilot_reg_qty}{$params.$reg_id.event_pilot_reg_qty}{else}0{/if};
					var current_value = document.main.event_reg_param_{$reg_id}_qty.value;
					diff = current_value - current_{$reg_id};
					var new_choices = "";
					if(diff>0){ldelim}
						for(i = current_{$reg_id} + 1;i<=(diff + current_{$reg_id}); i++){ldelim}
							new_choices += '<select name="event_reg_param_{$reg_id}_choice_value_' + i + '">' +
								{foreach $r.choices as $c}
								'<option value="{$c}">{$c}</option>' +
								{/foreach}
								'</select><br>';
						{rdelim}
						document.getElementById("choices_{$reg_id}").innerHTML = new_choices;
					{rdelim}else{ldelim}
						document.getElementById("choices_{$reg_id}").innerHTML = '';
					{rdelim}
					calc_totals();
				{rdelim});
		{/if}
	{/foreach}
{rdelim});

{/if}
$(function() {ldelim}
	{if $event->info.event_reg_teams == 1}
	var teams = [
		{foreach $teams as $t}
		"{$t.event_pilot_team}"{if !$t@last},{/if}
		{/foreach}
	];
	$("#event_pilot_team").autocomplete({ldelim}
		source: teams,
		minLength: 0, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300
	{rdelim});
	{/if}
{literal}
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
	var already_paid = {if $payments}{foreach $payments as $p}{$p.event_pilot_payment_amount}{if $p@last}{else} +{/if}{/foreach}{else}0{/if};
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
		id_{$r.event_reg_param_id}.innerHTML = '{$event->info.currency_html} '+temp_extended.toFixed(2);
		total=total + temp_extended;
	{/foreach}
	total = total - already_paid;
	var id_total=document.getElementById('total');
	id_total.innerHTML = '{$event->info.currency_html} '+total.toFixed(2);
	{if $event->info.event_reg_paypal_address!=''}
	if(total <=0){ldelim}
		document.getElementById('paypal').disabled = true;
		document.getElementById('paypal').style.opacity = "0.5";
	{rdelim}else{ldelim}
		document.getElementById('paypal').disabled = false;
		document.getElementById('paypal').style.opacity = "1.0";
	{rdelim}
	{/if}
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
			// Now lets check for any new ones
			var current_{$reg_id} = {if $params.$reg_id.event_pilot_reg_qty}{$params.$reg_id.event_pilot_reg_qty}{else}0{/if};
			var current_value = document.main.event_reg_param_{$reg_id}_qty.value;
			diff = current_value - current_{$reg_id};
			if(diff>0){ldelim}
				for(i = current_{$reg_id} + 1;i<=(diff + current_{$reg_id}); i++){ldelim}
					temp_value=eval('document.main.event_reg_param_{$reg_id}_choice_value_' + i + '.value');
					if(temp_value.indexOf("Select") !=-1){ldelim}
						all_selected=0;
					{rdelim}
				{rdelim}
			{rdelim}
			
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
<script>
	calc_totals();
</script>
{/block}
