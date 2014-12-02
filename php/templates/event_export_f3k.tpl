"{$event->info.event_id}"{$fs}"{$event->info.event_name}"{$fs}"{$event->info.location_name}"{$fs}"{$event->info.event_start_date|date_format:"m/d/y"}"{$fs}"{$event->info.event_end_date|date_format:"m/d/y"}"{$fs}"{$event->info.pilot_first_name} {$event->info.pilot_last_name}"{$fs}"{$event->info.event_type_name}"{$fs}{if $event->rounds|count>0}"{$event->rounds|count}"{else}"{$event->tasks|count}"{/if}

{if $event->rounds|count>0}{foreach $event->rounds as $r}{/foreach}{else}{foreach $event->tasks as $t}{$flight_type_id=$t.flight_type_id}"{$event->flight_types.$flight_type_id.flight_type_code}"{if !$t@last}{$fs}{/if}{/foreach}{/if}

{foreach $event->pilots as $p}{$event_pilot_id=$p.event_pilot_id}
"{$p.pilot_id}"{$fs}"{$p.event_pilot_bib}"{$fs}"{$p.pilot_first_name}"{$fs}"{$p.pilot_last_name}"{$fs}"{$p.class_description}"{$fs}"{$p.pilot_ama}"{$fs}"{$p.pilot_fai}"{$fs}"{$p.event_pilot_team}"{$fs}{foreach $draws as $d}{$evid=$d@key}{if $evid==$event_pilot_id}{foreach $d.draw as $r}"{$r}"{if !$r@last}{$fs}{/if}{/foreach}{/if}{/foreach}

{/foreach}