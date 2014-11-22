<table>
<tr>
	{$number=1}
	{foreach $event->pilots as $p}
		{$event_pilot_id=$p.event_pilot_id}
		{foreach $event->rounds as $r}
			{if $event->info.event_type_code=="f3k"}
				{$flight_type_id=$r.flight_type_id}
			{/if}
			{if $r.event_round_number<$print_round_from || $r.event_round_number>$print_round_to  || $r.flights.$flight_type_id.event_round_flight_score==0}
				{continue}
			{/if}
			{$event_round_number=$r.event_round_number}
			
		<td>
			
			<table align="left" height="290" width="300" cellpadding="2" cellspacing="2" style="border: 1px solid black;font-size:{if $print_format=="pdf"}8{else}12{/if};margin:10px;">
			<tr bgcolor="lightgrey">
				<th colspan="4" align="left" style="font-size:{if $print_format=="pdf"}8{else}10{/if};">
					{$event->info.event_name} - {$event->info.event_start_date|date_format:"%Y-%m-%d"}
				</th>
			</tr>
			<tr bgcolor="lightgrey">
				<th colspan="4"><font size="+1"><b>Round {$event_round_number}</b></font></th>
			</tr>
			<tr>
				<th width="50" height="30" align="center" nowrap bgcolor="lightgrey">Pilot</th>
				<td width="100" height="30">
					<b>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</b>
				</td>
				<th width="60" height="30" align="center" nowrap bgcolor="lightgrey">Group</th>
				<td height="30" align="center">
					<font size="+1"><b>{$event->rounds.$event_round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_group}</b></font>
				</td>
			</tr>
			<tr>
				<th colspan="4" align="center" nowrap bgcolor="lightgrey">{$event->flight_types.$flight_type_id.flight_type_name}</th>
			</tr>
			{$subs=$event->flight_types.$flight_type_id.subs}
			{$num_subs=$event->flight_types.$flight_type_id.flight_type_sub_flights}
			<tr>
				<td height="5" colspan="4" align="center">
				<table cellspacing="3" cellpadding="2">
				<tr>
					{foreach $subs as $i}
					<td width="60" height="5" align="center" style="font-size: 10;">{$i}</td>
					{/foreach}
				</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
				<table cellspacing="3" cellpadding="2">
				<tr>
					{for $i=1 to $num_subs}
					<td width="60" height="40" style="border: 1px solid black;"> &nbsp</td>
					{/for}
				</tr>
				</table>
				</td>
			</tr>
			<tr>
				<th bgcolor="lightgrey" height="20" align="right" nowrap>
					Penalty
				</th>
				<td>
					<table>
					<tr>
					<td height="25" width="50" style="border: 1px solid black;"> &nbsp;</td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<table style="font-size:{if $print_format=="pdf"}8{else}12{/if};margin:0px;">
					<tr>
					<th bgcolor="lightgrey" height="20" align="right" nowrap>Pilot Sig</th>
					<td height="20" width="80" style="border: 1px solid black;"> &nbsp;</td>
					<th bgcolor="lightgrey" height="20" align="right" nowrap>Timer Sig</th>
					<td height="20" width="80" style="border: 1px solid black;"> &nbsp;</td>
					</tr>
					</table>
				</td>
			</tr>
			</table>
	
		</td>
	
		{if $number is div by 6}
			</tr>
			</table>
			{if $print_format=='html'}
				<div style="{if $number is div by 6}page-break-after: always;{/if}"></div>
			{/if}
			<table>
			<tr>
		{else}
			{if $number is div by 3}
				</tr>
				<tr>
			{/if}
		{/if}
		{$number=$number+1}
		{/foreach}
	{/foreach}
</tr>
</table>
