"Event_ID"{$fs}"{$event->info.event_id}"
"Event_Name"{$fs}"{$event->info.event_name}"
"Event_Location"{$fs}"{$event->info.location_name}"
"Start_Date"{$fs}"{$event->info.event_start_date|date_format:"m/d/y"}"
"End_Date"{$fs}"{$event->info.event_end_date|date_format:"m/d/y"}"
"Contest_Director"{$fs}"{$event->info.pilot_first_name} {$event->info.pilot_last_name}"
"Event_Type"{$fs}"{$event->info.event_type_name}"
"Number_Rounds"{$fs}"{$rounds}"
"Pilot_id"{$fs}"Pilot_Bib"{$fs}"First_Name"{$fs}"Last_Name"{$fs}"Pilot_Class"{$fs}"AMA"{$fs}"FAI"{$fs}"Team_Name"{$fs}{for $r=1 to $rounds}"Round_{$r}"{if !$r@last}{$fs}{/if}{/for}

{foreach $event->pilots as $p}{$event_pilot_id=$p.event_pilot_id}
"{$p.pilot_id}"{$fs}"{$p.event_pilot_bib}"{$fs}"{$p.pilot_first_name}"{$fs}"{$p.pilot_last_name}"{$fs}"{$p.class_description}"{$fs}"{$p.pilot_ama}"{$fs}"{$p.pilot_fai}"{$fs}"{$p.event_pilot_team}"{$fs}{foreach $draws as $d}{$evid=$d@key}{if $evid==$event_pilot_id}{foreach $d.draw as $r}"{$r}"{if !$r@last}{$fs}{/if}{/foreach}{/if}{/foreach}

{/foreach}