package com.cellcom.soccer{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.JointStyle;
	import flash.display.CapsStyle;
	import flash.events.MouseEvent;
	import fl.text.TLFTextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.LineScaleMode;
	import com.greensock.easing.Back;
	import flash.events.IOErrorEvent;

	public class FullScreenView extends Sprite {
		private var loader:Loader=new Loader();
		private var back:Sprite=new Sprite();
		private var imageFrame:Sprite=new Sprite();
		private var imageBorder:Shape=new Shape();
		public static const FRAME_OFFSET:Number = 80;
		private var frameTitle:FullScreenTitle=new FullScreenTitle();
		private var imageTitle:TLFTextField = frameTitle.imageTitle;
		private var imageContainer:Sprite=new Sprite();
		private var loaded:Boolean;
		public function FullScreenView() {
			back.graphics.beginFill(0x000000,0.7);
			back.graphics.drawRect(0,0,UiConst.MAIN_WIDTH,UiConst.MAIN_HEIGHT);
			back.graphics.endFill();
			//
			imageFrame.graphics.beginFill(UiConst.BG_GREEN,1);
			imageFrame.graphics.drawRect(0,-FRAME_OFFSET,UiConst.FULL_SCREEN_MAX_WIDTH,FRAME_OFFSET+UiConst.FULL_SCREEN_MAX_HEIGHT);
			imageFrame.graphics.endFill();
			//
			imageFrame.x=(-UiConst.FULL_SCREEN_MAX_WIDTH)/2;
			imageFrame.y = (-UiConst.FULL_SCREEN_MAX_HEIGHT/2)+100;
			back.addEventListener(MouseEvent.CLICK,onBackClick);
			//
			
			frameTitle.y =  -  FRAME_OFFSET;
			//
			imageTitle.autoSize = TextFieldAutoSize.RIGHT;
			//
			imageBorder.graphics.lineStyle(3,0xffffff,1,true,LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER,3);
			
			imageBorder.graphics.drawRect(0,0,UiConst.FULL_SCREEN_MAX_WIDTH,UiConst.FULL_SCREEN_MAX_HEIGHT+FRAME_OFFSET);
			imageBorder.graphics.endFill();
			imageBorder.x=(imageFrame.x);
			imageBorder.y = imageFrame.y - FRAME_OFFSET;
			//
			this.addChild(back);
			imageContainer.addChild(imageFrame);
			imageContainer.addChild(imageBorder);
			this.addChild(imageContainer);
			imageContainer.x = UiConst.MAIN_WIDTH / 2;
			imageContainer.y = UiConst.MAIN_HEIGHT / 2;
			this.visible = false;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadDone);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);

			imageFrame.addChild(loader);
			imageFrame.addChild(frameTitle);
		}
		private function onBackClick(e:Event) {
			hide();
		}

		private function onLoadError(e:IOErrorEvent):void{
			
		}
		private function showDone() {
			frameTitle.visible = true;
			showAfterLoad();
		}
		private function onLoadDone(e:Event) {
			loader.width = UiConst.FULL_SCREEN_MAX_WIDTH;
			loader.height = UiConst.FULL_SCREEN_MAX_HEIGHT;
			// choose the larger scale property and match the other to it;
			( loader.scaleX < loader.scaleY ) ? loader.scaleY = loader.scaleX : loader.scaleX = loader.scaleY;
			loader.x=(-loader.width + UiConst.FULL_SCREEN_MAX_WIDTH)/2;
			loader.y=(-loader.height + UiConst.FULL_SCREEN_MAX_HEIGHT)/2;
			this.loaded = true;
			showAfterLoad();

		}
		private function showAfterLoad() {
			if (loader.alpha == 0 && imageContainer.scaleY==1 && this.loaded ) {
				TweenLite.to(loader,0.3,{alpha:1});
			}
		}
		public function show(data:Object):void {
			visible = true;
			this.loaded = false;
			loader.unloadAndStop(true);
			loader.alpha = 0;
			this.alpha=1;
			imageTitle.text = data.title;
			frameTitle.visible = false;
			imageContainer.scaleX = imageContainer.scaleY = 0.1;
			TweenLite.to(imageContainer,0.5,{scaleY:1,delay:0.5,overwrite:false,ease:Back.easeOut,onComplete:showDone});
			TweenLite.to(imageContainer,0.5,{scaleX:1,overwrite:false ,ease:Back.easeOut});
			loader.load(new URLRequest(UiConst.IMAGES_LINK+data.image));
		}
		public function hide():void {
			TweenLite.to(this,0.3,{alpha:0,onComplete:hideDone});
		}
		private function hideDone() {
			this.visible=false;
			trace("hidedone");
		}
	}
}
