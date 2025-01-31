﻿package com.cellcom.soccer{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import com.cellcom.global.GlobalConst;

	public class VideoScreen extends ViewDisplayObject {
		private var videoPlayer:SimpleVideoPlayer;
		private var indicator:LiveIndicator=new LiveIndicator();
		private var controlls:MovieClip=new VideoControlls();
		public function VideoScreen() {
			
			this.graphics.beginFill(0,1);
			this.graphics.drawRect(0,0,SoccerUiConst.WIN_WIDTH,SoccerUiConst.WIN_HEIGHT);
			this.graphics.endFill();
			videoPlayer = new SimpleVideoPlayer(1280,720);
			var cont:Sprite=new Sprite();
			this.addChild(cont);
			cont.addChild(videoPlayer.getVideo());
			var msk:Shape=new Shape();
			msk.graphics.beginFill(0,1);
			msk.graphics.drawRect(0,0,SoccerUiConst.WIN_WIDTH,SoccerUiConst.WIN_HEIGHT);
			msk.graphics.endFill();
			this.addChild(msk);
			cont.width = 1800;
			cont.height = 1012;
			cont.mask = msk;

			videoPlayer.play(SoccerUiConst.FAN_VIDEO_BG);
			this.addChild(indicator);
			indicator.x = indicator.y = 50;
			this.addChild(controlls);
			
			
			controlls.y = SoccerUiConst.WIN_HEIGHT - 80;
		}
		public function pause() {
			videoPlayer.pause();
		}
		public function resume() {
			videoPlayer.resume();
		}
		public function mute() {
			videoPlayer.setSound(0);
		}
		public function unmute() {
			videoPlayer.setSound(1);
		}
		public function setVideoData(data:Object) {
			//{"type":"video","videoitle":"בלה בלה","videolink":"http://54.225.188.163/soccrefans1.mp4"}
			var videoLink:String=data.videolink;
			//videoLink="http://54.225.188.163/video1.flv";
			if(videoLink && videoLink.length>5){
				videoPlayer.play(videoLink);
			}
		}
	}
}