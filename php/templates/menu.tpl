<div id="nav">
	<div id="header-menu-wrap" class="clearfix">
		<ul id="header-menu" class="menu clearfix">
			<li id="menu-item-31" class="menu-item menu-item-type-custom menu-item-object-custom current-menu-item current_page_item menu-item-home"><a href="/f3x/"><strong>Home</strong></a></li>
			<li id="menu-item-19" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-ancestor"><a href="/f3x/?action=main&function=view_locations"><strong>RC Locations</strong></a>
				<ul class="sub-menu">
					<li id="menu-item-36" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=location">Location Browse</a></li>
				</ul>
			</li>
			<li id="menu-item-33" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-ancestor"><a href="/f3x/?action=main&function=view_planes"><strong>RC Plane Database</strong></a>
				<ul class="sub-menu">
					<li id="menu-item-38" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=plane">Database Browse</a></li>
				</ul>
			</li>
			<li id="menu-item-34" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-ancestor"><a href="/f3x/?action=main&function=view_events"><strong>RC Events</strong></a>
				<ul class="sub-menu">
					<li id="menu-item-58" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=event">Event Browse</a></li>
					<li id="menu-item-88" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=series">Series Browse</a></li>
				</ul>
			</li>
			<li id="menu-item-81" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-ancestor"><a href="/f3x/?action=main&function=view_pilots"><strong>Pilot Profiles</strong></a>
				<ul class="sub-menu">
					<li id="menu-item-77" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=my">My Pilot Profile</a></li>
					<li id="menu-item-78" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=pilot">Browse Pilot Profiles</a></li>
				</ul>
			</li>
			<li id="menu-item-84" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-ancestor"><a href="/f3x/?action=main&function=view_clubs"><strong>RC Clubs</strong></a>
				<ul class="sub-menu">
					<li id="menu-item-85" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=club">RC Clubs Browse</a></li>
				</ul>
			</li>
			{if $user.user_id!=0}
			<li id="menu-item-50" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=main&function=logout"><strong>Log Out</strong></a></li>
			{else}
			<li id="menu-item-50" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=main&function=login"><strong>Log In</strong></a></li>
			<li id="menu-item-50" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=register"><strong>Register</strong></a></li>
			{/if}
			{if $user.user_admin==1}
			<li id="menu-item-50" class="menu-item menu-item-type-custom menu-item-object-custom"><a href="/f3x/?action=admin"><strong>Admin</strong></a></li>
			{/if}
		</ul>            
	</div>
	<div class="menu-bottom-shadow">&nbsp;</div>
</div>
