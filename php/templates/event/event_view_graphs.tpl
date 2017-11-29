<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;" id="8">
	<div class="entry clearfix" style="vertical-align:top;" id="9">                
		<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">
			
			Pilot #1 :
			<select name="pilot1">
			{foreach $event->pilots as $p}
				<option value="">{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</option>
			{/foreach}
			</select>
			Round Flight : 
			<select name="flight1">
			{foreach $event->pilots as $p}
				<option value="">{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</option>
			{/foreach}
			</select>
			<br>
			Pilot #2 :
			<select name="pilot2">
			{foreach $event->pilots as $p}
				<option value="">{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</option>
			{/foreach}
			</select>
			Round Flight : 
			<select name="flight2">
			{foreach $event->pilots as $p}
				<option value="">{$p.pilot_first_name|escape} {$p.pilot_last_name|escape}</option>
			{/foreach}
			</select>
			
			
			
		</div>

	<br>
	<br>
	</div>
</div>
{block name="footer"}
{if $event->rounds|count>0}
<script type="text/javascript">
	function set_pilot_flights(){ldelim}
		{foreach $event->pilots as $event_pilot_id => $p}
		pilots['{$event_pilot_id}'] = {ldelim}
			"rounds" : {ldelim}
				{foreach $event->rounds as $event_round_number => $r}
					{foreach $r.flights as $f}
						{if !$f.pilots.$event_pilot_id}
							{continue}
						{/if}
						'{$r.event_round_number}','{$f.pilots.$event_pilot_id.event_pilot_round_flight_seconds}',
					{/foreach}
				{/foreach}
			
			{rdelim}
		{rdelim}
	
	
	
		{/foreach}
	
	
	{rdelim}

</script>
{/if}
{/block}