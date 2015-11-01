{extends file='layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Flying Locations</h2>
	</div>
	<div class="panel-body">
	<p>
		<center>
		<img class="fixed-ratio-resize" src="images/torrey3.jpg"><br>
		Torrey Pines, CA
		</center>
		<br>
		
		I noticed that every time an event was being held, there was always the need to give more information about the flying site like providing directions,
		permission issues, rules, etc.<br>
		<br>
		This portion of the F3X Vault is dedicated to all of the information available on particular flying sites. Please contribute your information about the
		sites that you fly at. This will make us a more informed community and hopefully prevent any flying sites from being abused or having our privileges to fly there lost.<br>
		<br>
		Also, please use the suggestions form to let me know about new characteristics of locations that you might want to be tracked.<br>
		<br>

		<center>
		<input type="button" value=" Browse Locations " class="btn btn-primary btn-rounded" style="display:inline;float:none;" onClick="document.browse_locations.submit();">
		</center>
		<br>
		<br>
	</p>
	</div>
</div>
<form name="browse_locations" method="GET">
<input type="hidden" name="action" value="location">
</form>
 
{/block}