{extends file='layout/layout_print.tpl'}

{block name="content"}

{include file='print/print_event_header_info.tpl'}

<div style="-webkit-print-color-adjust:exact;">
	<div class="entry clearfix">                
	{foreach $event->rounds as $r}
		{$round_number=$r.event_round_number}
		{if $round_number >= $round_from && $round_number <= $round_to}		
		<h2 class="post-title entry-title">Round {$round_number} Detail Results</h2>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		{foreach $event->flight_types as $ft}
			{$flight_type_id=$ft.flight_type_id}
			{if $event->info.event_type_flight_choice==1 AND $ft.flight_type_id!=$event->rounds.$round_number.flight_type_id}
				{continue}
			{/if}
			{$cols=10}
			{if $ft.flight_type_seconds}{$cols=$cols+1}{/if}
			{if $ft.flight_type_landing}{$cols=$cols+1}{/if}
			{if $ft.flight_type_laps}{$cols=$cols+1}{/if}
			{if $ft.flight_type_start_penalty}{$cols=$cols+1}{/if}
			{if $ft.flight_type_start_height}{$cols=$cols+1}{/if}
			<tr>
				<th align="left" colspan="{$cols}">
					{$ft.flight_type_name|escape}
				</th>
			</tr>
			<tr>
				<th width="2%" align="right"></th>
				<th width="2%" align="right">Bib</th>
				<th align="left">Pilot Name</th>
				<th align="left">FAI</th>
				<th align="left" nowrap>FAI License</th>
				{if $ft.flight_type_group}
					<th align="center">Group</th>
					{if preg_match("/^f3f/",$ft.flight_type_code) && $ft.flight_type_group}
						<th align="center" style="text-align: center;">Flight Order</th>
					{/if}
				{else}
					<th align="center" style="text-align: center;">Flight Order</th>
				{/if}
				{if $ft.flight_type_start_penalty}
					<th align="center" style="text-align: center;">Start Penalty</th>
				{/if}
				{if $ft.flight_type_start_height}
					<th align="center" style="text-align: center;">Start Height</th>
				{/if}
				{if $ft.flight_type_minutes || $ft.flight_type_seconds}
					<th align="center" style="text-align: center;" nowrap>
						Time{if $ft.flight_type_sub_flights!=0}s{/if}{if $ft.flight_type_over_penalty}/Over{/if}
						{if $ft.flight_type_sub_flights!=0}<br>
							<div>
							{for $sub=1 to $ft.flight_type_sub_flights}
								<input type="text" size="6" style="width:45px;height: 20px;text-align: right;background-color: lightgrey;" value="{if $ft.flight_type_code == "f3f_plus"}{if $sub == 1}Climb{else}Sub {$sub - 1|escape}{/if}{else}Sub {$sub|escape}{/if}" disabled> {if $sub!=$ft.flight_type_sub_flights},{/if}
							{/for}
							= Total
							</div>
						{/if}
						
					</th>
				{/if}
				{if $ft.flight_type_landing}
					<th align="center" style="text-align: right;">Landing</th>
				{/if}
				{if $ft.flight_type_laps}
					<th align="center" style="text-align: right;">Laps</th>
				{/if}
				<th align="center" style="text-align: right;">Raw Score</th>
				<th align="center" style="text-align: right;">Normalized Score</th>
				<th align="center" style="text-align: right;">Penalty</th>
				<th align="center" style="text-align: right;">Flight Rank</th>
			</tr>
			{$num=1}
			{foreach $event->rounds.$round_number.flights as $f}
			{if $f@key!=$ft.flight_type_id}
				{continue}
			{/if}
			{$groupcolor='#9DCFF0'}
			{$oldgroup=''}
			{foreach $f.pilots as $p}
			{$event_pilot_id=$p@key}
			{if $oldgroup!=$p.event_pilot_round_flight_group}
				{if $groupcolor=='white'}{$groupcolor='#9DCFF0'}{else}{$groupcolor='white'}{/if}
				{$oldgroup=$p.event_pilot_round_flight_group|escape}
			{/if}
			{$time_disabled=0}
			<tr style="background-color: {$groupcolor};">
				<td style="background-color: lightgrey;">{$num}</td>
				<td>
					{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
						<div class="pilot_bib_number">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
					{/if}
				</td>
				<td nowrap>
					{if $event->pilots.$event_pilot_id.country_code}<img src="/images/flags/countries-iso/shiny/16/{$event->pilots.$event_pilot_id.country_code|escape}.png" class="inline_flag" title="{$event->pilots.$event_pilot_id.country_name}">{/if}
					{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}
				</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_fai}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_fai_license}</td>
					{if $f.flight_type_group}
						<td align="center" nowrap>{$p.event_pilot_round_flight_group|escape}</td>					
						{if preg_match("/^f3f/",$ft.flight_type_code) || $ft.flight_type_code=='f3b_speed' || $ft.flight_type_code=='f3b_speed_only'}
							<td align="center" nowrap>{$p.event_pilot_round_flight_order|escape}</td>					
						{/if}
					{else}
						<td align="center" nowrap>{$p.event_pilot_round_flight_order|escape}</td>					
					{/if}
					{if $ft.flight_type_start_penalty}
						<td align="center" nowrap>
							{$p.event_pilot_round_flight_start_penalty|escape}
						</td>
					{/if}
					{if $ft.flight_type_start_height}
						<td align="center" nowrap>
							{$p.event_pilot_round_flight_start_height|escape} m
						</td>
					{/if}
					{if $f.flight_type_minutes || $f.flight_type_seconds}
						<td align="right" nowrap>
							{if $ft.flight_type_sub_flights!=0}
								{$time_disabled=1}
								{for $sub=1 to $ft.flight_type_sub_flights}
									{if $p.sub.$sub.event_pilot_round_flight_sub_val!='0:00'}
										<span style="background-color: white;display: inline-block;padding: 0px;margin: 1px;width: 35px;">{$p.sub.$sub.event_pilot_round_flight_sub_val|escape}</span>
									{else}
										<span style="background-color: white;display: inline-block;padding: 0px;margin: 1px;width: 35px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
									{/if} 
								{/for}
								= 
							{/if}
							{if $f.flight_type_minutes}
								{$p.event_pilot_round_flight_minutes|escape}m
							{/if}
							{if $f.flight_type_seconds}
								{$p.event_pilot_round_flight_seconds|escape}s
							{/if}
							{if $f.flight_type_over_penalty}
								<input type="checkbox" tabindex="{$tabindex}" name="pilot_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if} onChange="save_data(this);">
							{/if}
						</td>
					{/if}
					{if $f.flight_type_landing}
						<td align="center" nowrap>{$p.event_pilot_round_flight_landing|escape}</td>
					{/if}
					{if $f.flight_type_laps}
						<td align="center" nowrap>{$p.event_pilot_round_flight_laps|escape}</td>
					{/if}
					<td align="right" nowrap>
						{if $f.flight_type_code=='f3f_speed' OR $f.flight_type_code=='f3b_speed'}
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
			{if $ft.flight_type_reflight==1}
			{if $event->rounds.$round_number.reflights.$flight_type_id.pilots|count > 0}
			<tr>
				<th align="left" colspan="12">Reflights</th>
			</tr>
			{/if}
			{foreach $event->rounds.$round_number.reflights as $f}
				{if $f@key!=$ft.flight_type_id}
					{continue}
				{/if}
				{$groupcolor='#9DCFF0'}
				{$oldgroup=''}
				{foreach $f.pilots as $p}
				{$event_pilot_id=$p@key}
				{if $oldgroup!=$p.event_pilot_round_flight_group}
					{if $groupcolor=='lightgrey'}{$groupcolor='#9DCFF0'}{else}{$groupcolor='lightgrey'}{/if}
					{$oldgroup=$p.event_pilot_round_flight_group}
				{/if}
				<tr style="background-color: {$groupcolor};">
					<td style="background-color: lightgrey;">{$num}</td>
					<td>
						{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
							<div class="pilot_bib_number">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
						{/if}
					</td>
					<td style="background-color: #9DCFF0;" nowrap>
						{if $event->pilots.$event_pilot_id.country_code}<img src="/images/flags/countries-iso/shiny/16/{$event->pilots.$event_pilot_id.country_code|escape}.png" class="inline_flag" title="{$event->pilots.$event_pilot_id.country_name}">{/if}
						{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}
					</td>
					<td>{$event->pilots.$event_pilot_id.pilot_fai}</td>
						{if $f.flight_type_group}
							<td align="center" nowrap>{$p.event_pilot_round_flight_group|escape}</td>					
							{if preg_match("/^f3f/",$ft.flight_type_code) || $ft.flight_type_code=='f3b_speed' || $ft.flight_type_code=='f3b_speed_only'}
								<td align="center" nowrap>{$p.event_pilot_round_flight_order|escape}</td>					
							{/if}
						{else}
							<td align="center" nowrap>{$p.event_pilot_round_flight_order|escape}</td>					
						{/if}
						{if $f.flight_type_minutes || $f.flight_type_seconds}
							<td align="right" nowrap>
								{if $f.flight_type_minutes}
									{$p.event_pilot_round_flight_minutes|escape}m
								{/if}
								{if $f.flight_type_seconds}
									{$p.event_pilot_round_flight_seconds|escape}s
								{/if}
								{if $f.flight_type_over_penalty}
									<input type="checkbox" tabindex="{$tabindex}" name="pilot_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$f.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if}>
								{/if}
							</td>
						{/if}
						{if $f.flight_type_landing}
							<td align="center" nowrap>{$p.event_pilot_round_flight_landing|escape}</td>
						{/if}
						{if $f.flight_type_laps}
							<td align="center" nowrap>{$p.event_pilot_round_flight_laps|escape}</td>
						{/if}
						<td align="right" nowrap>
							{if $f.flight_type_code=='f3f_speed' OR $f.flight_type_code=='f3b_speed'}
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
				</tr>
				{$num=$num+1}
				{/foreach}
			{/foreach}
			{/if}
		{/foreach}
		</table>

		<!-- Lets make a signture line -->
		<br><br><br>
		<table width="100%">
			<tr>
				<td height="20" width="5%" nowrap><b>Signature :</b></td>
				<td height="20" width="60%" style="border-bottom: 2px solid black;"> &nbsp;</td>
				<td height="20" width="5%" nowrap><b>Date :</b></td>
				<td height="20" style="border-bottom: 2px solid black;"> &nbsp;</td>
			</tr>
		</table>
		{if !$r@last && $one_per_page==1}
			<br style="page-break-after: always;">
		{/if}


		{/if}
	{/foreach}
	</div>
</div>
{/block}