<?php
############################################################################
#       logout.php
#
#       Tim Traver
#       6/21/12
#       Miva Merchant, Inc.
#       This is the script to log the user out of the system
#
############################################################################

destroy_fsession();
user_message("User Logged Out.");
header("Location: ?logout");
exit;
