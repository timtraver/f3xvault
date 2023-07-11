{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Event Draws for {$event->info.event_name|escape}</h2>
		<div style="float:right;overflow:hidden;margin-top:10px;">
			<input type="button" value=" Back To Event View " onClick="document.goback.submit();" class="btn btn-primary btn-rounded" style"float:right;">
		</div>
	</div>
	<div class="panel-body">

		<h3 class="post-title entry-title">Draws</h3>
		<form name="main" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_draw_edit">
		<input type="hidden" name="event_draw_id" value="0">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="flight_type_id" value="{$flight_type_id}">
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		<tr>
			<th width="10%" nowrap>Flight Type</th>
			<th width="5%" nowrap>Status</th>
			<th width="10%" nowrap>Draw Type</th>
			<th width="10%" nowrap>Round From</th>
			<th width="10%" nowrap>Round To</th>
			<th width="20%"  nowrap>View</th>
			<th width="25%" nowrap>Action</th>
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
					{if $d.flight_type_id!=$ft.flight_type_id}
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
						<td align="center" nowrap>
							Not Applied
						</td>
					{/if}
					<td align="center">{if $d.event_draw_type=="random"}Random{elseif $d.event_draw_type=='random_step'}Random With Step{elseif $d.event_draw_type=='group'}Group{/if}</td>
					<td align="center">{$d.event_draw_round_from}</td>
					<td align="center">{$d.event_draw_round_to}</td>
					<td align="center" nowrap>
						<div style="overflow: hidden;">
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" id="change_pilot_info_button" type="button" onclick="window.open('?action=event&function=event_draw_view&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}&flight_type_id={$d.flight_type_id}&use_print_header=1','_blank');"> View Draw </button></div>
							{if ( $ft.flight_type_code!="f3b_speed" && $ft.flight_type_code!="f3b_speed_only" && $ft.flight_type_code!="f3f_speed" ) || $d.event_draw_type=='group'}
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" id="change_pilot_info_button" type="button" onclick="location.href='?action=event&function=event_draw_stats&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}&flight_type_id={$d.flight_type_id}';"> View Stats </button></div>
							{/if}
						</div>
					</td>
					<td nowrap>
						<div style="overflow: hidden;">
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" type="button" onclick="if(check_permission()){ldelim}if(confirm('Are you sure you wish to delete this draw?')){ldelim}location.href='?action=event&function=event_draw_delete&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}';{rdelim}{rdelim}"> Delete </button></div>
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" type="button" onclick="if(check_permission()){ldelim}location.href='?action=event&function=event_draw_edit&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}&flight_type_id={$d.flight_type_id}';{rdelim}"> Edit </button></div>
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" type="button" onclick="if(check_permission()){ldelim}if(confirm('Are you sure you wish to unapply this draw?')){ldelim}location.href='?action=event&function=event_draw_unapply&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}&flight_type_id={$d.flight_type_id}';{rdelim}{rdelim}"> UnApply </button></div>
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" type="button" onclick="if(check_permission()){ldelim}if(confirm('Are you sure you wish to apply this draw to the future rounds? Any current rounds entered will not be changed.')){ldelim}location.href='?action=event&function=event_draw_apply&event_draw_id={$d.event_draw_id}&event_id={$event->info.event_id}&flight_type_id={$d.flight_type_id}';{rdelim}{rdelim}"> Apply </button></div>
						</div>
					</td>
					</tr>
				{/foreach}
			{/if}
			{if $event->info.event_type_code=='f3k'}
				{$f3k_first=1}
			{/if}
		{/foreach}
		<tr>
			<td colspan="7" style="text-align: right;padding-top:10px;">
				{$f3k_first=0}
				{foreach $event->flight_types as $ft}
				{if $f3k_first!=0}
					{continue}
				{/if}
				<input type="button" value=" Create {if $event->info.event_type_code=='f3k'}F3K{else}{$ft.flight_type_name}{/if} Draw " onClick="if(check_permission()){ldelim}document.main.flight_type_id.value={$ft.flight_type_id};submit();{rdelim}" class="btn btn-primary btn-rounded">
				{if $event->info.event_type_code=='f3k'}
					{$f3k_first=1}
				{/if}
				{/foreach}
			</td>
		</tr>
		</table>
		</form>

		<h3 class="post-title entry-title">Printing Active Draws</h3>
		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-event">
		{$f3k_first=0}
		{if $event->draws && $print_rounds|count >0}
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
					<td nowrap>
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
						<div style="overflow: hidden;float: right;">
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" type="button" onclick="document.print_{$ft.flight_type_id}.print_type.value='matrix';submit();"> Full Draw Matrix </button></div>
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" type="button" onclick="document.print_{$ft.flight_type_id}.print_type.value='table';submit();"> Draw Table </button></div>
							{if ( !$ft.flight_type_code|strstr:"speed" && !$ft.flight_type_code|strstr:"distance") || $ft.flight_type_code|strstr:"gps_distance"}
								<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" type="button" onclick="document.print_{$ft.flight_type_id}.print_type.value='pilot';submit();"> Pilot Recording Sheets </button></div>
							{/if}
							{if $ft.flight_type_code|strstr:"f5j" || $ft.flight_type_code|strstr:"f3k" || $ft.flight_type_code|strstr:"f3j" || $ft.flight_type_code|strstr:"td" || $ft.flight_type_code|strstr:"f3l" }
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" type="button" onclick="document.print_{$ft.flight_type_id}.print_type.value='pilot_summary';submit();"> Pilot Recording Sheets (Summary) </button></div>
							{/if}
							{if !$ft.flight_type_code|strstr:"f3k"}
							<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" type="button" onclick="document.print_{$ft.flight_type_id}.print_type.value='cd';submit();"> CD Recording Sheet </button></div>
							{/if}
						</div>
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
						<div class="btn-group btn-group-xs" style="display: inline-block;margin-left: 5px;"><button class="btn btn-primary btn-rounded" id="change_pilot_info_button" type="button" onclick="document.print_f3b_combined.print_type.value='f3b_table';submit();"> Draw Table </button></div>
					</td>
				</tr>
			{/if}
		{else} {* if no draws are active *}
			<tr>
				<td colspan="2" nowrap>There are no current applied draws to print. Apply a draw above to print.</td>
			</tr>
		{/if}
		</table>
		</form>
		
		<form name="goback" method="POST">
		<input type="hidden" name="action" value="event">
		<input type="hidden" name="function" value="event_view">
		<input type="hidden" name="event_id" value="{$event->info.event_id}">
		<input type="hidden" name="tab" value="">
		</form>

	</div>
</div>
{/block}
{block name="footer"}
<script type="text/javascript">
function check_permission() {ldelim}
	{if $permission!=1}
		alert('Sorry, but you do not have permission to access this function.');
		return 0;
	{else}
		return 1;
	{/if}
{rdelim}
</script>
{/block}