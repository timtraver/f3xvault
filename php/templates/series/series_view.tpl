{extends file='layout/layout_main.tpl'}

{block name="header"}
{literal}
<style>
table {
  text-align: left;
  position: relative;
  border-collapse: collapse; 
}

thead {
  background: white;
  z-index: 4;
  position: sticky;
  top: 0; /* Don't forget this, required for the stickiness */
}
thead th {
  position: sticky;
  left: 0;
  z-index: 2;
}
tbody th:first-child {
  position: sticky;
  left: 0;
  background: white;
  z-index: 1;
}

</style>
{/literal}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">{$series->info.series_name|escape}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Reload " onClick="document.reload.submit();" class="btn btn-primary btn-rounded" style"float:right;">
			<input type="button" value=" Edit Series Parameters " onClick="document.edit_series.submit();" class="btn btn-primary btn-rounded" style"float:right;">
			<input type="button" value=" Back To Series List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">
		
		<form name="series_save_multiples" method="POST">
		<input type="hidden" name="action" value="series">
		<input type="hidden" name="function" value="series_save_multiples">
		<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
		
		<table width="100%" cellpadding="0" cellspacing="0" class="table table-condensed table-bordered">
		<tr>
			<th width="20%" style="text-align:right;">Series Name</th>
			<td>
			{$series->info.series_name|escape}
			</td>
		</tr>
		<tr>
			<th style="text-align:right;">Location</th>
			<td>
			{$series->info.series_area|escape},{if $series->info.state_code != NULL}{$series->info.state_code|escape}{/if} {$series->info.country_code|escape}
			{if $series->info.country_code}<img src="/images/flags/countries-iso/shiny/24/{$series->info.country_code|escape}.png" style="vertical-align: middle;">{/if}
			{if $series->info.state_name != 'Other' && $series->info.country_code=="US"}<img src="/images/flags/states/24/{$series->info.state_name|replace:' ':'-'}-Flag-24.png" style="vertical-align: middle;">{/if}
			</td>
		</tr>
		<tr>
			<th style="text-align:right;">Series Web URL</th>
			<td><a href="{$series->info.series_url}" target="_new" class="btn-link">{$series->info.series_url}</a></td>
		</tr>
		<tr>
			<th style="text-align:right;">Series Scoring Type</th>
			<td>
				{if $series->info.series_scoring_type=='standard'}
					Standard Scoring - Event percentage.
				{elseif $series->info.series_scoring_type=='position'}
					Position Scoring - Event position. Lower is better.
				{elseif $series->info.series_scoring_type=='teamusa'}
					USA Team Selects Scoring - Top 30% receive a point. Double points for multiple day event.
				{elseif $series->info.series_scoring_type=='f5jtour'}
					USA F5J Tour - Event Percentage x 1000 plus bonus points for number of pilots if 2 day event.
				{/if}
			</td>
		</tr>
		</table>
		
		<h2 class="post-title entry-title">Series Events</h2>
		<div style="overflow:auto; height:300px;">
		<table width="100%" cellpadding="1" cellspacing="1" class="table-striped table-series">
			<thead>
				<tr>
					<th align="center">#</th>
					<th align="left" width="10%">Date</th>
					<th align="left">Event Name</th>
					<th align="left">Location</th>
					<th align="left">State</th>
					<th align="left">Country</th>
					<th align="left">Pilots</th>
					<th align="left">Point Multiple</th>
				</tr>
			</thead>
		{$num=1}
		{foreach $series->events as $e}
		<tr>
			<td align="center">{$num|escape}</td>
			<td nowrap>{$e.event_start_date|date_format:"Y-m-d"}</td>
			<td>
				<a href="?action=event&function=event_view&event_id={$e.event_id|escape:'url'}" class="btn-link">{$e.event_name|escape}</a>
			</td>
			<td>{$e.location_name|escape}</td>
			<td nowrap>
				{if $e.state_name && $e.country_code=="US"}<img src="/images/flags/states/16/{$e.state_name|replace:' ':'-'}-Flag-16.png" style="vertical-align: middle;">{/if}
				{$e.state_name|escape}
			</td>
			<td nowrap>
				{if $e.country_code}<img src="/images/flags/countries-iso/shiny/16/{$e.country_code|escape}.png" style="vertical-align: middle;">{/if}
				{$e.country_name|escape}
			</td>
			<td nowrap>{$e.total_pilots|escape}</td>
			<td nowrap>
				<input type="text" name="multiple_{$e.event_series_id|escape}" size="6" value="{$e.event_series_multiple|escape}">
				<input type="checkbox" name="mandatory_{$e.event_series_id|escape}" {if $e.event_series_mandatory}CHECKED{/if}> Mandatory
			</td>
		</tr>
		{$num=$num+1}
		{/foreach}
		</table>
		</div>
		<br>
		<input type="button" value=" Save Series Parameters " onClick="document.series_save_multiples.submit();" class="btn btn-primary btn-rounded" style="float:right;">
		</form>

		{$event_num=1}
		<h2 class="post-title entry-title">Series Overall Standings</h2>
		<div style="overflow:auto; height:600px;">
		<table width="100%" cellpadding="1" cellspacing="1" class="table-striped table-series">
			<thead>
			<tr>
				<th colspan="3" align="right" nowrap></th>
				<th colspan="{$series->totals.total_events + 1}" align="center" nowrap>
					{assign var='best' value='0'}
					{foreach $series->options as $key => $o}
						{if $o.series_option_type_code == 'best'}
							{assign var="best" value=$o.series_option_value}
						{/if}
					{/foreach}
					{if $best > 0}
						Series Events ( Best {$best|escape} out of {$series->completed_events|escape} Completed Events )
					{else}
						Series Events ({if $series->totals.round_drops==0}No{else}{$series->totals.round_drops|escape}{/if} Drop{if $series->totals.round_drops!=1}s{/if} In Effect over {$series->completed_events|escape} Completed Events)
					{/if}
				</th>
				<th width="5%" nowrap>Total Score</th>
				{if $series->info.series_scoring_type=='standard' || $series->info.series_scoring_type=='f5jtour'}
				<th width="5%" nowrap>Percentage</th>
				{/if}
			</tr>
			<tr>
				<th width="2%" align="left"></th>
				<th width="10%" align="right" nowrap>Pilot Name</th>
				<th width="2%" align="right" nowrap>Events</th>
				{foreach $series->events as $e}
					<th width="1%" align="center" style="text-align: center;" nowrap>
						<a class="tooltip_score_right_low" href="/?action=event&function=event_view&event_id={$e.event_id|escape:'url'}">E {$event_num|escape}
							<span style="z-index: 20;">{$e.event_name|escape} - {$e.event_start_date|date_format:"Y-m-d"}</span>
						</a>
					</th>
					{$event_num=$event_num+1}
				{/foreach}
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				{if $series->info.series_scoring_type=='standard' || $series->info.series_scoring_type=='f5jtour'}
				<th>&nbsp;</th>
				{/if}
			</tr>
			</thead>
			<tbody>
				{$previous=0}
				{$diff_to_lead=0}
				{$diff=0}
				{foreach $series->totals.pilots as $p}
				{$pilot_id=$p@key}
				{if $p.total_score>$previous}
					{$previous=$p.total_score}
				{else}
					{$diff=$previous-$p.total_score}
					{$diff_to_lead=$diff_to_lead+$diff}
				{/if}
				<tr>
					<td>{$p.overall_rank|escape}</td>
					<td align="right" nowrap>
						<a href="?action=series&function=series_pilot_view&pilot_id={$pilot_id|escape:'url'}&series_id={$series->info.series_id|escape:'url'}" class="btn-link">{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</a>
					</td>
					<td align="center" nowrap>
						{$p.total_events|escape}
					</td>
					{foreach $series->events as $e}
						{$event_id=$e.event_id|escape}
						<td class="info" align="right"{if $e.pilots.$pilot_id.event_pilot_position==1} style="border-width: 2px;border-color: green;color:green ;font-weight:bold;"{/if}>
							<div style="position:relative;">
								<a href="" class="tooltip_series_score" onClick="return false;">
									{$drop=$p.events.$event_id.dropped}
									{if $drop==1}<del><font color="red">{/if}
									{if $p.events.$event_id.event_score!=0}
										{if $series->info.series_scoring_type=='position' || $series->info.series_scoring_type=='teamusa'}
											{$p.events.$event_id.event_score|string_format:"%.1f"}
										{else}
											{$p.events.$event_id.event_score|string_format:"%0.2f"}
										{/if}
									{else}
										0
									{/if}
									{if $drop==1}</font></del>{/if}
									<span {if $series->info.series_scoring_type!='f5jtour'}style="margin-top: -40px; "{/if}>
										{if $series->info.series_scoring_type=='position' || $series->info.series_scoring_type=='teamusa'}
											{$p.events.$event_id.event_score|string_format:"%.1f"}
										{else if $series->info.series_scoring_type=='f5jtour'}
										<table>
												<tr>
													<th>Prelim</th>
													<td align="right">{$p.events.$event_id.event_score_orig|string_format:"%0.2f"}</td>
												</tr>
												<tr>
													<th>Bonus</th>
													<td align="right">{$p.events.$event_id.event_score_bonus|string_format:"%0.2f"}</td>
												</tr>
											</table>
										{else}
											<table>
												<tr>
													<th>{$p.events.$event_id.event_score|string_format:"%0.3f"}</th>
												</tr>
											</table>
										{/if}
									</span>
								</a>
							</div>
						</td>
					{/foreach}
					<td></td>
					
					<td width="5%" nowrap align="right">
						<a href="" class="tooltip_score_left" onClick="return false;">
							{if $series->info.series_scoring_type=='position' || $series->info.series_scoring_type=='teamusa'}
								{$p.total_score|string_format:"%.1f"}
							{else}
								{$p.total_score|string_format:"%0.2f"}
							{/if}
							<span>
								<b>Behind Prev</b> : {$diff|string_format:"%06.3f"}<br>
								<b>Behind Lead</b> : {$diff_to_lead|string_format:"%06.3f"}<br>
							</span>
						</a>
					</td>
					{if $series->info.series_scoring_type=='standard' || $series->info.series_scoring_type=='f5jtour'}
						<td width="5%" nowrap align="right">{$p.pilot_total_percentage|string_format:"%03.2f"}%</td>
					{/if}
				</tr>
				{$previous=$p.total_score}
				{/foreach}
			</tbody>
		</table>
		</div>
		<br>
		<br>
	</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_list">
</form>
<form name="edit_series" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_edit">
<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
</form>
<form name="reload" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_view">
<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
</form>

{/block}
