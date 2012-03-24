package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	
	import isotest.ViewPort;
	
	[SWF(width="800", height="600", backgroundColor="0xffffff", frameRate="31")]
	public class iso extends Sprite
	{
		public function iso()
		{
			stage.scaleMode  = StageScaleMode.NO_SCALE;
			
			var vp:ViewPort = new ViewPort();
			addChild(vp);
		}
	}
}