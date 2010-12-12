package
{
	import compnent.SampleClickAndDoubleClick;
	import compnent.SampleKeyInput;
	import compnent.SampleMouseAndKey;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import pokergame.Poker;
	import pokergame.PokerTable;
	import pokergame.PuKe;
	
	import test.DragTest;
	
	public class game extends Sprite
	{
		
		
		/**
		 * i love my lulu
		 * 
		 * i love you lanlan
		 * 
		 * this is my wife's run class 
		 * 
		 */		
		public function game()
		{
			/*var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x664455);
			bg.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill();
			addChild(bg);*/
			
			
			addChild(new PokerTable());
			
		}
	}
}