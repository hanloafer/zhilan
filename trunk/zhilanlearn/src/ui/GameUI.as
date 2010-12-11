package ui
{
	
	import compnent.ButtonConverter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.ui.Keyboard;
 
	public class GameUI extends Sprite
	{
		private var startItem:MCText;
		private var mainui:MainUI;
		private var restart:MCText;
		private var turnItem:MCText;
		private var input:Mytext;
		
		
		public function GameUI()
		{
			initStartItem();
			initMytext();
		}
			
		private function initStartItem():void{
			startItem = new MCText();
			startItem.tex2.text = "开始";
			startItem.tex2.mouseEnabled = false;
			new ButtonConverter(startItem.tex2);
			addChild(startItem);
			startItem.addEventListener(MouseEvent.CLICK,startNow);
		}
		
		public function initMainUI():void{
			mainui = new MainUI();
			mainui.y = 40;
			addChild(mainui);
		}
		
		private function initRestartItem():void{
			restart = new MCText();
			restart.tex2.text = "重新开始";
			new ButtonConverter(restart.tex2);
			restart.tex2.mouseEnabled = false;
			restart.x = 100;
			addChild(restart);
			restart.addEventListener(MouseEvent.CLICK,restartNow);
		}
		
		private function initTurnItem():void{
			turnItem = new MCText();
			turnItem.tex2.text = "跳关：";
			turnItem.x = 200;
			turnItem.tex2.mouseEnabled = false;
			new ButtonConverter(turnItem.tex2);
			addChild(turnItem);
			turnItem.addEventListener(MouseEvent.CLICK,turnTo);
		}
		
		public function initMytext():void{
			input = new Mytext();
			input.height = 21.9;
			input.leveltext.border = true;
			input.x = 300;
			addChild(input);
		}
		
		
		
		private function startNow(e:Event):void{
			initMainUI();
			initRestartItem();
			initTurnItem();
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,enterDown);
			startItem.removeEventListener(MouseEvent.CLICK,startNow);
	
		}
		
		private function restartNow(e:Event):void{
			removeChild(mainui);
			mainui = null;
			initMainUI();
		}
		
		private function turnTo(e:Event=null):void{
			var t:int = int(input.leveltext.text);
			mainui.tiaoguan(t);
		}
		
		private function enterDown(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.ENTER){
				turnTo();
			}
		}
	}
}