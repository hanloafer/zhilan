package isotest
{
	import flash.geom.Point;

	public class IsoMath
	{
		
		public static var cell:int = 40;
		
		public function IsoMath()
		{
		}
		
		public static function isoToScreen(pt:Point):Point{
			var y:Number = (pt.x + pt.y) / 2;
			var x:Number = pt.x - pt.y;
 			return new Point(x*cell, y*cell);
		}
		
		public static function screenToIso(pt:Point):Point{
			var y:Number = pt.y - pt.x / 2 ;
			var x:Number = pt.x / 2 + pt.y ;
			
			/* if (bAxonometricAxesProjection)
			{
			} */
			x = x / cell;
			y = y / cell;
			return new Point(x, y);
		}
		
	}
}