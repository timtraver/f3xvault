{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

{include file="event/event_view_top_info.tpl"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Event Pilot Update Pilot Info</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event Pilot Edit " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">

		<form name="main" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_pilot_save_pilot">
		<input type="hidden" name="event_id" value="{$event_id}">
		<input type="hidden" name="event_pilot_id" value="{$pilot.event_pilot_id}">
		<input type="hidden" name="pilot_id" value="{$pilot.pilot_id}">
		<input type="hidden" name="event_pilot_edit" value="1">
		<table width="100%" cellpadding="2" cellspacing="2" class="table table-condensed">
		<tr>
			<th colspan="3">Pilot Information</th>
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
					<option value="{$state.state_id}" {if $pilot.state_id==$state.state_id}SELECTED{/if}>{$state.state_name}</option>
				{/foreach}
				</select>
			</td>
		</tr>
		<tr>
			<th align="right" nowrap>Pilot Country</th>
			<td colspan="2">
				<select name="country_id">
				{foreach $countries as $country}
					<option value="{$country.country_id}" {if $pilot.country_id==$country.country_id}SELECTED{/if}>{$country.country_name}</option>
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
			<th align="right" nowrap>Pilot FAI #</th>
			<td colspan="2">
				<input type="text" name="pilot_fai" size="15" value="{$pilot.pilot_fai|escape}">
			</td>
		</tr>
		<tr>
			<td align="center" colspan="3">
			<input type="submit" value=" Back To Event Pilot Edit "  onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
			<input type="submit" value=" Save Pilot Info " class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>
		</form>
	
		<form name="goback" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_pilot_edit">
		<input type="hidden" name="event_id" value="{$event_id}">
		<input type="hidden" name="event_pilot_id" value="{$event_pilot_id}">
		<input type="hidden" name="event_pilot_edit" value="1">
		</form>

	</div>
</div>
{/block}
