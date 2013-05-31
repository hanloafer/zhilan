package psw2d
{
	import flash.geom.Matrix;

	/**
	 *	0 -	1
	 * 	| /	|
	 * 	3 - 2
	 * @author Physwf
	 * 
	 */	
	public class Quad
	{
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _color:uint;
		
		private var _modelMatrix:Matrix;
		private var _isMatrixDirty:Boolean = false;
		
		private var _vertexData:QuadVertex;
		
		public function Quad(w:Number,h:Number,color:uint=0)
		{
			_x = 0;
			_y = 0;
			_width = w;
			_height = h;
			_color = color;
			
			_vertexData = new QuadVertex();
			_vertexData.setPosition(0,0,0);
			_vertexData.setPosition(1,_width,0);
			_vertexData.setPosition(2,_width,_height);
			_vertexData.setPosition(3,0,_height);
			_vertexData.setColor(0,_color);
			_vertexData.setColor(1,_color);
			_vertexData.setColor(2,_color);
			_vertexData.setColor(3,_color);
			
			_modelMatrix = new Matrix();
		}
		
		public function set x(value:Number):void
		{
			if(_x==value) return;
			_x = value;
			_isMatrixDirty = true;
		}

		public function get x():Number
		{
			return _x;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			if(_y == value) return;
			_y = value;
			_isMatrixDirty = true;
		}

		public function get width():Number
		{
			return _width * _scaleX;
		}

		public function set width(value:Number):void
		{
			if(width == value) return;
			_scaleX = value / _width;
			_isMatrixDirty = true;
		}

		public function get height():Number
		{
			return _height * _scaleY;
		}

		public function set height(value:Number):void
		{
			if(height == value) return;
			_scaleY = value / _height;
			_isMatrixDirty = true;
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
		}

		public function get scaleX():Number
		{
			return _scaleX;
		}

		public function set scaleX(value:Number):void
		{
			if(_scaleX == value) return;
			_scaleX = value;
			_isMatrixDirty = true;
		}

		public function get scaleY():Number
		{
			return _scaleY;
		}

		public function set scaleY(value:Number):void
		{
			if(_scaleY == value) return;
			_scaleY = value;
			_isMatrixDirty = true;
		}
		
		public function get modelMatrix():Matrix
		{
			if(_isMatrixDirty)
			{
				_modelMatrix.identity();
				_isMatrixDirty = false;
				_modelMatrix.translate(_x,_y);
				_modelMatrix.scale(_scaleX,_scaleY);
			}
			return _modelMatrix;
		}
		
		public function get vertexData():QuadVertex
		{
			return _vertexData;
		}
	}
}