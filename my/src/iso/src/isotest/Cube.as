package isotest
{
	import flash.display.Graphics;
	import flash.geom.Point;

	public class Cube extends IsoItem
	{
		public function Cube(width:int, height:int)
		{
			super();
			this.rect = new Point(width, height);
			inintGraph();
		}
		
		private function inintGraph():void{
			var w:int = this.rect.x;
			var h:int = this.rect.y;
			var i:int,j:int;
			var sx:Number,sy:Number,ex:Number, ey:Number;
			var sp:Point, ep:Point;
			
			var p1:Point,p2:Point,p3:Point,p4:Point;
			p1 = IsoMath.isoToScreen(new Point(0,0));
			p2 = IsoMath.isoToScreen(new Point(w,0));
			p3 = IsoMath.isoToScreen(new Point(w,h));
			p4 = IsoMath.isoToScreen(new Point(0,h));
			
			var g:Graphics = this.graphics;
			g.moveTo(p2.x, p2.y);
			g.lineTo(p3.x, p3.y);
			g.moveTo(p3.x, p3.y);
			g.lineTo(p4.x, p4.y);
			
			
			
			
		}
		
		
	}
}