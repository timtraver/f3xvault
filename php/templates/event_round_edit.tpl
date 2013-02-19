<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Settings - {$event.event_name}</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event.event_start_date|date_format:"%Y-%m-%d"} to {$event.event_end_date|date_format:"%Y-%m-%d"}
			</td>
		</tr>
		<tr>
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
		</tr>
		</table>
		
	</div>
		<br>
		<h1 class="post-title entry-title">Event Round Edit</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" nowrap>Event Round Number</th>
			<td>
				{$round_number}
			</td>
		</tr>
		<tr>
			<th>Event Round Type</th>
			<td>
				{$event.round_type_name}
			</td>
		</tr>
		</table>
		
		<h1 class="post-title entry-title">Round Flights</h1>
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="left"></th>
			<th align="left">Pilot Name</th>
			<th align="left">Raw Score</th>
			<th align="left">Normalized Score</th>
			<th align="left">Round Position</th>
			<th align="left" width="4%"></th>
		</tr>
		{assign var=num value=1}
		{foreach $event.pilots as $p}
		<tr>
			<td>{$num}</td>
			<td>{$p.pilot_first_name} {$p.pilot_last_name}</td>
			<td><input type="text" size="5" name="pilot_raw_{$p.event_pilot_id}" value=""></td>
			<td></td>
			<td></td>
			<td></td>
			<td nowrap>
			</td>
		</tr>
		{assign var=num value=$num+1}
		{/foreach}
		</table>
		
<br>
<input type="button" value=" Back To Event " onClick="goback.submit();" class="block-button" style="float: none;margin-left: auto;margin-right: auto;">
</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event.event_id}">
</form>
