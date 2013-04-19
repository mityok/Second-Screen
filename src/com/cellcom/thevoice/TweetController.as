package com.cellcom.thevoice{
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class TweetController {
		private var tweetContMc:MovieClip;
		private var tweetHolder:Sprite=new Sprite();
		private var tweetHolderMask:Shape=new Shape();
		private var feedsList:Vector.<FeedUnit>=new Vector.<FeedUnit>();
		private var stagePosY:Number;
		private var deltaMotion:Number;
		private var totalItemsHeight:Number=0;
		private var initialHolderScroll:Number=0;
		public function TweetController(tweetCont:MovieClip) {
			tweetContMc = tweetCont;
			tweetContMc.addChild(tweetHolder);
			tweetContMc.addChild(tweetHolderMask);
			tweetHolder.mouseChildren=false;
			tweetHolder.mouseEnabled=false;
			tweetHolderMask.graphics.beginFill(0,1);
			tweetHolderMask.graphics.drawRect(0,0,TheVoiceUiConst.FEED_WIDTH,TheVoiceUiConst.FEED_HEIGHT);
			tweetHolderMask.graphics.endFill();
			tweetHolder.mask = tweetHolderMask;
			tweetContMc.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownTweet);
		}
		public function addNewFeed(feed:Object) {
			
			moveOtherUnits();
			var feedUnit:FeedUnit = new FeedUnit(feed);
			feedsList.unshift(feedUnit);
			tweetHolder.addChild(feedUnit);
			feedUnit.alpha = 0;
			TweenLite.to(feedUnit,0.5,{alpha:1});
			totalItemsHeight=feedsList.length*TheVoiceUiConst.FEED_UNIT_HEIGHT;
		}
		private function moveOtherUnits() {
			for (var i:int=0; i<feedsList.length; i++) {
				TweenLite.to(feedsList[i],0.5,{y:(i+1)*TheVoiceUiConst.FEED_UNIT_HEIGHT});
			}
		}
		public function reset() {
			totalItemsHeight=0;
			initialHolderScroll=0;
			clearEnterFrameMotion();
			var feedUnit:FeedUnit;
			for (var i:int=0; i<feedsList.length; i++) {
				feedUnit = feedsList[i];
				feedUnit.remove();
				TweenLite.killTweensOf(feedUnit);
				tweetHolder.removeChild(feedUnit);
			}
			feedsList.length=0;
		}
		private function onMouseDownTweet(e:MouseEvent){
			stagePosY = tweetContMc.mouseY;
			initialHolderScroll=tweetHolder.y;
			deltaMotion = 0;
			tweetContMc.stage.addEventListener(MouseEvent.MOUSE_UP,onMainStageMouseUp);
			tweetContMc.stage.addEventListener(MouseEvent.MOUSE_MOVE,onTweenMove);
			tweetContMc.stage.addEventListener(MouseEvent.RELEASE_OUTSIDE,onMainStageMouseUp);
			clearEnterFrameMotion();
		}
		private function onMainStageMouseUp(e:MouseEvent):void {
			tweetContMc.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onTweenMove);
			tweetContMc.stage.removeEventListener(MouseEvent.MOUSE_UP,onMainStageMouseUp);
			tweetContMc.stage.removeEventListener(MouseEvent.RELEASE_OUTSIDE,onMainStageMouseUp);
			if (Math.abs(deltaMotion) > 20) {
				tweetContMc.addEventListener(Event.ENTER_FRAME,onContinueMotion);
				trace("mot: "+deltaMotion);
			}
		}
		private function clearEnterFrameMotion(){
			tweetContMc.removeEventListener(Event.ENTER_FRAME,onContinueMotion);
		}
		private function onContinueMotion(e:Event):void {
			tweetHolder.y +=  deltaMotion;
			if (limit()) {
				clearEnterFrameMotion();
			}
		}
		private function onTweenMove(e:MouseEvent):void {
			var oldPos:Number = tweetHolder.y;
			tweetHolder.y = tweetContMc.stage.mouseY - stagePosY-TheVoiceUiConst.FEED_TOP+initialHolderScroll;
			limit();
			deltaMotion = tweetHolder.y - oldPos;
		}
		private function limit():Boolean {
			if( totalItemsHeight<TheVoiceUiConst.FEED_HEIGHT){
				tweetHolder.y = 0;
				return true;
			}
			if (-tweetHolder.y >= totalItemsHeight-TheVoiceUiConst.FEED_HEIGHT) {
				tweetHolder.y = -(totalItemsHeight-TheVoiceUiConst.FEED_HEIGHT);
				return true;
			} else if (tweetHolder.y>=0) {
				tweetHolder.y = 0;
				return true;
			} else {
				return false;
			}
		}
	}

}