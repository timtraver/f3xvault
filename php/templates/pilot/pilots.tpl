{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Pilots</h2>
	</div>
	<div class="panel-body">
	<p>
		<center>
			<img class="fixed-ratio-resize" src="images/jet.png"><br>
			<b>Jet Flying his Radian at Dave's Beach in Carlsbad, CA USA</b>
		</center>
		<br>
		<br>
		There are F3X pilots all over the world of all ages and when creating the competition database, storing basic pilot info for ease of entry was crucial. In this area you may be able to find pilots in your area that share your passion, send them a message, or see what kind of planes are being flown by the top pilots.<br>
		<br>
		I do not store any personal information that may get sold to outside sources, and as a pilot, you even have the ability to lock your information so that nobody can even see where you like to fly...but we really aren't that anti-social of a group, right?<br>
		<br>

		<center>
			<input type="button" value=" Browse Pilots " class="btn btn-primary btn-rounded" style="display:inline;float:none;" onClick="document.browse_pilots.submit();">
		</center>
		<br>
		<br>
	</p>
	</div>
</div>

<form name="browse_pilots" method="GET">
<input type="hidden" name="action" value="pilot">
</form>

{/block}
 
