package com.cellcom.advert {
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.desktop.*;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	
	public class AdvertMain extends MovieClip {
		
		var deviceXperia:MovieClip= new DeviceXperia();
		var counter:int=0;
		
		public function AdvertMain() {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			this.stage.addChild(deviceXperia);
			
			deviceXperia.x=1024-deviceXperia.width/2;
			deviceXperia.y=768-deviceXperia.height/2;
			deviceXperia.addEventListener(MouseEvent.CLICK,onDeviceClick);
			hotSpotContainer.rotationY=-30;
			onDeviceClick(null);
		}
		private function onDeviceClick(e:MouseEvent):void{
			counter++;
			var len:int=deviceXperia.totalFrames;
			trace(len)
			if(counter>len){
				counter=1;
			}
			deviceXperia.gotoAndStop(counter);
		}
	}
	
}
