		<table>
		<tr>
		
		{$number=1}
		{foreach $event->pilots as $p}
			{$event_pilot_id=$p@key}
			{foreach $event->rounds as $r}
				{if $event->info.event_type_code=="f3k"}
					{$flight_type_id=$r.flight_type_id}
				{/if}
				{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to  || $r.flights.$flight_type_id.event_round_flight_score==0}
					{continue}
				{/if}
				{$event_round_number=$r.event_round_number}
				
			<td>
				
				<table align="left" height="220" width="220" cellpadding="2" cellspacing="2" style="border: 1px solid black;font-size:{if $print_format=="pdf"}8{else}12{/if};margin:10px;">
				<tr bgcolor="lightgrey">
					<th colspan="4" align="left" style="font-size:{if $print_format=="pdf"}8{else}10{/if};">
						{$event->info.event_name} - {$event->info.event_start_date|date_format:"%Y-%m-%d"}
					</th>
				</tr>
				<tr bgcolor="lightgrey">
					<th colspan="4">{$event->flight_types.$flight_type_id.flight_type_name} - Round {$event_round_number}</th>
				</tr>
				<tr>
					<th width="80" align="right" nowrap bgcolor="lightgrey">Pilot</th>
					<td colspan="3">
						{if $p.event_pilot_bib!='' && $p.event_pilot_bib!=0}
							<div class="pilot_bib_number_print">{$p.event_pilot_bib}</div>
							&nbsp;
						{/if}
						<b>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</b>
					</td>
				</tr>
				<tr>
					<th width="80" align="right" nowrap bgcolor="lightgrey">Flight Group</th>
					<td align="center">
						<font size="+1"><b>{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_group}</b></font>
					</td>
					{if $event->info.event_type_code!='f3k'}
					<th align="right" nowrap bgcolor="lightgrey">
						{if $event->flight_types.$flight_type_id.flight_type_code=="f3b_duration"
							|| $event->flight_types.$flight_type_id.flight_type_code=="td_duration"
						}
							Spot
						{elseif $event->flight_types.$flight_type_id.flight_type_code=="f3b_distance"
							|| $event->flight_types.$flight_type_id.flight_type_code=="f3j_duration"
						}
							Lane
						{/if}
					</th>
					<td align="center">
						<font size="+1"><b>{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_lane}</b></font>
					</td>
					{/if}
				</tr>
				<tr>
					<th width="80" align="right" nowrap bgcolor="lightgrey">Flight Time</th>
					<td  colspan="3"style="border: 1px solid black;">&nbsp;</td>
				</tr>
				<tr>
					<th align="right" bgcolor="lightgrey">Landing</th>
					<td  colspan="3"style="border: 1px solid black;">&nbsp;</td>
				</tr>
				<tr>
					<th align="right" nowrap>Pilot Sig</th>
					<td  colspan="3"style="border: 1px solid black;">&nbsp;</td>
				</tr>
				<tr>
					<th align="right" nowrap>Timer Sig</th>
					<td  colspan="3"style="border: 1px solid black;">&nbsp;</td>
				</tr>
				</table>

			</td>

			{if $number is div by 12}
				</tr>
				</table>
				{if $print_format=='html'}
					<div style="{if $number is div by 12}page-break-after: always;{/if}"></div>
				{/if}
				<table>
				<tr>
			{else}
				{if $number is div by 4}
					</tr>
					<tr>
				{/if}
			{/if}
			{$number=$number+1}
			{/foreach}
		{/foreach}
		</tr>
		</table>
