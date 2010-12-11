package compnent
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SampleClickAndDoubleClick extends Sprite
	{
		public function SampleClickAndDoubleClick()
		{
			var click:MyRect = new MyRect("单击",0x66ccff);
			click.name = "【单击方块】";
			click.mouseChildren = false;
			addChild(click);
			
			var doubleClick:MyRect = new MyRect("双击",0xffcc00);
			doubleClick.name = "【双击方块】";
			doubleClick.x = 200;
			doubleClick.mouseChildren = false;
			addChild(doubleClick);
			
			//侦听单击
			click.addEventListener(MouseEvent.CLICK,clickHandler);
			//click.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			//click.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			
			doubleClick.doubleClickEnabled = true;
			//侦听双击
			doubleClick.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickHandler);
			//doubleClick.addEventListener(MouseEvent.CLICK,clickHandler);
			//doubleClick.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			//doubleClick.addEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		
		private function clickHandler(evt:Event):void{
			trace(evt.target.name + ":\t"+"单击");
		}
		
		private function downHandler(evt:MouseEvent):void{
			trace(evt.target.name+"\t"+"鼠标按键按下");
		}
		
		private function upHandler(evt:MouseEvent):void{
			trace(evt.target.name +"\t"+"鼠标按键松开");
		}
		
		private function doubleClickHandler(evt:MouseEvent):void{
			trace(evt.target.name + "\t"+"双击");
		}
		
	}
}