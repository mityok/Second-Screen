package com.cellcom.soccer{

	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import flash.display.LoaderInfo;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import com.cellcom.debug.Stats;
	import flash.desktop.*;


	public class SoccerMain extends Sprite implements IsFullScreenLaunchCapable {
		private var fms:FmsConnection;
		private var bg:Background=new Background();
		private var windowArray:Vector.<WindowContainer >  = new Vector.<WindowContainer > (UiConst.WIN_AMOUNT,true);
		private var galleryScreen:GalleryScreen;
		private var statsScreen:StatsScreen;
		private var windowHolder:Sprite=new Sprite();
		private var initialPosition:Point = new Point();
		private var initialMousePosition:Point = new Point();
		private var totalWindowWidth:Number = 0;
		private var videoScreen:VideoScreen;
		private var pageIndicator:PageIndicator=new PageIndicator();
		private var windowSelected:int;
		private var fullScreenView:FullScreenView;
		private var totalMotionMove:Number = 0;

		private var motionDir:Point = null;
		public function SoccerMain() {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			this.addChild(bg);
			this.addChild(windowHolder);
			fms = new FmsConnection(LoaderInfo(root.loaderInfo).parameters);
			fms.addEventListener(FmsEvent.DATA_RECEIVED,onFmsDataReceived);
			fms.addEventListener(FmsEvent.DATA_FAIL,onFmsDataFail);
			fms.addEventListener(FmsEvent.CONNECTION_ESTABLISHED,onFmsConnectionEstablished);
			windowHolder.x = UiConst.MAIN_WIDTH / 2;
			windowHolder.y = 100+(UiConst.MAIN_HEIGHT / 2);
			totalWindowWidth=UiConst.WIN_WIDTH*UiConst.WIN_AMOUNT+UiConst.WIN_SPACING*(UiConst.WIN_AMOUNT-1);
			galleryScreen=new GalleryScreen();
			statsScreen=new StatsScreen();
			videoScreen=new VideoScreen();
			fullScreenView=new FullScreenView();
			for (var i:int=0; i<UiConst.WIN_AMOUNT; i++) {
				var windCont:WindowContainer=new WindowContainer();
				windowArray[i] = windCont;
				windCont.x = UiConst.WIN_WIDTH/2+((UiConst.WIN_WIDTH + UiConst.WIN_SPACING)*i)-(totalWindowWidth/2);
				windowHolder.addChild(windCont);
			}
			windowSelected = 1;
			addToWindow(windowArray[2],galleryScreen);
			addToWindow(windowArray[1],statsScreen);
			addToWindow(windowArray[0],videoScreen);
			this.addChild(pageIndicator);
			pageIndicator.x = UiConst.MAIN_WIDTH / 2 - pageIndicator.getWidth() / 2;
			pageIndicator.y = UiConst.MAIN_HEIGHT - 70;
			pageIndicator.setCurrentPage(windowSelected);
			pageIndicator.addEventListener(SelectedPageEvent.SELECTED_PAGE_EVENT,onPageSelected);
			this.addChild(fullScreenView);
			addMainStageListeners();
			//this.addChild(new Stats());
		}
		private function onPageSelected(e:SelectedPageEvent):void {
			windowSelected = e.selectedPage;
			tweenToWindow(windowSelected);
		}
		private function addToWindow(win:DisplayObjectContainer,screen:ViewDisplayObject):void {
			win.addChild(screen);
			screen.x =  -  UiConst.WIN_WIDTH / 2;
			screen.y =  -  UiConst.WIN_HEIGHT / 2;
			screen.setView(this);
		}
		private function addMainStageListeners():void {
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMainStageMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onMainStageMouseUp);
			this.stage.addEventListener(MouseEvent.RELEASE_OUTSIDE,onMainStageMouseUp);
		}

		private function onMainStageMouseDown(e:MouseEvent):void {
			totalMotionMove = 0;

			TweenLite.killTweensOf(windowHolder);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMainStageMouseMove);
			initialPosition.x = this.windowHolder.x;
			initialPosition.y = this.windowHolder.y;
			initialMousePosition.x = this.stage.mouseX;
			initialMousePosition.y = this.stage.mouseY;
			galleryScreen.motionStarted();
			motionDir = null;
			if ( windowSelected==2) {
				galleryScreen.setInitialPositionY();
			}
		}

		private function onMainStageMouseUp(e:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMainStageMouseMove);
			setTimeout(function(){windowHolder.mouseChildren=true;},100);
			galleryScreen.motionStoped();
			detectWindowFocus();
		}
		private function onMainStageMouseMove(e:MouseEvent):void {
			var deltaMotionX:Number = this.stage.mouseX - initialMousePosition.x;
			var deltaMotionY:Number = this.stage.mouseY - initialMousePosition.y;
			var delta:Number = Math.sqrt(Math.pow(deltaMotionX,2) + Math.pow(deltaMotionY,2));
			totalMotionMove +=  delta;

			if (fullScreenView.visible) {
				return;
			}
			if (totalMotionMove>150) {
				this.windowHolder.mouseChildren = false;
			}

			//if moved more than x in any direction
			// calculate in which direction was motion and lock it
			//until release

			//possible in both direction
			if (windowSelected == 2) {
				if (totalMotionMove>150) {//lock direction
					if (motionDir==null) {
						motionDir = motionDirection(deltaMotionX,deltaMotionY);

					}
					if (motionDir.y == 0) {
						motionX(deltaMotionX);
					} else {
						galleryScreen.moveY(deltaMotionY);
					}
				}
			} else {
				//move in x only
				motionX(deltaMotionX);

			}
			updateIndicator();
		}
		private function motionX(dx:Number):void {
			windowHolder.x = dx + initialPosition.x;
			if (windowHolder.x > totalWindowWidth / 2 + UiConst.MAIN_WIDTH / 2) {
				windowHolder.x = totalWindowWidth / 2 + UiConst.MAIN_WIDTH / 2;
			} else if (windowHolder.x<-totalWindowWidth/2+UiConst.MAIN_WIDTH/2) {
				windowHolder.x =  -  totalWindowWidth / 2 + UiConst.MAIN_WIDTH / 2;
			}
		}
		private function motionDirection(dx:Number,dy:Number):Point {
			var dir:Point=new Point();
			var angle:Number=180+ (Math.atan2(-dy,-dx)* 180/Math.PI);
			if (angle>225 && angle<315) {
				dir = new Point(0,1);
			} else if (angle>45 && angle<135) {
				dir = new Point(0,-1);
			} else if (angle>135 && angle<225) {
				dir = new Point(-1,0);
			} else {
				dir = new Point(1,0);
			}
			//225 - 315 up
			//315 - 360 && 0 - 45 right
			// 45 - 135 down
			// 135- 225 left
			return dir;
		}
		private function updateIndicator():void {
			var winSelected:int = getWinInFocus();
			this.pageIndicator.setCurrentPage(winSelected);
		}
		private function getWinInFocus():int {
			return Math.floor(UiConst.WIN_AMOUNT/2-((windowHolder.x-UiConst.MAIN_WIDTH/2)/(UiConst.WIN_WIDTH+UiConst.WIN_SPACING)));
		}
		private function detectWindowFocus():void {
			windowSelected = getWinInFocus();
			tweenToWindow(windowSelected);
		}
		private function tweenToWindow(win:int):void {
			var windowSelectedPos:int = UiConst.WIN_WIDTH/2+((UiConst.WIN_WIDTH + UiConst.WIN_SPACING)*win)-(totalWindowWidth/2);
			var winHolderPos:int = UiConst.MAIN_WIDTH / 2 - windowSelectedPos;
			TweenLite.to(windowHolder,1,{x:winHolderPos,ease:Back.easeOut,onComplete:onWindowFocusDone});

		}
		private function onWindowFocusDone() {
			if (windowSelected==0) {
				videoScreen.resume();
			} else {
				videoScreen.pause();
			}
		}
		private function onFmsDataReceived(e:FmsEvent):void {
			if (e.data) {
				switch (e.data.type) {
					case "image" :
						galleryScreen.insertImage(e.data);
						break;
					case "stats" :
						statsScreen.updateStageOne(e.data);
						break;
					case "stats2" :
						statsScreen.updateStageTwo(e.data);
						break;
					case "video" :
						videoScreen.setVideoData(e.data);
						break;
					case "startgame" :
						resetAll(e.data);
						break;
					case "score" :
						bg.updateScore(e.data);
						break;
				}
				//types: image, stats, stats2,video, startgame, score
			}
		}
		private function resetAll(data:Object):void {
			//{"type":"startgame","startgame":"34"}
			if (data.startgame && ! isNaN(data.startgame)) {
				bg.resetTimer(Number(data.startgame)*60*1000);
			}
			galleryScreen.reset();

		}
		private function onFmsDataFail(e:FmsEvent):void {
			trace("fail");
		}
		private function onFmsConnectionEstablished(e:FmsEvent):void {

		}
		public function launchFullScreen(data:Object) {
			if (windowSelected==2) {
				trace("click");
				this.fullScreenView.show(data);
			}
		}
	}

}