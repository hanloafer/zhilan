package
	  {
	      import away3d.cameras.Camera3D;
	      import away3d.containers.ObjectContainer3D;
	      import away3d.containers.Scene3D;
	      import away3d.containers.View3D;
	      import away3d.core.utils.Cast;
	      import away3d.lights.DirectionalLight3D;
	      import away3d.materials.BitmapMaterial;
	      import away3d.materials.PhongBitmapMaterial;
	      import away3d.materials.TransformBitmapMaterial;
	      import away3d.primitives.Cube;
	      import away3d.primitives.Cylinder;
	      import away3d.primitives.Sphere;
	      import away3d.primitives.Torus;
	      
	      import flash.display.Sprite;
	      import flash.events.Event;
	      import flash.geom.Vector3D;
	      
	      [SWF(width="700",height="600",backgroundColor="#000000")]
	      public class textmapping extends Sprite
		      {
		          //声明变量
		          private var view:View3D;
		          private var cam:Camera3D;
		          private var sce:Scene3D;
		          
		          private var group:ObjectContainer3D;
		          private var sphere:Sphere;
		          private var cube:Cube;
		          private var centerCube:Cube;
		          private var torus:Torus;
		          private var cylinder:Cylinder;
		          private var light:DirectionalLight3D;
		          
		          private var earthMaterial:BitmapMaterial;
		          private var checkerMaterial:BitmapMaterial;
		          private var away3dMaterial:PhongBitmapMaterial;
		          private var tiledAway3dMaterial:TransformBitmapMaterial;
		          private var woodMaterial:BitmapMaterial;
		          
		          private static const ORBITAL_RADIUS:Number = 150;
		          //插入图片资源用于贴图（分类flex里用Embed标签、Cast.bitmap嵌入、使用图片资源，flash cs3如何嵌入看附录1）
		          [Embed(source="earth.jpg")] private var earthImage:Class;
		          [Embed(source="away3D.png")] private var away3dImage:Class;
		          [Embed(source="checker.jpg")] private var checkerImage:Class;
		          [Embed(source="wood.jpg")] private var woodImage:Class;
		          public function textmapping():void
		          {
			              //3D初始化 
			              init3D();
			              //创建场景  
			              createScene();
			              //添加侦听器-逐帧执行onEF(渲染并产生运动)
			              this.addEventListener(Event.ENTER_FRAME,onEF);
			          }
		          
		          private function init3D():void
		          {
			              //初始化摄像机
			              cam=new Camera3D({zoom:25, focus:30, x:-200, y:400, z:-400});
			              cam.lookAt(new Vector3D(0, 0, 0));
			              //初始化场景
			              sce=new Scene3D();
			              //初始化视口
			              view=new View3D({camera:cam,scene:sce,x:350,y:300});
			              addChild(view);                      
			          };
		          private function createScene():void
		          {
			              //生成位图材质(78行定义的away3dMaterial是phongBitmapMaterial类型，该类型需要光源)
			              earthMaterial=new BitmapMaterial(Cast.bitmap(new earthImage())); 
			              checkerMaterial=new BitmapMaterial(Cast.bitmap(new checkerImage()));
			              away3dMaterial=new PhongBitmapMaterial(Cast.bitmap(new away3dImage()),{smooth:true, precision:2});
			              tiledAway3dMaterial=new TransformBitmapMaterial(Cast.bitmap(new away3dImage()),{repeat:true, scaleX:.5, scaleY:.5});
			              woodMaterial=new BitmapMaterial(Cast.bitmap(new woodImage()));
			              
			              //添加光源（有了光源phongBitmapMaterial才能有光影效果，有光影效果会在下节讲到）
			              light=new DirectionalLight3D();
			              light.direction=new Vector3D(100,100,-200);
			              sce.addLight(light);
			              //新建容器并显示
			              group=new ObjectContainer3D();
			              sce.addChild(group);
			              //新建3D元素，并使用material属性为3D元素添加贴图材质
			              //新建3D元素-centerCube
			              centerCube=new Cube({material:away3dMaterial,width:75,height:75,depth:75});
			              group.addChild(centerCube);
			              //新建3d 元素 - sphere
			              sphere=new Sphere({radius:50,segmentsW:10,segmentsH:10,material:earthMaterial});
			              group.addChild(sphere);
			              sphere.x=ORBITAL_RADIUS;
			               //新建3d 元素 - totrus
			               torus=new Torus({radius:50,tube:20,segmentsT:8,segmentsR:16,material:checkerMaterial});
			               group.addChild(torus);
			               torus.x=-ORBITAL_RADIUS;
			                //新建3d 元素 - cylinder
			              cylinder=new Cylinder({radius:25,height:100,segmentsW:16,material:woodMaterial});
			              group.addChild(cylinder);
			              cylinder.z=ORBITAL_RADIUS;
			               //新建3d 元素 - totrus
			               cube=new Cube({width:75,height:75,depth:75,material:tiledAway3dMaterial});
			               group.addChild(cube);
			               cube.z=-ORBITAL_RADIUS;
			          };
		          private function onEF(e:Event):void
		          {
			               // 旋转3D物体
			              group.yaw(1);
			              
			              sphere.yaw(-4);
			              cube.yaw(-4);
			              cylinder.yaw(-4);
			              tworus.yaw(-4);
			              //一定要渲染哟
			              view.render();
			          };
		   
		      }
		  }