<?php
	//include the S3 stuff
	require_once('myS3.php');
	//instantiate the class
	$s3 = new S3();

	//create a new bucket (this will be ignored if bucket is already there)
	$myBucketName= "robs-1st-bucket";

	//retreive post variables
    $file = $_FILES['Filedata'];
    if ($file == '') {
	    $file = $_FILES['file'];
    }
	$fileName = $file['name'];
	$fileTempName = $file['tmp_name'];

	//create a new bucket (this will be ignored if bucket is already there)
	$s3->putBucket($myBucketName, S3::ACL_PUBLIC_READ);

	//move the file
	if ($s3->putObjectFile($fileTempName, $myBucketName, $fileName, S3::ACL_PUBLIC_READ)) {
		echo "Successfully uploaded the file.";
	} else {
		echo "Something went wrong while uploading the file...";
	}
?>