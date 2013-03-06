<script src="/f3x/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/f3x/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#club_user_name").autocomplete({
		source: "/f3x/lookup.php?function=lookup_pilot",
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
			document.club_user.pilot_id.value = ui.item.id;
		},
   		change: function( event, ui ) {
   			if(document.club_user.club_user_name.value==''){
				document.club_user.pilot_id.value = 0;
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
		<h1 class="post-title entry-title">RC Club Edit</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Edit Basic Club Parameters</h1>
<form name="main" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_save">
<input type="hidden" name="club_id" value="{$club.club_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th>Club Name</th>
	<td>
		<input type="text" size="60" name="club_name" value="{$club.club_name}">
	</td>
</tr>
<tr>
	<th>Club City</th>
	<td>
		<input type="text" size="60" name="club_city" value="{$club.club_city}">
	</td>
</tr>
<tr>
	<th>Club State</th>
	<td>
	<select name="state_id">
	{foreach $states as $s}
		<option value="{$s.state_id}" {if $club.state_id==$s.state_id}SELECTED{/if}>{$s.state_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Club Country</th>
	<td>
	<select name="country_id">
	{foreach $countries as $c}
		<option value="{$c.country_id}" {if $club.country_id==$c.country_id}SELECTED{/if}>{$c.country_name}</option>
	{/foreach}
	</select>
	</td>
</tr>
<tr>
	<th>Club Charter Date</th>
	<td>
	{html_select_date prefix="club_charter_date" start_year="-50" day_format="%02d" time=$club.club_charter_date}
	</td>
</tr>
<tr>
	<th>Club Web URL</th>
	<td>
		<input type="text" size="60" name="club_url" value="{$club.club_url}">
	</td>
</tr>
<tr>
	<th colspan="3" style="text-align: center;">
		<input type="button" value=" Back To Club View " onClick="goback.submit();" class="block-button">
		<input type="submit" value=" Save This Club " class="block-button">
	</th>
</tr>
</table>
</form>

{if $club.club_id!=0}

<h1 class="post-title entry-title">Edit Club Access</h1>
<form name="club_user" method="POST">
<input type="hidden" name="action" value="club">
<input type="hidden" name="function" value="club_user_save">
<input type="hidden" name="club_id" value="{$club.club_id}">
<input type="hidden" name="pilot_id" value="">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th colspan="2" align="left">The Following Users Have Access To Edit This Club</th>
</tr>
{foreach $club_users as $u}
<tr>
	<td>{$u.pilot_first_name} {$u.pilot_last_name} - {$u.pilot_city}, {$u.state_code} {$u.country_code}</td>
	<td width="2%">
		<a href="?action=club&function=club_user_delete&club_id={$club.club_id}&club_user_id={$u.club_user_id}"><img src="/f3x/images/del.gif"></a></td>
</tr>
{/foreach}
<tr>
	<th colspan="2">
		Add New User 
		<input type="text" id="club_user_name" name="club_user_name" size="40">
		<img id="loading_user" src="/f3x/images/loading.gif" style="vertical-align: middle;display: none;">
		<span id="user_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
		<input type="submit" value=" Add This User " class="block-button">
	</th>
</tr>

</table>
</form>
{/if}
<form name="goback" method="POST">
<input type="hidden" name="action" value="club">
{if $club.club_id==0}
<input type="hidden" name="function" value="club_list">
{else}
<input type="hidden" name="function" value="club_view">
<input type="hidden" name="club_id" value="{$club.club_id}">
{/if}
</form>

</div>
</div>
</div>

