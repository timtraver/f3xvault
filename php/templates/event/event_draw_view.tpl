<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Draws for {$event->info.event_name|escape}
				<input type="button" value=" Back To Event View " onClick="goback.submit();" class="block-button">
		</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Event Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}
			</td>
			<th align="right">Location</th>
			<td>
			<a href="?action=location&function=location_view&location_id={$event->info.location_id}">{$event->info.location_name|escape} - {$event->info.location_city|escape},{$event->info.state_code|escape} {$event->info.country_code|escape}</a>
			</td>
		</tr>
		<tr>
			<th align="right">Event Type</th>
			<td>
			{$event->info.event_type_name|escape}
			</td>
			<th align="right">Event Contest Director</th>
			<td>
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape} - {$event->info.pilot_city|escape}
			</td>
		</tr>
		{if $event->series || $event->info.club_name}
		<tr>
			<th valign="top" align="right">Part Of Series</th>
			<td valign="top">
				{foreach $event->series as $s}
				<a href="?action=series&function=series_view&series_id={$s.series_id}">{$s.series_name|escape}</a>{if !$s@last}<br>{/if}
				{/foreach}
			</td>
			<th valign="top" align="right">Club</th>
			<td valign="top">
			<a href="?action=club&function=club_view&club_id={$event->info.club_id}">{$event->info.club_name|escape}</a>
			</td>
		</tr>
		{/if}
		</table>
		
	</div>
<br>
<h1 class="post-title entry-title">Draws</h1>

<form name="main" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw_edit">
<input type="hidden" name="event_draw_id" value="0">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="flight_type_id" value="0">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th width="10%" nowrap>Flight Type</th>
	<th width="5%" nowrap>Status</th>
	<th width="10%" nowrap>Draw Type</th>
	<th width="10%" nowrap>Round From</th>
	<th width="10%" nowrap>Round To</th>
	<th width="20%"  nowrap>View</th>
</tr>
{$f3k_first=0}
{foreach $event->flight_types as $ft}
	{if $f3k_first!=0}
		{continue}
	{/if}
	{$total=0}
	{foreach $event->draws as $d}
		{if $d.flight_type_id==$ft.flight_type_id}
			{$total=$total+1}
		{/if}
	{/foreach}
	{if $total==0}
		<tr>
			<th width="20%" nowrap>
				{if $event->info.event_type_code=='f3k'}
					F3K
				{else}
					{$ft.flight_type_name}
				{/if}
			</th>
			<td colspan="6">No draws created</td>
		</tr>
	{else}	
		{foreach $event->draws as $d}
			{if $d.flight_type_id!=$ft.flight_type_id || $d.event_draw_active==0}
				{continue}
			{/if}
			<tr>
			<th nowrap>
				{if $event->info.event_type_code=='f3k'}
					F3K
				{else}
					{$ft.flight_type_name}
				{/if}
			</th>
			{if $d.event_draw_active}
				<td align="center" bgcolor="#9DCFF0">
					Active
				</td>
			{else}
				<td align="center">
					Not Applied
				</td>
			{/if}
			<td align="center">{if $d.event_draw_type=="random"}Random{elseif $d.event_draw_type=='random_step'}Random With Step{elseif $d.event_draw_type=='group'}Group{/if}</td>
			<td align="center">{$d.event_draw_round_from}</td>
			<td align="center">{$d.event_draw_round_to}</td>
			<td align="center" nowrap>
				{if $ft.flight_type_code!="f3b_speed" && $ft.flight_type_code!="f3b_speed_only" && $ft.flight_type_code!="f3f_speed"}
				<input type="button" value="View Draw Stats" class="button" style="float:left;" onClick="location.href='?action=event&function=event_draw_stats&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}&flight_type_id={$d.flight_type_id}&from_event_view=1';">
				{/if}
				<input type="button" value="View Draw" class="button" style="float:left;" onClick="window.open('?action=event&function=event_draw_view&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}&flight_type_id={$d.flight_type_id}&use_print_header=1','_blank');">
			</td>
			</tr>
		{/foreach}
	{/if}
	{if $event->info.event_type_code=='f3k'}
		{$f3k_first=1}
	{/if}
{/foreach}
</table>
</form>

<br>
<h1 class="post-title entry-title">Printing Active Draws</h1>
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
{$f3k_first=0}
{if $event->draws}
	{foreach $event->flight_types as $ft}
		{if $f3k_first!=0}
			{continue}
		{/if}
		{$flight_type_id=$ft.flight_type_id}
		<form name="print_{$ft.flight_type_id}" method="POST" target="_blank">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_draw_print">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="flight_type_id" value="{$ft.flight_type_id}">
		<input type="hidden" name="print_type" value="">
		<input type="hidden" name="use_print_header" value="1">

		<tr>
			<th width="10%" nowrap>{if $event->info.event_type_code=='f3k'}F3K{else}{$ft.flight_type_name}{/if}</th>
			<td style="padding-top:10px;">
				Rounds
				<select name="print_round_from">
				{for $i=$print_rounds.$flight_type_id.min to $print_rounds.$flight_type_id.max}
				<option value="{$i}">{$i}</option>
				{/for}
				</select>
				To
				<select name="print_round_to">
				{for $i=$print_rounds.$flight_type_id.min to $print_rounds.$flight_type_id.max}
				<option value="{$i}" SELECTED>{$i}</option>
				{/for}
				</select>
				<select name="print_format">
				<option value="html">HTML</option>
				<option value="pdf">PDF</option>
				</select>
				<input type="button" value=" CD Recording Sheet " onClick="document.print_{$ft.flight_type_id}.print_type.value='cd';submit();" class="block-button">
				{if !$ft.flight_type_code|strstr:"speed" && !$ft.flight_type_code|strstr:"distance"}
				<input type="button" value=" Pilot Recording Sheets " onClick="document.print_{$ft.flight_type_id}.print_type.value='pilot';submit();" class="block-button">
				{/if}
				<input type="button" value=" Draw Table " onClick="document.print_{$ft.flight_type_id}.print_type.value='table';submit();" class="block-button">
				<input type="button" value=" Full Draw Matrix " onClick="document.print_{$ft.flight_type_id}.print_type.value='matrix';submit();" class="block-button">
			</td>
		</tr>
		</form>
		{if $event->info.event_type_code=='f3k'}
			{$f3k_first=1}
		{/if}
	{/foreach}
	{if $event->info.event_type_code=='f3b'}
		<form name="print_f3b_combined" method="POST" target="_blank">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_draw_print">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="flight_type_id" value="{$ft.flight_type_id}">
		<input type="hidden" name="print_type" value="">
		<input type="hidden" name="use_print_header" value="1">
		<tr>
			<th width="10%" nowrap>F3B Combined</th>
			<td style="padding-top:10px;">
				Rounds
				<select name="print_round_from">
				{for $i=$print_rounds.$flight_type_id.min to $print_rounds.$flight_type_id.max}
				<option value="{$i}">{$i}</option>
				{/for}
				</select>
				To
				<select name="print_round_to">
				{for $i=$print_rounds.$flight_type_id.min to $print_rounds.$flight_type_id.max}
				<option value="{$i}" SELECTED>{$i}</option>
				{/for}
				</select>
				<select name="print_format">
				<option value="html">HTML</option>
				<option value="pdf">PDF</option>
				</select>
				<input type="button" value=" Draw Table " onClick="document.print_f3b_combined.print_type.value='f3b_table';submit();" class="block-button">
			</td>
		</tr>
	{/if}
{else} {* if no draws are active *}
	<tr>
		<th colspan="2" nowrap>There are no current active draws.</th>
	</tr>
{/if}
</table>
</form>
<br>
<br>
{if $user.user_id!=0 && ($permission==1 || $user.user_admin==1)}
	<input type="button" value=" Manage These Draws " onClick="document.event_draw.submit();" class="block-button">
{/if}


<form name="goback" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<input type="hidden" name="tab" value="">
</form>
<form name="event_draw" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_draw">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>

</div>
</div>
</div>

