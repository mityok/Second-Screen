package com.cellcom.fms{
	import flash.events.Event;

	public class FmsEvent extends Event {
		public static const DATA_RECEIVED:String ="DATA_RECEIVED";
		public static const DATA_FAIL:String ="DATA_FAIL";
		public static const CONNECTION_ESTABLISHED:String ="CONNECTION_ESTABLISHED";
		private var _data:Object;
		public function FmsEvent(type:String, data:Object,bubbles:Boolean=false, cancelable:Boolean=false):void {
			super(type, bubbles, cancelable);
			_data = data;
		}
		public function get data():Object{
			return _data;
		}

	}

}