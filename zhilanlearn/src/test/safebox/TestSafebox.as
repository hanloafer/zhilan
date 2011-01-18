package test.safebox
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class TestSafebox extends Sprite
	{
		
		public function TestSafebox()
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplet);
			loader.load(new URLRequest("http://hdn.xnimg.cn/photos/hdn411/20090215/15/45/tiny_Ua1M_40932b204237.jpg"));
			addChild(loader);
		}
		
		private function onComplet(e:Event):void{
			trace("complet");
			var bmpData:BitmapData = new BitmapData(60, 60,true,0);
			bmpData.draw(this);
			/*var bmp:Bitmap = e.target.content as Bitmap;
			addChild(bmp);*/
		}
	}
}