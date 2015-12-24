<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty ordinal modifier plugin
 *
 * Type:     modifier
 * Name:     ordinal
 * Purpose:  convert string to lowercase
 * @link http://smarty.php.net/manual/en/language.modifier.lower.php
 *          lower (Smarty online manual)
 * @author   Ignacio Segura, "nachenko" (www-isegura.es). It uses Ordinal Suffix PHP function by Paul Ferrett (www.paulferrett.com)
 * @param string
 * @return string
 */
function smarty_modifier_ordinal($n)
{
	if (is_numeric($n)) {
	 $n_last = $n % 100;
	 if (($n_last > 10 && $n_last < 14) || $n == 0){
				return "{$n}th";
	 }
	 switch(substr($n, -1)) {
				case '1':    return "{$n}st";
				case '2':    return "{$n}nd";
				case '3':    return "{$n}rd";
				default:     return "{$n}th";
	 }
	} else {
		$smarty->trigger_error("ordinal modifier: Parameter provided is not a number", E_USER_NOTICE);
	}
}

?>