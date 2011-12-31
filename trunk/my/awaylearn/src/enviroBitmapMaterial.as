package
	  {
	      import away3d.cameras.HoverCamera3D;
	      import away3d.containers.ObjectContainer3D;
	      import away3d.containers.View3D;
	      import away3d.core.utils.Cast;
	      import away3d.materials.BitmapMaterial;
	      import away3d.materials.EnviroBitmapMaterial;
	      import away3d.primitives.Plane;
	      import away3d.primitives.Sphere;
	      import away3d.primitives.Torus;
	      
	      import flash.display.Sprite;
	      import flash.events.Event;
	      import flash.events.MouseEvent;
	      import flash.geom.Vector3D;
	          
	      [SWF(width="600", height="500", frameRate="60", backgroundColor="#FFFFFF")]
	      public class enviroBitmapMaterial extends Sprite
	      {
	          //定义 变量
	          private var view:View3D;
	          private var cam:HoverCamera3D;
	          
	          private var planeMaterial:BitmapMaterial;
	          private var torusMaterial:EnviroBitmapMaterial;        
	          private var plane:Plane;
	          private var group:ObjectContainer3D;
	          private var torus:Torus;
	          
	          private var mouseDown:Boolean;
	          private var lastMouseX:Number;
	          private var lastMouseY:Number;
	          private var lastPanangle:Number;
	          private var lastTiltangle:Number;
	          private var cameraSpeed:Number;
	          
	          //嵌入图片,goldbackground.jpg用于背景及环境图；adobe_ico.jpg    是圆环的皮肤    
	          [Embed(source="goldbackground.jpg")] private var goldImage:Class;
	          [Embed(source="nooon.jpg")] private var skinImage:Class;
	          
	          public function enviroBitmapMaterial()
	          {
		              //新建各贴图材质，备用。
		              createMaterial();            
		              //inital 3D
		              init3D();
		              //create 3D Scene
		              createScene();
		              //addLsitener
		              addEventListener(Event.ENTER_FRAME,update);
		              stage.addEventListener(MouseEvent.MOUSE_DOWN,m_down_h);    
		              stage.addEventListener(MouseEvent.MOUSE_UP,m_up_h);
		                          
		          }
	          private function createMaterial():void
	          {
		              //背景的贴图材质为    BitmapMaterial        
		              planeMaterial=new BitmapMaterial(Cast.bitmap(new goldImage()),{smooth:true, precision:5});
		              //圆环要反射环境，用EnviroBitmapMaterial
		              //EnviroBitmapMaterial构造函数EnviroColorMaterial(color:*, enviroMap:BitmapData, init:Object = null)
		              //第二个参数必须是BitmapData，用于设置反射环境图，本例与背景平面用同一张图goldBackground
		              torusMaterial=new EnviroBitmapMaterial(Cast.bitmap(new skinImage()),Cast.bitmap(new goldImage()));
		              //设置EnviroBitmapMaterial的反射系数，数值为0～1,自行设定数值大小看看效果。
		              torusMaterial.reflectiveness = 0.4;
		              
		              //在这里顺便设置下后面要用到的一个参数cameraSpeed，这个参数影响：拖动鼠标是整个场景旋转速度。
		              cameraSpeed=.3;            
		          };
	          private function init3D():void
	          {
		              cam  = new HoverCamera3D({focus:300});                        
		              cam.lookAt( new Vector3D(0, 0, 0) );
		              cam.distance=900;
					  cam.panAngle=30;
		              cam.tiltAngle=15;
		              cam.minTiltAngle=5;
		   
		              view = new View3D({camera:cam,x:300,y:250});
		              addChild(view);
		          };
	          private function createScene():void
	          {
		              group=new ObjectContainer3D();
		              //创建背景平面                
		              plane=new Plane({material:planeMaterial,width:250,height:250,segmentsW:8,segmentsH:8});    
		              //创建圆环
		              //radius:圆环总半径；tube:环的圆管半径
		              //所使用的材质为 torusMaterial，它是EnviroBitmapMaterial        
		              torus= new Torus({material:torusMaterial,radius:30,tube:20,segmentsR:15,segmentsT:12});
		              torus.y=55;
		   
		              view.scene.addChild(group);
		              
		              group.addChild(plane);
		              group.addChild(torus);
		      };
	          private function update(e:Event):void
	          {
		              if(mouseDown)
			              { 
//				                  cam.targetpanangle=cameraSpeed*(stage.mouseX-lastMouseX)+lastPanangle;
//				                  cam.targettiltangle=cameraSpeed*(stage.mouseY-lastMouseY)+lastTiltangle;               
				              };
		              torus.yaw(-1);
		              torus.pitch(-1);
		              torus.roll(-1);
		              cam.hover();
		              view.render();
		             
		          };
	          private function m_down_h(e:MouseEvent):void
	          {
		            mouseDown=true;
		            lastMouseX=stage.mouseX;
		            lastMouseY=stage.mouseY;
//		            lastPanangle=cam.targetpanangle;
//		            lastTiltangle=cam.targettiltangle;
		          };
	          private function m_up_h(e:MouseEvent):void
	          {            
		              mouseDown=false;
		          };
		          
		      }
		  }