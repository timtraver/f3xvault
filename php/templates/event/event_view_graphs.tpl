<div class="page type-page status-publish hentry clearfix post nodate" style="display:inline-block;" id="8">
	<div class="entry clearfix" style="vertical-align:top;" id="9">                
		<div class="entry clearfix" style="display:inline-block;vertical-align:top;padding-bottom:10px;padding-right: 10px;">
			<h3>Event Wind Graph</h3>
			<div>
				<div>                
					<div id="event_chart_div" style="width: 1200px;height: 300px;"></div>
					<br>
				</div>
			</div>
			
			
			<h3>Individual Round Graphs</h3>
			{foreach $event->rounds as $r}
			<div>
				<div>
					<h4>Round {$r.event_round_number}</h4>
					<div id="round{$r.event_round_number}_chart_div" style="width: 1200px;height: 300px;"></div>
					<br>
				</div>
			</div>
			{/foreach}
		</div>

	<br>
	<br>
	</div>
</div>
