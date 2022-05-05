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
<style>
	input {
		touch-action: none;
	}
	::-moz-selection { /* Code for Firefox */
	  color: red;
	  background-color: yellow;
	}
	
	::selection {
	  color: red;
	  background-color: yellow;
	}
	::-webkit-selection {
	  color: red;
	  background-color: yellow;
	}
</style>
{/literal}
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
	<input type="hidden" id="sub_min_{$sub}" name="sub_min_{$sub}" value="{$subs.$sub.minutes}">
	<input type="hidden" id="sub_sec_{$sub}" name="sub_sec_{$sub}" value="{$subs.$sub.seconds}">
	<input type="hidden" id="sub_sec2_{$sub}" name="sub_sec2_{$sub}" value="{$subs.$sub.seconds2}">
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
				<th valign="top"><h3  style="margin-right: 20px;">Flight Time</h3></th>
				<td>
					<div class="btn-group">
						<input type="text" pattern="[0-9]*" size="2" inputmode="numeric" id="minutes_button" class="btn-primary btn-rounded" style="{if $event->tasks.$round_number.event_task_time_choice > 10 }width: 70px;{else}width: 50px;{/if}font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{if $minutes == '' || $minutes == null}0{else}{$minutes|escape}{/if}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_5jminute(this);' onChange="document.main.minutes.value=this.value;">
					</div>
					<div style="display:inline-block;vertical-align: bottom;margin-right: 5px;">Min</div>
					<div class="btn-group">
						<input type="text" pattern="[0-9]*" size="3" inputmode="numeric" id="seconds_button" class="btn-primary btn-rounded" style="width: 70px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$seconds|string_format:"%'.02d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_second(this);' onChange="document.main.seconds.value=this.value;">
					</div>
					{if $seconds_accuracy > 0}
					<div style="display: inline-block;vertical-align: bottom;font-size: 30px;margin-right: 5px;">.</div>
					<div class="btn-group">
						<input type="text" pattern="[0-9]*" size="1" inputmode="numeric" id="seconds_2_button" class="btn-primary btn-rounded" style="width: 45px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$seconds_2|string_format:"%'.01d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_tenth(this);' onChange="document.main.seconds_2.value=this.value;">
					</div>
					{/if}
					<div style="display:inline-block;vertical-align: bottom;">Sec</div>					
				</td>
			</tr>
			{if $event->info.event_type_code == 'f5j'}
			<tr>
				<th><h3>Start Height</h3></th>
				<td valign="center">
					<div class="btn-group">
						{if $startheight == ''}{$startheight = 0}{/if}
						<input type="text" pattern="[0-9]*" inputmode="numeric" size="2" id="height_button" class="btn-primary btn-rounded" style="width: 80px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$startheight}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_height(this);' onChange="document.main.startheight.value=this.value;"">
					</div>
					<div style="display:inline-block;vertical-align: bottom;margin-right: 5px;">Meters</div>
				</td>
			</tr>
			{/if}
			<tr>
				<th><h3>Landing</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						{if $landing == ''}{$landing = 0}{/if}
						<input type="button" id="landing_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "width: 70px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$landing}" data-toggle="dropdown" aria-expanded="false">
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
			{if $event->info.event_type_code == 'f3j'}
			<tr>
				<th><h3>Over Time</h3></th>
				<td>
					<input type="button" id="over_button" class="btn btn-primary btn-rounded" style="margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {if $over == 1}Yes{else}No{/if} " onClick="toggle_over();">
				</td>
			</tr>
			{/if}
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
				<th valign="top"><h3  style="margin-right: 15px;">Flight Time</h3></th>
				<td>
					<div class="btn-group">
						<input type="text" pattern="[0-9]*" size="2" inputmode="numeric" id="minutes_button" class="btn-primary btn-rounded" style="{if $event->tasks.$round_number.event_task_time_choice >= 10 }width: 70px;{else}width: 50px;{/if}font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{if $minutes == '' || $minutes == null}0{else}{$minutes|escape}{/if}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_tdminute(this);' onChange="document.main.minutes.value=this.value;">
					</div>
					<div style="display:inline-block;vertical-align: bottom;margin-right: 5px;">Min</div>
					<div class="btn-group">
						<input type="text" pattern="[0-9]*" size="3" inputmode="numeric" id="seconds_button" class="btn-primary btn-rounded" style="width: 60px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$seconds|string_format:"%'.02d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_second(this);' onChange="document.main.seconds.value=this.value;">
					</div>
					{if $seconds_accuracy > 0}
					<div style="display: inline-block;vertical-align: bottom;font-size: 30px;margin-right: 5px;">.</div>
					<div class="btn-group">
						<input type="text" pattern="[0-9]*" size="1" inputmode="numeric" id="seconds_2_button" class="btn-primary btn-rounded" style="width: 45px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$seconds_2|string_format:"%'.01d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_tenth(this);' onChange="document.main.seconds_2.value=this.value;">
					</div>
					{/if}
					<div style="display:inline-block;vertical-align: bottom;">Sec</div>					
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
				<th valign="top"><h3  style="margin-right: 15px;">Details</h3></th>
				<td valign="center">
					{$event->rounds.$round_number.flights.$flight_type_id.flight_type_name|escape}<br>
					{$event->rounds.$round_number.flights.$flight_type_id.flight_type_description|escape}
				</td>
			</tr>
			<tr>
				<th valign="top"><h3>Flight{if $event->rounds.$round_number.flights.$flight_type_id.flight_type_sub_flights > 1}s{/if}</h3></th>
				<td valign="baseline">
					{if $event->rounds.$round_number.flights.$flight_type_id.flight_type_code == 'f3k_d'}
							Click on highest achieved flight<br>
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
							<div class="btn-group">
								<button class="btn btn-success btn-rounded" style = "margin-right: 15px;margin-top: 10px;font-size: 16px;" onclick="return false;">{$sub}</button>
							</div>
							<div class="btn-group">
								<input type="text" pattern="[0-9]*" size="2" inputmode="numeric" id="sub_{$sub}_minutes_button" class="btn-primary btn-rounded" style="width: 50px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$subs.$sub.minutes|string_format:"%'.01d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_f3kminute(this);check_flight_total_time(this);' onChange="document.main.sub_min_{$sub}.value=this.value;">
							</div>
							<div style="display:inline-block;vertical-align: bottom;margin-right: 5px;">Min</div>
							<div class="btn-group">
								<input type="text" pattern="[0-9]*" size="3" inputmode="numeric" id="sub_{$sub}_seconds_button" class="btn-primary btn-rounded" style="width: 60px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$subs.$sub.seconds|string_format:"%'.02d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_second(this);check_flight_total_time(this);' onChange="document.main.sub_sec_{$sub}.value=this.value;">
							</div>
							{if $seconds_accuracy > 0}
							<div style="display: inline-block;vertical-align: bottom;font-size: 30px;margin-right: 5px;">.</div>
							<div class="btn-group">
								<input type="text" pattern="[0-9]*" size="1" inputmode="numeric" id="sub_{$sub}_seconds2_button" class="btn-primary btn-rounded" style="width: 45px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$subs.$sub.seconds2|string_format:"%'.01d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_tenth(this);check_flight_total_time(this);' onChange="document.main.sub_sec2_{$sub}.value=this.value;">
							</div>
							{/if}
							<div style="display:inline-block;vertical-align: bottom;">Sec</div>
							<br>
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
				<th valign="top"><h3  style="margin-right: 15px;">Total Laps</h3></th>
				<td>
					<div class="btn-group">
						{if $event->rounds.$round_number.flights.$flight_type_id.flight_type_code == 'gps_speed'}
							<input type="text" pattern="[0-9]*" inputmode="numeric" size="2" id="laps_button" class="btn-primary btn-rounded" style="width: 80px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="1" disabled>
						{else}
							{if $laps == ''}{$laps = 0}{/if}
							<input type="text" pattern="[0-9]*" inputmode="numeric" size="2" id="laps_button" class="btn-primary btn-rounded" style="width: 80px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$laps|escape}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_gpslaps(this);' onChange="document.main.laps.value=this.value;"">
						{/if}
					</div>
					<div style="display:inline-block;vertical-align: bottom;margin-right: 5px;">Laps</div>

				</td>
			</tr>
			<tr>
				<th width="37%" nowrap><h3>Flight Time</h3></th>
				<td valign="baseline">
					<div class="btn-group">
						<input type="text" pattern="[0-9]*" size="2" inputmode="numeric" id="minutes_button" class="btn-primary btn-rounded" style="width: 70px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{if $minutes == '' || $minutes == null}0{else}{$minutes|escape}{/if}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_gpsminute(this);' onChange="document.main.minutes.value=this.value;">
					</div>
					<div style="display:inline-block;vertical-align: bottom;margin-right: 5px;">Min</div>
					<div class="btn-group">
						<input type="text" pattern="[0-9]*" size="3" inputmode="numeric" id="seconds_button" class="btn-primary btn-rounded" style="width: 70px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$seconds|string_format:"%'.02d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_second(this);' onChange="document.main.seconds.value=this.value;">
					</div>
					{if $seconds_accuracy > 0}
					<div style="display: inline-block;vertical-align: bottom;font-size: 30px;margin-right: 5px;">.</div>
					<div class="btn-group">
						<input type="text" pattern="[0-9]*" size="1" inputmode="numeric" id="seconds_2_button" class="btn-primary btn-rounded" style="width: 70px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$seconds_2|string_format:"%'.02d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_hundredth(this);' onChange="document.main.seconds_2.value=this.value;">
					</div>
					{/if}
					<div style="display:inline-block;vertical-align: bottom;">Sec</div>					
				</td>
			</tr>
			<tr>
				<th nowrap><h3>Start Penalty&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						<input type="text" pattern="[0-9]*" inputmode="numeric" size="2" id="startpen_button" class="btn-primary btn-rounded" style="width: 80px;font-weight: 700;text-align: center;border-radius: 5px;margin-right: 5px;margin-top: 10px;font-size: 28px;" value="{$startpen|string_format:"%2d"}" onFocus='make_selected(this);' onBlur='make_unselected(this);' onKeyUp='check_startpen(this);' onChange="document.main.startpen.value=this.value;"">
					</div>
				</td>
			</tr>
			<tr>
				<th><h3>Landing</h3></th>
				<td>
					<div class="btn-group" style="width: 50px;">
						{if $landing == ''}{$landing = 0}{/if}
						<input type="button" id="landing_button" class="btn btn-primary btn-rounded dropdown-toggle" style = "margin-right: 5px;margin-top: 10px;font-size: 28px;" value=" {$landing} " data-toggle="dropdown" aria-expanded="false">
							<ul class="dropdown-menu dropdown-menu-left" style="font-size:24px;width: 50px;">
								<li><a href="#" onClick='document.main.landing.value=400;document.getElementById("landing_button").value="400";'>400</a></li>
								<li><a href="#" onClick='document.main.landing.value=200;document.getElementById("landing_button").value="200";'>200</a></li>
								<li><a href="#" onClick='document.main.landing.value=0;document.getElementById("landing_button").value="0";'>0</a></li>
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
			{if $event->rounds.$round_number.event_round_locked == 1 || $flight_locked == 1}
			<button class="btn btn-block btn-danger btn-rounded" style="font-size: 24px;" onClick="return false;">
				<i class="fa fa-lock" style="float:left;padding-top: 3px;"></i>
				Save This Flight ( Locked )
			</button>
			{else}
				{if $event->info.event_type_code == 'f3k'}
					<button id="save-button" class="btn btn-block btn-info btn-rounded dropdown-toggle" style="font-size: 24px;" onClick="if(check_total_round_time() == true ){ldelim}this.disabled=true;document.main.save.value=1;document.main.submit();{rdelim}else{ldelim}return false;{rdelim}">
						Save This Flight
					</button>
				{else}
					<button id="save-button" class="btn btn-block btn-info btn-rounded dropdown-toggle" style="font-size: 24px;" onClick="this.disabled=true;document.main.save.value=1;document.main.submit();">
					Save This Flight
				</button>
				{/if}
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
				{if $event->flight_types.$flight_type_id.flight_type_landing}
					<th style="text-align: right;">Land</th>
				{/if}
				{if $event->flight_types.$flight_type_id.flight_type_start_height}
					<th style="text-align: right;">Height</th>
				{/if}
				{if $event->flight_types.$flight_type_id.flight_type_laps}
					<th style="text-align: right;">Laps</th>
				{/if}
				{if $event->flight_types.$flight_type_id.flight_type_start_penalty}
					<th style="text-align: right;">StrPen</th>
				{/if}
				<th style="text-align: right;">Pen</th>
				<th style="text-align: right;">Score</th>
				<th style="text-align: right;"></th>
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
						{if $f.flight_type_landing}
							<td align="right" nowrap>{$p.event_pilot_round_flight_landing|escape}</td>
						{/if}
						{if $f.flight_type_start_height}
							<td align="right" nowrap>
								{$p.event_pilot_round_flight_start_height|escape}
							</td>
						{/if}
						{if $f.flight_type_laps}
							<td align="right" nowrap>{$p.event_pilot_round_flight_laps|escape}</td>
						{/if}
						{if $f.flight_type_start_penalty}
							<td align="right" nowrap>{$p.event_pilot_round_flight_start_penalty|escape}</td>
						{/if}
						<td align="right" nowrap>
							{if $p.event_pilot_round_flight_penalty!=0}{$p.event_pilot_round_flight_penalty|escape}{/if}
						</td>
						<td align="right" nowrap>
							{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}<del><font color="red">{/if}
							{$p.event_pilot_round_flight_score|string_format:$event->event_calc_accuracy_string}{if $p.event_pilot_round_flight_reflight_dropped}(R){/if}
							{if $p.event_pilot_round_flight_dropped || $p.event_pilot_round_flight_reflight_dropped}</font></del>{/if}
						</td>
						<td align="left" valign="center" nowrap>
							{if $p.event_pilot_round_flight_entered == 1 }<img width="25" src="/images/icons/bullet_green.png" />{else}<img width="25" src="/images/1x1.png" />{/if}
						</td>
					<tr>
					{$num=$num+1}
				{/foreach}
			{/foreach}
		</table>
	</div>
	<div>
		<br>
		<button class="btn btn-block btn-primary btn-rounded" style="font-size: 24px;" onClick="window.location.href='/?action=event&function=event_view&event_id={$event->info.event_id|escape:"javascript"}';">
			View Overall Standings
		</button>
		<br>
	</div>
</div>

<script type="text/javascript">
	function make_selected(object){ldelim}
		object.style.backgroundColor="yellow";
		object.style.color="black";
		object.select();
	{rdelim}
	function make_unselected(object){ldelim}
		if( object.value == "" || object.value == null){ldelim}
			if( object.id.match(/seconds/) && ! object.id.match(/seconds2/) ){ldelim}
				object.value="00";
			{rdelim}else{ldelim}
				object.value = 0;
			{rdelim}
		{rdelim}
		object.style.backgroundColor = "#579ddb";
		object.style.color="white";
	{rdelim}
	
	{if $event->info.event_type_code == 'f3k'}
	function check_flight_total_time(object){ldelim}
		/* Function to check a single sub flight time against the max time and reset it if needed */
		const zeroPad = (num, places) => String(num).padStart(places, '0');
		max_flight_seconds = {$event->rounds.$round_number.flights.$flight_type_id.flight_type_sub_flights_max_time};
		/* Get the current entered time to compare */
		/* First get the sub flight number from the name of this object */
		flight_num = object.id.match(/\d+/);
		current_minutes = parseInt( document.getElementById("sub_" + flight_num + "_minutes_button").value, 10 );
		current_seconds = parseInt( document.getElementById("sub_" + flight_num + "_seconds_button").value, 10 );
		current_seconds2 = parseInt( document.getElementById("sub_" + flight_num + "_seconds2_button").value, 10 );
		current_total_seconds = ( current_minutes * 60 ) + current_seconds + ( current_seconds2 * 0.1 );
		if( current_total_seconds > max_flight_seconds ){ldelim}
			/* reset the values for this flight to be the max */
			calc_min = Math.floor( max_flight_seconds / 60 );
			calc_sec = Math.floor( max_flight_seconds % 60 );
			document.getElementById("sub_" + flight_num + "_minutes_button").value = calc_min;
			document.getElementById("sub_" + flight_num + "_seconds_button").value = zeroPad(calc_sec,2);
			document.getElementById("sub_" + flight_num + "_seconds2_button").value = 0;
			/* change the form vars too */
			document.getElementById("sub_min_" + flight_num ).value = calc_min;
			document.getElementById("sub_sec_" + flight_num ).value = zeroPad(calc_sec,2);
			document.getElementById("sub_sec2_" + flight_num ).value = 0;
			
			alert( "Updated Flight #" + flight_num + " to max flight time." );
			goToNextFlight(object);
		{rdelim}
		return;
	{rdelim}
	function check_total_round_time(){ldelim}
		max_round_seconds = {$max_round_seconds};
		num_subs = {$event->rounds.$round_number.flights.$flight_type_id.flight_type_sub_flights};
		calculated_time = 0;
		for( x = 1; x <= num_subs ; x++ ){ldelim}
			flight_minutes = parseInt( document.getElementById("sub_" + x + "_minutes_button").value, 10 );
			flight_seconds = parseInt( document.getElementById("sub_" + x + "_seconds_button").value, 10 );
			flight_seconds2 = parseInt( document.getElementById("sub_" + x + "_seconds2_button").value, 10 );
			calculated_time += ( flight_minutes * 60 ) + flight_seconds + ( flight_seconds2 * 0.1 );
		{rdelim}
		if( calculated_time > max_round_seconds ){ldelim}
			alert("Total time greater than the allowed " + max_round_seconds + " seconds time! Please reconsider your flight entries.");
			return false;
		{rdelim}
		return true;
	{rdelim}
	function check_f3kminute(object){ldelim}
		max_flight_seconds = {$event->rounds.$round_number.flights.$flight_type_id.flight_type_sub_flights_max_time};
		max_min = Math.floor( max_flight_seconds / 60 );
		flight_num = object.id.match(/\d+/);
		if( object.value > max_min ){ldelim}
			object.value=max_min;
			document.getElementById("sub_min_" + flight_num ).value = max_min;
			if( object.value * 60 >= max_flight_seconds ){ldelim}
				goToNextFlight(object);
			{rdelim}else{ldelim}
				make_unselected(object);
				goToNextTab(object);
			{rdelim}
			return;
		{rdelim}
		if( object.value.length == 1 ){ldelim}
			if( object.value * 60 >= max_flight_seconds ){ldelim}
				goToNextFlight(object);
			{rdelim}else{ldelim}
				make_unselected(object);
				goToNextTab(object);
			{rdelim}
		{rdelim}
		return;
	{rdelim}
	{/if}
	{if $event->info.event_type_code == 'f5j' || $event->info.event_type_code == 'f3j'}
	function check_5jminute(object){ldelim}
		/* Set max min */
		max_min = {if $event->tasks.$round_number.event_task_time_choice > 0}{$event->tasks.$round_number.event_task_time_choice - 1 }{else}0{/if};
		if( object.value > max_min ){ldelim}
			object.value=max_min;
		{rdelim}
		if( max_min > 10 ){ldelim}
			if( object.value.length == 2 ){ldelim}
				make_unselected(object);
				goToNextTab(object);
			{rdelim}
		{rdelim}else{ldelim}
			if( object.value.length == 1 ){ldelim}
				make_unselected(object);
				goToNextTab(object);
			{rdelim}
		{rdelim}
		return;
	{rdelim}
	{/if}
	{if $event->info.event_type_code == 'gps'}
	function check_gpsminute(object){ldelim}
		/* Set max min */
		max_min = 29;
		if( object.value > max_min ){ldelim}
			object.value=max_min;
		{rdelim}
		if( object.value.length == 2 ){ldelim}
			make_unselected(object);
			goToNextTab(object);
		{rdelim}
		return;
	{rdelim}
	{/if}
	{if $event->info.event_type_code == 'td'}
	function check_tdminute(object){ldelim}
		/* Set max min */
		max_min = {if $event->tasks.$round_number.event_task_time_choice > 0}{$event->tasks.$round_number.event_task_time_choice}{else}0{/if};
		if( max_min >= 10 ){ldelim}
			if( object.value.length == 2 ){ldelim}
				make_unselected(object);
				goToNextTab(object);
			{rdelim}
		{rdelim}else{ldelim}
			if( object.value.length == 1 ){ldelim}
				make_unselected(object);
				goToNextTab(object);
			{rdelim}
		{rdelim}
		return;
	{rdelim}
	{/if}
	function check_second(object){ldelim}
		max_sec = 59;
		flight_num = object.id.match(/\d+/);
		if( object.value > max_sec ){ldelim}
			object.value=max_sec;
			document.getElementById("sub_sec_" + flight_num ).value = max_sec;
		{rdelim}
		if( object.value.length == 2){ldelim}
			make_unselected(object);
			goToNextTab(object);
		{rdelim}
		return;
	{rdelim}
	function check_tenth(object){ldelim}
		max_sec2 = 9;
		if( object.value > max_sec2 ){ldelim}
			object.value=max_sec2;
		{rdelim}
		if( object.value.length == 1){ldelim}
			make_unselected(object);
			goToNextTab(object);
		{rdelim}
		return;
	{rdelim}
	function check_hundredth(object){ldelim}
		max_sec2 = 99;
		if( object.value > max_sec2 ){ldelim}
			object.value=max_sec2;
		{rdelim}
		if( object.value.length == 2){ldelim}
			make_unselected(object);
			goToNextTab(object);
		{rdelim}
		return;
	{rdelim}
	{if $event->info.event_type_code == 'f5j'}
	function check_height(object){ldelim}
		max_min = 350;
		if( object.value > max_min ){ldelim}
			object.value=max_min;
		{rdelim}
		if( object.value.length == 3){ldelim}
			make_unselected(object);
			goToNextTab(object);
		{rdelim}
		return;
	{rdelim}
	{/if}
	{if $event->info.event_type_code == 'gps'}
	function check_gpslaps(object){ldelim}
		max_min = 99;
		if( object.value > max_min ){ldelim}
			object.value=max_min;
		{rdelim}
		if( object.value.length == 2){ldelim}
			make_unselected(object);
			goToNextTab(object);
		{rdelim}
		return;
	{rdelim}
	function check_startpen(object){ldelim}
		max_min = 999;
		if( object.value > max_min ){ldelim}
			object.value=max_min;
		{rdelim}
		if( object.value.length == 3){ldelim}
			make_unselected(object);
			goToNextTab(object);
		{rdelim}
		return;
	{rdelim}
	{/if}
	{literal}
	function goToNextTab(element){
		if(event.code == "Tab"){ return; }
		var nextEl = findNextTabStop(element);
		var elementName = nextEl.getAttribute( 'id' );
		nextEl.focus();
		if( ! elementName.match("penalty") ){
			nextEl.click();
		}
	}
	function goToNextFlight(element){
		flight_num = parseInt( element.id.match(/\d+/), 10 );
		var next_flight = flight_num + 1;
		if( document.getElementById( "sub_" + next_flight + "_minutes_button" ) ){
			/* Go to the next flight minute */
			document.getElementById( "sub_" + next_flight + "_minutes_button" ).focus();
			document.getElementById( "sub_" + next_flight + "_minutes_button" ).click();
		}else{
			element.blur();
		}
		return;
	}
	function findNextTabStop(el) {
		var universe = document.querySelectorAll('input');
		var list = Array.prototype.filter.call(universe, function(item) {return item.tabIndex >= "0"});
		var index = list.indexOf(el);
		return list[index + 1] || list[0];
	}
	{/literal}
</script>

{/block}
{block name="footer"}
{/block}
