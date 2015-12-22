<!DOCTYPE html>
<html lang="en" style="background: white;">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
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

	<link href="/new/css/f3x.min.css" rel="stylesheet">
	<!--SCRIPT-->
	<!--=================================================-->

	{block name="header"}{/block}
</head>
<body style="background: white;">
	<div>
		<div id="page-content">
			{block name="content"}{/block}
		</div>
	</div>
	<!--jQuery [ REQUIRED ]-->
	<script src="js/jquery-2.1.1.min.js"></script>

	<!--BootstrapJS [ RECOMMENDED ]-->
	<script src="js/bootstrap.min.js"></script>

	<!--Bootstrap Select [ OPTIONAL ]-->
	<script src="plugins/bootstrap-select/bootstrap-select.min.js"></script>

	<!--Nifty Admin [ RECOMMENDED ]-->
	<script src="js/nifty.min.js"></script>
	{block name="footer"}{/block}

</body>
</html>
