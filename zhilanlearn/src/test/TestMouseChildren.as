package test
{
	import compnent.CircleSprtie;
	import compnent.RectSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TestMouseChildren extends Sprite
	{
		public function TestMouseChildren()
		{
			super();
			var rect:RectSprite = new RectSprite();
			var circle:CircleSprtie = new CircleSprtie();
			circle.buttonMode = true;
			
			rect.addChild(circle);
			//rect.mouseChildren = false;
			this.addChild(rect);
			
			rect.addEventListener(MouseEvent.CLICK, onRectClick);
			circle.addEventListener(MouseEvent.CLICK, onCircleClick);
		}
		
		private var count:int=0;
		private function onRectClick(e:Object):void{
			trace("[Rect]: hello kitty" + count++);
		}
		
		private function onCircleClick(e:Object):void{
			trace("[Circle]: hello kitty" + count++);
		}
	}
}