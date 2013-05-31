package psw2d
{
	import flash.geom.Matrix;

	public class QuadVertex
	{
		public static const ELEMENTS_PER_VERTEX:int = 7;
		private var _rawData:Vector.<Number>;
		
		public function QuadVertex()
		{
			_rawData = new Vector.<Number>(4*ELEMENTS_PER_VERTEX,true);
		}
		
		public function setPosition(index:uint,x:Number,y:uint):void
		{
			var offset:int = ELEMENTS_PER_VERTEX * index;
			_rawData[offset] = x;
			_rawData[offset+1] = y;
			_rawData[offset+2] = 0;
		}
		
		public function setColor(index:uint,color:uint):void
		{
			var offset:int = ELEMENTS_PER_VERTEX * index;
			var alpha:Number = (color >> 24 ) & 0xFF;
			var r:Number = (color >> 16) & 0xFF
			var g:Number = (color >> 8) & 0xFF;
			var b:Number = (color & 0xFF);
			
			r/=0xFF;
			g/=0xFF;
			b/=0xFF;
			alpha/=0xFF;
			
			_rawData[offset+3] = r;
			_rawData[offset+4] = g;
			_rawData[offset+5] = b;
			_rawData[offset+6] = alpha;
		}
		
		public function get rawData():Vector.<Number>
		{
			return _rawData;
		}

		public function set rawData(value:Vector.<Number>):void
		{
			_rawData = value;
		}

		public function transformVertex(modelMatix:Matrix):void
		{
			var x:Number,y:Number;
			for(var i:int=0; i<4; ++i)
			{
				x = _rawData[i*ELEMENTS_PER_VERTEX];
				y = _rawData[i*ELEMENTS_PER_VERTEX+1];
				_rawData[i*ELEMENTS_PER_VERTEX] = modelMatix.a * x + modelMatix.c * y + modelMatix.tx;
				_rawData[i*ELEMENTS_PER_VERTEX+1] = modelMatix.b * x + modelMatix.d * y + modelMatix.ty;
			}
		}
		
		public function copyTo(target:QuadVertex):void
		{
			for(var i:uint;i<_rawData.length;++i)
			{
				target.rawData[i] = _rawData[i];
			}
		}
	}
}