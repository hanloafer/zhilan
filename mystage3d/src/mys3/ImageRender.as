package mys3
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.text.engine.ContentElement;
	
	/**
	 * 
	 * ImageRender.as
	 *
	 * @author 	Loafer
	 * @date 	2013 10:32:51 AM
	 *
	 */
	public class ImageRender
	{
		public function ImageRender(contenxt:Context3D)
		{
			_context3D = contenxt;
			_images = new Vector.<Image>();
		}
		
		private var _images:Vector.<Image>;
		private var _context3D:Context3D;
		
		private var _vectextBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		
		private static var z:uint = 0;
		
		public function addQuad(quad:Image):void{
			_images.push(quad);
		}
		
		private var  pm:Matrix3D;
		
		public function setMatrix(sW:Number,sH:Number):void
		{
			pm = new Matrix3D(Vector.<Number>(
				[
					2/sW,0,0,0,
					0,-2/sH,0,0,
					0,0,0,0,
					-1,1,0,1
				]));
			//			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,pm,true);
		}
		
		public function rebuidBuffer():void{
			_vectextBuffer && _vectextBuffer.dispose();
			_indexBuffer && _indexBuffer.dispose();
			
			var quadNum:int = _images.length;
			if(quadNum == 0){
				return;
			}
			var vertextData:Vector.<Number> = new Vector.<Number>(20*quadNum, true);
			var indexData:Vector.<uint> = new Vector.<uint>(6*quadNum,true);
			
//			var color:uint,r:Number,g:Number,b:Number,a:Number;
			var v0:uint,v1:uint,v2:uint,v3:uint;
			var c:uint = 0,n:uint=0,v:uint=0;
			var quad:Image;
			var pt:Point = new Point();
			var matrix:Matrix;
			
			for(var i:uint=0; i<quadNum; i++){
				quad = _images[i];
				matrix = quad.getMatrix()				
//				color = quad.color;
//				a = color>>24&0xff;
//				r = color>>16&0xff;
//				g = color>>8&0xff;
//				b = color&0xff;
//				a /= 0xff;
//				r /= 0xff;
//				g /= 0xff;
//				b /= 0xff;
				//				trace(a);
				
				//x,y,z r,g,b
				pt.x = 0;
				pt.y = quad.height;
				pt = matrix.transformPoint(pt);
				
				v0 = v++;
				vertextData[c++] = pt.x;
				vertextData[c++] = pt.y;
				vertextData[c++] = z;
				vertextData[c++] = 0;
				vertextData[c++] = quad.height;
				
				pt.x = 0;
				pt.y = 0;
				pt = matrix.transformPoint(pt);
				
				v1 = v++;
				vertextData[c++] = pt.x;
				vertextData[c++] = pt.y;
				vertextData[c++] = z;
				vertextData[c++] = 0;
				vertextData[c++] = 0;
				
				pt.x = quad.width;
				pt.y = 0;
				pt = matrix.transformPoint(pt);
				
				v2 = v++;
				vertextData[c++] = pt.x;
				vertextData[c++] = pt.y;
				vertextData[c++] = z;
				vertextData[c++] = quad.width;
				vertextData[c++] = 0;
				
				pt.x = quad.width;
				pt.y = quad.height;
				pt = matrix.transformPoint(pt);
				
				v3 = v++;
				vertextData[c++] = pt.x;
				vertextData[c++] = pt.y;
				vertextData[c++] = z;
				vertextData[c++] = quad.width;
				vertextData[c++] = quad.height;
				
				indexData[n++] = v0;
				indexData[n++] = v1;
				indexData[n++] = v2;
				indexData[n++] = v0;
				indexData[n++] = v2;
				indexData[n++] = v3;
				
				var tex:Texture = _context3D.createTexture(quad.bitmapData.width,quad.bitmapData.height,Context3DTextureFormat.BGRA,false);
				tex.uploadFromBitmapData(quad.bitmapData);
				_context3D.setTextureAt(0,tex);
			}
			
			_vectextBuffer = _context3D.createVertexBuffer(quadNum*4,5);
			_indexBuffer = _context3D.createIndexBuffer(quadNum*6);
			
			_vectextBuffer.uploadFromVector(vertextData,0,quadNum*4);
			_indexBuffer.uploadFromVector(indexData,0,indexData.length);
			
			
			_context3D.setVertexBufferAt( 0, _vectextBuffer, 0, Context3DVertexBufferFormat.FLOAT_3 );   // attribute #0 will contain the position information
			_context3D.setVertexBufferAt( 1, _vectextBuffer, 3, Context3DVertexBufferFormat.FLOAT_2 );
			
		}
		
		public function setProgram():void{
			//			var pm:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			//			pm = new Matrix3D(Vector.<Number>(
			//				[
			//					1,0,0,0,
			//					0,1,0,0,
			//					0,0,0,0,
			//					0,0,0,1
			//				]));
			//			pm.perspectiveFieldOfViewLH(1,1,1,1);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,pm,true);
			
			
			var vertexSrc:String = "m44 op,va0,vc0 \n" +//"mov op,va0 1\n" +
				"mov v0,va1";
			var fragmentSrc:String = "tex ft0, v0, fs0 <2d,nearest>\n"+
				"mov oc, ft0";
			
			var vectexAssember:AGALMiniAssembler = new AGALMiniAssembler();
			var fragmentAssember:AGALMiniAssembler = new AGALMiniAssembler();
			vectexAssember.assemble(Context3DProgramType.VERTEX,vertexSrc);
			fragmentAssember.assemble(Context3DProgramType.FRAGMENT,fragmentSrc);
			
			var program3d:Program3D = _context3D.createProgram();
			program3d.upload(vectexAssember.agalcode, fragmentAssember.agalcode);
			//			_context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			
			_context3D.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);//在开启深度测试的情况下，可通过这样的设置启动alpha混合
			_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			//			_context3D.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);
			//			_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			_context3D.setProgram(program3d);
			
		}
		
		public function render():void{
			_context3D.clear(1,1,1,1);
			_context3D.drawTriangles(_indexBuffer);
			_context3D.present();
		}
	}
	
	
}