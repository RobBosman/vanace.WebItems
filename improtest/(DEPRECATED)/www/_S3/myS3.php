<?php
	//include the S3 class
	if (!class_exists('S3')) require_once('S3.php');

	//AWS access info
	if (!defined('awsAccessKey')) define('awsAccessKey', 'AKIAICZOEWVDZ4COBAQQ');
	if (!defined('awsSecretKey')) define('awsSecretKey', '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');

	//instantiate the class
	S3::setAuth(awsAccessKey, awsSecretKey);
?>