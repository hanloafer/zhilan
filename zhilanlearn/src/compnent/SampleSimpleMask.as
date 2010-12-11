package compnent
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class SampleSimpleMask extends Sprite
	{
		private var _bitmap:Bitmap;
		private var _circleMask:Sprite;
		
		public function SampleSimpleMask()
		{
			initMask();
			startLoadImg();
		}
		
		private function loaded(evt:Event):void{
			_bitmap = evt.target.content as Bitmap;
			addChild(_bitmap);
			_bitmap.mask = _circleMask;
		}
		
		private function initMask():void{
			_circleMask = new Sprite();
			_circleMask.graphics.beginFill(0xff6600);
			_circleMask.graphics.drawCircle(60,60,60);
			_circleMask.graphics.endFill();
			addChild(_circleMask);
			_circleMask.startDrag(true);
		}
		
		private function startLoadImg():void{
			var loader:Loader = new Loader();
			var request:URLRequest = new URLRequest("D:fl/9.jpg");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaded);
			loader.load(request);
		}
	}
}