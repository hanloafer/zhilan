package compnent
{
	import flash.display.Sprite;
	
	public class RectSprite extends Sprite
	{
		public function RectSprite(width:Number=80, height:Number=80, color:int=0xffccff)
		{
			super();
			
			this.graphics.beginFill(color);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
	}
}