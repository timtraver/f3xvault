
			</div>
		</div>
		<div id="footer" class="clearfix">
    	    <div id="copyright" class="clearfix">
    	     	Copyright &copy; Tim Traver 2013-2014
   		    </div>
   		    
			{if $device=='computer' || $device=='tablet'}   		    
   		    	<input type="button" value="View Site In Mobile Format" class="button" onClick="device.submit();">
   		    {else}
   		    	<input type="button" value="View Site In Standard Format" class="button" onClick="device.submit();">
   			{/if}
   		    <input type="button" value="Give Some Site Feedback" class="button" onClick="feedback.submit();">
   		    <input type="button" value="Donate" class="button" onClick="donate.submit();">

 	   </div>
	</div><!-- #container -->
</div>
<form name="feedback" method="POST">
<input type="hidden" name="action" value="main">
<input type="hidden" name="function" value="main_feedback">
</form>
<form name="device" method="POST">
<input type="hidden" name="action" value="main">
<input type="hidden" name="function" value="change_format">
{if $device=='computer' || $device=='tablet'}   		    
<input type="hidden" name="format" value="phone">
{else}
<input type="hidden" name="format" value="computer">
{/if}
</form>
<form name="donate" method="GET" action="https://www.paypal.com/cgi-bin/webscr" target="_blank">
<input name="cmd" type="hidden" value="_xclick">
<input name="business" type="hidden" value="timtraver@gmail.com">
<input name="currency_code" type="hidden" value="USD">
<input name="item_name" type="hidden" value="F3XVault Donation">
<input name="amount" type="hidden" value="">
</form>

    </body>
</html>