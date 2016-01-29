import flash.filters.BlurFilter;
import gs.TweenMax;
import ascb.util.Proxy;
import gs.easing.*;

class oxylus.alr01.menu extends MovieClip 
{
	public var currentButton:MovieClip;
	
	public var settings:Object;
	private var deBg:MovieClip;
	private var acBg:MovieClip;
	private var deAr:MovieClip;
	private var title:MovieClip;
	private var lst:MovieClip;
	public var holder:MovieClip;
	private var mask:MovieClip;
	private var i:Number=0;
	private var node:XMLNode;
	private var ms:MovieClip;
	
	private var tol:Number;
	private var actualMaskWidth:Number;
	private var actualMaskHeight:Number;
	public static var ypos:Number;
	private var actualLstHeight:Number;
	
	public var myInt:Number;
	
	private var defY:Number;
	
	private var scrolling:Number = 0;
	
	private var idx:Number = 0;
	
	private var defYY:Number;
	
	private var dup:MovieClip;
	
	public function menu() {
		deBg = this["deBg"];
		acBg = this["acBg"]; acBg._alpha = 0;
		deAr = this["deAr"];
		title = this["title"];
		lst = this["lst"];
		ms = this["mask"];
		title.setMask(ms);
		holder = lst["holder"];
		mask = lst["mask"];
		holder.setMask(mask);
		title["a"]["t"]["txt"].autoSize = true;
		title["a"]["t"]["txt"].wordWrap = false;
		title["a"]["c"]["txt"].autoSize = true;
		title["a"]["c"]["txt"].wordWrap = false;
		
		deBg.onRollOver = Proxy.create(this, bgRO);
		deBg.onRollOut = Proxy.create(this, bgROO);
		deBg.onPress =Proxy.create(this, bgPress);
		
	}
	private function bgRO() {
		if (scrolling == 0) {
			TweenMax.to(acBg, 0.5, { _alpha:20 } );
		}
	}
	
	private function bgROO() {
		if (scrolling == 0) {
			TweenMax.to(acBg, 0.5, { _alpha:0 } );
		}
		
	}

	
	public function bgPress() {
		if (scrolling == 0) {
			scrolling = 1;
			startScroll();
			if (TweenMax.isTweening(acBg)) {
				TweenMax.killTweensOf(acBg, false);
			}
			TweenMax.to(acBg, 0.5, { _alpha:45 } );
		}
		else {
			scrolling = 0;
			stopScroll();
			if (TweenMax.isTweening(acBg)) {
				TweenMax.killTweensOf(acBg, false);
			}
			TweenMax.to(acBg, 0.5, { _alpha:0 } );
		}
	}
	
	public function resize() {
		deBg._width = acBg._width = lst["mask"]._width = lst["bg"]._width = ms._width = settings.bgWidth;
		deBg._height = acBg._height = ms._height = settings.bgHeight;
		lst["mask"]._height = lst["bg"]._width = settings.maskHeight;
		defY = -settings.bgHeight - 2;
		deBg._y = acBg._y = ms._y = defY;
		title._y = Math.round(defY / 2 - title["a"]["t"]._height / 2);
		deAr._y = Math.round(defY / 2 - deAr._height / 2-2);
		deAr._x = Math.round(deBg._width - deAr._width-7);
	}
	
	public function scrollText(n:XMLNode,id:Number) {
		var a:MovieClip = dup;
		TweenMax.to(a, 0.5, { _y:-a._height, onComplete:onFinishTween, onCompleteParams:[a]} );
		
		i++;
		dup = title["a"].duplicateMovieClip("dup-" + i, i);
		
		
		dup["t"]["txt"].autoSize = true;
		dup["t"]["txt"].wordWrap = false;
		dup["c"]["txt"].autoSize = true;
		dup["c"]["txt"].wordWrap = false;
		
		dup["t"]["txt"].text = n.attributes.title;
		dup["c"]["txt"].text = "(" + id + "/" + idx + ")";
		dup["t"]._x = dup["c"]._x = 10;
		dup["c"]._x = Math.round(dup["t"]._width + dup["t"]._x);
		dup._y = dup._height;
		dup._x = Math.round(title["a"]._x);
		TweenMax.to(dup, 0.5, { _y:1 } );
		
		if (title["a"]._y != Math.round(defY  - title._height)) {
			TweenMax.to(title["a"], 0.5, { _y:Math.round(defY  - title._height)} );
		}
	}
	
	private function onFinishTween(clip_mc:MovieClip) {
		clip_mc.removeMovieClip();
	}
	
	public function setNode(n:XMLNode) {
		node = n;
		
		
		
		generate();
	}
	
	private function generate() {
		var aux:XMLNode = node;
		var currentPos:Number = 0;
		for (; aux != null; aux = aux.nextSibling) {
			holder.attachMovie("IDbutton", "but" + idx, holder.getNextHighestDepth());
			holder["but" + idx].settings = settings;
			holder["but" + idx].wi = settings.bgWidth;
			holder["but" + idx].setNode(aux);
			holder["but" + idx]._y = currentPos;
			holder["but" + idx].idd = idx+1;
			currentPos += settings.butHeight + 2;
			idx++;
		}
		
		title["a"]["t"]._x = title["a"]["c"]._x = 10;
		title["a"]["t"]["txt"].text = node.attributes.title;
		title["a"]["c"]["txt"].text = "(1/" + idx + ")";
		title["a"]["c"]._x = Math.round(title["a"]["t"]._width + title["a"]["t"]._x);
		
		defYY = title["a"]._y;
		
		currentButton = holder["but" + 0];
		currentButton.activ();
		
		tol = settings.butHeight;
		actualMaskWidth = settings.bgWidth;
		actualMaskHeight = settings.maskHeight;
		actualLstHeight = currentPos;
		mask._height = 0;
	}
	
	public function startScroll() {
		if (TweenMax.isTweening(mask)) {
			TweenMax.killTweensOf(mask, false);
		}
		
		TweenMax.to(mask, 1, { _height:settings.maskHeight,ease:Bounce.easeOut } );
		myInt = setInterval(this, "movemouse", 20);
	}
	
	public function stopScroll() {
		if (TweenMax.isTweening(mask)) {
			TweenMax.killTweensOf(mask, false);
		}
		
		TweenMax.to(mask, 1, { _height:0,ease:Bounce.easeOut } );
		clearInterval(myInt);
	}
	
	public function movemouse() // this mouse executes on an interval and it will verify if the mouse is on the scroller, in order to make it "move"
	{
		if ((_xmouse > 0) && (_xmouse < actualMaskWidth) && (_ymouse < actualMaskHeight + lst._y) && (_ymouse >=deBg._y)) {
			var ym:Number = _ymouse-tol;
			if (ym<0) {
				ym = 0;
				
			}
		
			if (ym>(actualMaskHeight-2*tol)) {
					ym = actualMaskHeight-2*tol;
			}
			
			ypos = Math.round((ym*(actualMaskHeight-actualLstHeight))/(actualMaskHeight-2*tol));

			holder.onEnterFrame = function() {
				
				if (Math.abs(this._y-ypos)<1) {
					delete this.onEnterFrame;
						blur(0, this);
						this._y = ypos;
					return;
				} else {
						if (Math.abs(ypos-this._y)>50) {
							blur(Math.abs((ypos - this._y) / 12), this);
						
						} else {
							blur(0,this);
						}
					this._y += Math.round((ypos - this._y) / 4);
					
				}
			};
		}
		else {
			if (scrolling == 1) {
				bgPress();
			}
		}
		
		
	}
	
	public static function blur(blurY:Number,mc:MovieClip) //function used for blurring the image
	{
		var blurX:Number = 0;
		var quality:Number = 2;
		var filter:BlurFilter = new BlurFilter(blurX, blurY, quality);
		mc.filters = [filter];
	}
}