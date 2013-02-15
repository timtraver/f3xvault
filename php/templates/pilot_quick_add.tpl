<script src="/f3x/includes/jquery.min.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
$(function() {ldelim}
	var teams = [
		{foreach $teams as $t}
		"{$t.event_pilot_team}"{if !$t@last},{/if}
		{/foreach}
	];
{literal}
	$("#event_pilot_team").autocomplete({
		source: teams,
		minLength: 0, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300
	});
});
</script>
{/literal}
<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Pilot Quick Add</h1>
		<div class="entry-content clearfix">

<form method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="save_pilot_quick_add">
<input type="hidden" name="event_id" value="{$event.event_id}">
<table width="50%" cellpadding="2" cellspacing="2" class="tableborder">
<tr>
	<th colspan="3">Pilot Information</th>
</tr>
<tr>
	<th nowrap>Pilot First Name</th>
	<td colspan="2">
		<input type="text" name="pilot_first_name" size="40" value="{$pilot_first_name}">
	</td>
</tr>
<tr>
	<th nowrap>Pilot Last Name</th>
	<td colspan="2">
		<input type="text" name="pilot_last_name" size="40" value="{$pilot_last_name}">
	</td>
</tr>
<tr>
	<th nowrap>Pilot City</th>
	<td colspan="2">
		<input type="text" name="pilot_city" size="40" value="">
	</td>
</tr>
<tr>
	<th nowrap>Pilot State</th>
	<td colspan="2">
		<select name="state_id">
		{foreach $states as $state}
			<option value="{$state.state_id}">{$state.state_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<td nowrap>Pilot Country</td>
	<td colspan="2">
		<select name="country_id">
		{foreach $countries as $country}
			<option value="{$country.country_id}">{$country.country_name}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th nowrap>Pilot AMA #</th>
	<td colspan="2">
		<input type="text" name="pilot_ama" size="15" value="">
	</td>
</tr>
<tr>
	<th nowrap>Pilot FIA #</th>
	<td colspan="2">
		<input type="text" name="pilot_fia" size="15" value="">
	</td>
</tr>
<tr>
	<th nowrap>Email Address</th>
	<td colspan="2">
		<input type="text" name="pilot_email" size="40" value="">
	</td>
</tr>
<tr>
	<th nowrap>Pilot Class</th>
	<td colspan="2">
		<select name="class_id">
		{foreach $classes as $c}
			<option value="{$c.class_id}">{$c.class_description}</option>
		{/foreach}
		</select>
	</td>
</tr>
<tr>
	<th nowrap>Event Team</th>
	<td colspan="2">
		<input type="text" id="event_pilot_team" name="event_pilot_team" size="40" value="">
	</td>
</tr>
<tr>
	<td valign="center" colspan="3">
	<br>
	<input type="button" value=" Cancel " class="button" onClick="goback.submit();">
	<input type="submit" value=" Add New Pilot To This Event " class="button">
	</td>
</tr>
</table>
</form>

<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event.event_id}">
</form>

</div>
</div>
</div>
