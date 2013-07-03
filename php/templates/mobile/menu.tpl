<div class="page-sidebar">
  <div class="page-sidebar-scroll">  
  	  <a href="mailto:mail@doamain.com" class="sidebar-button hide2-sidebar"><em class="sidebar-button-close">COLLAPSE</em></a>
      <div class="clear"></div>  
      <div class="menu">         
          <div class="menu-item">
              <strong class="gallery-icon"></strong>
              <a class="menu-disabled deploy-submenu" href="#">Select Discipline ({if $disc=='all' || $disc==''}All{elseif $disc=='f3b'}F3B{elseif $disc=='f3f'}F3F{elseif $disc=='f3j'}F3J{elseif $disc=='f3k'}F3K{elseif $disc=='td'}TD{/if})</a>
              <div class="clear"></div>
              <div class="submenu">
              	  <a href="?action={$action}&disc=all">All</a>	<em class="submenu-decoration"></em>
              	  <a href="?action={$action}&disc=f3b">F3B</a>	<em class="submenu-decoration"></em>
                  <a href="?action={$action}&disc=f3f">F3F</a>	<em class="submenu-decoration"></em>
                  <a href="?action={$action}&disc=f3j">F3J</a>	<em class="submenu-decoration"></em>
                  <a href="?action={$action}&disc=f3k">F3K</a>	<em class="submenu-decoration"></em>
                  <a href="?action={$action}&disc=td">TD</a>	<em class="submenu-decoration"></em>
              </div>
          </div> 

          <div class="menu-item">
              <strong class="home-icon"></strong>
              <a class="{if $current_menu=='home'}menu-enabled{else}menu-disabled{/if}" href="/">Home</a>
          </div> 
          
          <div class="menu-item">
              <strong class="gallery-icon"></strong>
              <a class="{if $current_menu=='locations'}menu-enabled{else}menu-disabled{/if} deploy-submenu" href="#">Flying Locations</a>
              <div class="clear"></div>
              <div class="submenu">
              	  <a href="/?action=location&country_id=0&state_id=0&search=">Location Browse</a> 	  <em class="submenu-decoration"></em>
                  <a href="/?action=location&function=location_map&country_id=0&state_id=0&search=">Location Map</a>         <em class="submenu-decoration"></em>
              </div>
          </div> 
          
          <div class="menu-item">
               <strong class="features-icon"></strong>
              <a class="{if $current_menu=='planes'}menu-enabled{else}menu-disabled{/if} deploy-submenu" href="#">F3X Planes</a>
              <div class="clear"></div>
              <div class="submenu">
                  <a href="/?action=plane&search=">Plane Browse</a>        <em class="submenu-decoration"></em>
              </div>
          </div> 

          <div class="menu-item">
               <strong class="features-icon"></strong>
              <a class="{if $current_menu=='events'}menu-enabled{else}menu-disabled{/if} deploy-submenu" href="#">F3X Competitions</a>
              <div class="clear"></div>
              <div class="submenu">
              
                  <a href="/?action=event&function=event_view&event_id={$fsession.current_event_id}">View Current Event</a>        <em class="submenu-decoration"></em>
                  <a href="/?action=event&country_id=0&state_id=0&search=">Event Search</a>        <em class="submenu-decoration"></em>
                  <a href="/?action=series&country_id=0&state_id=0&search=">Series Browse</a>        <em class="submenu-decoration"></em>
              </div>
          </div>
          
          <div class="menu-item">
               <strong class="features-icon"></strong>
              <a class="{if $current_menu=='pilots'}menu-enabled{else}menu-disabled{/if} deploy-submenu" href="#">F3X Pilots</a>
              <div class="clear"></div>
              <div class="submenu">
                  <a href="/?action=my">My Profile</a>        <em class="submenu-decoration"></em>
                  <a href="/?action=pilot&country_id=0&state_id=0&search=">Browse Pilots</a>        <em class="submenu-decoration"></em>
                  <a href="/?action=message">Message Center</a>        <em class="submenu-decoration"></em>
              </div>
          </div>
          
          <div class="menu-item">
              <strong class="contact-icon"></strong>
              <a class="menu-disabled" href="/?action=main&function=main_feedback">Give Feedback</a>
          </div> 
          <div class="menu-item">
               <strong class="features-icon"></strong>
              <a class="menu-disabled" href="/?action=main&function=change_format&format=computer">View In Full Web Format</a>
          </div> 
      </div>
            
  	  <a href="#" class="sidebar-button"><em class="sidebar-button-facebook">FACEBOOK</em></a>
  	  <a href="#" class="sidebar-button"><em class="sidebar-button-twitter">TWITTER</em></a>
      <a href="#" class="sidebar-button"><em class="sidebar-button-rss">SUBSCRIBE</em></a>   
      <div class="clear"></div>
      
  </div>
</div>
