package psw2d
 {
     import com.adobe.utils.AGALMiniAssembler;
     import com.adobe.utils.PerspectiveMatrix3D;
     
     import flash.display3D.Context3D;
     import flash.display3D.Context3DProgramType;
     import flash.display3D.Context3DVertexBufferFormat;
     import flash.display3D.IndexBuffer3D;
     import flash.display3D.Program3D;
     import flash.display3D.VertexBuffer3D;
 
     public class QuadRender
     {
         private var _context3D:Context3D;
         private var _quads:Vector.<Quad>;
         
         private var _vertexBuffer:VertexBuffer3D;
         private var _indexBuffer:IndexBuffer3D;
         
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
             var x0:Number,y0:Number;
             var x1:Number,y1:Number;
             var x2:Number,y2:Number;
             var x3:Number,y3:Number;
             var z:Number=1;
             var color:uint;
             var r:uint;
             var g:uint;
             var b:uint;
             for(var i:int=0;i<numQuads;++i)
             {
                 x0 = _quads[i].x;
                 y0 = _quads[i].y + _quads[i].height;
                 x1 = _quads[i].x;
                 y1 = _quads[i].y;
                 x2 = _quads[i].x + _quads[i].width;
                 y2 = _quads[i].y;
                 x3 = _quads[i].x + _quads[i].width;
                 y3 = _quads[i].y + _quads[i].height;
                 color = _quads[i].color;
                 r = (color&0xFF0000)>>16;
                 g = (color&0x00FF00)>>8;
                 b = (color&0x0000FF);
                 r/=0xFF;
                 g/=0xFF;
                 b/=0xFF;
                 vertexData.push(
                     x0,y0,z,r,g,b,
                     x1,y1,z,r,g,b,
                     x2,y2,z,r,g,b,
                     x3,y3,z,r,g,b);
                 indexData.push(i*4+0,i*4+1,i*4+2,i*4+0,i*4+2,i*4+3);
                 75             }
             _vertexBuffer = _context3D.createVertexBuffer(numQuads * 4,6);
             _indexBuffer = _context3D.createIndexBuffer(numQuads * 6);
             
             _vertexBuffer.uploadFromVector(vertexData,0,numQuads * 4);
             _indexBuffer.uploadFromVector(indexData,0,indexData.length);
             
             _context3D.setVertexBufferAt(0,_vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
             _context3D.setVertexBufferAt(1,_vertexBuffer,3,Context3DVertexBufferFormat.FLOAT_3);
         }
         
         public function setMatrix():void
         {
             var pm:PerspectiveMatrix3D = new PerspectiveMatrix3D();
             pm.perspectiveFieldOfViewLH(1,1,1,10000);
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
             _context3D.setProgram(program);
         }
         
         public function render():void
         {
             _context3D.clear();
             _context3D.drawTriangles(_indexBuffer);
             _context3D.present();
         }
     }
 }