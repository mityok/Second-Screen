package com.cellcom.thevoice{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.cellcom.global.GlobalConst;
	import flash.display.MovieClip;
	import fl.text.TLFTextField;

	public class FeedUnit extends Sprite {
		private var feed:Object;
		private var loader:Loader;
		private var uiUnit:MovieClip=new FeedUnitUi();
		public function FeedUnit(feed:Object) {
			this.addChild(uiUnit);
			this.feed = feed;
			loader=new Loader();
			Loader(loader).contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoadDone);
			loader.load(new URLRequest(GlobalConst.IMAGES_LINK+feed.feed));
			TLFTextField(uiUnit.feedTextOne).text=feed.feedtext1;
			TLFTextField(uiUnit.feedTextTwo).text=feed.feedtext2;
		}
		private function onImageLoadDone(e:Event) {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageLoadDone);
			uiUnit.imageContainer.addChild(loader);
			loader.height=loader.width=TheVoiceUiConst.FEED_ICON;
		}
		public function remove() {
			loader.unloadAndStop();
		}

	}

}