<?php
############################################################################
#       security_functions.inc
#
#       Tim Traver
#       6/4/12
#       Miva Merchant, Inc.
#       This is an included bunch of subroutines to handle all the user access security
#
############################################################################

function check_user_function($function){
        # Function to quickly check to see if the function being called is a proper one
        $functions=get_defined_functions();
        if(in_array($function,$functions['user'])){
                return 1;
        }else{
                return 0;
        }
}
function show_no_permission(){
        global $smarty;
        # Function to show that a user does not have permission for this area
        $tpl=find_template("no_permission.tpl");
        return $smarty->fetch($tpl);
}
function get_user_info($user_parameter){
        # $user_parameter cna be either user_id (int) or user_name (string)
        # Function to get all of the user info, including permissions
        $user=array();

        # Lets see if what was passed was a user_id or a user_name
        if(preg_match("/^\d+$/",$user_parameter)){
                $user_id=$user_parameter;
        }else{
                $user_id=0;
        }
        # Now get the base user info
        if($user_id!=0){
                $stmt=db_prep("
                        SELECT *
                        FROM user
                        WHERE user_id=:user_id
                ");
                $result=db_exec($stmt,array("user_id"=>$user_id));
        }else{
                $stmt=db_prep("
                        SELECT *
                        FROM user
                        WHERE user_name=:user_name
                ");
                $result=db_exec($stmt,array("user_name"=>$user_parameter));
        }
        if($result){
                # Get the user groups and permissions
                foreach($result[0] as $key=>$value){
                        $user[$key]=$value;
                }
        }
        return $user;
}
?>
