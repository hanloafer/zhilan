<html>
<head>
<?php
/*
 * Created on Jun 20, 2011
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */
 
 require_once(dirname(__FILE__) . '/config.php');
 

 
 
 
 $app_id = APP_ID;

 $canvas_page = CANVAS_PAGE_URL;

 $message = "Apps on Facebook.com are cool!";

 $feed_url = "http://www.facebook.com/dialog/feed?app_id=" 
        . $app_id . "&redirect_uri=" . urlencode(START_PAGE)
        . "&message=" . $message;

 if (empty($_REQUEST["post_id"])) {
    //echo("<script> top.location.href='" . $feed_url . "'</script>");
 } else {
    //echo ("Feed Post Id: " . $_REQUEST["post_id"]);
 }
 
  echo 	"<script type='text/javascript'>" .
 		"	function onbClick(){
 			top.location.href='"$feed_url"';
 		}" .
 		"</script>";
		
 
 
?>
</head>
<body>
<?php
 echo '====================================== INFO ============================================';
 foreach ($_REQUEST as $key => $value){
 	echo '<br>' . $key . "=" . $value;
 }
 
 echo '====================================== FEED ============================================';
?>
<button type="button" onclick="onbClick();">Click Me!</button>
</body>
</html>


