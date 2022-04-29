{capture name='_smarty_debug' assign=debug_output}
<div id="debug-toolbar">
	<div id="debug-toolbar-bar">
		<div class="close-wrapper">
			<a href="javascript:;" class="close">&times;</a>
		</div>
		<ul class="debug-toolbar-menu">
			<li class="title">Debug Console</li>
			{if isset($assigned_vars['action'])}
				{if isset($assigned_vars['function']) && !empty($assigned_vars['function']['value'])}
					<li>Current Route: {$assigned_vars['action']['value']|escape}:{$assigned_vars['function']['value']|escape}</li>
				{else}
					<li>Current Route: {$assigned_vars['action']['value']|escape}:default</li>
				{/if}
			{/if}
			{if isset($assigned_vars['debugLogger'])}
				<li><a href="javascript:;" debug-toggle="query-log">{$assigned_vars['debugLogger']['value']->getQueryCount()|escape} Queries Executed</a></li>
				<li><a href="javascript:;" debug-toggle="message-log">{$assigned_vars['debugLogger']['value']->getLogCount()|escape} Debug Messages</a></li>
			{/if}
			<li><a href="javascript:;" debug-toggle="template-vars">{count($assigned_vars)} Template Variables</a></li>
			<li><a href="javascript:;" debug-toggle="template-config">{count($config_vars)} Template Configuration Variables</a></li>
			<li>Script Memory: {number_format(memory_get_usage() / 1048576, 2)}MB</li>
			<li>Total Memory: {number_format(memory_get_usage(true) / 1048576, 2)}MB</li>
			{if isset($smarty.server.REQUEST_TIME_FLOAT)}
				<li>Request Time: {round((microtime(true)-$smarty.server.REQUEST_TIME_FLOAT), 4)} Seconds</li>
			{else}
				<li>Request Time: {round((microtime(true)-$smarty.server.REQUEST_TIME), 4)} Seconds</li>
			{/if}
		</ul>
	</div>

	<div class="debug-toolbar-pane" id="debug-content-template-vars" style="display:none;">
		<div class="debug-toolbar-pane-title">Template Variables <a href="javascript:;" class="close-pane">&times;</a></div>
		<div class="debug-toolbar-pane-content">
			<ul class="debug-template-var-list">
			{foreach $assigned_vars as $vars}
	            <li>
	            	<a href="javascript:;">${$vars@key|escape:'html'}</a>
	            	<div class="debug-template-var-details" style="display:none;">
	            		{$vars|debug_print_var nofilter}
	            	</div>
	            </li>
	        {/foreach}
	        </ul>
       </div>
	</div>

	<div class="debug-toolbar-pane" id="debug-content-template-config" style="display:none;">
		<div class="debug-toolbar-pane-title">Template Configuration Variables <a href="javascript:;" class="close-pane">&times;</a></div>
		<div class="debug-toolbar-pane-content">
			{foreach $config_vars as $vars}
                <div>{$vars@key|escape:'html'} <br />
                </div>
        	{/foreach}
        </div>
	</div>
	{if isset($assigned_vars['debugLogger'])}
		<div class="debug-toolbar-pane" id="debug-content-query-log" style="display:none;">
			<div class="debug-toolbar-pane-title">Query Log <a href="javascript:;" class="close-pane">&times;</a></div>
			<div class="debug-toolbar-pane-content">
				<ul>
					{foreach $assigned_vars['debugLogger']['value']->getQueries() as $query}
						<li>{$query['query']->queryString|escape} - {$query['time']|string_format:"%5f"}</li>
					{/foreach}
				</ul>
			</div>
		</div>

		<div class="debug-toolbar-pane" id="debug-content-message-log" style="display:none;">
			<div class="debug-toolbar-pane-title">Debug Log <a href="javascript:;" class="close-pane">&times;</a></div>
			<div class="debug-toolbar-pane-content">
				<ul>
					{foreach $assigned_vars['debugLogger']['value']->getLogs() as $message}
						<li><pre>{$message|escape}</pre></li>
					{/foreach}
				</ul>
			</div>
		</div>
	{/if}
</div>
{/capture}
{literal}
<script>
	if (!$('#debug-toolbar').length) {
		$('body').append("{/literal}{$debug_output|escape:'javascript' nofilter}{literal}");

		$('a[debug-toggle]').on('click', function(e){
			e.preventDefault();
			$('.debug-toolbar-pane').css('display', 'none');
			var $target = $('#debug-content-' + $(this).attr('debug-toggle'));
			$target.css('display', 'block');
		});

		$('#debug-toolbar a.close').on('click', function(e){
			e.preventDefault();
			$('#debug-toolbar').remove();
		});

		$("#debug-toolbar a.close-pane").on('click', function(e){
			e.preventDefault();
			$('.debug-toolbar-pane').css('display', 'none');
		});

		$('.debug-template-var-list a').on('click', function(e){
			e.preventDefault();
			var $target = $(this).parent().find('div.debug-template-var-details');
			if ($target.is(':visible')) {
				$target.css('display', 'none');
			} else {
				$target.css('display', 'block');
			}
		});
	}
</script>
{/literal}