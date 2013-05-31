package mys3
{
	import flash.geom.Matrix;
	
	/**
	 * 
	 * Quad.as
	 *
	 * @author 	Loafer
	 * @date 	2013 11:19:39 AM
	 *
	 */
	public class Quad
	{
		public function Quad()
		{
		}
		
		public var x:Number;
		public var y:Number;
		
		public var width:Number;
		public var height:Number;
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		
		public var rotation:Number = 0;
		
		public var matrix:Matrix;
		
		public var color:uint;
	}
}