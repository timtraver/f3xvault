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
			<li class="menu-item menu-item-type-post_type menu-item-object-page {if $current_menu=='planes'}current-menu-item{/if} menu-item-ancestor"><a href="/?action=main&function=view_planes"><strong>Plane Database</strong></a>
				<ul class="sub-menu">
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=plane&search=">Database Browse</a></li>
				</ul>
			</li>
			<li class="menu-item menu-item-type-post_type menu-item-object-page {if $current_menu=='events'}current-menu-item{/if} menu-item-ancestor"><a href="/?action=main&function=view_events"><strong>Events</strong></a>
				<ul class="sub-menu">
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=event&country_id=0&state_id=0&search=">Event Browse</a></li>
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=series&country_id=0&state_id=0&search=">Series Browse</a></li>
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
					<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=club&country_id=0&state_id=0&search=">RC Clubs Browse</a></li>
				</ul>
			</li>
			{if $user.user_id!=0}
			<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=main&function=logout"><strong>Log Out</strong></a></li>
			{else}
			<li class="menu-item menu-item-type-custom menu-item-object-custom {if $current_menu=='login'}current-menu-item{/if}"><a href="/?action=main&function=login"><strong>Log In</strong></a></li>
			<li class="menu-item menu-item-type-custom menu-item-object-custom {if $current_menu=='register'}current-menu-item{/if}"><a href="/?action=register"><strong>Register</strong></a></li>
			{/if}
			{if $user.user_admin==1}
			<li class="menu-item menu-item-type-custom menu-item-object-custom {if $current_menu=='admin'}current-menu-item{/if}"><a href="/?action=admin"><strong>Admin</strong></a></li>
			{/if}
			<li class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/?action=main&function=main_feedback"><strong>Todo</strong></a></li>
		</ul>            
	</div>
	<div class="menu-bottom-shadow">&nbsp;</div>
</div>
