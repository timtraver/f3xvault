{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">
				
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr class="table-row-heading-left">
			<th colspan="8">Admin Event Cleanup Area</th>
		</tr>
		<tr>
			<th width="250">Total Events With Status 0</th>
			<th>{$total_events|escape}</th>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Class Records</th>
			<td>{$total_event_class|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Draw Records</th>
			<td>{$total_event_draw|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Draw Round Records</th>
			<td>{$total_event_draw_round|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Draw Flights Records</th>
			<td>{$total_event_draw_round_flights|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Options Records</th>
			<td>{$total_event_options|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Records</th>
			<td>{$total_event_pilots|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Payment Records</th>
			<td>{$total_event_pilot_payments|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Reg Records</th>
			<td>{$total_event_pilot_reg|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Round Records</th>
			<td>{$total_event_pilot_rounds|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Round Flight Records</th>
			<td>{$total_event_pilot_round_flights|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Round Sub Flight Records</th>
			<td>{$total_event_pilot_round_flight_subs|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Reg Param Records</th>
			<td>{$total_event_reg_params|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Round Records</th>
			<td>{$total_event_rounds|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Round Flight Records</th>
			<td>{$total_event_round_flights|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Series Records</th>
			<td>{$total_event_series|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Task Records</th>
			<td>{$total_event_tasks|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event User Records</th>
			<td>{$total_event_users|escape}</td>
		</tr>
		<tr>
			<th width="250">Total Orphaned Records</th>
			<th>{$total_orphaned_records|escape}</th>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Club Location Records</th>
			<td>{$total_club_location|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Club Pilot Records</th>
			<td>{$total_club_pilot|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Club User Records</th>
			<td>{$total_club_user|escape}</td>
		</tr>

		<tr>
			<th width="250" style="text-align:right;">Event Draw Records</th>
			<td>{$total_event_draw|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Draw Round Records</th>
			<td>{$total_event_draw_round|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Draw Round Flight Records</th>
			<td>{$total_event_draw_round_flight|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Option Records</th>
			<td>{$total_event_option|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Records</th>
			<td>{$total_event_pilot|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Payment Records</th>
			<td>{$total_event_pilot_payment|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Reg Records</th>
			<td>{$total_event_pilot_reg|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Round Records</th>
			<td>{$total_event_pilot_round|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Round Flight Records</th>
			<td>{$total_event_pilot_round_flight|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Pilot Round Flight Sub Records</th>
			<td>{$total_event_pilot_round_flight_sub|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Reg Param Records</th>
			<td>{$total_event_reg_param|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Round Records</th>
			<td>{$total_event_round|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Round Flight Records</th>
			<td>{$total_event_round_flight|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event Task Records</th>
			<td>{$total_event_task|escape}</td>
		</tr>
		<tr>
			<th width="250" style="text-align:right;">Event User Records</th>
			<td>{$total_event_user|escape}</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="button" value=" Fix Records " onclick="document.fix_records.submit();" class="btn btn-primary btn-rounded">
				<input type="button" value=" Go Back " onclick="document.goback.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>
		<br>
	</div>
</div>

 
<form name="goback" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_view">
</form>
<form name="fix_records" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_clean_events">
<input type="hidden" name="clean" value="1">
</form>
{/block}