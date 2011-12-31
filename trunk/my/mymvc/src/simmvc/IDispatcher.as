package simmvc
{
	public interface IDispatcher
	{
		function dispatch(event:String, data:*=null):void;
		
		function addEvent(event:String, callback:Function):void;
		
		function removeEvent(event:String, callback:Function):void;
	}
}