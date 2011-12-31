package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TestSprite extends Sprite
	{
		public function TestSprite()
		{
			super();
			this.graphics.beginFill(0x0f);
			this.graphics.drawRoundRect(0,0, 50,50,3);
			this.graphics.endFill();
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onClick(e:Object):void{
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
		
		private function onFrame(e:*):void{
			trace("ccc");
		}
	}
}