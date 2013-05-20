<div class="page type-page clearfix post nodate"  style="-webkit-print-color-adjust:exact;">
	<div class="entry clearfix">
		{$number=1}
		{foreach $event->pilots as $p}
			{$event_pilot_id=$p@key}
			{foreach $event->rounds as $r}
				{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to  || $r.flights.$flight_type_id.event_round_flight_score==0}
					{continue}
				{/if}
				{$event_round_number=$r.event_round_number}
				<span style="margin:10px;">
				<table align="left" height="220" width="220" cellpadding="2" cellspacing="2" style="border: 1px solid black;font-size:14;margin:10px;">
				<tr bgcolor="lightgrey">
					<th colspan="2" align="left" style="font-size:10;">
						{$event->info.event_name} - {$event->info.event_start_date|date_format:"%Y-%m-%d"}
					</th>
				</tr>
				<tr bgcolor="lightgrey">
					<th colspan="2">{$event->flight_types.$flight_type_id.flight_type_name} - Round {$event_round_number}</th>
				</tr>
				<tr>
					<th width="80" align="right" nowrap bgcolor="lightgrey">Pilot</th>
					<td><b>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</b></td>
				</tr>
				<tr>
					<th width="80" align="right" nowrap bgcolor="lightgrey">Flight Group</th>
					<td><b>{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_group}</b></td>
				</tr>
				<tr>
					<th width="80" align="right" nowrap bgcolor="lightgrey">Flight Time</th>
					<td style="border: 1px solid black;">&nbsp;</td>
				</tr>
				<tr>
					<th align="right" bgcolor="lightgrey">Landing</th>
					<td style="border: 1px solid black;">&nbsp;</td>
				</tr>
				<tr>
					<th align="right" nowrap>Pilot Sig</th>
					<td style="border: 1px solid black;">&nbsp;</td>
				</tr>
				<tr>
					<th align="right" nowrap>Timer Sig</th>
					<td style="border: 1px solid black;">&nbsp;</td>
				</tr>
				</table>
				</span>
				{if $number is div by 4}<div style="{if $number is div by 12}page-break-after: always;{/if}"></div>{/if}
				{$number=$number+1}
			{/foreach}
		{/foreach}
	</div>
</div>
