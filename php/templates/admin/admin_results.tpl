{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Vault Admin area !</h2>
	</div>
	<div class="panel-body">

		<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed table-striped">
		<tr>
			<th>Results from Admin Function</th>
			<td>
				<textarea cols="80" rows="30">{foreach $results as $r}{$r|escape}{/foreach}</textarea>
			</td>
		</tr>
		</table>
	</div>
</div>

 {/block}
