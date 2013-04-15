package com.cellcom.soccer{
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import fl.transitions.Tween;
	import com.greensock.TweenLite;
	import flash.events.ErrorEvent;
	import flash.display.Bitmap;
	import flash.events.IOErrorEvent;
	import com.cellcom.global.GlobalConst;

	public class GalleryImage extends Sprite {
		public static const IMG_WIDTH:Number=(SoccerUiConst.WIN_WIDTH-(SoccerUiConst.GALLERY_SPACING*(SoccerUiConst.GALLERY_COLUMNS-1)))/(SoccerUiConst.GALLERY_COLUMNS);
		public static const IMG_HEIGHT:Number=(SoccerUiConst.WIN_HEIGHT-(SoccerUiConst.GALLERY_SPACING*(SoccerUiConst.GALLERY_ROWS-1)))/(SoccerUiConst.GALLERY_ROWS);
		private var loader:Loader;
		private var _data:Object;
		public function GalleryImage() {
			this.graphics.beginFill(SoccerUiConst.BG_MED_GREEN);
			this.graphics.drawRect(0,0,IMG_WIDTH,IMG_HEIGHT);
			this.graphics.endFill();
			loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadDone);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			this.addChild(loader);
			loader.alpha = 0;
		}
		private function onLoadError(e:IOErrorEvent):void{
			
		}
		public function setData(data:Object):void {
			_data = data;
			if(data.image== null || data.image=="" || data.image==undefined){
				return;
			}
			loader.load(new URLRequest(GlobalConst.IMAGES_LINK+data.image));
		}
		private function onLoadDone(e:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadDone);
			try {
				Bitmap(loader.content).smoothing = true;
			} catch (e: * ) {

			}
			loader.width = IMG_WIDTH;
			loader.height = IMG_HEIGHT;
			TweenLite.to(loader,1,{alpha:1});
		}
		public function getData():Object {
			return _data;
		}
	}

}