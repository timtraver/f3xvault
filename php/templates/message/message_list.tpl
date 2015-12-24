{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Message Center for {$user.pilot_first_name|escape} {$user.pilot_last_name|escape}</h2>
	</div>
	<div class="panel-body">
		<p>

		<form name="main" method="POST">
		<input type="hidden" name="action" value="message">
		<input type="hidden" name="function" value="message_delete">

		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr>
			<th colspan="3" style="text-align: left;" nowrap>
				Messages (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})
				<select name="message_box" onChange="document.view_list.message_box.value=document.main.message_box.value;view_list.submit();">
				<option value="incoming"{if $message_box=='incoming'} SELECTED{/if}>View Incoming Messages</option>
				<option value="sent"{if $message_box=='sent'} SELECTED{/if}>Sent Messages</option>
				</select>	
			</th>
			<th colspan="3" nowrap>
				{include file="paging.tpl"}
			</th>
		</tr>
		<tr>
			<th width="1%" style="text-align: left;"></th>
			<th width="15%" style="text-align: left;">Date</th>
			<th style="text-align: left;">
				{if $message_box=='incoming'}From{else}To{/if} User Name</th>
			<th style="text-align: left;">Subject</th>
			<th style="text-align: center;">Status</th>
		</tr>
		{foreach $user_messages as $m}
		<tr {if $m.user_message_read_status==0}style="background-color:#87CEFA;"{/if}>
			<td>
				<input type="checkbox" name="message_{$m.user_message_id}">
			</td>
			<td>
				<a href="?action=message&function=message_edit&user_message_id={$m.user_message_id}" class="btn-link">{$m.user_message_date}</a>
			</td>
			<td>
				<a href="?action=pilot&function=pilot_view&pilot_id={$m.pilot_id|escape}" class="btn-link">{$m.user_first_name|escape} {$m.user_last_name|escape}</a>
			</td>
			<td>
				<a href="?action=message&function=message_edit&user_message_id={$m.user_message_id}" class="btn-link">{$m.user_message_subject|escape}</a>
			</td>
			<td align="center">
				{if $m.user_message_read_status==0}<b>Unread</b>{else}Read{/if}
			</td>
		</tr>
		{/foreach}
		<tr>
			<th colspan="6" nowrap>
				{include file="paging.tpl"}
			</th>
		</tr>
		<tr>
			<td colspan="6" align="center">
				{if $message_box=='incoming'}
				<input type="button" value=" Delete Selected Messages " onClick="document.main.submit();" class="btn btn-primary btn-rounded">
				{/if}
				<input type="button" value=" Send A Message " onClick="document.new_message.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>
		</form>
		
		<form name="new_message" method="POST">
		<input type="hidden" name="action" value="message">
		<input type="hidden" name="function" value="message_edit">
		<input type="hidden" name="user_message_id" value="0">
		</form>
		<form name="view_list" method="POST">
		<input type="hidden" name="action" value="message">
		<input type="hidden" name="function" value="message_list">
		<input type="hidden" name="message_box" value="">
		</form>



		</p>
	</div>
</div>

{/block}
