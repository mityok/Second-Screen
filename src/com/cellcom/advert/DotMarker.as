package com.cellcom.advert {
	import flash.display.Shape;
	import com.cellcom.global.GlobalConst;
	
	public class DotMarker extends Shape {

		public function DotMarker(color:uint=0x7e7e7e) {
			draw(color);
		}
		public function draw(color:uint){
			this.graphics.clear();
			this.graphics.lineStyle(5,color);
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawCircle(0,0,AdvertConst.DOT_SIZE/2);
			this.graphics.endFill();
			this.graphics.lineStyle(0,0,0);
			this.graphics.beginFill(color,1);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();
		}

	}
	
}
