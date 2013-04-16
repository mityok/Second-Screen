package com.cellcom.advert{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.cellcom.global.GlobalConst;
	import flash.display.Shape;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	import com.greensock.easing.Ease;

	public class DeviceController {

		var container:MovieClip;
		var device:MovieClip;
		var stagePosX:Number = 0;
		var deltaMotion:Number;
		var spot:Shape=new Shape();
		var spot2:Shape=new Shape();
		var spot3:Shape=new Shape();
		var totalFrames:int = 0;
		var hotspots:Vector.<HotspotIndicator>=new Vector.<HotspotIndicator>();
		var hotPoints:Vector.<Point>=new Vector.<Point>();
		var inMotion:Boolean=false;
		var notify:Function;
		var startMotion:Function;
		public function DeviceController(container:MovieClip,notify:Function,startMotion:Function) {
			this.container = container;
			this.notify=notify;
			this.startMotion=startMotion;
			container.addEventListener(MouseEvent.MOUSE_DOWN,onDeviceDown);
			container.addEventListener(MouseEvent.CLICK,onClick);
			hotPoints.push(new Point(350,890));
			hotPoints.push(new Point(650,150));
			hotPoints.push(new Point(-450,300));
			//
			hotPoints.push(new Point(650,890));
			hotPoints.push(new Point(350,150));
			//
		}
		private function onClick(e:MouseEvent){
			if(e.target is HotspotIndicator && !inMotion){
				var spot:HotspotIndicator=HotspotIndicator(e.target);
				notify(container.x+spot.x,container.y+spot.y,hotspots.indexOf(spot));
			}
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
				var config:HotspotConfig=new HotspotConfig(575,device.width,device.height,20,530/2,130,600);
				for (var i:int=0; i<hotPoints.length; i++) {
					var spot:HotspotIndicator=new HotspotIndicator(hotPoints[i],config)
					hotspots.push(spot);
					container.addChild(spot);
					turnSpot(spot,0);
				}
			}
		}
		private function hideHotSpots(){
			for (var i:int=0; i<hotspots.length; i++) {
				TweenLite.to(hotspots[i],0.1,{alpha:0,scaleX:0,scaleY:0});
			}
		}
		private function showHotSpots(){
			for (var i:int=0; i<hotspots.length; i++) {
				TweenLite.to(hotspots[i],0.3,{alpha:1,scaleX:1,scaleY:1,delay:i*0.1});
			}
		}
		private function turnSpot(spot:HotspotIndicator,angle:Number):void {
			spot.turn(angle);
			var num:int=container.numChildren;
			//back
			if(angle>Math.PI/2 && angle<Math.PI/2+Math.PI){
				if(!spot.isFrontFacing()){
					container.setChildIndex(spot,num-1);
				}else{
					container.setChildIndex(spot,0);
				}
			}else{
				if(spot.isFrontFacing()){
					container.setChildIndex(spot,num-1);
				}else{
					container.setChildIndex(spot,0);
				}
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
			} else {
				stopMotion();
			}
		}
		private function stopMotion():void {
			showHotSpots();
			inMotion=false;
			this.container.removeEventListener(Event.ENTER_FRAME,onContinueMotion);
		}
		private function onDeviceMove(e:Event):void {
			var dist:Number = container.mouseX - stagePosX;
			if(Math.abs(dist)>0){
				if(!inMotion){
					startMotion();
					inMotion=true;
					hideHotSpots();
				}
			}
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
			//var yCenter:int=(device.height/2)-575;
			var ang:Number=((destFrame-1)*360/totalFrames)*Math.PI/180;
			for (var i:int=0; i<hotspots.length; i++) {
				turnSpot(hotspots[i],ang);
			}
			/*
			spot.x = (530 / 2) * Math.cos( -  ang) + 20;
			spot.y = (220 / 2) * Math.sin( -  ang) - yCenter + 440;
			//575
			spot2.x = (530 / 2) * Math.cos(   ang) + 20;
			spot2.y = (220 / 2) * Math.sin( ang) - yCenter- 440;
			//
			spot3.x = (530 / 2) * Math.cos(   ang) + 20;
			spot3.y = (00 / 2) * Math.sin( ang) - yCenter;
			*/
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