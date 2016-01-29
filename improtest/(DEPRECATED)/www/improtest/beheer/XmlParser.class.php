<?php
class XmlParser {
	
	private $parser;
	private $currentElementName;
	private $currentData;
	public $parsedData;

	function __construct() {
		$this->parser = xml_parser_create();
		xml_parser_set_option($this->parser, XML_OPTION_CASE_FOLDING, 0);
		xml_parser_set_option($this->parser, XML_OPTION_SKIP_WHITE, 1);
		xml_set_element_handler($this->parser, 'XmlParser::startTag', 'XmlParser::endTag');
		xml_set_character_data_handler($this->parser, 'XmlParser::contents');
		$this->parsedData = array();
	}

	function __destruct() {
		xml_parser_free($this->parser);
	}

	public function parse($xml) {
		if (!xml_parse($this->parser, $xml, true)) { 
			die('Parsing error on line '.xml_get_current_line_number($this->parser)); 
		}
	}

	protected function startTag($parser, $elementName, $attributes) {
		if ($elementName == 'news') {
			$this->currentData = array();
			$this->currentData['title'] = $attributes['title'];
			$this->currentData['target_url'] = $attributes['url'];
			$this->currentData['button_text'] = $attributes['buttonText'];
			$this->currentData['picture_url'] = $attributes['picture'];
		}
	}

	protected function contents($parser, $data) {
		if (isset($this->currentData['description'])) {
			$this->currentData['description'] .= trim($data);
		} else {
			$this->currentData['description'] = trim($data);
		}
	}

	protected function endTag($parser, $elementName) {
		if ($elementName == 'news') {
			$this->parsedData[] = $this->currentData;
			$columnNames = null;
			$values = null;
			foreach ($this->currentData as $name => $value) {
				$columnNames[] = $name;
				$values[] = "'$value'";
			}
//			echo '
//INSERT ('.implode(',',$columnNames).') VALUES('.implode(',',$values).") INTO $this->table;";
		}
	}
}
?>