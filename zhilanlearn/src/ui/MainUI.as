package ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class MainUI extends Sprite
	{
		private var shu:Shu;
		private var infortext:TextField;
		private var turnItem:MCText;
		private var putlevel:Mytext;
		private var dongArray:Array =new Array();
		private var level:int = 1;
		private var count:int = 0;
		private var wrong:int = 0;
		
		public function MainUI()
		{
			initInfor();
			initDong();
			initShu();
		}
		
		private var t:int = 1+1;
		
		public function initShu():void{
			t= Math.random()*dongArray.length;
			shu = new Shu();
			shu.x = dongArray[t].x;
			shu.y = dongArray[t].y;
			addChild(shu);
			shu.buttonMode = true;
			shu.addEventListener(MouseEvent.CLICK,move);
		}
		
		private function initDong():void{
			for(var i:int=0;i<Math.pow(level,2);i++){
				var dong:Dong = new Dong();
				dong.x = i%level*60;
				dong.y = Math.floor(i/level)*60+30;
				addChild(dong);
				dongArray.push(dong);
				dong.addEventListener(MouseEvent.CLICK,onDongClick);
			}
		}
		
		public function initInfor():void{
			infortext = new TextField();
			infortext.y = 0;
			infortext.width = 400;
			infortext.mouseEnabled = false;
			addChild(infortext);
			infortext.text = "第1关，正确0个，错误0个";
		}
		
		public function initLevel():void{
			putlevel = new Mytext();
			putlevel.x = 0;
			infortext.width = 400;
			addChild(infortext);
			infortext.text = "第1关，正确0个，错误0个";
		}
		public function keepMouseFront():void{
			this.setChildIndex(shu,numChildren-1);
		}
		
		public function move(e:MouseEvent):void{
			t= Math.random()*dongArray.length;
			shu.x = dongArray[t].x;
			shu.y = dongArray[t].y;
			count++;
			if(count>Math.pow(level,2)){
				level++;
				release();
				//showLevel();
				//var s:String = string(level);
				//infortext.replaceText(0,1,s);
				initDong();
				count = 0;
				wrong = 0;
			}
			keepMouseFront();
			updataInfo();
			trace(dongArray.length);
		}
		
		public function onDongClick(e:Event):void{
			wrong++;
			updataInfo();
		}
		
		public function updataInfo():void{
			//var s:int = Math.pow(level,2)+1-count;
			
			infortext.text = "当前第"+level+"关,"+"正确"+count+"个，"+"错误"+wrong+"个";
		}
		
		public function tiaoguan(lv:int):void{
			level = lv;
			count = 0;
			wrong = 0;
			release();
			initDong();
			t= Math.random()*dongArray.length;
			shu.x = dongArray[t].x;
			shu.y = dongArray[t].y;
			keepMouseFront();
		}
		
		public function release():void{
			for(var i:int=0;i<dongArray.length;i++){
				var dong:Dong = dongArray[i] as Dong;
				dong.removeEventListener(MouseEvent.CLICK,onDongClick);
				removeChild(dong);
			}
			dongArray = new Array();
		}
	}
}