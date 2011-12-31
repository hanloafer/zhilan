package simmvc
{
	import flash.utils.Dictionary;
	
	import flashx.textLayout.elements.InlineGraphicElement;

	public class Dispatcher implements IDispatcher
	{
		
		protected var eventDic:Dictionary = new Dictionary();
		
		public function Dispatcher()
		{
		}
		
		public function dispatch(event:String, data:*=null):void
		{
		}
		
		public function addEvent(event:String, callback:Function):void
		{
			var arry:Array;
			if(eventDic[event] == null){
				arry = eventDic[event];
			}else{
				arry = [];
				eventDic[event] = [];
			}
			arry.push(callback);
		}
		
		public function removeEvent(event:String, callback:Function):void
		{
			var arry:Array = eventDic[event];
			if(arry != null){
				var idx:int = arry.indexOf(callback);
				if(idx != -1){
					arry.splice(idx, 1);
				}
			}
		}
	}
}