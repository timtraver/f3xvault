{extends file='layout/layout_main.tpl'}

{block name="header"}
<script src="/js/moment.min.js"></script>
<script src="/js/moment-timezone-with-data.min.js"></script>
<script type="text/javascript">
	function guess_open_zone(){ldelim}
		return moment.tz.guess();
	{rdelim}
</script>
{/block}

{block name="content"}
<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Event Edit</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
</div>
<div class="panel" style="background-color:#337ab7;">
	<div class="panel-body">
		<div class="tab-base" style="margin-top: 10px;">
			<ul class="nav nav-tabs">
				<li>
					<a href="?action=event&function=event_edit&event_id={$event->info.event_id}&tab=0">
						Basic Event Parameters
					</a>
				</li>
				<li>
					<a href="?action=event&function=event_edit&event_id={$event->info.event_id}&tab=1">
						Advanced Parameters
					</a>
				</li>
				<li class="active">
					<a href="#" aria-expanded="true" aria-selected="true">
						Registration Parameters
					</a>
				</li>
				<li>
					<a href="?action=event&function=event_edit&event_id={$event->info.event_id}&tab=2">
						Event Series
					</a>
				</li>
				<li>
					<a href="?action=event&function=event_edit&event_id={$event->info.event_id}&tab=3">
						Admin Access
					</a>
				</li>
			</ul>
			<div class="tab-content">
				<div id="pilot-tab-4" class="tab-pane fade active in">
					<h2 style="float:left;">Event Registration Parameters</h2>

					<form name="main" method="POST">
					<input type="hidden" name="action" value="event">
					<input type="hidden" name="function" value="event_reg_save">
					<input type="hidden" name="event_id" value="{$event->info.event_id}">
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
					<tr>
						<th width="20%">Registration Status</th>
						<td>
							<input type="radio" name="event_reg_status" value="0"{if $event->info.event_reg_status == 0} CHECKED{/if}> Event Registration is Closed<br>
							<input type="radio" name="event_reg_status" value="1"{if $event->info.event_reg_status == 1} CHECKED{/if}> Event Registration is Open<br>
							<input type="radio" name="event_reg_status" value="2"{if $event->info.event_reg_status == 2} CHECKED{/if}> Event Registration Opens on &nbsp;&nbsp;
								{html_select_date prefix="event_reg_open_date" end_year="+3" day_format="%02d" day_value_format="%02d" time=$event->info.event_reg_open_date_stamp}
								&nbsp;&nbsp;
								{html_select_time prefix="event_reg_open_date" use_24_hours=false display_seconds=false display_meridian=true time=$event->info.event_reg_open_date_stamp}
								
								<select name="event_reg_open_tz">
								{foreach timezone_identifiers_list() as $t}
								<option value="{$t}"{if $event->info.event_reg_open_tz == $t} SELECTED{/if}>{$t}</option>
								{/foreach}
								</select>
								<br>
						</td>
					</tr>
					<tr>
						<th>Registration Till Date</th>
						<td>
							<input type="checkbox" name="event_reg_close_on"{if $event->info.event_reg_close_on == 1} CHECKED{/if}> Close Registration On &nbsp;&nbsp;
							{html_select_date prefix="event_reg_close_date" end_year="+3" day_format="%02d" day_value_format="%02d" time=$event->info.event_reg_close_date_stamp}
							&nbsp;&nbsp;
							{html_select_time prefix="event_reg_close_date" use_24_hours=false display_seconds=false display_meridian=true time=$event->info.event_reg_close_date_stamp}
						
							<select name="event_reg_close_tz">
							{foreach timezone_identifiers_list() as $t}
							<option value="{$t}"{if $event->info.event_reg_close_tz == $t} SELECTED{/if}>{$t}</option>
							{/foreach}
							</select>
						</td>
					</tr>
					<tr>
						<th>Registration Max Participants</th>
						<td>
							<input type="text" size="3" name="event_reg_max" value="{$event->info.event_reg_max}"> 0=unlimited
						</td>
					</tr>
					<!--
					<tr>
						<th>Registration Has Wait List</th>
						<td>
							<input type="checkbox" name="event_reg_waitlist"{if $event->info.event_reg_waitlist} CHECKED{/if}> Allow registration to have a wait list when full
						</td>
					</tr>
					-->
					<tr>
						<th nowrap>Registration Requires Payment</th>
						<td>
							<input type="checkbox" name="event_reg_pay_flag"{if $event->info.event_reg_pay_flag==1} CHECKED{/if}>
						</td>
					</tr>
					<tr>
						<th>Payment Currency</th>
						<td>
							<select name="currency_id">
							{foreach $currencies as $c}
							<option value="{$c.currency_id}"{if $event->info.currency_id==$c.currency_id} SELECTED{/if}>{$c.currency_name} {$c.currency_html}</option>
							{/foreach}
							</select>
						</td>
					</tr>
					<tr>
						<th>PayPal Email Address (For Payment)</th>
						<td>
							<input type="text" size="40" name="event_reg_paypal_address" value="{$event->info.event_reg_paypal_address}">
						</td>
					</tr>
					<tr>
						<td colspan="3" style="text-align: center;">
							<input type="submit" value=" Save Registration Parameters " class="btn btn-primary btn-rounded" onClick="return check_event();">
						</td>
					</tr>
					</table>
					
					<h3 class="post-title entry-title">Additional Registration Values</h3>
					<select name="event_reg_add_name" style="float:left;">
					<option value="0">Select From This list for Common Registration values to add</option>
					<option value="">Blank Entry For Customization</option>
					<option value="Event Registration Fee">Event Registration Fee</option>
					<option value="Battery Rental">Battery Rental</option>
					<option value="T-Shirt Purchase">T-Shirt Purchase</option>
					<option value="Breakfast Meal">Breakfast Meal</option>
					<option value="Lunch Meal">Lunch Meal</option>
					<option value="Dinner Meal">Dinner Meal</option>
					<option value="Opening Banquet">Opening Banquet</option>
					<option value="Closing Banquet">Closing Banquet</option>
					<option value="Team Pilot Credential">Team Pilot Credential</option>
					<option value="Team Manager Credential">Team Manager Credential</option>
					<option value="Team Helper Credential">Team Helper Credential</option>
					</select>
					<div class="btn-group btn-group-xs" style="float: left;margin-left: 15px;"><button class="btn btn-primary btn-rounded" type="button" onclick="document.main.submit();"> Add New Value </button></div>
					
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
					<tr>
						<th width="5%">Mandatory</th>
						<th width="20%">Name</th>
						<th>Full Description (For Details if necessary)</th>
						<th width="5%">Allow<br>Qty</th>
						<th width="8%">Cost Per<br>Unit</th>
						<th width="20%">Choice List</th>
						<th width="5%"></th>
					</tr>
					{if $event->reg_options}
					{foreach $event->reg_options as $r}
					<tr>
						<td valign="top">
							<input type="checkbox" name="reg_param_{$r.event_reg_param_id}_man"{if $r.event_reg_param_mandatory==1} CHECKED{/if}>
						</td>
						<td valign="top">
							<input type="text" name="reg_param_{$r.event_reg_param_id}_name" size="30" value="{$r.event_reg_param_name}">
						</td>
						<td>
							<textarea name="reg_param_{$r.event_reg_param_id}_desc" cols="30" rows="2">{$r.event_reg_param_description}</textarea>
						</td>
						<td>
							<input type="checkbox" name="reg_param_{$r.event_reg_param_id}_qty"{if $r.event_reg_param_qty_flag==1} CHECKED{/if}>
						</td>
						<td>
							<input type="text" name="reg_param_{$r.event_reg_param_id}_cost" size="6" value="{$r.event_reg_param_cost}">
						</td>
						<td align="right">
							Name<input type="text" name="reg_param_{$r.event_reg_param_id}_choice_name" size="25" value="{$r.event_reg_param_choice_name}"><br>
							Values<input type="text" name="reg_param_{$r.event_reg_param_id}_choice_values" size="25" value="{$r.event_reg_param_choice_values}">
						</td>
						<td>
							<a title="Delete" href="?action=event&function=event_reg_del&event_id={$event->info.event_id}&event_reg_param_id={$r.event_reg_param_id}"><img src="/images/del.gif"></a>
						</td>
					</tr>
					{/foreach}
					<tr>
						<td colspan="7" style="text-align: center;">
							<input type="submit" value=" Save Registration Parameters " class="btn btn-primary btn-rounded" onClick="return check_event();">
						</td>
					</tr>
					{else}
					<tr>
						<td colspan="7">
							This event currently has no additional registration parameters
						</td>
					</tr>
					{/if}
					</table>
					</form>

				</div>
			</div>
		</div>
	</div>
	<br>
</div>


<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="tab" value="">
</form>
{/block}

{block name="footer"}
{if $event->info.event_reg_open_date_stamp == 0 || !$event->info.event_reg_open_date_stamp}
<script type="text/javascript">
	document.main.event_reg_open_tz.value = guess_open_zone();
</script>
{/if}
{if $event->info.event_reg_close_date_stamp == 0 || !$event->info.event_reg_close_date_stamp}
<script type="text/javascript">
	document.main.event_reg_close_tz.value = guess_open_zone();
</script>
{/if}
{/block}