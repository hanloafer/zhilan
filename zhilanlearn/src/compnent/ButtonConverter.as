package compnent
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 *  
	 * @author Administrator
	 * 
	 */	
	public class ButtonConverter
	{
		
		private var textField:TextField;
		private var cover:Sprite;
		private var background:Sprite;
		
		/**
		 *  
		 * @param textField		
		 * 
		 */		
		/**
		 * 
		 * @param textField		if parent is null, must have benn added in a DiaplayObjectContainer
		 * @param parent
		 * 
		 */		
		public function ButtonConverter(textField:TextField, parent:DisplayObjectContainer = null)
		{
			this.textField = textField;
			textField.mouseEnabled = false;
			
			background = new Sprite();
			background.graphics.beginFill(0xff0099, 1);
			background.graphics.lineStyle(1);
			background.graphics.drawRoundRect(0,0,textField.textWidth+2, textField.textHeight+2,5,5);
			background.graphics.endFill();
			
			cover = new Sprite();
			//cover.alpha = 0;
			cover.buttonMode = true;
			//			cover.width = textField.width;
			//			cover.height = textField.height;
			cover.graphics.beginFill(0xff0099, 0);
			cover.graphics.drawRect(0,0,textField.width, textField.height);
			cover.graphics.endFill();
			
			if(parent==null){
				parent = textField.parent;
				if(parent == null){
					throw new Error("找不到TextFiled的parent");
				}
			}
			//parent.addChild(background);
			parent.addChild(textField);
			parent.addChild(cover);
		}
		
	}
}