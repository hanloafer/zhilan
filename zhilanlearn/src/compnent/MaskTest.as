package compnent
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class MaskTest extends Sprite
	{
		private var circleMask:Sprite;
		
		public function MaskTest()
		{
			initMask();
			//initRect();
			loadIMG();
		}
		
		public function initMask():void{
		 circleMask = new Sprite();
		 circleMask.graphics.beginFill(0xff6699,0);
		 circleMask.graphics.drawCircle(0,0,60);
		 circleMask.graphics.endFill();
		 circleMask.startDrag(true);
		 addChild(circleMask);
		}
		
		public function initRect():void{
			var rect:Sprite = new Sprite();
			rect.graphics.beginFill(0x669900);
			rect.graphics.drawRect(20,20,300,300);
			rect.graphics.endFill();
			addChild(rect);
			rect.mask = circleMask;
			
		}
		
		public function loadIMG():void{
			var loader:Loader = new Loader();
			var request:URLRequest = new URLRequest("D:fl/9.jpg");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaded);
			loader.load(request);
		}
		
		public function loaded(e:Event):void{
			var _bitmap:Bitmap = e.target.content as Bitmap;
			addChild(_bitmap);
			_bitmap.mask = circleMask;
		}
	}
}