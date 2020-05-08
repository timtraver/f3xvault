{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3X Competition Events and Series</h2>
	</div>
	<div class="panel-body">
		<br>
		<center>
		<img class="fixed-ratio-resize" src="images/vampire_launch.jpg"><br>
		Gator F3B Contest, Cocoa, Florida USA
		</center>
		<br>
		Many of us fly for the sheer joy of flying, but there are also many that are addicted to the friendly competitions that we have with our planes. After a competition,
		the person that volunteered to do the scoring would have to blast an email containing some spreadsheet or scribbled notes about who won.<br>
		<br>
		This portion of the F3X Vault is dedicated to the scoring of events. I currently have programming for scoring F3B, F3F, F3J, F3K, F5J, GPS, MOM and TD contests along with all the cool
		statistics that I could think of to go along with them. I have made it so that a user can create an event and give access for other users to edit the event so that
		others can help out those people that may be busy. I have also tried my hardest to make the input of the data quick and efficient so that you don't have 
		to spend hours after a tiring day inputting data.<br>
		<br>
		I have also made a series section to be able to link events together to make a best of series.<br>
		<br>
		This site can be used for live contests as long as you have an internet connection at the site. I hope to one day have an off line version for those sites that don't have 
		internet connections, and also to have a system to run a contest control board, live timing and announcing.<br>
		<br>
		Wouldn't it be cool to watch the world championships as they happen?<br>
		<br>
		<br>
		
		Please, let me know if I have gotten anything wrong with the calculations, as some of these disciplines are tricky.<br>
		<br>
		<center>
		<input type="button" value=" Browse Contest Events " class="btn btn-primary btn-rounded" style="display:inline;float:none;" onClick="document.browse_events.submit();">
		<input type="button" value=" Browse Contest Series " class="btn btn-primary btn-rounded" style="display:inline;float:none;" onClick="document.browse_series.submit();">
		</center>
		<br>
		<br>
	</div>
</div>

<form name="browse_events" method="GET">
<input type="hidden" name="action" value="event">
</form>
<form name="browse_series" method="GET">
<input type="hidden" name="action" value="series">
</form>
 {/block}
