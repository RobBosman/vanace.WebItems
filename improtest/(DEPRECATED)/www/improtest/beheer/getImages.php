<?php
    $contentEncoding = "UTF-8";
    $imageDir = 'images/'.$_GET['itemSoort'];
    $imageRelDir = $_GET['urlPrefix'].$imageDir;
    $handle = opendir($imageRelDir);

    // Disable any caching in the browser.
    header("Cache-Control: no-cache, no-store, max-age=0, must-revalidate");
    header("Sat, 1 Jan 2000 00:00:00 GMT");
    header("Pragma: no-cache");
    header("Content-encoding: ".$contentEncoding);
    header("Content-type: text/xml");

    echo "<?xml version='1.0' encoding='".$contentEncoding."'?>";
    echo "<images>";
    while ($file = readdir($handle)) {
        if (!is_dir($file)) {
    		echo "<image filename='$file' url='$imageDir/$file'/>";
    	}
    }
    echo "</images>";
 
    closedir($handle);
?>