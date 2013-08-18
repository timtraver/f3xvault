<div id="nav">
	<div id="header-menu-wrap" class="clearfix">
		<ul id="header-menu" class="menu clearfix">
			<li class="menu-item menu-item-type-custom menu-item-object-custom {if $current_menu=='home'}current-menu-item{/if} menu-item-home"><a href="/"><strong>Home</strong></a></li>
			<li class="menu-item menu-item-type-post_type menu-item-object-page {if $current_menu=='locations'}current-menu-item{/if} menu-item-ancestor"><a href="/?action=main&function=view_locations"><strong>Locations</strong></a>
				<ul class="sub-menu">
					<li id="menu-item-36" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=location&country_id=0&state_id=0&search=">Location Browse</a></li>
					<li id="menu-item-36" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=location&function=location_map&country_id=0&state_id=0&search=">Location Map</a></li>
				</ul>
			</li>
			<li class="menu-item menu-item-type-post_type menu-item-object-page {if $current_menu=='planes'}current-menu-item{/if} menu-item-ancestor"><a href="/?action=main&function=view_planes"><strong>Planes</strong></a>
				<ul class="sub-menu">
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=plane&search=">Database Browse</a></li>
				</ul>
			</li>
			<li class="menu-item menu-item-type-post_type menu-item-object-page {if $current_menu=='events'}current-menu-item{/if} menu-item-ancestor"><a href="/?action=main&function=view_events"><strong>Competitions</strong></a>
				<ul class="sub-menu">
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=event&country_id=0&state_id=0&search=">Event Browse</a></li>
					{if $fsession.current_event_id}
           			<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=event&function=event_view&event_id={$fsession.current_event_id}">View Last Event</a></li>
					{/if}
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=series&country_id=0&state_id=0&search=">Series Browse</a></li>
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=records&country_id=0&page=1&perpage=20">F3F and F3B Records</a></li>
				</ul>
			</li>
			<li class="menu-item menu-item-type-post_type menu-item-object-page {if $current_menu=='pilots'}current-menu-item{/if} menu-item-ancestor"><a href="/?action=main&function=view_pilots"><strong>Pilot Profiles</strong></a>
				<ul class="sub-menu">
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=my">My Pilot Profile</a></li>
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=pilot&country_id=0&state_id=0&search=">Browse Pilot Profiles</a></li>
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=message">Message Center</a></li>
				</ul>
			</li>
			<li class="menu-item menu-item-type-post_type menu-item-object-page {if $current_menu=='clubs'}current-menu-item{/if} menu-item-ancestor"><a href="/?action=main&function=view_clubs"><strong>Clubs</strong></a>
				<ul class="sub-menu">
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=club&country_id=0&state_id=0&search=">F3X Clubs Browse</a></li>
				</ul>
			</li>
			<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=main&function=main_feedback"><strong>Todo</strong></a></li>
		</ul>
	</div>
</div>
