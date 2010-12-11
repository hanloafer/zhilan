package compnent
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;

	public class SampleKeyInput extends Sprite
	{
		private var _input:TextField;
		
		public function SampleKeyInput()
		{
			_input = new TextField();
			_input.border = true;
			_input.type = "input";
			
			var container:Sprite = new Sprite();
			container.addChild(_input);
			addChild(container);
			
			container.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
		}
		
		public function keyHandler(e:KeyboardEvent):void{
			trace("按键"+String.fromCharCode(e.charCode)+"\t"+e.charCode+"\t"+e.keyCode);
		}
	}
}