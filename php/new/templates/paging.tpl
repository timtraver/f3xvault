<div class="pull-right pagination">
	<ul class="pagination">
		<li>
			<span class="btn-group dropdown">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" style="height:19px;">
					<span class="page-size" style="height:17px;">{$perpage|escape}</span> <span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu">
					<li{if $perpage == 25} class="active"{/if}><a href="?action={$action}&function={$function}&perpage=25">25</a></li>
					<li{if $perpage == 50} class="active"{/if}><a href="?action={$action}&function={$function}&perpage=50">50</a></li>
					<li{if $perpage == 100} class="active"{/if}><a href="?action={$action}&function={$function}&perpage=100">100</a></li>
				</ul>
			</span>
		</li>
		<li class="page-first {if $startrecord<=1}disabled{/if}"><a href="?action={$action}&function={$function}&page=1">&lt;&lt;</a></li>
		<li class="page-pre {if $startrecord<=1}disabled{/if}"><a href="?action={$action}&function={$function}&page={$prevpage|escape}">&lt;</a></li>
		<li class="page-number active"><a href="javascript:void(0)">{$page|escape}</a></li>
		<li class="page-next{if $endrecord>=$totalrecords} disabled{/if}"><a href="?action={$action}&function={$function}&page={$nextpage|escape}">&gt;</a></li>
		<li class="page-last{if $endrecord>=$totalrecords} disabled{/if}"><a href="?action={$action}&function={$function}&page={$totalpages|escape}">&gt;&gt;</a></li>
	</ul>
</div>
