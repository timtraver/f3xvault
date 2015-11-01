{if $messages}
<table width="100%" bgcolor="#lightblue" height="30" cellpadding="10">
<tr>
	<td align="left">
	{$message_graphic}
	{foreach $messages as $message}
	<font color="{$message.message_color}" size="-1">
	{$message.message|escape}
	</font>
	<br>
	{/foreach}
	</td>
</tr>
</table>
<br>
{/if}
