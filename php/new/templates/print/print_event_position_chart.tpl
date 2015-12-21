{extends file='layout/layout_print.tpl'}

{block name="content"}

{include file='print/print_event_header_info.tpl'}

<div style="-webkit-print-color-adjust:exact;">

	<h2 class="post-title entry-title">Event Position Chart</h2>

	<div>
		<div id="chart_div" style="width: 900px;height: {30*$event->pilots|count}px;"></div>
	</div>
</div>
{/block}
{block name="footer"}
<script src="/includes/jquery-ui/ui/jquery.ui.core.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.widget.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.position.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.menu.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.dialog.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.button.js"></script>
<script src="/includes/jquery-ui/ui/jquery.ui.autocomplete.js"></script>
<script src="/includes/highcharts/js/highcharts.js"></script>
<script>
$(function () {ldelim} 
    $('#chart_div').highcharts({ldelim}
        chart: {ldelim}
            type: 'line'
        {rdelim},
        title: {ldelim}
            text: 'Position Movement Chart'
        {rdelim},
        xAxis: {ldelim}
            title: {ldelim}
            	text: 'Round'
        	{rdelim},
        	tickInterval: 1,
        	tickPixelInterval: 10
        {rdelim},
        yAxis: {ldelim}
            title: {ldelim}
                text: 'Overall Position'
            {rdelim},
            reversed: true,
            min: 1,
        	tickInterval: 1
        {rdelim},
        legend: {ldelim}
        	align: 'right',
        	verticalAlign: 'top',
        	layout: 'vertical',
        	y: 15,
        	itemMarginTop: 2
        {rdelim},
        series: [
        	{foreach $event->totals.pilots as $p}
        	{ldelim}
            name: '{$p.pilot_first_name} {$p.pilot_last_name}',
            data: [{foreach $p.rounds as $r}{if $r.event_round_score_status==0}{continue}{/if}[{$r@key},{$r.event_round_upto_rank}]{if !$r@last},{/if}{/foreach}]
        	{rdelim}{if !$p@last},{/if}
        	{/foreach}
       	]
    {rdelim});
{rdelim});
</script>

{/block}