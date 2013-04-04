<script src="/includes/jquery.min.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#user_name").autocomplete({
		source: "/lookup.php?function=lookup_user",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.main.to_user_id.value = ui.item.id;
			var name=document.getElementById('user_name');
			document.main.user_name.value=name.value;
		},
   		change: function( event, ui ) {
   			var id=document.getElementById('user_name');
   			if(id.value==''){
				document.main.to_user_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading');
			loading.style.display = "none";
   			var mes=document.getElementById('search_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found.';
			}
		}
	});
});
</script>
{/literal}

<div id="post-1" class="post-1 post type-post status-publish format-standard hentry category-uncategorized clearfix post">
	<div class="entry clearfix">
		<h2 class="post-title entry-title">RC Vault Message Center</h2>
				<div class="entry-content clearfix">

				<h1>Message View</h1>
				<form method="POST" name="main" enctype="multipart/form-data">
				<input type="hidden" name="action" value="message">
				<input type="hidden" name="function" value="message_save">
				<input type="hidden" name="user_message_id" value="{$user_message.user_message_id}">
				<input type="hidden" name="to_user_id" value="{$user_message.to_user_id}">
				<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
				<tr>
					<th width="20%" align="right">Message From</th>
					<td>
						{if $user_message.user_message_id!=0}
							<a href="?action=pilot&function=pilot_view&pilot_id={$user_message.pilot_id|escape}">{$user_message.from.user_first_name|escape} {$user_message.from.user_last_name|escape}</a>
						{else}
							{$user.user_first_name|escape} {$user.user_last_name|escape}
						{/if}
					</td>
				</tr>
				<tr>
					<th align="right">Message To</th>
					<td>
						{if $user_message.user_message_id!=0}
							{$user_message.to.user_first_name} {$user_message.to.user_last_name}
						{else}
							<input type="text" id="user_name" name="user_name" size="40" value="{if $user_message.to.user_first_name!=''}{$user_message.to.user_first_name} {$user_message.to.user_last_name}{/if}">
		    				<img id="loading" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		    				<span id="search_message" style="font-style: italic;color: grey;"> Start typing to search users</span>
						{/if}
					</td>
				</tr>
				<tr>
					<th align="right">Message Subject</th>
					<td>
						{if $user_message.user_message_id!=0}
							{$user_message.user_message_subject|escape}
						{else}
							<input type="text" size="40" name="user_message_subject" value="{$user_message.user_message_subject|escape}">
						{/if}
					</td>
				</tr>
				<tr>
					<th align="right" valign="top">Message Content</th>
					<td>
						{if $user_message.user_message_id!=0}
							<pre style="white-space: pre-wrap;">{$user_message.user_message_text}</pre>
						{else}
							<textarea cols="80" rows="20" name="user_message_text">{$user_message.user_message_text}</textarea>
						{/if}
					</td>
				</tr>
				<tr>
					<td colspan="2" class="table-data-heading-center">
					<input type="button" value=" Go Back " onclick="document.goback.submit();" class="button">
					{if $user_message.user_message_id==0}
						<input type="button" value=" Send This Message " onclick="document.main.submit();" class="button">
					{else}
						<input type="button" value=" Reply To This Message " onclick="document.replyto.submit();" class="button">
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
<form name="replyto" method="GET">
<input type="hidden" name="action" value="message">
<input type="hidden" name="function" value="message_edit">
<input type="hidden" name="user_message_id" value="{$user_message.user_message_id}">
<input type="hidden" name="reply" value="1">
</form>
