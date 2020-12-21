{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Message Center for {$user.pilot_first_name|escape} {$user.pilot_last_name|escape}</h2>
	</div>
	<div class="panel-body">
		<p>

			<h2 class="heading">Message View</h2>
			<form method="POST" name="main" enctype="multipart/form-data">
			<input type="hidden" name="action" value="message">
			<input type="hidden" name="function" value="message_save">
			<input type="hidden" name="user_message_id" value="{$user_message.user_message_id|escape}">
			<input type="hidden" name="to_user_id" value="{$user_message.to_user_id|escape}">
			<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
			<tr>
				<th width="20%" align="right">Message From</th>
				<td>
					{if $user_message.user_message_id!=0}
						<a href="?action=pilot&function=pilot_view&pilot_id={$user_message.pilot_id|escape}" class="btn-link">{$user_message.from.user_first_name|escape} {$user_message.from.user_last_name|escape}</a>
					{else}
						{$user.user_first_name|escape} {$user.user_last_name|escape}
					{/if}
				</td>
			</tr>
			<tr>
				<th align="right">Message To</th>
				<td>
					{if $user_message.user_message_id!=0}
						{$user_message.to.user_first_name|escape} {$user_message.to.user_last_name|escape}
					{else}
						<input type="text" id="user_name" name="user_name" size="40" value="{if $user_message.to.user_first_name!=''}{$user_message.to.user_first_name|escape} {$user_message.to.user_last_name|escape}{/if}">
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
						<pre style="white-space: pre-wrap;">{$user_message.user_message_text|escape}</pre>
					{else}
						<textarea cols="80" rows="20" name="user_message_text">{$user_message.user_message_text|escape}</textarea>
					{/if}
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="button" value=" Back To Message List " onclick="document.goback.submit();" class="btn btn-primary btn-rounded">
					{if $user_message.user_message_id==0}
						<input type="button" value=" Send This Message " onclick="document.main.submit();" class="btn btn-primary btn-rounded">
					{else}
						<input type="button" value=" Reply To This Message " onclick="document.replyto.submit();" class="btn btn-primary btn-rounded">
					{/if}
				</td>
			</tr>
			</table>
			</form>

		</p>
	</div>
</div>

 
<form name="goback" method="GET">
<input type="hidden" name="action" value="message">
<input type="hidden" name="function" value="message_list">
</form>
<form name="replyto" method="GET">
<input type="hidden" name="action" value="message">
<input type="hidden" name="function" value="message_edit">
<input type="hidden" name="user_message_id" value="{$user_message.user_message_id|escape}">
<input type="hidden" name="reply" value="1">
</form>

{/block}

{block name="footer"}
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
{/block}