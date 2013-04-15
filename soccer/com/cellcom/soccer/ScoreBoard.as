package com.cellcom.soccer{
	import flash.display.Sprite;
	import fl.text.TLFTextField;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.elements.TextFlow;
	import flash.text.engine.FontLookup;
	import flash.text.Font;
	import flashx.textLayout.formats.Direction;

	public class ScoreBoard extends Sprite {

		public function ScoreBoard() {
			var applyFont:Font = new NachlieliLight();
			
			var myTLFTextField:TLFTextField = new TLFTextField();
			addChild(myTLFTextField);
			myTLFTextField.x = 10;
			myTLFTextField.y = 10;
			myTLFTextField.width = 400;
			myTLFTextField.height = 100;
			myTLFTextField.text = "כבש גול ראשון בדקה ה-26";

			var myFormat:TextLayoutFormat = new TextLayoutFormat();
			myFormat.direction=Direction.RTL;
			myFormat.textIndent = 8;
			myFormat.color = 0xff0000;
			myFormat.fontLookup = FontLookup.EMBEDDED_CFF;
			myFormat.fontFamily = applyFont.fontName;
			myFormat.fontSize = 72;

			var myTextFlow:TextFlow = myTLFTextField.textFlow;
			myTextFlow.hostFormat = myFormat;
			myTextFlow.flowComposer.updateAllControllers();
		}

	}

}