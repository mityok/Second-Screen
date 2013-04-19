package com.cellcom.thevoice{
	import flash.net.NetConnection;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.media.SoundTransform;
	import flash.events.NetStatusEvent;
	public class LyricsVideoPlayer {
		private var vid:Video;
		private var ns:NetStream;
		private var nc:NetConnection = new NetConnection();
		public function LyricsVideoPlayer(wid:int=320,hgt:int=240) {
			nc.connect(null);
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			ns.client = {onMetaData:metaDataHandler};
			vid = new Video(wid,hgt);
			vid.attachNetStream(ns);
		}

		private function onStatus(item:Object):void {
			trace("vid: "+item.info.code);
			if (item.info.code == "NetStream.Play.Stop") {

			} else if (item.info.code =="NetStream.Play.Start") {

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
				trace("\n"+prop+" : "+infoObject[prop]);
			}

		}
		public function setVolume(volume:Number):void {
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
		public function stop() {
			if (ns) {
				ns.close();
			}
		}
	}

}