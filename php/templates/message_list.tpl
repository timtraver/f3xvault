<div id="post-1" class="post-1 post type-post status-publish format-standard hentry category-uncategorized clearfix post">
	<div class="entry clearfix">
		<h2 class="post-title entry-title">RC Vault Messaging Center</h2>
		<div class="entry-content clearfix">

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
{foreach $messages as $m}
<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
	<td><input type="checkbox" name="message_{$m.user_message_id}"></td>
	<td><a href="?action=message&function=message_edit&user_message_id={$m.user_message_id}">{$m.user_message_date}</a></td>
	<td>{$m.user_first_name|escape} {$m.user_last_name|escape}</td>
	<td>{$m.user_message_subject|escape}</td>
	<td>{if $m.user_message_read_status==0}Unread{else}Read{/if}</td>
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
		<input type="button" value=" Send A Message " onClick="document.goback.submit();" class="button">
		<input type="button" value=" Delete Selected Messages " onClick="document.goback.submit();" class="button">
	</td>
</tr>
</table>

<form name="goback" method="POST">
<input type="hidden" name="action" value="admin">
<input type="hidden" name="function" value="admin_view">
</form>


</div>
</div>
</div>

