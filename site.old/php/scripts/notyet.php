<?php
############################################################################
#       notyet.php
#
#       Tim Traver
#       5/21/12
#       Miva Merchant, Inc.
#       This is the script to simply tell the user that it isn't operational yet.
#
############################################################################

if(isset($_REQUEST['function']) && $_REQUEST['function']!='') {
        $function=$_REQUEST['function'];
}else{
        $function="view";
}
if(check_user_function($function)){
        eval("\$actionoutput=$function();");
}

function view() {
        global $reseller_id;
        global $smarty;

        $tpl=find_template("notyet.tpl",$reseller_id);
        return $smarty->fetch($tpl);
}
?>
