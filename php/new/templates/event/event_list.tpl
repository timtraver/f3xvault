{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">Browse F3X Event List</h2>
	</div>
	<div class="panel-body">
		<br style="clear:left;">

		<div style="float:left;">
			<form name="search_form" method="POST">
			<input type="hidden" name="action" value="event">
			<input type="hidden" name="function" value="event_list">
			<table class="filter" cellpadding="2" cellspacing="2">
				<tr>
					<th colspan="2">Filter Results</th>
				</tr>
				<tr>
					<td align="right">Country</td>
					<td nowrap>
						<select name="country_id" onChange="document.search_form.state_id.value=0;search_form.submit();">
						<option value="0">Choose Country to Narrow Search</option>
						{foreach $countries as $country}
							<option value="{$country.country_id}" {if $country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
						{/foreach}
						</select>
			
					</td>
				</tr>
				<tr>
					<td align="right">State</td>
					<td nowrap>
						<select name="state_id" onChange="search_form.submit();">
						<option value="0">Choose State to Narrow Search</option>
						{foreach $states as $state}
							<option value="{$state.state_id}" {if $state_id==$state.state_id}SELECTED{/if}>{$state.state_name}</option>
						{/foreach}
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">Name</td>
					<td nowrap>
						<input type="text" name="search" size="20" value="{$search|escape}">
						<input type="submit" value=" Search " class="btn btn-primary btn-rounded">
						<input type="submit" value=" Reset " class="btn btn-primary btn-rounded" onClick="document.search_form.country_id.value=0;document.search_form.state_id.value=0;document.search_form.search.value='';search_form.submit();">
					</td>
				</tr>
			</table>
			</form>
		</div>
		<div style="float:right;overflow:hidden;">
			<input type="button" value=" Create New Event " onclick="{if $user.user_id!=0}newevent.submit();{else}alert('You must be registered and logged in to create a new event.');{/if}" class="btn btn-primary btn-rounded">
		</div>
		<br style="clear:left;">
		<br>
		<div style="border-style:solid;border-width:1px;width:110px;background:lightblue;float:left;text-align:center;">Future Event</div>
		<div style="border-style:solid;border-width:1px;width:110px;background:lightgreen;float:left;text-align:center;">Current Event</div>
		<div style="border-style:solid;border-width:1px;width:110px;background:#C8F7C8;float:left;text-align:center;">Recent Event</div>
		<div style="border-style:solid;border-width:1px;width:110px;background:white;float:left;text-align:center;">Completed Event</div>
		<br>
		<br>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr class="table-row-heading-left">
			<th colspan="2" style="text-align: left;" nowrap>Events (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
			<th colspan="5" nowrap>
				{include file="paging.tpl"}
			</th>
		</tr>
		<tr>
			<th width="10%" style="text-align: left;" nowrap>Event Date</th>
			<th style="text-align: left;">Event Name</th>
			<th style="text-align: left;">Event Type</th>
			<th style="text-align: left;">Event Location</th>
			<th style="text-align: center;">Map</th>
			<th style="text-align: center;">Pilots</th>
			<th style="text-align: center;">Status</th>
		</tr>
		{foreach $events as $event}
		<tr style="background:{if $event.time_status==2}lightblue{elseif $event.time_status==1}lightgreen{elseif $event.time_status==0}#C8F7C8{else}white{/if};">
			<td nowrap>{$event.event_start_date|date_format:"%Y-%m-%d"}</td>
			<td>
				<a href="?action=event&function=event_view&event_id={$event.event_id|escape}" class="btn-link">{$event.event_name|escape}</a>
			</td>
			<td nowrap>{$event.event_type_name|escape}</td>
			<td nowrap>{if $event.country_code}<img src="/images/flags/countries-iso/shiny/16/{$event.country_code|escape}.png" style="vertical-align: middle;" title="{$event.country_name}">{/if} 
				{if $event.state_name && $event.country_id==226}<img src="/images/flags/states/16/{$event.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;" title="{$event.state_name}">{/if} 
				{$event.location_name|escape}
			</td>
			<td align="center">{if $event.location_coordinates!=''}<a class="fancybox-map" href="https://maps.google.com/maps?q={$event.location_coordinates|escape:'url'}+({$event.location_name})&t=h&z=14" title="Press the Powered By Google Logo in the lower left hand corner to go to google maps."><img src="/images/icons/world.png"></a>{/if}</td>
			<td align="center">
				{$event.pilot_count}
			</td>
			<td nowrap>
				{if $event.event_reg_flag==1 && $event.time_status!=-1 && $event.time_status!=0}
					{if $event.event_reg_status==0 || 
						($event.pilot_count>=$event.event_reg_max && $event.event_reg_max!=0)
					}
						<font color="red"><b>Registration Closed</b></font>
					{else}
						<font color="green"><b>Registration Open</b></font>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="?action=event&function=event_register&event_id={$event.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if}>
						Register Me Now!
						</a>
					{/if}
				{else}
					{if $event.time_status==2}
					Scheduled
					{elseif $event.time_status==1}
					In Progress
					{else}
					Completed
					{/if}
				{/if}
			</td>
		</tr>
		{/foreach}
		<tr class="table-row-heading-left" style="background-color: lightgray;">
			<th colspan="7" nowrap>
				{include file="paging.tpl"}
			</th>
		</tr>
		</table>
		
		<form name="newevent" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_edit">
		<input type="hidden" name="event_id" value="0">
		</form>


	</div>
</div>
{/block}
