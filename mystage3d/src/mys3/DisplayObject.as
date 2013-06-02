package mys3
{
	import flash.geom.Matrix;
	
	/**
	 * 
	 * DisplayObject.as
	 *
	 * @author 	Loafer
	 * @date 	2013 10:17:12 AM
	 *
	 */
	public class DisplayObject
	{
		public function DisplayObject()
		{
		}
		
		public var x:Number;
		public var y:Number;
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		
		public var rotation:Number = 0;
		
		public var matrix:Matrix = new Matrix();
		
		public function getMatrix():Matrix{
			matrix.identity();
			if (scaleX != 1.0 || scaleY != 1.0) matrix.scale(scaleX, scaleY);
			if (rotation != 0.0)                 matrix.rotate(rotation);
			if (x != 0.0 || y != 0.0)           matrix.translate(x, y);
			
			//			if (mPivotX != 0.0 || mPivotY != 0.0)
			//			{
			//				// prepend pivot transformation
			//				matrix.tx = mX - matrix.a * mPivotX
			//					- matrix.c * mPivotY;
			//				matrix.ty = mY - matrix.b * mPivotX 
			//					- matrix.d * mPivotY;
			//			}
			return matrix;
		}
	}
}