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
			addChild(new PokerTable());
			
		}
	}
}