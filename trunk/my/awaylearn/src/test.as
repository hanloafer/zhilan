package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	public class test extends Sprite
	{
		
		private var _dic:Dictionary;
		
		
		private var tf:TextField;
		
		private var s:TestSprite ;
		
		public function test()
		{
			_dic = new Dictionary(true);
			
			
//			_dic[s] = "@@@";
			tf = new TextField();
			tf.y = 200;
			addChild(tf);
			
//			setInterval(onFrame, 5000 );
			
			this.addEventListener(Event.ENTER_FRAME, onFrame);
			
//			for(var i:int=0; i<2; i++){
//				var loader:Loader = new Loader();
//				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e){
//					var k = i;
//					trace(k);
//				});
//				loader.load(new URLRequest("tt.swf"));
//			}
		}
		
		private var c:int=0;
		private function onFrame(e:*):void{
//			c++;
////			System.gc();
//			var str:String = c + "# ";
////			System.gc();
//			for(var k:* in _dic){
//				str += _dic[k] + k;
//				if(c == 3){
//					addChild(k);
//				}
//			}
//			tf.text = str;
			if(s == null){
				s = new TestSprite();
				addChild(s);
			}else{
				removeChild(s);
				s=null;
			}
		}
	}
}