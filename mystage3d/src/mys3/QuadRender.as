package mys3
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	
	/**
	 * 
	 * QuadRender.as
	 *
	 * @author 	Loafer
	 * @date 	2013 11:29:49 AM
	 *
	 */
	public class QuadRender
	{
		
		private var _quads:Vector.<Quad>;
		private var _context3D:Context3D;
		
		
		private var _vectextBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		
		private static var z:uint = 1;
		
		public function QuadRender(contenxt:Context3D)
		{
			_context3D = contenxt;
			_quads = new Vector.<Quad>();
		}
		
		
		public function addQuad(quad:Quad):void{
			_quads.push(quad);
		}
		
		public function rebuidBuffer():void{
			_vectextBuffer && _vectextBuffer.dispose();
			_indexBuffer && _indexBuffer.dispose();
			
			var quadNum:int = _quads.length;
			if(quadNum == 0){
				return;
			}
			var vertextData:Vector.<Number> = new Vector.<Number>(24*quadNum, true);
			var indexData:Vector.<uint> = new Vector.<uint>(6*quadNum,true);
			
			var color:uint,r:uint,g:uint,b:uint;
			var v0:uint,v1:uint,v2:uint,v3:uint;
			var c:uint = 0,n:uint=0,v:uint=0;
			var quad:Quad;
			
			for(var i:uint=0; i<quadNum; i++){
				quad = _quads[i];
				
				color = quad.color;
				r = color>>16&0xff;
				g = color>>8&0xff;
				b = color&0xff;
				
				//x,y,z r,g,b
				v0 = v++;
				vertextData[c++] = quad.x;
				vertextData[c++] = quad.y + quad.height;
				vertextData[c++] = z;
				vertextData[c++] = r;
				vertextData[c++] = g;
				vertextData[c++] = b;
				
				v1 = v++;
				vertextData[c++] = quad.x;
				vertextData[c++] = quad.y;
				vertextData[c++] = z;
				vertextData[c++] = r;
				vertextData[c++] = g;
				vertextData[c++] = b;
				
				v2 = v++;
				vertextData[c++] = quad.x + quad.width;
				vertextData[c++] = quad.y;
				vertextData[c++] = z;
				vertextData[c++] = r;
				vertextData[c++] = g;
				vertextData[c++] = b;
				
				v3 = v++;
				vertextData[c++] = quad.x + quad.width;
				vertextData[c++] = quad.y + quad.height;
				vertextData[c++] = z;
				vertextData[c++] = r;
				vertextData[c++] = g;
				vertextData[c++] = b;
				
				indexData[n++] = v0;
				indexData[n++] = v1;
				indexData[n++] = v2;
				indexData[n++] = v0;
				indexData[n++] = v2;
				indexData[n++] = v3;
				
			}
			
			_vectextBuffer = _context3D.createVertexBuffer(quadNum*4,6);
			_indexBuffer = _context3D.createIndexBuffer(quadNum*6);
			
			_vectextBuffer.uploadFromVector(vertextData,0,quadNum*4);
			_indexBuffer.uploadFromVector(indexData,0,indexData.length);
			
			_context3D.setVertexBufferAt( 0, _vectextBuffer, 0, Context3DVertexBufferFormat.FLOAT_3 );   // attribute #0 will contain the position information
			_context3D.setVertexBufferAt( 1, _vectextBuffer, 3, Context3DVertexBufferFormat.FLOAT_3 );    
		}
		
		public function setProgram():void{
			var pm:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			pm.perspectiveFieldOfViewLH(1,1,1,10000);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,pm,true);
			
			
			var vertexSrc:String = "m44 op,va0,vc0 \n" +//"mov op,va0 1\n" +
									"mov v0,va1";
			var fragmentSrc:String = "mov oc,v0";
			
			var vectexAssember:AGALMiniAssembler = new AGALMiniAssembler();
			var fragmentAssember:AGALMiniAssembler = new AGALMiniAssembler();
			vectexAssember.assemble(Context3DProgramType.VERTEX,vertexSrc);
			fragmentAssember.assemble(Context3DProgramType.FRAGMENT,fragmentSrc);
			
			var program3d:Program3D = _context3D.createProgram();
			program3d.upload(vectexAssember.agalcode, fragmentAssember.agalcode);
			_context3D.setProgram(program3d);
		}
		
		public function render():void{
			_context3D.clear();
			_context3D.drawTriangles(_indexBuffer);
			_context3D.present();
		}
	}
}