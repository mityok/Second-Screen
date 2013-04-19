package com.cellcom.fms{
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.system.Security;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;

	public class FmsConnection extends EventDispatcher {
		private var nc:NetConnection;
		private var so_Content:SharedObject;
		private var rtmplink:String;


		public function FmsConnection(paramObj:Object,defaultString:String) {
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			rtmplink = paramObj["rtmplink"] || defaultString;
			nc.connect(rtmplink);
		}
		private function netStatusHandler(event:NetStatusEvent):void {
			trace(event.info.code);
			switch (event.info.code) {
				case "NetConnection.Connect.Success" :
					so_Content = SharedObject.getRemote("ContentSO",nc.uri,false);
					so_Content.connect(nc);
					so_Content.addEventListener(SyncEvent.SYNC, so_Content_syncHandler);
					this.dispatchEvent(new FmsEvent(FmsEvent.CONNECTION_ESTABLISHED,null));
					break;
			}
		}

		private function so_Content_syncHandler(event:SyncEvent):void {
			trace("so_Content_syncHandler " + so_Content.data.content);
			try {
				var item:Object = JSON.parse(so_Content.data.content);
				//types: image, stats, video, startgame, score
				this.dispatchEvent(new FmsEvent(FmsEvent.DATA_RECEIVED,item));
			} catch (error:Error) {
				this.dispatchEvent(new FmsEvent(FmsEvent.DATA_FAIL,null));
			}
		}
	}
}