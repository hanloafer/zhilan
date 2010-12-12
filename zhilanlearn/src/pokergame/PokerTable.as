package pokergame
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PokerTable extends Sprite
	{
		private var pokerAry:Array = [];
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
		
		public function addEventListenerToPoker():void{
			for(var i:int=0;i<pokerAry.length;i++){
				Poker(pokerAry[i]).addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				this.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}
		}
		private var pokerToMouse:Point;
		
		public function onMouseDown(e:MouseEvent):void{
			var poker:Poker = e.target as Poker;
			if(poker != null){
				dragedPoker = poker;
				beginDrag();
				this.setChildIndex(dragedPoker,this.numChildren-1);
				pokerToMouse = new Point(e.localX,e.localY);
			}else{
				trace("[beginDrag 的目标不是poker]");
			}
		}
		
		public function beginDrag():void{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,movePoker);
		}
		
		public function movePoker(e:MouseEvent):void{
			dragedPoker.x = this.mouseX-pokerToMouse.x;
			dragedPoker.y = this.mouseY-pokerToMouse.y;
		}
		
		public function onMouseUp(e:MouseEvent):void{
			if(dragedPoker != null ){
				endDrag();
			}else{
				trace("[endDrag 的目标不是poker]");
			}
		}
		
		public function endDrag():void{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,movePoker);
		}
	}
}