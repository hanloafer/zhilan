package
{
    import com.adobe.utils.AGALMiniAssembler;
     
    import flash.display.*;
    import flash.display.Sprite;
    import flash.display.Stage3D;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Program3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.events.Event;
     
    [SWF(frameRate="60")]
    public class HelloTexture extends Sprite
    {
        [Embed(source="1.png")]
        private var pic:Class;
         
        private var _stage3d:Stage3D;
        private var _context3d:Context3D;
         
        public function HelloTexture()
        {
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, added);
				
          
             
        }
		
		private function added(e:Event = null):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			  trace( stage.stage3Ds.length );
             
            this._stage3d = stage.stage3Ds[0];
            this._stage3d.addEventListener(Event.CONTEXT3D_CREATE,created);
            this._stage3d.requestContext3D();
			
		}
         
        private function created(evt:Event):void
        {
            trace( this._stage3d.context3D.driverInfo );
             
            this._context3d = this._stage3d.context3D;
            this._context3d.enableErrorChecking = true;
            this._context3d.configureBackBuffer( 300,300,1000,true );
             
            init();
        }
         
        private function init():void
        {
            //顶点数据
            var vb:Vector.<Number> = Vector.<Number>([
                0,0, 0,1,
                1,0, 1,1,
                1,1, 1,0,
                0,1, 0,0
            ]);
             
            vbs = this._context3d.createVertexBuffer( vb.length/4, 4 );
            vbs.uploadFromVector( vb,0, vb.length/4 );
             
            //顶点索引
            var ib:Vector.<uint> = Vector.<uint>([
                0,3,1,
                1,2,3
            ]);
             
            ibs = this._context3d.createIndexBuffer( ib.length );
            ibs.uploadFromVector( ib, 0, ib.length );
             
            //纹理
            tex = this._context3d.createTexture( 128,128, Context3DTextureFormat.BGRA,true);
            var bit:Bitmap = new pic();
            bit.x = 350;
			//bit.bitmapData.fillRect(bit.bitmapData.rect, 0xff00ff00);
            //this.addChild( bit );
            tex.uploadFromBitmapData( bit.bitmapData, 0 );
             
            //AGAL
            var vp:String = "mov op, va0\n" +
                "mov v0, va1";
             
            var vagal:AGALMiniAssembler = new AGALMiniAssembler();
            vagal.assemble( Context3DProgramType.VERTEX, vp );
             
            var fp:String = "tex ft0, v0, fs0 <2d,repeat,linear,nomip>\n" +
                "mov oc,ft0";
             
            var fagal:AGALMiniAssembler = new AGALMiniAssembler();
            fagal.assemble( Context3DProgramType.FRAGMENT, fp );
             
            //shader
            pm = this._context3d.createProgram();
            pm.upload( vagal.agalcode, fagal.agalcode );
             
            this._context3d.setTextureAt( 0, this.tex );
            this._context3d.setProgram( pm );
            this._context3d.setVertexBufferAt(0,this.vbs,0, Context3DVertexBufferFormat.FLOAT_2 );
            this._context3d.setVertexBufferAt(1,this.vbs,2, Context3DVertexBufferFormat.FLOAT_2);
             
            this.addEventListener(Event.ENTER_FRAME, update);
             
        }
        private var pm:Program3D;
        private var vbs:VertexBuffer3D;
        private var ibs:IndexBuffer3D;
        private var tex:Texture;
         
        //循环渲染
        private function update(evt:Event):void
        {
            this._context3d.clear();
            this._context3d.drawTriangles( this.ibs );
            this._context3d.present();
        }
    }
}