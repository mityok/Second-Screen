package com.cellcom.advert{
	import flash.geom.Point;
	import flash.display.Sprite;

	public class HotspotIndicator extends Sprite {
		var config:HotspotConfig;
		var position:Point;
		var frontFacing:Boolean;
		public function HotspotIndicator(position:Point,config:HotspotConfig) {
			this.graphics.lineStyle(3,0);
			this.graphics.beginFill(0xff0000,0.5);
			this.graphics.drawCircle(0,0,50);
			this.graphics.endFill();
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
		public function isFrontFacing():Boolean{
			return frontFacing;
		}

	}

}