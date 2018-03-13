{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:600px;">
	<div class="panel-heading">
		<h2 class="heading">Event CD Quick Add Into Pilots DB</h2>
	</div>
	<div class="panel-body">

		<form name="main" method="POST">
		<input type="hidden" name="action" value="pilot">
		<input type="hidden" name="function" value="pilot_save_cd">
		<table width="100%" cellpadding="2" cellspacing="2" class="table table-condensed table-event">
		<tr>
			<th colspan="3">CD Information</th>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot First Name</th>
			<td colspan="2">
				<input type="text" name="pilot_first_name" size="40" value="{$pilot.pilot_first_name|escape}">
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot Last Name</th>
			<td colspan="2">
				<input type="text" name="pilot_last_name" size="40" value="{$pilot.pilot_last_name|escape}">
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot City</th>
			<td colspan="2">
				<input type="text" name="pilot_city" size="40" value="{$pilot.pilot_city|escape}">
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot State</th>
			<td colspan="2">
				<select name="state_id">
				{foreach $states as $state}
					<option value="{$state.state_id}">{$state.state_name}</option>
				{/foreach}
				</select>
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot Country</th>
			<td colspan="2">
				<select name="country_id">
				{foreach $countries as $country}
					<option value="{$country.country_id}">{$country.country_name}</option>
				{/foreach}
				</select>
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot Email</th>
			<td colspan="2">
				<input type="text" name="pilot_email" size="40" value="{$pilot.pilot_email|escape}">
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot AMA #</th>
			<td colspan="2">
				<input type="text" name="pilot_ama" size="15" value="{$pilot.pilot_ama|escape}">
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot FAI Designation</th>
			<td colspan="2">
				<input type="text" name="pilot_fai" size="15" value="{$pilot.pilot_fai|escape}">
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot FAI License</th>
			<td colspan="2">
				<input type="text" name="pilot_fai_license" size="15" value="{$pilot.pilot_fai_license|escape}">
			</td>
		</tr>
		</table>
		<center>
			<input type="button" value=" Cancel " class="btn btn-primary btn-rounded" onClick="goback.submit();">
			<input type="submit" value=" Save CD Info And Return To Event Edit " class="btn btn-primary btn-rounded">
		</center>
		<br>
		<br>
		{foreach $from as $f}
		<input type="hidden" name="{$f.key}" value="{$f.value}">
		{if $f.key == 'from_event_id'}
			{$event_id = $f.value}
		{/if}
		{/foreach}
		</form>
		
		<form name="goback" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_edit">
		<input type="hidden" name="event_id" value="{$event_id}">
		</form>

	</div>
</div>
{/block}