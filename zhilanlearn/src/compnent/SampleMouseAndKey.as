package compnent
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SampleMouseAndKey extends Sprite
	{
		public function SampleMouseAndKey()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void{
			this.stage.addEventListener(MouseEvent.CLICK,clickHandler);
			this.stage.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function clickHandler(evt:MouseEvent):void{
			var color:uint = 0xffffff;
			if(evt.ctrlKey) color = 0x66cc00;
			if(evt.altKey) color = 0x669933;
			if(evt.shiftKey) color = 0x66ff00;
			if(evt.altKey && evt.ctrlKey) color = 0xffcc00;
			if(evt.altKey && evt.shiftKey)color = 0xffff00;
			if(evt.altKey && evt.ctrlKey && evt.shiftKey) color = 0xff9900;
			trace("click:"+ color.toString(16));
			
			var circle:CircleSprtie = new CircleSprtie(evt.stageX,evt.stageY,50,color);
			addChild(circle);
		}
	}
}