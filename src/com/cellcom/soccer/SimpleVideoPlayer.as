package com.cellcom.soccer{
	import flash.net.NetConnection;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.media.SoundTransform;
	import flash.events.NetStatusEvent;
	import flash.text.TextField;

	public class SimpleVideoPlayer {
		private var vid:Video;
		private var ns:NetStream;
		private var nc:NetConnection = new NetConnection();
		private var loop:Boolean;
		private var initialPlay:Boolean;
		private var txt:TextField;
		public function SimpleVideoPlayer(wid:int=320,hgt:int=240) {
			var customClient = new Object();
			customClient.onMetaData = metaDataHandler;


			nc.connect(null);

			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			ns.client = customClient;
			vid = new Video(wid,hgt);
			vid.attachNetStream(ns);

		}
		public function setLoop(value:Boolean):void{
			loop=value;
		}
		public function setText(txt:TextField):void{
			this.txt=txt;
		}
		
		private function onStatus(item:Object):void {
			txt.appendText("\n"+"info: "+item.info.code);
			trace("vid: "+item.info.code);
			if (item.info.code == "NetStream.Play.Stop") {
				/*if (loop) {
					ns.seek(0);
				}*/
			}else if(item.info.code =="NetStream.Play.Start"){
				/*if(!initialPlay){
					initialPlay=true;
					pause();
				}*/
			}
		}
		public function play(url:String):void {
			ns.play(url);

		}
		public function getVideo():Video {
			return vid;
		}
		public function metaDataHandler(infoObject:Object):void {
			for (var prop in infoObject) {
				txt.appendText("\n"+prop+" : "+infoObject[prop]);
			}
		}
		public function setSound(volume:Number):void {
			var transform:SoundTransform = new SoundTransform();
			transform.volume = volume;
			ns.soundTransform = transform;
		}
		public function pause() {
			ns.pause();
		}
		public function resume() {
			ns.resume();
		}
	}

}