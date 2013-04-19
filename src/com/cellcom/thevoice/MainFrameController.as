package com.cellcom.thevoice{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.cellcom.global.GlobalConst;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;

	public class MainFrameController {
		private var container:MovieClip;
		private var mainLoader:Loader;
		private var albumLoader:Loader;
		private var albumContainerMc:MovieClip;
		private var stars:Vector.<MovieClip > ;
		private var albumInitialPos:Number;
		private var judgesInitialPos:Number;
		
		private var titleContainerMc:MovieClip;
		private var judgesContainerMc:MovieClip;
		
		public function MainFrameController(container:MovieClip,notification:Function) {
			this.container = container;
			albumContainerMc = container.albumContainer;
			//
			judgesContainerMc=container.judgesContainer;
			judgesContainerMc.textFieldOne.text=TheVoiceUiConst.JUDGE_ONE;
			judgesContainerMc.textFieldTwo.text=TheVoiceUiConst.JUDGE_TWO;
			judgesContainerMc.textFieldThree.text=TheVoiceUiConst.JUDGE_THREE;
			judgesContainerMc.textFieldFour.text=TheVoiceUiConst.JUDGE_FOUR;
			judgesInitialPos=judgesContainerMc.y;
			titleContainerMc = container.titleContainer;
			
			//
			mainLoader=new Loader();
			mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadDone);
			container.artistImageContainer.addChild(mainLoader);
			//;
			albumLoader=new Loader();
			albumLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadAlbumDone);
			albumContainerMc.albumFrame.addChild(albumLoader);
			albumInitialPos = albumContainerMc.y;
			stars = Vector.<MovieClip > ([albumContainerMc.star1,albumContainerMc.star2,albumContainerMc.star3,albumContainerMc.star4,albumContainerMc.star5]);
			titleContainerMc.alpha = 0;
			albumContainerMc.alpha=0;
			judgesContainerMc.alpha=0;
			for (var i:int=0; i<stars.length; i++) {
				stars[i].addEventListener(MouseEvent.CLICK,function(e:MouseEvent){
										setDefaultRank(stars.indexOf(e.target));
										TweenLite.to(e.target,0.2,{scaleX:1.5,scaleY:1.5,onComplete:function(){
													 TweenLite.to(e.target,0.2,{scaleX:1,scaleY:1});
													 }});
										notification();
										  });
			}
		}
		public function reset() {
			mainLoader.unloadAndStop();
			albumLoader.unloadAndStop();
			resetAlbum();
			resetTitle();
			resetJudges();
		}
		private function resetJudges(){
			TweenLite.to(judgesContainerMc,0.1,{y:judgesInitialPos,alpha:0});
		}
		private function resetTitle() {
			TweenLite.to(titleContainerMc,0.1,{alpha:0,y:0});
		}
		private function resetAlbum() {
			TweenLite.to(albumContainerMc,0.1,{y:albumInitialPos,alpha:0});
		}
		public function setData(data:Object) {
			var title:String = "";
			if (data.infosongname == "turned") {
				title = TheVoiceUiConst.TITLE_JUDGES;
				resetAlbum();
				judgesContainerMc.alpha=0;
				TweenLite.to(judgesContainerMc,0.3,{y:judgesInitialPos-80,alpha:1});
			}else{
				if (data.infosongalbumimg && data.infosongalbumimg.length > 4) {
					albumLoader.load(new URLRequest(GlobalConst.IMAGES_LINK + data.infosongalbumimg));
				}
				title = TheVoiceUiConst.TITLE_ARTIST;
				albumContainerMc.textFieldOne.text = data.infosongsource;
				albumContainerMc.textFieldTwo.text = data.infosongmelody;
				albumContainerMc.textFieldThree.text = data.infosongproduction;
				//"infosongyear":"1984"
				setDefaultRank(2);
				resetJudges();
				albumContainerMc.alpha = 0;
				TweenLite.to(albumContainerMc,0.3,{y:albumInitialPos-40,alpha:1});
			}
			TweenLite.to(titleContainerMc,0.1,{alpha:0,y:0,onComplete:function(){
			titleContainerMc.textFieldTitle.text=title;
			TweenLite.to(titleContainerMc,0.1,{alpha:1,y:40});
			}});
			if (data.infosongimg.length > 4) {
				mainLoader.load(new URLRequest(GlobalConst.IMAGES_LINK + data.infosongimg));
			}
		}
		private function setDefaultRank(pos:int):void {
			for (var i:int=0; i<stars.length; i++) {
				if (i<=pos) {
					stars[i].gotoAndStop(2);
				} else {
					stars[i].gotoAndStop(1);
				}
			}
		}
		private function onLoadDone(e:Event) {
			mainLoader.width = TheVoiceUiConst.ARTIST_WIDTH;
			mainLoader.height = TheVoiceUiConst.ARTIST_HEIGHT;
		}
		private function onLoadAlbumDone(e:Event) {
			albumLoader.width = albumLoader.height = TheVoiceUiConst.ALBUM_SIZE;
		}
	}
}