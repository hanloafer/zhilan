package psw2d
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;

	public class QuadRender
	{
		private var _context3D:Context3D;
		private var _quads:Vector.<Quad>;
		
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _vertexData:QuadVertex;
		
		public function QuadRender(context3D:Context3D)
		{
			_context3D = context3D;
			_quads = new Vector.<Quad>();
		}
		
		public function addQuad(quad:Quad):Quad
		{
			_quads.push(quad);
			rebuildBuffer();
			return quad;
		}
		
		public function rebuildBuffer():void
		{
			_vertexBuffer && _vertexBuffer.dispose();
			_indexBuffer && _indexBuffer.dispose();
			var numQuads:uint = _quads.length;
			if(!numQuads) return;
			var vertexData:Vector.<Number>=new Vector.<Number>();
			var indexData:Vector.<uint>=new Vector.<uint>();
			_vertexData = new QuadVertex();
			for(var i:int=0;i<numQuads;++i)
			{
				_quads[i].vertexData.copyTo(_vertexData)
				_vertexData.transformVertex(_quads[i].modelMatrix);
				vertexData = vertexData.concat(_vertexData.rawData);
				indexData.push(i*4+0,i*4+1,i*4+2,i*4+0,i*4+2,i*4+3);
			}
			_vertexBuffer = _context3D.createVertexBuffer(numQuads * 4,QuadVertex.ELEMENTS_PER_VERTEX);
			_indexBuffer = _context3D.createIndexBuffer(numQuads * 6);
			
			_vertexBuffer.uploadFromVector(vertexData,0,numQuads * 4);
			_indexBuffer.uploadFromVector(indexData,0,indexData.length);
			
			_context3D.setVertexBufferAt(0,_vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1,_vertexBuffer,3,Context3DVertexBufferFormat.FLOAT_4);
		}
		
		public function setMatrix(sW:Number,sH:Number):void
		{
			var pm:Matrix3D = new Matrix3D(Vector.<Number>(
				[
					2/sW,0,0,0,
					0,-2/sH,0,0,
					0,0,0,0,
					-1,1,0,1
				]));
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,pm,true);
		}
		
		public function setProgram():void
		{
			var vertexSrc:String = "m44 op,va0,vc0 \n" +
				"mov v0,va1";
			var fragmentSrc:String = "mov oc,v0";
			
			var vertexAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			var fragmentAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexAssembler.assemble(Context3DProgramType.VERTEX,vertexSrc);
			fragmentAssembler.assemble(Context3DProgramType.FRAGMENT,fragmentSrc);
			var program:Program3D = _context3D.createProgram();
			program.upload(vertexAssembler.agalcode,fragmentAssembler.agalcode);
			_context3D.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);//在开启深度测试的情况下，可通过这样的设置启动alpha混合
			_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			_context3D.setProgram(program);
		}
		
		public function render():void
		{
			rebuildBuffer();
			_context3D.clear(1,1,1,1);
			
			_context3D.drawTriangles(_indexBuffer,0,4);
			_context3D.present();
		}
	}
}