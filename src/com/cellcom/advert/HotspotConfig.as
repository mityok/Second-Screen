package com.cellcom.advert{

	public class HotspotConfig {
		public var horizon:Number;
		public var deviceWidth:Number;
		public var deviceHeight:Number;
		public var offsetX:Number;
		public var deviceRadiusX:Number;
		public var deviceRadiusY:Number;
		public var topLimit:Number;

		public function HotspotConfig(horizon:Number,deviceWidth:Number,deviceHeight:Number,offsetX:Number,deviceRadiusX:Number,deviceRadiusY:Number,topLimit:Number) {
			this.deviceRadiusX = deviceRadiusX;
			this.deviceRadiusY = deviceRadiusY;
			this.horizon = horizon;
			this.deviceWidth = deviceWidth;
			this.deviceHeight = deviceHeight;
			this.offsetX = offsetX;
			this.topLimit = topLimit;
		}

	}

}