<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=0.75, minimum-scale=0.25">
	<title>F3X Vault</title>
	
	<!--STYLESHEET-->
	<!--=================================================-->

	<!--Open Sans Font [ OPTIONAL ] -->
 	<!-- <link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&amp;subset=latin" rel="stylesheet">
	 -->

	<!--Bootstrap Stylesheet [ REQUIRED ]-->
	<link href="css/bootstrap.min.css" rel="stylesheet">

	<!--Nifty Stylesheet [ REQUIRED ]-->
	<link href="css/nifty.css" rel="stylesheet">

	<link rel="stylesheet" type="text/css" href="/includes/jquery-ui/css/rcvault/jquery-ui.css">
	<link rel="stylesheet" type="text/css" href="/includes/jquery-ui/css/rcvault/jquery.ui.theme.css">
	
	<!--Font Awesome [ OPTIONAL ]-->
	<link href="css/font-awesome.min.css" rel="stylesheet">

	<!--Bootstrap Select [ OPTIONAL ]-->
	<link href="plugins/bootstrap-select/bootstrap-select.css" rel="stylesheet">

	<link href="css/f3x.min.css" rel="stylesheet">
	<!--SCRIPT-->
	<!--=================================================-->
	
	<!--Page Load Progress Bar [ OPTIONAL ]-->
	<link href="css/pace.min.css" rel="stylesheet">
	<script src="js/pace.min.js"></script>

    {if $debug}
        <link href="/css/debug-toolbar.css" rel="stylesheet" type="text/css">
    {/if}

	{block name="header"}{/block}
</head>
<body>
	<div id="container" class="effect mainnav-lg navbar-fixed">
		
		<!--NAVBAR-->
		<!--===================================================-->
		<header id="navbar">
			<div id="navbar-container" class="boxed">

				<!--================================-->
				<!--End brand logo & name-->
				<!--Navbar Dropdown-->
				<!--================================-->
				<div class="navbar-content clearfix" style="position: relative;height: 60px;">
					<img src="img/logo.png" height="40" width="40" style="float: left;margin-left: 10px;margin-top: 5px;" onClick="document.main.submit();">
					<h2 style="float: left;margin-left: 10px;font-size: 24px;padding-top: 5px;">
						Self Score Entry
					</h2>
					<input type="button" style = "float: right;margin-right: 15px;margin-top: 10px;font-size: large;" value=" Back " onClick="window.location.href='/?action=event&function=event_view&event_id={$event->info.event_id|escape:"javascript"}';" class="btn btn-primary btn-rounded">
					<input type="button" style = "float: right;margin-right: 15px;margin-top: 10px;font-size: large;" value=" Refresh " onClick="document.refresh.submit();" class="btn btn-primary btn-rounded">
				</div>
				<!--================================-->
				<!--End Navbar Dropdown-->

			</div>
		</header>
		<!--===================================================-->
		<!--END NAVBAR-->
				
		<div class="boxed">

			<!--CONTENT CONTAINER-->
			<!--===================================================-->
			<div id="content-container" style="padding-top: 55px;padding-bottom: 5px;padding-left: 0px;padding-right: 0px;">
				<div id="page-content">
					{block name="content"}{/block}
				</div>
			</div>
			<!--===================================================-->
			<!--END CONTENT CONTAINER-->			


	</div>
	<!--===================================================-->
	<!-- END OF CONTAINER -->
	
	<!--JAVASCRIPT-->
	<!--=================================================-->
	<!--jQuery [ REQUIRED ]-->
	<script src="js/jquery-2.1.1.min.js"></script>

	<!--BootstrapJS [ RECOMMENDED ]-->
	<script src="js/bootstrap.min.js"></script>

	<!--Bootstrap Select [ OPTIONAL ]-->
	<script src="plugins/bootstrap-select/bootstrap-select.min.js"></script>
	
	<!--Nifty Admin [ RECOMMENDED ]-->
	<script src="js/nifty.min.js"></script>

	<!--Fast Click [ OPTIONAL ]-->
	<script src="js/fastclick.min.js"></script>

	{block name="footer"}{/block}
	{block name="footer2"}{/block}

	<script>
		$( "#main_logo" ).hide();
		setInterval(function(){ldelim}
		$( "#main_logo" ).fadeIn(2000).fadeOut(500);
		{rdelim},0);
	</script>
	<script type="text/javascript">
		$(document).ready(function() {ldelim}
			var sw = nifty.container.width();
			if (sw <= 740) {ldelim}
				nifty.container.addClass('mainnav-sm').removeClass('mainnav-lg');
			{rdelim}
		{rdelim})
	</script>

	<script type="text/javascript">
		$(document).ready(function() {ldelim}
			{foreach $messages as $m}
				$.niftyNoty({ldelim}
					type: '{if $m.message_color == 'green'}success{else}danger{/if}',
					icon: 'fa {if $m.message_color == 'green'}fa-thumbs-o-up{else}fa-thumbs-o-down{/if}',
					container : 'floating',
					title : '{$m.message|escape:"javascript"}',
					timer : 10000
				{rdelim});
			{/foreach}
		{rdelim});
	</script>
	{if $first_view}
		<script type="text/javascript">
			$(document).ready(function() {ldelim}
				$.niftyNoty({ldelim}
					type: 'warning',
					icon: 'fa fa-arrow-left',
					container : 'floating',
					title : 'Click on the Blinking <img src="img/logo.png" width="35"> Plane Icon for Menu',
					timer : 10000
				{rdelim});
			{rdelim});
		</script>
	{/if}

	<!--

	REQUIRED
	You must include this in your project.

	RECOMMENDED
	This category must be included but you may modify which plugins or components which should be included in your project.

	OPTIONAL
	Optional plugins. You may choose whether to include it in your project or not.


	Detailed information and more samples can be found in the document.

	-->
	<form name="donate" method="GET" action="https://www.paypal.com/cgi-bin/webscr" target="_blank">
	<input name="cmd" type="hidden" value="_xclick">
	<input name="business" type="hidden" value="timtraver@gmail.com">
	<input name="currency_code" type="hidden" value="USD">
	<input name="item_name" type="hidden" value="F3XVault Donation">
	<input name="amount" type="hidden" value="">
	</form>
	<form name="logmein" method="POST">
	<input name="action" type="hidden" value="main">
	<input name="function" type="hidden" value="login">
	</form>
	<form id="goback" name="goback" method="GET">
	<input type="hidden" name="action" value="event">
	<input type="hidden" name="function" value="event_view">
	<input type="hidden" name="event_id" value="{$event->info.event_id|escape}">
	</form>
	<form id="goback" name="refresh" method="GET">
	<input type="hidden" name="action" value="event">
	<input type="hidden" name="function" value="event_self_entry">
	<input type="hidden" name="save" value="0">
	<input type="hidden" name="event_id" value="{$event->info.event_id|escape}">
	<input type="hidden" name="event_pilot_id" value="{$event_pilot_id|escape}">
	<input type="hidden" name="round_number" value="{$round_number|escape}">
	</form>


	<!-- google analytics code -->
	{literal}
	<script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		ga('create', 'UA-38521011-2', 'auto');
		ga('send', 'pageview');
	</script>
	{/literal}
	{if $debug}
		{debug}
	{/if}
</body>
</html>
