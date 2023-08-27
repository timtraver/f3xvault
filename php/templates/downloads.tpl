{extends file='layout/layout_main.tpl'}

{block name="header"}
{/block}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3XVault Downloads Page</h2>
	</div>
	<div class="panel-body">
	<h3>Additional Software To Download</h3>
	This is the official page of any downloads for software to help you run your competition.

	<h3>Introducing F3XTiming!</h3>
	F3XTiming is a full stack application that runs on your Mac or PC to run timing audio and peripherals such as a timing board. It is a full featured program to run your event timing and timing boards. Here is a list of features :<br>
	<br>
	<ul style="font-weight: bold;font-size: 16px;">
		<li>Use with or without internet connectivity</li>
		<li>Search for Events on f3xvault.com to run an established event</li>
		<li>Run timing for F3K, F3J, and F5J events!</li>
		<li>Edit pilot pronunciations on the fly</li>
		<li>Select different kinds of horns</li>
		<li>Select from a variety of system voices and languages (not all text is spoken in a different language)</li>
		<li>Full playlist preferences to control task announcement, pilot announcements, prep times, landing windows and announcing pilots for next round!</li>
		<li>Connection to many serial timing boards (and the list is growing as needed)</li>
		<li>Pilots meeting countdowns and announcements</li>
		<li>Automatic contest start announcements and auto play of playlist at set time</li>
		<li>Calculation of playlist times to help you know when the contest will end</li>
		<li>If no internet connection, you can build a manual playlist</li>
		<li>Manual playlist can be repeated for ease of use when practicing</li>
		<li>Create custom playlist on the fly with custom window times</li>
		<li>Full F3K Task list</li>
		<li>Cache voice phrases for countdowns that are right on queue!</li>
		<li>Versions on MacOS or PC (Looks and works exactly the same)</li>
	</ul>
	<br>
	<h3>Screen Shots (Click for larger preview)</h3>
	<br>
	<table width="100%">
		<tr>
			<td align="center"><b>Home Screen</b></td>
			<td align="center"><b>Event Search Screen</b></td>
			<td align="center"><b>Loaded Event Screen</b></td>
			<td align="center"><b>Manual Timing</b></td>
		</tr>
		<tr>
			<td align="center" width="25%"><a href="/images/f3xtiming_home.png" target="_blank"><img width="75%" src="/images/f3xtiming_home.png" /></a></td>
			<td align="center" width="25%"><a href="/images/f3xtiming_search.png" target="_blank"><img width="75%" src="/images/f3xtiming_search.png" /></a></td>
			<td align="center" width="25%"><a href="/images/f3xtiming_event.png" target="_blank"><img width="75%" src="/images/f3xtiming_event.png" /></a></td>
			<td align="center" width="25%"><a href="/images/f3xtiming_manual.png" target="_blank"><img width="75%" src="/images/f3xtiming_manual.png" /></a></td>
		</tr>
	</table>
	<br>
	<h3>Release Version Information</h3>
	<br>
	<ul style="font-weight: bold;font-size: 16px;">
		<li>2022-04-16 : Initial Release 1.0 of software.</li>
		<li>2022-05-05 : Release 1.1 of software.</li>
		<ul>
			<li>Separate the Announce checkboxes in the preferences to show that they don’t need to have a new create playlist done</li>
			<li>Add a two minute warning for pilots meeting and start of contest calls too.</li>
			<li>Pilot name announcements in alpha order</li>
			<li>Announcements for no fly time at 10 sec and 5 sec</li>
			<li>Give No Fly Time a short horn</li>
			<li>Draw names in alpha order if no lanes (for F3K) or just order by lanes and then by name</li>
			<li>Check Big ladder and huge ladder descriptions to make sure they are correct</li>
			<li>Send NF time code to pandora serial port during No Fly times.</li>
		</ul>
		<li>2022-07-19 : Release 1.2 of software.</li>
		<ul>
			<li>Update of playlist preferences to include 45 second testing time and 1m no fly queue entries</li>
			<li>Update of serial output of color codes for F3Kmaster and Pandora for testing and nofly periods</li>
		</ul>
		<li>2023-01-13 : Release 1.3 of software.</li>
		<ul>
			<li>Update to include search and function use for F3L discipline</li>
			<li>Added F3B tasks for manual timing</li>
			<li>Forced space bar to be a toggle for queue play/pause</li>
			<li>Added second serial port to be able to send board and pandora data out two different ports</li>
		</ul>
		<li>2023-08-26 : Release 1.4 of software.</li>
		<ul>
			<li>Update to entry into Pilot Meeting and Contest Start Time fields to make it easier</li>
			<li>Added separate group and round separation times for playlist</li>
			<li>Improved separation and landing announcements to be more clear</li>
			<li>Addition of double click on playlist items to go to specific entry</li>
			<li>Internet connection check on front page and on event details page</li>
			<li>Tooltip popups for buttons to give some explanations of screen items</li>
			<li>Draw pane now moves with playlist pane</li>
			<li>Reload of draw if internet is connected and update green dots next to names that have entered scores in previous rounds</li>
			<li>New Pilot reminder system to enter scores if more than two rounds behind</li>
			<li>New button to immediately call out pilots that have not entered scores from last round and earlier</li>
			<li>New insults for the Mike Smith rule! :)</li>
		</ul>
	</ul>
	<br>
	<h3>Download Links And Instructions</h3>
	<br>
	<ul style="font-weight: bold;font-size: 16px;">
		<li>MacOS (MacOS X 10.12 and above)</li>
			<ul>
				<li>F3XTiming 1.0 - <a style="color: blue;" href="/downloads/macos/f3xtiming1.0.zip">Download Link</a></li>
				<li>F3XTiming 1.1 - <a style="color: blue;" href="/downloads/macos/f3xtiming1.1.zip">Download Link</a></li>
				<li>F3XTiming 1.2 - <a style="color: blue;" href="/downloads/macos/f3xtiming1.2.zip">Download Link</a></li>
				<li>F3XTiming 1.3 - <a style="color: blue;" href="/downloads/macos/f3xtiming1.3.zip">Download Link</a></li>
				<li>F3XTiming 1.4 (Current) - <a style="color: blue;" href="/downloads/macos/f3xtiming1.4.zip">Download Link</a></li>
			</ul>
		<li>Windows PC (Windows 10 and above?)</li>
			<ul>
				<li>Windows US-en Registry File to allow English Windows Cortana Voice - <a style="color: blue;" href="/downloads/windows/windows-10-voices-add.zip">Download Link</a></li>
				<li>F3XTiming 1.0 - <a style="color: blue;" href="/downloads/windows/f3xtiming1.0.zip">Download Link</a></li>
				<li>F3XTiming 1.1 - <a style="color: blue;" href="/downloads/windows/f3xtiming1.1.zip">Download Link</a></li>
				<li>F3XTiming 1.2 - <a style="color: blue;" href="/downloads/windows/f3xtiming1.2.zip">Download Link</a></li>
				<li>F3XTiming 1.3 - <a style="color: blue;" href="/downloads/windows/f3xtiming1.3.zip">Download Link</a></li>
				<li>F3XTiming 1.4 (Current) - <a style="color: blue;" href="/downloads/windows/f3xtiming1.4.zip">Download Link</a></li>
			</ul>
	</ul>
	<ul style="font-weight: bold;font-size: 16px;">
		<ul>
		</ul>
	</ul>
	<br>
	<h4>Instructions For Installation</h4>
	<ol style="font-weight: bold;font-size: 14px;">
		<li>Select the proper download link above for your computer operating system.</li>
		<li>Uncompress the zip file to a convenient location like your desktop. You must leave the contents of the folders intact and start the application from within the folders.</li>
		<li>If you are using Windows 10 or higher, I highly recommend you download the registry import to add the cortana voices to your system. The base system voices are not that great, and if you install these files, you will get at least the nice Cortana Eva voice to use. Uncompress that zip file and double click on each voice. This will change some registry settings to allow third party apps to use the Cortana voices.</li>
		<li>Click on the glider icon to start the application. (For MacOS, you will need to right-click -> Open to open the application the first time)</li>
		<li>It starts out at the main menu.</li>
	</ol>
	<br>
	<h4>Using the application</h4>
	<br>
	I would suggest you open the application and read along with these paragraphs to get familiar with the functionality of the program.<br>
	<br>
	<ol style="font-weight: bold;font-size: 14px;">
		<li>Home Screen : 
			<p style="font-weight: normal;font-size: 12px;">The home screen is simple in it has only three buttons. One that will allow you to search for events you have already set up in f3xvault.com, one that will take you to the manual timing screen, and a donation button. Please Donate! :) This screen now has an interenet connection status that will be green if you have an internet connection. It will also turn the Search button green if you have an active session.
			</p>
		</li>
		<li>Search Screen : 
			<p style="font-weight: normal;font-size: 12px;">The search screen is also very simple. It allows you to search for events in the f3xvault system so that you can download the draw and pilots and create a playlist for that event. You can search on discipline type (f3k, f5j, etc), and you can also search for a string of the name of the event. Simply click on the row of the event you want to load, and it will take you to the main event screen.
			</p>
		</li>
		<li>Event Screen :
			<p style="font-weight: normal;font-size: 12px;">The event screen has the following areas :
				<ul>
					<li> Top And Title Area
						<p style="font-weight: normal;font-size: 12px;">
							Across the top of the screen is the logo, the name of the event, and at the top right are the fields you can set for the pilots meeting time and the start of the event :
								<ul>
									<li>Pilots Meeting Field
										<p style="font-weight: normal;font-size: 12px;">
											If you enter a time here (and do not have  "Send Time to clock when system is idle" selected), the system will show a countdown to the pilots meeting, and every 5 minutes will announce when the pilots meeting is. Once the time is reached it will sound the horn and explain that the pilots meeting is beginning and to come to the organization table. This field needs to be entered in 24 hour time (like 09:00) This can now be simplified by not using the full four digits and colon. You can just type in 900 for 9 a.m.
										</p>
									</li>
									<li>Contest Starts Field
										<p style="font-weight: normal;font-size: 12px;">
											If you enter a time here (and do not have  "Send Time to clock when system is idle" selected), the system will show a countdown to the start of the contest AFTER the pilots meeting time has passed, and every 5 minutes will announce when the contest will start. Once the time is reached it will sound the horn and explain that the contest will begin. It will then automatically start the generated playlist at the designated queue entry. This field also needs to be entered in 24 hour time (like 09:00) This can now be simplified by not using the full four digits and colon. You can just type in 900 for 9 a.m.
										</p>
									</li>
								</ul>
						</p>
					</li>
					<li> Pilot List Area
						<p style="font-weight: normal;font-size: 12px;">
							On the left hand side of the window is the pilot list of this event.
								<ul>
									<li>Top Speaker
										<p style="font-weight: normal;font-size: 12px;">
											Clicking on the speaker icon in the top pilot header bar will speak each pilot's name which will allow you to see if the voice you have chosen pronounces the pilots names correctly.
										</p>
									</li>
									<li>Pilot Speakers
										<p style="font-weight: normal;font-size: 12px;">
											Each of the pilot entries has a speaker next to it where you can test and edit the pronunciation of that pilot. Clicking on the speaker icon will open a small window below the pilot list that will allow you to edit the pronunciation of the pilot. You can enter phonetic spellings of their name, test the voice saying it, and if you like it, save that pilot's pronunciation. It will not change the name of the pilot anywhere. It will just change the pronunciation when being said in flight groups. Press the cancel button to close the window, or Save to save that voice. This will only save it on this computer.
										</p>
									</li>
								</ul>
						</p>
					</li>
					<li> Draw Area
						<p style="font-weight: normal;font-size: 12px;">
							Next to the pilot list scroll on the right is the round draw of the contest. This simply shows the draw of the contest. This draw area now has a spot for a green or red icon if the pilots have entered scored in the self scoring screens or not. It gets refreshed every new round, and the draw pane now moves to the same round that is being announced in the playlist.
						</p>
					</li>
					<li> Sound And Voice Preferences
						<p style="font-weight: normal;font-size: 12px;">
							In the middle of the screen is the Sound and Voice Preferences area. If changes are made to any of these preferences, you do not have to regenerate the playlist for them to be in effect.
								<ul>
									<li>Horn
										<p style="font-weight: normal;font-size: 12px;">
											Selecting the horn list will allow you to select from some different horn types. Some horns can be better heard through particular sound systems. When you select a horn, a test horn audio will occur, allowing you to hear the horn you have chosen.
										</p>
									</li>
									<li>Language
										<p style="font-weight: normal;font-size: 12px;">
											The language list allows you to select a language of voices that you have installed on the computer. Sometimes this will translate some of the spoken phrases like numbers, so you can choose your native language and hear some phrases natively. This selection will also change the voice selection depending on what different voices you have installed on your machine.
										</p>
									</li>
									<li>Voice Selection
										<p style="font-weight: normal;font-size: 12px;">
											Once you have selected the language, this will give you the list of voices installed on your computer that can be used by external applications. As I had mentioned in the installation area, if you download the registry files for Windows, you can add the Cortana Eva voice to your machine (english) that is a much better quality voice than the default voices that come with windows. The MacOS has an extensive list of voices that can be downloaded. They are located in the Settings -> Accessibility -> Spoken Text area in the settings (You can download additional voices by selecting to edit the list in the voice list and download nice voices. My Favorite is Ava)
										</p>
									</li>
									<li>Test Voice
										<p style="font-weight: normal;font-size: 12px;">
											After selecting a voice, you can hear an example of the voice by pressing this button.
										</p>
									</li>
									<li>Preload Voice Cache
										<p style="font-weight: normal;font-size: 12px;">
											Pressing this button will load the audio cache with all of the phrases used when speaking. This will allow them to be said quicker and  they will land on the proper seconds. This is particularly necessary on Windows machines, as the Text To Speech engine on windows is very slow in generating the audio. Press this button and it will show a loading screen that loads all the voices. It will disappear when it is finished. If for some reason it is taking too long and stuck, then you can cancel it and try again.
										</p>
									</li>
								</ul>
						</p>
					</li>
					<li> Playlist Preferences
						<p style="font-weight: normal;font-size: 12px;">
							In the middle of the screen is the Playlist Preferences area. These preferences are usually set before creating the playlist, but the last two can be set on the fly.
								<ul>
									<li>Announce Tasks
										<p style="font-weight: normal;font-size: 12px;">
											This checkbox will announce the particular tasks at the beginning of each group. It will say the full explanation of the task. Changes to this playlist for this parameter will only take effect when the playlist is regenerated.
										</p>
									</li>
									<li>Announce Pilots
										<p style="font-weight: normal;font-size: 12px;">
											This will create a playlist entry to announce the pilots that are in this group. Changes to this playlist for this parameter will only take effect when the playlist is regenerated.
										</p>
									</li>
									<li>Prep Time
										<p style="font-weight: normal;font-size: 12px;">
											This is the amount of prep time you wish to have before the working window for the task starts. Changes to this playlist for this parameter will only take effect when the playlist is regenerated.
										</p>
									</li>
									<li>45s Test Flight Window (F3K)
										<p style="font-weight: normal;font-size: 12px;">
											For F3K, this will insert a queue entry of 45 seconds for flight testing time as per the f3k rules of 2020.
										</p>
									</li>
									<li>1m No Fly Window (F3K)
										<p style="font-weight: normal;font-size: 12px;">
											For F3K, this will insert a queue entry of 1 minute for a no fly period before the start of the working window.
										</p>
									</li>
									<li>Use Landing Window
										<p style="font-weight: normal;font-size: 12px;">
											For F3K, the landing window is 30 seconds. For F3J, F5J, and TD this allows for a one minute timed window for landing back on the field. Changes to this playlist for this parameter will only take effect when the playlist is regenerated.
										</p>
									</li>
									<li>Between Rounds
										<p style="font-weight: normal;font-size: 12px;">
											If you wish for there to be some time between rounds, this is a selection where you can insert time. Changes to this playlist for this parameter will only take effect when the playlist is regenerated.
										</p>
									</li>
									<li>Announce Pilots In Next Round
										<p style="font-weight: normal;font-size: 12px;">
											This is to announce the next round pilots at approximately 3:25 left in the window of the current round. This is to help pilots remember that they are up in the next round and should start to get ready. This can also be turned on and off on the fly without re generating the playlist.
										</p>
									</li>
									<li>Announce Pilot Score Reminders
										<p style="font-weight: normal;font-size: 12px;">
											This is to announce a list of pilots that have not yet entered their self scoring scores. It happens at the beginning of a new round, and looks at anything older than 2 rounds ago to announce the pilots to be reminded.
										</p>
									</li>
									<li>Call Out Pilot Score Reminder Now Button
										<p style="font-weight: normal;font-size: 12px;">
											This button will immediately announce a list of pilots that have not yet entered their self scoring scores and looks at anything older than 1 rounds ago to announce the pilots to be reminded.
										</p>
									</li>
								</ul>
						</p>
					</li>
					<li> Create Playlist Button
						<p style="font-weight: normal;font-size: 12px;">
							The yellow button in the center that says Create Playlist will regenerate the playlist with the preferences you have selected in the above preferences.
						</p>
					</li>
					<li> Serial Connected Clock Board Preferences
						<p style="font-weight: normal;font-size: 12px;">
							The clock preferences for a serially connected clock are located in the lower left hand area of the screen.
								<ul>
									<li>Serial Port
										<p style="font-weight: normal;font-size: 12px;">
											This is the list of serial ports that have been found on your computer. If you do not see any (except None), then plug in your serial cable adapter (USB to serial cable) and use the refresh button.
										</p>
									</li>
									<li>Serial Port Refresh button
										<p style="font-weight: normal;font-size: 12px;">
											This is the recycle image next to the serial port dropdown list. Clicking on this will re-load the serial port list and close the serial port connection. You can then select a new serial port if it shows up. If it does not show up in the list, then you may have to look at the drivers for your USB to serial cable.
										</p>
									</li>
									<li>Protocol
										<p style="font-weight: normal;font-size: 12px;">
											This is which protocol to use when sending data to a particular timing board. If you do not find the protocol on this list that works with your board, then please contact me, and we can create one that works.
										</p>
									</li>
									<li>Baud Rate
										<p style="font-weight: normal;font-size: 12px;">
											This is the serial baud rate to use over this connection.
										</p>
									</li>
									<li>Send Time to clock when system is idle
										<p style="font-weight: normal;font-size: 12px;">
											If this checkbox is selected, then the time of day will be displayed on the serial board when there is no activity. If you have a Pilot's meeting entry or a contest start entry, then you will want this off to show the remaining times to the pilots list or contest start.
										</p>
									</li>
									<li>Sent
										<p style="font-weight: normal;font-size: 12px;">
											This is a field that is showing you what is being sent to the serial port.
										</p>
									</li>
								</ul>
						</p>
					</li>
					<li> Audio Playlist
						<p style="font-weight: normal;font-size: 12px;">
							This is the main playlist area on the right hand portion of the screen that has the clock and the playlist queue entries.
								<ul>
									<li>Progress Bar
										<p style="font-weight: normal;font-size: 12px;">
											When a timer is counting down, this bar will slowly move to the left to give a visual of how much time is left in the particular count down.
										</p>
									</li>
									<li>Clock Time
										<p style="font-weight: normal;font-size: 12px;">
											This is the remaining time in the queue entry and is in minutes and seconds.
										</p>
									</li>
									<li>Fast Forward Entry ( >> )
										<p style="font-weight: normal;font-size: 12px;">
											To fast forward to a different entry in the queue, you can use this button. It will stop the queue, and go to the next queue entry (shown by the play icon in the entry)
										</p>
									</li>
									<li>Fast Forward 10 seconds ( 10> )
										<p style="font-weight: normal;font-size: 12px;">
											When a timer is running, if you wish to move it forward ten seconds, then press the fast forward 10 button, and the time will decrease by 10 seconds.
										</p>
									</li>
									<li>Rewind Entry ( << )
										<p style="font-weight: normal;font-size: 12px;">
											To rewind to a previous entry in the queue, you can use this button. It will stop the queue, and go to the previous queue entry (shown by the play icon in the entry)
										</p>
									</li>
									<li>Rewind 10 seconds ( <10 )
										<p style="font-weight: normal;font-size: 12px;">
											When a timer is running, if you wish to move it rewind ten seconds, then press the fast rewind 10 button, and the time will increase by 10 seconds.
										</p>
									</li>
									<li>Play/Pause button
										<p style="font-weight: normal;font-size: 12px;">
											This toggle button will Start and Pause the playlist queue.
										</p>
									</li>
									<li>Playlist Queue Pane
										<p style="font-weight: normal;font-size: 12px;">
											In this pane, each line is an individual queue entry item. If you want to jump to a particular item in the queue, click on  the queue number on the left and the queue will stop and go to that entry. The play icon shows which entry is the current entry, and the whole pane will scroll as the contest moves forward.
										</p>
									</li>
								</ul>
						</p>
					</li>
					<li> Audio Calculations
						<p style="font-weight: normal;font-size: 12px;">
							This is lower right hand area below the playlist that shows you the calculated time that the playlist will need and the time the contest would end.
								<ul>
									<li>Calculate To End Of Round
										<p style="font-weight: normal;font-size: 12px;">
											This selection will allow you to select which round you want to see the calculation go to. This will allow you to see the time remaining to do a particular number of rounds from the current queue entry till the end of the selected round.
										</p>
									</li>
									<li>Remain
										<p style="font-weight: normal;font-size: 12px;">
											This is the remaining time to go to the selected end of round from the current queue entry.
										</p>
									</li>
									<li>End Time
										<p style="font-weight: normal;font-size: 12px;">
											This shows the end time from now if the playlist plays through from the current playlist queue entry to the end of the round selected in the calculate dropdown above.
										</p>
									</li>
								</ul>
						</p>
					</li>
				</ul>
			</p>
		</li>
		<li>Manual Event Timing Screen :
			<p style="font-weight: normal;font-size: 12px;">
				This screen will allow you to create a timing playlist without an internet connection by manually adding rounds, groups and tasks.<br>
				<br>
				Most of this screen is the same as in the Event screen above, so for those areas reference above. I will only describe the differences in this screen here.
				
				<ul>
					<li> Select Tasks Area
						<p style="font-weight: normal;font-size: 12px;">
							Since there are no pilots or a draw, the left side of the screen is taken up by the Select Tasks area. This area will allow you to select the different tasks and groups to make a playlist of your own.
								<ul>
									<li>Task
										<p style="font-weight: normal;font-size: 12px;">
											This selection list allows you to select from all of the tasks available in the system. These include all of the current (and past) F3K tasks, F3J, GPS and F5J tasks.
										</p>
									</li>
									<li>Task Description field
										<p style="font-weight: normal;font-size: 12px;">
											This is a field area that shows the complete description of the task that you have selected.											
										</p>
									</li>
									<li>Override Window Time To
										<p style="font-weight: normal;font-size: 12px;">
											Before adding this task to your playlist, you can override the window time default for the task if you wish. For instance, often times there can be flyoff times in F5J that are a fifteen minute window instead of a ten minute window.								
										</p>
									</li>
									<li>Add Task to Rounds
										<p style="font-weight: normal;font-size: 12px;">
											Use this button to add the selected task to your list of rounds. (with the selected override if you want)							
										</p>
									</li>
									<li>Rounds
										<p style="font-weight: normal;font-size: 12px;">
											This is the list of the rounds you have created for your playlist. You can delete the round using the small trash icon to the right, which will remove the round from your list.							
										</p>
									</li>
									<li>Groups
										<p style="font-weight: normal;font-size: 12px;">
											This is to select the number of groups you wish to have in your rounds.							
										</p>
									</li>
								</ul>
						</p>
					</li>
					<li> Repeat Playlist
						<p style="font-weight: normal;font-size: 12px;">
							Underneath the audio playlist is a checbox that will repeat the playlist when it gets to the end. This makes it easy if you wish to use the playlist to repeat a task for practice.
						</p>
					</li>
				</ul>
			</p>
		</li>
		<li>Upgrading the Software :
			<p style="font-weight: normal;font-size: 12px;">
				Periodically I will release updates to the software.<br>
				<br>
				The software does not have any automatic upgrading functionality, so when updating, simply delete the installation you have, and re-download the software like you initially have.
			</p>
		</li>
	</ol>
	<h2>Considerations</h2>
		<p style="font-weight: normal;font-size: 12px;">
			As with any written software, there can be bugs in any cases that we have not tested for. If you come across any issues with the software, please contact me, and I can attempt to help with fixes or workarounds. There are also possibly issues with different computers and operating system versions that can arise. I will do my best, but if you report an issue, please let me know as much about your setup as possible.<br>
			<br>
			And as always, donations are welcome at any time <a href="#" onClick="document.donate.submit();">Here</a><br>
			<br>
		</p>
		Thanks,<br>
		Tim
	</li>
</div>
<form name="donate" method="GET" action="https://www.paypal.com/cgi-bin/webscr" target="_blank">
	<input type="hidden" name="cmd" value="_xclick">
	<input type="hidden" name="business" value="timtraver@gmail.com">
	<input type="hidden" name="currency_code" value="USD">
	<input type="hidden" name="item_name" value="F3XVault Donation">
	<input type="hidden" name="amount" value=>
</form>
<form name="login" method="GET">
<input type="hidden" name="action" value="main">
<input type="hidden" name="function" value="login">
</form>
<form name="register" method="GET">
<input type="hidden" name="action" value="register">
</form>

{/block}