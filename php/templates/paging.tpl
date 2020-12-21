{if $label == ''}
	{$label = 'main'}
{/if}
<div class="pull-right pagination">
	<ul class="pagination">
		<li>
			<span class="btn-group dropdown">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" style="height:19px;">
					<span class="page-size" style="height:17px;">{$paging.$label.perpage|escape}</span> <span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu">
					<li{if $perpage == 10} class="active"{/if}><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&perpage=10">10</a></li>
					<li{if $perpage == 25} class="active"{/if}><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&perpage=25">25</a></li>
					<li{if $perpage == 50} class="active"{/if}><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&perpage=50">50</a></li>
					<li{if $perpage == 100} class="active"{/if}><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&perpage=100">100</a></li>
					<li{if $perpage == 500} class="active"{/if}><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&perpage=500">500</a></li>
					<li{if $perpage == 1000} class="active"{/if}><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&perpage=1000">1000</a></li>
				</ul>
			</span>
		</li>
		<li class="page-first {if $paging.$label.startrecord<=1}disabled{/if}"><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&page=1">&lt;&lt;</a></li>
		<li class="page-pre {if $paging.$label.startrecord<=1}disabled{/if}"><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&page={$paging.$label.prevpage|escape:"url"}">&lt;</a></li>
		<li class="page-number active"><a href="javascript:void(0)">{$paging.$label.page|escape:"url"}</a></li>
		<li class="page-next{if $paging.$label.endrecord>=$paging.$label.totalrecords} disabled{/if}"><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&page={$paging.$label.nextpage|escape:"url"}">&gt;</a></li>
		<li class="page-last{if $paging.$label.endrecord>=$paging.$label.totalrecords} disabled{/if}"><a href="?{$paging.$label.callback|escape:"url"}&tab={$tab|escape:"url"}&page={$paging.$label.totalpages|escape:"url"}">&gt;&gt;</a></li>
	</ul>
</div>
