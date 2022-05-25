{extends file='layout/layout_main.tpl'}

{block name="header"}
<script src='https://www.google.com/recaptcha/api.js'></script>
{literal}
<style>
table {
  text-align: left;
  position: relative;
  border-collapse: collapse; 
}

thead {
  background: white;
  z-index: 4;
  position: sticky;
  top: 0; /* Don't forget this, required for the stickiness */
}
thead th {
  position: sticky;
  left: 0;
  z-index: 2;
}
tbody th:first-child {
  position: sticky;
  left: 0;
  background: white;
  z-index: 1;
}
::-webkit-scrollbar {
  -webkit-appearance: none;
  width: 7px;
}

::-webkit-scrollbar-thumb {
  border-radius: 4px;
  background-color: rgba(0, 0, 0, .5);
  box-shadow: 0 0 1px rgba(255, 255, 255, .5);
}

</style>
{/literal}
{/block}

{block name="content"}

{include file="event/event_view_top_info.tpl"}

<div class="panel" style="min-width:1100px;background-color:#337ab7;">
	<div class="panel-body">
		<div class="tab-base" style="margin-top: 10px;">
			<ul class="nav nav-tabs">
				<li>
					<a href="?action=event&function=event_view&event_id={$event->info.event_id}&tab=0">
						Preliminary Rounds
						<span class="badge badge-blue">{$total_prelim_rounds}</span>
					</a>
				</li>
				{if $total_flyoff_rounds>0}
				<li>
					<a href="?action=event&function=event_view&event_id={$event->info.event_id}&tab=1">
						Flyoff Rounds
						<span class="badge badge-blue">{$total_flyoff_rounds}</span>
					</a>
				</li>
				{/if}
				<li>
					<a href="?action=event&function=event_view&event_id={$event->info.event_id}&tab=2">
						Pilots
						<span class="badge badge-blue">{$event->pilots|count}</span>
					</a>
				</li>
				{if $active_draws}
				<li>
					<a href="?action=event&function=event_view&event_id={$event->info.event_id}&tab=3">
						Draw
					</a>
				</li>
				{/if}
				{if $event->rounds|count>0}
				<li>
					<a href="?action=event&function=event_view&event_id={$event->info.event_id}&tab=4">
						Position Chart
					</a>
				</li>
				{/if}
				{if $event->rounds|count>0 && ($event->classes|count > 1 || $event->totals.teams || $duration_rank || $speed_rank || $round_wins)}
				<li>
					<a href="?action=event&function=event_view&event_id={$event->info.event_id}&tab=5">
						Rankings
					</a>
				</li>
				{/if}
				{if $event->rounds|count>0 && ($lap_totals || $speed_averages || $top_landing || $event->planes|count>0)}
				<li>
					<a href="?action=event&function=event_view&event_id={$event->info.event_id}&tab=6">
						Stats
					</a>
				</li>
				{/if}
				{if $event->rounds|count>0 && $graphs}
				<li>
					<a href="?action=event&function=event_view&event_id={$event->info.event_id}&tab=7">
						Graphs
					</a>
				</li>
				{/if}
				<li class="active">
					<a href="#" aria-expanded="true" aria-selected="true">
						Send Messages
					</a>
				</li>
			</ul>
			<div class="tab-content">
				<div id="pilot-tab-8" class="tab-pane fade active in">
					<h2 style="float:left;">Send Messages</h2>
					<br style="clear:left;">
					<div>
						<div>                
							<h4 style="float:left;">Send Message to Pilots, Organizers or the Contest Director using templates or your own custom message.</h4>
							<br style="clear:left;">
							<form name="main" method="POST">
							<input type="hidden" name="action" value="event_message">
							<input type="hidden" name="function" value="event_message_send">
							<input type="hidden" name="save" value="1">
							<input type="hidden" name="to" value="">

							<table cellpadding="2" cellspacing="1" class="table table-condensed table-event">
								<tr>
									<th>Message Subject</th>
									<td>
										<input type="text" size="60" name="message_subject" value="{$message_subject|escape}">
									</td>
									<th>Send Message To &nbsp;&nbsp;&nbsp;&nbsp;
										<div class="btn-group">
											<button class="btn btn-primary dropdown-toggle btn-rounded" data-toggle="dropdown" type="button" style="height: 20px;padding-top: 0px;">
												<span id="button_label">Select Group Of Pilots</span> <i class="dropdown-caret fa fa-caret-down"></i>
											</button>
											<ul class="dropdown-menu dropdown-menu-right">
												<li><a href="#" onClick="document.getElementById('button_label').innerText='Contest Director';close_additional_menus();select_recipients( 'cd' );">Contest Director</a></li>
												<li><a href="#" onClick="document.getElementById('button_label').innerText='Contest Organizers';close_additional_menus();select_recipients( 'org' );">Contest Organizers</a></li>
												<li class="dropdown-header"></li>
												<li><a href="#" onClick="document.getElementById('button_label').innerText='Individually Selected pilots';">Individually Selected pilots</a></li>
												<li><a href="#" onClick="document.getElementById('button_label').innerText='All Pilots';close_additional_menus();select_recipients( 'all' );">All Contest Pilots</a></li>
												<li><a href="#" onClick="document.getElementById('button_label').innerText='Pilots In Class';close_additional_menus();document.getElementById('class_dropdown').style.display='inline-block';document.getElementById('class_label').innerText='Select Class';">Pilots In Class</a></li>
												<li><a href="#" onClick="document.getElementById('button_label').innerText='Pilots On Team';close_additional_menus();document.getElementById('team_dropdown').style.display='inline-block';document.getElementById('team_label').innerText='Select Team';">Pilots On Team</a></li>
												<li><a href="#" onClick="document.getElementById('button_label').innerText='Pilots With Registration Due';close_additional_menus();select_recipients( 'due' );">Pilots With Registration Due</a></li>
												<li><a href="#" onClick="document.getElementById('button_label').innerText='Pilots With Registration Paid';close_additional_menus();select_recipients( 'paid' );">Pilots With Registration Paid</a></li>
											</ul>
										</div>
										<div id="class_dropdown" class="btn-group" style="display: none;">
											<button class="btn btn-primary dropdown-toggle btn-rounded" data-toggle="dropdown" type="button" style="height: 20px;padding-top: 0px;">
												<span id="class_label">Select Class</span> <i class="dropdown-caret fa fa-caret-down"></i>
											</button>
											<ul class="dropdown-menu dropdown-menu-right">
												{foreach $classes as $c}
												<li><a href="#" onClick="document.getElementById('class_label').innerText='{$c.class_description|escape}';select_recipients( 'class', '{$c.class_id|escape}' );">{$c.class_description|escape}</a></li>
												{/foreach}
											</ul>
										</div>
										<div id="team_dropdown" class="btn-group" style="display: none;">
											<button class="btn btn-primary dropdown-toggle btn-rounded" data-toggle="dropdown" type="button" style="height: 20px;padding-top: 0px;">
												<span id="team_label">Select Team</span> <i class="dropdown-caret fa fa-caret-down"></i>
											</button>
											<ul class="dropdown-menu dropdown-menu-right">
												{foreach $event->teams as $t}
												<li><a href="#" onClick="document.getElementById('team_label').innerText='{$t.event_pilot_team|escape}';select_recipients( 'team', '{$t.event_pilot_team|replace:' ':'_'}' );">{$t.event_pilot_team|escape}</a></li>
												{/foreach}
											</ul>
										</div>
									</th>
								</tr>
								<tr>
									<th>Message From</th>
									<td width="5%" nowrap>
										<input type="radio" name="message_from" value="0" {if $message_from == 0} CHECKED{/if}> F3XVault System (will not be able to reply to email)<br>
										<input type="radio" name="message_from" value="1" {if $message_from == 1} CHECKED{/if}> My Email Address <input type="text" name="from_email_address" size="40" value="{if $from_email_address != ''}{$from_email_address|escape}{else}{$user.user_email|escape}{/if}">
									</td>
									<td rowspan="3">
										<table cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-event">
										<thead>
											<tr>
												<th width="2%" align="left"></th>
												<th align="left" colspan="2">Name</th>
												<th align="left">Role</th>
											</tr>
										</thead>
										<tbody>
										{foreach $event->event_users as $p}
											<tr>
												<td>
													<input type="checkbox" name="pilot_{$p.pilot_id|escape}" id="pilot_{$p.pilot_id|escape}" class="{if $p.type == 'cd'} cd{/if} {if $p.type == 'admin' || $p.type == 'cd'} admin{/if} organizer" {if in_array( $p.pilot_id, $recipients ) } CHECKED{/if}>
												</td>
												<td width="1%" nowrap>
													{if $p.country_code}<img src="/images/flags/countries-iso/shiny/16/{$p.country_code|escape}.png" class="inline_flag" title="{$p.country_code}">{else}<img src="/images/1x1.png" width="16" style="display:inline;">{/if}
													{if $p.state_name && $p.country_code=="US"}<img src="/images/flags/states/16/{$p.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$p.state_name}">{else}<img src="/images/1x1.png" width="16" style="display:inline;">{/if}
												</td>
												<td>
													&nbsp;{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}
												</td>
												<td>
													{if $p.type == 'cd'}Contest Director{/if}
													{if $p.type == 'event_owner'}Organizer{/if}
													{if $p.type == 'admin'}Contest Admin{/if}
												</td>
											</tr>
										{/foreach}
										</tbody>
										</table>
										<div style="overflow:scroll; height:530px;">
											<table cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-event">
											<thead>
												<tr>
													<th width="2%" align="left"></th>
													<th width="2%" align="left"></th>
													<th width="2%" align="left">#</th>
													<th align="left" colspan="2">Pilot Name</th>
													<th align="left">Pilot Class</th>
													{if $event->info['event_reg_teams'] == 1}
														<th align="left">Event Team</th>
													{/if}
													<th align="right">Reg Status</th>
												</tr>
											</thead>
											<tbody>
											{if $event->pilots|count >0}
												{assign var=num value=1}
												{foreach $event->pilots as $p}
												<tr>
													<td>
														<input type="checkbox" name="pilot_{$p.pilot_id|escape}" id="pilot_{$p.pilot_id|escape}" class="allpilots {if $p.event_pilot_paid_flag==1}paid{else}due{/if} {if $p.class_id != 0}class_{$p.class_id|escape}{/if} {if $p.event_pilot_team != ''}team_{$p.event_pilot_team|replace:' ':'_'}{/if} {if ! $p.pilot_email}noemail{/if} " {if in_array( $p.pilot_id, $recipients ) } CHECKED{/if}>
													</td>
													<td>
														{if $p.pilot_email}
															<a href="" class="tooltip_score_right" onClick="return false;">
																<img width="25" src="/images/icons/bullet_green.png" />
																<span>
																	<b>Valid Email<br>
																</span>
															</a>
														{else}
															<a href="" class="tooltip_score_right" onClick="return false;">
															<img width="25" src="/images/icons/bullet_red.png" />
															<span>
																<b>No Email Address<br>
															</span>
														</a>
														{/if}
													</td>
													<td>{$num}</td>
													<td width="1%" nowrap>
														{if $p.country_code}<img src="/images/flags/countries-iso/shiny/16/{$p.country_code|escape}.png" class="inline_flag" title="{$p.country_code}">{else}<img src="/images/1x1.png" width="16" style="display:inline;">{/if}
														{if $p.state_name && $p.country_code=="US"}<img src="/images/flags/states/16/{$p.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$p.state_name}">{else}<img src="/images/1x1.png" width="16" style="display:inline;">{/if}
													</td>
													<td{if $p.event_pilot_draw_status==0} bgcolor="lightgrey"{/if}>
														{if $p.event_pilot_bib!='' && $p.event_pilot_bib!=0}
															<div class="pilot_bib_number">{$p.event_pilot_bib}</div>
														{/if}
														&nbsp;{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}
													</td>
													<td>{$p.class_description|escape}</td>
													{if $event->info.event_reg_teams == 1}
														<td>{$p.event_pilot_team|escape}</td>
													{/if}
													{if $event->info.event_reg_flag==1}
														<td align="right">
															{if $p.event_pilot_paid_flag==1}
															<font color="green">PAID</font>
															{else}
															<font color="red">DUE</font>
															{/if}
														</td>
													{/if}
												</tr>
												{assign var=num value=$num+1}
												{/foreach}
											{else}
												<tr>
													<td colspan="5">Currently no pilots registered for this event.</td>
												</tr>
											{/if}
											</tbody>
											</table>
										</div>
									</td>									
								</tr>
								<tr>
									<th>Message Template</th>
									<td>
										<div class="btn-group">
											<button id="templateSelection" class="btn btn-primary dropdown-toggle btn-rounded" data-toggle="dropdown" type="button" style="height: 20px;padding-top: 0px;">
												Insert Message Template <i class="dropdown-caret fa fa-caret-down"></i>
											</button>
											<ul class="dropdown-menu dropdown-menu-right">
												<li><a href="#" onClick="add_template( 'registration' );">Registration Payment Reminder</a></li>
												<li><a href="#" onClick="add_template( 'event_info' );">Event Update</a></li>
											</ul>
										</div>
									</td>
								</tr>
								<tr>
									<th>Message Text</th>
									<td width="5%" nowrap>
										<textarea style="height: 600px;" cols="60" rows="25" id="message_body" name="message_body">{$message_body|escape}</textarea><br>
										<div class="g-recaptcha" data-sitekey="{$recaptcha_key|escape}"></div>
									</td>

								</tr>
								<tr>
									<th colspan="3" align="center" style="text-align: center;">
										<button class="btn btn-primary dropdown-toggle btn-rounded" type="button" style="justify-content: center;" onClick="document.main.submit();">
											Send Message
										</button>
									</th>
								</tr>
							</table>


							</form>

							<br>
						</div>
					</div>
				</div>
			</div>
			<br>
		</div>
	</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
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
<script src="/includes/highcharts/js/highcharts.js"></script>
{literal}
<script type="text/javascript">
function close_additional_menus(){
	document.getElementById('class_dropdown').style.display='none';
	document.getElementById('team_dropdown').style.display='none';
	return;
}
function select_recipients( type, value='' ){
	/* Script to select the recipients when the Send Message button is pressed */
	/* first deselect all pilots */
	var pilots = document.getElementsByClassName("allpilots");
	Array.prototype.forEach.call(pilots, function(pilot){
		pilot.checked = false;
	});
	/* Now clear all of the organizers */
	var pilots = document.getElementsByClassName("organizer");
	Array.prototype.forEach.call(pilots, function(pilot){
		pilot.checked = false;
	});
	switch( type ){
		case 'all':
			/* Select all of the pilots */
			var pilots = document.getElementsByClassName("allpilots");
			Array.prototype.forEach.call(pilots, function(pilot){
				pilot.checked = true;
			});
			break;
		case 'due':
			/* Select all of the pilots that are still due */
			var pilots = document.getElementsByClassName("due");
			Array.prototype.forEach.call(pilots, function(pilot){
				pilot.checked = true;
			});
			break;
		case 'paid':
			/* Select all of the pilots that are still due */
			var pilots = document.getElementsByClassName("paid");
			Array.prototype.forEach.call(pilots, function(pilot){
				pilot.checked = true;
			});
			break;
		case 'cd':
			/* Select all of the pilots that are still due */
			var pilots = document.getElementsByClassName("cd");
			Array.prototype.forEach.call(pilots, function(pilot){
				pilot.checked = true;
			});
			break;
		case 'org':
			/* Select all of the pilots that are still due */
			var pilots = document.getElementsByClassName("organizer");
			Array.prototype.forEach.call(pilots, function(pilot){
				pilot.checked = true;
			});
			break;
		case 'class':
			/* Select all of the pilots that are in a particular class */
			var pilots = document.getElementsByClassName("class_" + value );
			Array.prototype.forEach.call(pilots, function(pilot){
				pilot.checked = true;
			});
			break;
		case 'team':
			/* Select all of the pilots that are in a particular team */
			var pilots = document.getElementsByClassName("team_" + value );
			Array.prototype.forEach.call(pilots, function(pilot){
				pilot.checked = true;
			});
			break;
	}
	/* uncheck all that have no email */
	var pilots = document.getElementsByClassName("noemail");
	Array.prototype.forEach.call(pilots, function(pilot){
		pilot.checked = false;
	});
	return;
}
function add_template( template ){
	/* Function to add an easy template text to the message text area */
	textAreaObject = document.getElementById('message_body');
	templateText = '';
	switch( template ){
		case 'event_info':
			templateText = `Dear {$pilot_first_name},<br>
<br>
The following additional information for the event : <br>
<br>
<table cellpadding="2" cellspacing="1" border="0">
	<tr>
		<th align="right" width="20%" align="right" bgcolor="#1f6eb6" style="color:white;">Event Name</th>
		<td>{$event_name}</td>
	</tr>
	<tr>
		<th align="right" width="20%" align="right" bgcolor="#1f6eb6" style="color:white;">Event Date</th>
		<td>{$event_start_date|date_format:"Y-m-d"}</td>
	</tr>
	<tr>
		<th align="right" width="20%" align="right" bgcolor="#1f6eb6" style="color:white;">Event Type</th>
		<td>{$event_type_name}</td>
	</tr>
	<tr>
		<th align="right" width="20%" align="right" bgcolor="#1f6eb6" style="color:white;">Information</th>
		<td>
	
			INFORMATION (REPLACE ME)
	
		</td>
	</tr>
</table>
<br>
You can go to the event link <a href="http://www.f3xvault.com/?action=event&function=event_view&event_id={$event_id}">HERE</a><br>
<br>
Thank you,<br>
<br>
Your Event Organizers
`;
			break;
		case 'registration':
			templateText = `Dear {$pilot_first_name},<br>
<br>
This is a reminder to that the registration payment is due for the following event :<br>
<br>
<table cellpadding="2" cellspacing="1" border="0">
	<tr>
		<th align="right" width="20%" align="right" bgcolor="#1f6eb6" style="color:white;">Event Name</th>
		<td>{$event_name}</td>
	</tr>
	<tr>
		<th align="right" width="20%" align="right" bgcolor="#1f6eb6" style="color:white;">Event Date</th>
		<td>{$event_start_date|date_format:"Y-m-d"}</td>
	</tr>
	<tr>
		<th align="right" width="20%" align="right" bgcolor="#1f6eb6" style="color:white;">Event Type</th>
		<td>{$event_type_name}</td>
	</tr>
	<tr>
		<th align="right" width="20%" align="right" bgcolor="#1f6eb6" style="color:white;">Amount Owed</th>
		<td>{if $event->info.currency_symbol != ''}{$event->info.currency_symbol|escape}{else}\${/if} {$amount_due}</td>
	</tr>
</table>
<br>
Please log into your F3XVault account and make payment to ensure your spot in the competition.<br>
<br>
You can go to the event link <a href="http://www.f3xvault.com/?action=event&function=event_view&event_id={$event_id}">HERE</a><br>
<br>
Thank you,<br>
<br>
Your Event Organizers
`;
			break;
	}
	textAreaObject.value = templateText;
	return;
}
</script>
{/literal}
<script type="text/javascript">
function check_permission() {ldelim}
	{if $permission!=1}
		alert('Sorry, but you do not have permission to edit this event. Contact the event owner if you need access to edit this event.');
		return 0;
	{else}
		return 1;
	{/if}
{rdelim}
{if $to}
select_recipients( '{$to}' );
{/if}
</script>
{/block}
