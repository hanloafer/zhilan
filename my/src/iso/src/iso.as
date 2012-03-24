package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	
	import isotest.Cube;
	import isotest.ViewPort;
	
	[SWF(width="1200", height="900", backgroundColor="0xffffff", frameRate="31")]
	public class iso extends Sprite
	{
		public function iso()
		{
			stage.scaleMode  = StageScaleMode.NO_SCALE;
			
			var vp:ViewPort = new ViewPort();
			addChild(vp);
			
			
			
			var i:int,j:int;
			for(i=0; i<6; i++){
				for(j=0; j<6; j++){
					var w:int = int(Math.random()*3) +1;
					var h:int = int(Math.random()*3) +1;
					var cube:Cube = new Cube(w, h);
					cube.isoPos = new Point(i*3, j*3);
					vp.addItem(cube);
				}
			}
			
			
		}
	}
}