{extends file='layout/layout_entry.tpl'}

{block name="header"}
<script type="text/javascript">
	function toggle_over(){ldelim}
		if(document.main.over.value == 0) {ldelim}
			document.main.over.value = 1;
			document.getElementById('over_button').value = 'Yes';
		{rdelim}else{ldelim}
			document.main.over.value = 0;
			document.getElementById('over_button').value = 'No';
		{rdelim}
	{rdelim}
</script>
{literal}
<script type="text/javascript">
	function ladder(arg){
		/* Function to set the ladder values */
		if(arg == 1 && document.getElementById("label1").classList.contains('active') && !document.getElementById("label2").classList.contains('active')){
			arg = 0;
		}
		for( i = 1 ; i <= 7 ; i++){
			if(i <= arg ){
				document.getElementById("checkbox" + i).checked = true;
				document.getElementById("label" + i).classList.add('active');
			}else{
				document.getElementById("checkbox" + i).checked = false;
				document.getElementById("label" + i).classList.remove('active');
			}
		}
		/* Now to set the field variables for subs after the checkboxes have been checked */
		if(document.getElementById("label1").classList.contains('active')){
			document.main.sub_min_1.value = 0;
			document.main.sub_sec_1.value = 30;
		}else{
			document.main.sub_min_1.value = 0;
			document.main.sub_sec_1.value = 0;
		}
		if(document.getElementById("label2").classList.contains('active')){
			document.main.sub_min_2.value = 0;
			document.main.sub_sec_2.value = 45;
		}else{
			document.main.sub_min_2.value = 0;
			document.main.sub_sec_2.value = 0;
		}
		if(document.getElementById("label3").classList.contains('active')){
			document.main.sub_min_3.value = 1;
			document.main.sub_sec_3.value = 0;
		}else{
			document.main.sub_min_3.value = 0;
			document.main.sub_sec_3.value = 0;
		}
		if(document.getElementById("label4").classList.contains('active')){
			document.main.sub_min_4.value = 1;
			document.main.sub_sec_4.value = 15;
		}else{
			document.main.sub_min_4.value = 0;
			document.main.sub_sec_4.value = 0;
		}
		if(document.getElementById("label5").classList.contains('active')){
			document.main.sub_min_5.value = 1;
			document.main.sub_sec_5.value = 30;
		}else{
			document.main.sub_min_5.value = 0;
			document.main.sub_sec_5.value = 0;
		}
		if(document.getElementById("label6").classList.contains('active')){
			document.main.sub_min_6.value = 1;
			document.main.sub_sec_6.value = 45;
		}else{
			document.main.sub_min_6.value = 0;
			document.main.sub_sec_6.value = 0;
		}
		if(document.getElementById("label7").classList.contains('active')){
			document.main.sub_min_7.value = 2;
			document.main.sub_sec_7.value = 0;
		}else{
			document.main.sub_min_7.value = 0;
			document.main.sub_sec_7.value = 0;
		}
	}
</script>
{/literal}
{/block}

{block name="content"}
<div class="panel">
	<form name="main" method="POST">
	<input type="hidden" name="action" value="event">
	<input type="hidden" name="function" value="event_self_entry">
	<input type="hidden" name="save" value="0">
	<input type="hidden" name="event_id" value="{$event->info.event_id|escape}">
	<input type="hidden" name="event_pilot_id" value="{$event_pilot_id|escape}">
	<input type="hidden" name="flight_type_id" value="{$flight_type_id|escape}">
	<input type="hidden" name="round_number" value="{$round_number|escape}">
	<input type="hidden" name="group" value="{$event->rounds.$round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_group|escape}">
	<input type="hidden" name="minutes" value="{$minutes|escape}">
	<input type="hidden" name="seconds" value="{$seconds|escape}">
	<input type="hidden" name="seconds_2" value="{$seconds_2|escape}">
	<input type="hidden" name="over" value="{$over|escape}">
	<input type="hidden" name="landing" value="{$landing|escape}">
	<input type="hidden" name="laps" value="{if $event->rounds.$round_number.flights.$flight_type_id.flight_type_code == 'gps_speed'}1{else}{$laps|escape}{/if}">
	<input type="hidden" name="penalty" value="{$penalty|escape}">
	<input type="hidden" name="startpen" value="{$startpen|escape}">
	<input type="hidden" name="startheight" value="{$startheight|escape}">
	{for $sub=1 to $event->rounds.$round_number.flights.$flight_type_id.flight_type_sub_flights}
	<input type="hidden" name="sub_min_{$sub}" value="{$subs.$sub.minutes}">
	<input type="hidden" name="sub_sec_{$sub}" value="{$subs.$sub.seconds}">
	<input type="hidden" name="sub_sec2_{$sub}" value="{$subs.$sub.seconds2}">
	{/for}
	
	<div class="panel-body" style="padding-top: 5px;padding-bottom: 5px;padding-left: 0px;padding-right: 0px;">

		<div style="display:block;padding-right: 5px;padding-bottom: 2px;">
			<button class="btn btn-block btn-success btn-rounded dropdown-toggle" style="font-size: 24px;" data-toggle="dropdown" aria-expanded="false">
				<i class="fa fa-user" style="float:left;padding-top: 3px;"></i>
				{$current_pilot.pilot_first_name|escape} {$current_pilot.pilot_last_name|escape}
				<i class="dropdown-caret fa fa-chevron-down" style="padding-top: 3px;padding-left: 15px;"></i>
			</button>
				<ul class="dropdown-menu" style="width:100%;position: relative;font-size:20px;">
				{foreach $team_members as $t}
					<li style="text-align: center;"><a href="#" onClick="document.main.event_pilot_id.value={$t.event_pilot_id|escape};document.main.submit();">{$t.pilot_first_name|escape} {$t.pilot_last_name|escape}</a></li>
				{/foreach}
				</ul>
		</div>
		
		
		
		<div style="display:block;padding-right: 5px;padding-bottom: 2px;">
			<button class="btn btn-group btn-primary btn-rounded" style="font-size: 24px;width: 20%;float: left;border-width: 0px;border-top-right-radius: 0px;border-bottom-right-radius: 0px;" onClick="{if $round_number > 1}document.main.round_number.value={$round_number-1}{else}return false;{/if}">
				<i class="fa fa-chevron-left" style="float:left;padding-top: 5px;padding-bottom: 5px;{if $round_number == 1}color: grey;{/if}"></i>
			</button>
			<button class="btn btn-group btn-primary dropdown-toggle" style="font-size: 24px;width: 60%;border-width: 0px;margin-left: 0px;margin-right: 0px;"  data-toggle="dropdown" aria-expanded="false">
				Round {$round_number|escape}
			</button>
			<button class="btn btn-group btn-primary btn-rounded" style="font-size: 24px;width: 20%;float: right;border-width: 0px;border-top-left-radius: 0px;border-bottom-left-radius: 0px;" onclick="{if $advance_round == 1}document.main.round_number.value={$round_number+1};document.main.submit();{else}return false;{/if}">
				<i class="fa fa-chevron-right" style="float: right;padding-top: 5px;padding-bottom: 5px;{if $advance_round == 0}color: grey;{/if}"></i>
			</button>
				<ul class="dropdown-menu" style="width:100%;position: relative;font-size:20px;">
				{for $x = 1; $x <= count($event->rounds); $x++ }
					<li style="text-align: center;"><a href="#" onClick="document.main.round_number.value={$x};document.main.submit();">Round {$x}</a></li>
				{/for}
				</ul>
		</div>
		
		
		
		<div style="display:block;padding-right: 5px;padding-bottom: 2px;">
			<button class="btn btn-block btn-warning btn-rounded" style="font-size: 22px;" onClick="return false;">
				Flight Group {$event->rounds.$round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_group|escape}
				{if $event->rounds.$round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_lane}
				&nbsp;&nbsp;Lane {$event->rounds.$round_number.flights.$flight_type_id.pilots.$event_pilot_id.event_pilot_round_flight_lane}
				{/if}
			</button>
		</div>
		
		
		
		<div style="display:block;padding-right: 5px;padding-bottom: 2px;">
			<button class="btn btn-block btn-warning btn-rounded" style="font-size: 22px;" onClick="return false;">
				Task : {$event->rounds.$round_number.flights.$flight_type_id.flight_type_name_short|escape}
				{if $event->info.event_type_code == 'f3j' || $event->info.event_type_code == 'td' || $event->info.event_type_code == 'f5j'}
				 ({$event->tasks.$round_number.event_task_time_choice} min)
				{/if}
			</button>
		</div>

		
		{* For F3J and F5J Event *}
		{if $event->info.event_type_code == 'f3j' || $event->info.event_type_code == 'f5j'}
			{$event_round_time = $event->tasks.$round_number.event_task_time_choice}
			<table>
			<tr>
				<th width="37%" nowrap><h3>Flight Time</h3></th>
				<td valign="baseline">
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="minutes_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$minutes|string_format:"%'.02d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{section name=s loop=$event_round_time start=$event_round_time step=-1}
								<li><a href="#" onClick='document.main.minutes.value="{$smarty.section.s.index}";document.getElementById("minutes_button").value="{$smarty.section.s.index|string_format:"%'.02d"}";'>{$smarty.section.s.index|string_format:"%'.02d"}</a></li>
								{/section}
							</ul>
					</div>
						&nbsp;&nbsp;&nbsp;Min
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="seconds_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$seconds|string_format:"%'.02d"} " data-toggle="dropdown" aria-expanded="false">
						<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
							{section name=s loop=60 start=60 step=-1}
								<li><a href="#" onClick='document.main.seconds.value="{$smarty.section.s.index}";document.getElementById("seconds_button").value="{$smarty.section.s.index|string_format:"%'.02d"}";'>{$smarty.section.s.index|string_format:"%'.02d"}</a></li>
							{/section}
						</ul>
					</div>&nbsp;&nbsp;
					{if $seconds_accuracy > 0}
						{$loop_val = pow(10,$seconds_accuracy)}
						<div class="btn-group" style="width: 50px;">
							<input type="button" id="seconds_2_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$seconds_2|string_format:$seconds_accuracy_string} " data-toggle="dropdown" aria-expanded="false">
								<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
									
									{section name=s loop=$loop_val start=0 step=1}
									<li><a href="#" onClick='document.main.seconds_2.value="{$smarty.section.s.index}";document.getElementById("seconds_2_button").value="{$smarty.section.s.index|string_format:$seconds_accuracy_string}";'>{$smarty.section.s.index|string_format:$seconds_accuracy_string}</a></li>
									{/section}
								</ul>
						</div>
					{/if}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sec
				</td>
			</tr>
			{if $event->info.event_type_code == 'f3j'}
			<tr>
				<th><h3>Over Time</h3></th>
				<td>
					<input type="button" id="over_button" class="btn btn-primary btn-rounded" style="margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {if $over == 1}Yes{else}No{/if} " onClick="toggle_over();">
				</td>
			</tr>
			{/if}
			{if $event->info.event_type_code == 'f5j'}
			<tr>
				<th><h3>Start Height</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						{if $startheight == ''}{$startheight = 0}{/if}
						<input type="button" id="height_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$startheight} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{section name=s loop=350 start=1 step=1}
								<li><a href="#" onClick='document.main.startheight.value="{$smarty.section.s.index}";document.getElementById("height_button").value="{$smarty.section.s.index}";'>{$smarty.section.s.index}</a></li>
								{/section}
							</ul>
					</div>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Meters
				</td>
			</tr>
			{/if}
			<tr>
				<th><h3>Landing</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						{if $landing == ''}{$landing = 0}{/if}
						<input type="button" id="landing_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$landing} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{if $event->info.event_type_code == 'f5j'}
									{section name=s loop=51 start=51 step=-5}
									<li><a href="#" onClick='document.main.landing.value="{$smarty.section.s.index}";document.getElementById("landing_button").value="{$smarty.section.s.index}";'>{$smarty.section.s.index}</a></li>
									{/section}
								{else}
									{section name=s loop=101 start=101 step=-1}
									<li><a href="#" onClick='document.main.landing.value="{$smarty.section.s.index}";document.getElementById("landing_button").value="{$smarty.section.s.index}";'>{$smarty.section.s.index}</a></li>
									{/section}
								{/if}
							</ul>
					</div>
				</td>
			</tr>
			<tr>
				<th><h3>Penalty</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="penalty_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$penalty|string_format:"%2d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;">
								<li><a href="#" onClick='document.main.penalty.value=0;document.getElementById("penalty_button").value="0";'>0</a></li>
								<li><a href="#" onClick='document.main.penalty.value=100;document.getElementById("penalty_button").value="100";'>100</a></li>
								<li><a href="#" onClick='document.main.penalty.value=300;document.getElementById("penalty_button").value="300";'>300</a></li>
								<li><a href="#" onClick='document.main.penalty.value=1000;document.getElementById("penalty_button").value="1000";'>1000</a></li>
							</ul>
					</div>
				</td>
			</tr>
			</table>
		{/if} {* End F3J Event *}
			
		{* For TD Event *}
		{if $event->info.event_type_code == 'td'}
			{$event_round_time = $event->tasks.$round_number.event_task_time_choice + 2}
			<table>
			<tr>
				<th width="37%" nowrap><h3>Flight Time</h3></th>
				<td valign="baseline">
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="minutes_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$minutes|string_format:"%'.02d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{section name=s loop=$event_round_time start=$event_round_time step=-1}
								<li><a href="#" onClick='document.main.minutes.value="{$smarty.section.s.index}";document.getElementById("minutes_button").value="{$smarty.section.s.index|string_format:"%'.02d"}";'>{$smarty.section.s.index|string_format:"%'.02d"}</a></li>
								{/section}
							</ul>
					</div>
						min
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="seconds_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$seconds|string_format:"%'.02d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{section name=s loop=60 start=60 step=-1}
								<li><a href="#" onClick='document.main.seconds.value="{$smarty.section.s.index}";document.getElementById("seconds_button").value="{$smarty.section.s.index|string_format:"%'.02d"}";'>{$smarty.section.s.index|string_format:"%'.02d"}</a></li>
								{/section}
							</ul>
					</div>&nbsp;&nbsp;&nbsp;sec
				</td>
			</tr>
			<tr>
				<th><h3>Landing</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						{if $landing == ''}{$landing = 0}{/if}
						<input type="button" id="landing_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$landing} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{section name=s loop=101 start=101 step=-1}
								<li><a href="#" onClick='document.main.landing.value="{$smarty.section.s.index}";document.getElementById("landing_button").value="{$smarty.section.s.index}";'>{$smarty.section.s.index}</a></li>
								{/section}
							</ul>
					</div>
				</td>
			</tr>
			<tr>
				<th><h3>Penalty</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="penalty_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$penalty|string_format:"%2d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;">
								<li><a href="#" onClick='document.main.penalty.value=0;document.getElementById("penalty_button").value="0";'>0</a></li>
								<li><a href="#" onClick='document.main.penalty.value=100;document.getElementById("penalty_button").value="100";'>100</a></li>
								<li><a href="#" onClick='document.main.penalty.value=300;document.getElementById("penalty_button").value="300";'>300</a></li>
								<li><a href="#" onClick='document.main.penalty.value=1000;document.getElementById("penalty_button").value="1000";'>1000</a></li>
							</ul>
					</div>
				</td>
			</tr>
			</table>
		{/if} {* End TD Event *}
			
		{* For F3K Event *}
		{if $event->info.event_type_code == 'f3k'}
			<table>
			<tr>
				<th width="25%" valign="top"><h3>Details</h3></th>
				<td valign="center">
					{$event->rounds.$round_number.flights.$flight_type_id.flight_type_name|escape}<br>
					{$event->rounds.$round_number.flights.$flight_type_id.flight_type_description|escape}
				</td>
			</tr>
			<tr>
				<th width="25%" valign="top"><h3>Flight{if $event->rounds.$round_number.flights.$flight_type_id.flight_type_sub_flights > 1}s{/if}</h3></th>
				<td valign="baseline">
					{if $event->rounds.$round_number.flights.$flight_type_id.flight_type_sub_flights_max_time != 0}
						{$max_min = $event->rounds.$round_number.flights.$flight_type_id.flight_type_sub_flights_max_time / 60}
					{else}
						{if $event->rounds.$round_number.flights.$flight_type_id.flight_type_code == 'f3k_e'}
							{$max_min = 10}
						{elseif $event->rounds.$round_number.flights.$flight_type_id.flight_type_code == 'f3k_h'}
							{$max_min = 4}
						{/if}
					{/if}
					{if $event->rounds.$round_number.flights.$flight_type_id.flight_type_code == 'f3k_d'}
							<div class="btn-group" style="width: 10px;margin-right: 25px;">
								<input type="button" class="btn btn-success btn-rounded" style = "margin-right: 25px;margin-top: 10px;font-size: 16px;" value=" 1 " onclick="return false;">
							</div>&nbsp;
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 00 ">
							</div>
								min
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 30 ">
							</div>&nbsp;&nbsp;&nbsp;sec &nbsp;&nbsp;&nbsp;
							<label id="label1" class="form-checkbox form-icon form-no-label btn btn-primary btn-rounded{if $subs.1.minutes == 0 && $subs.1.seconds == "30"} active{/if}" style="margin-top: 10px;font-size: 16px;margin-bottom: 0px;"><input type="checkbox" id="checkbox1" onClick="ladder(1);"{if $subs.1.minutes == 0 && $subs.1.seconds == 30} checked{/if}></label>
							<br>
							<div class="btn-group" style="width: 10px;margin-right: 25px;">
								<input type="button" class="btn btn-success btn-rounded" style = "margin-right: 25px;margin-top: 10px;font-size: 16px;" value=" 2 " onclick="return false;">
							</div>&nbsp;
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 00 ">
							</div>
								min
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 45 ">
							</div>&nbsp;&nbsp;&nbsp;sec &nbsp;&nbsp;&nbsp;
							<label id="label2" class="form-checkbox form-icon form-no-label btn btn-primary btn-rounded{if $subs.2.minutes == 0 && $subs.2.seconds == "45"} active{/if}" style="margin-top: 10px;font-size: 16px;margin-bottom: 0px;"><input type="checkbox" id="checkbox2" onClick="ladder(2);"{if $subs.2.minutes == 0 && $subs.2.seconds == "45"} checked{/if}></label>
							<br>
							<div class="btn-group" style="width: 10px;margin-right: 25px;">
								<input type="button" class="btn btn-success btn-rounded" style = "margin-right: 25px;margin-top: 10px;font-size: 16px;" value=" 3 " onclick="return false;">
							</div>&nbsp;
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 01 ">
							</div>
								min
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 00 ">
							</div>&nbsp;&nbsp;&nbsp;sec &nbsp;&nbsp;&nbsp;
							<label id="label3" class="form-checkbox form-icon form-no-label btn btn-primary btn-rounded{if $subs.3.minutes == 1 && $subs.3.seconds == "00"} active{/if}" style="margin-top: 10px;font-size: 16px;margin-bottom: 0px;"><input type="checkbox" id="checkbox3" onClick="ladder(3);"{if $subs.3.minutes == 1 && $subs.3.seconds == "00"} checked{/if}></label>
							<br>
							<div class="btn-group" style="width: 10px;margin-right: 25px;">
								<input type="button" class="btn btn-success btn-rounded" style = "margin-right: 25px;margin-top: 10px;font-size: 16px;" value=" 4 " onclick="return false;">
							</div>&nbsp;
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 01 ">
							</div>
								min
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 15 ">
							</div>&nbsp;&nbsp;&nbsp;sec &nbsp;&nbsp;&nbsp;
							<label id="label4" class="form-checkbox form-icon form-no-label btn btn-primary btn-rounded{if $subs.4.minutes == 1 && $subs.4.seconds == "15"} active{/if}" style="margin-top: 10px;font-size: 16px;margin-bottom: 0px;"><input type="checkbox" id="checkbox4" onClick="ladder(4);"{if $subs.4.minutes == 1 && $subs.4.seconds == "15"} checked{/if}></label>
							<br>
							<div class="btn-group" style="width: 10px;margin-right: 25px;">
								<input type="button" class="btn btn-success btn-rounded" style = "margin-right: 25px;margin-top: 10px;font-size: 16px;" value=" 5 " onclick="return false;">
							</div>&nbsp;
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 01 ">
							</div>
								min
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 30 ">
							</div>&nbsp;&nbsp;&nbsp;sec &nbsp;&nbsp;&nbsp;
							<label id="label5" class="form-checkbox form-icon form-no-label btn btn-primary btn-rounded{if $subs.5.minutes == 1 && $subs.5.seconds == "30"} active{/if}" style="margin-top: 10px;font-size: 16px;margin-bottom: 0px;"><input type="checkbox" id="checkbox5" onClick="ladder(5);"{if $subs.5.minutes == 1 && $subs.5.seconds == "30"} checked{/if}></label>
							<br>
							<div class="btn-group" style="width: 10px;margin-right: 25px;">
								<input type="button" class="btn btn-success btn-rounded" style = "margin-right: 25px;margin-top: 10px;font-size: 16px;" value=" 6 " onclick="return false;">
							</div>&nbsp;
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 01 ">
							</div>
								min
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 45 ">
							</div>&nbsp;&nbsp;&nbsp;sec &nbsp;&nbsp;&nbsp;
							<label id="label6" class="form-checkbox form-icon form-no-label btn btn-primary btn-rounded{if $subs.6.minutes == 1 && $subs.6.seconds == "45"} active{/if}" style="margin-top: 10px;font-size: 16px;margin-bottom: 0px;"><input type="checkbox" id="checkbox6" onClick="ladder(6);"{if $subs.6.minutes == 1 && $subs.6.seconds == "45"} checked{/if}></label>
							<br>
							<div class="btn-group" style="width: 10px;margin-right: 25px;">
								<input type="button" class="btn btn-success btn-rounded" style = "margin-right: 25px;margin-top: 10px;font-size: 16px;" value=" 7 " onclick="return false;">
							</div>&nbsp;
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 02 ">
							</div>
								min
							<div class="btn-group" style="width: 50px;">
								<input type="button" class="btn btn-primary btn-rounded" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 00 ">
							</div>&nbsp;&nbsp;&nbsp;sec &nbsp;&nbsp;&nbsp;
							<label id="label7" class="form-checkbox form-icon form-no-label btn btn-primary btn-rounded{if $subs.7.minutes == 2 && $subs.7.seconds == "00"} active{/if}" style="margin-top: 10px;font-size: 16px;margin-bottom: 0px;"><input type="checkbox" id="checkbox7" onClick="ladder(7);"{if $subs.7.minutes == 2 && $subs.7.seconds == "00"} checked{/if}></label>
					{else}
						{for $sub=1 to $event->rounds.$round_number.flights.$flight_type_id.flight_type_sub_flights}
							<div class="btn-group" style="width: 10px;margin-right: 25px;">
								<input type="button" class="btn btn-success btn-rounded" style = "margin-right: 25px;margin-top: 10px;font-size: 16px;" value=" {$sub} " onclick="return false;">
							</div>&nbsp;
							<div class="btn-group" style="width: 50px;">
								<input type="button" id="sub_{$sub}_minutes_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$subs.$sub.minutes|string_format:"%'.02d"} " data-toggle="dropdown" aria-expanded="false">
									<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
										{section name=s loop=$max_min+1 start=$max_min+1 step=-1}
										<li><a href="#" onClick='document.main.sub_min_{$sub}.value="{$smarty.section.s.index}";document.getElementById("sub_{$sub}_minutes_button").value="{$smarty.section.s.index|string_format:"%'.02d"}";'>{$smarty.section.s.index|string_format:"%'.02d"}</a></li>
										{/section}
									</ul>
							</div>
							&nbsp;&nbsp;min
							<div class="btn-group" style="width: 50px;">
								<input type="button" id="sub_{$sub}_seconds_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$subs.$sub.seconds|string_format:"%'.02d"} " data-toggle="dropdown" aria-expanded="false">
									<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
										{section name=s loop=60 start=60 step=-1}
										<li><a href="#" onClick='document.main.sub_sec_{$sub}.value="{$smarty.section.s.index}";document.getElementById("sub_{$sub}_seconds_button").value="{$smarty.section.s.index|string_format:"%'.02d"}";'>{$smarty.section.s.index|string_format:"%'.02d"}</a></li>
										{/section}
									</ul>
							</div>&nbsp;&nbsp;
							
							{if $seconds_accuracy > 0}
								{$loop_val = pow(10,$seconds_accuracy)}
								<div class="btn-group" style="width: 50px;">
									<input type="button" id="sub_{$sub}_seconds2_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$subs.$sub.seconds2|string_format:$seconds_accuracy_string} " data-toggle="dropdown" aria-expanded="false">
										<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
											{section name=s loop=$loop_val start=0 step=1}
											<li><a href="#" onClick='document.main.sub_sec2_{$sub}.value="{$smarty.section.s.index}";document.getElementById("sub_{$sub}_seconds2_button").value="{$smarty.section.s.index|string_format:$seconds_accuracy_string}";'>{$smarty.section.s.index|string_format:$seconds_accuracy_string}</a></li>
											{/section}
										</ul>
								</div>
							{/if}
							&nbsp;&nbsp;&nbsp;&nbsp;sec<br>
						{/for}
					{/if}
				</td>
			</tr>
			<tr>
				<th><h3>Penalty</h3></th>
				<td valign="top">
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="penalty_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$penalty|string_format:"%2d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;">
								<li><a href="#" onClick='document.main.penalty.value=0;document.getElementById("penalty_button").value="0";'>0</a></li>
								<li><a href="#" onClick='document.main.penalty.value=100;document.getElementById("penalty_button").value="100";'>100</a></li>
								<li><a href="#" onClick='document.main.penalty.value=300;document.getElementById("penalty_button").value="300";'>300</a></li>
								<li><a href="#" onClick='document.main.penalty.value=1000;document.getElementById("penalty_button").value="1000";'>1000</a></li>
							</ul>
					</div>
				</td>
			</tr>
			</table>
		{/if} {* End F3K Event *}
			
		{* For GPS Event *}
		{if $event->info.event_type_code == 'gps'}
			{$event_round_time = $event->tasks.$round_number.event_task_time_choice + 2}
			<table>
			<tr>
				<th><h3>Total Laps</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						{if $event->rounds.$round_number.flights.$flight_type_id.flight_type_code == 'gps_speed'}
							<input type="button" id="laps_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" 1 " data-toggle="dropdown" aria-expanded="false">
						{else}
							{if $laps == ''}{$laps = 0}{/if}
							<input type="button" id="laps_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$laps} " data-toggle="dropdown" aria-expanded="false">
								<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
									{section name=s loop=26 start=0 step=1}
									<li><a href="#" onClick='document.main.laps.value="{$smarty.section.s.index}";document.getElementById("laps_button").value="{$smarty.section.s.index}";'>{$smarty.section.s.index}</a></li>
									{/section}
								</ul>
						{/if}
					</div>
				</td>
			</tr>
			<tr>
				<th width="37%" nowrap><h3>Flight Time</h3></th>
				<td valign="baseline">
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="minutes_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$minutes|string_format:"%'.02d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{section name=s loop=30 start=0 step=1}
								<li><a href="#" onClick='document.main.minutes.value="{$smarty.section.s.index}";document.getElementById("minutes_button").value="{$smarty.section.s.index|string_format:"%'.02d"}";'>{$smarty.section.s.index|string_format:"%'.02d"}</a></li>
								{/section}
							</ul>
					</div>
						min
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="seconds_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$seconds|string_format:"%'.02d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{section name=s loop=60 start=60 step=-1}
								<li><a href="#" onClick='document.main.seconds.value="{$smarty.section.s.index}";document.getElementById("seconds_button").value="{$smarty.section.s.index|string_format:"%'.02d"}";'>{$smarty.section.s.index|string_format:"%'.02d"}</a></li>
								{/section}
							</ul>
					</div>&nbsp;&nbsp;
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="seconds_2_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$seconds_2|string_format:".%'.02d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{section name=s loop=100 start=100 step=-1}
								<li><a href="#" onClick='document.main.seconds_2.value="{$smarty.section.s.index}";document.getElementById("seconds_2_button").value="{$smarty.section.s.index|string_format:".%'.02d"}";'>{$smarty.section.s.index|string_format:".%'.02d"}</a></li>
								{/section}
							</ul>
					</div>
						&nbsp;&nbsp;&nbsp;sec
				</td>
			</tr>
			<tr>
				<th><h3>Landing</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						{if $landing == ''}{$landing = 0}{/if}
						<input type="button" id="landing_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$landing} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;">
								<li><a href="#" onClick='document.main.landing.value=0;document.getElementById("landing_button").value="0";'>0</a></li>
								<li><a href="#" onClick='document.main.landing.value=200;document.getElementById("landing_button").value="200";'>200</a></li>
								<li><a href="#" onClick='document.main.landing.value=400;document.getElementById("landing_button").value="400";'>400</a></li>
							</ul>
					</div>
				</td>
			</tr>
			<tr>
				<th nowrap><h3>Start Penalty&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="startpen_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 15px;margin-top: 10px;font-size: 28px;" value=" {$startpen|string_format:"%2d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;height: 300px;overflow-y: auto;">
								{section name=s loop=1000 start=0 step=1}
								<li><a href="#" onClick='document.main.startpen.value="{$smarty.section.s.index}";document.getElementById("startpen_button").value="{$smarty.section.s.index}";'>{$smarty.section.s.index}</a></li>
								{/section}
							</ul>
					</div>
				</td>
			</tr>
			<tr>
				<th><h3>Penalty</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						<input type="button" id="penalty_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$penalty|string_format:"%2d"} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;">
								<li><a href="#" onClick='document.main.penalty.value=0;document.getElementById("penalty_button").value="0";'>0</a></li>
								<li><a href="#" onClick='document.main.penalty.value=100;document.getElementById("penalty_button").value="100";'>100</a></li>
								<li><a href="#" onClick='document.main.penalty.value=300;document.getElementById("penalty_button").value="300";'>300</a></li>
								<li><a href="#" onClick='document.main.penalty.value=1000;document.getElementById("penalty_button").value="1000";'>1000</a></li>
							</ul>
					</div>
				</td>
			</tr>
			</table>
		{/if} {* End GPS Event *}
			
		<br>
			{if $event->rounds.$round_number.event_round_locked == 1}
			<button class="btn btn-block btn-danger btn-rounded" style="font-size: 24px;" onClick="return false;">
				<i class="fa fa-lock" style="float:left;padding-top: 3px;"></i>
				Save This Flight ( Locked )
			</button>
			{else}
			<button class="btn btn-block btn-info btn-rounded dropdown-toggle" style="font-size: 24px;" onClick="document.main.save.value=1;document.main.submit();">
				Save This Flight
			</button>
			{/if}
	</div>
	</form>
	<div style="background-color: lightgrey;">
		<span style="font-size: 16px;"><center>Current Round Standings</center></span>
	</div>
	<div style="overflow: scroll;">
		{$num=1}
		<table width="100%">
			<tr class="table-heading">
				<th>#</th>
				<th>Bib  Pilot Name</th>
				{if $event->flight_types.$flight_type_id.flight_type_group}
					<th style="text-align: center;">Group</th>
					{if preg_match("/^f3f/",$event->flight_types.$flight_type_id.flight_type_code) && $event->flight_types.$flight_type_id.flight_type_group}
						<th style="text-align: center;">Flight Order</th>
					{/if}
				{else}
					<th style="text-align: center;">Flight Order</th>
				{/if}
				<th>Time</th>
				{if $event->flight_types.$flight_type_id.flight_type_start_height}
					<th style="text-align: right;">Height</th>
				{/if}
				{if $event->flight_types.$flight_type_id.flight_type_landing}
					<th style="text-align: right;">Land</th>
				{/if}
				{if $event->flight_types.$flight_type_id.flight_type_laps}
					<th style="text-align: right;">Laps</th>
				{/if}
				<th style="text-align: right;">Pen</th>
				<th style="text-align: right;">Score</th>
			</tr>
			{$groupcolor='lightgrey'}
			{$oldgroup=''}
			{foreach $event->rounds.$round_number.flights as $flight_id => $f}
				{foreach $f.pilots as $event_pilot_id => $p}
					{if $oldgroup!=$p.event_pilot_round_flight_group}
						{if $groupcolor=='white'}{$groupcolor='lightgrey'}{else}{$groupcolor='white'}{/if}
						{$oldgroup=$p.event_pilot_round_flight_group|escape}
					{/if}
					<tr style="background-color: {$groupcolor};">
						<td>{$p.event_pilot_round_flight_rank|escape}</td>
						<td>
							{if $event->pilots.$event_pilot_id.event_pilot_bib!='' && $event->pilots.$event_pilot_id.event_pilot_bib!=0}
								<div class="pilot_bib_number" style="margin-right: 4px;">{$event->pilots.$event_pilot_id.event_pilot_bib}</div>
							{/if}
							{if $event->pilots.$event_pilot_id.country_code}<img src="/images/flags/countries-iso/shiny/16/{$event->pilots.$event_pilot_id.country_code|escape}.png" class="inline_flag" title="{$event->pilots.$event_pilot_id.country_name}">{/if}
							{if $event->pilots.$event_pilot_id.state_name && $event->pilots.$event_pilot_id.country_code=="US"}<img src="/images/flags/states/16/{$event->pilots.$event_pilot_id.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$event->pilots.$event_pilot_id.state_name}">{/if}
							{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}
						</td>
						{if $f.flight_type_group}
							<td align="center" nowrap>{$p.event_pilot_round_flight_group|escape}</td>					
						{else}
							<td align="center" nowrap>{$p.event_pilot_round_flight_order|escape}</td>					
						{/if}
						<td align="left" nowrap>
							{if $f.flight_type_minutes}
								{$p.event_pilot_round_flight_minutes|escape}m
							{/if}
							{if $f.flight_type_seconds}
								{if $p.event_pilot_round_flight_dns==1}DNS{elseif $p.event_pilot_round_flight_dnf==1}DNF{else}{$p.event_pilot_round_flight_seconds|escape}{/if}s
							{/if}
						</td>
						{if $f.flight_type_start_height}
							<td align="right" nowrap>
								{$p.event_pilot_round_flight_start_height|escape}
							</td>
						{/if}
						{if $f.flight_type_landing}
							<td align="right" nowrap>{$p.event_pilot_round_flight_landing|escape}</td>
						{/if}
						{if $f.flight_type_laps}
							<td align="right" nowrap>{$p.event_pilot_round_flight_laps|escape}</td>
						{/if}
						<td align="right" nowrap>
							{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty|escape}{/if}
						</td>
						<td align="right" nowrap>
							{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}<del><font color="red">{/if}
							{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}{if $p.event_pilot_round_flight_reflight_dropped}(R){/if}
							{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}</font></del>{/if}
						</td>
					<tr>
					{$num=$num+1}
				{/foreach}
			{/foreach}
		</table>
	</div>
</div>


{/block}
{block name="footer"}
{/block}
