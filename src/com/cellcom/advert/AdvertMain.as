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
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import com.cellcom.fms.FmsConnection;
	import com.cellcom.fms.FmsEvent;
	import flash.display.LoaderInfo;
	import flash.display.StageQuality;


	public class AdvertMain extends MovieClip {
		private var stagePosX:Number = 0;
		private var formContainerMc:MovieClip;
		private var deltaMotion:Number;
		private var openButtonMc:MovieClip;
		private var closeButtonMc:MovieClip;
		private var hotspotLink:Shape=new Shape();
		private var deviceController:DeviceController;
		private var linkConnectorMc:MovieClip;
		private var hotSpotContainerMc:MovieClip;
		private var dotMarker:DotMarker;
		private var xperiaLoader:Loader =new Loader();
		private var galaxyLoader:Loader =new Loader();
		private var xperiaContent:MovieClip;
		private var galaxyContent:MovieClip;
		private var fms:FmsConnection;
		private var xperiaHotspotsData:Vector.<HotspotPointData > ;
		private var galaxyHotspotsData:Vector.<HotspotPointData > ;
		private var galaxyBgMc:MovieClip;
		private var xperiaBgMc:MovieClip;
		private var coverScreenMc:MovieClip;
		private var loaderContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain,null);
		public function AdvertMain() {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality=StageQuality.HIGH;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			//
			dotMarker = new DotMarker(GlobalConst.CELLCOM_DARK_PURPLE);
			dotMarker.visible = false;
			//
			galaxyBgMc=galaxyBg;
			xperiaBgMc=xperiaBg;
			galaxyBgMc.visible=xperiaBgMc.visible=false;
			formContainerMc = formContainer;
			coverScreenMc=coverScreen;
			openButtonMc = formContainerMc.openButton;
			closeButtonMc = formContainerMc.closeButton;
			linkConnectorMc = linkConnector;
			hotSpotContainerMc = hotSpotContainer;
			formContainerMc.x = GlobalConst.MAIN_WIDTH;
			coverScreenMc.mouseChildren=false;
			coverScreenMc.mouseEnabled=false;
			//

			xperiaLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onXperiaDone);
			galaxyLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onGalaxyDone);
			xperiaLoader.load(new URLRequest("xz.swf"),loaderContext);
		}
		private function onXperiaDone(e:Event) {
			xperiaContent = MovieClip(xperiaLoader.content);
			galaxyLoader.load(new URLRequest("s4.swf"),loaderContext);

		}
		private function onGalaxyDone(e:Event) {
			galaxyContent = MovieClip(galaxyLoader.content);
			init();
		}
		private function init() {
			galaxyHotspotsData=Vector.<HotspotPointData>([new HotspotPointData(450,300,new HotspotCameraGalaxy(),false),new HotspotPointData(600,280,new HotspotScreenGalaxy()),new HotspotPointData(350,1100,new HotspotNfcGalaxy(),true),new HotspotPointData(760,660,new HotspotWeightGalaxy()),new HotspotPointData(400,570,new HotspotGlassGalaxy()) ]);
			//
			xperiaHotspotsData=Vector.<HotspotPointData>([new HotspotPointData(350,290,new HotspotScreenXperia()),new HotspotPointData(750,150,new HotspotWaterXperia()),new HotspotPointData(550,300,new HotspotCameraXperia(),false),new HotspotPointData(600,590,new HotspotGlassXperia()),new HotspotPointData(300,1100,new HotspotNfcXperia()) ]);
			deviceController = new DeviceController(deviceContainer,notify,startMotion);
			linkConnectorMc.addChild(dotMarker);
			//
			addFormEvents();
			isClosed(true);
			//
			fms = new FmsConnection(LoaderInfo(root.loaderInfo).parameters,GlobalConst.FMS_CONNECTION_ADV);
			fms.addEventListener(FmsEvent.DATA_RECEIVED,onFmsDataReceived);
			fms.addEventListener(FmsEvent.DATA_FAIL,onFmsDataFail);
			fms.addEventListener(FmsEvent.CONNECTION_ESTABLISHED,onFmsConnectionEstablished);
		}
		private function startMotion():void {
			clearHotSpot();
		}
		private function notify(x:int,y:int,spot:MovieClip):void {
			trace(x,y,spot);
			clearHotSpot();
			var dir:int = 0;
			if (x>GlobalConst.MAIN_WIDTH/2) {
				spot.x = 0;
				hotSpotContainerMc.x = GlobalConst.MAIN_WIDTH - AdvertConst.HOTSPOTS_CONTAINER_OFFSET - AdvertConst.HOTSPOTS_WIDTH;
				dir = 1;
			} else {
				spot.x =  -  AdvertConst.HOTSPOTS_WIDTH;
				hotSpotContainerMc.x = AdvertConst.HOTSPOTS_CONTAINER_OFFSET + AdvertConst.HOTSPOTS_WIDTH;
				dir = -1;
			}
			replayFromStart(spot);
			hotSpotContainerMc.rotationY = dir * 45;
			hotSpotContainerMc.addChild(spot);
			drawLinkConnection(x,y,dir);
			dotMarker.y = hotSpotContainer.y + AdvertConst.ICON_SIZE / 2;
			dotMarker.x = hotSpotContainerMc.x - dir * AdvertConst.ICON_SIZE / 2;
			dotMarker.visible = true;
		}
		private function drawLinkConnection(x:int,y:int,dir:int):void {
			//TODO: fix line overlapping
			linkConnectorMc.graphics.lineStyle(5,GlobalConst.CELLCOM_DARK_PURPLE);
			linkConnectorMc.graphics.moveTo(x,y);
			linkConnectorMc.graphics.lineTo(hotSpotContainerMc.x-dir*AdvertConst.ICON_SIZE/2,hotSpotContainer.y+AdvertConst.ICON_SIZE/2);
		}
		private function replayFromStart(mc:MovieClip):void {
			mc.gotoAndPlay(1);
			for (var i:int=0; i<mc.numChildren; i++) {
				if (mc.getChildAt(i) is MovieClip) {
					replayFromStart(MovieClip(mc.getChildAt(i)));
				}
			}
		}
		private function clearHotSpot():void {
			linkConnectorMc.graphics.clear();
			hotSpotContainerMc.removeChildren();
			dotMarker.visible = false;
		}

		private function isClosed(closed:Boolean):void {
			openButtonMc.alpha = int(closed);
			closeButtonMc.alpha = int(! closed);
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
		private function onFmsDataReceived(e:FmsEvent):void {
			if (e.data) {
				switch (e.data.type) {
					case "galaxy" :
					showCover(setGalaxy);
						
						break;
					case "xperia" :
					showCover(setXperia);
					
						
						break;
				}
			}
		}
		private function showCover(setDevice:Function){
			coverScreenMc.visible=true;
			
			TweenLite.to(coverScreenMc,0.5,{alpha:1,onComplete:setDevice});
		}
		private function hideCover(){
			TweenLite.to(coverScreenMc,0.5,{alpha:0,onComplete:function(){
						 coverScreenMc.visible=false;
						 coverScreenMc.alpha=0;}});
		}
		private function setXperia() {
			hideCover();
			clearHotSpot();
			deviceController.setDevice(xperiaContent,new HotspotConfig(575,xperiaContent.width,xperiaContent.height,20,530/2,130,600),xperiaHotspotsData);
			xperiaBgMc.visible=true;
			galaxyBgMc.visible=false;
		}
		private function setGalaxy() {
			hideCover();
			clearHotSpot();
			deviceController.setDevice(galaxyContent,new HotspotConfig(575,galaxyContent.width,galaxyContent.height,20,530/2,130,600),galaxyHotspotsData);
			xperiaBgMc.visible=false;
			galaxyBgMc.visible=true;
		}
		private function onFmsDataFail(e:FmsEvent):void {

		}
		private function onFmsConnectionEstablished(e:FmsEvent):void {

		}
	}

}