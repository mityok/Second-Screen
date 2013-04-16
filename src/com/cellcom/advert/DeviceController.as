package com.cellcom.advert{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.cellcom.global.GlobalConst;
	import flash.display.Shape;

	public class DeviceController {

		var container:MovieClip;
		var device:MovieClip;
		var stagePosX:Number = 0;
		var deltaMotion:Number;
		var spot:Shape=new Shape();
		var spot2:Shape=new Shape();
		var spot3:Shape=new Shape();
		var totalFrames:int = 0;
		public function DeviceController(container:MovieClip) {
			this.container = container;
			container.addEventListener(MouseEvent.MOUSE_DOWN,onDeviceDown);
			drawSpot(spot);
			drawSpot(spot2);
			drawSpot(spot3);
		}
		private function drawSpot(spot:Shape) {
			spot.graphics.lineStyle(3,0);
			spot.graphics.drawCircle(0,0,10);
			spot.graphics.endFill();
		}
		public function setDevice(device:MovieClip) {
			this.device = device;
			if (device) {
				container.removeChildren();
				container.addChild(device);
				device.x =  -  device.width / 2;
				device.y =  -  device.height / 2;
				totalFrames = device.totalFrames;
				device.gotoAndStop(1);
				container.addChild(spot);
				container.addChild(spot2);
				container.addChild(spot3);

			}
		}
		private function onDeviceDown(e:MouseEvent):void {
			stagePosX = container.mouseX;
			deltaMotion = 0;
			this.container.stage.addEventListener(MouseEvent.MOUSE_UP,onMainStageMouseUp);
			this.container.stage.addEventListener(MouseEvent.MOUSE_MOVE,onDeviceMove);
			this.container.stage.addEventListener(MouseEvent.RELEASE_OUTSIDE,onMainStageMouseUp);
			//;
			this.container.removeEventListener(Event.ENTER_FRAME,onContinueMotion);
		}
		private function onMainStageMouseUp(e:MouseEvent):void {
			this.container.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onDeviceMove);
			this.container.stage.removeEventListener(MouseEvent.MOUSE_UP,onMainStageMouseUp);
			this.container.stage.removeEventListener(MouseEvent.RELEASE_OUTSIDE,onMainStageMouseUp);

			if (Math.abs(deltaMotion) > (GlobalConst.MAIN_WIDTH/200)) {
				this.container.addEventListener(Event.ENTER_FRAME,onContinueMotion);
				trace("mot");
			} else {
				stopMotion();
			}
		}
		private function stopMotion():void {
			this.container.removeEventListener(Event.ENTER_FRAME,onContinueMotion);
		}
		private function onDeviceMove(e:Event):void {
			var dist:Number = container.mouseX - stagePosX;
			deltaMotion = dist;
			rotateDeviceBy(dist/(GlobalConst.MAIN_WIDTH/200));
			stagePosX = container.mouseX;
		}
		private function rotateDeviceBy(dist:Number):void {
			var normDist:int=(Math.abs(dist)/dist)*Math.ceil(Math.abs(dist));
			//trace("dist: "+dist+":"+normDist);
			var pos:int = device.currentFrame;
			var destFrame:int = pos + normDist;
			if (destFrame>totalFrames) {
				destFrame = destFrame - totalFrames;
			} else if (destFrame<1) {
				destFrame = totalFrames + destFrame;
			}
			moveSpot(destFrame);
			device.gotoAndStop(destFrame);
		}
		private function moveSpot(destFrame:int):void {
			var yCenter:int=(device.height/2)-575;
			var ang:Number=((destFrame-1)*360/totalFrames)*Math.PI/180;
			spot.x = (530 / 2) * Math.cos( -  ang) + 20;
			spot.y = (220 / 2) * Math.sin( -  ang) - yCenter + 440;
			//575
			spot2.x = (530 / 2) * Math.cos(   ang) + 20;
			spot2.y = (220 / 2) * Math.sin( ang) - yCenter- 440;
			//
			spot3.x = (530 / 2) * Math.cos(   ang) + 20;
			spot3.y = (00 / 2) * Math.sin( ang) - yCenter;
		}
		private function onContinueMotion(e:Event):void {
			deltaMotion *=  0.9;
			if (Math.abs(deltaMotion) < 1) {
				stopMotion();
			} else {
				rotateDeviceBy(deltaMotion/(GlobalConst.MAIN_WIDTH/200));
			}
		}

	}

}