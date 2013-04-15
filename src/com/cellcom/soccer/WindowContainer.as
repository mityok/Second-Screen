package com.cellcom.soccer{
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class WindowContainer extends Sprite {

		public function WindowContainer() {
			this.graphics.beginFill(UiConst.BG_LIGHT_GREEN,0.2);
			this.graphics.drawRect(-UiConst.WIN_WIDTH/2,-UiConst.WIN_HEIGHT/2,UiConst.WIN_WIDTH,UiConst.WIN_HEIGHT);
			this.graphics.endFill();
		}
		override public function addChild(child:DisplayObject):DisplayObject{
			this.graphics.clear();
			return super.addChild(child);
		}
	}
}