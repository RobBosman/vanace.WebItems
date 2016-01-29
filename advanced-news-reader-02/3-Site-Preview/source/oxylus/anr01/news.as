import ascb.util.Proxy;
import mx.utils.Delegate;
import gs.TweenMax;
import gs.easing.*;
import flash.display.BitmapData;
import com.pixelfumes.Reflect;
import caurina.transitions.*;

class oxylus.anr01.news extends MovieClip 
{
	public var settings:Object;
	
	private var node:XMLNode;
	private var title:MovieClip;
	private var bg:MovieClip;
	
	private var html:MovieClip;
	private var actual:MovieClip;
	private var field:MovieClip;
	
	private var scroller:MovieClip;
	private var stick:MovieClip;
	private var bar:MovieClip;
	
	private var mcl:MovieClipLoader;
	private var iw:Number;
	private var ih:Number;
	private var w:Number;
	private var h:Number;
	
	private var picture:MovieClip;
	private var loadError:Number = 0;
	private var timeInfo:MovieClip;
	private var holder:MovieClip;
	private var imgStroke:MovieClip;
	private var button:MovieClip;
	private var buttonOver:MovieClip;
	private var buttonNormal:MovieClip;
	
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	private var t:MovieClip;
	private var r1:Reflect;
	private var r2:Reflect;
	
	private var loader:MovieClip;
	
	public function news() {
		settings = new Object();
		
		
		title = this["title"];  title._alpha = 0;
		title["txt"].autoSize = true;
		title["txt"].wordWrap = true;
		
		bg = this["bg"];
		
		html = this["html"];  html._alpha = 0;
		actual = html["html_box"];
		field = actual["field"];
		field.setMask(actual["mask"]);
		field["txt"].autoSize = true;
		field["txt"].wordWrap = true;
		field["txt"].scrollable = false;
		
		scroller = html["scroller"];
		stick = scroller["stick"];
		bar = scroller["bar"];
		bar["over"]._alpha = 0;
		
		loader = this["loader"];
		loader._visible = false;
		
		picture = this["picture"]; picture._visible = false;
		timeInfo = picture["timeInfo"];
		holder = picture["holder"];
		imgStroke = picture["stroke"];
		button = picture["button"];
		buttonOver = button["over"]; buttonOver._alpha = 0;
		buttonNormal = button["normal"];
		button._visible = false;
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
	}
	
	
	public function deact() {
		if (TweenMax.isTweening(this)) {
			TweenMax.killTweensOf(this, false);
		}
		
		TweenMax.to(this, 0.5, { blurFilter: { blurX:20, blurY:0, quality:2 } } );
	}
	
	public function act() {
		if (TweenMax.isTweening(this)) {
			TweenMax.killTweensOf(this, false);
		}
		
		TweenMax.to(this, 0.5, {blurFilter:{blurX:0, blurY:0, quality:2}});
	}
	
	
	private function defaultTextFormat() {
		title["txt"]._width = settings.totalWidth - 20;
		title._x = 10;
		title._y = 6;
		field["txt"]._width = settings.totalWidth - 10 - 16; //-12 when scroller present
		field._x = title._x;
		field._y = title._y + title._height;
	
		actual["mask"]._width = field["txt"]._width;
		actual["mask"]._height = settings.totalHeight - field._y - 10;
		actual["mask"]._x = field._x;
		actual["mask"]._y = field._y;
		
		scroller._x = settings.totalWidth - 10;
		scroller._y = field._y;
	}
	
	/*
	 * this will resize the components
	*/
	private function resizeG() {
		bg._width = settings.totalWidth;
		bg._height = settings.totalHeight;
		
	}
	
	public function setNode(n:XMLNode) {
		node = n;
		resizeG();
		loader._x = Math.round(settings.totalWidth / 2 - loader._width / 2);
		loader._y = Math.round(settings.totalHeight / 2 - loader._height / 2);
		title["txt"].text = node.attributes.title;
		field["txt"].htmlText = node.firstChild.firstChild.nodeValue;
		defaultTextFormat();
		mcl.loadClip(node.attributes.picture, holder);
		
		
	}
	
	public function cont()
	{
		Tweener.addTween(loader, { _rotation:360, time:1.2, transition:"linear",onComplete:Proxy.create(this,cont) } );
	}
	
	private function onLoadStart() {
		Tweener.addTween(loader, { _rotation:360, time:1.2, transition:"linear", onComplete:Proxy.create(this, cont) } );
		
		loader._visible = true;
	}
	
	private function onLoadComplete() {
		Tweener.removeAllTweens();
		loader._visible = false;
	}
	private function checkButton() {
		if ((node.attributes.buttonText != "") && (node.attributes.buttonText != undefined)) {
			
			h = settings.totalHeight - 10 - 10 - 20 - settings.imageStrokePx - 10;
			w = settings.totalWidth - settings.htmlFieldWidth - 10 - settings.imageStrokePx-20;
		
			buttonOver["txt"].autoSize = true;
			buttonOver["txt"].wordWrap = false;
			buttonNormal["txt"].autoSize = true;
			buttonNormal["txt"].wordWrap = false;
			buttonOver["txt"].text = buttonNormal["txt"].text = node.attributes.buttonText;
			buttonNormal["bg"]._width = buttonOver["bg"]._width = buttonNormal["txt"]._width + 8;
			buttonNormal["txt"]._x = buttonOver["txt"]._x = Math.round(buttonNormal["bg"]._width / 2 - buttonNormal["txt"]._width / 2);
			button._visible = true;
		}
		else {
			h = settings.totalHeight - 10 - 10 - 20 - settings.imageStrokePx;
			w = settings.totalWidth - settings.htmlFieldWidth - 20;
		}
	}
	
	private function onLoadInit(mc:MovieClip) // executed when the image has fully loaded
	{
		checkButton();
		
		timeInfo["date"].autoSize = true;
		timeInfo["date"].wordWrap = false;
		timeInfo["date"].text = node.attributes.date;
		timeInfo["time"].autoSize = true;
		timeInfo["time"].wordWrap = false;
		timeInfo["time"].text = node.attributes.time;
		var bd:BitmapData = new BitmapData(mc._width, mc._height);
		bd.draw(mc);
		mc.attachBitmap(bd, mc.getNextHighestDepth(), "always", true);
		resize(mc);
		
		loadedTextFormat();
		
		
		mc._y = 0;
		
		
		
		if (button._visible == true) {
			button._x = Math.round(mc._x + mc._width / 2 - button._width / 2);
			button._y = Math.round(mc._y + mc._height + 10);
			buttonActions();
		}

		imgStroke._width = iw + 2*settings.imageStrokePx;
		imgStroke._height = ih + 2 * settings.imageStrokePx;
		imgStroke._x = mc._x - settings.imageStrokePx;
		imgStroke._y = mc._y - settings.imageStrokePx;
		
		timeInfo._x = mc._x;
		timeInfo._y = Math.round(mc._y + ih - timeInfo["bg"]._height);
		timeInfo["bg"]._width = iw;
		timeInfo["date"]._x = 2;
		timeInfo["time"]._x = Math.round(iw - timeInfo["time"]._width-4);
		
		picture._y = picture._height;
		picture._yscale = 0;
		picture._visible = true;
		
		
		r1 = new Reflect( { mc:mc, alpha:50, ratio:255, distance:settings.imageStrokePx+2, reflectionAlpha:60, reflectionDropoff:4 } ); //this will reflect the picture
		r2 = new Reflect({mc:imgStroke, alpha:50, ratio:255, distance:0, reflectionAlpha:60, reflectionDropoff:4}); //this will reflect the stroke
		
	}
	
	private function onLoadError(mc:MovieClip) { // this function will be executed when the picture cannot be loaded
		loadError = 1;
		ScrollBox()
		
		this._parent._parent._parent.keepLoading();
	}
	
	private function loadedTextFormat() {
		var a:Number = settings.totalWidth - w - 10 - 10;
		title["txt"]._width = a-10;
		var b:Number = settings.htmlFieldWidth + 100;
		var c:Number = Math.round(settings.totalWidth -  settings.htmlFieldWidth - 20);
		var d:Number = settings.totalWidth - settings.htmlFieldWidth - 12;
		var e:Number = Math.round(title._y + title._height);
		
		
		field["txt"]._width = b; //-12 when scroller present
		field._x = d;
		title._x = d;
		field._y = e;
		
		scroller._x = settings.totalWidth - 10;
		scroller._y = e;
		actual["mask"]._width = b;
		actual["mask"]._height = settings.totalHeight - e - 10;
		actual["mask"]._x = d;
		actual["mask"]._y = e;
		
		
		TweenMax.to(scroller, .5, {_x:(settings.totalWidth - 10), _y:e});
		picture._x = Math.round(d / 2 - iw / 2);
		
		TweenMax.to(picture, 0.5, { _yscale:100,_y:(11 + settings.imageStrokePx),ease:Circ.easeOut,onComplete:onFinishTween, onCompleteParams:[this]} );

		ScrollBox();
	}

	
	private function onFinishTween(t) {
		t._parent._parent._parent.keepLoading();
	}
	
	private function resize(mc:MovieClip) { //this function will resize by ratio the image
		mc._xscale = mc._yscale=100;
		iw = mc._width;
		ih = mc._height;
		
		
		mc._width = w;
		mc._yscale = mc._xscale;
		if (mc._height>h) {
			mc._height = h;
			mc._xscale = mc._yscale;
		}
		iw = mc._width;
		ih = mc._height;
		mc._width = Math.round(iw);
		mc._height = Math.round(ih);
	}
	
	private function buttonActions() {
		button.onRollOver = Proxy.create(this, buttonOnRollOver);
		button.onRollOut = Proxy.create(this, buttonOnRollOut);
		button.onPress = Proxy.create(this, buttonOnPress);
		button.onRelease = button.onReleaseOutside = Proxy.create(this, buttonOnRelease);
	}
	
	private function buttonOnRollOver() {
		TweenMax.to(buttonOver, .5, {_alpha:100});
	}
	
	private function buttonOnRollOut() {
		TweenMax.to(buttonOver, .5, {_alpha:0});
	}
	
	/*
	 * here you can setup the actions for pressing the button
	 * you can call an url like now or you can call a frame number
	*/
	private function buttonOnPress() {
		getURL(node.attributes.url, node.attributes.target); 
	}
	
	private function buttonOnRelease() {
		buttonOnRollOut();
	}
	
	private function Bon()
	{
		ScrollButton["over"]._alpha = 100;
	}
	private function Bout()
	{
		ScrollButton["over"]._alpha = 0;
	}
	private function Bp()
	{
		startScroll()
	}
	private function onRel()
	{
		stopScroll()
		ScrollButton["over"]._alpha = 0;
	}
	
	public function ScrollBox() {
		TweenMax.to(title, .5, {_alpha:100});
		TweenMax.to(html, .5, {_alpha:100});
		
		
		ScrollArea = stick;
		ScrollButton = bar;
		Content = field["txt"];
		ContentMask = actual["mask"];
		Content._y = -4;
		ScrollButton.onRollOver = Delegate.create(this, Bon);
		ScrollButton.onRollOut = Delegate.create(this, Bout);
		ScrollButton.onPress = Delegate.create(this, Bp);
		ScrollButton.onRelease = ScrollButton.onReleaseOutside = Proxy.create(this, onRel);
		HitZone = ContentMask.duplicateMovieClip("_hitzone_", this.getNextHighestDepth());
		HitZone._alpha = 0;
		HitZone._width = ContentMask._width;
		HitZone._height = ContentMask._height;
		Content.setMask(ContentMask);
		ScrollArea.onPress = Delegate.create(this, startScroll);
		ScrollArea.onRelease = ScrollArea.onReleaseOutside=Delegate.create(this, stopScroll);
		viewHeight = ContentMask._height;
		totalHeight = Content._height;
		scrollable = false;
		updateScrollbar();
		Mouse.addListener(this);
	}
	
	private function updateScrollbar() {
	
		var prop:Number = viewHeight / totalHeight;
		
		if (prop>1) {
			scrollable = false;
			ScrollButton._visible = false;
			ScrollArea.enabled = false;
			scroller._visible = false;
			if (loadError == 0) {
				field["txt"]._width = settings.htmlFieldWidth;
				actual["mask"]._width = field["txt"]._width+4;
			}
			else {
				field["txt"]._width = settings.totalWidth - 20
				actual["mask"]._width = field["txt"]._width+4;
			}
			
			actual["mask"]._height = field["txt"]._height;
			
		} else {
			if (loadError == 0) {
				field["txt"]._width = settings.htmlFieldWidth - 10;
			}
			scrollable = true;
			ScrollButton._visible = true;
			ScrollArea.enabled = true;
			ScrollArea._height = actual["mask"]._height;
			ScrollButton._y = 0;
			ScrollHeight = ScrollArea._height-ScrollButton._height;
		}
	}
	
	private function startScroll() {
			
		var center:Boolean = !ScrollButton.hitTest(_level0._xmouse, _level0._ymouse, true);
		var sbx:Number = ScrollButton._x;
		if (center) {
			var sby:Number = ScrollButton._parent._ymouse-ScrollButton._height/2;
			sby<0 ? sby=0 : (sby>ScrollHeight ? sby=ScrollHeight : null);
			ScrollButton._y = sby;
		}
		ScrollButton.startDrag(false, sbx, 0, sbx, ScrollHeight);
		ScrollButton.onMouseMove = Delegate.create(this, updateContentPosition);
		updateContentPosition();
	}
	private function stopScroll() {
		ScrollButton.stopDrag();
		delete ScrollButton.onMouseMove;
	}
	private function updateContentPosition() {
		
		var contentPos:Number = (viewHeight - totalHeight) * (ScrollButton._y / ScrollHeight);
		
		this.onEnterFrame = function() {
			if (Math.abs(Content._y-contentPos)<1) {
				Content._y = contentPos;
				delete this.onEnterFRame;
				return;
			}
			
			Content._y += (contentPos-Content._y)/6;
		};
	}
	private function scrollDown() {
		var sby:Number = ScrollButton._y+ScrollButton._height/4;
		if (sby>ScrollHeight) {
			sby = ScrollHeight;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	private function scrollUp() {
		var sby:Number = ScrollButton._y-ScrollButton._height/4;
		if (sby<0) {
			sby = 0;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	private function onMouseWheel(delt:Number) {
		if (!HitZone.hitTest(_level0._xmouse, _level0._ymouse, true)) {
			return;
		}
		var dir:Number = delt/Math.abs(delt);
		if (dir<0) {
			scrollDown();
		} else {
			scrollUp();
		}
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