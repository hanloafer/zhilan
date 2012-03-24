package isotest
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
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
			var p8:Point,p5:Point,p6:Point,p7:Point;
			p1 = IsoMath.isoToScreen(new Point(0,0));
			p2 = IsoMath.isoToScreen(new Point(w,0));
			p3 = IsoMath.isoToScreen(new Point(w,h));
			p4 = IsoMath.isoToScreen(new Point(0,h));
			
			var highrate:int = 1;
			
			p5 = new Point(p1.x, p1.y-IsoMath.cell*highrate);
			p6 = new Point(p2.x, p2.y-IsoMath.cell*highrate);
			p7 = new Point(p3.x, p3.y-IsoMath.cell*highrate);
			p8 = new Point(p4.x, p4.y-IsoMath.cell*highrate);
			
			var g:Graphics = this.graphics;
			g.lineStyle(2,0x0000ff);
			g.beginFill(0xffffff*Math.random());
			
			
			var cmds:Vector.<int> = new Vector.<int>();
			var pts:Vector.<Number> = new Vector.<Number>();
			
			cmds.push(GraphicsPathCommand.MOVE_TO);
			pts.push(p8.x);
			pts.push(p8.y);
			cmds.push(GraphicsPathCommand.LINE_TO);
			pts.push(p4.x);
			pts.push(p4.y);
			cmds.push(GraphicsPathCommand.LINE_TO);
			pts.push(p3.x);
			pts.push(p3.y);
			cmds.push(GraphicsPathCommand.LINE_TO);
			pts.push(p2.x);
			pts.push(p2.y);
			cmds.push(GraphicsPathCommand.LINE_TO);
			pts.push(p6.x);
			pts.push(p6.y);
			
			cmds.push(GraphicsPathCommand.LINE_TO);
			pts.push(p5.x);
			pts.push(p5.y);
			cmds.push(GraphicsPathCommand.LINE_TO);
			pts.push(p8.x);
			pts.push(p8.y);
			
			g.drawPath(cmds, pts);
			g.endFill();
			
			cmds = new Vector.<int>();
			pts = new Vector.<Number>();
			
			cmds.push(GraphicsPathCommand.LINE_TO);
			pts.push(p7.x);
			pts.push(p7.y);
			cmds.push(GraphicsPathCommand.LINE_TO);
			pts.push(p6.x);
			pts.push(p6.y);
			
			
			cmds.push(GraphicsPathCommand.MOVE_TO);
			pts.push(p7.x);
			pts.push(p7.y);
			cmds.push(GraphicsPathCommand.LINE_TO);
			pts.push(p3.x);
			pts.push(p3.y);
			
			g.drawPath(cmds, pts);
			
			g.endFill();
			
			this.cacheAsBitmap = true;
			
		}
		
		
	}
}