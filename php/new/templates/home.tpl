{extends file='layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Welcome To F3XVault !</h2>
	</div>
	<div class="panel-body">
	<h3>Where Are You?</h3>
	You have stumbled upon a storage vault of information about RC F3X Model Flying. It includes databases for flying locations, planes, competitions, and clubs and all related data. It even includes a full scoring system for all of the disciplines to run a live competition!

	<h3><font color="red">WARNING</font></h3>
	Apparently, this site uses enough CSS3 and advanced html that it is not rendered very nicely on anything but IE10, Firefox, Chrome, or Safari browsers. This mostly means that if you have older version of Internet Explorer (6-9), that there are sections of the site that won't look good, and possibly will not function correctly. Sorry, I have tried to make sense of it, but I can't spend too much time figuring out old browsers, so you should upgrade...

	<h3>What can you do here?</h3>
	You can view and most importantly contribute to the knowledge base of our flying sports. A database is only as good as the data that you put in it, so help us fill it up!!!
						
	<h3>How can I start?</h3>
	You can start by registering or simply logging in. You do not have to be a member to view the data, but if you wish to contribute, then you must create and account with us.
	<br>
	<br>
	<center>
		<input type="button" value=" Log Me In " class="btn btn-primary btn-rounded" style="display:inline;float:none;" onClick="document.login.submit();"> or 
		<input type="button" value=" Register Me " class="btn btn-primary btn-rounded" style="display:inline;float:none;" onClick="document.register.submit();">
	</center>
	<h3>From the Author</h3>
	<p style="padding-left:10px">
		Welcome to my web database of all things F3X Flying. It wasn't very long ago that I started this hobby, and as I have increased my passion for it, I noticed that it was difficult to find information about where to fly, what planes are out there and the results of many competitions. In my research, I have found remnants of information in scattered places, but many are dead end links because the people that gathered that info have had life intervene and haven't been able to add to them or keep them up to date.<br>
		<br>
		That is why I decided to create a skeleton database that can be populated by all the people that know the answers. (That's you!)<br>
		<br>
		I started out building a place to store all of the results of contests, and it grew out of control from there. I needed the location of events, so I made a location database. Then I wanted to know the planes that the pilots flew, so I created the plane database. Then the clubs they were associated with, and it just kept going!<br>
		<br>
		It has been a challenging web site to build (especially the competition scoring programming) and is still in progress, but I am having fun creating it, and hope that the community at large will find it useful and fill it up with the data that only they know!<br>
		<br>
		Please let me know if there is anything that you might find useful to include or change, and I will try to incorporate it.<br>
		<br>
		Happy Flying!<br>
		<br>						
		Tim
		<center>
			<img class="fixed-ratio-resize" src="images/tim.jpg"><br>
			San Diego, California USA
		</center>
	</p>
						
	</div>
</div>

<form name="login" method="GET">
<input type="hidden" name="action" value="main">
<input type="hidden" name="function" value="login">
</form>
<form name="register" method="GET">
<input type="hidden" name="action" value="register">
</form>

{/block}