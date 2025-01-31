﻿package com.cellcom.soccer{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.greensock.TweenLite;
	import fl.text.TLFTextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	import flash.events.IOErrorEvent;
	import flash.display.LoaderInfo;
	import flash.text.engine.FontWeight;
	import com.cellcom.global.GlobalConst;

	public class StatsScreen extends ViewDisplayObject {
		public static const STATS_ONE_GOAL:String = "STATS_ONE_GOAL";
		public static const STATS_ONE_REG:String = "STATS_ONE_REG";
		public static const STATS_TWO:String = "STATS_TWO";
		private var statsViewPlayer:StatsViewPlayer=new StatsViewPlayer();
		private var statsViewTeam:StatsViewTeam=new StatsViewTeam();
		private var playerNumber:TextField;
		private var miniTitle:TLFTextField;
		private var playerName:TLFTextField;
		private var playerPos:TLFTextField;
		private var imageContainer:MovieClip;
		private var playerNameBg:MovieClip;
		private var playerPosBg:MovieClip;
		private var playerMiniBg:MovieClip;
		
		
			
		private var playerMiniNumber:TextField
		private var playerMiniName:TLFTextField;
		private var playerMiniNameBg:MovieClip;
		private var playerMiniPosBg:MovieClip;
		private var playerMiniPos:TLFTextField;
		
		private var birthField:TextField;
		private var dayField:TextField;
		private var monthField:TextField;
		private var yearField:TextField;
		private var ageField:TextField;
		private var countryField:TLFTextField;
		private var playerNameBgPosX:Number = 0;
		private var playerPosBgPosX:Number = 0;
		//
		private var playerMiniNameBgPosX:Number = 0;
		private var playerMiniPosBgPosX:Number = 0;
		private var playerMiniTitleBgPosX:Number = 0;
		//
		private var loader:Loader=new Loader();
		public static const IMG_WIDTH:Number = 240;
		public static const IMG_HEIGHT:Number = 320;
		private var statsMode:String;
		private var data:Object;
		private var flags:Vector.<MovieClip>=new Vector.<MovieClip>();
		private var goalDistance:MovieClip;
		private var goalChance:MovieClip;
		private var distField:TextField;
		private var chanceField:TextField;
		private var ballChance:MovieClip;
		private var seasonGoal:MovieClip;
		private var seasonField:TextField;
		private var gamesSeason:MovieClip;
		private var gamesField:TextField;
		private var frameKick:MovieClip;
		private var frameField:TextField;
		private var ballControllOne:Vector.<TextField>=new Vector.<TextField>();
		private var ballControllTwo:Vector.<TextField>=new Vector.<TextField>();
		private var hookFieldTwo:TextField;
		private var hookFieldOne:TextField;
		private var numFormat:TextFormat=new TextFormat();
		private var faulsCardHolderOne:Vector.<MovieClip>=new Vector.<MovieClip>();
		private var faulsCardHolderTwo:Vector.<MovieClip>=new Vector.<MovieClip>();
		private var faulsCardFieldOne:Vector.<TextField>=new Vector.<TextField>();
		private var faulsCardFieldTwo:Vector.<TextField>=new Vector.<TextField>();

		private var gateFieldOne:TextField;
		private var gateFieldTwo:TextField;

		private var offsideFieldTwo:TextField;
		private var offsideFieldOne:TextField;

		private var freeKicksFieldTwo:TextField;
		private var freeKicksFieldOne:TextField;
		//
		public function StatsScreen() {
			this.mouseChildren = false;
			this.mouseEnabled = false;
			numFormat.bold = FontWeight.BOLD;
			
			imageContainer = statsViewPlayer.imageContainer;
			//
			miniTitle = statsViewPlayer.playerNameMiniTitle.miniTitle;
			playerMiniBg = statsViewPlayer.playerNameMiniTitle.playerMiniBg;
			playerMiniNumber = statsViewPlayer.playerNameMiniTitle.playerNumber;
			playerMiniName = statsViewPlayer.playerNameMiniTitle.playerName;
			playerMiniNameBg = statsViewPlayer.playerNameMiniTitle.playerNameBg;
			playerMiniPosBg = statsViewPlayer.playerNameMiniTitle.playerPosBg;
			playerMiniPos = statsViewPlayer.playerNameMiniTitle.playerPos;
			//
			playerNumber = statsViewPlayer.playerNameNoTitle.playerNumber;
			playerName = statsViewPlayer.playerNameNoTitle.playerName;
			playerNameBg = statsViewPlayer.playerNameNoTitle.playerNameBg;
			playerPosBg = statsViewPlayer.playerNameNoTitle.playerPosBg;
			playerPos = statsViewPlayer.playerNameNoTitle.playerPos;
			//
			goalDistance = statsViewPlayer.goalDistance;
			distField = goalDistance.distField;
			//
			goalChance = statsViewPlayer.goalChance;
			ballChance = goalChance.ballChance;
			chanceField = goalChance.chanceField;
			seasonGoal = statsViewPlayer.seasonGoal;
			seasonField = seasonGoal.seasonField;
			//
			gamesSeason = statsViewPlayer.gamesSeason;
			gamesField = gamesSeason.gamesField;
			frameKick = statsViewPlayer.frameKick;
			frameField = frameKick.frameField;
			//team
			var i:int = 0;
			for (i=0; i<4; i++) {
				ballControllOne.push(TextField(statsViewTeam.ballControl.controlTeamOne["controlField"+i]));
				ballControllTwo.push(TextField(statsViewTeam.ballControl.controlTeamTwo["controlField"+i]));
				ballControllOne[i].defaultTextFormat = ballControllTwo[i].defaultTextFormat = numFormat;
			}
			hookFieldTwo = statsViewTeam.hookKick.hookFieldTwo;
			hookFieldOne = statsViewTeam.hookKick.hookFieldOne;


			//FaulCard
			for (i=0; i<3; i++) {
				faulsCardHolderOne.push(statsViewTeam.fauls.faulsOne["cardHolder"+i]);
				faulsCardHolderTwo.push(statsViewTeam.fauls.faulsTwo["cardHolder"+i]);

				faulsCardFieldOne.push(statsViewTeam.fauls.faulsOne["faulsField"+i]);
				faulsCardFieldTwo.push(statsViewTeam.fauls.faulsTwo["faulsField"+i]);
				faulsCardFieldOne[i].defaultTextFormat = faulsCardFieldTwo[i].defaultTextFormat = numFormat;
			}
			//

			gateFieldOne = statsViewTeam.gateKicks.gateFieldOne;
			gateFieldTwo = statsViewTeam.gateKicks.gateFieldTwo;

			offsideFieldTwo = statsViewTeam.offside.offsideFieldTwo;
			offsideFieldOne = statsViewTeam.offside.offsideFieldOne;

			freeKicksFieldTwo = statsViewTeam.freeKicks.freeKicksFieldTwo;
			freeKicksFieldOne = statsViewTeam.freeKicks.freeKicksFieldOne;
			//

			birthField = statsViewPlayer.birthField;
			dayField = statsViewPlayer.dateAnim.dayField;
			monthField = statsViewPlayer.dateAnim.monthField;
			yearField = statsViewPlayer.dateAnim.yearField;
			ageField = statsViewPlayer.ageField;

			ageField.defaultTextFormat = numFormat;
			birthField.defaultTextFormat = numFormat;
			distField.defaultTextFormat = numFormat;
			chanceField.defaultTextFormat = numFormat;
			seasonField.defaultTextFormat = numFormat;
			frameField.defaultTextFormat = numFormat;
			gamesField.defaultTextFormat = numFormat;
			hookFieldTwo.defaultTextFormat = numFormat;
			hookFieldOne.defaultTextFormat = numFormat;
			gateFieldOne.defaultTextFormat = numFormat;
			gateFieldTwo.defaultTextFormat = numFormat;
			offsideFieldTwo.defaultTextFormat = numFormat;
			offsideFieldOne.defaultTextFormat = numFormat;

			freeKicksFieldTwo.defaultTextFormat = numFormat;
			freeKicksFieldOne.defaultTextFormat = numFormat;
			countryField = statsViewPlayer.countryField;
			flags.push(statsViewPlayer.flagAnim.flagContSmall);
			flags.push(statsViewPlayer.flagAnim.flagContMiddle);
			flags.push(statsViewPlayer.flagAnim.flagContBig);
			//
			playerNameBgPosX = playerNameBg.x;
			playerPosBgPosX = playerPosBg.x;
			//
			playerMiniNameBgPosX = playerMiniNameBg.x;
			playerMiniPosBgPosX = playerMiniPosBg.x;
			playerMiniTitleBgPosX = playerMiniBg.x;
			//
			imageContainer.addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadDone);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			drawBackground();
			this.addChild(statsViewPlayer);
			this.addChild(statsViewTeam);
			var format:TextFormat=new TextFormat();
			format.letterSpacing = -9;
			playerMiniNumber.defaultTextFormat =playerNumber.defaultTextFormat = format;
			playerMiniNumber.text =playerNumber.text= "";

			miniTitle.autoSize = TextFieldAutoSize.RIGHT;
			playerName.autoSize = TextFieldAutoSize.RIGHT;
			playerPos.autoSize = TextFieldAutoSize.RIGHT;
			playerMiniName.autoSize = TextFieldAutoSize.RIGHT;
			playerMiniPos.autoSize = TextFieldAutoSize.RIGHT;
			resetInfo();
		}
		private function resetInfo() {
			statsViewPlayer.visible = false;
			statsViewTeam.visible = false;
			trace("reset");
			birthField.text = "";
			dayField.text = "";
			monthField.text = "";
			yearField.text = "";
			playerPos.text = "";
			playerMiniPos.text = "";
			miniTitle.text = "";
			playerName.text = "";
			playerMiniName.text = "";
			ageField.text = "";
			countryField.text = "";
			loader.unloadAndStop(true);
			miniTitle.alpha = playerName.alpha = playerPos.alpha =playerMiniName.alpha = playerMiniPos.alpha = 0;
			playerNameBg.x = playerNameBgPosX;
			playerPosBg.x = playerPosBgPosX;
			//
			playerMiniBg.x=playerMiniTitleBgPosX;
			playerMiniNameBg.x = playerMiniNameBgPosX;
			playerMiniPosBg.x = playerMiniPosBgPosX;
			//
			distField.text = "";
			goalDistance.visible = false;
			goalChance.visible = false;
			chanceField.text = "";
			seasonField.text = "";
			gamesSeason.visible = false;
			gamesField.text = "";
			frameKick.visible = false;
			frameField.text = "";
			var len:int = ballControllOne.length;
			var i:int = 0;
			for (i=0; i<len; i++) {
				ballControllOne[i].text = "";
				ballControllTwo[i].text = "";
			}
			hookFieldTwo.text = "";
			hookFieldOne.text = "";
			for (i=0; i<3; i++) {
				faulsCardHolderOne[i].removeChildren();
				faulsCardHolderTwo[i].removeChildren();


				faulsCardFieldOne[i].text = "";
				faulsCardFieldTwo[i].text = "";
			}
			gateFieldOne.text = "";
			gateFieldTwo.text = "";
			offsideFieldTwo.text = "";
			offsideFieldOne.text = "";

			freeKicksFieldTwo.text = "";
			freeKicksFieldOne.text = "";
		}
		/*
		{"type":"stats2","kicks":"5,6","funds":"9,8","freekicks":"4,7","fouls":"4,8,6","differ":"9,7","percentcontrol":"55,45"}
		*/
		public function updateStageTwo(data:Object):void {
			clearPreviousStage();
			this.data = data;
			statsMode = STATS_TWO;
			initiateStateTwo();
		}
		/*{"type":"stats","playername":"אלי אוחנה","playerimg":"c2cb6bf13e79419cbf3bdbd9f7985234.gif","playernumber":"22","playerbirthdate":"18/07/1984","statsplayerage":"28","statsdistance":"10","chancegoal":"15","playerposition":"התקפה","playertotalgoals":"5","playercountry":"ישראל","countryflag":"12143367ed5b4d09aacd2bc7fc70d44e.png"}
		*/

		/*
		{"type":"stats","playername":"ליאונל מסי","playerimg":"5f76f30c391f4e3683311b7062523aa8.jpg","playernumber":"11","playerbirthdate":"20/05/1980","statsplayerage":"30","statsdistance":"","chancegoal":"","playerposition":"מגן","playertotalgoals":"5","playercountry":"ספרד","countryflag":"60bae410846e4844b8ff195a796031bf.jpg","statsgamescount":"22","statskicksframework":"11"}
		*/

		public function updateStageOne(_data:Object):void {
			clearPreviousStage();
			data = _data;
			var statsdistance:String = data.statsdistance;
			var chancegoal:String = data.chancegoal;
			if (statsdistance.length > 0 && chancegoal.length > 0) {
				statsMode = STATS_ONE_GOAL;
				initiateStateOneGoal();
			} else {
				statsMode = STATS_ONE_REG;
				initiateStateOneReg();
			}
		}
		private function clearPreviousStage() {
			resetInfo();
		}
		private function initiateStateTwo() {
			statsViewTeam.visible = true;
			statsViewTeam.ballControl.gotoAndPlay(1);
			statsViewTeam.hookKick.gotoAndPlay(1);
			statsViewTeam.offside.gotoAndPlay(1);
			statsViewTeam.gateKicks.gotoAndPlay(1);
			var percentcontrol:Array = data.percentcontrol.toString().split(",");
			var percentcontrolOne:int = int(percentcontrol[0]);
			var percentcontrolTwo:int = int(percentcontrol[1]);
			var len:int = ballControllOne.length;
			var i:int=0;
			for (i=0; i<len; i++) {
				ballControllOne[i].text=""+Math.round(percentcontrolOne/(i+1));
				ballControllTwo[i].text=""+Math.round(percentcontrolTwo/(i+1));
			}
			//
			var funds:Array = data.funds.split(",");
			hookFieldTwo.text = funds[1];
			hookFieldOne.text = funds[0];
			//
			var fouls:Array = data.fouls.split(",");
			for (i=0; i<3; i++) {
				var foulsOne:int = int(fouls[i]);
				var foulsTwo:int=int(((3+i)>=fouls.length?"10":fouls[3+i]));
				var card:MovieClip;
				var j:int = 0;
				for (j=0; j<foulsOne; j++) {
					card=new FaulCard();
					card.x =  -  j * 10;
					card.alpha=0;
					card.scaleX=card.scaleY=1.5;
					TweenLite.to(card,0.1,{delay:j*0.1,alpha:1,scaleX:1,scaleY:1});
					card.gotoAndStop(i+1);
					faulsCardHolderOne[i].addChild(card);
				}
				for (j=0; j<foulsTwo; j++) {
					card=new FaulCard();
					card.alpha=0;
					card.scaleX=card.scaleY=1.5;
					TweenLite.to(card,0.1,{delay:j*0.1,alpha:1,scaleX:1,scaleY:1});
					card.x = j * 10;
					card.gotoAndStop(i+1);
					faulsCardHolderTwo[i].addChild(card);
				}


				faulsCardFieldOne[i].text = "" + foulsOne;
				faulsCardFieldTwo[i].text = "" + foulsTwo;
			}
			var kicks:Array = data.kicks.split(",");
			gateFieldOne.text = kicks[0];
			gateFieldTwo.text = kicks[1];

			//
			var differ:Array = data.differ.split(",");
			offsideFieldTwo.text = differ[1];
			offsideFieldOne.text = differ[0];
			var freekicks:Array = data.freekicks.split(",");
			freeKicksFieldTwo.text = freekicks[1];
			freeKicksFieldOne.text = freekicks[0];
		}
		private function initiateStateOneReg() {
			gamesSeason.visible = true;
			gamesField.text = data.statsgamescount;
			frameKick.visible = true;
			frameField.text = data.statskicksframework;
			initiatePlayer();
		}
		private function initiateStateOneGoal() {
			goalDistance.visible = true;
			distField.text = data.statsdistance;
			//
			goalChance.visible = true;
			chanceField.text = data.chancegoal + "%";
			initiatePlayer();
		}
		private function initiatePlayer() {
			statsViewPlayer.visible = true;
			gamesSeason.gotoAndPlay(1);
			frameKick.gotoAndPlay(1);
			statsViewPlayer.dateAnim.gotoAndPlay(1);
			statsViewPlayer.ageAnim.gotoAndPlay(1);
			statsViewPlayer.seasonGoal.gotoAndPlay(1);
			//
			var hasMiniTile:Boolean=false;
			if(data.minititle && data.minititle.length>0){
				hasMiniTile=true;
				miniTitle.text = data.minititle;
				playerMiniName.text = data.playername;
				playerMiniNumber.text = data.playernumber;
				playerMiniPos.text = data.playerposition;
				TweenLite.to(playerMiniPos,0.2,{alpha:1,delay:0.2});
				TweenLite.to(playerMiniPosBg,0.2,{x:playerMiniPosBgPosX - playerMiniPos.width});
				TweenLite.to(miniTitle,0.2,{alpha:1,delay:0.2});
				TweenLite.to(playerMiniName,0.2,{alpha:1,delay:0.2});
				TweenLite.to(playerMiniNameBg,0.2,{x:playerMiniNameBgPosX - playerMiniName.width});
				TweenLite.to(playerMiniBg,0.2,{x:playerMiniTitleBgPosX - miniTitle.width});
			}else{
				playerName.text = data.playername;
				playerNumber.text = data.playernumber;
				playerPos.text = data.playerposition;
				TweenLite.to(playerPos,0.2,{alpha:1,delay:0.2});
				TweenLite.to(playerPosBg,0.2,{x:playerPosBgPosX - playerPos.width});
				TweenLite.to(playerName,0.2,{alpha:1,delay:0.2});
				TweenLite.to(playerNameBg,0.2,{x:playerNameBgPosX - playerName.width});
			}
			statsViewPlayer.playerNameMiniTitle.visible = hasMiniTile;
			statsViewPlayer.playerNameNoTitle.visible = !hasMiniTile;
			//
			
			//
			seasonField.text = data.playertotalgoals;
			//
			
			//;
			loader.unloadAndStop(true);
			loader.alpha = 0;
			loader.load(new URLRequest(GlobalConst.IMAGES_LINK+data.playerimg));
			//;
			birthField.text = data.playerbirthdate;
			var dates:Array=[0,0,0];
			if( birthField.text.indexOf("/")>=0){
				dates = birthField.text.split("/");
			}else if( birthField.text.indexOf(".")>=0){
				dates = birthField.text.split(".");
			}
			
			dayField.text = dates[0];
			monthField.text = dates[1];
			yearField.text = dates[2].toString().substr(dates[2].length - 2,2);
			ageField.text = data.statsplayerage;
			countryField.text = data.playercountry;
			//
			for (var i:int=0; i<flags.length; i++) {
				flags[i].flagCont.removeChildren();
				var flagLoader:Loader = new Loader();
				flags[i].flagCont.addChild(flagLoader);
				flagLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadFlagDone);
				flagLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadFlagError);
				flagLoader.load(new URLRequest(GlobalConst.IMAGES_LINK + data.countryflag));
			}
		}
		private function onLoadFlagError(e:Event):void {
			trace("error flag: "+e);
		}
		private function onLoadFlagDone(e:Event):void {
			LoaderInfo(e.target).loader.width=110;
			LoaderInfo(e.target).loader.height=110;
		}
		private function onLoadError(e:IOErrorEvent):void {

		}
		private function onLoadDone(e:Event):void {
			loader.width = IMG_WIDTH;
			loader.height = IMG_HEIGHT;
			TweenLite.to(loader,1,{alpha:1});
		}
		private function drawBackground() {
			this.graphics.lineStyle(1,0xffffff);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(SoccerUiConst.WIN_WIDTH,0);

			this.graphics.moveTo(0,SoccerUiConst.WIN_HEIGHT);
			this.graphics.lineTo(SoccerUiConst.WIN_WIDTH,SoccerUiConst.WIN_HEIGHT);

			this.graphics.moveTo(0,SoccerUiConst.WIN_HEIGHT);
			this.graphics.lineTo(SoccerUiConst.WIN_WIDTH,SoccerUiConst.WIN_HEIGHT);

			this.graphics.moveTo(0,SoccerUiConst.WIN_FRAME);
			this.graphics.lineTo(0,SoccerUiConst.WIN_HEIGHT-SoccerUiConst.WIN_FRAME);

			this.graphics.moveTo(SoccerUiConst.WIN_WIDTH,SoccerUiConst.WIN_FRAME);
			this.graphics.lineTo(SoccerUiConst.WIN_WIDTH,SoccerUiConst.WIN_HEIGHT-SoccerUiConst.WIN_FRAME);
		}

	}
}