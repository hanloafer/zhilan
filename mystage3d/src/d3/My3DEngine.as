package d3
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	/**
	 * 
	 * My3DEngine.as
	 *
	 * @author 	Loafer
	 * @date 	2013 3:26:04 PM
	 *
	 */
	public class My3DEngine
	{
		
		private var _context3D:Context3D;
		
		private var _stage:Stage;
		
		public function My3DEngine(stage:Stage, context3D:Context3D)
		{
			_context3D = context3D;
			_stage = stage;
			initEngineMatrix();
			initMeshData();
			_stage.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		public var projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
		public var viewMatrix:Matrix3D = new Matrix3D();
		public var modelViewProjection:Matrix3D = new Matrix3D();
		
		
		private var _meshVertextData:Vector.<Number>;
		private var _meshIndexData:Vector.<uint>;
		
		private var _texture:Texture;
		
		private var _bitmapData:BitmapData;
		
		[Embed(source="../test.jpg")]
		private var bmp:Class;
		
		private var _shaderProgrem:Program3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _vetextBuffer:VertexBuffer3D;

		private var modelMatrix:Matrix3D;
		
		private function initMeshData():void{
			_meshIndexData = Vector.<uint>([
				0,1,2,  0,2,3,
			]);
			_meshVertextData = Vector.<Number>([
				-1,-1,1, 0,0, 1,0,0,1,
				 1,-1,1, 1,0, 0,1,0,1,
				 1, 1,1, 1,1, 0,0,1,1,
				-1, 1,1, 0,1, 1,1,1,1
			]);
			
			var vertextShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertextShaderAssembler.assemble(
				Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n"+
				"mov v0, va0\n"+
				"mov v1, va1\n"+
				"mov v2,va2"
			);
			
			var fregmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fregmentShaderAssembler.assemble(
				Context3DProgramType.FRAGMENT,
				"tex ft0, v1, fs0 <2d,repeat,nomip,linear>\n" +
				"mul ft1, fc0,ft0\n"+
				"mov oc, ft1\n"
			);
			
			_shaderProgrem = _context3D.createProgram();
			_shaderProgrem.upload(vertextShaderAssembler.agalcode, fregmentShaderAssembler.agalcode);
			
			_indexBuffer = _context3D.createIndexBuffer(_meshIndexData.length);
			_indexBuffer.uploadFromVector(_meshIndexData,0,_meshIndexData.length);
			_vetextBuffer = _context3D.createVertexBuffer(4,9);
			_vetextBuffer.uploadFromVector(_meshVertextData, 0,4);
			
			_bitmapData = new bmp().bitmapData;
			_texture = _context3D.createTexture(_bitmapData.width,_bitmapData.height,Context3DTextureFormat.BGRA,false);
			_texture.uploadFromBitmapData(_bitmapData,0);
			
		}
		
		private function initEngineMatrix():void{
			projectionMatrix.identity();
			projectionMatrix.perspectiveFieldOfViewRH(45.0,_stage.stageWidth/_stage.stageHeight,0.01,100.0);
			
			viewMatrix.identity();
			viewMatrix.appendTranslation(0,0,-4);
			
			modelMatrix = new Matrix3D();
		}
		
		private var t:int;
		
		protected function onFrame(event:Event):void
		{
			_context3D.clear(0,0,0);
			_context3D.setProgram(_shaderProgrem);
			
			t = getTimer();
			modelMatrix.appendRotation(0.1,Vector3D.Y_AXIS);
			modelMatrix.appendRotation(0.2, Vector3D.X_AXIS);
			modelMatrix.appendRotation(0.7, Vector3D.Z_AXIS);
			
			modelViewProjection.identity();
			modelViewProjection.append(modelMatrix);
			modelViewProjection.append(viewMatrix);
			modelViewProjection.append(projectionMatrix);
			
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,modelViewProjection,true);
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,
				Vector.<Number>([
					1,
					Math.abs(Math.cos(t/500)),
					0,
					1
				])
			);
			
			_context3D.setVertexBufferAt(0,_vetextBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1,_vetextBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
			_context3D.setVertexBufferAt(2,_vetextBuffer,5,Context3DVertexBufferFormat.FLOAT_4);
			
			_context3D.setTextureAt(0,_texture);
			_context3D.drawTriangles(_indexBuffer,0,_meshIndexData.length/3);
			_context3D.present();
		}
	}
}