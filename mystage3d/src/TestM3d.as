package
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	
	
	/**
	 * 
	 * TestM3d.as
	 *
	 * @author 	Loafer
	 * @date 	2013 12:46:23 PM
	 *
	 */
	public class TestM3d extends Sprite
	{
		public function TestM3d()
		{
			super();
			
			var m3:Matrix3D = new Matrix3D();
			m3.appendScale(2,-2,1);
			m3.appendTranslation(1,-1,0);
			trace(m3.rawData);
			
//			2,0,0,0,
//			0,-2,0,0,
//			0,0,1,0,
//			1,-1,0,1
		}
	}
}