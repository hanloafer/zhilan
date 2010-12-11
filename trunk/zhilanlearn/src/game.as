package
{
	import Container.Poker;
	import Container.PuKe;
	
	import compnent.SampleClickAndDoubleClick;
	import compnent.SampleKeyInput;
	import compnent.SampleMouseAndKey;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class game extends Sprite
	{
		private var pokerAry:Array = [];
		
		/**
		 * i love you lanlan
		 * 
		 * this is my wife's run class 
		 * 
		 */		
		public function game()
		{
			var signAry:Array = ["A","B","C","D"];
			for(var j=0;j<signAry.length;j++){
				var valueAry:Array = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"];
				for(var i:int=0;i<valueAry.length;i++){
					var _poker:Poker = new Poker(signAry[j], valueAry[i]);
					_poker.x = j*100;
					_poker.y = i*25;
					this.stage.addChild(_poker);
					pokerAry.push(_poker);
				}
			}
			addEventListenerToPoker();
		}
		
		public function addEventListenerToPoker():void{
			for(var i:int=0;i<pokerAry.length;i++){
				Poker(pokerAry[i]).addEventListener(MouseEvent.MOUSE_DOWN,beginDrag);
				Poker(pokerAry[i]).addEventListener(MouseEvent.MOUSE_UP,endDrag);
			}
		}
		
		public function beginDrag(e:MouseEvent):void{
			
			for(var i:int=0;i<pokerAry.length;i++){
				Poker(pokerAry[i]).startDrag(true);
			}
		}
		
		public function endDrag(e:MouseEvent):void{
			for(var i:int=0;i<pokerAry.length;i++){
				Poker(pokerAry[i]).stopDrag();
			}
		}
	}
}