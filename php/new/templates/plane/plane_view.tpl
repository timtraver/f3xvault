{extends file='layout_main.tpl'}

{block name="header"}
<script type="text/javascript">
function calc_wingspan(){ldelim}
	var current_units = '{$plane.plane_wingspan_units}';
	var current_value = {$plane.plane_wingspan};
	var multiple = 2.54;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'in' || current_units == ''){ldelim}
		calc_value = multiple * current_value;
		calc_units = 'cm';
	{rdelim}else{ldelim}
		calc_value = current_value / multiple;
		calc_units = 'in';
	{rdelim}
	document.getElementById('wingspan').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
{rdelim}
function calc_aspect(){ldelim}
	var length={$plane.plane_wingspan};
	var area={$plane.plane_wing_area};
	if('{$plane.plane_wing_area_units}'=='dm2'){ldelim}
		area=area*100;
	{rdelim}
	var calc_aspect=0;
	if(area!=0 && length!=0){ldelim}
		calc_aspect = (length*length) / area;
	{rdelim}
	document.getElementById('aspect').innerHTML = calc_aspect.toFixed(2);
{rdelim}
function calc_length(){ldelim}
	var current_units = '{$plane.plane_length_units}';
	var current_value = {$plane.plane_length};
	var multiple = 2.54;
	var calc_value = 0;
	var calc_units = '';
	if(current_units == 'in' || current_units == ''){ldelim}
		calc_value = multiple * current_value;
		calc_units = 'cm';
	{rdelim}else{ldelim}
		calc_value = current_value / multiple;
		calc_units = 'in';
	{rdelim}
	document.getElementById('length').innerHTML = ' = ' + calc_value.toFixed(2) + ' ' + calc_units;
{rdelim}
function calc_auw(){ldelim}
	var current_units = '{$plane.plane_auw_units}';
	var current_from_value = {$plane.plane_auw_from};
	var current_to_value = {$plane.plane_auw_to};
	var multiple = 28.35;
	var calc_from_value = 0;
	var calc_to_value = 0;
	var calc_units = '';
	if(current_units == 'oz' || current_units == ''){ldelim}
		calc_from_value = multiple * current_from_value;
		calc_to_value = multiple * current_to_value;
		calc_units = 'gr';
	{rdelim}else{ldelim}
		calc_from_value = current_from_value / multiple;
		calc_to_value = current_to_value / multiple;
		calc_units = 'oz';
	{rdelim}
	document.getElementById('auwrange').innerHTML = '  =  ' + calc_from_value.toFixed(2) + ' To ' + calc_to_value.toFixed(2) + ' ' + calc_units;
{rdelim}
function calc_max_weight(){ldelim}
	var current_units = '{$plane.plane_wing_area_units}';
	var current_value = {$plane.plane_wing_area + $plane.plane_tail_area};
	var multiple = 28.35;
	var calc_value = 0;
	var calc_to = 0;
	var calc_units = '';
	var calc_to_units = '';
	if(current_units == 'in2' || current_units == ''){ldelim}
		calc_value = 0.17 * current_value;
		calc_units = 'oz';
		calc_to = multiple * calc_value;
		calc_to_units = 'gr';
	{rdelim}else{ldelim}
		calc_value = 75 * current_value;
		calc_units = 'gr';
		calc_to = calc_value / multiple;
		calc_to_units = 'oz';
	{rdelim}
	document.getElementById('max_weight').innerHTML = calc_value.toFixed(2) + ' ' + calc_units + ' = ' + calc_to.toFixed(2) + ' ' + calc_to_units;
{rdelim}
function calc_area(){ldelim}
	var current_units = '{$plane.plane_wing_area_units}';
	var current_wing_value = {$plane.plane_wing_area};
	var current_tail_value = {$plane.plane_tail_area};
	var multiple = .0645;
	var calc_wing_value = 0;
	var calc_tail_value = 0;
	var calc_total_value = 0;
	var calc_units = '';
	if(current_units == 'in2' || current_units == ''){ldelim}
		calc_wing_value = multiple * current_wing_value;
		calc_tail_value = multiple * current_tail_value;
		calc_total_value = calc_wing_value +  calc_tail_value;
		current_units = 'in<sup>2</sup>';
		calc_units = 'dm<sup>2</sup>';
	{rdelim}else{ldelim}
		calc_wing_value = current_wing_value / multiple;
		calc_tail_value = current_tail_value / multiple;
		calc_total_value = calc_wing_value +  calc_tail_value;
		current_units = 'dm<sup>2</sup>';
		calc_units = 'in<sup>2</sup>';
	{rdelim}
	var totalarea = (current_wing_value*1) + (current_tail_value*1);
	document.getElementById('wingarea').innerHTML = ' = ' + calc_wing_value.toFixed(2) + ' ' + calc_units;
	document.getElementById('tailarea').innerHTML = ' = ' + calc_tail_value.toFixed(2) + ' ' + calc_units;
	document.getElementById('totalarea').innerHTML = totalarea.toFixed(2) + ' ' + current_units + ' = ' + calc_total_value.toFixed(2) + ' ' + calc_units;
{rdelim}
</script>

{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Plane Details - {$plane.plane_name|escape}</h2>
	</div>
	<div class="panel-body" style="background-color:#337ab7;">
		<p>
			<div class="tab-base">
				<ul class="nav nav-tabs">
					<li{if $tab==0} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-1" aria-expanded="true" {if $tab==0}aria-selected="true"{/if}>
							Information
						</a>
					</li>
					<li{if $tab==1} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-2" aria-expanded="false" {if $tab==1}aria-selected="true"{/if}>
							Media
							<span class="badge badge-blue">{$media|count}</span>
						</a>
					</li>
					<li{if $tab==2} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-3" aria-expanded="false" {if $tab==2}aria-selected="true"{/if}>
							Comments
							<span class="badge badge-blue">{$comments|count}</span>
						</a>
					</li>
					<li{if $tab==3} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-4" aria-expanded="true" {if $tab==3}aria-selected="true"{/if}>
							Competitions
							<span class="badge badge-blue">{$totalrecords}</span>
						</a>
					</li>
					{if $f3f_records}
					<li{if $tab==4} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-5" aria-expanded="true" {if $tab==4}aria-selected="true"{/if}>
							F3F Speed
							<span class="badge badge-blue">{$f3f_records|count}</span>
						</a>
					</li>
					{/if}
					{if $f3b_records}
					<li{if $tab==4} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-5" aria-expanded="true" {if $tab==4}aria-selected="true"{/if}>
							F3B Speed
							<span class="badge badge-blue">{$f3b_records|count}</span>
						</a>
					</li>
					{/if}
					{if $f3b_distance}
					<li{if $tab==4} class="active"{/if}>
						<a data-toggle="tab" href="#location-tab-5" aria-expanded="true" {if $tab==4}aria-selected="true"{/if}>
							F3B Distance
							<span class="badge badge-blue">{$f3b_distance|count}</span>
						</a>
					</li>
					{/if}
				</ul>
				<div class="tab-content">
					<div id="location-tab-1" class="tab-pane fade{if $tab==0} active in{/if}">
						<h2 style="float:left;">Plane Information</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Edit Plane Information " class="btn btn-primary btn-rounded" onClick="plane_edit.submit();">
							<input type="button" value=" Back To Plane List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
						<tr>
							<th width="30%" align="left">Plane Name</th>
							<td>{$plane.plane_name|escape}</td>
						</tr>
						<tr>
							<th align="left" valign="top">Plane Flying Disciplines</th>
							<td>
								{$calc_max=0}
								{foreach $disciplines as $d}
								{$d.discipline_description}<br>
								{if $d.discipline_code=='f3b' || $d.discipline_code=='f3f' || $d.discipline_code=='f3j'}
									{$calc_max=1}
								{/if} 
								{/foreach}
							</td>
						</tr>
						<tr>
							<th align="left">Plane Wingspan</th>
							<td>
								{$plane.plane_wingspan|string_format:'%.1f'} {$plane.plane_wingspan_units|escape}
								<span id="wingspan"></span>
							</td>
						</tr>
						<tr>
							<th align="left">Plane Length</th>
							<td>
								{$plane.plane_length|string_format:'%.1f'} {$plane.plane_length_units|escape}
								<span id="length"></span>		
							</td>
						</tr>
						<tr>
							<th align="left">Plane Root Chord Length</th>
							<td>
								{$plane.plane_root_chord_length|string_format:'%.1f'} {$plane.plane_wingspan_units|escape}
								<span id="length"></span>		
							</td>
						</tr>
						<tr>
							<th align="left">Plane Aspect Ratio</th>
							<td bgcolor="lightgrey">
								<span id="aspect"></span>
							</td>
						</tr>
						<tr>
							<th align="left">Plane AUW Range (Empty)</th>
							<td>
								{$plane.plane_auw_from|string_format:'%.1f'} To {$plane.plane_auw_to|string_format:'%.1f'} {$plane.plane_auw_units|escape}
								<span id="auwrange"></span>
							</td>
						</tr>
						<tr>
							<th align="left">Plane Wing Area</th>
							<td>
								{$plane.plane_wing_area|string_format:'%.2f'} {if $plane.plane_wing_area_units == 'in2'}in<sup>2</sup>{else}dm<sup>2</sup>{/if}
								<span id="wingarea"></span>		
							</td>
						</tr>
						<tr>
							<th align="left">Plane Tail Area</th>
							<td>
								{$plane.plane_tail_area|string_format:'%.2f'} {if $plane.plane_wing_area_units == 'in2'}in<sup>2</sup>{else}dm<sup>2</sup>{/if}
								<span id="tailarea"></span>		
							</td>
						</tr>
						<tr>
							<th align="left">Plane Total Area</th>
							<td bgcolor="lightgrey">
								<span id="totalarea"></span>
							</td>
						</tr>
						{if $calc_max}
						<tr>
							<th align="left">FAI Max Wing Loading (By Rule For Class)</th>
							<td bgcolor="lightgrey">
								{if $plane.plane_wing_area_units == 'in2'}
									0.17 oz/in<sup>2</sup> = 75 g/dm<sup>2</sup>
								{else}
									75 g/dm<sup>2</sup> = 0.17 oz/in<sup>2</sup>
								{/if}
							</td>
						</tr>
						<tr>
							<th align="left">Maximum FAI Weight</th>
							<td bgcolor="lightgrey">
							<span id="max_weight"></span>
							</td>
						</tr>
						{/if}
						<tr>
							<th align="left">Plane Manufacturer</th>
							<td>{$plane.plane_manufacturer|escape}</td>
						</tr>
						<tr>
							<th align="left">Manufacturer Country</th>
							<td>
								{if $plane.country_code}<img src="/images/flags/countries-iso/shiny/24/{$plane.country_code|escape}.png" style="vertical-align: middle;">{/if}
								{$plane.country_name|escape}
							</td>
						</tr>
						<tr>
							<th align="left">Manufacturer Year</th>
							<td>{$plane.plane_year|escape}</td>
						</tr>
						<tr>
							<th align="left">Manufacturer Web Site</th>
							<td><a href="{$plane.plane_website|escape}" target="_blank">{$plane.plane_website|escape}</a></td>
						</tr>
						<tr>
							<th valign="top" nowrap>Plane Attributes</th>
							<td colspan="3">
								{if $plane_attributes}
								<table cellspacing="2" cellpadding="2" class="table table-condensed">
								{assign var='cat' value=''}
								{assign var='row' value='0'}
								{foreach $plane_attributes as $pa name="pas"}
									{if $pa.plane_att_cat_name != $cat}
										{if $pa.plane_att_cat_name != ''}
											{if $row != 0}
											</td></tr>
											{/if}
										{/if}
										<tr style="border-style: none;">
											<th width="20%" nowrap><b>{$pa.plane_att_cat_name}</b></th> 
										{assign var='row' value='1'}
									{else}
										<th></th>
									{/if}
									{if $pa.plane_att_type == 'boolean'}
										<td><span title="{$pa.plane_att_description|escape}">{$pa.plane_att_name|escape}</span></td>
									{else}
										<td><span title="{$pa.plane_att_description|escape}">{$pa.plane_att_name|escape}</span> <input type="text" name="plane_att_{$la.plane_att_id}" size="{$pa.plane_att_size}" value="{$pa.plane_att_value_value|escape}"></td>
									{/if}
										</tr>
									{assign var='cat' value=$pa.plane_att_cat_name}
								{/foreach}
								</table>
								{else}
								This information has not been entered for this plane.<br>
								Help us out and enter it!
								{/if}
							</td>
						</tr>
</table>
					</div>
					<div id="location-tab-2" class="tab-pane fade{if $tab==1} active in{/if}">
						<h2 style="float:left;">Plane Media</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Add New Plane Media " class="btn btn-primary btn-rounded" onClick="add_media.submit();">
							<input type="button" value=" Back To Plane List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						{if $media}
						<div id="media-carousel" class="carousel slide" data-ride="carousel">
							<ol class="carousel-indicators dark out">
								{foreach $media as $m}
								<li class="{if $m@index == 0}active{/if}" data-slide-to="{$m@index}" data-target="#media-carousel"></li>
								{/foreach}
							</ol>
							<div class="carousel-inner">
								{foreach $media as $m}
								<div class="item{if $m@index == 0} active{/if}">
									<center>
									{if $m.location_media_type == 'picture'}
										<img src="{$m.location_media_url}"><br>
									{else}
										<div class="video-wrapper">
											<div class="video-container">
												<iframe src="{$m.location_media_url}" width="640" height="360" frameborder="0" allowfullscreen></iframe>
											</div>
										</div>
									{/if}
									<br>
									<br>
									{if $m.user_id!=0}
										{$m.pilot_first_name|escape}, {$m.pilot_city|escape}<br>
									{/if}
									{$m.location_media_caption|escape}
									</center>
								</div>
								{/foreach}
								<a class="carousel-control left" data-slide="prev" href="#media-carousel"><i class="fa fa-chevron-left fa-2x"></i></a>
								<a class="carousel-control right" data-slide="next" href="#media-carousel"><i class="fa fa-chevron-right fa-2x"></i></a>
							</div>
						</div>
						{else}
						Currently No Media for this Plane
						{/if}
												
						<form name="add_media" method="GET">
						<input type="hidden" name="action" value="plane">
						<input type="hidden" name="function" value="plane_media_edit">
						<input type="hidden" name="plane_id" value="{$plane.plane_id}">
						</form>
						
					</div>
					<div id="location-tab-3" class="tab-pane fade{if $tab==2} active in{/if}">
						<h2>Plane Comments</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Add Comment " class="btn btn-primary btn-rounded" onClick="addcomment.submit();">
							<input type="button" value=" Back To Location List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						
						<h4 class="comments gutter-left current">{$comments_num} Plane Comments</h4>
							{foreach $comments as $c}
							<div class="panel panel-primary">
					
								<!--Panel heading-->
								<div class="panel-heading">
									<div class="panel-control">
										<em class="text-muted"><small>{$c.location_comment_date|date_format:"%B %e, %Y - %I:%M %p"}</small></em>
									</div>
									<h4 class="panel-title">{$c.user_first_name|escape} {$c.user_last_name|escape}</h4>
								</div>
								<!--Panel body-->
								<div class="panel-body">
									<p>{$c.location_comment_string|escape}</p>
								</div>
							</div>
							{/foreach}
						
					</div>
					<div id="location-tab-4" class="tab-pane fade{if $tab==3} active in{/if}">
						<h2>Plane Competitions</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Add Comment " class="btn btn-primary btn-rounded" onClick="addcomment.submit();">
							<input type="button" value=" Back To Location List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						
						<h4 class="comments gutter-left current">{$comments_num} Plane Competitions</h4>
						
						
						
						
						
						
					</div>
					{if $f3f_records}
					<div id="location-tab-5" class="tab-pane fade{if $tab==4} active in{/if}">
						<h2>Top F3F Speeds ({$startrecord} - {$endrecord})</h2>
						<div style="float:right;overflow:hidden;">
							<input type="button" value=" Add Comment " class="btn btn-primary btn-rounded" onClick="addcomment.submit();">
							<input type="button" value=" Back To Location List " onClick="document.goback.submit();" class="btn btn-primary btn-rounded">
						</div>
						<br style="clear:left;">
						
						<h4 class="comments gutter-left current">{$comments_num} Plane F3F Times</h4>
						
						<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
						<tr>
							<th style="text-align: left;"></th>
							<th style="text-align: left;">Event Date</th>
							<th style="text-align: left;">Pilot</th>
							<th style="text-align: left;">Plane</th>
							<th style="text-align: left;">Event Name</th>
							<th style="text-align: left;">Location</th>
							<th style="text-align: left;">Speed</th>
						</tr>
						{$rank=$startrecord}
						{$last=0}
						{foreach $f3f_records as $f}
							<tr>
								<td align="right">
									{if $f.event_pilot_round_flight_seconds!=$last}
										{$rank}
									{/if}
								</td>
								<td>{$f.event_start_date|date_format:"Y-m-d"}</td>
								<td>
									{if $f.pilot_country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.pilot_country_code|escape}.png" style="vertical-align: middle;" title="{$f.pilot_country_code}">{/if}
									<a href="?action=pilot&function=pilot_view&pilot_id={$f.record_pilot_id}">{$f.pilot_first_name} {$f.pilot_last_name}</a>
								</td>
								<td><a href="?action=plane&function=plane_view&plane_id={$f.plane_id}" title="View This Plane">{$f.plane_name|escape}</a></td>
								<td><a href="?action=event&function=event_view&event_id={$f.event_id}" title="View This Event">{$f.event_name|escape}</a></td>
								<td>
									{if $f.country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.country_code|escape}.png" style="vertical-align: middle;" title="{$f.country_code}">{/if}
									<a href="?action=location&function=location_view&location_id={$f.location_id}" title="View This Location">{$f.location_name|escape}</a>,
									{$f.country_code|escape}
								</td>
								<td align="right"><b>{$f.event_pilot_round_flight_seconds|string_format:"%03.2f"}</b></td>
							</tr>
							{$rank=$rank+1}
							{$last=$f.event_pilot_round_flight_seconds}
						{/foreach}
						<tr style="background-color: lightgray;">
						        <td align="left" colspan="3">
						                {if $page>1}[<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&page={$page-1}"> &lt;&lt; Prev Page</a>]{/if}
						                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&page={$page+1}">Next Page &gt;&gt</a>]
						        </td>
						        <td align="right" colspan="4">PerPage
						                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&perpage=20">20</a>]
						                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&perpage=40">40</a>]
						                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&perpage=60">60</a>]
						                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&page=1">First Page</a>]
						        </td>
						</tr>
						</table>

					</div>
					{/if}
				</div>
			</div>
		</p>



<form name="goback" method="GET">
<input type="hidden" name="action" value="plane">
</form>






{if $f3b_records}
<br>
<h1 class="post-title entry-title">Top F3B Speeds For This Model ({$startrecord} - {$endrecord})</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;"></th>
	<th style="text-align: left;">Event Date</th>
	<th style="text-align: left;">Pilot</th>
	<th style="text-align: left;">Plane</th>
	<th style="text-align: left;">Event Name</th>
	<th style="text-align: left;">Location</th>
	<th style="text-align: left;">Speed</th>
</tr>
{$rank=$startrecord}
{$last=0}
{foreach $f3b_records as $f}
	<tr bgcolor="{cycle values="white,lightgray"}">
		<td align="right" bgcolor="lightgrey">
			{if $f.event_pilot_round_flight_seconds!=$last}
				{$rank}
			{/if}
		</td>
		<td>{$f.event_start_date|date_format:"Y-m-d"}</td>
		<td>
			{if $f.pilot_country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.pilot_country_code|escape}.png" style="vertical-align: middle;" title="{$f.pilot_country_code}">{/if}
			<a href="?action=pilot&function=pilot_view&pilot_id={$f.record_pilot_id}">{$f.pilot_first_name} {$f.pilot_last_name}</a>
		</td>
		<td><a href="?action=plane&function=plane_view&plane_id={$f.plane_id}" title="View This Plane">{$f.plane_name|escape}</a></td>
		<td><a href="?action=event&function=event_view&event_id={$f.event_id}" title="View This Event">{$f.event_name|escape}</a></td>
		<td>
			{if $f.country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.country_code|escape}.png" style="vertical-align: middle;" title="{$f.country_code}">{/if}
			<a href="?action=location&function=location_view&location_id={$f.location_id}" title="View This Location">{$f.location_name|escape}</a>,
			{$f.country_code|escape}
		</td>
		<td align="right"><b>{$f.event_pilot_round_flight_seconds|string_format:"%03.2f"}</b></td>
	</tr>
	{$rank=$rank+1}
	{$last=$f.event_pilot_round_flight_seconds}
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $page>1}[<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&page={$page-1}"> &lt;&lt; Prev Page</a>]{/if}
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&page={$page+1}">Next Page &gt;&gt</a>]
        </td>
        <td align="right" colspan="4">PerPage
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&perpage=20">20</a>]
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&perpage=40">40</a>]
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&perpage=60">60</a>]
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&page=1">First Page</a>]
        </td>
</tr>
</table>
{/if}
{if $f3b_distance}
<br>
<h1 class="post-title entry-title">Top F3B Distance Runs ({$startrecord} - {$endrecord})</h1>
<table width="100%" cellpadding="2" cellspacing="1">
<tr>
	<th style="text-align: left;"></th>
	<th style="text-align: left;">Event Date</th>
	<th style="text-align: left;">Pilot</th>
	<th style="text-align: left;">Plane</th>
	<th style="text-align: left;">Event Name</th>
	<th style="text-align: left;">Location</th>
	<th style="text-align: left;">Laps</th>
</tr>
{$rank=$startrecord}
{$last=0}
{foreach $f3b_distance as $f}
	<tr bgcolor="{cycle values="white,lightgray"}">
		<td align="right" bgcolor="lightgrey">
			{if $f.event_pilot_round_flight_laps!=$last}
				{$rank}
			{/if}
		</td>
		<td>{$f.event_start_date|date_format:"Y-m-d"}</td>
		<td>
			{if $f.pilot_country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.pilot_country_code|escape}.png" style="vertical-align: middle;" title="{$f.pilot_country_code}">{/if}
			<a href="?action=pilot&function=pilot_view&pilot_id={$f.record_pilot_id}">{$f.pilot_first_name} {$f.pilot_last_name}</a>
		</td>
		<td><a href="?action=plane&function=plane_view&plane_id={$f.plane_id}" title="View This Plane">{$f.plane_name|escape}</a></td>
		<td><a href="?action=event&function=event_view&event_id={$f.event_id}" title="View This Event">{$f.event_name|escape}</a></td>
		<td>
			{if $f.country_code}<img src="/images/flags/countries-iso/shiny/16/{$f.country_code|escape}.png" style="vertical-align: middle;" title="{$f.country_code}">{/if}
			<a href="?action=location&function=location_view&location_id={$f.location_id}" title="View This Location">{$f.location_name|escape}</a>,
			{$f.country_code|escape}
		</td>
		<td align="right"><b>{$f.event_pilot_round_flight_laps}</b></td>
	</tr>
	{$rank=$rank+1}
	{$last=$f.event_pilot_round_flight_laps}
{/foreach}
<tr style="background-color: lightgray;">
        <td align="left" colspan="3">
                {if $page>1}[<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&page={$page-1}"> &lt;&lt; Prev Page</a>]{/if}
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&page={$page+1}">Next Page &gt;&gt</a>]
        </td>
        <td align="right" colspan="4">PerPage
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&perpage=20">20</a>]
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&perpage=40">40</a>]
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&perpage=60">60</a>]
                [<a href="?action=plane&function=plane_view&plane_id={$plane.plane_id}&page=1">First Page</a>]
        </td>
</tr>
</table>
{/if}




</div>
</div>


<form name="addcomment" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_comment_add">
<input type="hidden" name="plane_id" value="{$plane.plane_id}">
</form>
<form name="plane_edit" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_edit">
<input type="hidden" name="plane_id" value="{$plane.plane_id}">
</form>
<form name="add_media" method="GET">
<input type="hidden" name="action" value="plane">
<input type="hidden" name="function" value="plane_media_edit">
<input type="hidden" name="plane_id" value="{$plane.plane_id}">
</form>

{/block}

{block name="footer"}
<script type="text/javascript">
	calc_wingspan();
	calc_aspect();
	calc_length();
	calc_auw();
	calc_area();
	calc_max_weight();
</script>
{/block}