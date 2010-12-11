package pokergame
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.hamcrest.mxml.collection.InArray;

	public class PuKe extends Sprite
	{
		private var _sprite:Sprite;
		
		
		public function PuKe()
		{
			var ary:Array = ["A",2,3,4,5,6,7,8,9,10,"J","Q","K"];
			for(var j:int=0;j<ary.length;j++){
				initSprite(j);
				_sprite.x = 0;
				var s:String = String(ary[j]);
				initHeiChar(s);
				initHeiTao();
				_sprite.addEventListener(MouseEvent.MOUSE_DOWN,beginDrag);
				_sprite.addEventListener(MouseEvent.MOUSE_UP,endDrag);
			}
			
			for(var j:int=0;j<ary.length;j++){
				initSprite(j);
				_sprite.x = 120;
				var s:String = String(ary[j]);
				initChar(s);
				initHongTao();
			}
			
			for(var j:int=0;j<ary.length;j++){
				initSprite(j);
				_sprite.x = 240;
				var s:String = String(ary[j]);
				initHeiChar(s);
				initMeiHua();
			}
			
			for(var j:int=0;j<ary.length;j++){
				initSprite(j);
				_sprite.x = 360;
				var s:String = String(ary[j]);
				initChar(s);
				initFangKuai();
			}
		}
		
		
		public function beginDrag(e:MouseEvent):void{
			_sprite.startDrag(true);
		}
		
		public function endDrag(e:MouseEvent):void{
			_sprite.stopDrag();
			
		}
		
		public function initSprite(j:int):void{
			_sprite = new Sprite();
			_sprite.x = 0;
			_sprite.y = j*45;
			_sprite.graphics.beginFill(0xffffff,1);
			_sprite.graphics.lineStyle(1,0x000000);
			_sprite.graphics.drawRoundRect(10,10,100,160,2,2);
			_sprite.graphics.endFill();
			addChild(_sprite);
		}
	
		public function initHeiChar(s:String=null):void{
			var charShang:TextA = new TextA();
			charShang.x = 9;
			charShang.y = 9;
			charShang.scaleX = 0.43;
			charShang.scaleY = 0.43;
			charShang.txt.text = s;
			_sprite.addChild(charShang);
			
			var charXia:TextA = new TextA();
			charXia.txt.text = s;
			charXia.x = 111;
			charXia.y = 173;
			charXia.scaleX = 0.43;
			charXia.scaleY = 0.43;
			charXia.rotation = 180;
			_sprite.addChild(charXia);
			
		}
		
		public function initChar(s:String=null):void{
			var charShang:TextAA = new TextAA();
			charShang.x = 9;
			charShang.y = 9;
			charShang.scaleX = 0.43;
			charShang.scaleY = 0.43;
			charShang.txt.text = s;
			_sprite.addChild(charShang);
			
			var charXia:TextAA = new TextAA();
			charXia.txt.text = s;
			charXia.x = 111;
			charXia.y = 173;
			charXia.scaleX = 0.43;
			charXia.scaleY = 0.43;
			charXia.rotation = 180;
			_sprite.addChild(charXia);
			
		}
		//红桃
		public function initHongTao():void{
			var hongTaoShang:HongTao = new HongTao();
			hongTaoShang.x = 33;
			hongTaoShang.y = 60;
			hongTaoShang.scaleX = 0.18;
			hongTaoShang.scaleY = 0.18;
			hongTaoShang.rotation = 180;
			_sprite.addChild(hongTaoShang);
			
			var hongTaoZhong:HongTao = new HongTao();
			hongTaoZhong.x = 80;
			hongTaoZhong.y = 110;
			hongTaoZhong.scaleX = 0.36;
			hongTaoZhong.scaleY = 0.36;
			hongTaoZhong.rotation = 180;
			_sprite.addChild(hongTaoZhong);
			
			var hongTaoZhongXia:HongTao = new HongTao();
			hongTaoZhongXia.x = 87;
			hongTaoZhongXia.y = 125;
			hongTaoZhongXia.scaleX = 0.18;
			hongTaoZhongXia.scaleY = 0.18;
			_sprite.addChild(hongTaoZhongXia);
		}
		//黑桃
		public function initHeiTao():void{
			var heiTaoShang:HeiTao = new HeiTao();
			heiTaoShang.x = 33;
			heiTaoShang.y = 60;
			heiTaoShang.scaleX = 0.18;
			heiTaoShang.scaleY = 0.18;
			heiTaoShang.rotation = 180;
			_sprite.addChild(heiTaoShang);
			
			var heiTaoZhong:HeiTao = new HeiTao();
			heiTaoZhong.x = 80;
			heiTaoZhong.y = 110;
			heiTaoZhong.scaleX = 0.36;
			heiTaoZhong.scaleY = 0.36;
			heiTaoZhong.rotation = 180;
			_sprite.addChild(heiTaoZhong);
			
			var heiTaoXia:HeiTao = new HeiTao();
			heiTaoXia.x = 87;
			heiTaoXia.y = 125;
			heiTaoXia.scaleX = 0.18;
			heiTaoXia.scaleY = 0.18;
			_sprite.addChild(heiTaoXia);
		}
		
		//梅花
		public function initMeiHua():void{
			var heiTaoShang:MeiHua = new MeiHua();
			heiTaoShang.x = 33;
			heiTaoShang.y = 60;
			heiTaoShang.scaleX = 0.18;
			heiTaoShang.scaleY = 0.18;
			heiTaoShang.rotation = 180;
			_sprite.addChild(heiTaoShang);
			
			var heiTaoZhong:MeiHua = new MeiHua();
			heiTaoZhong.x = 80;
			heiTaoZhong.y = 110;
			heiTaoZhong.scaleX = 0.36;
			heiTaoZhong.scaleY = 0.36;
			heiTaoZhong.rotation = 180;
			_sprite.addChild(heiTaoZhong);
			
			var heiTaoXia:MeiHua = new MeiHua();
			heiTaoXia.x = 87;
			heiTaoXia.y = 125;
			heiTaoXia.scaleX = 0.18;
			heiTaoXia.scaleY = 0.18;
			_sprite.addChild(heiTaoXia);
		}
		//方块
		public function initFangKuai():void{
			var heiTaoShang:FangKuai = new FangKuai();
			heiTaoShang.x = 33;
			heiTaoShang.y = 60;
			heiTaoShang.scaleX = 0.18;
			heiTaoShang.scaleY = 0.18;
			heiTaoShang.rotation = 180;
			_sprite.addChild(heiTaoShang);
			
			var heiTaoZhong:FangKuai = new FangKuai();
			heiTaoZhong.x = 80;
			heiTaoZhong.y = 110;
			heiTaoZhong.scaleX = 0.36;
			heiTaoZhong.scaleY = 0.36;
			heiTaoZhong.rotation = 180;
			_sprite.addChild(heiTaoZhong);
			
			var heiTaoXia:FangKuai = new FangKuai();
			heiTaoXia.x = 87;
			heiTaoXia.y = 125;
			heiTaoXia.scaleX = 0.18;
			heiTaoXia.scaleY = 0.18;
			_sprite.addChild(heiTaoXia);
		}
		
	}
}