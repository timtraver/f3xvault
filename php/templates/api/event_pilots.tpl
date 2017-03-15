"Pilot_id"{$fs}"Pilot_Bib"{$fs}"First_Name"{$fs}"Last_Name"{$fs}"Pilot_Class"{$fs}"AMA"{$fs}"FAI"{$fs}"Team_Name"
{foreach $event->pilots as $p}{$event_pilot_id=$p.event_pilot_id}
"{$p.pilot_id}"{$fs}"{$p.event_pilot_bib}"{$fs}"{$p.pilot_first_name}"{$fs}"{$p.pilot_last_name}"{$fs}"{$p.class_description}"{$fs}"{$p.pilot_ama}"{$fs}"{$p.pilot_fai}"{$fs}"{$p.event_pilot_team}"
{/foreach}