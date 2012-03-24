package isotest
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class IsoItem extends Sprite
	{
		
		private var _isoPos:Point;
		
		private var _rect:Point;
		
		public function IsoItem()
		{
			super();
		}
		
		
		public function get rect():Point
		{
			return _rect;
		}

		public function set rect(value:Point):void
		{
			_rect = value;
		}

		public function get isoPos():Point
		{
			return _isoPos;
		}

		public function set isoPos(value:Point):void
		{
			_isoPos = value;
		}

	}
}