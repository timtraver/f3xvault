{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">{$event->info.event_name}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">

		<form name="main" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_round_save">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="event_round_id" value="{$event_round_id}">
		<input type="hidden" name="event_round_number" value="{$round_number}">
		<input type="hidden" name="create_new_round" value="0">

		<h2 class="post-title entry-title">Event Round 
			{$prev=$round_number-1}
			{$next=$round_number+1}
			{if $event->rounds.$prev}
			<a href="?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$event->rounds.$prev.event_round_id}"><img src="/images/arrow-left.png" style="vertical-align:text-bottom;"></a>
			{/if}
			{$round_number|escape}
			{if $event->rounds.$next}
			<a href="?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$event->rounds.$next.event_round_id}"><img src="/images/arrow-right.png" style="vertical-align:text-bottom;"></a>
			{/if}
		</h2>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
			<th width="20%" nowrap>Event Round Type</th>
			<td>
				{if $event->info.event_type_flight_choice==1}
					<select name="flight_type_id">
					{foreach $flight_types as $ft}
					<option value="{$ft.flight_type_id}" {if $ft.flight_type_id==$event->rounds.$round_number.flight_type_id}SELECTED{/if}>{$ft.flight_type_name|escape}</option>
					{/foreach}
					</select>
				{else}
					{foreach $flight_types as $ft}
						{$ft.flight_type_name|escape}{if $ft.flight_type_start_height} + Start Height{/if}{if $ft.flight_type_landing} + Landing{/if}{if !$ft@last},&nbsp;{/if}
					{/foreach}
					<input type="hidden" name="flight_type_id" value="0">
				{/if}
			</td>
			{if $event->info.event_type_time_choice==1}
			<th>
				Max Flight Time
			</th>
			<td>
				{if $event->info.event_type_time_choice==1}
					<input type="text" size="5" name="event_round_time_choice" value="{$event->rounds.$round_number.event_round_time_choice}"> Minutes
				{else}
					<input type="hidden" name="event_round_time_choice" value="0">
				{/if}
			</td>
			{else}
			<th colspan="2">&nbsp;</th>
			{/if}
		</tr>
		<tr>
			<th nowrap>Event Round Sort By</th>
			<td>
				<select name="sort_by" onChange="document.sort_round.sort_by.value=document.main.sort_by.value; sort_round.submit();">
				<option value="round_rank"{if $sort_by=='round_rank'} SELECTED{/if}>Round Rank</option>
				<option value="entry_order"{if $sort_by=='entry_order'} SELECTED{/if}>Entry Order</option>
				<option value="bib_order"{if $sort_by=='bib_order'} SELECTED{/if}>Bib Order</option>
				<option value="flight_order"{if $sort_by=='flight_order'} SELECTED{/if}>Round Flight Order</option>
				<option value="group_alphabetical_first"{if $sort_by=='group_alphabetical_first'} SELECTED{/if}>Group, then Alphabetical Order - First Name</option>
				<option value="group_alphabetical_last"{if $sort_by=='group_alphabetical_last'} SELECTED{/if}>Group, then Alphabetical Order - Last Name</option>
				<option value="group_entry"{if $sort_by=='group_entry'} SELECTED{/if}>Group, then Entry Order</option>
				<option value="alphabetical_first"{if $sort_by=='alphabetical_first'} SELECTED{/if}>Alphabetical Order - First Name</option>
				<option value="alphabetical_last"{if $sort_by=='alphabetical_last'} SELECTED{/if}>Alphabetical Order - Last Name</option>
				</select>
			</td>
			<th nowrap>Include This Round In Final Results</th>
			<td align="left">
				<input type="checkbox" name="event_round_score_status"{if $event->rounds.$round_number.event_round_score_status==1} CHECKED{/if}>
			</td>
		</tr>
		{if $event->info.event_type_flyoff==1}
		<tr>
			<th nowrap>Round Flyoff Number</th>
			<td colspan="3">
				{$event->rounds.$round_number.event_round_flyoff}
			</td>
		</tr>
		{/if}
		</table>
		
		<h2 class="post-title entry-title">Round Flights</h2>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		{$tabindex=2}
		{foreach $flight_types as $ft}
			{$flight_type_id=$ft.flight_type_id}
			{if $event->info.event_type_flight_choice==1 AND $ft.flight_type_id!=$event->rounds.$round_number.flight_type_id}
				{continue}
			{/if}
			{$cols=4}
			{if preg_match("/^f3f/",$ft.flight_type_code) && $ft.flight_type_group==1}{$cols=$cols+1}{/if}
			{if $ft.flight_type_seconds}{$cols=$cols+1}{/if}
			{if $ft.flight_type_landing}{$cols=$cols+1}{/if}
			{if $ft.flight_type_laps}{$cols=$cols+1}{/if}
			{if $ft.flight_type_position}{$cols=$cols+1}{/if}
			{if $ft.flight_type_start_penalty}{$cols=$cols+1}{/if}
			{if $ft.flight_type_start_height}{$cols=$cols+1}{/if}
			<tr>
				<th colspan="2" style="text-align:left;">
					<span id="toggle_{$flight_type_id}" onClick="toggle('view_flight_type_{$flight_type_id}',this);">
					<img width="24" height="24" src="/images/arrow-down.png" style="vertical-align:middle;"> 
					</span>
					Round {$round_number|escape}
				</th>
				<th colspan="{$cols}">
					{$ft.flight_type_name|escape}
				</th>
				<th>
					Score <input type="checkbox" name="event_round_flight_score_{$ft.flight_type_id}"{if $event->rounds.$round_number.flights.$flight_type_id.event_round_flight_score==1 || $event_round_id==0 || empty($event->rounds.$round_number.flights.$flight_type_id)} CHECKED{/if}>
				</th>
			</tr>
			<tbody id="view_flight_type_{$flight_type_id}" style="display: table-row-group;">
			<tr>
				<th width="2%" align="left"></th>
				<th align="left">Pilot Name</th>
				{if $ft.flight_type_group}
					<th align="center" style="text-align: center;">Group</th>
					{if preg_match("/^f3f/",$ft.flight_type_code) && $ft.flight_type_group}
						<th align="center">Flight Order</th>
					{/if}
				{else}
					<th align="center" style="text-align: center;">Flight Order</th>
				{/if}
				{if $ft.flight_type_start_penalty}
					<th align="center" style="text-align: center;">Start Penalty</th>
				{/if}
				{if $ft.flight_type_minutes || $ft.flight_type_seconds}
					<th align="center" style="text-align: center;" nowrap>
						Time{if $ft.flight_type_sub_flights!=0}s{/if}{if $ft.flight_type_over_penalty}/Over{/if}
						{if $ft.flight_type_sub_flights!=0}<br>
							<div>
							{for $sub=1 to $ft.flight_type_sub_flights}
								<input type="text" size="6" style="width:{$ft.accuracy*20 + 20}px;height: 20px;text-align: right;background-color: lightgrey;" value="{if $ft.flight_type_code == "f3f_plus"}{if $sub == 1}Climb{else}Sub {$sub - 1|escape}{/if}{else}Sub {$sub|escape}{/if}" disabled> {if $sub!=$ft.flight_type_sub_flights},{/if}
							{/for}
							= Total
							</div>
						{/if}
						
					</th>
				{/if}
				{if $ft.flight_type_landing}
					<th align="center" style="text-align: center;">Landing</th>
				{/if}
				{if $ft.flight_type_start_height}
					<th align="center" style="text-align: center;">Start Height</th>
				{/if}
				{if $ft.flight_type_laps}
					<th align="center" style="text-align: center;">Laps</th>
				{/if}
				{if $ft.flight_type_position}
					<th align="center" style="text-align: center;">Flight Position</th>
				{/if}
				<th align="center" style="text-align: right;">Raw Score</th>
				<th align="center" style="text-align: right;">{if $event->info.event_type_score_inverse==0}Normalized{else}Calculated{/if} Score</th>
				<th align="center" style="text-align: center;">Penalty</th>
				<th align="center" style="text-align: right;">Flight Rank</th>
			</tr>
			{$num=1}
			{foreach $event->rounds.$round_number.flights as $f}
			{if $f@key!=$ft.flight_type_id}
				{continue}
			{/if}
			{$groupcolor='lightgrey'}
			{$oldgroup=''}
			{foreach $f.pilots as $p}
			{$event_pilot_id=$p@key}
			{if $oldgroup!=$p.event_pilot_round_flight_group}
				{if $groupcolor=='white'}{$groupcolor='lightgrey'}{else}{$groupcolor='white'}{/if}
				{$oldgroup=$p.event_pilot_round_flight_group|escape}
			{/if}
			{$time_disabled=0}
			<tr style="background-color: {$groupcolor};height: 20px;">
				<td style="background-color: lightgrey;">{$num}</td>
				<td valign="center" nowrap>
					{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
						<div class="pilot_bib_number" style="margin-right: 4px;">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
					{/if}
					{if $event->pilots.$event_pilot_id.country_code}<img src="/images/flags/countries-iso/shiny/16/{$event->pilots.$event_pilot_id.country_code|escape}.png" class="inline_flag" title="{$event->pilots.$event_pilot_id.country_name}">{/if}
					{if $event->pilots.$event_pilot_id.state_name && $event->pilots.$event_pilot_id.country_code=="US"}<img src="/images/flags/states/16/{$event->pilots.$event_pilot_id.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$event->pilots.$event_pilot_id.state_name}">{/if}
					{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}
				</td>
					{if $ft.flight_type_group}
						<td align="center" nowrap>{$p.event_pilot_round_flight_group|escape}</td>					
					{else}
						<td align="center" nowrap>{$p.event_pilot_round_flight_order|escape}</td>					
					{/if}
					{if $ft.flight_type_start_penalty}
						<td align="center" nowrap>
							{$p.event_pilot_round_flight_start_penalty|escape}
						</td>
					{/if}
					{if $ft.flight_type_minutes || $ft.flight_type_seconds}
						<td align="center" nowrap>
							{if $ft.flight_type_sub_flights != 0}
								{if $ft.flight_type_code != 'f3f_plus'}{$time_disabled = 1}{/if}
								{for $sub=1 to $ft.flight_type_sub_flights}
									<input tabindex="{$tabindex}" autocomplete="off" type="text" size="10" style="width:{$ft.accuracy*20 + 20}px;text-align: right;color:black;" name="pilot_sub_flight_{$sub}_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.sub.$sub.event_pilot_round_flight_sub_val!='0:00'}{$p.sub.$sub.event_pilot_round_flight_sub_val|escape}{/if}" disabled> {if $sub!=$ft.flight_type_sub_flights},{/if} 
									{$tabindex=$tabindex+1}
								{/for}
								= Total
							{/if}
							{if $ft.flight_type_minutes}
								{$p.event_pilot_round_flight_minutes|escape}m
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_seconds}
								{if $p.event_pilot_round_flight_dns==1}DNS{elseif $p.event_pilot_round_flight_dnf==1}DNF{else}{$p.event_pilot_round_flight_seconds|escape}{/if}s
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_over_penalty}
								<input type="checkbox" tabindex="{$tabindex}" name="pilot_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if} onChange="save_data(this);">
								{$tabindex=$tabindex+1}
							{/if}
						</td>
					{/if}
					{if $ft.flight_type_start_height}
						<td align="center" nowrap>
							{$p.event_pilot_round_flight_start_height|escape}
						</td>
					{/if}
					{if $ft.flight_type_landing}
						<td align="center" nowrap>{$p.event_pilot_round_flight_landing|escape}</td>
						{$tabindex=$tabindex+1}
					{/if}
					{if $ft.flight_type_laps}
						<td align="center" nowrap>{$p.event_pilot_round_flight_laps|escape}</td>
						{$tabindex=$tabindex+1}
					{/if}
					{if $ft.flight_type_position}
						<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:35px;height: 20px;text-align: right;" name="pilot_position_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.event_pilot_round_flight_dns==1}DNS{elseif $p.event_pilot_round_flight_dnf==1}DNF{else}{$p.event_pilot_round_flight_position|escape}{/if}" onChange="save_data(this);"></td>
						{$tabindex=$tabindex+1}
					{/if}
					<td align="right" nowrap>
						{if preg_match("/^f3f/",$ft.flight_type_code) || $ft.flight_type_code=='f3b_speed'}
						{$p.event_pilot_round_flight_raw_score|escape}
						{else}
						{$p.event_pilot_round_flight_raw_score|string_format:$event->event_calc_accuracy_string}
						{/if}
					</td>
					<td align="right" nowrap>
					{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}<del><font color="red">{/if}
					{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}{if $p.event_pilot_round_flight_reflight_dropped}(R){/if}
					{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}</font></del>{/if}
					</td>
					<td align="center" nowrap>
						{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty|escape}{/if}
					</td>
					<td align="right" nowrap>
					{$p.event_pilot_round_flight_rank|escape}
					</td>
			</tr>
			{$num=$num+1}
			{/foreach}
			{/foreach}
			{if $ft.flight_type_reflight==1 && $event->rounds.$round_number.reflights.$flight_type_id.pilots|count > 0}
			<tr>
			<th colspan="3">Reflights</th>
			<th colspan="8">
			{$event->rounds.$round_number.reflights.$flight_type_id.pilots|count}
			</th>
			</tr>
			{foreach $event->rounds.$round_number.reflights as $f}
				{if $f@key!=$ft.flight_type_id}
					{continue}
				{/if}
				{$groupcolor='lightgrey'}
				{$oldgroup=''}
				{foreach $f.pilots as $p}
				{$event_pilot_id=$p@key}
				{if $oldgroup!=$p.event_pilot_round_flight_group}
					{if $groupcolor=='white'}{$groupcolor='lightgrey'}{else}{$groupcolor='white'}{/if}
					{$oldgroup=$p.event_pilot_round_flight_group}
				{/if}
				<tr style="background-color: {$groupcolor};">
					<td style="background-color: lightgrey;">{$num}</td>
					<td style="background-color: white;" nowrap>
						{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
							<div class="pilot_bib_number">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
						{/if}
						{if $event->pilots.$event_pilot_id.country_code}<img src="/images/flags/countries-iso/shiny/16/{$event->pilots.$event_pilot_id.country_code|escape}.png" class="inline_flag" title="{$event->pilots.$event_pilot_id.country_name}">{/if}
						{if $event->pilots.$event_pilot_id.state_name && $event->pilots.$event_pilot_id.country_code=="US"}<img src="/images/flags/states/16/{$event->pilots.$event_pilot_id.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$event->pilots.$event_pilot_id.state_name}">{/if}
						{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}
					</td>
						{if $ft.flight_type_group}
							<td align="center" nowrap>{$p.event_pilot_round_flight_group|escape}</td>					
						{else}
							<td align="center" nowrap>{$p.event_pilot_round_flight_order|escape}</td>					
						{/if}
						{if $ft.flight_type_minutes || $ft.flight_type_seconds}
						<td align="center" nowrap>
							{if $ft.flight_type_sub_flights!=0}
								{$time_disabled=1}
								{for $sub=1 to $ft.flight_type_sub_flights}
									<input tabindex="{$tabindex}" autocomplete="off" type="text" size="6" style="width:35px;text-align: right;color: black;" name="pilot_reflight_sub_flight_{$sub}_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.sub.$sub.event_pilot_round_flight_sub_val!='0:00'}{$p.sub.$sub.event_pilot_round_flight_sub_val|escape}{/if}" disabled> {if $sub!=$ft.flight_type_sub_flights},{/if} 
									{$tabindex=$tabindex+1}
								{/for}
								= Total
							{/if}
							{if $ft.flight_type_minutes}
								{$p.event_pilot_round_flight_minutes|escape}m
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_seconds}
								{if $p.event_pilot_round_flight_dns==1}DNS{elseif $p.event_pilot_round_flight_dnf==1}DNF{else}{$p.event_pilot_round_flight_seconds|escape}{/if}s
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_over_penalty}
								<input type="checkbox" tabindex="{$tabindex}" name="pilot_reflight_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if}>
								{$tabindex=$tabindex+1}
							{/if}
						</td>
						{/if}
						{if $ft.flight_type_landing}
							<td align="center" nowrap>{$p.event_pilot_round_flight_landing|escape}</td>
							{$tabindex=$tabindex+1}
						{/if}
						{if $ft.flight_type_start_height}
							<td align="center" nowrap>
								{$p.event_pilot_round_flight_start_height|escape}
							</td>
						{/if}
						{if $ft.flight_type_laps}
							<td align="center" nowrap>{$p.event_pilot_round_flight_laps|escape}</td>
							{$tabindex=$tabindex+1}
						{/if}
						<td align="right" nowrap>
							{if $ft.flight_type_code=='f3f_speed' OR $ft.flight_type_code=='f3b_speed'}
							{$p.event_pilot_round_flight_raw_score}
							{else}
							{$p.event_pilot_round_flight_raw_score|string_format:$event->event_calc_accuracy_string}
							{/if}
						</td>
						<td align="right" nowrap>
						{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}<del><font color="red">{/if}
						{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}{if $p.event_pilot_round_flight_reflight_dropped}(R){/if}
						{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}</font></del>{/if}
						</td>
						<td align="center" nowrap>
							{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty|escape}{/if}
						</td>
						<td align="right" nowrap>
						{$p.event_pilot_round_flight_rank|escape}
						</td>
						<td align="right" nowrap>
						</td>
				</tr>
				{$num=$num+1}
				{/foreach}
			{/foreach}
			{/if}
			</tbody>
		{/foreach}
		</table>
		</form>
		<center>
			<input type="button" value=" Print Round Detail " onClick="document.printround.submit();" class="btn btn-primary btn-rounded">
			<input type="button" value=" Back To Event " onClick="goback.submit();" class="btn btn-primary btn-rounded">
		</center>
		<br>
</div>

<form name="sort_round" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_round_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_round_id" value="{$event_round_id}">
<input type="hidden" name="sort_by" value="">
</form>
<form name="printround" method="POST" target="_blank">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_print_round">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="use_print_header" value="1">
<input type="hidden" name="round_start_number" value="{$round_number|escape}">
<input type="hidden" name="round_end_number" value="{$round_number|escape}">
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>

{/block}
{block name="footer"}
<script>
function toggle(element,tog) {ldelim}
	if (document.getElementById(element).style.display == 'none') {ldelim}
		document.getElementById(element).style.display = 'table-row-group';
		tog.innerHTML = '<img width="24" height="24" src="/images/arrow-down.png" style="vertical-align:middle;">';
	{rdelim} else {ldelim}
		document.getElementById(element).style.display = 'none';
		tog.innerHTML = '<img width="24" height="24" src="/images/arrow-right.png" style="vertical-align:middle;">';
	{rdelim}
{rdelim}
</script>
{/block}