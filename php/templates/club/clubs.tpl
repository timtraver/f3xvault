{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Clubs</h2>
	</div>
	<div class="panel-body">
	<p>
		<br>
		<center>
			<img class="fixed-ratio-resize" src="images/gulls.jpg"><br>
			Torrey Pines Gulls, San Diego, California USA
		</center>
		<br>
		All around the world, we gather in small groups to discuss and brag about our F3X flying.
		<br>
		This portion of the F3X Vault is dedicated to all of the information available on flying clubs. Please contribute your information about your club and the members that might be in it.<br>
		<br>
		This area may be the future home of actually handling your club membership info as well as taking dues and anything that we can think of to make it easier for us to gather together.<br>
		<center>
			<input type="button" value=" Browse Clubs " class="btn btn-primary btn-rounded" style="display:inline;float:none;" onClick="document.browse_clubs.submit();">
		</center>
		<br>

	</p>
	</div>
</div>

<form name="browse_clubs" method="GET">
<input type="hidden" name="action" value="club">
</form>
 
{/block}