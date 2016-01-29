<?php
	foreach ($_POST as $index => $url) {
		$fileHandle = fopen("../$url", 'w') or die("can't open file $url");
		fclose($fileHandle);
		unlink("../$url");
	}
?>