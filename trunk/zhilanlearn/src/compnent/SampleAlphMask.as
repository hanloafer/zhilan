package compnent
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.net.URLRequest;
	import flash.filters.BitmapFilterQuality;

	public class SampleAlphMask extends Sprite
	{
		private var _bitmap:Bitmap;
		private var _circleMask:Sprite;
		
		public function SampleAlphMask() 
		{
			initMask();
			startLoadImg();
		}
		
		private function loaded(e:Event):void{
			_bitmap = e.target.content as Bitmap;
			addChild(_bitmap);
			_bitmap.cacheAsBitmap = true;
			_bitmap.mask = _circleMask;
		}
		
		private function initMask():void{
			_circleMask = new Sprite();
			_circleMask.graphics.beginFill(0xff0000);
			_circleMask.graphics.drawCircle(60,60,60);
			_circleMask.graphics.endFill();
			_circleMask.filters = [new BlurFilter(20,20,BitmapFilterQuality.HIGH)];

			_circleMask.cacheAsBitmap = true;
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