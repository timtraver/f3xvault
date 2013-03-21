<div id="post-1" class="post-1 post type-post status-publish format-standard hentry category-uncategorized clearfix post">
	<div class="entry clearfix">
		<h2 class="post-title entry-title">RC Vault Messaging Center</h2>
		<div class="entry-content clearfix">
<form name="main" method="POST">
<input type="hidden" name="action" value="message">
<input type="hidden" name="function" value="message_delete">

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="6" style="text-align: left;">Messages (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="2">
                {if $startrecord>1}[<a href="?action=message&function=message_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=message&function=message_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=message&function=message_list&&perpage=25">25</a>]
                [<a href="?action=message&function=message_list&&perpage=50">50</a>]
                [<a href="?action=message&function=message_list&&perpage=100">100</a>]
                [<a href="?action=message&function=message_list&page=1">First Page</a>]
                [<a href="?action=message&function=message_list&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<th width="1%" style="text-align: left;"></th>
	<th width="15%" style="text-align: left;">Date</th>
	<th style="text-align: left;">From User Name</th>
	<th style="text-align: left;">Subject</th>
	<th style="text-align: center;">Status</th>
</tr>
{foreach $user_messages as $m}
<tr {if $m.user_message_read_status==0}style="background-color:#87CEFA;"{else}style="background-color:{cycle values="#FFFFFF,#E8E8E8"};"{/if}>
	<td><input type="checkbox" name="message_{$m.user_message_id}"></td>
	<td><a href="?action=message&function=message_edit&user_message_id={$m.user_message_id}">{$m.user_message_date}</a></td>
	<td><a href="?action=pilot&function=pilot_view&pilot_id={$m.pilot_id|escape}">{$m.user_first_name|escape} {$m.user_last_name|escape}</a></td>
	<td><a href="?action=message&function=message_edit&user_message_id={$m.user_message_id}">{$m.user_message_subject|escape}</a></td>
	<td align="center">{if $m.user_message_read_status==0}<b>Unread</b>{else}Read{/if}</td>
</tr>
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="2">
                {if $startrecord>1}[<a href="?action=message&function=message_list&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=message&function=message_list&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=message&function=message_list&&perpage=25">25</a>]
                [<a href="?action=message&function=message_list&&perpage=50">50</a>]
                [<a href="?action=message&function=message_list&&perpage=100">100</a>]
                [<a href="?action=message&function=message_list&page=1">First Page</a>]
                [<a href="?action=message&function=message_list&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<td colspan="6" align="left">
	<br>
		<input type="button" value=" Back " onClick="document.goback.submit();" class="button">
		<input type="button" value=" Send A Message " onClick="document.new_message.submit();" class="button">
		<input type="button" value=" Delete Selected Messages " onClick="document.main.submit();" class="button">
	</td>
</tr>
</table>
</form>
<form name="goback" method="POST">
<input type="hidden" name="action" value="main">
<input type="hidden" name="function" value="view_home">
</form>
<form name="new_message" method="POST">
<input type="hidden" name="action" value="message">
<input type="hidden" name="function" value="message_edit">
<input type="hidden" name="user_message_id" value="0">
</form>


</div>
</div>
</div>

