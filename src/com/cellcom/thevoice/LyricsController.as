package com.cellcom.thevoice{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import fl.text.TLFTextField;
	import com.greensock.TweenLite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextFormatAlign;

	public class LyricsController {
		private var container:MovieClip;
		private var lyrics:LyricsVideoPlayer;
		private var video:DisplayObject;
		private var didYouKnowTextTlf:TLFTextField;
		
		private var didyouknowtext:String;
		private var counter:int = 0;
		public function LyricsController(container:MovieClip) {
			this.container = container;
			lyrics = new LyricsVideoPlayer(TheVoiceUiConst.LYRICS_WIDTH,TheVoiceUiConst.LYRICS_HEIGHT);
			video = lyrics.getVideo();
			container.addChild(video);
			didYouKnowTextTlf = container.didYouKnowText;
			
		}
		public function setData(data:Object):void {
			if (data.type == "lyrics") {
				lyrics.play(data.lyricsvideolink);
				didYouKnowTextTlf.text = "";
				video.visible = true;
			} else if ("didyouknow") {
				video.visible = false;
				
				didYouKnowTextTlf.text= data.didyouknowtext;
				
			}
		}
		
		public function reset() {
			
			lyrics.stop();
			video.visible = false;
			
		}
	}
}