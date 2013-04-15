package com.cellcom.soccer{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	public class GalleryScreen extends ViewDisplayObject {
		private var loadedImagesCounter:int = 0;
		private var images:Vector.<GalleryImage>=new Vector.<GalleryImage>();
		private var imageContainer:Sprite=new Sprite();
		private var imageContainerMask:Shape=new Shape();
		private var initialPosition:Point=new Point();
		private var inMotion:Boolean;
		private var scroller:Shape=new Shape();

		public function GalleryScreen() {
			this.addChild(imageContainer);
			imageContainerMask.graphics.beginFill(0);
			imageContainerMask.graphics.drawRect(0,0,SoccerUiConst.WIN_WIDTH,SoccerUiConst.WIN_HEIGHT);
			imageContainerMask.graphics.endFill();
			this.addChild(imageContainerMask);
			imageContainer.mask = imageContainerMask;
			this.addChild(scroller);

			reset();
		}
		public function reset():void {
			loadedImagesCounter = 0;
			imageContainer.y = 0;
			scroller.x = SoccerUiConst.WIN_WIDTH;
			scroller.y =0;//UiConst.WIN_WIDTH;
			for (var i:int=0; i<images.length; i++) {
				//clear events
				images[i].removeEventListener(MouseEvent.CLICK,onClickImage);
				imageContainer.removeChild(images[i]);
			}
			images=new Vector.<GalleryImage>();
			initInitial();
		}
		private function initInitial():void {
			for (var i:int=0; i<SoccerUiConst.GALLERY_COLUMNS*SoccerUiConst.GALLERY_ROWS; i++) {
				addImage(i);
			}
			redrawScroller();
		}
		private function addImage(count:int):void {
			var image:GalleryImage=new GalleryImage();
			var yPos:int = count / SoccerUiConst.GALLERY_ROWS;
			var xPos:int = count % SoccerUiConst.GALLERY_COLUMNS;
			image.x=xPos*(GalleryImage.IMG_WIDTH+SoccerUiConst.GALLERY_SPACING);
			image.y=yPos*(GalleryImage.IMG_HEIGHT+SoccerUiConst.GALLERY_SPACING);
			images.push(image);
			image.mouseChildren = false;
			image.mouseEnabled = true;
			imageContainer.addChild(image);
			image.addEventListener(MouseEvent.CLICK,onClickImage);
		}
		private function onClickImage(e:MouseEvent):void {

			var clickedImage:GalleryImage = GalleryImage(e.target);
			var imageData:Object = clickedImage.getData();
			trace(imageData+":"+ mainView);
			if (imageData != null && mainView!=null) {
				mainView.launchFullScreen(imageData);
			}
		}
		//{"type":"image","image":"3eda42317f524bcf96875b0ca1db3488.jpg","title":"test3"};
		public function insertImage(data:Object):void {
			if (images.length <= loadedImagesCounter) {
				addImage(loadedImagesCounter);
				if (checkRowAddition()&& !inMotion) {
					TweenLite.to(imageContainer,1,{y:-imageContainer.height+SoccerUiConst.WIN_HEIGHT});
				}
			}
			redrawScroller();
			images[loadedImagesCounter].setData(data);
			loadedImagesCounter++;
		}
		private function redrawScroller():void {
			var imgHgt:Number = imageContainer.height;
			var perc:Number = 0;
			if (imgHgt!=0) {
				perc = SoccerUiConst.WIN_HEIGHT / imgHgt;
			}
			scroller.graphics.clear();
			if (perc<1) {
				var scrHgt:Number=SoccerUiConst.WIN_HEIGHT*perc;
				
				scroller.graphics.beginFill(SoccerUiConst.BG_ORANGE,0.5);
				scroller.graphics.drawRoundRect(2,0,8,scrHgt,4,4);
				scroller.graphics.endFill();
			}
		}
		private function checkRowAddition():Boolean {
			var oldPos:int = (loadedImagesCounter - 1) / SoccerUiConst.GALLERY_ROWS;
			var newPos:int = loadedImagesCounter / SoccerUiConst.GALLERY_ROWS;
			return newPos>oldPos;
		}

		public function setInitialPositionY() {
			initialPosition.y = this.imageContainer.y;
			TweenLite.to(scroller,0.3,{alpha:1});
		}
		public function motionStarted(){
			inMotion=true;
		}
		
		public function motionStoped(){
			inMotion=false;
			TweenLite.to(scroller,1,{delay:1,alpha:0});
			
		}
		public function moveY(deltaMotionY:Number) {
			TweenLite.killTweensOf(imageContainer);
			this.imageContainer.y = deltaMotionY + initialPosition.y;
			if (this.imageContainer.y > 0) {
				this.imageContainer.y = 0;
			} else if (this.imageContainer.y<-imageContainer.height+SoccerUiConst.WIN_HEIGHT) {
				this.imageContainer.y =  -  imageContainer.height + SoccerUiConst.WIN_HEIGHT;
			}
			var perc:Number=this.imageContainer.y/(-imageContainer.height+SoccerUiConst.WIN_HEIGHT);
			
			scroller.y=(-scroller.height+SoccerUiConst.WIN_HEIGHT)*perc;
			
			
		}
	}

}