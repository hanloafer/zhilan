package compnent
{
	import flash.display.Sprite;

	public class RectContainer extends Sprite
	{
		public function RectContainer(x:Number,y:Number,w:Number,h:Number)
		{
			this.graphics.beginFill(0xFFFFFF*Math.random());
			this.graphics.drawRect(x,y,w,h);
			this.graphics.endFill();
		}
	}
}