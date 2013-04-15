package com.cellcom.soccer{
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class PageIndicator extends Sprite {
		public static const DOT_SIZE:int = 10;
		public static const DOT_SPACING:int = 100;

		private var currentPage:int = -1;
		private var dots:Vector.<Sprite >  = new Vector.<Sprite > (UiConst.WIN_AMOUNT,true);
		public function PageIndicator() {

			for (var i:int=0; i<UiConst.WIN_AMOUNT; i++) {
				dots[i] = createIndicatorDot();
				dots[i].x = i * DOT_SPACING;
			}
		}
		public function setCurrentPage(page:int) {
			if (currentPage==page) {
				return;
			}
			currentPage = page;
			for (var i:int=0; i<UiConst.WIN_AMOUNT; i++) {
				var dot:Sprite = dots[i];
				if (i==page) {
					TweenLite.to(dot,0.3,{alpha:1,scaleX:1,scaleY:1});
				} else {
					TweenLite.to(dot,0.1,{alpha:0.5,scaleX:0.5,scaleY:0.5});
				}
			}

		}
		private function createIndicatorDot():Sprite {
			var dot:Sprite=new Sprite();
			dot.graphics.beginFill(0xffffff,0.0);
			dot.graphics.drawCircle(0,0,DOT_SPACING/2);
			dot.graphics.endFill();
			dot.graphics.beginFill(0xffffff,1);
			dot.graphics.drawCircle(0,0,DOT_SIZE);
			dot.graphics.endFill();
			dot.alpha = 0.5;
			dot.scaleX = 0.5;
			dot.scaleY = 0.5;
			this.addChild(dot);
			dot.addEventListener(MouseEvent.CLICK,onClick);
			return dot;
		}
		public function getWidth():Number {
			return dots.length*DOT_SPACING;
		}
		private function onClick(e:MouseEvent):void {
			var position:int = dots.indexOf(e.currentTarget);
			if (position!=currentPage) {
				setCurrentPage(position);
				this.dispatchEvent(new SelectedPageEvent(SelectedPageEvent.SELECTED_PAGE_EVENT,position));
			}
		}
	}

}