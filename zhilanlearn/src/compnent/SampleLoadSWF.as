package compnent
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;

	public class SampleLoadSWF extends Sprite
	{
		private const FILE_PATH:String = "F:\flash\flashziliao寒假\lanlan.swf";
		private const CLASS_NAME:String = "Ball";
		
		private var loader:Loader;
		private var request:URLRequest;
		
		public function SampleLoadSWF()
		{
			loader = new Loader();
			request = new URLRequest(FILE_PATH);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader.load(request);
		}
		
		private function onComplete(event:Event):void{
			var loadedSWF = event.target;
			var domain:ApplicationDomain = loadedSWF.ApplicationDomain as ApplicationDomain;
			var BallClass:Class = domain.getDefinition(CLASS_NAME)as Class;
			var ballA:MovieClip = (new BallClass())as MovieClip;
			var ballB:MovieClip = (new BallClass())as MovieClip;
			ballA.x = 0,ballA.y = 100;
			ballB.x = 100; ballB.y = 100;
			ballB.scaleX = 2;
			addChild(ballA);
			addChild(ballB);
		}
	}
}