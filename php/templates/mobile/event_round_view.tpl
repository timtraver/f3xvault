<link href="style2.css" rel="stylesheet" type="text/css">
<div class="page type-page status-publish hentry clearfix post nodate" style="overflow: auto;">
	<div class="entry clearfix" style="overflow: auto;">                
		<h1 class="post-title entry-title">{$event->info.event_name|escape}</h1>
		<div class="entry-content clearfix" style="overflow: auto;">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder" style="overflow:auto;">
		<tr>
			<th width="20%" align="right">Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"}{if $event->info.event_end_date!=$event->info.event_start_date} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}{/if}
			</td>
		</tr>
		<tr>
			<th align="right">Location</th>
			<td>
			<a href="?action=location&function=location_view&location_id={$event->info.location_id}">{$event->info.location_name|escape} - {$event->info.state_code|escape} {$event->info.country_code|escape}</a>
			</td>
		</tr>
		<tr>
			<th align="right">Type</th>
			<td>
			{$event->info.event_type_name|escape}
			</td>
		</tr>
		<tr>
			<th align="right">CD</th>
			<td>
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape}
			</td>
		</tr>
		{if $event->info.series_name || $event->info.club_name}
		<tr>
			<th align="right">Series</th>
			<td>
			<a href="?action=series&function=series_view&series_id={$event->info.series_id}">{$event->info.series_name|escape}</a>
			</td>
		</tr>
		<tr>
			<th align="right">Club</th>
			<td>
			<a href="?action=club&function=club_view&club_id={$event->info.club_id}">{$event->info.club_name|escape}</a>
			</td>
		</tr>
		{/if}
		</table>
		<input type="button" value=" Back To Event " onClick="goback.submit();" class="block-button">

		</div>
		
		<br>
		<form name="main" method="POST" style="overflow:auto;">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_round_save">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="event_round_id" value="{$event_round_id}">
		<input type="hidden" name="event_round_number" value="{$round_number}">
		<input type="hidden" name="create_new_round" value="0">

		<h1 class="post-title entry-title">Event Round {$round_number|escape} Detail</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder" style="overflow:auto;">
		<tr>
			<th width="20%" nowrap>Round Type</th>
			<td>
				{if $event->info.event_type_flight_choice==1}
					<select name="flight_type_id">
					{foreach $flight_types as $ft}
					<option value="{$ft.flight_type_id}" {if $ft.flight_type_id==$event->rounds.$round_number.flight_type_id}SELECTED{/if}>{$ft.flight_type_name|escape}</option>
					{/foreach}
					</select>
				{else}
					{foreach $flight_types as $ft}
						{$ft.flight_type_name|escape}{if $ft.flight_type_landing} + Landing{/if}{if !$ft@last},&nbsp;{/if}
					{/foreach}
					<input type="hidden" name="flight_type_id" value="0">
				{/if}
			</td>
		</tr>
		{if $event->info.event_type_time_choice==1}
		<tr>
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
		</tr>
		{/if}
		<tr>
			<th nowrap>Sort By</th>
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
		</tr>
		<tr>
			<th>Include Round In Results</th>
			<td align="left">
				<input type="checkbox" name="event_round_score_status"{if $event->rounds.$round_number.event_round_score_status==1} CHECKED{/if}>
			</td>
		</tr>
		{if $event->info.event_type_flyoff==1}
		<tr>
			<th nowrap>Round Flyoff Number</th>
			<td>
				{$event->rounds.$round_number.event_round_flyoff}
			</td>
		</tr>
		{/if}
		</table>
		<br>
		
		<h1 class="post-title entry-title">Round Flights</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder" style="overflow:auto;">
		{$tabindex=2}
		{foreach $flight_types as $ft}
			{$flight_type_id=$ft.flight_type_id}
			{if $event->info.event_type_flight_choice==1 AND $ft.flight_type_id!=$event->rounds.$round_number.flight_type_id}
				{continue}
			{/if}
			{$cols=4}
			{if $ft.flight_type_seconds}{$cols=$cols+1}{/if}
			{if $ft.flight_type_landing}{$cols=$cols+1}{/if}
			{if $ft.flight_type_laps}{$cols=$cols+1}{/if}
			<tr>
				<th colspan="2">Round {$round_number|escape}</th>
				<th colspan="{$cols}">
					{$ft.flight_type_name|escape}
				</th>
				<th>
					Score <input type="checkbox" name="event_round_flight_score_{$ft.flight_type_id}"{if $event->rounds.$round_number.flights.$flight_type_id.event_round_flight_score==1 || $event_round_id==0 || empty($event->rounds.$round_number.flights.$flight_type_id)} CHECKED{/if}>
				</th>
			</tr>
			<tr>
				<th width="2%" align="left"></th>
				<th align="left">Pilot</th>
				{if $ft.flight_type_group}
					<th align="center">Grp</th>
				{else}
					<th align="center">Ord</th>
				{/if}
				{if $ft.flight_type_minutes || $ft.flight_type_seconds}
					<th align="center">Time{if $ft.flight_type_sub_flights!=0}s{/if}{if $ft.flight_type_over_penalty}/Over{/if}</th>
				{/if}
				{if $ft.flight_type_landing}
					<th align="center">Landing</th>
				{/if}
				{if $ft.flight_type_laps}
					<th align="center">Laps</th>
				{/if}
				<th align="center">Score</th>
				<th align="center">Pen</th>
				<th align="center">Rank</th>
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
			<tr style="background-color: {$groupcolor};">
				<td style="background-color: lightgrey;">{$num}</td>
				<td nowrap>
					{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
						<div class="pilot_bib_number">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
					{/if}
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
								{for $sub=1 to $ft.flight_type_sub_flights}<input tabindex="{$tabindex}" autocomplete="off" type="text" size="4" style="width:35px;text-align: right;color:black;display: inline-block;" name="pilot_sub_flight_{$sub}_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.sub.$sub.event_pilot_round_flight_sub_val!='0:00'}{$p.sub.$sub.event_pilot_round_flight_sub_val|escape}{/if}" disabled> {if $sub!=$ft.flight_type_sub_flights},{/if}{$tabindex=$tabindex+1}{/for}= Total{/if}
							{if $ft.flight_type_minutes}
								{$p.event_pilot_round_flight_minutes|escape}m
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_seconds}
								{if $p.event_pilot_round_flight_dns==1}DNS{elseif $p.event_pilot_round_flight_dnf==1}DNF{else}{$p.event_pilot_round_flight_seconds|escape}{/if}s
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_over_penalty}
								<input type="checkbox" tabindex="{$tabindex}" name="pilot_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if} style="display: inline-block;" onChange="save_data(this);">
								{$tabindex=$tabindex+1}
							{/if}
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
									<input tabindex="{$tabindex}" autocomplete="off" type="text" size="4" style="width:35px;text-align: right;color: black;display: inline-block;" name="pilot_reflight_sub_flight_{$sub}_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.sub.$sub.event_pilot_round_flight_sub_val!='0:00'}{$p.sub.$sub.event_pilot_round_flight_sub_val|escape}{/if}" disabled> {if $sub!=$ft.flight_type_sub_flights},{/if} 
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
								<input type="checkbox" tabindex="{$tabindex}" name="pilot_reflight_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if} style="display: inline-block;">
								{$tabindex=$tabindex+1}
							{/if}
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
		{/foreach}
		</table>

		</form>
<br>
</div>

<form name="sort_round" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_round_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_round_id" value="{$event_round_id}">
<input type="hidden" name="sort_by" value="">
</form>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
