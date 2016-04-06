{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Event Pilot Add (And Create New Pilot)</h2>
	</div>
	<div class="panel-body">
		<br style="clear:left;">

		<form name="main" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_pilot_save">
		<input type="hidden" name="event_id" value="{$event_id}">
		<input type="hidden" name="event_pilot_id" value="0">
		<input type="hidden" name="plane_id" value="{$plane_id}">
		<input type="hidden" name="from_confirm" value="1">
		<br>
		It looks like we may have some matches already in our database for that pilot!<br>
		<br>
		Look down through this list and check the box that could be the pilot you are trying to add.<br>
		<br>
		<table width="100%" cellpadding="2" cellspacing="2" class="table table-condensed table-event">
		<tr>
			<th colspan="6">Possible Pilots</th>
		</tr>
		<tr>
			<th width="5%">&nbsp;</th>
			<th width="20%" nowrap>Pilot First Name</th>
			<th width="20%" nowrap>Pilot Last Name</th>
			<th nowrap>City</th>
			<th nowrap>State</th>
			<th nowrap>Country</th>
		<tr>
		{foreach $pilots as $p}
		<tr>
			<td class="table-data-heading-left" nowrap>
				<input type="radio" name="pilot_id" value="{$p.pilot_id}">
			</td>
			<td>{$p.pilot_first_name|escape}</td>
			<td>{$p.pilot_last_name|escape}</td>
			<td>{$p.pilot_city|escape}</td>
			<td>{$p.state_name|escape}</td>
			<td>{$p.country_name|escape}</td>
		</tr>
		{/foreach}
		<tr>
			<td class="table-data-heading-left" nowrap>
				<input type="radio" name="pilot_id" value="0" CHECKED>
			</td>
			<td colspan="5">Sorry, but none of those pilots are the one I wanted, Please create the one I entered.<br>
				<br>
				{$pilot_first_name|escape} {$pilot_last_name|escape}<br>
				{$pilot_city|escape}, {$state.state_name|escape} - {$country.country_name|escape}
			</td>
		</tr>
		</table>
		<center>
			<input type="submit" value=" Use Selected Pilot " class="btn btn-primary btn-rounded">
		</center>
		
		<input type="hidden" name="pilot_first_name" value="{$pilot_first_name|escape}">
		<input type="hidden" name="pilot_last_name" value="{$pilot_last_name|escape}">
		<input type="hidden" name="pilot_city" value="{$pilot_city|escape}">
		<input type="hidden" name="state_id" value="{$state_id}">
		<input type="hidden" name="country_id" value="{$country_id}">
		<input type="hidden" name="pilot_ama" value="{$pilot_ama|escape}">
		<input type="hidden" name="pilot_fia" value="{$pilot_fia|escape}">
		<input type="hidden" name="pilot_email" value="{$pilot_email|escape}">
		<input type="hidden" name="class_id" value="{$class_id}">
		<input type="hidden" name="event_pilot_freq" value="{$event_pilot_freq|escape}">
		<input type="hidden" name="event_pilot_team" value="{$event_pilot_team|escape}">
		<input type="hidden" name="plane_id" value="{$plane_id}">
		</form>

	</div>
</div>
{/block}