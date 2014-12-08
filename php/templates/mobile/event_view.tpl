<script>
{literal}
function toggle(element,tog) {
	 if (document.getElementById(element).style.display == 'none') {
	 	document.getElementById(element).style.display = 'block';
	 	tog.innerHTML = '(<u>Hide</u>)';
	 } else {
		 document.getElementById(element).style.display = 'none';
		 tog.innerHTML = '(<u>Show</u>)';
	 }
}
{/literal}
function check_permission() {ldelim}
	{if $permission!=1}
		alert('Sorry, but you do not have permission to edit this event. Contact the event owner if you need access to edit this event.');
		return 0;
	{else}
		return 1;
	{/if}
{rdelim}
</script>

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">{$event->info.event_name|escape}</h1>
		<div class="entry-content clearfix">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="20%" align="right">Dates</th>
			<td>
			{$event->info.event_start_date|date_format:"%Y-%m-%d"}{if $event->info.event_end_date!=$event->info.event_start_date} to {$event->info.event_end_date|date_format:"%Y-%m-%d"}{/if}
			</td>
		</tr>
		<tr>
			<th align="right">Location</th>
			<td>
			<a href="?action=location&function=location_view&location_id={$event->info.location_id}">{$event->info.location_name|escape} - {$event->info.state_code|escape} {$event->info.country_code|escape}</a>
			</td>
		</tr>
		<tr>
			<th align="right">Type</th>
			<td>
			{$event->info.event_type_name|escape}
			</td>
		</tr>
		<tr>
			<th align="right">CD</th>
			<td>
			{$event->info.pilot_first_name|escape} {$event->info.pilot_last_name|escape}
			</td>
		</tr>
		{if $event->info.series_name || $event->info.club_name}
		<tr>
			<th align="right">Series</th>
			<td>
			<a href="?action=series&function=series_view&series_id={$event->info.series_id}">{$event->info.series_name|escape}</a>
			</td>
		</tr>
		<tr>
			<th align="right">Club</th>
			<td>
			<a href="?action=club&function=club_view&club_id={$event->info.club_id}">{$event->info.club_name|escape}</a>
			</td>
		</tr>
		{/if}
		{if $event->info.event_reg_flag==1}
		<tr>
			<th align="right">Registration Status</th>
			<td>
				{if $event->info.event_reg_status==0 || 
					($event->pilots|count>=$event->info.event_reg_max && $event->info.event_reg_max!=0) ||
					$event_reg_passed==1
				}
					<font color="red"><b>Registration Currently Closed</b></font>
				{else}
					<font color="green"><b>Registration Currently Open</b></font>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="?action=event&function=event_register&event_id={$event->info.event_id}"{if $user.user_id==0} onClick="alert('You must be logged in to Register for this event. Please create an account or log in to your existing account to proceed.');return false;"{/if}>
					{if $registered==1}
					You Are Registered! Update Your Registration Info
					{else}
					Register Me Now!
					{/if}
					</a>
				{/if}
			</td>
		{/if}
		</table>
		
		{if $user.user_id!=0 && ($permission==1 || $user.user_admin==1)}
		<input type="button" value=" Event Settings " onClick="if(check_permission()){ldelim}document.event_edit.submit();{rdelim}" class="block-button">
		{/if}
		{if $active_draws}
		<input type="button" value=" View Draws " onClick="document.event_view_draws.submit();" class="block-button">
		{/if}
		<input type="button" value=" View Full Event Info " onClick="document.event_view_info.submit();" class="block-button">
	</div>

	{if !$event->totals}
		<br>
		<h1 class="post-title entry-title">Event Pilots {if $event->pilots}({$event->pilots|count}){/if} <span id="viewtoggle" onClick="toggle('pilots',this);">(<u>Hide</u>)</span>
		</h1>
		<span id="pilots">
		<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="center">AMA#</th>
			<th align="left">Pilot Name</th>
			<th align="left">Pilot Class</th>
			<th align="left">Pilot Plane</th>
			<th align="left">Team</th>
		</tr>
		{assign var=num value=1}
		{foreach $event->pilots as $p}
		<tr>
			<td>{$num}</td>
			<td align="center">{$p.pilot_ama|escape}</td>
			<td><a href="/?action=event&function=event_pilot_edit&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Edit Event Pilot">{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</a></td>
			<td>{$p.class_description|escape}</td>
			<td>{$p.plane_name|escape}</td>
			<td>{$p.event_pilot_team|escape}</td>
		</tr>
		{assign var=num value=$num+1}
		{/foreach}
		</table>
		</span>
	{/if}

	{if $event->flyoff_totals}
		<!--# Lets do the flyoff Leader Board -->
		{foreach $event->flyoff_totals as $t}
			{$flyoff_number=$t@key}

			<h1 class="post-title entry-title">Flyoff #{$flyoff_number} Leader Board</h1>
			<h4>After {$t.total_rounds} Rounds ({if $t.round_drops==0}No{else}{$t.round_drops}{/if} Drop{if $t.round_drops!=1}s{/if} In Effect)</h4>
	
			<table width="100%" cellpadding="2" cellspacing="2">
			<tr>
				<th width="2%" align="left"></th>
				<th width="10%" align="left" nowrap>Pilot Name</th>
				<th width="5%" nowrap>Sub</th>
				<th width="5%" nowrap>Drop</th>
				<th width="5%" nowrap>Pen</th>
				<th width="5%" nowrap>Total</th>
				<th width="5%" nowrap>Diff</th>
			</tr>
			{$previous=0}
			{$diff_to_lead=0}
			{$diff=0}
			{foreach $t.pilots as $e}
			{if $e.total>$previous}
				{$previous=$e.total}
			{else}
				{$diff=$previous-$e.total}
				{$diff_to_lead=$diff_to_lead+$diff}
			{/if}
			{$event_pilot_id=$e.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$e.overall_rank|escape}</td>
				<td align="left" nowrap style="text-align:left;"><a href="?action=event&function=event_pilot_rounds&event_pilot_id={$e.event_pilot_id}&event_id={$event->info.event_id}">{$e.pilot_first_name|escape} {$e.pilot_last_name|escape}</a></td>
				<td class="info" width="5%" nowrap align="right">{$e.subtotal|string_format:"%03.0f"}</td>
				<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:"%03.0f"}{/if}</td>
				<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties|escape}{/if}</td>
				<td width="5%" nowrap align="right">{$e.total|string_format:"%03.0f"}</td>
				<td width="5%" nowrap align="right"><font color="red">-{if $diff!=0}{$diff|string_format:"%3.0f"}{/if}</font></td>
			</tr>
			{$previous=$e.total}
			{/foreach}
			</table>
		{/foreach}
	{/if}

	{if $event->flyoff_totals}
		<!--# Now lets do the flyoff rounds -->
		{foreach $event->flyoff_totals as $t}
			{$flyoff_number=$t@key}
		<h1 class="post-title entry-title">Flyoff #{$flyoff_number} Rounds ({$t.total_rounds})
		</h1>
		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{$t.total_rounds + 1}" align="center" nowrap>
				Completed Rounds ({if $t.round_drops==0}No{else}{$t.round_drops}{/if} Drop{if $t.round_drops!=1}s{/if} In Effect)
			</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=$flyoff_number}
					{continue}
				{/if}
				<th class="info" width="5%" align="center" nowrap>
					<a href="/?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$r.event_round_id}&view_only=1" title="View Round">{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}<del><font color="red">{/if}R {$r.event_round_number|escape}{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}</del></font>{/if}</a>
				</th>
			{/foreach}
			<th>&nbsp;</th>
		</tr>
		{foreach $t.pilots as $e}
		{$event_pilot_id=$e.event_pilot_id}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank}</td>
			<td align="right" nowrap style="text-align:left;"><a href="?action=event&function=event_pilot_rounds&event_pilot_id={$e.event_pilot_id}&event_id={$event->info.event_id}">{$e.pilot_first_name|escape} {$e.pilot_last_name|escape}</a></td>
			{foreach $e.rounds as $r}
				{if $r@iteration <=9}
				<td class="info" align="center"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
					<div style="position:relative;">
					{$dropval=0}
					{$dropped=0}
					{foreach $r.flights as $f}
						{if $f.event_pilot_round_flight_dropped}
							{$dropval=$dropval+$f.event_pilot_round_total_score}
							{$dropped=1}
						{/if}
					{/foreach}
					{$drop=0}
					{if $dropped==1 && $dropval==$r.event_pilot_round_total_score}{$drop=1}{/if}
					{if $drop==1}<del><font color="red">{/if}
						{if $r.event_pilot_round_total_score==1000}
							1000
						{else}
							{$r.event_pilot_round_total_score|string_format:"%03.0f"}
						{/if}
					{if $drop==1}</font></del>{/if}
					{* lets determine the content to show on popup *}
						<span>
							{$event_round_number=$r@key}
							{foreach $event->rounds.$event_round_number.flights as $f}
								{if $f.flight_type_code|strstr:'duration' || $f.flight_type_code|strstr:'f3k'}
									{if $f.flight_type_code=='f3b_duration'}A - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_minutes|escape}:{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}{if $f.flight_type_landing} - {$f.pilots.$event_pilot_id.event_pilot_round_flight_landing|escape}{/if}<br>
								{/if}
								{if $f.flight_type_code|strstr:'distance'}
									{if $f.flight_type_code=='f3b_distance'}B - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_laps|escape} Laps<br>
								{/if}
								{if $f.flight_type_code|strstr:'speed'}
									{if $f.flight_type_code=='f3b_speed'}C - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}s
								{/if}
							{/foreach}
						</span>
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
		</tr>
		{/foreach}
		{if $event->info.event_type_code=='f3f'}
		<tr>
			<th colspan="2" align="right">Round Fast Time</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=$flyoff_number}
					{continue}
				{/if}
				{$fast=1000}
				{$fast_id=0}
				{foreach $r.flights as $f}
					{foreach $f.pilots as $p}
						{if $p.event_pilot_round_flight_seconds<$fast && $p.event_pilot_round_flight_seconds!=0}
							{$fast=$p.event_pilot_round_flight_seconds}
							{$fast_id=$p.event_pilot_id}
						{/if}
					{/foreach}
				{/foreach}
				{if $fast==1000}{$fast=0}{/if}
				<th class="info" align="center">
					<div style="position:relative;">
					{$fast}s
					<span>
						Fast Time : {$fast}s<br>
						{$event->pilots.$fast_id.pilot_first_name|escape} {$event->pilots.$fast_id.pilot_last_name|escape}
					</span>
					</div>
				</th>
			{/foreach}
		</tr>
		{/if}
		</table>
		{if !$t@last}
		<br style="page-break-after: always;">
		{/if}
		{/foreach}
		<!--# End of flyoff rounds -->
	{/if}


	{if $event->totals}
		<h1 class="post-title entry-title">{if $event->info.event_type_flyoff==1}Preliminary {/if}Leader Board</h1>
		<h4>After {$event->totals.total_rounds} Rounds ({if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drop{if $event->totals.round_drops!=1}s{/if} In Effect)</h4>

		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="left" nowrap>Pilot Name</th>
			<th width="5%" nowrap>Sub</th>
			<th width="5%" nowrap>Drop</th>
			<th width="5%" nowrap>Pen</th>
			<th width="5%" nowrap>Total</th>
			<th width="5%" nowrap>Diff</th>
		</tr>
		{$previous=0}
		{$diff_to_lead=0}
		{$diff=0}
		{foreach $event->totals.pilots as $e}
		{if $e.total>$previous}
			{$previous=$e.total}
		{else}
			{$diff=$previous-$e.total}
			{$diff_to_lead=$diff_to_lead+$diff}
		{/if}
		{$event_pilot_id=$e.event_pilot_id}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank|escape}</td>
			<td align="left" nowrap style="text-align:left;"><a href="?action=event&function=event_pilot_rounds&event_pilot_id={$e.event_pilot_id}&event_id={$event->info.event_id}">{$e.pilot_first_name|escape} {$e.pilot_last_name|escape}</a></td>
			<td class="info" width="5%" nowrap align="right">{$e.subtotal|string_format:"%03.0f"}</td>
			<td width="5%" align="right" nowrap>{if $e.drop!=0}{$e.drop|string_format:"%03.0f"}{/if}</td>
			<td width="5%" align="center" nowrap>{if $e.penalties!=0}{$e.penalties|escape}{/if}</td>
			<td width="5%" nowrap align="right">{$e.total|string_format:"%03.0f"}</td>
			<td width="5%" nowrap align="right"><font color="red">-{if $diff!=0}{$diff|string_format:"%3.0f"}{/if}</font></td>
		</tr>
		{$previous=$e.total}
		{/foreach}
		</table>
	{/if}


		{$perpage=4}
		{* Lets figure out how many flyoff and zero  rounds there are *}
		{$flyoff_rounds=0}
		{$zero_rounds=0}
		{foreach $event->rounds as $r}
			{if $r.event_round_flyoff!=0}
				{$flyoff_rounds=$flyoff_rounds+1}
			{/if}
			{if $r.event_round_number==0}
				{$zero_rounds=$zero_rounds+1}
			{/if}
		{/foreach}
		{$prelim_rounds=$event->rounds|count - $flyoff_rounds}
		{$pages=ceil($prelim_rounds / $perpage)}
		{if $pages==0}{$pages=1}{/if}
		{if $zero_rounds>0}
			{$start_round=0}
			{$end_round=$perpage - $zero_rounds}
			{if $end_round>=$prelim_rounds}
				{$end_round=$prelim_rounds - $zero_rounds}
			{/if}
			{$numrounds=$end_round-$start_round + $zero_rounds}
		{else}
			{$start_round=1}
			{$end_round=$perpage}
			{if $end_round>=$prelim_rounds}
				{$end_round=$prelim_rounds - $zero_rounds}
			{/if}
			{$numrounds=$end_round-$start_round + 1}
		{/if}
		
		{for $page_num=1 to $pages}
		{if $page_num>1}
			{$numrounds=$end_round-$start_round + 1}
		{/if}
		<h1 class="post-title entry-title">{if $event->info.event_type_flyoff==1}Preliminary {/if}Rounds {if $event->rounds}({$start_round}-{$end_round}) {/if}</h1>
		<table width="100%" cellpadding="2" cellspacing="2">
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap></th>
			<th colspan="{$numrounds+1}" align="center" nowrap>
				Rounds ({if $event->totals.round_drops==0}No{else}{$event->totals.round_drops}{/if} Drop{if $event->totals.round_drops!=1}s{/if} In Effect)
			</th>
		</tr>
		<tr>
			<th width="2%" align="left"></th>
			<th width="10%" align="right" nowrap>Pilot Name</th>
			{foreach $event->rounds as $r}
				{if $r.event_round_flyoff!=0}
					{continue}
				{/if}
				{$round_number=$r.event_round_number}
				{if $round_number >= $start_round && $round_number <= $end_round}
				<th class="info" width="5%" align="center" nowrap>
					<div style="position:relative;">
					<a href="/?action=event&function=event_round_edit&event_id={$event->info.event_id}&event_round_id={$r.event_round_id}&view_only=1" title="Edit Round">{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}<del><font color="red">{/if}R {$r.event_round_number|escape}{if $r.event_round_score_status==0 || ($event->info.event_type_code != 'f3b' && $r.flights.$flight_type_id.event_round_flight_score ==0 && $flight_type_id!=0)}</del></font>{/if}</a>
					</div>
				</th>
				{/if}
			{/foreach}
			<th>&nbsp;</th>
		</tr>
		{$previous=0}
		{$diff_to_lead=0}
		{$diff=0}
		{foreach $event->totals.pilots as $e}
		{if $e.total>$previous}
			{$previous=$e.total}
		{else}
			{$diff=$previous-$e.total}
			{$diff_to_lead=$diff_to_lead+$diff}
		{/if}
		{$event_pilot_id=$e.event_pilot_id}
		<tr style="background-color: {cycle values="#9DCFF0,white"};">
			<td>{$e.overall_rank|escape}</td>
			<td align="right" nowrap style="text-align:left;"><a href="?action=event&function=event_pilot_rounds&event_pilot_id={$e.event_pilot_id}&event_id={$event->info.event_id}">{$e.pilot_first_name|escape} {$e.pilot_last_name|escape}</a></td>
			{foreach $e.rounds as $r}
				{$round_number=$r@key}
				{if $round_number >= $start_round && $round_number <= $end_round}
				<td class="info" align="center"{if $r.event_pilot_round_rank==1 || ($event->info.event_type_code!='f3b' && $r.event_pilot_round_total_score==1000)} style="border-width: 2px;border-color: green;color:green;font-weight:bold;"{/if}>
					<div style="position:relative;">
					{$dropval=0}
					{$dropped=0}
					{foreach $r.flights as $f}
						{if $f.event_pilot_round_flight_dropped}
							{$dropval=$dropval+$f.event_pilot_round_total_score}
							{$dropped=1}
						{/if}
					{/foreach}
					{$drop=0}
					{if $dropped==1 && $dropval==$r.event_pilot_round_total_score}{$drop=1}{/if}
					{if $drop==1}<del><font color="red">{/if}
						{if $r.event_pilot_round_total_score==1000}
							1000
						{else}
							{if $r.event_pilot_round_flight_dns==1}
								<font color="red">DNS</font>
							{elseif $r.event_pilot_round_flight_dnf==1}
								<font color="red">DNF</font>
							{else}
								{$r.event_pilot_round_total_score|string_format:"%03.0f"}
							{/if}
						{/if}
					{if $drop==1}</font></del>{/if}
					{* lets determine the content to show on popup *}
						<span>
							{$event_round_number=$r@key}
							{foreach $event->rounds.$event_round_number.flights as $f}
								{if $f.flight_type_code|strstr:'duration' || $f.flight_type_code|strstr:'f3k'}
									{if $f.flight_type_code=='f3b_duration'}A - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_minutes|escape}:{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}{if $f.flight_type_landing} - {$f.pilots.$event_pilot_id.event_pilot_round_flight_landing|escape}{/if}<br>
								{/if}
								{if $f.flight_type_code|strstr:'distance'}
									{if $f.flight_type_code=='f3b_distance'}B - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_laps|escape} Laps<br>
								{/if}
								{if $f.flight_type_code|strstr:'speed'}
									{if $f.flight_type_code=='f3b_speed'}C - {/if}
									{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds|escape}s
								{/if}
							{/foreach}
						</span>
					</div>
				</td>
				{/if}
			{/foreach}
			<td></td>
		</tr>
		{$previous=$e.total}
		{/foreach}
		{if $event->info.event_type_code=='f3f'}
		<tr>
			<th colspan="2" align="right">Round Fast Time</th>
			{foreach $event->rounds as $r}
				{$round_number=$r.event_round_number}
				{if $round_number >= $start_round && $round_number <= $end_round}
					{$fast=1000}
					{$fast_id=0}
					{foreach $r.flights as $f}
						{foreach $f.pilots as $p}
						{if $p.event_pilot_round_flight_seconds<$fast && $p.event_pilot_round_flight_seconds!=0}
							{$fast=$p.event_pilot_round_flight_seconds}
							{$fast_id=$p.event_pilot_id}
						{/if}
						{/foreach}
					{/foreach}
					{if $fast==1000}{$fast=0}{/if}
					<th class="info" align="center">
						<div style="position:relative;">
						{$fast|escape}s
						<span>
							Fast Time : {$fast}s<br>
							{$event->pilots.$fast_id.pilot_first_name|escape} {$event->pilots.$fast_id.pilot_last_name|escape}
						</span>
						</div>
					</th>
				{/if}
			{/foreach}
		</tr>
		{/if}
		</table>
		{$start_round=$end_round+1}
		{$end_round=$start_round+$perpage - 1}
		{if $end_round>$prelim_rounds}
			{$end_round=$prelim_rounds - $zero_rounds}
		{/if}
		{if $page_num!=$pages || $flyoff_rounds!=0}
		<br style="page-break-after: always;">
		{/if}
		{/for}







<br>
	</div>
</div>

{if $event->classes|count > 1 || $event->totals.teams || $duration_rank || $speed_rank}
<h1 class="post-title">Contest Ranking Reports</h1>
<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;">
	{if $event->classes|count > 1}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h1 class="post-title">Class Rankings</h1>
		<table cellpadding="2" cellspacing="1" class="tableborder">
			{foreach $event->classes as $c}
			{$rank=1}
					<tr>
						<th colspan="3" nowrap>{$c.class_description|escape} Rankings</th>
					</tr>
					<tr>
						<th></th>
						<th>Pilot</th>
						<th>Total</th>
					</tr>
					{foreach $event->totals.pilots as $p}
					{$event_pilot_id=$p.event_pilot_id}
					{if $event->pilots.$event_pilot_id.class_id==$c.class_id}
					<tr style="background-color: {cycle values="#9DCFF0,white"};">
						<td>{$rank}</td>
						<td nowrap>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
						<td>{$p.total|string_format:"%06.2f"}</td>
					</tr>
					{$rank=$rank+1}
					{/if}
					{/foreach}
			{/foreach}
		</tr>
		</table>
	</div>
	{/if}
	{if $event->totals.teams}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;">                
		<h1 class="post-title">Team Rankings</h1>
		<table cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Team</th>
			<th>Total</th>
		</tr>
		{foreach $event->totals.teams as $t}
		<tr style="background-color:#9DCFF0;">
			<td>{$t.rank}</td>
			<td nowrap>{$t.team_name|escape}</td>
			<td>{$t.total|string_format:"%06.2f"}</td>
		</tr>
			{foreach $event->totals.pilots as $p}
			{$event_pilot_id=$p.event_pilot_id}
			{if $event->pilots.$event_pilot_id.event_pilot_team==$t.team_name}
			<tr>
				<td></td>
				<td>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
				<td align="right">{$p.total|string_format:"%06.2f"}</td>
			</tr>
			{/if}
			{/foreach}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $duration_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Duration Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{foreach $duration_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:"%06.2f"}</td>
			</tr>
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Distance Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{foreach $distance_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:"%06.2f"}</td>
			</tr>
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $speed_rank}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Speed Ranking</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th></th>
			<th>Pilot</th>
			<th>Score</th>
		</tr>
		{$rank=1}
		{foreach $speed_rank as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_round_flight_score|string_format:"%06.2f"}</td>
			</tr>
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
</div>
{/if}

<!-- Lets figure out if there are reports for speed or laps -->
{if $lap_totals || $speed_averages || $top_landing}
<h1 class="post-title">Statistics Reports</h1>
<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;">
	{if $lap_totals}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Total Distance Laps</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
		</tr>
		{foreach $lap_totals as $p}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$p.event_pilot_lap_rank|escape}</td>
				<td nowrap>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_total_laps|escape}</td>
			</tr>
		{/foreach}
		</table>
	</div>
	{/if}
	{if $distance_laps}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Top 20 Distance Runs</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Laps</th>
		</tr>
		{$rank=1}
		{foreach $distance_laps as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td align="center">{$p.event_pilot_round_flight_laps|escape}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
	{if $speed_averages}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Average Speeds</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{foreach $speed_averages as $p}
			{if $p.event_pilot_average_speed_rank!=0}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$p.event_pilot_average_speed_rank}</td>
				<td nowrap>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
				<td>{$p.event_pilot_average_speed|string_format:"%06.2f"}</td>
			</tr>
			{/if}
		{/foreach}
		</table>
	</div>
	
		<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Top 20 Speed Runs</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Speed</th>
			<th>Round</th>
		</tr>
		{$rank=1}
		{foreach $speed_times as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td>{$p.event_pilot_round_flight_seconds|string_format:"%06.2f"}</td>
				<td align="center">{$p.event_round_number|escape}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	{if $top_landing}
	<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;">                
		<h1 class="post-title">Landing Averages</h1>
		<table align="center" cellpadding="2" cellspacing="1" class="tableborder">
		<tr>
			<th>Rank</th>
			<th>Pilot</th>
			<th>Avg</th>
		</tr>
		{$rank=1}
		{foreach $top_landing as $p}
			{$event_pilot_id=$p.event_pilot_id}
			<tr style="background-color: {cycle values="#9DCFF0,white"};">
				<td>{$rank}</td>
				<td nowrap>{$event->pilots.$event_pilot_id.pilot_first_name|escape} {$event->pilots.$event_pilot_id.pilot_last_name|escape}</td>
				<td>{$p.average_landing|string_format:"%02.2f"}</td>
			</tr>
			{if $rank==20}{break}{/if}
			{$rank=$rank+1}
		{/foreach}
		</table>
	</div>
	{/if}
	
</div>
{/if}

<form name="goback" method="GET">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_list">
</form>
<form name="event_view_draws" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view_draws">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
<form name="event_view_info" method="POST">
<input type="hidden" name="action" value="event">
<input type="hidden" name="function" value="event_view_info">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
</form>
{if $event->rounds}
<script>
	 document.getElementById('pilots').style.display = 'none';
	 document.getElementById('viewtoggle').innerHTML = '(<u>Show</u>)';
</script>
{/if}