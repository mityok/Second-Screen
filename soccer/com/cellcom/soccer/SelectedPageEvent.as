package com.cellcom.soccer{
	import flash.events.Event;

	public class SelectedPageEvent extends Event {
		public static const SELECTED_PAGE_EVENT:String = "SELECTED_PAGE_EVENT";
		private var _selectedPage:int = 0;
		public function SelectedPageEvent(type:String,selectedPage:int,bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type,bubbles,cancelable);
			_selectedPage = selectedPage;
		}
		public function get selectedPage():int {
			return _selectedPage;
		}
	}

}