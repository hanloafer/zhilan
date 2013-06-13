package
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.events.Event;
	
	import d3.My3DEngine;
	
	import mys3.Image;
	import mys3.ImageRender;
	import mys3.Quad;
	import mys3.QuadRender;
	
	/**
	 * 
	 * @author Loafer
	 * 
	 */	
	[SWF(frameRate="30", width="1000", height="500")]
	public class mystage3d extends Sprite
	{
		[Embed (source="test.jpg")]
		private static var imgClass:Class;
		
		public function mystage3d()
		{
//			t(0xff00ff00>>>8);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.stage.scaleMode = StageScaleMode.NO_SCALE;

		}
		
		private var _stage3d:Stage3D;
		
		private var _context3d:Context3D;
		
		private function t(a:int):void{
//			a = a&0xff;
			trace(a.toString(16));
		}
		
		private function onAdded(e:*):void{
			_stage3d = stage.stage3Ds[0];
			_stage3d.addEventListener(Event.CONTEXT3D_CREATE,  onStage3dCreate);
			_stage3d.requestContext3D();
		}
		
		private var qrender:QuadRender; 

		private var imageRender:ImageRender;
		
		private function onStage3dCreate(e:*):void{
			trace( "GPU设备类型：",this._stage3d.context3D.driverInfo );
			_context3d = _stage3d.context3D;
			_context3d.configureBackBuffer(stage.stageWidth, stage.stageHeight,2,true);
			_context3d.enableErrorChecking = true;
			
			new My3DEngine(this.stage, _context3d);
			
//			qrender = new QuadRender(_context3d);
//			qrender.setMatrix(stage.stageWidth, stage.stageHeight);
//			
//			createQuad(0,-0,0x80ff0000,qrender);
//			createQuad(30,0,0x8000ff00,qrender);
//			createQuad(100,200,0x800000ff,qrender);
//			
////			createQuad(490,0,qrender);
////			createQuad(0,230,qrender);
////			createQuad(980,0,qrender);
////			createQuad(0,230,qrender);
//////			createQuad(0,0.8,qrender);
//////			createQuad(-0.5,0,qrender);
//////			createQuad(0.5,0,qrender);
//////			createQuad(0,0.5,qrender);
//			
//			
//			qrender.rebuidBuffer();
//			qrender.setProgram();
			
			
//			imageRender = new ImageRender(_context3d);
//			imageRender.setMatrix(stage.stageWidth, stage.stageHeight);
//			createImage(0,0,imageRender);
//			imageRender.rebuidBuffer();
//			imageRender.setProgram();
//			this.addEventListener(Event.ENTER_FRAME, onFrame);
			
			
		}
		
		private function createQuad(x:Number, y:Number, color:uint,qrender:QuadRender):Quad{
			var quad:Quad = new Quad();
			quad.width = 100;
			quad.height =50;
			quad.x = x;
			quad.y = y;
			quad.color = color;
			quad.rotation = 45;
			quad.scaleX = 10;
			qrender.addQuad(quad);
			return quad;
		}
		
		private function createImage(x:Number, y:Number, qrender:ImageRender):void{
			var image:Image = new Image();
			image.x = 0;
			image.y = 0;
//			this.stage.addChild(new imgClass());
			image.bitmapData = new imgClass().bitmapData;
//			trace(image.bitmapData.width,image.bitmapData.height);
			qrender.addQuad(image);
		}
		
		private function onFrame(e:*):void{
			imageRender.render();
		}
	}
}