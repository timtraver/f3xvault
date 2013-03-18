<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title>RC Vault</title>
<link href="style.css" rel="stylesheet" type="text/css">
<link rel='stylesheet' id='admin-bar-css'  href='/wp-includes/css/admin-bar.min.css?ver=3.5.1' type='text/css' media='all' />
<link rel='stylesheet' id='theme-my-login-css'  href='/wp-content/plugins/theme-my-login/theme-my-login.css?ver=6.2.2' type='text/css' media='all' /><link rel='stylesheet' id='graphene-stylesheet-css'  href='/wp-content/themes/graphene/style.css?ver=3.5.1' type='text/css' media='screen' />
<link rel='stylesheet' id='graphene-light-header-css'  href='/wp-content/themes/graphene/style-light.css?ver=3.5.1' type='text/css' media='screen' />
<!-- Add jQuery library -->
<script type="text/javascript" src="/f3x/includes/jquery.min.js"></script>
<!-- Add mousewheel plugin (this is optional) -->
<script type="text/javascript" src="/f3x/includes/fancybox/lib/jquery.mousewheel-3.0.6.pack.js"></script>
<!-- Add fancyBox -->
<link rel="stylesheet" href="/f3x/includes/fancybox/source/jquery.fancybox.css?v=2.1.0" type="text/css" media="screen" />
<script type="text/javascript" src="/f3x/includes/fancybox/source/jquery.fancybox.pack.js?v=2.1.0"></script>
<!-- Optionally add helpers - button, thumbnail and/or media -->
<link rel="stylesheet" href="/f3x/includes/fancybox/source/helpers/jquery.fancybox-buttons.css?v=1.0.3" type="text/css" media="screen" />
<script type="text/javascript" src="/f3x/includes/fancybox/source/helpers/jquery.fancybox-buttons.js?v=1.0.3"></script>
<script type="text/javascript" src="/f3x/includes/fancybox/source/helpers/jquery.fancybox-media.js?v=1.0.3"></script>
<link rel="stylesheet" href="/f3x/includes/fancybox/source/helpers/jquery.fancybox-thumbs.css?v=1.0.6" type="text/css" media="screen" />
<script type="text/javascript" src="/f3x/includes/fancybox/source/helpers/jquery.fancybox-thumbs.js?v=1.0.6"></script>
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
		closeEffect : 'none',

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
});
</script>
<link rel="stylesheet" type="text/css" href="/f3x/includes/jquery-ui/css/cupertino/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/f3x/includes/jquery-ui/css/cupertino/jquery.ui.theme.css">
<style type="text/css">
#header-menu-wrap{ background: #2982C5; background: -moz-linear-gradient(#84b9f9, #2982C5); background: -webkit-linear-gradient(#84b9f9, #2982C5); background: -o-linear-gradient(#84b9f9, #2982C5); -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorStr='#84b9f9', EndColorStr='#2982C5')"; background: linear-gradient(#84b9f9, #2982C5); }#header-menu > li:hover,#header-menu > li.current-menu-item,#header-menu > li.current-menu-ancestor{ background: #2982C5; background: -moz-linear-gradient(#eee, #2982C5); background: -webkit-linear-gradient(#eee, #2982C5); background: -o-linear-gradient(#eee, #2982C5); -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorStr='#eee', EndColorStr='#2982C5')"; background: linear-gradient(#eee, #2982C5); }#header-menu > li:hover > a, #header-menu > li.current-menu-item > a, #header-menu > li.current-menu-ancestor > a {color: #ffffff}#header-menu ul li:hover,#header-menu ul li.current-menu-item,#header-menu ul li.current-menu-ancestor,.primary-menu-preview.dropdown ul li.current-menu-item,.primary-menu-preview.dropdown ul li.current-menu-ancestor{ background: #2982C5; background: -moz-linear-gradient(#fdfdfd, #2982C5); background: -webkit-linear-gradient(#fdfdfd, #2982C5); background: -o-linear-gradient(#fdfdfd, #2982C5); -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorStr='#fdfdfd', EndColorStr='#2982C5')"; background: linear-gradient(#fdfdfd, #2982C5); }#footer,.graphene-footer{background-color:#1f6eb6;color:#999}.header_title, .header_title a, .header_title a:visited, .header_title a:hover, .header_desc {color:#090fa3}#sidebar_bottom .sidebar-wrap{width:301px}#header .header_title{ font-family:arial;font-size:18;font-weight:700; }#header{height:100px}.container_16 {width:1024px}.container_16 .grid_1{width:40px}.container_16 .prefix_1{padding-left:60px}.container_16 .suffix_1{padding-right:60px}.container_16 .push_1{left:60px}.container_16 .pull_1{left:-60px}.container_16 .grid_2{width:100px}.container_16 .prefix_2{padding-left:120px}.container_16 .suffix_2{padding-right:120px}.container_16 .push_2{left:120px}.container_16 .pull_2{left:-120px}.container_16 .grid_3{width:160px}.container_16 .prefix_3{padding-left:180px}.container_16 .suffix_3{padding-right:180px}.container_16 .push_3{left:180px}.container_16 .pull_3{left:-180px}.container_16 .grid_4{width:220px}.container_16 .prefix_4{padding-left:240px}.container_16 .suffix_4{padding-right:240px}.container_16 .push_4{left:240px}.container_16 .pull_4{left:-240px}.container_16 .grid_5{width:280px}.container_16 .prefix_5{padding-left:300px}.container_16 .suffix_5{padding-right:300px}.container_16 .push_5{left:300px}.container_16 .pull_5{left:-300px}.container_16 .grid_6{width:340px}.container_16 .prefix_6{padding-left:360px}.container_16 .suffix_6{padding-right:360px}.container_16 .push_6{left:360px}.container_16 .pull_6{left:-360px}.container_16 .grid_7{width:400px}.container_16 .prefix_7{padding-left:420px}.container_16 .suffix_7{padding-right:420px}.container_16 .push_7{left:420px}.container_16 .pull_7{left:-420px}.container_16 .grid_8{width:460px}.container_16 .prefix_8{padding-left:480px}.container_16 .suffix_8{padding-right:480px}.container_16 .push_8{left:480px}.container_16 .pull_8{left:-480px}.container_16 .grid_9{width:520px}.container_16 .prefix_9{padding-left:540px}.container_16 .suffix_9{padding-right:540px}.container_16 .push_9{left:540px}.container_16 .pull_9{left:-540px}.container_16 .grid_10{width:580px}.container_16 .prefix_10{padding-left:600px}.container_16 .suffix_10{padding-right:600px}.container_16 .push_10{left:600px}.container_16 .pull_10{left:-600px}.container_16 .grid_11{width:640px}.container_16 .prefix_11{padding-left:660px}.container_16 .suffix_11{padding-right:660px}.container_16 .push_11{left:660px}.container_16 .pull_11{left:-660px}.container_16 .grid_12{width:700px}.container_16 .prefix_12{padding-left:720px}.container_16 .suffix_12{padding-right:720px}.container_16 .push_12{left:720px}.container_16 .pull_12{left:-720px}.container_16 .grid_13{width:760px}.container_16 .prefix_13{padding-left:780px}.container_16 .suffix_13{padding-right:780px}.container_16 .push_13{left:780px}.container_16 .pull_13{left:-780px}.container_16 .grid_14{width:820px}.container_16 .prefix_14{padding-left:840px}.container_16 .suffix_14{padding-right:840px}.container_16 .push_14{left:840px}.container_16 .pull_14{left:-840px}.container_16 .grid_15{width:880px}.container_16 .prefix_15{padding-left:900px}.container_16 .suffix_15{padding-right:900px}.container_16 .push_15{left:900px}.container_16 .pull_15{left:-900px}.container_16 .grid_16{width:940px}.container_16 .prefix_16{padding-left:960px}.container_16 .suffix_16{padding-right:960px}.container_16 .push_16{left:960px}.container_16 .pull_16{left:-960px}.header-img {margin-left: -512px}#content-main, #content-main .grid_11, .container_16 .slider_post, #comments #respond {width:840px}#sidebar1, #sidebar2 {width:140px}.comment-form-author, .comment-form-email, .comment-form-url {width:260px}.graphene-form-field {width:252px}#commentform textarea {width:812px}
</style>
	<!--[if lte IE 7]>
      <style type="text/css" media="screen">
      	#footer, div.sidebar-wrap, .block-button, .featured_slider, #slider_root, #nav li ul, .pie{behavior: url(/wp-content/themes/graphene/js/PIE.php);}
        .featured_slider{margin-top:0 !important;}
        #header-menu-wrap {z-index:5}
      </style>
    <![endif]-->
<style type="text/css">.recentcomments a{display:inline !important;padding:0 !important;margin:0 !important;}</style>
<style type="text/css" media="screen">
	html { margin-top: 28px !important; }
	* html body { margin-top: 28px !important; }
</style>
<style type="text/css" id="custom-background-css">
body.custom-background { background-image: url('/f3x/images/vampire_launch.jpg'); background-repeat: repeat; background-position: top left; background-attachment: fixed; }
</style>
{/literal}
</head>
<body class="home blog logged-in admin-bar no-customize-support custom-background two_col_left two-columns">
<div id="container" class="container_16">
	<div id="header">
		<img src="/f3x/images/vampire_launch.jpg" alt="" class="header-img" style="z-index:0;"/>        	       
		<h1 class="header_title push_1 grid_15">RC Vault</h1>
		<h2 class="header_desc push_1 grid_15">RC Plane Databases and Timing of RC competitions</h2>
		{if $user.user_id!=0}
		<span style="color:white;z-index:1;float: right;font-size: 18px;position: relative;padding-top:15px;padding-right:80px;">Welcome {$user.user_first_name}</span>
		{/if}
	</div>
    {include file="menu.tpl"}
    <div id="content" class="clearfix hfeed">
		<div id="content-main" class="clearfix grid_11" style="width:1000px;">