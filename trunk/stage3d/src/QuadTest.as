package 
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
         
         private function onContext3DCreated(e:Event):void
         {
             context3D = stage3D.context3D;
             context3D.configureBackBuffer(stage.stageWidth,stage.stageHeight,2,true);
             qRender = new QuadRender(context3D);
             var q:Quad = new Quad(0.1,0.1,0xFF0000);
             q.x = 0;
             q.y = 0;
             qRender.addQuad(q);
             qRender.setMatrix();
             qRender.setProgram();
             addEventListener(Event.ENTER_FRAME,onEnterFrame);
         }
         
         private function onEnterFrame(e:Event):void
         {
             qRender.render();
         }
     }
 }