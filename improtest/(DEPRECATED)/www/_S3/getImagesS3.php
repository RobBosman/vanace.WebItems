<?php
    $contentEncoding = "UTF-8";
	//include the S3 stuff
	require_once('myS3.php');
	//instantiate the class
	$s3 = new S3();

	//create a new bucket (this will be ignored if bucket is already there)
	$myBucketName = "robs-1st-bucket";

	// Get the contents of our bucket
	$bucket_contents = $s3->getBucket($myBucketName);

	// Disable any caching in the brwoser.
	header("Cache-Control: no-cache, no-store, max-age=0, must-revalidate");
	header("Sat, 1 Jan 2000 00:00:00 GMT");
	header("Pragma: no-cache");
    header("Content-encoding: ".$contentEncoding);
    header("Content-type: text/xml");

    echo "<?xml version='1.0' encoding='".$contentEncoding."'?>";
	echo "<images>";
	foreach ($bucket_contents as $file) {
		$fname = $file['name'];
		$furl = S3::getAuthenticatedURL($myBucketName, $fname, 60, false, true);
		//$furl = "http://$myBucketName.s3.amazonaws.com/$fname";
		//output a link to each file
		echo "<image filename='$fname' url='$furl'/>";
	}
	echo "</images>";
?>