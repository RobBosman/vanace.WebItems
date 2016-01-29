<?php
// Connect to database and fetch data.
mysql_connect('localhost', 'w4252545_imprtst', 'improtest') or die (mysql_error());
mysql_select_db("w4252545_improtest") or die (mysql_error());

foreach ($_POST as $soortItem => $postedXml) {
	$simpleXml = simplexml_load_string($postedXml);
	foreach ($simpleXml->children() as $child) {
		if ($child->getName() == 'news') {
			$columnNames = array();
			$values = array();

			$columnNames[] = 'soort_item';
			$values[]= $soortItem;

			$id = null;
			foreach ($child->attributes() as $name => $value) {
				if ($name == 'id') {
					$id = $value;
				} else {
					$columnName = mapXmlField($name);
					if ($columnName != '') {
						$columnNames[] = $columnName;
						$values[] = $value;
					}
				}
			}
			$columnNames[] = mapXmlField('description');
			$description = $child->xpath('description');
			$values[] = $description[0];
			
			for ($i = 0; $i < count($values); $i++) {
				$values[$i] = escapePhp($values[$i]);
			}

			if ($id == null) {
				$query = 'INSERT INTO items ('.implode(',', $columnNames).') VALUES(\''.implode('\',\'', $values).'\');';
			} else {
				$updateValues = array();
				for ($i = 0; $i < count($columnNames); $i++) {
					$updateValues[] = $columnNames[$i].'=\''.$values[$i].'\'';
				}
				$query = 'UPDATE items SET '.implode(', ', $updateValues).' WHERE id=\''.$id.'\';';
			}
//echo $query.'
//';exit;
			mysql_query(utf8_decode($query)) or die (mysql_error());
		}
	}
}

function mapXmlField($xmlField) {
	$fieldMap = array(
		// xml-field => db-column
		'volgnummer' => 'volgnummer',
		'title' => 'title',
		'description' => 'description',
		'url' => 'target_url',
		'buttonText' => 'button_text',
		'picture' => 'picture_url',
	);
	if (isset($fieldMap[$xmlField])) {
		return $fieldMap[$xmlField];
	} else {
		return '';
	}
}

function escapePhp($value) {
	$value = str_replace('\\' ,'\\\\', $value);
	$value = str_replace('\'' ,'\\\'', $value);
	return $value;
}
?>