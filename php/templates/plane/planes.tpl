{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Plane Database</h2>
	</div>
	<div class="panel-body">
	<p>
		<center>
		<img class="fixed-ratio-resize" src="images/pike.jpg" width="400"><br>
		Pike Precision F3B
		</center>
		<br>
		It's nice to be able to look up infomation on what kind of planes are out there, who makes them, who flys them and any other cool things about them.<br>
		<br>
		This portion of the F3X Vault is dedicated to all of the information available on F3X planes. Please contribute your information about the planes that you fly. You can even include pictures and links to videos!<br>
		<br>
		Please use the suggestions form to let me know about new characteristics of planes that you might want to be tracked.<br>
		<br>

		<center>
			<input type="button" value=" Browse Planes " class="btn btn-primary btn-rounded" style="display:inline;float:none;" onClick="document.browse_planes.submit();">
		</center>
		<br>
	</p>
	</div>
</div>

<form name="browse_planes" method="GET">
<input type="hidden" name="action" value="plane">
</form>

{/block}
 
