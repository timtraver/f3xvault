<div class="page type-page status-publish hentry clearfix post nodate">
	<div class="entry clearfix">                
		<h1 class="post-title entry-title">F3X Event Import Step 1</h1>
		<div class="entry-content clearfix">

<h1 class="post-title entry-title">Import File for Event</h1>
<p>This import process can currently handle the export files from F3KScore for F3K events, and import files for F3F. They both follow the same format.</p>
<br>

<form name="main" method="POST" enctype="multipart/form-data">
<input type="hidden" name="action" value="import">
<input type="hidden" name="function" value="import_verify">
<input type="hidden" name="event_id" value="{$event->info.event_id}">
<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
	{if $event->info.event_id!=0}
	<tr>
		<th>Event Name</th>
		<td>
			{$event->info.event_name}
		</td>
	</tr>
	{/if}
	<tr>
		<th>Import File</th>
		<td>
			<input type="hidden" name="MAX_FILE_SIZE" value="2000000">
			<input type="file" size="60" name="import_file" value="">
		</td>
	</tr>
	<tr>
		<th>Import Field Separator</th>
		<td>
			<input type="radio" name="field_separator" value="," CHECKED> Comma or 
			<input type="radio" name="field_separator" value=";"> Semicolon 
		</td>
	</tr>
	<tr>
		<th>Decimal Type</th>
		<td>
			<input type="radio" name="decimal_type" value="." CHECKED> Period or 
			<input type="radio" name="decimal_type" value=","> Comma 
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<input type="button" value=" Back To Event Edit " class="block-button" onClick="goback.submit();">
			<input type="submit" value=" Submit Initial Import File " class="block-button">
		</td>
	</tr>
</table>
</form>

<h1 class="post-title entry-title">Import File Format</h1>
<p>It is important that if you are creating a file format that is to be imported into F3XVault, that it follows these lines and fields <b>EXACTLY</b>.<br>
	The file is a CSV formatted file, and text fields that may contain odd characters should be enclosed in quotes.
</p>

<table width="100%" cellpadding="2" cellspacing="1" class="tableborder">
<tr>
	<th align="left" colspan="2">For F3K Events</th>
</tr>
<tr>
	<th nowrap>Line 1 (Event Info)</th>
	<td>
		Event_ID(num),Event_Name(text),Event_Date_From(text),Event_Date_To(text),Event_Type(f3k or f3f)
	</td>
</tr>
<tr>
	<th nowrap>Line 2 (Round List)</th>
	<td>
		Round_1_Type ('f3k_a'), Round_2_Type ('f3k_c3'), Round_X_Type ('f3k_a-j') . . .
	</td>
</tr>
<tr>
	<th nowrap>Line 3 (Pilot Data)</th>
	<td>
		Pilot_ID(num or 0), Pilot_Name(text), Pilot_Class(text), Pilot_Freq(text), Pilot_Team(text), Round_1_Group(txt), Round_1_flight_1(seconds or colon notation min:sec like 1:58), Round_1_flight_X(seconds or colon), Round_1_Penalty(num), Round_2_Group(txt), Round_2_Flight_X(seconds or colon), Round_2_Penalty(num), ... Round_X_...
	</td>
</tr>
<tr>
	<th nowrap>Example</th>
	<td>
		0,2015 International Hand Launch Glider Festival,05/02/2015,05/03/2015,f3k<br>
		f3k_c,f3k_g,f3k_i,f3k_d,f3k_e,f3k_a,f3k_f,f3k_j,f3k_h,f3k_b,f3k_g,f3k_e<br>
		0,Tim Traver,Open,2.4GHz,,E,3:00,3:00,3:00,,B,1:59,2:00,1:59,1:41,2:00,,............<br>
		0,Thomas Kiesling,Open,2.4GHz,,D,3:00,3:00,3:00,,B,2:00,2:00,1:59,1:59,1:49,,...........<br>

	</td>
</tr>
<tr>
	<th align="left" colspan="2">For F3F Events</th>
</tr>
<tr>
	<th nowrap>Line 1 (Event Info)</th>
	<td>
		Same as Above Line 1
	</td>
</tr>
<tr>
	<th nowrap>Line 2 (Pilot Data)</th>
	<td>
		Pilot_ID(num or 0), Pilot_Name(text), Pilot_Class(text), Pilot_Freq(text), Pilot_Team(text), Round_1_flight(sec), Round_1_Penalty(num), Round_2_Flight(sec), Round_2_Penalty(num), ... Round_X_...
	</td>
</tr>
<tr>
	<th nowrap>Example</th>
	<td>
		0,2015 SCSR Vincent,05/18/2015,05/18/2015,f3f<br>
		0,Tim Traver,Open,2.4GHz,,42.56,,46.22,,41.21,,40.37,,............<br>
		0,Thomas Kiesling,Open,2.4GHz,,41.59,,43.29,,45.75,,41.21,,...........<br>

	</td>
</tr>
<tr>
	<th align="left" colspan="2">Glossary of Fields</th>
</tr>
<tr>
	<th nowrap>Event_ID</th>
	<td>
		This is the existing Event ID in the F3XVault system. It is usually retrieved from the export of the event. If it is 0, it will create a new event, or match the name and dates with an existing event.
	</td>
</tr>
<tr>
	<th nowrap>Event_Name</th>
	<td>
		Text of the Event Name. If no Event_ID is given, then it must match up EXACTLY to an existing event along with the dates to overwrite.
	</td>
</tr>
<tr>
	<th nowrap>Event_Date_From (To)</th>
	<td>
		Dates of event. Preferably in the format mm/dd/yyyy
	</td>
</tr>
<tr>
	<th nowrap>Event_Type</th>
	<td>
		String of the event type. Currently only 'f3k' or 'f3f'
	</td>
</tr>
<tr>
	<th nowrap>F3K Round List</th>
	<td>
		This is the list of round types for each round. They contain the strings for the round types (f3k_a - f3k_j).<br>
		And example of this line might look like this : f3k_a,f3k_c,f3k_h,f3k_g
	</td>
</tr>
<tr>
	<th nowrap>Pilot_ID</th>
	<td>
		If the event was exported from this system first, or the lookup feature was used to look pilots up from this database, then this is the pilot_id field. It is a number.
	</td>
</tr>
<tr>
	<th nowrap>Pilot_Name</th>
	<td>
		The Pilot Name field. First Name with a space and then Last Name.
	</td>
</tr>
<tr>
	<th nowrap>Pilot_Class</th>
	<td>
		Competition Class of this pilot. "Open", "Sportsman", "Master" are all examples.
	</td>
</tr>
<tr>
	<th nowrap>Pilot_Freq</th>
	<td>
		Radio Frequency of this pilot. "2.4GHz", or "39" are examples.
	</td>
</tr>
<tr>
	<th nowrap>Pilot_Team</th>
	<td>
		Text value of the team that the pilot is on. Used for team scores.
	</td>
</tr>
<tr>
	<th nowrap>Round_X Data</th>
	<td>
		These fields are each round data. For F3K, it includes the flight group, the number of sub flights corresponding to the task, and the penalty.
	</td>
</tr>

</table>

</div>
</div>
</div>

