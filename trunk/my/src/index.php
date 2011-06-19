<?php
/*
 * Created on Jun 19, 2011
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */
?>

Hello My

 <?php

     $app_id = APP_ID;

     $canvas_page = CANVAS_PAGE;

     $auth_url = "http://www.facebook.com/dialog/oauth?client_id="
            . $app_id . "&redirect_uri=" . urlencode($canvas_page);

     $signed_request = $_REQUEST["signed_request"];

     list($encoded_sig, $payload) = explode('.', $signed_request, 2);

     $data = json_decode(base64_decode(strtr($payload, '-_', '+/')), true);

     if (empty($data["user_id"])) {
            echo("<script> top.location.href='" . $auth_url . "'</script>");
     } else {
            echo ("Welcome User: " . $data["user_id"]);
     }
 ?>

