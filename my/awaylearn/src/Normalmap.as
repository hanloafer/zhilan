package
{
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.View3D;
	import away3d.core.utils.Cast;
	import away3d.events.MouseEvent3D;
	import away3d.events.Object3DEvent;
	import away3d.lights.DirectionalLight3D;
	import away3d.materials.Dot3BitmapMaterial;
	import away3d.materials.PhongBitmapMaterial;
	import away3d.primitives.Cube;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	[SWF(width ="760",height="600",frameRate="24",backgroundColor ="0xffffff")]
	public class Normalmap extends Sprite
	{
		[Embed(source="normalmap_thumb.png")]//normalmapImage
		private var mapImg:Class;
		[Embed(source="doodle_thumb.jpg")]//doodleImage
		private var texImg:Class;
		
		private var _view:View3D;
		
		
		  private var cam:HoverCamera3D;
		  private var cube:Cube;
		  private var doodle:Dot3BitmapMaterial;
		  private var originalmap:PhongBitmapMaterial;
		  private var light:DirectionalLight3D;
		  
		  private var mouseDown:Boolean;
		  private var lastMouseX:Number;
		  private var lastMouseY:Number;
		  private var lastPanangle:Number;
		  private var lastTiltangle:Number;
		  private var cameraSpeed:Number;
		
		public function Normalmap()
		{
			super();
			_view = new View3D();
			_view.x = 200;
			_view.y = 300;
			addChild(_view);
			
			//doodle=new Dot3BitmapMaterial(Cast.bitmap(new doodleImage()),Cast.bitmap(new normalmapImage()),{smooth:true, precision:6});
			
			var light:DirectionalLight3D = new DirectionalLight3D({brightness:1,ambient:0.25, diffuse:0.75, specular:0.9});
			light.direction = new Vector3D(500, 100, 5000);
//			light.=5000;
//			light.z=-50000;
//			light.y=1000;
			_view.scene.addLight(light);
			
			doodle=new Dot3BitmapMaterial(Cast.bitmap(new texImg()),Cast.bitmap(new mapImg()),{smooth:true, precision:6});
			
			cube=new Cube({width:600,height:300,depth:20,segmentsW:2,segmentsH:2});
			cube.cubeMaterials.front=doodle;
			
			originalmap=new PhongBitmapMaterial(Cast.bitmap(new texImg()));
			cube.cubeMaterials.back=originalmap;
			
			_view.scene.addChild(cube);
			
			this.addEventListener(Event.ENTER_FRAME, onFrame);
			
			cube.cubeMaterials.back=originalmap
				
			cube.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
		}
		
		private function onFrame(e:Event):void{
			_view.camera.x ++;
			_view.render();
//			cube.rotationX ++;
//			cube.rotationY ++;
//			cube.rotationZ ++;
			cube.z ++;
		}
		
		private function onMouseUp(e:MouseEvent3D):void{
			cube.rotationX +=10;
		}
	}
}