<?php
    $imageRelDir = $_GET['urlPrefix'].$imageDir.'images/'.$_GET['itemSoort'];

    $file = $_FILES['Filedata'];
    if ($file == '') {
	    $file = $_FILES['file'];
    }
    $fileError = $file['error'];
    $fileName = $file['name'];
    $tempFile = $file['tmp_name'];

    if ($fileError > 0) {
	    echo "Error: " . $fileError;
    } else {
    	echo "File: $fileName<br/>";
    	echo "Type: $file->type<br/>";
    	echo "Size: $file->size<br/>";
    	echo "Temp_name: " . $tempFile;
    	move_uploaded_file($tempFile, "$imageRelDir/$fileName");
    }
?>