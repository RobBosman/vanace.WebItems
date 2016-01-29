<?php
	//include the S3 stuff
	require_once('myS3.php');
	//instantiate the class
	$s3 = new S3();

	//create a new bucket (this will be ignored if bucket is already there)
	$myBucketName= "robs-1st-bucket";

	foreach ($_POST as $index => $fileName) {
//error_log("fileName = $fileName");
		$s3->deleteObject($myBucketName, $fileName);
	}
?>