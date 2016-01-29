package nl.vanace.itemeditor {
	
	import mx.collections.XMLListCollection;
	import mx.controls.listClasses.ListBase;

	public interface AbstractEditor {
		
		function getItemList() : ListBase;
		function getXmlListColl() : XMLListCollection;
		function setXmlListColl(xmlListColl:XMLListCollection) : void;
	}
}