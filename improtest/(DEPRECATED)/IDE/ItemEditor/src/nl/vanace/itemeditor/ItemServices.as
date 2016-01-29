package nl.vanace.itemeditor {

	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ItemServices {
		
		public static const URL_PREFIX:String = "../";
		private static const SET_XML_URL:String = "saveXml.php"; // store in XML files
		//private static const SET_XML_URL:String = "setXml.php"; // store in MySQL
		
		private var xmlLabel: String;
		private var soortItem: String;
		private var itemEditor:AbstractEditor;
		[Bindable] private var xml:XML;
		private var getXmlService:HTTPService;
		private var setXmlService:HTTPService;
		
		public function ItemServices(xmlLabel:String, soortItem:String, itemEditor:AbstractEditor) {
			this.xmlLabel = xmlLabel;
			this.soortItem = soortItem;
			this.itemEditor = itemEditor;

			xml = new XML();
			itemEditor.setXmlListColl(new XMLListCollection());
			itemEditor.getXmlListColl().enableAutoUpdate();

			getXmlService = new HTTPService();
			getXmlService.url = URL_PREFIX + soortItem + ".xml";
			getXmlService.resultFormat = HTTPService.RESULT_FORMAT_XML;
			getXmlService.addEventListener(FaultEvent.FAULT, faultHandler);
			getXmlService.addEventListener(ResultEvent.RESULT, fetchCompleteHandler);

			setXmlService = new HTTPService();
			setXmlService.url = SET_XML_URL;
			setXmlService.method = "POST";
			setXmlService.addEventListener(FaultEvent.FAULT, faultHandler);
			setXmlService.addEventListener(ResultEvent.RESULT, saveCompleteHandler);

			getXmlService.send();
		}
		
		private function faultHandler(event:FaultEvent):void {
			Alert.show(event.fault.faultCode + "\n" + event.fault.faultDetail + "\n" + event.fault.faultString, "FOUT");
		}
		
		public function fetch():void {
			Alert.show("Wijzigingen van '" + xmlLabel + "'-items ongedaan maken?", "Bevestiging",
				Alert.YES | Alert.NO,
				null, fetchConfirmed, ItemEditor.questionMark, Alert.NO); 
		}
		
		private function fetchConfirmed(someEvent:CloseEvent):void{
			if (someEvent.detail == Alert.YES) {
				getXmlService.send();
			}
		}
		
		private function fetchCompleteHandler(event:ResultEvent):void {
			var selectedIndices:Array = itemEditor.getItemList().selectedIndices;
			xml = XML(event.result);
			itemEditor.setXmlListColl(new XMLListCollection(xml.news));
			if (selectedIndices.length == 0) {
				itemEditor.getItemList().selectedIndices = [0];
			} else {
				itemEditor.getItemList().selectedIndices = selectedIndices;
			}
		}
		
		public function save():void {
			Alert.show("Alle '" + xmlLabel + "'-items opslaan op de server?", "Bevestiging", Alert.YES | Alert.NO,
				null, saveConfirmed, ItemEditor.questionMark, Alert.NO); 
		}
		
		private function saveConfirmed(someEvent:CloseEvent):void{
			if (someEvent.detail == Alert.YES) {
				// Leg de volgorde vast in het attribuut 'volgnummer'.
				var i:int = 0;
				for each (var newsXml:XML in xml.news) {
					newsXml.@volgnummer = i;
					// Work-around voor bug in news reader: vul eventuele lege @picture attributen met een dummy waarde.
					if (newsXml.@picture == "") {
						newsXml.@picture = CanvasImage.GEEN_AFBEELDING;
					}
					i++;
				}
				setXmlService.request[soortItem] = xml;
				setXmlService.send();
			}
		}
		
		private function saveCompleteHandler(event:ResultEvent):void {
			// @@@ Alert.show(XML(event.result), "DEBUG");
			Alert.show("De '"+ xmlLabel + "'-items zijn op de server opgeslagen.", "SUCCES");
		}
		
		public function createItem(timestamp:Date):void {
			var newItem: XML =
				<news date="" time="" title="titel" picture="(geen afbeelding)" buttonText="Naar de site" url="" target="_blank">
					<description>beschrijving</description>
				</news>;
			if (timestamp != null) {
				newItem.@date = asString(timestamp.getDate(), 2) + "-" + asString(timestamp.getMonth(), 2) + "-"
					+ asString(timestamp.getFullYear(), 4);
				newItem.@time = asString(timestamp.getHours(), 2) + ":" + asString(timestamp.getMinutes(), 2);
			}
			
			itemEditor.getXmlListColl().addItemAt(newItem, 0);
			itemEditor.getItemList().scrollToIndex(0);
			itemEditor.getItemList().selectedIndices = [0];
		}
		
		private function asString(number:Number, numDigits:int):String {
			var result:String = number.toString();
			while (result.length < numDigits) {
				result = "0" + result;
			}
			return result;
		}
		
		public function deleteItem():void {
			delete xml.news[itemEditor.getItemList().selectedIndex];
			itemEditor.setXmlListColl(new XMLListCollection(xml.news));
			itemEditor.getItemList().selectedIndices = [];
		}
		
		public static function getImageName(imageUrl:String, imageBaseUrl:String):String {
			var index:int = imageUrl.lastIndexOf(imageBaseUrl);
			if (index >= 0) {
				return imageUrl.substr(index + imageBaseUrl.length);
			}
			return imageUrl;
		}
	}
}