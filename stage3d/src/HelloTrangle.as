package  
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.*;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author hanlu
	 */
	public class HelloTrangle extends Sprite 
	{
		
		public function HelloTrangle() 
		{	
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.addEventListener(MouseEvent.CLICK, click_handler);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			trace("stage3D层数量：", stage.stage3Ds.length);
			if (stage.stage3Ds.length > 0)
			{
				this._stage3d = stage.stage3Ds[0];
				this._stage3d.addEventListener(Event.CONTEXT3D_CREATE, created_handler);
				this._stage3d.addEventListener(ErrorEvent.ERROR, created_error_handler);
				this._stage3d.requestContext3D(Context3DRenderMode.AUTO);
			}
		}
		
		private var _stage3d:Stage3D;
		private var _context3d:Context3D;
		
		private function created_error_handler(evt:ErrorEvent):void
		{
			trace("GPU启动失败或设备丢失!");
		}
		
		private function created_handler(evt:Event):void
		{
			trace("GPU设备类型：", this._stage3d.context3D.driverInfo);
			this._context3d = this._stage3d.context3D;
			this._context3d.configureBackBuffer(500, 500, 0, true);
			//   stage.addEventListener(MouseEvent.CLICK, click_handler );
			this.addTriangle();
			this.draw();
		}
		private var _vb:VertexBuffer3D;
		private var _ib:IndexBuffer3D;
		private var _pm:Program3D;
		
		private function addTriangle():void
		{
			//三角形顶点数据
			var triangleData:Vector.<Number> = Vector.<Number>([
				//  x, y, r, g, b
				-1, 1, 1, 0, 0, 
				1, 1, 0, 1, 0, 
				-1, -1, 0, 0, 1]);
			this._vb = this._context3d.createVertexBuffer(triangleData.length / 5, 5);
			this._vb.uploadFromVector(triangleData, 0, triangleData.length / 5);
			//三角形索引数据
			var indexData:Vector.<uint> = Vector.<uint>([0, 1, 2]);
			this._ib = this._context3d.createIndexBuffer(indexData.length);
			this._ib.uploadFromVector(indexData, 0, indexData.length);
			//AGAL
			var vagalcode:String = "mov op, va0\n" + "mov v0, va1";
			var vagal:AGALMiniAssembler = new AGALMiniAssembler();
			vagal.assemble(Context3DProgramType.VERTEX, vagalcode);
			var fagalcode:String = "mov oc, v0";
			var fagal:AGALMiniAssembler = new AGALMiniAssembler();
			fagal.assemble(Context3DProgramType.FRAGMENT, fagalcode);
			this._pm = this._context3d.createProgram();
			this._pm.upload(vagal.agalcode, fagal.agalcode);
		}
		
		private function draw():void
		{
			this._context3d.clear(0, 0, 0);
			this._context3d.setVertexBufferAt(0, this._vb, 0, Context3DVertexBufferFormat.FLOAT_2);
			this._context3d.setVertexBufferAt(1, this._vb, 2, Context3DVertexBufferFormat.FLOAT_3);
			this._context3d.setProgram(this._pm);
			this._context3d.drawTriangles(this._ib);
			this._context3d.present();
		}
		
		private function click_handler(evt:MouseEvent):void
		{
			//this._context3d.dispose();
			this._context3d.configureBackBuffer(500, 500, 0, true);
			trace("ok");
		}
		
	}

}