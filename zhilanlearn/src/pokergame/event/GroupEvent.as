package pokergame.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import pokergame.Poker;
	
	public class GroupEvent extends MouseEvent
	{
		
		public static const POKER_DRAG_END:String = "POKER_DRAG_END";
		
		public function GroupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public var poker:Poker;
	}
}