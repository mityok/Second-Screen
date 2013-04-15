package com.cellcom.soccer{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class ViewDisplayObject extends Sprite implements IsMainViewAware {
		protected var mainView:IsFullScreenLaunchCapable;

		public function ViewDisplayObject() {
			// constructor code
		}
		public function setView(view:IsFullScreenLaunchCapable) {
			mainView = view;
		}

	}

}