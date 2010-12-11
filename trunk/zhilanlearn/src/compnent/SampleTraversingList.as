package compnent
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	//import mx.utils.DisplayUtil;

	public class SampleTraversingList extends Sprite
	{
		public function SampleTraversingList()
		{
			var container:Sprite = new Sprite();
			var rect:MyRect = new MyRect("ok",0x668899);
			rect.y = 100;
			container.addChild(rect);
			container.addChild(new CircleSprtie());
			container.addChild(new MyRect("hi",0x660066));
			
			addChild(container);
			rect.name = "KingdaRect";
			var a:MyRect = container.getChildByName("KingdaRect")as MyRect;
			trace(a.getChildByName("ss"));
			//traverDisplayContainer(container);
			//DisplayUtil.walkDisplayObjects(container,traceContent);
		}
		
	public static function traverDisplayContainer(container:DisplayObjectContainer,indentString:String=""):void{
			var child:DisplayObject;
			for(var i:int=0;i<container.numChildren;i++){
				child = container.getChildAt(i);
				trace(indentString,"depth:"+i,child,child.name);
				if(container.getChildAt(i)is DisplayObjectContainer){
					traverDisplayContainer(DisplayObjectContainer(child),indentString+"");
				}
			}
		}
	}
}