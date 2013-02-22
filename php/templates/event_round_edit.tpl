<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Settings - {$event.event_name} <input type="button" value=" Edit Event Parameters " onClick="document.event_edit.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event.event_start_date|date_format:"%Y-%m-%d"} to {$event.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th align="right">Location</th>
			<td>
			{$event.location_name} - {$event.location_city},{$event.state_code} {$event.country_code}
			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			{$event.event_type_name}
			</td>
			<th align="right">Event Contest Director</th>
			<td>
			{$event.pilot_first_name} {$event.pilot_last_name} - {$event.pilot_city}
			</td>
		</tr>
		</table>
		
	</div>
		<br>
		<form name="main" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_round_save">
		<input type="hidden" name="event_id" value="{$event.event_id}">
		<input type="hidden" name="event_round_id" value="{$round.event_round_id}">
		
		<h1 class="post-title entry-title">Event Round Edit</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" nowrap>Event Round Number</th>
			<td>
				{$round_number}
				<input type="hidden" name="event_round_number" value="{$round_number}">
			</td>
		</tr>
		<tr>
			<th>Event Round Type</th>
			<td>
				{if $event.event_type_flight_choice==1}
					<select name="flight_type_id">
					{foreach $flight_types as $ft}
					<option value="{$ft.flight_type_id}" {if $ft.flight_type_id==$round.flight_type_id}SELECTED{/if}>{$ft.flight_type_name}</option>
					{/foreach}
					</select>
				{else}
					{foreach $flight_types as $ft}
						{$ft.flight_type_name}{if $ft.flight_type_landing} + Landing{/if}{if !$ft@last},&nbsp;{/if}
					{/foreach}
					<input type="hidden" name="flight_type_id" value="0">
				{/if}
				&nbsp;&nbsp;
				{if $event.event_type_time_choice==1}
					Max Flight Time : <input type="text" size="5" name="event_round_time_choice" value="{$round.event_round_time_choice}"> Minutes
				{else}
					<input type="hidden" name="event_round_time_choice" value="0">
				{/if}
			</td>
		</tr>		
		</table>
		
		<h1 class="post-title entry-title">Round Flights</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th colspan="2">&nbsp;</th>
			{foreach $flight_types as $ft}
				{if $event.event_type_flight_choice==1 AND $ft.flight_type_id!=$round.flight_type_id}
					{continue}
				{/if}
				<th colspan="{if $ft.flight_type_landing}6{else}5{/if}">{$ft.flight_type_name}</th>
			{/foreach}
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th align="left">Pilot Name</th>
			{foreach $flight_types as $ft}
				{if $event.event_type_flight_choice==1 AND $ft.flight_type_id!=$round.flight_type_id}
					{continue}
				{/if}
				{if $ft.flight_type_group}
					<th align="center">Gr</th>
				{/if}
				{if $ft.flight_type_minutes || $ft.flight_type_seconds}
					<th align="center">Time</th>
				{/if}
				{if $ft.flight_type_landing}
					<th align="center">Land</th>
				{/if}
				{if $ft.flight_type_laps}
					<th align="center">Laps</th>
				{/if}
				<th align="center">Raw</th>
				<th align="center">Score</th>
				<th align="center">Pen</th>
			{/foreach}
		</tr>
		{assign var=num value=1}
		{foreach $round.pilot as $p}
		<tr>
			<td>{$num}</td>
			<td>{$p.pilot_first_name} {$p.pilot_last_name}</td>
			{assign var=bg value='white'}
			{foreach $p.flight as $f}
				{assign var=tab value=1}
				{if $event.event_type_flight_choice==1 AND $f.flight_type_id!=$round.flight_type_id}
					{continue}
				{/if}
				{if $bg=='white'}
					{assign var=bg value='lightgrey'}
				{else}
					{assign var=bg value='lightgrey'}
				{/if}
				{if $f.flight_type_group}
					<td bgcolor="{$bg}" align="center" nowrap><input tabindex="" autocomplete="off" type="text" size="1" style="width:10px;" name="pilot_group_{$p.event_pilot_id}_{$f.flight_type_id}" value="{$f.event_round_flight_group}"></td>					
				{/if}
				{if $f.flight_type_minutes || $f.flight_type_seconds}
					<td bgcolor="{$bg}" align="center" nowrap>
						{if $f.flight_type_minutes}<input tabindex="{$num+$tab}" autocomplete="off" type="text" size="2" style="width:15px;text-align: right;" name="pilot_min_{$p.event_pilot_id}_{$f.flight_type_id}" value="{$f.event_round_flight_minutes}">m{/if}
						{if $f.flight_type_seconds}
							{if $f.flight_type_code=='f3f_speed' OR $f.flight_type_code=='f3b_speed'}
							<input tabindex="{$num+$tab}" autocomplete="off" type="text" size="6" style="width:40px;text-align: right;" name="pilot_sec_{$p.event_pilot_id}_{$f.flight_type_id}" value="{if $f.event_round_flight_seconds!=0}{$f.event_round_flight_seconds}{/if}">s
							{else}
							<input tabindex="{$num+$tab}" autocomplete="off" type="text" size="6" style="width:20px;" name="pilot_sec_{$p.event_pilot_id}_{$f.flight_type_id}" value="{$f.event_round_flight_seconds|string_format:"%02.0f"}">s
							{/if}
						{/if}
					</td>
				{/if}
				{if $f.flight_type_landing}
					<td bgcolor="{$bg}" align="center" nowrap><input tabindex="{$num+$tab}" autocomplete="off" type="text" size="2" style="width:25px;text-align: right;" name="pilot_land_{$p.event_pilot_id}_{$f.flight_type_id}" value="{$f.event_round_flight_landing}"></td>
				{/if}
				{if $f.flight_type_laps}
					<td bgcolor="{$bg}" align="center" nowrap><input tabindex="{$num+$tab}" autocomplete="off" type="text" size="2" style="width:15px;" name="pilot_laps_{$p.event_pilot_id}_{$f.flight_type_id}" value="{$f.event_round_flight_laps}"></td>
				{/if}
				<td bgcolor="{$bg}" align="right" nowrap>
					{if $f.flight_type_code=='f3f_speed' OR $f.flight_type_code=='f3b_speed'}
					{$f.event_round_flight_raw_score}
					{else}
					{$f.event_round_flight_raw_score|string_format:"%02.0f"}
					{/if}
				</td>
				<td bgcolor="{$bg}" align="right" nowrap>
				{$f.event_round_flight_score}
				</td>
				<td bgcolor="{$bg}" align="center" nowrap>
					<input tabindex="{$num+$tab}" autocomplete="off" type="text" size="4" style="width:25px;text-align: right;" name="pilot_pen_{$p.event_pilot_id}_{$f.flight_type_id}" value="{if $f.event_round_flight_penalty!=0}{$f.event_round_flight_penalty}{/if}">
				</td>
				{assign var=tab value=$tab+1000}
			{/foreach}
		</tr>
		{assign var=num value=$num+1}
		{/foreach}
		</table>
		
		</form>
<br>
<input type="button" value=" Save and Calculate Event Round " onClick="main.submit();" class="block-button">
<input type="button" value=" Back To Event " onClick="goback.submit();" class="block-button">
</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event.event_id}">
</form>
