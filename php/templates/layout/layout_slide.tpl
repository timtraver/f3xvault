<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>F3X Vault</title>
	
	<!--STYLESHEET-->
	<!--=================================================-->

	<!--Open Sans Font [ OPTIONAL ] -->
 	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&amp;subset=latin" rel="stylesheet">

	<!--Bootstrap Stylesheet [ REQUIRED ]-->
	<link href="css/bootstrap.min.css" rel="stylesheet">


	<!--Nifty Stylesheet [ REQUIRED ]-->
	<link href="css/nifty.css" rel="stylesheet">
	
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
	<style>
		.cb-slideshow li:nth-child(1) span {ldelim}
			background-image: url('../rand_img.php?user_id={$user_id|escape}')
		{rdelim}
		.cb-slideshow li:nth-child(2) span {ldelim}
		    background-image: url('../rand_img.php?user_id={$user_id|escape}&2');
		    -webkit-animation-delay: 6s;
		    -moz-animation-delay: 6s;
		    -o-animation-delay: 6s;
		    -ms-animation-delay: 6s;
		    animation-delay: 6s;
		{rdelim}
		.cb-slideshow li:nth-child(3) span {ldelim}
		    background-image: url('../rand_img.php?user_id={$user_id|escape}&3');
		    -webkit-animation-delay: 12s;
		    -moz-animation-delay: 12s;
		    -o-animation-delay: 12s;
		    -ms-animation-delay: 12s;
		    animation-delay: 12s;
		{rdelim}
		.cb-slideshow li:nth-child(4) span {ldelim}
		    background-image: url('../rand_img.php?user_id={$user_id|escape}&4');
		    -webkit-animation-delay: 18s;
		    -moz-animation-delay: 18s;
		    -o-animation-delay: 18s;
		    -ms-animation-delay: 18s;
		    animation-delay: 18s;
		{rdelim}
		.cb-slideshow li:nth-child(5) span {ldelim}
		    background-image: url('../rand_img.php?user_id={$user_id|escape}&5');
		    -webkit-animation-delay: 24s;
		    -moz-animation-delay: 24s;
		    -o-animation-delay: 24s;
		    -ms-animation-delay: 24s;
		    animation-delay: 24s;
		{rdelim}
		.cb-slideshow li:nth-child(6) span {ldelim}
		    background-image: url('../rand_img.php?user_id={$user_id|escape}&6');
		    -webkit-animation-delay: 30s;
		    -moz-animation-delay: 30s;
		    -o-animation-delay: 30s;
		    -ms-animation-delay: 30s;
		    animation-delay: 30s;
		{rdelim}
		.cb-slideshow li:nth-child(7) span {ldelim}
		    background-image: url('../rand_img.php?user_id={$user_id|escape}&7');
		    -webkit-animation-delay: 36s;
		    -moz-animation-delay: 36s;
		    -o-animation-delay: 36s;
		    -ms-animation-delay: 36s;
		    animation-delay: 36s;
		{rdelim}
		.cb-slideshow li:nth-child(8) span {ldelim}
		    background-image: url('../rand_img.php?user_id={$user_id|escape}&8');
		    -webkit-animation-delay: 42s;
		    -moz-animation-delay: 42s;
		    -o-animation-delay: 42s;
		    -ms-animation-delay: 42s;
		    animation-delay: 42s;
		{rdelim}
		.cb-slideshow li:nth-child(9) span {ldelim}
		    background-image: url('../rand_img.php?user_id={$user_id|escape}&9');
		    -webkit-animation-delay: 48s;
		    -moz-animation-delay: 48s;
		    -o-animation-delay: 48s;
		    -ms-animation-delay: 48s;
		    animation-delay: 48s;
		{rdelim}
		.cb-slideshow li:nth-child(10) span {ldelim}
		    background-image: url('../rand_img.php?user_id={$user_id|escape}&10');
		    -webkit-animation-delay: 54s;
		    -moz-animation-delay: 54s;
		    -o-animation-delay: 54s;
		    -ms-animation-delay: 54s;
		    animation-delay: 54s;
		{rdelim}
	</style>
</head>
<body id="page">
	<ul class="cb-slideshow" style="list-style-type:none;">
		<li><span>Image 01</span></li>
		<li><span>Image 02</span></li>
		<li><span>Image 03</span></li>
		<li><span>Image 04</span></li>
		<li><span>Image 05</span></li>
		<li><span>Image 06</span></li>
		<li><span>Image 07</span></li>
		<li><span>Image 08</span></li>
		<li><span>Image 09</span></li>
	</ul>
	{block name="content"}{/block}
	
	<div style="position: fixed;bottom: 0;width: 100%;margin-bottom: 20px;text-align: center;">
		{if $user_id}
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
