package compnent
{
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SampleEventFlow extends Sprite
	{
		public function SampleEventFlow()
		{
			var outter:Sprite = new RectContainer(10,10,200,200);
			var middle:Sprite = new RectContainer(30,30,150,150);
			var inner:Sprite = new RectContainer(50,50,100,100);
			outter.name = "外层容器";
			middle.name = "中层容器";
			inner.name = "内层容器";
			
			addChild(outter);
			outter.addChild(middle);
			middle.addChild(inner);
			
			inner.addEventListener(MouseEvent.CLICK,clickHandle);
			middle.addEventListener(MouseEvent.CLICK,clickHandle);
			outter.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		public function clickHandle(evt:MouseEvent):void{
			trace("事件发生目标：\t"+evt.target.name);
			trace("正在侦听事件的当前目标："+evt.currentTarget.name);
			trace("事件当前阶段：\t"+evt.eventPhase);
			trace("==============================================");
		}
	}
}