package compnent
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class MyRect extends Sprite
	{
		private var _lable:TextField;
		/**
		 * 
		 * @param lableName
		 * @param color
		 * 
		 */		
		public function MyRect(lableName:String,color:uint)
		{
			this.graphics.beginFill(color);
			this.graphics.lineStyle(2,0x85DB18);
			this.graphics.drawRoundRect(0,0,100,50,10,10);
			this.graphics.endFill();
			
			_lable = new TextField();
			_lable.htmlText = "<font size='24'><b>"+lableName+"</b></font>";
			_lable.autoSize = "left";
			//_lable.name = "ss";
			addChild(_lable);
		}
	}
}