package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import pokergame.Poker;
	import pokergame.Group;
	import pokergame.Table;
	
	import test.TestPokerGroup;
	
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
			
			addChild(new TestPokerGroup());
			
		}
	}
}