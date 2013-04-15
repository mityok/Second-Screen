package com.cellcom.soccer{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;

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
			//cont.width = 1800;
			//cont.height = 1012;
			cont.mask = msk;
			var txt:TextField=new TextField();
			txt.width=400;
			txt.height=400;
videoPlayer.setText(txt);
			videoPlayer.setLoop(true);
			videoPlayer.play("http://av.vimeo.com/03611/451/64340711.mp4?aktimeoffset=0&aksessionid=46fc6faa8a009134a0f582beacd12029&token=1365664249_d5f7e73a06c04412e9b835490009a6f8");//"64340711.mp4");//"http://54.225.188.163/soccrefans1.mp4");//"fans_old.flv");
			this.addChild(indicator);
			indicator.x = indicator.y = 50;
			this.addChild(controlls);
			
			txt.background=true;
			txt.border=true;
			this.addChild(txt);
			controlls.y = SoccerUiConst.WIN_HEIGHT - 80;
		}
		public function pause() {
			videoPlayer.pause();
		}
		public function resume() {
			videoPlayer.resume();
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