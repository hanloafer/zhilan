package compnent
{
	import flash.display.Sprite;
	
	import org.hamcrest.mxml.collection.InArray;
	
	public class CircleSprtie extends Sprite
	{
		public function CircleSprtie(x:Number=30,y:Number=30,r:Number=30, color:int=0x667788)
		{
			super();
			this.graphics.beginFill(color);
			this.graphics.drawCircle(x, y, r);
			this.graphics.endFill();
		}
	}
}