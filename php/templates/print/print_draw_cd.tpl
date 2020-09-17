{extends file='layout/layout_print.tpl'}

{block name="content"}

{include file='print/print_draw_header.tpl'}
		{$num_rounds_printed=0}
		{foreach $event->rounds as $r}
		{if $event->info.event_type_code=="f3k"}
			{$flight_type_id=$r.flight_type_id}
		{/if}
		{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to || ! $r.flights.$flight_type_id}
			{continue}
		{/if}
		{$num_rounds_printed=$num_rounds_printed+1}
		{$total_rows=1}
		<h2 class="post-title entry-title" style="margin:0px;">CD Recording Sheet - {$event->flight_types.$flight_type_id.flight_type_name}</h2>		
		<table width="600" cellpadding="2" cellspacing="1" 
			style="border: 1px solid black;
				{if ($event->info.event_type_code=='f3f' || $event->info.event_type_code=='f3b_speed' || $event->info.event_type_code=='f3f_plus') && $event->pilots|count<=20}
					{* We want to skip every other round for a new page to have two on a page *}
					{if $num_rounds_printed is div by 2}
						{if $r.event_round_number!=$print_round_to}
						page-break-after: always;
						{/if}
					{/if}
				{else}
						{if $r.event_round_number!=$print_round_to}page-break-after: always;{/if}
				{/if}
				">
		<tr bgcolor="lightgray">
			<th width="60">Round</th>
			{if $event->flight_types.$flight_type_id.flight_type_group && $event->flight_types.$flight_type_id.flight_type_code!='f3f_speed'}
				<th width="60">Group</th>
			{else}
				<th width="60">Order</th>
			{/if}
			<th width="200" align="left">Pilot</th>
			
			{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' 
				|| $event->flight_types.$flight_type_id.flight_type_code=='td_duration'}
				<th>Spot</th>
			{elseif $event->flight_types.$flight_type_id.flight_type_code=='f3b_distance'
				|| $event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'
				|| $event->flight_types.$flight_type_id.flight_type_code=='f5j_duration'}
				<th>Lane</th>
			{/if}

			{if $event->flight_types.$flight_type_id.flight_type_seconds}
				<th width="100">Time</th>
			{/if}
			{if $event->info.event_type_code=="f3j"}
				<th width="20">Over</th>
			{/if}
			{if $event->info.event_type_code=="f5j"}
				<th width="60">Start Height</th>
			{/if}
			{if $event->flight_types.$flight_type_id.flight_type_landing}
				<th width="100">Landing</th>
			{/if}
			{if $event->flight_types.$flight_type_id.flight_type_laps}
				<th width="100">Laps</th>
			{/if}
			{if $event->info.event_type_code=="gps"}
				<th width="100">Start Penalty</th>
			{/if}
			<th width="100">Penalty</th>
		</tr>
		{$oldgroup='1000'}
		{$bottom=0}
		{foreach $r.flights.$flight_type_id.pilots as $p}
		{$event_pilot_id=$p@key}
		{if $oldgroup!=$p.event_pilot_round_flight_group}
			{if $bgcolor=='white' || $r.flights.$flight_type_id.flight_type_code=='f3b_speed' || $r.flights.$flight_type_id.flight_type_code=='f3f_speed' || $r.flights.$flight_type_id.flight_type_code=='f3f_plus'}
				{$bgcolor='lightgray'}
			{else}
				{$bgcolor='white'}
			{/if}
			{$bottom=1}
		{/if}
		<tr>
			<td align="center" {if $p@first}style="border-top: 2px solid black;"{/if}>{if $p@first}{$r.event_round_number}{/if}</td>
			{if $event->info.event_type_code=="gps" && $oldgroup!=$p.event_pilot_round_flight_group}
				<th colspan="2" style="height: 30px;">Window Date/Time</th>
				<td style="border: 1px solid black;{if $bottom}border-top: 2px solid black;{/if}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/ </td>
				<td style="border: 1px solid black;{if $bottom}border-top: 2px solid black;{/if}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </td>
			</tr>
			<tr>
				<td></td>
			{/if}

			{if $event->flight_types.$flight_type_id.flight_type_group && $event->flight_types.$flight_type_id.flight_type_code!='f3f_speed' && $event->flight_types.$flight_type_id.flight_type_code!='f3f_plus'}
				<td align="center" bgcolor="{$bgcolor}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$p.event_pilot_round_flight_group}</td>
			{else}
				<td align="center" bgcolor="{$bgcolor}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$p.event_pilot_round_flight_order}</td>
			{/if}
			<td align="left" bgcolor="{$bgcolor}" {if $bottom}style="border-top: 2px solid black;"{/if}>
				{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
					<div class="pilot_bib_number_print">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
					&nbsp;
				{/if}
				{$event->pilots.$event_pilot_id.pilot_first_name} {$event->pilots.$event_pilot_id.pilot_last_name}
			</td>

			{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' 
				|| $event->flight_types.$flight_type_id.flight_type_code=='td_duration'
				|| $event->flight_types.$flight_type_id.flight_type_code=='f3b_distance'
				|| $event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'
				|| $event->flight_types.$flight_type_id.flight_type_code=='f5j_duration'
			}
				<td align="center" bgcolor="{$bgcolor}" {if $bottom}style="border-top: 2px solid black;"{/if}>{$p.event_pilot_round_flight_lane}</td>
			{/if}

			{if $event->flight_types.$flight_type_id.flight_type_seconds}
				<td style="border: 1px solid black;{if $bottom}border-top: 2px solid black;{/if}">&nbsp;</td>
			{/if}
			{if $event->info.event_type_code=="f3j"}
				<th width="20" style="border: 1px solid black;{if $bottom}border-top: 2px solid black;{/if}"><input type="checkbox" name="box"></th>
			{/if}
			{if $event->flight_types.$flight_type_id.flight_type_start_height}
				<td style="border: 1px solid black;{if $bottom}border-top: 2px solid black;{/if}">&nbsp;</td>
			{/if}
			{if $event->flight_types.$flight_type_id.flight_type_landing}
				<td style="border: 1px solid black;{if $bottom}border-top: 2px solid black;{/if}">&nbsp;</td>
			{/if}
			{if $event->flight_types.$flight_type_id.flight_type_laps}
				<td style="border: 1px solid black;{if $bottom}border-top: 2px solid black;{/if}">&nbsp;</td>
			{/if}
			{if $event->info.event_type_code=="gps"}
				<td style="border: 1px solid black;{if $bottom}border-top: 2px solid black;{/if}">&nbsp;</td>
			{/if}
			<td style="border: 1px solid black;{if $bottom}border-top: 2px solid black;{/if}">&nbsp;</td>
		</tr>
		{$total_rows=$total_rows+1}
		{$oldgroup=$p.event_pilot_round_flight_group}
		{$bottom=0}
		{/foreach}
		{if $r.flights.$flight_type_id.flight_type_reflight==1}
		{for $var=1 to (40-$total_rows)}
		<tr>
			<td align="center">{if $var==1}Reflights{/if}</td>
			<td align="center" style="border-bottom: 1px solid black;">&nbsp;</td>
			<td align="left" style="border-bottom: 1px solid black;">&nbsp;</td>
			{if $event->flight_types.$flight_type_id.flight_type_code=='f3b_duration' 
				|| $event->flight_types.$flight_type_id.flight_type_code=='td_duration'
				|| $event->flight_types.$flight_type_id.flight_type_code=='f3b_distance'
				|| $event->flight_types.$flight_type_id.flight_type_code=='f3j_duration'
				|| $event->flight_types.$flight_type_id.flight_type_code=='f5j_duration'
			}
				<td align="center" style="border-bottom: 1px solid black;">&nbsp;</td>
			{/if}
			{if $event->flight_types.$flight_type_id.flight_type_seconds}
				<td style="border: 1px solid black;">&nbsp;</td>
			{/if}
			{if $event->info.event_type_code=="f3j"}
				<th width="20"><input type="checkbox" name="box"></th>
			{/if}
			{if $event->flight_types.$flight_type_id.flight_type_start_height}
				<td style="border: 1px solid black;">&nbsp;</td>
			{/if}
			{if $event->flight_types.$flight_type_id.flight_type_landing}
				<td style="border: 1px solid black;">&nbsp;</td>
			{/if}
			{if $event->flight_types.$flight_type_id.flight_type_laps}
				<td style="border: 1px solid black;">&nbsp;</td>
			{/if}
			<td style="border: 1px solid black;">&nbsp;</td>
		</tr>
		{/for}
		{/if}
		</table>
		{/foreach}
{/block}
