package com.cellcom.soccer{
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class WindowContainer extends Sprite {

		public function WindowContainer() {
			this.graphics.beginFill(SoccerUiConst.BG_LIGHT_GREEN,0.2);
			this.graphics.drawRect(-SoccerUiConst.WIN_WIDTH/2,-SoccerUiConst.WIN_HEIGHT/2,SoccerUiConst.WIN_WIDTH,SoccerUiConst.WIN_HEIGHT);
			this.graphics.endFill();
		}
		override public function addChild(child:DisplayObject):DisplayObject{
			this.graphics.clear();
			return super.addChild(child);
		}
	}
}