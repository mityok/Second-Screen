package com.cellcom.advert{
	import flash.display.MovieClip;

	public class HotspotPointData {
		private var x:int;
		private var y:int;
		private var frontFacing:Boolean;
		private var hotspotClip:MovieClip;
		public function HotspotPointData(x:int,y:int,hotspotClip:MovieClip,frontFacing:Boolean=true) {
			this.x = x;
			this.y = y;
			this.frontFacing = frontFacing;
			this.hotspotClip = hotspotClip;
		}
		public function getX():int{
			return x;
		}
		public function getY():int{
			return y;
		}
		public function getFrontFacing():Boolean{
			return frontFacing;
		}
		public function getHotspotClip():MovieClip{
			return hotspotClip;
		}

	}

}