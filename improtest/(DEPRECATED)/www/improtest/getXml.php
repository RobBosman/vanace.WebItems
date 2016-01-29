<?php
$encoding = 'UTF-8';
$soortItem = $_GET['soortItem'];

// Connect to database and fetch data.
mysql_connect('localhost', 'w4252545_imprtst', 'improtest') or die (mysql_error());
mysql_select_db("w4252545_improtest") or die (mysql_error());
$queryResult = mysql_query("SELECT * FROM items WHERE soort_item = '$soortItem' ORDER BY volgnummer;") or die(mysql_error());

// Set HTTP header fields.
header('Content-type: text/xml');
header('Content-encoding: UTF-8');
// Disable any caching in the browser.
header('Cache-Control: no-cache, no-store, max-age=0, must-revalidate');
header('Sat, 1 Jan 2000 00:00:00 GMT');
header('Pragma: no-cache');

echo '<?xml version="1.0" encoding="UTF-8"?>';
echo '<NEWS_READER>';
echo '<settings_slider totalHeight="191" stroke2Radius="6" stroke1Color="0x1f1f1f" imageStrokePx="3" stroke2Color="0x575757" bgColor="0x000000" htmlFieldWidth="300" stroke1Radius="6" stroke1Px="2" bgRadius="6" totalWidth="479" stroke2Px="1"/>';
echo '<settings_menu bgWidth="300" butDistance="2" bgHeight="23" butHeight="23" maskHeight="75"/>';
while ($row = mysql_fetch_array($queryResult)) {
	echo '<news';
	echo ' id="'.valueAt($row, 'id').'"';
	echo ' updated_at="'.valueAt($row, 'updated_at').'"';
	echo ' title="'.valueAt($row, 'title').'"';
	echo ' picture="'.valueAt($row, 'picture_url').'"';
	echo ' url="'.valueAt($row, 'target_url').'"';
	echo ' buttonText="'.valueAt($row, 'button_text', 'Go!').'"';
	echo ' date="01-04-2010"';
	echo ' time="12:34"';
	echo ' target="_blank"';
	echo '>';
	echo '<description>'.cdataAt($row, 'description').'</description>';
	echo '</news>';
}
echo '</NEWS_READER>';

function valueAt($row, $columnName, $default = '') {
	$value = $default;
	if (isset($row[$columnName])) {
		$value = $row[$columnName];
	}
	$value = str_replace('&', '&#x0026;', $value);
	$value = str_replace('<', '&#x003C;', $value);
	$value = str_replace('>', '&#x003E;', $value);
	$value = str_replace('\'', '&#x0027;', $value);
	$value = str_replace('"', '&#x0022;', $value);
	return utf8_encode($value);
}

function cdataAt($row, $columnName) {
	$value = '';
	if (isset($row[$columnName])) {
		$value = (string) $row[$columnName];
		if ($value != '') {
			$value = utf8_encode('<![CDATA['.$value.']]>');
		}
	}
	return $value;
}
?>