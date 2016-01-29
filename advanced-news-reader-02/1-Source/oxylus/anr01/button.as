import gs.TweenMax;

class oxylus.anr01.button extends MovieClip 
{
	private var bg_normal:MovieClip;
	private var bg_over:MovieClip;
	private var nn:MovieClip;
	private var o:MovieClip;
	private var s:MovieClip;
	
	public var node:XMLNode;
	public var settings:Object;
	public var wi:Number;
	
	public var idd:Number;
	
	public function button() {
		bg_normal = this["bg"];
		bg_over = this["bg_over"]; bg_over._alpha = 0;
		nn = this["txt_normal"];
		o = this["txt_over"]; o._alpha = 0;
		s = this["txt_sel"]; s._alpha = 0;
		
		nn["txt"].autoSize = o["txt"].autoSize = s["txt"].autoSize = true;
		nn["txt"].wordWrap = o["txt"].wordWrap = s["txt"].wordWrap = false;
		nn["txt"].selectable = o["txt"].selectable = s["txt"].selectable = false;
		
		nn._x = o._x = s._x = Math.round(10);
	}
	
	public function setNode(n:XMLNode) {
		node = n;
		nn["txt"].text = o["txt"].text = s["txt"].text = node.attributes.title;
		bg_normal._width = bg_over._width = wi;
		bg_normal._height = bg_over._height = settings.butHeight;
		
		nn._y = o._y = s._y = Math.round(settings.butHeight / 2 - nn._height / 2);
	}
	
	private function onRollOver() {
		TweenMax.to(o, 0.3, { _alpha:100 } );
		TweenMax.to(bg_over, 0.3, { _alpha:25 } );
		
	}
	
	private function onRollOut() {
		TweenMax.to(o, 0.3, { _alpha:0 } );
		TweenMax.to(bg_over, 0.3, { _alpha:0 } );

	
	}
	
	private function onPress() {
		if (s._alpha == 0) {
			this._parent._parent._parent.currentButton.res();
			ac()
			this._parent._parent._parent.currentButton = this;
			this._parent._parent._parent.scrollText(node, idd);
			this._parent._parent._parent._parent.goToPos((idd-1))
			this._parent._parent._parent.bgPress();
		}
		
	}
	
	private function onRelease() {
		onRollOut()
	}
	
	private function onReleaseOutside() {
		onRelease()
	}
	
	public function res() {
		TweenMax.to(o, 0.3, { _alpha:0 } );
		TweenMax.to(s, 0.3, { _alpha:0 } );
	}
	
	public function ac() {
		TweenMax.to(s, 0.3, { _alpha:100 } );
	}
	
	public function activ() {
		this._parent._parent._parent.currentButton.res();
		TweenMax.to(s, 0.3, { _alpha:100 } );
		this._parent._parent._parent.currentButton = this;
		this._parent._parent._parent.scrollText(node,idd);
	}
	
	
	public function callThis() {
		TweenMax.to(s, 0.3, { _alpha:100 } );
	}
	
}
		