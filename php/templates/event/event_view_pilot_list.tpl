{if $user.user_id!=0 && ($permission==1 || $user.user_admin==1)}
<div style="margin-bottom: 3px;">
	<div class="btn-group btn-group-xs" style="float: right;"><button class="btn btn-primary btn-rounded" type="button" onclick="if(check_permission()){ldelim}var name=document.getElementById('pilot_name');document.event_pilot_add.pilot_name.value=name.value;event_pilot_add.submit();{rdelim}"> + Add New Pilot </button></div>
	<input type="text" id="pilot_name" name="pilot_name" size="40">
	<img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
	<span id="search_message" style="font-style: italic;color: grey;"> Start typing to search pilot to Add</span>
</div>
{/if}
Sort Pilots By : 
<select name="sort_pilot" onChange="document.event_view.tab.value=2;document.event_view.event_pilot_sort_by.value=this.value;document.event_view.submit();">
	<option value="entry_order"{if $event_pilot_sort_by == 'entry_order'} SELECTED{/if}>Entry Order</option>
	<option value="alphabetical_first"{if $event_pilot_sort_by == 'alphabetical_first'} SELECTED{/if}>First Name</option>
	<option value="alphabetical_last"{if $event_pilot_sort_by == 'alphabetical_last'} SELECTED{/if}>Last Name</option>
	<option value="team"{if $event_pilot_sort_by == 'team'} SELECTED{/if}>Team Name</option>
</select>
<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped table-event">
<tr>
	<th width="2%" align="left">#</th>
	<th align="left" colspan="2">Pilot Name</th>
	<th width="5%" align="left">AMA/FAI#</th>
	<th width="5%" align="left" nowrap>FAI License</th>
	<th align="left">Pilot Class</th>
	<th align="left">Pilot Plane</th>
	<th align="left">Pilot Freq</th>
	{if $event->info['event_reg_teams'] == 1 || $event->info['event_use_teams'] == 1}
		<th align="left">Event Team</th>
	{/if}
	{if $event->info.event_reg_flag==1}
		<th align="right">Reg Status</th>
	{/if}
	<th align="left" width="4%"></th>
</tr>
{if $event->pilots|count >0}
	{assign var=num value=1}
	{foreach $event->pilots as $p}
	<tr>
		<td>{$num}</td>
		<td width="1%" nowrap>
			{if $p.country_code}<img src="/images/flags/countries-iso/shiny/16/{$p.country_code|escape}.png" class="inline_flag" title="{$p.country_code}">{else}<img src="/images/1x1.png" width="16" style="display:inline;">{/if}
			{if $p.state_name && $p.country_code=="US"}<img src="/images/flags/states/16/{$p.state_name|replace:' ':'-'}-Flag-16.png" class="inline_flag" title="{$p.state_name}">{else}<img src="/images/1x1.png" width="16" style="display:inline;">{/if}
		</td>
		<td{if $p.event_pilot_draw_status==0} bgcolor="lightgrey"{/if}>
			{if $p.event_pilot_bib!='' && $p.event_pilot_bib!=0}
				<div class="pilot_bib_number">{$p.event_pilot_bib}</div>
			{/if}
			&nbsp;{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}
		</td>
		<td align="left" nowrap>
			{if $p.pilot_fai}
				{$p.pilot_fai|escape}
			{else}
				{$p.pilot_ama|escape}
			{/if}
		</td>
		<td align="left" nowrap>
			{$p.pilot_fai_license|escape}
		</td>
		<td>{$p.class_description|escape}</td>
		<td>{$p.plane_name|escape}</td>
		<td>{$p.event_pilot_freq|escape}</td>
		{if $event->info.event_reg_teams == 1 || $event->info['event_use_teams'] == 1}
			<td>
				{if $user_is_event_admin==1}
					<input id="team_name_{$p.event_pilot_id}" name="team_name_{$p.event_pilot_id}" value="{$p.event_pilot_team|escape}" onChange="save_team_field(this);">
				{else}
					{$p.event_pilot_team|escape}
				{/if}
			</td>
		{/if}
		{if $event->info.event_reg_flag==1}
			<td align="right">
				{if $p.event_pilot_paid_flag==1}
				<font color="green">PAID</font>
				{else}
				<font color="red">DUE</font>
				{/if}
			</td>
		{/if}
		<td nowrap>
			{if $user.user_id!=0 && ($permission==1 || $user.user_admin==1)}		
				<a href="?action=event&function=event_pilot_edit&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Edit Event Pilot"><img width="16" src="/images/icon_edit_small.gif"></a>
				<a href="/?action=event&function=event_pilot_remove&event_id={$event->info.event_id}&event_pilot_id={$p.event_pilot_id}" title="Remove Event Pilot" onClick="return confirm('Are you sure you want to remove {$p.pilot_first_name|escape} from the event?');"><img width="14px" src="/images/del.gif"></a>
			{/if}
		</td>
	</tr>
	{assign var=num value=$num+1}
	{/foreach}
{else}
	<tr>
		<td colspan="8">Currently no pilots registered for this event.</td>
	</tr>
{/if}
</table>
