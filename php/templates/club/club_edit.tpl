{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel" style="min-width:1000px;">
	<div class="panel-heading">
		<h2 class="heading">Club View - {$club.club_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li class="active">
						<a href="?action=club&function=club_view&club_id={$club.club_id|escape:'url'}&tab=0" aria-expanded="true" aria-selected="true">
							Club Info
						</a>
					</li>
					<li>
						<a href="?action=club&function=club_view&club_id={$club.club_id|escape:'url'}&tab=1" aria-expanded="false">
							Club Locations
							<span class="badge badge-blue">{$club_locations|count}</span>
						</a>
					</li>
					<li>
						<a href="?action=club&function=club_view&club_id={$club.club_id|escape:'url'}&tab=2" aria-expanded="false">
							Club Members
							<span class="badge badge-blue">{$pilots|count}</span>
						</a>
					</li>
				</ul>
				<div class="tab-content">
					<div id="pilot-tab-0" class="tab-pane fade active in">
						<h2 style="float:left;">Edit Club General Info</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Back To Club List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">

						<form name="main" method="POST">
						<input type="hidden" name="action" value="club">
						<input type="hidden" name="function" value="club_save">
						<input type="hidden" name="club_id" value="{$club.club_id|escape}">
						
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
						<tr>
							<th width="20%" align="right">Club Name</th>
							<td>
								<input type="text" size="60" name="club_name" value="{$club.club_name|escape}">
							</td>
						</tr>
						<tr>
							<th width="20%" align="right">Club City</th>
							<td>
								<input type="text" size="60" name="club_city" value="{$club.club_city|escape}">
							</td>
						</tr>
						<tr>
							<th width="20%" align="right">Club State</th>
							<td>
								<select name="state_id">
								{foreach $states as $s}
									<option value="{$s.state_id|escape}" {if $club.state_id==$s.state_id}SELECTED{/if}>{$s.state_name|escape}</option>
								{/foreach}
								</select>
							</td>
						</tr>
						<tr>
							<th width="20%" align="right">Club Country</th>
							<td>
								<select name="country_id">
								{foreach $countries as $c}
									<option value="{$c.country_id|escape}" {if $club.country_id==$c.country_id}SELECTED{/if}>{$c.country_name|escape}</option>
								{/foreach}
								</select>
							</td>
						</tr>
						<tr>
							<th width="20%" align="right">Club Charter Date</th>
							<td>
								{html_select_date prefix="club_charter_date" start_year="-50" day_format="%02d" time=$club.club_charter_date}
							</td>
						</tr>
						<tr>
							<th>Club Web URL</th>
							<td>
								<input type="text" size="60" name="club_url" value="{$club.club_url|escape}">
							</td>
						</tr>
						</table>
						{foreach $from as $f}
						<input type="hidden" name="{$f.key}" value="{$f.value|escape}">
						{/foreach}
						<center>
							<input type="submit" value=" Save Club Info " class="btn btn-primary btn-rounded">
						</center>
						</form>
						
						{if $club.club_id!=0}
						
						<h2 class="post-title entry-title">Edit Club Access</h2>
						<form name="club_user" method="POST">
						<input type="hidden" name="action" value="club">
						<input type="hidden" name="function" value="club_user_save">
						<input type="hidden" name="club_id" value="{$club.club_id|escape}">
						<input type="hidden" name="pilot_id" value="">
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-bordered">
						<tr>
							<th colspan="2" align="left">The Following Users Have Access To Edit This Club</th>
						</tr>
						{foreach $club_users as $u}
						<tr>
							<td>{$u.pilot_first_name|escape} {$u.pilot_last_name|escape} - {$u.pilot_city|escape}, {$u.state_code|escape} {$u.country_code|escape}</td>
							<td width="2%">
								<a href="?action=club&function=club_user_delete&club_id={$club.club_id|escape:'url'}&club_user_id={$u.club_user_id|escape:'url'}"{if $user.user_id==0} onClick="alert('You must be logged in to use this function. Please create an account or log in to your existing account to proceed.');return false;"{/if}><img src="/images/del.gif"></a></td>
						</tr>
						{/foreach}
						<tr>
							<th colspan="2">
								Add New User 
								<input type="text" id="club_user_name" name="club_user_name" size="40">
								<img id="loading_user" src="/images/loading.gif" style="vertical-align: middle;display: none;">
								<span id="user_message" style="font-style: italic;color: grey;">Start typing to search pilots</span>
								<input type="submit" value=" Add This User " class="btn btn-primary btn-rounded">
							</th>
						</tr>
						
						</table>
						</form>
						{/if}
					</div>
					
					<form name="goback" method="POST">
					<input type="hidden" name="action" value="club">
					{if $club.club_id==0}
					<input type="hidden" name="function" value="club_list">
					{else}
					<input type="hidden" name="function" value="club_view">
					<input type="hidden" name="club_id" value="{$club.club_id|escape}">
					{/if}
					</form>
				</div>
			</div>
		</p>
	</div>
</div>

{/block}

{block name="footer"}
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script>
{literal}
$(function() {
	$("#club_user_name").autocomplete({
		source: "/lookup.php?function=lookup_pilot",
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
{/block}