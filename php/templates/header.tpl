<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
	<head>
		<title>F3X Vault</title>
		<link rel="icon" type="image/ico" href="/favicon.ico">
		<link rel='stylesheet' id='graphene-stylesheet-css' href='/graphene.css' type='text/css' media='screen' />
		<link rel='stylesheet' id='graphene-light-header-css' href='/graphene-style-light.css' type='text/css' media='screen' />
		
		<!-- Add jQuery library -->
		<script type="text/javascript" src="/includes/jquery.min.js"></script>
		<!-- Add mousewheel plugin (this is optional) -->
		<script type="text/javascript" src="/includes/fancybox/lib/jquery.mousewheel-3.0.6.pack.js"></script>
		<!-- Add fancyBox -->
		<link rel="stylesheet" href="/includes/fancybox/source/jquery.fancybox.css?v=2.1.0" type="text/css" media="screen" />
		<script type="text/javascript" src="/includes/fancybox/source/jquery.fancybox.pack.js?v=2.1.0"></script>
		<!-- Optionally add helpers - button, thumbnail and/or media -->
		<link rel="stylesheet" href="/includes/fancybox/source/helpers/jquery.fancybox-buttons.css?v=1.0.3" type="text/css" media="screen" />
		<script type="text/javascript" src="/includes/fancybox/source/helpers/jquery.fancybox-buttons.js?v=1.0.3"></script>
		<script type="text/javascript" src="/includes/fancybox/source/helpers/jquery.fancybox-media.js?v=1.0.3"></script>
		<link rel="stylesheet" href="/includes/fancybox/source/helpers/jquery.fancybox-thumbs.css?v=1.0.6" type="text/css" media="screen" />
		<script type="text/javascript" src="/includes/fancybox/source/helpers/jquery.fancybox-thumbs.js?v=1.0.6"></script>
		{literal}
		<script type="text/javascript">
			$(document).ready(function() {
				$('.fancybox-media').fancybox({
					openEffect  : 'none',
					closeEffect : 'none',
					helpers : {
						title	: { type : 'inside'},
						media : {},
						buttons	: {}
					}
				});
				$('.fancybox-map').fancybox({
					openEffect  : 'none',
					autoSize   : false,
					closeEffect : 'none',
					type : 'iframe',
					iframe : {
						preload : false // this will prevent to place map off center
					},
					helpers : {
						title	: { type : 'inside'},
						media : {},
						buttons	: {}
					}
				});
				$(".fancybox").fancybox();
				$(".fancybox-button").fancybox({
					prevEffect		: 'none',
					nextEffect		: 'none',
					closeBtn		: false,
					beforeShow: function () {
						if (this.title) {
							// New line
							this.title += '<br />';                
							// Add FaceBook like button
							this.title += '<iframe src="//www.facebook.com/plugins/like.php?href=' + this.href + '&amp;layout=button_count&amp;show_faces=true&amp;width=500&amp;action=like&amp;font&amp;colorscheme=light&amp;height=23" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:110px; height:23px;" allowTransparency="true"></iframe>';
						}
					},
					helpers: {
						title	: { type : 'inside' },
						buttons	: {}
					}
				});
				$(".fancybox-trigger").click(function() {
					$("a[rel='" + $(this).data('trigger-rel') + "']").eq(0).trigger('click');
					return false;

				});
			});
		</script>
		<link rel="stylesheet" type="text/css" href="/includes/jquery-ui/css/rcvault/jquery-ui.css">
		<link rel="stylesheet" type="text/css" href="/includes/jquery-ui/css/rcvault/jquery.ui.theme.css">
		<link href="style2.css" rel="stylesheet" type="text/css">
{/literal}
</head>
<body class="home custom-background">
	<div id="global-nav">
		<div class="embossed-nav">
		F3X Disciplines - 
		</div>
		<div id="nav-all" class="embossed-nav">
			<a href="?action={$action}&disc=all"{if $disc=='all' || $disc==''} style="color:red;"{/if}>All</a>
		</div>
		<div id="nav-f3b" class="embossed-nav">
			<a href="?action={$action}&disc=f3b"{if $disc=='f3b'} style="color:red;"{/if}>F3B</a>
		</div>
		<div id="nav-f3f" class="embossed-nav">
			<a href="?action={$action}&disc=f3f"{if $disc=='f3f'} style="color:red;"{/if}>F3F</a>
		</div>
		<div id="nav-f3j" class="embossed-nav">
			<a href="?action={$action}&disc=f3j"{if $disc=='f3j'} style="color:red;"{/if}>F3J</a>
		</div>
		<div id="nav-f3k" class="embossed-nav">
			<a href="?action={$action}&disc=f3k"{if $disc=='f3k'} style="color:red;"{/if}>F3K</a>
		</div>
		<div id="nav-td" class="embossed-nav">
			<a href="?action={$action}&disc=td"{if $disc=='td'} style="color:red;"{/if}>TD</a>
		</div>
		{if $user.user_id!=0}
			<a href="?action=main&function=logout"><input id="welcome-button" type="button" value="Log Out" class="button"></a>
			<a href="?action=admin"><input id="welcome-button" type="button" value="Admin" class="button"></a>
			<a href="?action=message"><input id="welcome-button" type="button" value="Welcome {$user.user_first_name|escape}{if $unread_messages>0} ({$unread_messages} unread messages){/if}" class="button"></a>
		{else}
			<a href="?action=register"><input id="welcome-button" type="button" value="Register" class="button"></a>
			<a href="?action=main&function=login"><input id="welcome-button" type="button" value="Log In" class="button"></a>
		{/if}
	</div>
	<div id="container" class="container_16">
		<div id="header">
			<img src="/images/vampire_launch.jpg" alt="" class="header-img" style="z-index:0;width: 100%;"/>
			<h1 class="header_title push_1">F3X Vault</h1>
			<h2 class="header_desc push_1">Databases and Scoring of F3X Gliding Disciplines</h2>
		</div>
		{include file="menu.tpl"}
		<div class="menu-bottom-shadow">&nbsp;</div>
		<div id="content" class="clearfix hfeed">
			<div id="content-main" class="clearfix grid_11">