"Event_ID"{$fs}"{$event->info.event_id}"
"Event_Name"{$fs}"{$event->info.event_name}"
"Event_Location"{$fs}"{$event->info.location_name}"
"Start_Date"{$fs}"{$event->info.event_start_date|date_format:"m/d/y"}"
"End_Date"{$fs}"{$event->info.event_end_date|date_format:"m/d/y"}"
"Contest_Director"{$fs}"{$event->info.pilot_first_name} {$event->info.pilot_last_name}"
"Event_Type"{$fs}"{$event->info.event_type_name}"
"Number_Rounds"{$fs}{if $event->rounds|count>0}"{$event->rounds|count}"{else}"{$event->tasks|count}"{/if}

"Event_Tasks"{$fs}{if $event->rounds|count>0}{foreach $event->rounds as $r}{$flight_type_id=$r.flight_type_id}"{$event->flight_types.$flight_type_id.flight_type_code}"{if !$r@last}{$fs}{/if}{/foreach}{else}{foreach $event->tasks as $t}{$flight_type_id=$t.flight_type_id}"{$event->flight_types.$flight_type_id.flight_type_code}"{if !$t@last}{$fs}{/if}{/foreach}{/if}

"Pilot_id"{$fs}"Pilot_Bib"{$fs}"First_Name"{$fs}"Last_Name"{$fs}"Pilot_Class"{$fs}"AMA"{$fs}"FAI"{$fs}"Team_Name"{$fs}{if $event->rounds|count>0}{$num=$event->rounds|count}{else}{$num=$event->tasks|count}{/if}{for $r=1 to $num}"Round_{$r}"{if !$r@last}{$fs}{/if}{/for}

{foreach $event->pilots as $p}{$event_pilot_id=$p.event_pilot_id}
"{$p.pilot_id}"{$fs}"{$p.event_pilot_bib}"{$fs}"{$p.pilot_first_name}"{$fs}"{$p.pilot_last_name}"{$fs}"{$p.class_description}"{$fs}"{$p.pilot_ama}"{$fs}"{$p.pilot_fai}"{$fs}"{$p.event_pilot_team}"{$fs}{foreach $draws as $d}{$evid=$d@key}{if $evid==$event_pilot_id}{foreach $d.draw as $r}"{$r}"{if !$r@last}{$fs}{/if}{/foreach}{/if}{/foreach}

{/foreach}