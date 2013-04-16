package com.cellcom.advert{

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.desktop.*;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import com.cellcom.global.GlobalConst;
	import com.greensock.TweenLite;
	import flash.events.Event;


	public class AdvertMain extends MovieClip {
		var stagePosX:Number = 0;
		var deviceXperia:MovieClip= new DeviceXperia();
		
		var formContainerMc:MovieClip;
		var deltaMotion:Number;
		var openButtonMc:MovieClip
		var closeButtonMc:MovieClip
		var hotspotLink:Shape=new Shape();
		var deviceController:DeviceController;
		var linkConnectorMc:MovieClip;
		var hotSpotContainerMc:MovieClip;
		var dotMarker:DotMarker;
		public function AdvertMain() {
			dotMarker=new DotMarker(GlobalConst.CELLCOM_DARK_PURPLE);
			dotMarker.visible=false;
			formContainerMc = formContainer;
			openButtonMc=formContainerMc.openButton;
			closeButtonMc=formContainerMc.closeButton;
			linkConnectorMc=linkConnector;
			hotSpotContainerMc=hotSpotContainer;
			deviceController=new DeviceController(deviceContainer,notify,startMotion);
			linkConnectorMc.addChild(dotMarker);						
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			
			deviceController.setDevice(deviceXperia);
			formContainerMc.x = GlobalConst.MAIN_WIDTH;
			addFormEvents();
			isClosed(true);
		}
		private function  startMotion():void {
			clearHotSpot();
		}
		private function  notify(x:int,y:int,count:int):void {
			trace(x,y,count);
		
			clearHotSpot();
			
			var spot:MovieClip=new HotspotScreenGalaxy();
			var dir:int=0;
			if(x>GlobalConst.MAIN_WIDTH/2){
				spot.x=0;
				hotSpotContainerMc.x=GlobalConst.MAIN_WIDTH-AdvertConst.HOTSPOTS_CONTAINER_OFFSET-AdvertConst.HOTSPOTS_WIDTH;
				
				dir=1;
			}else{
				spot.x=-AdvertConst.HOTSPOTS_WIDTH;
				hotSpotContainerMc.x=AdvertConst.HOTSPOTS_CONTAINER_OFFSET+AdvertConst.HOTSPOTS_WIDTH;
				dir=-1;
			}
			hotSpotContainerMc.rotationY = dir*45;
			hotSpotContainerMc.addChild(spot);
			linkConnectorMc.graphics.lineStyle(5,0);
			linkConnectorMc.graphics.moveTo(x,y);
			linkConnectorMc.graphics.lineTo(hotSpotContainerMc.x-dir*AdvertConst.ICON_SIZE/2,hotSpotContainer.y+AdvertConst.ICON_SIZE/2);
			dotMarker.y=hotSpotContainer.y+AdvertConst.ICON_SIZE/2;
			dotMarker.x=hotSpotContainerMc.x-dir*AdvertConst.ICON_SIZE/2;
			dotMarker.visible=true;
		}
		private function  clearHotSpot():void {
			linkConnectorMc.graphics.clear();
			hotSpotContainerMc.removeChildren();
			dotMarker.visible=false;
		}
		
		private function isClosed(closed:Boolean):void {
			openButtonMc.alpha=int(closed);
			closeButtonMc.alpha=int(!closed);
		}
		
		private function addFormEvents() {
			formContainerMc.addEventListener(MouseEvent.MOUSE_DOWN,onFormMouseDown);

		}
		private function onFormMouseDown(e:MouseEvent) {
			stagePosX = formContainerMc.mouseX;
			deltaMotion = 0;
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onMainStageMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onFormMove);
			this.stage.addEventListener(MouseEvent.RELEASE_OUTSIDE,onMainStageMouseUp);
			//;
			this.removeEventListener(Event.ENTER_FRAME,onContinueMotion);
			TweenLite.killTweensOf(formContainerMc);
		}
		private function onMainStageMouseUp(e:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onFormMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onMainStageMouseUp);
			this.stage.removeEventListener(MouseEvent.RELEASE_OUTSIDE,onMainStageMouseUp);

			if (Math.abs(deltaMotion) > 20) {
				this.addEventListener(Event.ENTER_FRAME,onContinueMotion);
				trace("mot: "+deltaMotion);
			} else {
				tweenToPosition();
			}
		}
		private function onContinueMotion(e:Event):void {
			formContainerMc.x +=  deltaMotion;
			if (limit()) {
				doneTween(formContainerMc.x);
				this.removeEventListener(Event.ENTER_FRAME,onContinueMotion);
			}
		}
		private function onFormMove(e:MouseEvent):void {
			var oldPos:Number = formContainerMc.x;
			formContainerMc.x = this.stage.mouseX - stagePosX;
			limit();
			deltaMotion = formContainerMc.x - oldPos;
		}
		private function limit():Boolean {
			if (formContainerMc.x >= GlobalConst.MAIN_WIDTH) {
				formContainerMc.x = GlobalConst.MAIN_WIDTH;
				return true;
			} else if (formContainerMc.x<=0) {
				formContainerMc.x = 0;
				return true;
			} else {
				return false;
			}
		}
		private function tweenToPosition() {
			var pos:int = Math.round(formContainerMc.x / GlobalConst.MAIN_WIDTH) * GlobalConst.MAIN_WIDTH;
			var dist:Number=Math.abs((pos-formContainerMc.x)/GlobalConst.MAIN_WIDTH);
			TweenLite.to(formContainerMc,dist,{x:pos,onComplete:doneTween,onCompleteParams:[pos]});
		}
		private function doneTween(pos:int) {
			isClosed(pos!=0);
		}
	}

}