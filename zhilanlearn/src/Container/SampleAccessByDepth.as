package Container
{
	import compnent.CircleSprtie;
	import compnent.RectSprite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class SampleAccessByDepth extends Sprite
	{
		public function SampleAccessByDepth()
		{
			var a:RectSprite = new RectSprite(150,150,0x666666);
			var b:RectSprite = new RectSprite(150,100,0xff6600);
			var c:RectSprite = new RectSprite(100,150,0x4c1b1b);
			
			a.x = 200,a.y = 0;
			c.x = 400,c.y = 100;
			b.addChild(new CircleSprtie());
			
			var container:Sprite = new Sprite();
			container.addChild(a);
			container.addChild(b);
			container.addChild(c);
			
			this.addChild(container);
			
			var _circle:CircleSprtie;
			
			for(var i:int=0;i<container.numChildren;i++){
				for(var j:int=0;j<(container.getChildAt(i) as Sprite).numChildren;j++){
					var tmpobj:DisplayObject = (container.getChildAt(i) as Sprite).getChildAt(j);
					if(tmpobj is CircleSprtie){
						_circle = tmpobj as CircleSprtie;
					}
				}
			}
			if(_circle != null){
				_circle.alpha = 0.5;
			}
			
			
		}
	}
}