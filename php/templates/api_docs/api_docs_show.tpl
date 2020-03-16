{extends file='layout/layout_main.tpl'}

{block name="content"}

<div class="panel">
	<div class="panel-heading">
		<h2 class="heading">F3XVault API Documentation</h2>
	</div>
	<div class="panel-body">
	<p>
		<center>
			<img class="fixed-ratio-resize" src="images/API-icon.png"><br>
		</center>
		<h1>Introduction</h1>
		I have created a simple API (Applications Programming Interface) for developers that are creating software that can interact with the databases here at F3XVault.<br>
		<br>
		The method consists of simple HTTP GET or POST requests to the primary api URL. You must have a proper f3xvault login and password to access the API, and in some cases proper access to the particular data you are trying to modify.
		
		<h1>Main Parameters For Every Request</h1>
		Every request to the API has to be made with the following information :<br>
		<br>
		<table width="50%" class="table table-condensed table-bordered">
			<tr>
				<th width="20%">API URL</th><td>http://www.f3xvault.com/api.php?</td>
			</tr>
		</table>
		<table width="50%" class="table table-condensed table-bordered">
			<tr>
				<th colspan="2">Mandatory Request Parameters for every call (case sensitive parameter names)</th>
			</tr>
			<tr>
				<th width="20%">login</th><td>your user login name</td>
			</tr>
			<tr>
				<th width="20%">password</th><td>your user password</td>
			</tr>
			<tr>
				<th width="20%">function</th><td>the function that you wish to access (See below for function list)</td>
			</tr>
			<tr>
				<th colspan="2">Optional Request Parameters for every call (case sensitive parameter names)</th>
			</tr>
			<tr>
				<th width="20%">output_type</th><td>The type of output you want to get back. Defaults to standard text lines, but can be ( standard, xml, json )</td>
			</tr>
		</table>
		
		<h1>Function List</h1>
		This is the list of functions and their parameters to be posted, and the expected returned results and their format.<br>
		<br>
		
		{foreach $api_functions as $f}
		<table width="50%" class="table table-condensed table-bordered">
			<tr>
				<th width="20%">Function Name</th><td><b>{$f.function_name|escape}</b></td>
			</tr>
			<tr>
				<th width="20%">Function Description</th><td>{$f.function_description|escape}</td>
			</tr>
			<tr>
				<th width="20%">Function Input Parameters</th>
				<td>
					<table class="table table-condensed table-bordered">
						<tr>
							<th width="15%">Variable Name</th><th width="5%">Type</th><th width="5%">Mandatory</th><th>Description</th>
						</tr>
						{foreach $f.function_parameters as $p}
						<tr>
							<td nowrap><b>{$p.name|escape}</b></td>
							<td nowrap>{$p.type|escape}</td>
							<td>{if $p.mandatory}<font color="green">YES</font>{else}No{/if}</td>
							<td>{$p.description|escape}</td>
						</tr>
						{/foreach}
						{if $f.additional_parameters}
						{foreach $f.additional_parameters as $type => $a}
						{if $a}
						<tr>
							<th colspan="4">Additional Parameters for {$type|escape} event type</th>
						</tr>
						{foreach $a as $p}
						<tr>
							<td nowrap><b>{$p.name|escape}</b></td>
							<td nowrap>{$p.type|escape}</td>
							<td>{if $p.mandatory}<font color="green">YES</font>{else}No{/if}</td>
							<td>{$p.description|escape}</td>
						</tr>
						{/foreach}
						{/if}
						{/foreach}
						{/if}
					</table>
				</td>
			</tr>
			<tr>
				<th width="20%">Function Output</th><td><pre style="white-space:pre-wrap;">{$f.function_output_description|escape}</pre></td>
			</tr>
		</table>
		{/foreach}
		
		<h1>API Output</h1>
		The output from the API is an array of lines.<br>
		<br>
		The first line will ALWAYS contain the status of the call (0 = failure, 1 = success).<br>
		<br>
		The lines after that will depend on the function, and are given in the above command descriptions. Some of the functions will output a header line to label each column of data. All elements are in double quoted CSV format, so any parser you have will need to take that into account.<br>
		<br>
		In order to avoid data mining, no sensitive information is available in the API calls, such as email addresses.
				
		<h1>Conclusion</h1>
		I hope that this information for integrating your system to use the f3xvault databases is complete enough. If you have any questions, you can send me feedback through the feedback form.<br>
		<br>
		Thanks!!!<br>
		<br>
		Tim
	</p>
	</div>
</div>
<form name="browse_locations" method="GET">
<input type="hidden" name="action" value="location">
</form>
 
{/block}