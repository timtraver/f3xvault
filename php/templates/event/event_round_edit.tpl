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
		<input type="hidden" name="add_reflight" value="0">
		<input type="hidden" name="reflight_flight_type_id" value="0">
		<input type="hidden" name="reflight_event_pilot_id" value="0">
		<input type="hidden" name="reflight_group" value="">

		<h2 class="post-title entry-title">Event Round 
			{$prev=$round_number-1}
			{$next=$round_number+1}
			{if $event->rounds.$prev}
			<a href="?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$event->rounds.$prev.event_round_id}&sort_by={$sort_by|escape}"><img src="/images/arrow-left.png" style="vertical-align:text-bottom;"></a>
			{/if}
			{$round_number|escape}
			{if $event->rounds.$next}
			<a href="?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$event->rounds.$next.event_round_id}&sort_by={$sort_by|escape}"><img src="/images/arrow-right.png" style="vertical-align:text-bottom;"></a>
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
					<input type="text" size="2" name="event_round_time_choice" value="{$event->rounds.$round_number.event_round_time_choice}"> Minutes
				{else}
					<input type="hidden" name="event_round_time_choice" value="0">
				{/if}
			</td>
			{else}
			<th colspan="2">&nbsp;</th>
			{/if}
		</tr>
		<tr>
			<th nowrap{if $event->info.event_type_code=='td'} rowspan="2"{/if}>Event Round Sort By</th>
			<td{if $event->info.event_type_code=='td'} rowspan="2"{/if}>
				<select name="sort_by" onChange="document.sort_round.sort_by.value=document.main.sort_by.value; sort_round.submit();">
				<option value="round_rank"{if $sort_by=='round_rank'} SELECTED{/if}>Round Rank</option>
				<option value="entry_order"{if $sort_by=='entry_order'} SELECTED{/if}>Entry Order</option>
				<option value="bib_order"{if $sort_by=='bib_order'} SELECTED{/if}>Bib Order</option>
				<option value="flight_order"{if $sort_by=='flight_order'} SELECTED{/if}>Round Flight Order</option>
				<option value="current_standing"{if $sort_by=='current_standing'} SELECTED{/if}>Current Event Standing</option>
				<option value="group_alphabetical_first"{if $sort_by=='group_alphabetical_first'} SELECTED{/if}>Group, then Alphabetical Order - First Name</option>
				<option value="group_alphabetical_last"{if $sort_by=='group_alphabetical_last'} SELECTED{/if}>Group, then Alphabetical Order - Last Name</option>
				<option value="group_entry"{if $sort_by=='group_entry'} SELECTED{/if}>Group, then Entry Order</option>
				<option value="alphabetical_first"{if $sort_by=='alphabetical_first'} SELECTED{/if}>Alphabetical Order - First Name</option>
				<option value="alphabetical_last"{if $sort_by=='alphabetical_last'} SELECTED{/if}>Alphabetical Order - Last Name</option>
				</select>
			</td>
			{if $event->info.event_type_code=='td'}
				<th nowrap>Round Scoring Points</th>
				<td>
					<input type="text" size="3" name="event_round_score_second" value="{$event->rounds.$round_number.event_round_score_second|string_format:"%0.1f"}"> Points Per Second
				</td>
		</tr>
		<tr>
			{/if}
			
			<th nowrap>Include This Round In Final Results</th>
			<td align="left">
				<input type="checkbox" name="event_round_score_status"{if $event->rounds.$round_number.event_round_score_status==1} CHECKED{/if}>
			</td>
		</tr>
		
		
		{if $event->info.event_type_flyoff==1}
		<tr>
			<th nowrap>Flyoff Number</th>
			<td colspan="3">
				<input type="text" size="2" name="event_round_flyoff" value="{$event->rounds.$round_number.event_round_flyoff}"> Update this number if there will be multiple flyoff rounds or to 0 for normal round
			</td>
		</tr>
		{/if}
		</table>
		<div style="text-align: right;">
			<input type="button" value=" Save Event Round Info " onClick="if(check_permission()){ldelim}this.disabled=true;main.submit();{rdelim}" class="btn btn-primary btn-rounded">
			{if $event_round_id !=0 && $permission==1 && $event->rounds.$round_number.last_round==1}
				<input type="button" style="float: right;margin-left: 10px;" value=" Delete This Round " class="btn btn-danger btn-rounded" style="float: none;margin-left: 0;margin-right: auto;" onClick="return confirm('Are you sure you wish to delete this round?') && document.delete_round.submit();">
			{/if}
		</div>
		{$flight_type_id = $event->rounds.$round_number.flight_type_id}
		{if $event->info.event_type_code=='f3k' && $event_round_id==0 && !$event->rounds.$round_number.flights.$flight_type_id.pilots}
		</form>
		{else}
		
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
				<th colspan="{$cols - 2}">
					{$ft.flight_type_name|escape}
				</th>
				<th colspan="2">
					{if $self_entry}
						Self Score Locked <input type="checkbox" name="event_round_locked"{if $event->rounds.$round_number.event_round_locked==1} CHECKED{/if}
					{/if}
				</th>
				<th>
					Score <input type="checkbox" name="event_round_flight_score_{$ft.flight_type_id}"{if $event->rounds.$round_number.flights.$flight_type_id.event_round_flight_score==1 || $event_round_id==0 || empty($event->rounds.$round_number.flights.$flight_type_id)} CHECKED{/if}>
				</th>
				<th align="center" style="text-align: right;"></th>
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
					<th align="left" style="text-align: left;" nowrap>
						Time{if $ft.flight_type_sub_flights!=0}s{/if}{if $ft.flight_type_over_penalty}/Over{/if}
						{if $ft.flight_type_sub_flights!=0}<br>
							<div>
							{for $sub=1 to $ft.flight_type_sub_flights}
								<input type="text" size="10" style="width:{$ft.accuracy*20 + 30}px;height: 20px;text-align: right;background-color: lightgrey;" value="{if $ft.flight_type_code == "f3f_plus"}{if $sub == 1}Climb{else}Sub {$sub - 1|escape}{/if}{else}Sub {$sub|escape}{/if}" disabled> {if $sub!=$ft.flight_type_sub_flights},{/if}
							{/for}
							= Total
							{if $ft.flight_type_minutes}
								<input type="text" size="10" style="width:{$ft.accuracy*20 + 25}px;height: 20px;text-align: right;background-color: lightgrey;" value="" disabled>
							{/if}
							{if $ft.flight_type_seconds}
								<input type="text" size="10" style="width:{$ft.accuracy*20 + 25}px;height: 20px;text-align: right;background-color: lightgrey;" value="" disabled>
							{/if}
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
				<th align="center" style="text-align: right;">SE</th>
			</tr>
			{$num=1}
			{foreach $event->rounds.$round_number.flights as $f}
			{if $f@key!=$ft.flight_type_id}
				{continue}
			{/if}
			{$groupcolor="rgba(218, 237, 255, 0.97)"}
			{$oldgroup=''}
			{foreach $f.pilots as $p}
			{$event_pilot_id=$p@key}
			{if $oldgroup!=$p.event_pilot_round_flight_group}
				{if $groupcolor=='white'}{$groupcolor='rgba(218, 237, 255, 0.97)'}{else}{$groupcolor='white'}{/if}
				{$oldgroup=$p.event_pilot_round_flight_group|escape}
			{/if}
			{$time_disabled=0}
			<tr style="background-color: {$groupcolor};height: 20px;">
				<td style="background-color: lightgrey;">{$num}</td>
				<td valign="center" nowrap>
					{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
						<div class="pilot_bib_number" style="margin-right: 4px;">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
					{/if}
					{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}
				</td>
					{if $ft.flight_type_group}
						<td align="center" nowrap>
							<input tabindex="1" autocomplete="off" type="text" size="3" style="width:30px;height: 18px;" name="pilot_group_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_group|escape}" onChange="save_data(this);">
							<input type="hidden" name="pilot_lane_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_lane|escape}">
						</td>
					{/if}
					{if preg_match("/^f3f/",$ft.flight_type_code) || $ft.flight_type_code=='f3b_speed' || $ft.flight_type_code=='f3b_speed_only' || $ft.flight_type_code=='gps_speed'}
						<td align="center" nowrap><input tabindex="1" autocomplete="off" type="text" size="3" style="width:30px;height: 18px;" name="pilot_order_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_order|escape}" onChange="save_data(this);"></td>					
					{/if}
					{if $ft.flight_type_start_penalty}
						<td align="center" nowrap>
							<input tabindex="{$tabindex}" autocomplete="off" type="text" size="6" style="width:35px;height: 18px;" name="pilot_startpen_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_start_penalty|escape}" onChange="save_data(this);">
							{$tabindex=$tabindex+1}
						</td>
					{/if}
					{if $ft.flight_type_minutes || $ft.flight_type_seconds}
						<td align="left" nowrap>
							{if $ft.flight_type_sub_flights != 0}
								{if $ft.flight_type_code != 'f3f_plus'}{$time_disabled = 1}{/if}
								{for $sub=1 to $ft.flight_type_sub_flights}
									<input tabindex="{$tabindex}" autocomplete="off" type="text" size="10" style="width:{$ft.accuracy*20 + 30}px;height: 18px;text-align: right;" name="pilot_sub_flight_{$sub}_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.sub.$sub.event_pilot_round_flight_sub_val!='0:00'}{$p.sub.$sub.event_pilot_round_flight_sub_val|escape}{/if}" onChange="check_ladder(this);"> {if $sub!=$ft.flight_type_sub_flights},{/if} 
									{$tabindex=$tabindex+1}
								{/for}
								= Total
							{/if}
							{if $ft.flight_type_minutes}
								<input tabindex="{$tabindex}" autocomplete="off" type="text" size="3" style="width:25px;height: 18px;text-align: right;" name="pilot_min_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_minutes|escape}" onChange="save_data(this);" {if $time_disabled==1}disabled{/if}>m
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_seconds}
								<input tabindex="{$tabindex}" autocomplete="off" type="text" size="10" style="width:{$ft.accuracy*20 + 30}px;height: 18px;text-align: right;" name="pilot_sec_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.event_pilot_round_flight_dns==1}DNS{elseif $p.event_pilot_round_flight_dnf==1}DNF{else}{$p.event_pilot_round_flight_seconds|escape}{/if}" onChange="save_data(this);" {if $time_disabled==1}disabled{/if}>s
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_over_penalty}
								<input type="checkbox" tabindex="{$tabindex}" name="pilot_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if} onChange="save_data(this);">
								{$tabindex=$tabindex+1}
							{/if}
						</td>
					{/if}
					{if $ft.flight_type_landing}
						<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:35px;height: 18px;text-align: right;" name="pilot_land_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_landing|escape}" onChange="save_data(this);"></td>
						{$tabindex=$tabindex+1}
					{/if}
					{if $ft.flight_type_start_height}
						<td align="center" nowrap>
							<input tabindex="{$tabindex}" autocomplete="off" type="text" size="6" style="width:35px;height: 18px;" name="pilot_startheight_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_start_height|escape}" onChange="save_data(this);">
							{$tabindex=$tabindex+1}
						</td>
					{/if}
					{if $ft.flight_type_laps}
						<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:35px;height: 18px;text-align: right;" name="pilot_laps_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_laps|escape}" onChange="save_data(this);"></td>
						{$tabindex=$tabindex+1}
					{/if}
					{if $ft.flight_type_position}
						<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:35px;height: 18px;text-align: right;" name="pilot_position_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.event_pilot_round_flight_dns==1}DNS{elseif $p.event_pilot_round_flight_dnf==1}DNF{else}{$p.event_pilot_round_flight_position|escape}{/if}" onChange="save_data(this);"></td>
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
						<input tabindex="1000" autocomplete="off" type="text" size="4" style="width:35px;height: 18px;text-align: right;" name="pilot_pen_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty|escape}{/if}" onChange="save_data(this);">
					</td>
					<td align="right" nowrap>
					{$p.event_pilot_round_flight_rank|escape}
					</td>
					<td align="right" nowrap>
						{if $event->rounds.$round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_entered == 1}
							<img height="20" src="/images/icons/bullet_green.png" />
						{/if}
					</td>
			</tr>
			{$num=$num+1}
			{/foreach}
			{/foreach}
			{if $ft.flight_type_reflight==1}
			<tr>
			<th colspan="3">Reflights</th>
			<th colspan="8">
				<div class="btn-group btn-group-xs" style="float: right;"><button class="btn btn-primary btn-rounded" id="addreflight" type="button" onclick="document.reflight.flight_type_id.value={$ft.flight_type_id};$('#add_reflight').dialog('open');"> Add Reflight Entry </button></div>
			</th>
			</tr>
			{foreach $event->rounds.$round_number.reflights as $f}
				{if $f@key!=$ft.flight_type_id}
					{continue}
				{/if}
				{$groupcolor='rgba(218, 237, 255, 0.97)'}
				{$oldgroup=''}
				{foreach $f.pilots as $p}
				{$event_pilot_id=$p@key}
				{if $oldgroup!=$p.event_pilot_round_flight_group}
					{if $groupcolor=='white'}{$groupcolor='rgba(218, 237, 255, 0.97)'}{else}{$groupcolor='white'}{/if}
					{$oldgroup=$p.event_pilot_round_flight_group}
				{/if}
				<tr style="background-color: {$groupcolor};height: 20px;">
					<td style="background-color: lightgrey;">{$num}</td>
					<td style="background-color: white;" nowrap>
						{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
							<div class="pilot_bib_number" style="margin-right: 4px;height: 18px;">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
						{/if}
						{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}
					</td>
						{if $ft.flight_type_group}
							<td align="center" nowrap><input tabindex="1" autocomplete="off" type="text" size="2" style="width:30px;height: 18px;" name="pilot_reflight_group_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_group|escape}" onChange="save_data(this);"></td>
						{/if}				
						{if preg_match("/^f3f/",$ft.flight_type_code) || $ft.flight_type_code=='f3b_speed' || $ft.flight_type_code=='f3b_speed_only'}
							<td align="center" nowrap><input tabindex="1" autocomplete="off" type="text" size="2" style="width:30px;height: 18px;" name="pilot_reflight_order_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_order|escape}" onChange="save_data(this);"></td>					
						{/if}
						{if $ft.flight_type_minutes || $ft.flight_type_seconds}
						<td align="center" nowrap>
							{if $ft.flight_type_sub_flights!=0}
								{if $ft.flight_type_code != 'f3f_plus'}{$time_disabled = 1}{/if}
								{for $sub=1 to $ft.flight_type_sub_flights}
									<input tabindex="{$tabindex}" autocomplete="off" type="text" size="4" style="width:45px;height: 18px;text-align: right;" name="pilot_reflight_sub_flight_{$sub}_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.sub.$sub.event_pilot_round_flight_sub_val!='0:00'}{$p.sub.$sub.event_pilot_round_flight_sub_val|escape}{/if}" onChange="check_ladder(this);"> {if $sub!=$ft.flight_type_sub_flights},{/if} 
									{$tabindex=$tabindex+1}
								{/for}
								= Total
							{/if}
							{if $ft.flight_type_minutes}
								<input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:25px;height: 18px;text-align: right;" name="pilot_reflight_min_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_minutes|escape}" onChange="save_data(this);" {if $time_disabled==1}disabled{/if}>m
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_seconds}
								<input tabindex="{$tabindex}" autocomplete="off" type="text" size="6" style="width:{$ft.accuracy*20 + 30}px;height: 18px;text-align: right;" name="pilot_reflight_sec_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.event_pilot_round_flight_dns==1}DNS{elseif $p.event_pilot_round_flight_dnf==1}DNF{else}{$p.event_pilot_round_flight_seconds|escape}{/if}" onChange="save_data(this);" {if $time_disabled==1}disabled{/if}>s
								{$tabindex=$tabindex+1}
							{/if}
							{if $ft.flight_type_over_penalty}
								<input type="checkbox" tabindex="{$tabindex}" name="pilot_reflight_over_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}"{if $p.event_pilot_round_flight_over==1}CHECKED{/if} onChange="save_data(this);">
								{$tabindex=$tabindex+1}
							{/if}
						</td>
						{/if}
						{if $ft.flight_type_landing}
							<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:35px;height: 18px;text-align: right;" name="pilot_reflight_land_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_landing|escape}" onChange="save_data(this);"></td>
							{$tabindex=$tabindex+1}
						{/if}
						{if $ft.flight_type_start_height}
							<td align="center" nowrap>
								<input tabindex="{$tabindex}" autocomplete="off" type="text" size="6" style="width:35px;height: 18px;" name="pilot_reflight_startheight_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_start_height|escape}" onChange="save_data(this);">
								{$tabindex=$tabindex+1}
							</td>
						{/if}
						{if $ft.flight_type_laps}
							<td align="center" nowrap><input tabindex="{$tabindex}" autocomplete="off" type="text" size="2" style="width:25px;height: 18px;" name="pilot_reflight_laps_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{$p.event_pilot_round_flight_laps|escape}" onChange="save_data(this);"></td>
							{$tabindex=$tabindex+1}
						{/if}
						<td align="right" nowrap>
							{if preg_match("/^f3f/",$ft.flight_type_code) OR $ft.flight_type_code=='f3b_speed'}
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
							<input tabindex="1000" autocomplete="off" type="text" size="4" style="width:35px;height: 18px;text-align: right;" name="pilot_reflight_pen_{$p.event_pilot_round_flight_id}_{$event_pilot_id}_{$ft.flight_type_id}" value="{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty|escape}{/if}" onChange="save_data(this);">
						</td>
						<td align="right" nowrap>
						{$p.event_pilot_round_flight_rank|escape}
						</td>
						<td align="right" nowrap>
						<a href="?action=event&function=event_round_flight_delete&event_id={$event->info.event_id}&event_round_id={$event_round_id}&event_round_number={$round_number}&event_pilot_round_flight_id={$p.event_pilot_round_flight_id}" onClick="return confirm('Are you sure you wish to remove this pilot reflight?');"><img src="/images/icons/delete.png"></a>
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

		{if $event_round_id !=0 && $permission==1 && $event->rounds.$round_number.last_round==1}
		<input type="button" style="float: right;margin-left: 10px;" value=" Delete This Round " class="btn btn-danger btn-rounded" style="float: none;margin-left: 0;margin-right: auto;" onClick="return confirm('Are you sure you wish to delete this round?') && document.delete_round.submit();">
		{/if}
		<input type="button" style="float: right;margin-left: 10px;" value=" Back To Event " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
		<input type="button" style="float: right;margin-left: 10px;" value=" Print Round Detail " onClick="document.printround.submit();" class="btn btn-primary btn-rounded">
		<input type="button" style="float: right;margin-left: 10px;" value=" Save And Create New Round " onClick="if(check_permission()){ldelim}this.disabled=true;document.main.create_new_round.value=1;main.submit();{rdelim}" class="btn btn-primary btn-rounded">
		<input type="button" style="float: right;margin-left: 10px;" value=" Save Event Round " onClick="if(check_permission()){ldelim}this.disabled=true;main.submit();{rdelim}" class="btn btn-primary btn-rounded">
		<br>
		<br>
</div>

<div id="add_reflight" style="display: hidden;overflow: hidden;">
		<form name="reflight" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_round_add_reflight">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="event_round_id" value="{$event_round_id}">
		<input type="hidden" name="event_round_number" value="{$round_number|escape}">
		<input type="hidden" name="flight_type_id" value="">
		<input type="hidden" name="event_pilot_id" value="">
		<div style="float: left;padding-right: 10px;">
			<input type="text" name="group" size="2"><br>
			<span style="font-style: italic;color: grey;"> Group </span>
		</div>
		<div>
			<input id="pilot_name" type="text" name="pilot_name" size="30"><br>
			<img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
			<span id="search_message" style="font-style: italic;color: grey;"> Start typing to search pilots</span>
		</div>
		<br style="clear:both" />
		</form>
</div>

		{/if}

<form name="sort_round" method="GET" action="">
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

<form name="goback" method="GET" action="">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="tab" value="">
</form>

<form name="delete_round" method="GET" action="">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_round_delete">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="event_round_id" value="{$event_round_id}">
<input type="hidden" name="event_round_number" value="{$round_number|escape}">
</form>
{/block}
{block name="footer"}
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.dialog.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.button.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{$flight_type_id=$event->rounds.$round_number.flight_type_id}
{$flight_type_code=$flight_types.$flight_type_id.flight_type_code}
{$flight_type_subs=$flight_types.$flight_type_id.flight_type_sub_flights}
{if $flight_type_subs==''}{$flight_type_subs=0}{/if}
function save_data(element) {ldelim}
	var event_round_score_status=document.main.elements["event_round_score_status"].checked ? 1 : 0;
	{if $permission==1}
	$.ajax({ldelim}
		type: "POST",
		url: "/",
		data: {ldelim}
			action: "event",
			function: "save_individual_flight",
			event_id: "{$event->info.event_id}",
			event_round_id: "{$event_round_id}",
			event_round_number: "{$round_number|escape}",
			flight_type_id: document.main.flight_type_id.value,
			{if $event->info.event_type_time_choice==1}event_round_time_choice: document.main.event_round_time_choice.value,{/if}
			event_round_score_status: event_round_score_status,
			field_name: element.name,
			field_value: element.value
		{rdelim}
	{rdelim});
	{else}
		return;
	{/if}
{rdelim}
{if $event->info.event_type_code=='f3k'}
function check_ladder(element) {ldelim}
	var numsubs={$flight_type_subs};
	var reflight=0;
	if(element.name.substring(6, 14)=="reflight"){ldelim}
		var subnum=element.name.charAt(26);
		var subrest=element.name.substr(27);
		reflight=1;
	{rdelim}else{ldelim}
		var subnum=element.name.charAt(17);
		var subrest=element.name.substr(18);
	{rdelim}
	
	if(subnum != '1'){ldelim}
		return;
	{rdelim}
	{if $flight_type_code!='f3k_d'}
		return;
	{/if}
	var subval=element.value;
	var times = new Array("0:30","0:45","1:00","1:15","1:30","1:45","2:00");
	var times_alt = new Array("30","45","100","115","130","145","200");

	var i=times.indexOf(subval);
	var j=times_alt.indexOf(subval);
	if(i>0 || j>0){ldelim}
		// They entered an entry that matched the array and wasn't the first one
		var z=i;
		if(j>i){ldelim}z=j{rdelim}
		// Now lets step through the array and set the values to zero first
		for(x=1;x<=numsubs;x++){ldelim}
			if(reflight==1){ldelim}
				var fieldstring = "pilot_reflight_sub_flight_" + x + subrest;
			{rdelim}else{ldelim}
				var fieldstring = "pilot_sub_flight_" + x + subrest;
			{rdelim}
			document.main[fieldstring].value='';
		{rdelim}
		// Now lets populate up until the time that was entered
		for(x=1;x<=z+1;x++){ldelim}
			if(reflight==1){ldelim}
				var fieldstring = "pilot_reflight_sub_flight_" + x + subrest;
			{rdelim}else{ldelim}
				var fieldstring = "pilot_sub_flight_" + x + subrest;
			{rdelim}
			document.main[fieldstring].value=times[x-1];
		{rdelim}
		// Lets see if I can tab to the next row
		if(reflight==1){ldelim}
			var fieldstring = "pilot_reflight_sub_flight_" + numsubs + subrest;
		{rdelim}else{ldelim}
			var fieldstring = "pilot_sub_flight_" + numsubs + subrest;
		{rdelim}
		document.main[fieldstring].focus();
	{rdelim}
{rdelim}
{/if}
$(function() {ldelim}
	var pilots = [
		{foreach $event->pilots as $p}
		{ldelim}"id":{$p.event_pilot_id},"label":"{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}","value":"{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}"{rdelim}{if !$t@last},{/if}
		{/foreach}
	];
{literal}
	$( "#add_reflight" ).dialog({
		title: "Add A Pilot To A Reflight Group",
		autoOpen: false,
		height: 150,
		width: 350,
		modal: true,
		buttons: {
			"Add This Pilot": function() {
				this.disabled=true;
				document.main.add_reflight.value="1";
				document.main.reflight_flight_type_id.value=document.reflight.flight_type_id.value;
				document.main.reflight_group.value=document.reflight.group.value;
				document.main.reflight_event_pilot_id.value=document.reflight.event_pilot_id.value;
				$(this).dialog('close');
				document.main.submit();
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		},
		close: function() {
		}
	});
	$( "#addreflightoff" )
		.button()
		.click(function() {
		$( "#add_reflight" ).dialog( "open" );
		});
	$("#pilot_name").autocomplete({
		source: pilots,
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
			document.reflight.event_pilot_id.value = ui.item.id;
			var name=document.getElementById('pilot_name');
			document.reflight.pilot_name.value=name.value;
			document.main.add_reflight.value="1";
			document.main.reflight_flight_type_id.value=document.reflight.flight_type_id.value;
			document.main.reflight_group.value=document.reflight.group.value;
			document.main.reflight_event_pilot_id.value=document.reflight.event_pilot_id.value;
			//document.main.submit();
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('pilot_name');
   			if(id.value==''){
				document.reflight.pilot_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "none";
   			var mes=document.getElementById('search_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
});
$("input:text").on('mouseup', function() { $this.select(); });

//$(':text').focus(function(){
//    $(this).one('mouseup', function(event){
//        event.preventDefault();
//    }).select();
//});
{/literal}
</script>
<script>
function check_permission() {ldelim}
	{if $permission!=1}
		alert('Sorry, but you do not have permission to edit this event. Contact the event owner if you need access to edit this event.');
		return 0;
	{else}
		return 1;
	{/if}
{rdelim}
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