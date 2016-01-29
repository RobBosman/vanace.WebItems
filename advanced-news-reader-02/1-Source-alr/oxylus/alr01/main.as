import ascb.util.Proxy;
import gs.TweenMax;
import gs.easing.*;

class oxylus.alr01.main extends MovieClip
{
	private var myXml:XMLNode; 
	private var settings:Object;
	
	private var bg:MovieClip;
	private var stroke1:MovieClip;
	private var stroke2:MovieClip;
	private var left:MovieClip;
	private var right:MovieClip;
	private var list:MovieClip;
	private var lst:MovieClip;
	private var totalItems:Number;
	private var currentIdx:Number;
	private var shade:MovieClip;
	private var menu:MovieClip;
	private var la:Number = 1;
	private var ra:Number = 1;
	
	private var aux:XMLNode;
	private var idx:Number;
	public function main()
	{
		
		bg = this["bg"];
		stroke1 = this["stroke1"];
		stroke2 = this["stroke2"];
		left = this["left_arrow"]; left["over"]._alpha = 0;
		right = this["right_arrow"]; right["over"]._alpha = 0;
		list = this["news_list"];
		lst = list["lst"];
		lst.setMask(list["mask"]);
		settings = new Object();
		var xmlOb:XML = new XML();
		myXml = xmlOb;
		xmlOb.ignoreWhite = true;
		xmlOb.onLoad = Proxy.create(this, cont, myXml, settings);
		xmlOb.load(_root.xmlFile == undefined ? "no-cache/links.xml" : _root.xmlFile);
		defaultSettings();
	}
	
	public function cont()
	{
	
		// executed after the .xml file loaded
		var a:XMLNode = myXml.firstChild.firstChild
		settings.totalWidth = Number(a.attributes.totalWidth);
		settings.totalHeight = Number(a.attributes.totalHeight);
		settings.bgColor = Number(a.attributes.bgColor);
		settings.stroke1Color = Number(a.attributes.stroke1Color);
		settings.stroke2Color = Number(a.attributes.stroke2Color);
		settings.stroke1Px = Number(a.attributes.stroke1Px);
		settings.stroke2Px = Number(a.attributes.stroke2Px);
		settings.bgRadius = Number(a.attributes.bgRadius);
		settings.stroke1Radius = Number(a.attributes.stroke1Radius);
		settings.stroke2Radius = Number(a.attributes.stroke2Radius);
		settings.imageStrokePx = Number(a.attributes.imageStrokePx);
		settings.htmlFieldWidth = Number(a.attributes.htmlFieldWidth);
		
		var b:XMLNode = a.nextSibling;
		settings.bgWidth = Number(b.attributes.bgWidth);
		settings.bgHeight = Number(b.attributes.bgHeight);
		settings.maskHeight = Number(b.attributes.maskHeight);
		settings.butHeight = Number(b.attributes.butHeight);
		settings.butDistance = Number(b.attributes.butDistance);
		
		
		drawMyMainGraphics();
		positionElements();
		actionsForArrows();
		
		
		aux = a.nextSibling.nextSibling;
		idx = 0;
		currentIdx = 0;
		keepLoading();
		
		totalItems = idx;
		
		leftDe();
		menu = this.attachMovie("IDmenu", "menu", this.getNextHighestDepth());
		menu.settings = settings;
		menu.resize();
		menu.setNode(a.nextSibling.nextSibling);
		menu._y = Math.round(settings.totalHeight + settings.bgHeight + 2 + settings.stroke1Px + settings.stroke2Px);
		menu._x = Math.round(settings.totalWidth / 2 - settings.bgWidth / 2);
		
		
		
		
		
	}
	
	public function keepLoading() {
		if (aux != null) {
			
			lst.attachMovie("IDnews", "news" + idx, lst.getNextHighestDepth());
			lst["news" + idx].settings = settings;
			lst["news" + idx].setNode(aux);
			lst["news" + idx]._x = settings.totalWidth * idx;
			
			if (idx != currentIdx)
				lst["news" + idx].deact();
				
			idx++;
		}
		aux = aux.nextSibling;
		totalItems = idx;
	}
	
	/*
	 * this will draw the main graphics
	*/
	private function drawMyMainGraphics() {
		
		drawOval(bg, settings.totalWidth, settings.totalHeight, settings.bgRadius, settings.bgColor, 100);
		drawOval(stroke1, settings.totalWidth + 2 * settings.stroke1Px, settings.totalHeight + 2 * settings.stroke1Px, settings.stroke1Radius, settings.stroke1Color, 100);
		stroke1._x = stroke1._y = -settings.stroke1Px;
		drawOval(stroke2, settings.totalWidth + 2 * settings.stroke1Px + 2 * settings.stroke2Px, settings.totalHeight + 2 * settings.stroke1Px + 2 * settings.stroke2Px, settings.stroke2Radius, 	settings.stroke2Color, 100);
		stroke2._x = stroke2._y = stroke1._x - settings.stroke2Px;
		list["mask"]._height = settings.totalHeight;
		list["mask"]._width = settings.totalWidth;
		
		shade._x = -settings.stroke1Px;
		shade._width = settings.totalWidth + 2 * settings.stroke1Px;
	}
	
	/*
	 * this will positions the elments
	*/
	private function positionElements() {
		right._x = settings.totalWidth + settings.stroke1Px + settings.stroke2Px;
		right._y = Math.round(settings.totalHeight / 2 - right._height / 2);
		left._x = -(left._width + settings.stroke1Px + settings.stroke2Px);
		left._y = Math.round(settings.totalHeight / 2 - left._height / 2);
	}
	
	/*
	 * this will define the actions for the navigating arrows
	*/
	private function actionsForArrows() {
		left.onRollOver = Proxy.create(this, leftOnRollOver);
		left.onRollOut = Proxy.create(this, leftOnRollOut);
		left.onPress = Proxy.create(this, leftOnPress);
		left.onReleaseOutside = Proxy.create(this, leftOnRelease);
		
		right.onRollOver = Proxy.create(this, rightOnRollOver);
		right.onRollOut = Proxy.create(this, rightOnRollOut);
		right.onPress = Proxy.create(this, rightOnPress);
		right.onReleaseOutside = Proxy.create(this, rightOnRelease);
	}
	
	private function leftDe() {
		TweenMax.to(left["normal"], .5, {_alpha:50});
		leftOnRelease();
		la = 0;
	}
	
	private function leftAc() {
		la = 1;
		TweenMax.to(left["normal"], .5, {_alpha:100});
		
	}
	
	private function rightDe() {
		TweenMax.to(right["normal"], .5, {_alpha:50});
		rightOnRelease();
		ra = 0;
	}
	
	private function rightAc() {
		TweenMax.to(right["normal"], .5, {_alpha:100});
		ra = 1;
	}
	
	private function leftOnPress() {
		goPrev();

		if (currentIdx == 0) {
			if(la==1)
				leftDe()
		}
		else {
			if(la==0)
				leftAc();
			if (ra == 0)
				rightAc();
		}
	}
	
	private function rightOnPress() {
		goNext()
	
		if (currentIdx == (totalItems - 1)) {
			if (ra==1)
				rightDe()
		}
		else {
			if (ra == 0)
				rightAc()
		}
		
		if (currentIdx != 0) {
			if(la==0)
				leftAc();
		}
		
		
	}
	
	public function goNext() {
		if (currentIdx < (totalItems-1)) {
			lst["news" + currentIdx].deact();
			currentIdx++;
			lst["news" + currentIdx].act();
			slideListNext();
			
			menu.holder["but" + currentIdx].activ();
		}
	}
	
	public function goPrev() {
		if (currentIdx > 0) {
			lst["news" + currentIdx].deact();
			currentIdx--;
			lst["news" + currentIdx].act();
			slideListPrev()
			
			menu.holder["but" + currentIdx].activ();
		}
	}
	
	private function slideListNext() {
		if (TweenMax.isTweening(lst)) {
			TweenMax.killTweensOf(lst, false);
		}
		
		TweenMax.to(lst, 0.5, {_x:-currentIdx*settings.totalWidth } );
	}
	
	private function slideListPrev() {
		if (TweenMax.isTweening(lst)) {
			TweenMax.killTweensOf(lst, false);
		}
		TweenMax.to(lst, 0.5, {_x:-currentIdx*settings.totalWidth} );
	}
	
	public function goToPos(ps:Number) {
			lst["news" + currentIdx].deact();
			currentIdx = ps;
			lst["news" + currentIdx].act();
			slideListNext();
			
			if (ps == 0) {
				if (la == 1) {
					leftDe();
				}
			}
			else {
				if (la == 0) {
					leftAc();
				}
			}
			
			if (ps == (totalItems - 1)) {
				
				if (ra == 1) {
					rightDe();
				}
			}
			else {
				if (ra == 0) {
					rightAc();
				}
			}
			
					
	}
	
	private function leftOnRollOver() {
		if(la==1)
			TweenMax.to(left["over"], .5, {_alpha:100});
	}
	
	private function leftOnRollOut() {
		if(la==1)
			TweenMax.to(left["over"], .5, {_alpha:0});
	}
	
	private function leftOnRelease() {
		TweenMax.to(left["over"], .5, { _alpha:0 } );
		
	}
	
	private function rightOnRollOver() {
		if (ra==1)
			TweenMax.to(right["over"], .5, {_alpha:100});
	}
	
	private function rightOnRollOut() {
		if (ra==1)
			TweenMax.to(right["over"], .5, {_alpha:0});
	}
	
	private function rightOnRelease() {
		TweenMax.to(right["over"], .5, {_alpha:0});
	}
	
	
	
	private function defaultSettings()
	{
		// these settings are the default ones so the project will look nice on the screen
		// if you remove these the menu;s functionality will not be afected but it will no longer be fixed size
		// at some php/html applications you should remove these
		//Stage.scaleMode = "noScale";
		//Stage.align = "LT";
		_lockroot = true;
	}
	
	private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:Number, alphaAmount:Number) {
		//draws an oval or square if r=0
		//fillColor=0x000000;
		//alphaAmount = 100;
			mc.clear();
			mc.beginFill(fillColor,alphaAmount);
			mc.moveTo(r,0);
			mc.lineTo(mw-r,0);
			mc.curveTo(mw,0,mw,r);
			mc.lineTo(mw,mh-r);
			mc.curveTo(mw,mh,mw-r,mh);
			mc.lineTo(r,mh);
			mc.curveTo(0,mh,0,mh-r)
			mc.lineTo(0,r);
			mc.curveTo(0,0,r,0);
			mc.endFill();
	}
}