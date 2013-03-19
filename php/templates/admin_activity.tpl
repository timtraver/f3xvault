<div id="post-1" class="post-1 post type-post status-publish format-standard hentry category-uncategorized clearfix post">
	<div class="entry clearfix">
		<h2 class="post-title entry-title">RC Vault Admin area !</h2>
		<div class="entry-content clearfix">

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr class="table-row-heading-left">
	<th colspan="6" style="text-align: left;">Site Activity (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
</tr>
<tr style="background-color: lightgray;">
        <td align="left" colspan="2">
                {if $startrecord>1}[<a href="?action=admin&function=admin_activity&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=admin&function=admin_activity&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=admin&function=admin_activity&&perpage=25">25</a>]
                [<a href="?action=admin&function=admin_activity&&perpage=50">50</a>]
                [<a href="?action=admin&function=admin_activity&&perpage=100">100</a>]
                [<a href="?action=admin&function=admin_activity&page=1">First Page</a>]
                [<a href="?action=admin&function=admin_activity&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<th style="text-align: left;">Date</th>
	<th style="text-align: left;">User Name</th>
	<th style="text-align: left;">User Action</th>
	<th style="text-align: left;">User Function</th>
	<th style="text-align: center;">ID</th>
</tr>
{foreach $entries as $e}
<tr bgcolor="{cycle values="#FFFFFF,#E8E8E8"}">
	<td>{$e.site_log_date}</td>
	<td>{$e.user_first_name|escape} {$e.user_last_name|escape}</td>
	<td>{$e.site_log_action|escape}</td>
	<td>{$e.site_log_function|escape}</td>
	<td>{$e.site_log_action_id|escape}</td>
</tr>
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="2">
                {if $startrecord>1}[<a href="?action=admin&function=admin_activity&page={$prevpage|escape}"> &lt;&lt; Prev Page</a>]{/if}
                {if $endrecord<$totalrecords}[<a href="?action=admin&function=admin_activity&page={$nextpage|escape}">Next Page &gt;&gt</a>]{/if}
        </td>
        <td align="right" colspan="3">PerPage
                [<a href="?action=admin&function=admin_activity&&perpage=25">25</a>]
                [<a href="?action=admin&function=admin_activity&&perpage=50">50</a>]
                [<a href="?action=admin&function=admin_activity&&perpage=100">100</a>]
                [<a href="?action=admin&function=admin_activity&page=1">First Page</a>]
                [<a href="?action=admin&function=admin_activity&page={$totalpages|escape}">Last Page</a>]
        </td>
</tr>
<tr>
	<td colspan="6" align="center">
		<input type="button" value=" Back " onClick="document.goback.submit();" class="button">
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

