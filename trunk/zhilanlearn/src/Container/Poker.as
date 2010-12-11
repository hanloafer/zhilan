package Container
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * This is a Poker
	 * @author Administrator
	 * 
	 */	
	public class Poker extends Sprite
	{
		/**
		 * 
		 * @param sign		["A", "B", "C" "D"]
		 * @param value		["A",2,3,4,5,6,7,8,9,10,"J","Q","K"]
		 * 
		 */		
		
		public var sign:String;
		public var value:String;
		
		public function Poker(sign:String, value:String)
		{
			super();
			this.sign = sign;// !!!!!!!!!!!!!!!!!!!why add this ????????????????????????
			this.value = value;
			drawPoker();
			
		}
		
		private function drawPoker():void{
			this.drawBorder();
			drawValue();
			drawSign();
		}
		
		//画边框
		public function drawBorder():void{
			this.graphics.beginFill(0xffffff,1);
			graphics.lineStyle(1,0x000000);
			graphics.drawRoundRect(10,10,50,75,3,3);
			graphics.endFill();
		}
		
		
		// 画数值
		public function drawValue():void{
			var charShang:MovieClip = getValueTextField(); //charShang的类型写成sprite会报错  （报空类型错误）
			charShang.txt.text = this.value;
			charShang.x = 10;
			charShang.y = 9;
			charShang.scaleX = 0.2;
			charShang.scaleY = 0.2;
			addChild(charShang);
			
			var charXia:MovieClip = getValueTextField();
			charXia.txt.text = value;
			charXia.x = 59;
			charXia.y = 86;
			charXia.scaleX = 0.2;
			charXia.scaleY = 0.2;
			charXia.rotation = 180;
			addChild(charXia);
		}
		
		private function getValueTextField():MovieClip{
			if(sign == "A" || sign=="C"){
				return new TextAA();//hong
			}else{
				return new TextA();//hei
			}
		}
		
		private function drawSign():void{
			var shang:Sprite = getSignImg();// ?????why shang's type can not use MovieClip
			shang.x = 25;
			shang.y = 35;
			shang.scaleX = 0.105;
			shang.scaleY = 0.105;
			shang.rotation = 180;
			addChild(shang);
			
			var zhong:Sprite = getSignImg();
			zhong.x = 45;
			zhong.y = 55;
			zhong.scaleX = 0.15;
			zhong.scaleY = 0.15;
			zhong.rotation = 180;
			addChild(zhong);
			
			var xia:Sprite = getSignImg();
			xia.x = 45;
			xia.y = 60;
			xia.scaleX = 0.105;
			xia.scaleY = 0.105;
			addChild(xia);
		}
		
		// !!!!!!why can return sprite?????
		private function getSignImg():Sprite{
			switch(sign){
				case "A":
					return new HongTao();
					break;
				case "B":
					return new HeiTao();
					break;
				case "C":
					return new FangKuai();
					break;
				case "D":
					return new MeiHua();
					break;
			}
			return null;//!!!!!! why need return ????????
			
		}
		
		
	}
}