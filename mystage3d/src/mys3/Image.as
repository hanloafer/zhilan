package mys3
{
	import flash.display.BitmapData;
	
	/**
	 * 
	 * Image.as
	 *
	 * @author 	Loafer
	 * @date 	2013 10:48:54 AM
	 *
	 */
	public class Image extends DisplayObject
	{
		public function Image()
		{
		}
		
		private var _bitmapData:BitmapData;
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}
		
		public function get width():Number{
			return _bitmapData.width;
		}
		
		public function get height():Number{
			return _bitmapData.height;
		}

	}
}