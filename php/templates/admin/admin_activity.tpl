{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">

		<h2 class="post-title entry-title">Site Activity</h2>

		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr class="table-row-heading-left">
			<th colspan="6" style="text-align: left;">Site Activity (records {$startrecord|escape} - {$endrecord|escape} of {$totalrecords|escape})</th>
		</tr>
		<tr style="background-color: lightgray;">
			<td colspan="5">
				{include file="paging.tpl"}
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
			<td>{$e.site_log_date|escape}</td>
			<td>{$e.user_first_name|escape} {$e.user_last_name|escape}</td>
			<td>{$e.site_log_action|escape}</td>
			<td>{$e.site_log_function|escape}</td>
			<td>{$e.site_log_action_id|escape}</td>
		</tr>
		{/foreach}
		<tr style="background-color: lightgray;">
			<td colspan="5">
				{include file="paging.tpl"}
			</td>
		</tr>
		<tr>
			<td colspan="5" align="center">
				<input type="button" value=" Back " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
			</td>
		</tr>
		</table>

		<form name="goback" method="POST">
		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="function" value="admin_view">
		</form>


	</div>
</div>
{/block}
