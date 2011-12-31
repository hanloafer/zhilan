package
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.WhiteShadingBitmapMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Sphere;
	import away3d.primitives.Trident;
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	
	[SWF(width ="760",height="600",frameRate="24",backgroundColor ="0x0")]
	public class HelloAway extends Sprite
	{
		[Embed(source="img.jpg")]
		private static var imgClass:Class; 
		
		private var _view:View3D;
		
		private var cube:Cube;
		
		private var sphere : Sphere
		
		public function HelloAway()
		{
			super();
			var bmpImg:Bitmap = new imgClass();
			
			_view = new View3D({});
			_view.x = 100;
			_view.y = 300;
			addChild(_view);
			
			var camera:Camera3D = new Camera3D();
			camera.x = 0;
			camera.y = 0;
			camera.z = -100;
			_view.camera = camera;
			
			
			var trident:Trident = new Trident(300, true);
			_view.scene.addChild(trident);
			
			var bmp : BitmapData = new BitmapData(200,200);
			bmp.perlinNoise(200, 200, 2, Math.random(), true, true);
			var mat : BitmapMaterial = new WhiteShadingBitmapMaterial(bmpImg.bitmapData);
			cube= new Cube({ material: mat });
			_view.scene.addChild(cube);
			cube.x = 100;
			
			_view.addEventListener(Event.ENTER_FRAME, onFrame);
			
			sphere = new Sphere();
			sphere.segmentsW = 32;
			sphere.segmentsH = 32;
			sphere.material = new WhiteShadingBitmapMaterial(bmpImg.bitmapData);
			sphere.x = 200;
			sphere.y = 75;
			_view.scene.addChild(sphere);
			
			var light : PointLight3D = new PointLight3D();
			light.y = 500;
			_view.scene.addLight(light);
			
			cube.addEventListener(MouseEvent3D.MOUSE_UP, onClickCube);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onFrame(e:Event):void{
			_view.render();
//			cube.rotationX ++;
//			cube.rotationY ++;
			sphere.x += 0.1;
			sphere.rotationY ++;
			_view.scene.rotationX ++;
		}
		
		private function onClickCube(ev : MouseEvent3D) : void
		{
			TweenLite.to(ev.currentTarget, 2, {
				rotationX: Math.random()*360,
				rotationY: Math.random()*360,
				rotationZ: Math.random()*360 }
			);
		}
		
		private function onKeyDown(e:KeyboardEvent):void{
			switch(e.keyCode){
				case Keyboard.UP:
					_view.camera.z ++;
					break;
				case Keyboard.DOWN:
					_view.camera.z --;
					break;
				case Keyboard.LEFT:
					_view.camera.x --;
					break;
				case Keyboard.RIGHT:
					_view.camera.x ++;
					break;
			}
		}
	}
}