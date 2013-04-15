package com.cellcom.soccer {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Background extends Sprite {
		private var backScore:BackScore=new BackScore();
		private var scoreText:TextField;
		private var timerText:TextField;
		private var timer:Timer = new Timer(1000,0);
		private var initialCounter:Number = 0;
		public function Background() {
			
			this.addChild(backScore);
			scoreText = backScore.scoreText;
			timerText = backScore.timerText;
			scoreText.text = "0-0";
			timer.addEventListener(TimerEvent.TIMER,onTimerCount);
			timer.start();
		}
		private function onTimerCount(e:TimerEvent):void {
			initialCounter +=  1000;
			timerText.text = timerFormater(initialCounter);
		}
		public function resetTimer(newCounter:Number):void {
			initialCounter = newCounter;
		}
		private function timerFormater(num:Number):String {
			num = num / 1000;
			var min:int = num / 60;
			var sec:int = num % 60;
			return (min<10?("0"+min):min)+":"+(sec<10?("0"+sec):sec);
		}
		//{"type":"score","score":"2-3"}
		public function updateScore(data:Object){
			var score:String=data.score;
			if(score){
				scoreText.text=score;
			}
		}
	}

}