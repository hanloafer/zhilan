package test
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	
	import psw2d.Quad;
	import psw2d.QuadRender;
	
	public class QuadTest extends Sprite
	{
		private var stage3D:Stage3D;
		private var context3D:Context3D;
		private var qRender:QuadRender;
		
		public function QuadTest()
		{
			stage?onAddToStage(null):
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE,onContext3DCreated);
			stage3D.requestContext3D();
		}
		private var q:Quad;
		private var q2:Quad;
		private function onContext3DCreated(e:Event):void
		{
			context3D = stage3D.context3D;
			//关闭深度测试,，如果想要开启，必须调用setDepthTest接口来开启alpha混合
			context3D.configureBackBuffer(stage.stageWidth,stage.stageHeight,2,false);
			qRender = new QuadRender(context3D);
			q = new Quad(100,100,0x7FFF0000);
			q.x = 100;
			q.y = 100;
			qRender.addQuad(q);
			q2 = new Quad(100,100,0x7F00FF00);
			q2.x = 100;
			q2.y = 100;
			qRender.addQuad(q2);
			qRender.setMatrix(stage.stageWidth,stage.stageHeight);
			qRender.setProgram();
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		private function onEnterFrame(e:Event):void
		{
			q.x++;
			q2.x+=0.5;
			qRender.render();
		}
	}
}