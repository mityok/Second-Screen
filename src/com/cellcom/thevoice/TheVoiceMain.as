package com.cellcom.thevoice{

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.desktop.*;
	import com.cellcom.global.GlobalConst;
	import com.cellcom.fms.FmsEvent;
	import com.cellcom.fms.FmsConnection;
	import flash.display.LoaderInfo;
	import com.greensock.TweenLite;
	import fl.text.TLFTextField;
	import flash.display.StageQuality;

	public class TheVoiceMain extends MovieClip {

		private var tweetController:TweetController;
		private var fms:FmsConnection;
		private var notificationClipMc:MovieClip;
		private var lyricsController:LyricsController;
		private var bottomTitleTlf:TLFTextField;
		private var mainFrame:MainFrameController;
		public function TheVoiceMain() {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality=StageQuality.HIGH;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			notificationClipMc = notificationClip;
			notificationClipMc.mouseChildren = false;
			notificationClipMc.mouseEnabled = false;
			notificationClipMc.visible = false;
			lyricsController = new LyricsController(lyricsCont);
			tweetController = new TweetController(tweetCont);
			bottomTitleTlf = bottomTitle;
			mainFrame=new MainFrameController(artistMainFrame,showNotification);
			fms = new FmsConnection(LoaderInfo(root.loaderInfo).parameters,GlobalConst.FMS_CONNECTION_VOD);
			fms.addEventListener(FmsEvent.DATA_RECEIVED,onFmsDataReceived);
			fms.addEventListener(FmsEvent.DATA_FAIL,onFmsDataFail);
			fms.addEventListener(FmsEvent.CONNECTION_ESTABLISHED,onFmsConnectionEstablished);

		}
		private function showNotification() {
			notificationClipMc.visible = true;
			notificationClipMc.alpha = 0;
			TweenLite.to(notificationClipMc,0.3,{alpha:1,overwrite :false});
			TweenLite.to(notificationClipMc,0.3,{alpha:0,delay:3,overwrite :false,onComplete:hideNotification});
		}
		private function hideNotification() {
			TweenLite.killTweensOf(notificationClipMc);
			notificationClipMc.visible = false;
		}
		private function onFmsDataReceived(e:FmsEvent):void {
			if (e.data) {
				switch (e.data.type) {
					case "feed" :
						tweetController.addNewFeed(e.data);
						break;
					case "startover" :
						resetAll(e.data);
						break;
					case "lyrics" :
						playVideo(e.data);
						break;
					case "infosong" :
						displayInfoSong(e.data);
						break;
					case "didyouknow" :
						displayDidYouKnowInfo(e.data);
						break;
				}
				//types: startover,feed,lyrics,infosong,didyouknow
			}
		}
		
		private function playVideo(data:Object) {
			bottomTitleTlf.text = TheVoiceUiConst.TITLE_LYRICS;
			lyricsController.setData(data);
		}
		private function resetAll(data:Object):void {
			tweetController.reset();
			mainFrame.reset();
			lyricsController.reset();
		}

		private function displayDidYouKnowInfo(data:Object) {
			bottomTitleTlf.text = TheVoiceUiConst.TITLE_DIDYOUKNOW;
			lyricsController.setData(data);
		}
		private function displayInfoSong(data:Object) {
			mainFrame.setData(data);
			
		}
		private function onFmsDataFail(e:FmsEvent):void {
			trace("fail");
		}
		private function onFmsConnectionEstablished(e:FmsEvent):void {

		}
	}
}
/*
{"type":"lyrics","lyricsvideolink":"http://54.225.188.163/karyoki/balada.flv"}
{"type":"feed","feedtext1":"asdasd","feedtext2":"dffdfdfdf","feed":"df225b78089c43ff976e52f2c08939bb.jpg"}
{"type":"feed","feedtext1":"","feedtext2":"","feed":"d8abb201cd024f78b8ccfc2d57f11163.jpg"}
{"type":"infosong","infosongname":"  ","infosongimg":"e6dca47a5517414bade58ab5af23282e.png","infosongsource":"","infosongmelody":" ","infosongproduction":" ","infosongyear":"1984"}
{"type":"feed","feedtext1":"","feedtext2":"34324","feed":"95165195d6d64d3a9550913c978bb5af.jpg"}
{"type":"infosong","infosongname":"nocontent","infosongimg":"","infosongsource":"","infosongmelody":"","infosongproduction":"","infosongyear":""}
{"type":"infosong","infosongname":"turned","infosongimg":"57a0260caa7c481985107b9679b29c02.jpg","infosongsource":"","infosongmelody":"","infosongproduction":"","infosongyear":""}
{"type":"didyouknow","didyouknowtext":""}
*/