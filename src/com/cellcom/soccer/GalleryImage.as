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

	public class GalleryImage extends Sprite {
		public static const IMG_WIDTH:Number=(UiConst.WIN_WIDTH-(UiConst.GALLERY_SPACING*(UiConst.GALLERY_COLUMNS-1)))/(UiConst.GALLERY_COLUMNS);
		public static const IMG_HEIGHT:Number=(UiConst.WIN_HEIGHT-(UiConst.GALLERY_SPACING*(UiConst.GALLERY_ROWS-1)))/(UiConst.GALLERY_ROWS);
		private var loader:Loader;
		private var _data:Object;
		public function GalleryImage() {
			this.graphics.beginFill(UiConst.BG_MED_GREEN);
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
			loader.load(new URLRequest(UiConst.IMAGES_LINK+data.image));
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