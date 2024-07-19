{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

	<div class="panel">
		<div class="panel-heading">
			<h2 class="heading">{$series->info.series_name|escape}</h2>
			<div style="float:right;overflow:hidden;margin-top:10px;">
				<input type="button" value=" Back To Series View " onClick="document.goback.submit();"
					class="btn btn-primary btn-rounded" style"float:right;">
			</div>
		</div>
		<div class="panel-body">

			<h2 class="post-title entry-title">
				Pilot Event Detail for {$series->totals.pilots.$pilot_id.pilot_first_name|escape}
				{$series->totals.pilots.$pilot_id.pilot_last_name|escape}
				{if $series->totals.pilots.$pilot_id.excluded==true}<font color="red">(Results Excluded From Series Totals)
				</font>{/if}
			</h2>
			<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered table-striped">
				<tr>
					<th width="2%" align="center">Number</th>
					<th align="left">Event Name</th>
					<th width="10%" align="right">Event Score</th>
					<th width="5%" nowrap>Event Rank</th>
				</tr>
				{$num=1}
				{foreach $series->events as $e}
					<tr>
						{$event_id=$e@key}
						{$bgcolor='#9DCFF0'}
						<td align="center">{$num|escape}</td>
						<td align="left"><a href="?action=event&function=event_view&event_id={$e.event_id|escape:'url'}"
								class="btn-link">{$e.event_name|escape}</a></td>
						<td align="right" nowrap>
							{if $series->totals.pilots.$pilot_id.events.$event_id.dropped==1}<del>
								<font color="red">{/if}
									{$series->totals.pilots.$pilot_id.events.$event_id.event_score|string_format:"%06.3f"}
									{if $series->totals.pilots.$pilot_id.events.$event_id.dropped==1}</font>
							</del>{/if}
						</td>
						<td align="right" nowrap>
							{$series->totals.pilots.$pilot_id.events.$event_id.event_pilot_position|escape}
						</td>
					</tr>
					{$num=$num+1}
				{/foreach}
			</table>

			<h2 class="post-title entry-title">Pilot Totals for {$series->totals.pilots.$pilot_id.pilot_first_name|escape}
				{$series->totals.pilots.$pilot_id.pilot_last_name|escape}</h2>
			<table width="50%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
				<tr>
					<th>Overall Rank</th>
					<td>{$series->totals.pilots.$pilot_id.overall_rank|escape}</td>
				</tr>
				<tr>
					<th>Total Points</th>
					<td>{$series->totals.pilots.$pilot_id.total_score|string_format:"%06.3f"}</td>
				</tr>
				<tr>
					<th>Event Percentage</th>
					<td>{$series->totals.pilots.$pilot_id.pilot_total_percentage|string_format:"%06.3f"} %</td>
				</tr>
			</table>
			<br>

		</div>
	</div>

	<form name="goback" method="GET">
		<input type="hidden" name="action" value="series">
		<input type="hidden" name="function" value="series_view">
		<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
	</form>
	<form name="print_pilot" action="?" method="GET" target="_blank">
		<input type="hidden" name="action" value="series">
		<input type="hidden" name="function" value="series_print_pilot">
		<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
		<input type="hidden" name="pilot_id" value="{$pilot_id|escape}">
		<input type="hidden" name="use_print_header" value="1">
	</form>

{/block}