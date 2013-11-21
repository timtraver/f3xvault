<div id="post-1" class="post-1 post type-post status-publish format-standard hentry category-uncategorized clearfix post">
	<div class="entry clearfix">
		<h2 class="post-title entry-title">F3X Vault Admin area !</h2>
				<div class="entry-content clearfix">
				<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
				<tr class="table-row-heading-left">
					<th colspan="5">System Emails</th>
				</tr>
				<tr>
					<th width="10%">Email Name</th>
					<th width="30%">Email From</th>
					<th>Email Subject</th>
					<th>Email Send Test</th>
				</tr>
				{foreach $emails as $e}
				<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
					<td>{$e.email_name}</td>
					<td>{$e.email_from_name} {$e.email_from_address}</td>
					<td><a href="?action=admin&function=admin_email_edit&email_id={$e.email_id}">{$e.email_subject}</a></td>
					<td>
					<input type="button" value="Send Email To All" class="button"
					 onClick="document.sendmail_all.email_name.value='{$e.email_name}';document.sendmail_all.submit();">
					<input type="button" value="Send Email Test" class="button"
					 onClick="var sendto=prompt('Enter the email address to send to :','');document.sendmail_one.email_to.value=sendto;document.sendmail_one.email_name.value='{$e.email_name}';if(sendto!=null) document.sendmail_one.submit();">
					</td>
				</tr>
				{/foreach}
				<tr>
					<td colspan="5" class="table-data-heading-center">
					<input type="button" value=" Go Back " onclick="document.goback.submit();" class="button">
					<input type="button" value=" Create New Email " onclick="document.newmail.submit();" class="button">
					</td>
				</tr>
				</table>

				</div>
	</div>
</div>

<form name="goback" method="GET">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_view">
</form>
<form name="newmail" method="POST">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_email_edit">
<input type="hidden" name="email_id" value="0">
</form>

<form name="sendmail_one" method="POST">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_email_send_test">
<input type="hidden" name="email_name" value="{$e.email_name}">
<input type="hidden" name="email_to" value="">
</form>
<form name="sendmail_all" method="POST">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_email_send_all">
<input type="hidden" name="email_name" value="{$e.email_name}">
</form>
