package test
{
	import compnent.CircleSprtie;
	import compnent.RectSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TestMouseOver extends Sprite
	{
		public function TestMouseOver()
		{
			super();
			var rect:Sprite = new RectSprite();
			var cicle1:CircleSprtie = new CircleSprtie();
			
			rect.addChild(cicle1);
			addChild(rect);
			rect.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			rect.addEventListener(MouseEvent.ROLL_OVER, rollOver);
		}
		
		private function mouseOver(e:Event):void{
			trace("mouseOver");
		}
		
		private function rollOver(e:Event):void{
			trace("rollOver");
		}
	}
}