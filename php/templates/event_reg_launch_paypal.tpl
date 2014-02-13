<html>
<body>
<form name="paypal" method="GET" action="https://www.paypal.com/cgi-bin/webscr" target="_blank">
<input name="cmd" type="hidden" value="_xclick">
<input name="business" type="hidden" value="{$event->info.event_reg_paypal_address}">
<input name="lc" type="hidden" value="{$event->info.country_code}">
<input name="item_name" type="hidden" value="F3XVault Registration for {$event->info.event_name} for pilot {$user.user_first_name} {$user.user_last_name}">
<input name="amount" type="hidden" value="{$total|string_format:"%.2f"}">
<input type="hidden" name="currency_code" value="{$event->info.currency_code}">
<input type="hidden" name="button_subtype" value="services">
<input type="hidden" name="bn" value="PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted">
</form>
<script type="text/javascript">
<!--
        document.paypal.submit();
-->
</script>
</body>
</html>
