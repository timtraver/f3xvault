{extends file='layout/layout_main.tpl'}

{block name="header"}
<script src="https://www.google.com/recaptcha/api.js"></script>
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">Site Feedback</h2>
	</div>
	<div class="panel-body">
		<p>

			<form name="main" method="POST">
			<input type="hidden" name="action" value="main">
			<input type="hidden" name="function" value="main_feedback_save">
			<table width="100%" cellpadding="2" cellspacing="1" class="table table-condensed">
			{if $user.user_id==0}
			<tr>
				<th valign="top">Email Address</th>
				<td>
					<input type="text" size="50" name="email_address">
				</td>
			</tr>
			{/if}
			<tr>
				<th width="30%" valign="top" nowrap>Feedback, Comments, or Feature Requests</th>
				<td>
					<textarea cols="75" rows="8" name="feedback_string"></textarea><br>
					<div class="g-recaptcha" data-sitekey="{$recaptcha_key|escape}"></div>
				</td>
			</tr>
			</table>
			<center>
				<input type="submit" value=" Send This Feedback " class="btn btn-primary btn-rounded">
			</center>
			</form>

			<h2 class="post-title entry-title">On My Todo List</h2>
			This is just a short list of some of the things already on my suggestion and todo list (not necessarily in order of importance):<br>
			<ul>
			
				<li>Event Management</li>
					<ul>
						<li>Full signup system for event registration<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Payment methods for registration<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Calander system to see upcoming events</li>
						<li>Registration wait list for events that fill up quickly</li>
					</ul>
				<li>Event Scoring</li>
					<ul>
						<li>Reflights<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Flyoff Rounds and Calcs <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Create flying draw order for All disciplines<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Full flight time entries for all the flights in F3K<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Printouts for flight orders and groups <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Possibly print to PDF format for easier printing <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Email link to results for event participants</li>
						<li>Full Mobile version for tablets and smartphones <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Show statistics for F3K events (quick turnaround times, etc)</li>
						<li>Resolve ties by going back to dropped rounds for event rank <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Create ability to set event calculation accuracy<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
					</ul>
				<li>Location Database</li>
					<ul>
						<li>Make a cool map of the locations in the database in a separate locations map screen using google api <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Add Map waypoints</li>
						<li>Recent Event List at that location<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
					</ul>
				<li>Plane Database</li>
					<ul>
						<li>Add plane setups to allow pilots to show setup info</li>
						<li>Plane Reviews</li>
						<li>Plane links to build logs</li>
						<li>Plane Speed and Distance Records<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Pilots Flying Model<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
					</ul>
				<li>Pilots Area</li>
					<ul>
						<li>Show your own Personal Records for F3F, F3B<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
					</ul>
				<li>Series</li>
					<ul>
						<li>Series preferences and standings<img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Multiple Series assignment (Events can be part of more than one series) <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Allow different types of series scoring such as MOM scoring <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
					</ul>
				<li>Clubs</li>
					<ul>
						<li>Club Member management (possible due paying?)</li>
						<li>Club Mailing List management</li>
						<li>Club Calendar</li>
						<li>Add Events and Series to club view screen</li>
					</ul>
				<li>General</li>
					<ul>
						<li>Create a "Using this site" kind of tutorial instructions</li>
					</ul>
				<li>Mobile Site Access</li>
					<ul>
						<li>Create a mobile version of the site to be able to view locations, planes, and events <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Mobile score entry by end user <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
						<li>Ability to expand and contract to view mobile site better <img src="/images/icons/accept.png" style="border:0;margin:0;"></li>
					</ul>
				<li>Wish List</li>
					<ul>
						<li>Live Timing board control <img src="/images/icons/accept.png" style="border:0;margin:0;"> !!!!!</li>
					</ul>
			</ul>

		</p>
	</div>
</div>
{/block}



