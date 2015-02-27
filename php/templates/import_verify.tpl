<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">F3X Event Import Step 1</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Import File for Event</h1>
<br>
<form name="main" method="POST">
<input type="hidden" name="action" value="import">
<input type="hidden" name="function" value="import_import">
<input type="hidden" name="event_id" value="{$event.event_id}">
<input type="hidden" name="event_type_id" value="{$event.event_type_id}">
<input type="hidden" name="event_zero_round" value="{$event.event_zero_round}">
<input type="hidden" name="event_name" value="{$event.event_name}">
<input type="hidden" name="event_start_date" value="{$event.event_start_date}">
<input type="hidden" name="event_end_date" value="{$event.event_end_date}">
{foreach $rounds as $r}
{$round=$r@key}
<input type="hidden" name="event_round_{$round}" value="{$r.flight_type_id}">
{/foreach}

Imported information from file

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th colspan="2">Event Type</th>
	<td colspan="4">
		{$event.event_type_code} - {$event.event_type_name}
		
	</td>
</tr>
<tr>
	<th colspan="2">Event Name</th>
	<td colspan="4">
		{$event.event_name}
	</td>
</tr>
<tr>
	<th colspan="2">Event Dates</th>
	<td colspan="4">
		{$event.event_start_date} TO {$event.event_end_date}
	</td>
</tr>
<tr>
	<th colspan="3">Data Import</th>
	<th colspan="3">Example Import Round 1</th>
</tr>
<tr>
	<th></th>
	<th>Pilot Name</th>
	<th>Pilot Lookup</th>
	<th>Grp</th>
	<th>Flight</th>
	<th>Pen</th>
</tr>
{$line_number=1}
{foreach $pilots as $p}
<tr>
	<th>{$line_number}</th>
	<td>
		{$p.pilot_name}
		<input type="hidden" name="pilot_name_{$line_number}" value="{$p.pilot_name}">
		<input type="hidden" name="pilot_class_{$line_number}" value="{$p.pilot_class}">
		<input type="hidden" name="pilot_freq_{$line_number}" value="{$p.pilot_freq}">
		<input type="hidden" name="pilot_team_{$line_number}" value="{$p.pilot_team}">
		{foreach $p.rounds as $r}
			{$round=$r@key}
			<input type="hidden" name="pilot_{$line_number}_round_{$round}_group" value="{$r.group}">
			{foreach $r.flights.sub as $s}
				{$subnum=$s@key}
				<input type="hidden" name="pilot_{$line_number}_round_{$round}_sub_{$subnum}" value="{$s}">
			{/foreach}
			<input type="hidden" name="pilot_{$line_number}_round_{$round}_pen" value="{$r.penalty}">
		{/foreach}
	</td>
	<td>
		{if $p.found==1}<img src="/images/icons/accept.png">{else}<img src="/images/icons/exclamation.png">{/if}
		<select name="pilot_id_{$line_number}">
		{foreach $p.potentials as $pt}
			<option value="{$pt.pilot_id}" {if $pt.pilot_full_name==$p.pilot_name}SELECTED{/if}>{$pt.pilot_full_name}{if $pt.pilot_id!=0} - {$pt.pilot_city},{$pt.state_code} {$pt.country_code}{/if}</option>
		{/foreach}
		</select>
	</td>
	<td align="center">{$p.rounds.1.group}</td>
	<td align="center">
		{if $p.rounds.1.flights.sub}
			{foreach $p.rounds.1.flights.sub as $s}
				{$s}{if !$s@last},{/if}
			{/foreach}
		{else}
			{$p.rounds.1.flights.1}
		{/if}
	</td>
	<td align="center">{$p.rounds.1.penalty}</td>
</tr>
{$line_number=$line_number+1}
{/foreach}
<tr>
	<th colspan="6">
	<input type="button" value=" Cancel Import " class="block-button" onClick="goback.submit();">
	<input type="submit" value=" Import This Data " class="block-button">
	</th>
</tr>
</table>
</form>


<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_edit">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>



</div>
</div>
</div>

