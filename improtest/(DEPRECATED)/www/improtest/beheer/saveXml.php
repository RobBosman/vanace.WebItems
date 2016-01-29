<?php
	foreach (array ('data', 'links', 'portfolio') as $xmlSource) {
		if (array_key_exists($xmlSource, $_POST)) {
			$postedXml = $_POST[$xmlSource];
			// Unescape PHP-characters (backslash, quotes, etc)
			$postedXml = str_replace('\\\\', '\\', $postedXml);
			$postedXml = str_replace('\\"', '"', $postedXml);
			$postedXml = str_replace('\\\'', '\'', $postedXml);
			if (strlen($postedXml) != 0) {
				$fileHandle = fopen("../$xmlSource.xml", 'w') or die('can\'t open file');
				fwrite($fileHandle, $postedXml);
				fclose($fileHandle);
			}
		}
	}
?>