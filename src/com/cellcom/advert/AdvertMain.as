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
		
		var deviceController:DeviceController;
		public function AdvertMain() {
			formContainerMc = formContainer;
			openButtonMc=formContainerMc.openButton;
			closeButtonMc=formContainerMc.closeButton;
			
			deviceController=new DeviceController(deviceContainer);
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			
			hotSpotContainer.rotationY = -30;
			deviceController.setDevice(deviceXperia);
			formContainerMc.x = GlobalConst.MAIN_WIDTH;
			addFormEvents();
			isClosed(true);
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