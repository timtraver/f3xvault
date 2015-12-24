<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#series_user_name").autocomplete({
		source: "/lookup.php?function=lookup_user",
		minLength: 2, 
		highlightItem: true, 
        matchContains: true,
        autoFocus: true,
        scroll: true,
        scrollHeight: 300,
   		search: function( event, ui ) {
   			var loading=document.getElementById('loading_user');
			loading.style.display = "inline";
		},
   		select: function( event, ui ) {
			document.series_user.user_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.series_user.series_user_name.value==''){
				document.series_user.user_id.value = 0;
			}
		},
   		response: function( event, ui ) {
   			var loading=document.getElementById('loading_user');
			loading.style.display = "none";
   			var mes=document.getElementById('user_message');
			if(ui.content && ui.content.length){
				mes.innerHTML = ' Found ' + ui.content.length + ' results. Use Arrow keys to select';
			}else{
				mes.innerHTML = ' No Results Found. Use Add button to add new pilot.';
			}
		}
	});
});
</script>
{/literal}

<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">Event Series Edit</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Series Basic Parameters</h1>
<form name="main" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_save">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Series Name</th>
	<td>
		<input type="text" size="60" name="series_name" value="{$series->info.series_name|escape}">
	</td>
</tr>
<tr>
	<th>Series Area</th>
	<td>
		<input type="text" size="60" name="series_area" value="{$series->info.series_area|escape}">
	</td>
</tr>
<tr>
	<th>State</th>
	<td>
	<select name="state_id">
	{foreach $states as $s}
		<option value="{$s.state_id}" {if $series->info.state_id==$s.state_id}SELECTED{/if}>{$s.state_name|escape}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Country</th>
	<td>
	<select name="country_id">
	{foreach $countries as $c}
		<option value="{$c.country_id}" {if $series->info.country_id==$c.country_id}SELECTED{/if}>{$c.country_name|escape}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Series Web URL</th>
	<td>
		<input type="text" size="60" name="series_url" value="{$series->info.series_url}">
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value=" Back To Series View " onClick="goback.submit();" class="block-button">
		<input type="submit" value=" Save This Series{if $from} and Return{/if} " class="block-button">
	</th>
</tr>
</table>
{foreach $from as $f}
<input type="hidden" name="{$f.key}" value="{$f.value}">
{/foreach}
</form>

{if $series->info.series_id!=0}
<h1 class="post-title entry-title">Edit Series Parameters</h1>
<form name="event_options" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_param_save">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th colspan="2" align="left">The Following Specific Parameters Are for this series</th>
</tr>
{foreach $series->options as $o}
<tr>
	<th align="right" width="30%">{$o.series_option_type_name|escape} (<a href="#" title="{$o.series_option_type_description|escape}">?</a>)</th>
	<td>
		{if $o.series_option_type_type == 'boolean'}
			<select name="option_{$o.series_option_type_id}_{$o.series_option_id}">
			<option value="yes" {if $o.series_option_status==1 && $o.series_option_value ==1}SELECTED{/if}>Yes</option>
			<option value="no" {if $o.series_option_status==1 && $o.series_option_value ==0}SELECTED{/if}>No</option>
			</select>
		{else}
				<input type="text" name="option_{$o.series_option_type_id}_{$o.series_option_id}" size="{$o.series_option_type_size}" value="{$o.series_option_value|escape}"> 
		{/if}
	</td>
</tr>
{/foreach}
<tr>
	<th colspan="2">
		<input type="submit" value=" Save These Series Parameters " class="block-button">
		<input type="button" value=" Add Drop " class="block-button" onClick="var round=prompt('Enter Round for new drop :');if(round!=null && round!=''){ldelim}document.add_drop.drop_round.value=round;document.add_drop.submit();{rdelim}">
	</th>
</tr>

</table>
</form>

<h1 class="post-title entry-title">Edit Series Access</h1>
<form name="series_user" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_user_save">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
<input type="hidden" name="user_id" value="">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th colspan="2" align="left">The Following Users Have Access To Edit This Series</th>
</tr>
{foreach $series->access as $u}
<tr>
	<td>{$u.user_first_name|escape} {$u.user_last_name|escape}</td>
	<td width="2%">
		<a href="?action=series&function=series_user_delete&series_id={$series->info.series_id}&series_user_id={$u.series_user_id}"><img src="/images/del.gif"></a></td>
</tr>
{/foreach}
<tr>
	<th colspan="2">
		Add New User 
		<input type="text" id="series_user_name" name="series_user_name" size="40">
		<img id="loading_user" src="/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="user_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
		<input type="submit" value=" Add This User " class="block-button">
	</th>
</tr>

</table>
</form>
{/if}
<form name="goback" method="POST">
<input type="hidden" name="action" value="series">
{if $series->info.series_id==0}
<input type="hidden" name="function" value="series_list">
{else}
<input type="hidden" name="function" value="series_view">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
{/if}
</form>
<form name="add_drop" method="POST">
<input type="hidden" name="action" value="series">
<input type="hidden" name="function" value="series_option_add_drop">
<input type="hidden" name="series_id" value="{$series->info.series_id}">
<input type="hidden" name="drop_round" value="0">
</form>

</div>
</div>
</div>

