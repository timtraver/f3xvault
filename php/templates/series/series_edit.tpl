{extends file='layout/layout_main.tpl'}

{block name="content"}

	<div class="panel">
		<div class="panel-heading">
			<h2 class="heading">Event Series Edit</h2>
			<div style="float:right;overflow:hidden;margin-top:10px;">
				<input type="button" value=" Back To Series View " onClick="document.goback.submit();"
					class="btn btn-primary btn-rounded" style"float:right;">
			</div>
		</div>
		<div class="panel-body">

			<h2 class="post-title entry-title">Series Basic Parameters</h2>
			<form name="main" method="POST">
				<input type="hidden" name="action" value="series">
				<input type="hidden" name="function" value="series_save">
				<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
				<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
					<tr>
						<th>Series Name</th>
						<td>
							<input type="text" size="60" name="series_name" value="{$series->info.series_name|escape}">
						</td>
					</tr>
					<tr>
						<th>Series Area</th>
						<td>
							<input type="text" size="60" name="series_area" value="{$series->info.series_area|escape}">
						</td>
					</tr>
					<tr>
						<th>State</th>
						<td>
							<select name="state_id">
								{foreach $states as $s}
									<option value="{$s.state_id|escape}" {if $series->info.state_id==$s.state_id}SELECTED{/if}>
										{$s.state_name|escape}</option>
								{/foreach}
							</select>
						</td>
					</tr>
					<tr>
						<th>Country</th>
						<td>
							<select name="country_id">
								{foreach $countries as $c}
									<option value="{$c.country_id|escape}"
										{if $series->info.country_id==$c.country_id}SELECTED{/if}>{$c.country_name|escape}
									</option>
								{/foreach}
							</select>
						</td>
					</tr>
					<tr>
						<th>Series Web URL</th>
						<td>
							<input type="text" size="60" name="series_url" value="{$series->info.series_url}">
						</td>
					</tr>
				</table>

				<h2 class="post-title entry-title">Series Scoring Parameters</h2>
				<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
					<tr>
						<th>Standard Scoring</th>
						<td>
							<input type="radio" name="series_scoring_type" value="standard"
								{if $series->info.series_scoring_type=='' || $series->info.series_scoring_type=='standard'}
								CHECKED{/if}>
							This standard scoring uses the percentage of total points from each event, multiplied by 10 as
							the points for each event.
						</td>
					</tr>
					<tr>
						<th>Position Based</th>
						<td>
							<input type="radio" name="series_scoring_type" value="position"
								{if $series->info.series_scoring_type=='position'} CHECKED{/if}>
							This scoring uses the final place position as the score for the pilot with the lowest score
							being better. If an event is missed it is given a score of the number of pilots in the event
							plus one.
						</td>
					</tr>
					<tr>
						<th>USA Team Select Scoring</th>
						<td>
							<input type="radio" name="series_scoring_type" value="teamusa"
								{if $series->info.series_scoring_type=='teamusa'} CHECKED{/if}>
							This scoring gives a single point for the top 30% of positions in an event, and orders by
							highest score.
						</td>
					</tr>
					<tr>
						<th>USA F5J Tour</th>
						<td>
							<input type="radio" name="series_scoring_type" value="f5jtour"
								{if $series->info.series_scoring_type=='f5jtour'} CHECKED{/if}>
							This scoring gives the normalized score, plus bonus points based on number of participants.
						</td>
					</tr>
					<tr>
						<th>FAI World Cup Scoring</th>
						<td>
							<input type="radio" name="series_scoring_type" value="faiwc"
								{if $series->info.series_scoring_type=='faiwc'} CHECKED{/if}>
							This scoring gives a custom FAI World Cup Scoring model.
						</td>
					</tr>
					<tr>
						<td colspan="3" style="text-align: center;">
							<input type="submit" value=" Save Series Info{if $from} and Return{/if} "
								class="btn btn-primary btn-rounded">
						</td>
					</tr>
				</table>

				{foreach $from as $f}
					<input type="hidden" name="{$f.key|escape}" value="{$f.value|escape}">
				{/foreach}
			</form>

			{if $series->info.series_id!=0}
				<h2 class="post-title entry-title">Edit Series Parameters</h2>
				<form name="event_options" method="POST">
					<input type="hidden" name="action" value="series">
					<input type="hidden" name="function" value="series_param_save">
					<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
						<tr>
							<th colspan="3" align="left">The Following Specific Parameters Are for this series</th>
						</tr>
						{foreach $series->options as $o}
							<tr>
								<th align="right" width="30%">{$o.series_option_type_name|escape} (<a href="#"
										title="{$o.series_option_type_description|escape}">?</a>)</th>
								<td>
									{if $o.series_option_type_type == 'boolean'}
										<select name="option_{$o.series_option_type_id|escape}_{$o.series_option_id|escape}">
											<option value="yes"
												{if $o.series_option_status==1 && $o.series_option_value ==1}SELECTED{/if}>Yes</option>
											<option value="no"
												{if $o.series_option_status==1 && $o.series_option_value ==0}SELECTED{/if}>No</option>
										</select>
									{else}
										<input type="text" name="option_{$o.series_option_type_id|escape}_{$o.series_option_id|escape}"
											size="{$o.series_option_type_size|escape}" value="{$o.series_option_value|escape}">
									{/if}

								</td>
								<td width="2%">
									<a href="?action=series&function=series_option_del_parameter&series_id={$series->info.series_id|escape:'url'}&series_option_id={$o.series_option_id|escape:'url'}"
										title="Remove Option"
										onClick="return confirm('Are you sure you wish to remove this option?');"><img
											src="/images/del.gif"></a>
								</td>
							</tr>
						{/foreach}
						<tr>
							<td colspan="3">
								<input type="submit" value=" Save These Series Parameters " class="btn btn-primary btn-rounded">
								<input type="button" value=" Add Drop " class="btn btn-primary btn-rounded"
									onClick="var round=prompt('Enter Round for new drop :');if(round!=null && round!=''){ldelim}document.add_parameter.drop_round.value=round;document.add_parameter.submit();{rdelim}">
								<input type="button" value=" Add Best Number of Events " class="btn btn-primary btn-rounded"
									onClick="var best=prompt('Enter best X Events :');if(best!=null && best!=''){ldelim}document.add_parameter.best_of.value=best;document.add_parameter.submit();{rdelim}">
							</td>
						</tr>

					</table>
				</form>

				<h2 class="post-title entry-title">Edit Series Access</h2>
				<form name="series_user" method="POST">
					<input type="hidden" name="action" value="series">
					<input type="hidden" name="function" value="series_user_save">
					<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
					<input type="hidden" name="user_id" value="">
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
						<tr>
							<th colspan="2" align="left">The Following Users Have Access To Edit This Series</th>
						</tr>
						{foreach $series->access as $u}
							<tr>
								<td>{$u.user_first_name|escape} {$u.user_last_name|escape}</td>
								<td width="2%">
									<a
										href="?action=series&function=series_user_delete&series_id={$series->info.series_id|escape:'url'}&series_user_id={$u.series_user_id|escape:'url'}"><img
											src="/images/del.gif"></a>
								</td>
							</tr>
						{/foreach}
						<tr>
							<th colspan="2">
								Add New User
								<input type="text" id="series_user_name" name="series_user_name" size="40">
								<img id="loading_user" src="/images/loading.gif" style="vertical-align: middle;display: none;">
								<span id="user_message" style="font-style: italic;color: grey;">Start typing to search
									pilots</span>
								<input type="submit" value=" Add This User " class="block-button">
							</th>
						</tr>

					</table>
				</form>

				<h2 class="post-title entry-title">Series Events</h2>
				<form name="series_event" method="POST">
					<input type="hidden" name="action" value="series">
					<input type="hidden" name="function" value="series_event_save">
					<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
					<input type="hidden" name="event_id" value="">
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
						<tr>
							<th colspan="2" align="left">The Following Events Are In This Series</th>
						</tr>
						{foreach $series->events as $e}
							<tr>
								<td>{$e.event_start_date|date_format:"Y-m-d"} - {$e.event_name|escape}</td>
								<td width="2%">
									<a href="?action=series&function=series_event_delete&series_id={$series->info.series_id|escape:'url'}&event_series_id={$e.event_series_id|escape:'url'}"
										title="Remove Event"
										onClick="return confirm('Are you sure you wish to remove this event?');"><img
											src="/images/del.gif"></a>
								</td>
							</tr>
						{/foreach}
						<tr>
							<th colspan="2">
								Add Event To Series
								<input type="text" id="series_event_name" name="series_event_name" size="40">
								<img id="loading_event" src="/images/loading.gif" style="vertical-align: middle;display: none;">
								<span id="series_event_message" style="font-style: italic;color: grey;">Start typing to search
									events</span>
								<input type="submit" value=" Add This Event " class="block-button">
							</th>
						</tr>

					</table>
				</form>

				<h2 class="post-title entry-title">Edit Series Exclusions</h2>
				<form name="series_pilot" method="POST">
					<input type="hidden" name="action" value="series">
					<input type="hidden" name="function" value="series_exclusion_save">
					<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
					<input type="hidden" name="pilot_id" value="">
					<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
						<tr>
							<th colspan="2" align="left">The Following Pilots Have Been Excluded from the Series Totals</th>
						</tr>
						{foreach $series->excluded as $p}
							<tr>
								<td>{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</td>
								<td width="2%">
									<a
										href="?action=series&function=series_exclusion_delete&series_id={$series->info.series_id|escape:'url'}&series_exclusion_id={$p.series_exclusion_id|escape:'url'}"><img
											src="/images/del.gif"></a>
								</td>
							</tr>
						{/foreach}
						<tr>
							<th colspan="2">
								Add New Pilot Exclusion
								<input type="text" id="series_pilot_name" name="series_pilot_name" size="40">
								<img id="loading_pilot" src="/images/loading.gif" style="vertical-align: middle;display: none;">
								<span id="exclusion_message" style="font-style: italic;color: grey;">Start typing to search
									pilots</span>
								<input type="submit" value=" Add This Pilot " class="block-button">
							</th>
						</tr>

					</table>
				</form>

			{/if}

			<form name="goback" method="POST">
				<input type="hidden" name="action" value="series">
				{if $series->info.series_id==0}
					<input type="hidden" name="function" value="series_list">
				{else}
					<input type="hidden" name="function" value="series_view">
					<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
				{/if}
			</form>
			<form name="add_parameter" method="POST">
				<input type="hidden" name="action" value="series">
				<input type="hidden" name="function" value="series_option_add_parameter">
				<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
				<input type="hidden" name="drop_round" value="0">
				<input type="hidden" name="best_of" value="0">
			</form>
			<form name="del_parameter" method="POST">
				<input type="hidden" name="action" value="series">
				<input type="hidden" name="function" value="series_option_del_parameter">
				<input type="hidden" name="series_id" value="{$series->info.series_id|escape}">
				<input type="hidden" name="series_option_id" value="0">
			</form>

		</div>
	</div>

{/block}
{block name="footer"}
	<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
	<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
	<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
	<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
	<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
	<script>
		{literal}
			$(function() {
				$("#series_user_name").autocomplete({
					source: "/lookup.php?function=lookup_user",
					minLength: 2,
					highlightItem: true,
					matchContains: true,
					autoFocus: true,
					scroll: true,
					scrollHeight: 300,
					search: function(event, ui) {
						var loading = document.getElementById('loading_user');
						loading.style.display = "inline";
					},
					select: function(event, ui) {
						document.series_user.user_id.value = ui.item.id;
					},
					change: function(event, ui) {
						if (document.series_user.series_user_name.value == '') {
							document.series_user.user_id.value = 0;
						}
					},
					response: function(event, ui) {
						var loading = document.getElementById('loading_user');
						loading.style.display = "none";
						var mes = document.getElementById('user_message');
						if (ui.content && ui.content.length) {
							mes.innerHTML = ' Found ' + ui.content.length +
								' results. Use Arrow keys to select';
						} else {
							mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
						}
					}
				});
				$("#series_event_name").autocomplete({
					source: "/lookup.php?function=lookup_event",
					minLength: 2,
					highlightItem: true,
					matchContains: true,
					autoFocus: true,
					scroll: true,
					scrollHeight: 300,
					search: function(event, ui) {
						var loading = document.getElementById('loading_event');
						loading.style.display = "inline";
					},
					select: function(event, ui) {
						document.series_event.event_id.value = ui.item.id;
					},
					change: function(event, ui) {
						if (document.series_event.series_event_name.value == '') {
							document.series_event.event_id.value = 0;
						}
					},
					response: function(event, ui) {
						var loading = document.getElementById('loading_event');
						loading.style.display = "none";
						var mes = document.getElementById('series_event_message');
						if (ui.content && ui.content.length) {
							mes.innerHTML = ' Found ' + ui.content.length +
								' results. Use Arrow keys to select';
						} else {
							mes.innerHTML = ' No Results Found.';
						}
					}
				});
				$("#series_pilot_name").autocomplete({
					source: "/lookup.php?function=lookup_pilot",
					minLength: 2,
					highlightItem: true,
					matchContains: true,
					autoFocus: true,
					scroll: true,
					scrollHeight: 300,
					search: function(event, ui) {
						var loading = document.getElementById('loading_pilot');
						loading.style.display = "inline";
					},
					select: function(event, ui) {
						document.series_pilot.pilot_id.value = ui.item.id;
					},
					change: function(event, ui) {
						if (document.series_pilot.series_pilot_name.value == '') {
							document.series_pilot.pilot_id.value = 0;
						}
					},
					response: function(event, ui) {
						var loading = document.getElementById('loading_pilot');
						loading.style.display = "none";
						var mes = document.getElementById('exclusion_message');
						if (ui.content && ui.content.length) {
							mes.innerHTML = ' Found ' + ui.content.length +
								' results. Use Arrow keys to select';
						} else {
							mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
						}
					}
				});

			});
		</script>
	{/literal}
{/block}