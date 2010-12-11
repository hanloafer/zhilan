package pokergame
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PokerTable extends Sprite
	{
		private var _pokerAry:Array = [];
		private var dragedPoker:Poker;
		
		public function PokerTable()
		{
			super();
			var signAry:Array = ["A","B","C","D"];
			for(var j:int=0;j<signAry.length;j++){
				var valueAry:Array = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"];
				for(var i:int=0;i<valueAry.length;i++){
					var poker:Poker = new Poker(signAry[j], valueAry[i]);
					poker.x = j*100;
					poker.y = i*25;
					addChild(poker);
					pokerAry.push(poker);
				}
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListenerToPoker();
		}
		
		// 主意什么时候该加下划线,为什么要加下划线


		public function get pokerAry():Array{
			return _pokerAry;
		}
		
		public function set pokerAry(value:Array):void{
			this._pokerAry = value;
		}
		
		public function addEventListenerToPoker():void{
			for(var i:int=0;i<pokerAry.length;i++){
				Poker(pokerAry[i]).addEventListener(MouseEvent.MOUSE_DOWN,beginDrag);
				this.stage.addEventListener(MouseEvent.MOUSE_UP,endDrag);
			}
		}
		
		public function beginDrag(e:MouseEvent):void{
			//Poker(e.target).startDrag();
			//不建议这么写，有可能会报类型转换错误   
			var poker:Poker = e.target as Poker;
			if(poker != null){
				poker.startDrag(true);
				dragedPoker = poker;
				this.setChildIndex(dragedPoker,this.numChildren-1);
			}else{
				trace("[beginDrag 的目标不是poker]");
			}
			
//			上述写法等价于=>
//			if(e.target is Poker){
//				Poker(e.target).startDrag(true);
//			}else{
//				trace("[beginDrag 的目标不是poker]");
//			}
		}
		public function onDrag(e:MouseEvent):void{
			if(e.target is Poker){
				var pok:Poker = e.target as Poker;
				pok.x = 
			}else{
			    trace("[beginDrag 的目标不是poker]");
			}
		}
		
		public function endDrag(e:MouseEvent):void{
			if(dragedPoker != null ){
				dragedPoker.stopDrag();
				
			}else{
				trace("[endDrag 的目标不是poker]");
			}
		}
	}
}