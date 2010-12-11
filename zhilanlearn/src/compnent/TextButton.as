package compnent
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class TextButton extends Sprite
	{
		
		private var textField:TextField;
		private var cover:Sprite;
		private var background:Sprite;
		
		public function TextButton(text:String)
		{
			super();
			
			textField = new TextField();
			textField.text = text;
			//textField.border = true;
			textField.mouseEnabled = false;
			
			background = new Sprite();
			background.graphics.beginFill(0xff0099, 1);
			background.graphics.lineStyle(1);
			background.graphics.drawRoundRect(0,0,textField.textWidth+2, textField.textHeight+2,5,5);
			background.graphics.endFill();
			
			cover = new Sprite();
			//cover.alpha = 0;
			cover.buttonMode = true;
//			cover.width = textField.width;
//			cover.height = textField.height;
			cover.graphics.beginFill(0xff0099, 0);
			cover.graphics.drawRect(0,0,textField.textWidth+2, textField.textHeight+2);
			cover.graphics.endFill();
			
			addChild(background);
			addChild(textField);
			addChild(cover);
		}
		
		public function set text(value:String):void{
			textField.text = value;
		}
		
		public function get text():String{
			return textField.text;
		}
	}
}