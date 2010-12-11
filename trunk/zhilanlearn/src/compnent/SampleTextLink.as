package compnent
{
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;

	public class SampleTextLink extends Sprite
	{
		private var txt:TextField;
		
		public function SampleTextLink()
		{
			txt = new TextField();
			txt.width = 300;
			txt.wordWrap = true;
			addChild(txt);
			txt.htmlText = 
				"单击<u><a href='event:geturl|http://www.kingda.org|_blank'>这儿</a></u>在"+
				"新窗口打开一个到www.kingda.org链接。</br>"+
				"单击<u><a href='event:load|someswf.swf'>这儿</a></u>则是在Flash中加载一个动画。</br>"+
				"单击<u><a href='event:move|10'>这儿</a></u>则是将文本框移动十个像素。"
			txt.addEventListener(TextEvent.LINK,clickLink);	
		}
		
		public function clickLink(evt:TextEvent):void{
			trace(evt.text);
			var cmdArray:Array = evt.text.split("|");
			switch(cmdArray[0]){
				case "geturl":
					geturl(cmdArray[1],cmdArray[2]);
					break;
				case "load":
					loadswf(cmdArray[1]);
					break;
				case "move":
					movetxt(cmdArray[1]);
					break;
				default:
					trace(cmdArray);
			}
		}
		
		private function geturl(url:String,target:String):void{
			var tmpRequest:URLRequest = new URLRequest(url);
			navigateToURL(tmpRequest,target);
			trace("1:"+url,"2:"+target);
		}
		
		private function loadswf(url:String):void{
			trace("load a swf from:"+url);
		}
		
		private function movetxt(distance:Number):void{
			txt.x += distance;
		}
	}
}