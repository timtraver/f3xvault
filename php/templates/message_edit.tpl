<div id="post-1" class="post-1 post type-post status-publish format-standard hentry category-uncategorized clearfix post">
	<div class="entry clearfix">
		<h2 class="post-title entry-title">RC Vault Messaging Center</h2>
				<div class="entry-content clearfix">

				<h1>Message View</h1>
				<form method="POST" name="main" enctype="multipart/form-data">
				<input type="hidden" name="action" value="message">
				<input type="hidden" name="function" value="message_save">
				<input type="hidden" name="user_message_id" value="{$user_message.user_message_id}">
				<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
				<tr>
					<th class="table-data-heading-left">Message From</th>
					<td>
						{if $user_message.user_message_id!=0}
							<a href="?action=pilot&function=pilot_view&pilot_id={$user_message.pilot_id|escape}">{$user_message.user_first_name|escape} {$user_message.user_last_name|escape}</a>
						{else}
							{$user.user_first_name|escape} {$user.user_last_name|escape}
						{/if}
					</td>
				</tr>
				<tr>
					<th class="table-data-heading-left">Message To</th>
					<td>
						{if $user_message.user_message_id!=0}
							{$user.pilot_first_name} {$user.pilot_last_name}
						{else}
							<input type="text" size="40" name="user_message_to" value="">
						{/if}
					</td>
				</tr>
				<tr>
					<th class="table-data-heading-left">Message Subject</th>
					<td>
						{if $user_message.user_message_id!=0}
							{$user_message.user_message_subject|escape}
						{else}
							<input type="text" size="40" name="user_message_subject" value="{$user_message.user_message_subject|escape}">
						{/if}
					</td>
				</tr>
				<tr>
					<th class="table-data-heading-left">Message Content</th>
					<td>
						<textarea cols="80" rows="20" name="user_message_text">{$user_message.user_message_text}</textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="table-data-heading-center">
					<input type="button" value=" Go Back " onclick="document.goback.submit();" class="button">
					{if $user_message.user_message_id==0}
						<input type="button" value=" Send This Message " onclick="document.main.submit();" class="button">
					{/if}
					</td>
				</tr>
				</table>
				</form>


				</div>
	</div>
</div>

 
<form name="goback" method="GET">
<input type="hidden" name="action" value="message">
<input type="hidden" name="function" value="message_list">
</form>
