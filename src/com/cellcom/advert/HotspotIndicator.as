package com.cellcom.advert{
	import flash.geom.Point;
	import flash.display.Sprite;
	import com.cellcom.global.GlobalConst;

	public class HotspotIndicator extends Sprite {
		var config:HotspotConfig;
		var position:Point;
		var frontFacing:Boolean;
		var dot:DotMarker;
		public function HotspotIndicator(position:Point,config:HotspotConfig) {
			dot=new DotMarker();
			this.addChild(dot);
			this.config = config;
			frontFacing = true;
			if (position.x < 0 || position.y < 0) {
				position.x = Math.abs(position.x);
				position.y = Math.abs(position.y);
				frontFacing = false;
			}
			this.position = position;
		}
		public function turn(angle:Number):void {
			//config.deviceHeight;
			var yCenter:int=(config.deviceHeight/2)-config.horizon;
			var distFromCenterX:Number=position.x-(config.deviceWidth/2+config.offsetX);
			var distFromCenterY:Number = position.y - config.horizon;
			var extra:Number = distFromCenterX < 0 ? Math.PI:0;
			var calcRadiusY:Number = (distFromCenterY / config.topLimit) * config.deviceRadiusY*(Math.abs(distFromCenterX)/config.deviceRadiusX);
			//trace("resp:" +calcRadiusY+":"+calcRadiusY*(distFromCenterX/config.deviceRadiusX));
			this.x = Math.abs(distFromCenterX) * Math.cos( -  angle + extra) + config.offsetX;
			this.y = calcRadiusY * Math.sin( -  angle + extra) - yCenter + distFromCenterY;


		}
		public function isFrontFacing():Boolean {
			return frontFacing;
		}
		public function mark(value:Boolean):void {
			dot.draw(value?GlobalConst.CELLCOM_DARK_PURPLE:0x7e7e7e);
		}
	}

}