<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>F3X Vault</title>
	
	<!--STYLESHEET-->
	<!--=================================================-->

	<!--Open Sans Font [ OPTIONAL ] -->
 	<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&amp;subset=latin" rel="stylesheet">

	<!--Bootstrap Stylesheet [ REQUIRED ]-->
	<link href="css/bootstrap.min.css" rel="stylesheet">


	<!--Nifty Stylesheet [ REQUIRED ]-->
	<link href="css/nifty.min.css" rel="stylesheet">
	
	<!--Font Awesome [ OPTIONAL ]-->
	<link href="css/font-awesome.min.css" rel="stylesheet">

	<!--Bootstrap Select [ OPTIONAL ]-->
	<link href="plugins/bootstrap-select/bootstrap-select.css" rel="stylesheet">

	<!--=================================================-->
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="css/style2.css" />
	<script type="text/javascript" src="js/modernizr.custom.86080.js"></script>
	{block name="header"}{/block}

	<!--Page Load Progress Bar [ OPTIONAL ]-->
	<link href="css/pace.min.css" rel="stylesheet">
	<script src="js/pace.min.js"></script>

</head>
<body id="page">
	<ul class="cb-slideshow" style="list-style-type:none;">
		<li><span>Image 01</span></li>
	</ul>
	{block name="content"}{/block}
	
	<div style="position: fixed;bottom: 0;width: 100%;margin-bottom: 20px;text-align: center;">
		{if $user_only}
			<h5>User Slideshow</h5>
		{else}
			<h5>Slideshow pictures are from randomly submitted media by pilots around the world</h5>
		{/if}
	</div>

	<!--jQuery [ REQUIRED ]-->
	<script src="js/jquery-2.1.1.min.js"></script>


	<!--BootstrapJS [ RECOMMENDED ]-->
	<script src="js/bootstrap.min.js"></script>


	<!--Fast Click [ OPTIONAL ]-->
	<script src="plugins/fast-click/fastclick.min.js"></script>

	
	<!--Nifty Admin [ RECOMMENDED ]-->
	<script src="js/nifty.min.js"></script>

	<!-- google analytics code -->
	{literal}
	<script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		ga('create', 'UA-38521011-2', 'auto');
		ga('send', 'pageview');
	</script>
	{/literal}
</body>
</html>
