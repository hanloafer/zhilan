package pokergame
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import pokergame.event.GroupEvent;

	public class Group extends Sprite
	{
		public static const POKER_DISTANCE:Number = 30;
		
		private var pokers:Array = [];
		
		private var dragedPoker:Poker;
		public var groupName:String;
		
		public function Group()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function addPoker(poker:Poker):void{
			pokers.push(poker);
			addChild(poker);
			poker.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			poker.x = 0;
			poker.y = pokers.indexOf(poker) * POKER_DISTANCE;
			trace("pokers.indexOf(poker)");
			trace(pokers.indexOf(poker));
		}
		
		public function addPokers(pokerArray:Array):void{
			for(var i:int=0;i<pokerArray.length;i++){
				var poker:Poker = pokerArray[i] as Poker;
				if(poker != null){
					addPoker(poker);
				} else {
					throw new Error("要添加的pokerArray中的弟"+ i +"个元素不是Poker");
				}
			}
		}
		
		public function removePoker(poker:Poker):void{
			removeChild(poker);
			poker.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			pokers.splice(pokers.indexOf(poker),1);
		}
		
		public function removePokers(pokerArray:Array):void{
			for each(var poker:Poker in pokerArray){
				removePoker(poker);
			}
		}
		
		
		//private static var isRegisterStageOnMouseUp:Boolean = false;
		
		private function onAddedToStage(e:Event):void{
			//if(!isRegisterStageOnMouseUp){
				this.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			//	isRegisterStageOnMouseUp = true;
			//}
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		/** poker的初始点(0,0)与鼠标的位置差向量		 */		
		private var pokerToMouseVector:Point;
		
		public function onMouseDown(e:MouseEvent):void{
			if(e.target is Poker){
				var pok:Poker = e.target as Poker;
				dragedPoker = pok;
				beginDrag();
				
				// 记录鼠标与poker之间的位置差，
				// 以保证在今后的mouseMove中使鼠标与poker的位置差不变
				// localX localY鼠标相对targe的x y。
				pokerToMouseVector = new Point(e.localX, e.localY);
				// 等价于 
				// pokerToMouseVector = new Point(pok.mouseX, pok.mouseY);
			}else{
				trace("e.targe is not a Poker!");
			}
		}
		
		public function onMouseUp(e:MouseEvent):void{
			if(dragedPoker != null){
				endDrag();
				
			}
		}
		
		public function beginDrag(e:MouseEvent=null):void{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, movePoker);
			trace("beginDrag");
		}
		
		public function endDrag():void{
			trace("endDrag");
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, movePoker);
			
			var groupEvent:GroupEvent = new GroupEvent(GroupEvent.POKER_DRAG_END);
			groupEvent.poker = dragedPoker;
			this.dispatchEvent(groupEvent);
			dragedPoker = null;
		}
		
		
		/**
		 * 想达到这样一个目标：
		 * 让我们的poker一直和mouseDown后鼠标和poker的相对位置不变
		 * 
		 * @param e
		 * 
		 */
		public function movePoker(e:MouseEvent):void{
			//同步鼠标和poker的位置差
			dragedPoker.x = this.mouseX - pokerToMouseVector.x;
			dragedPoker.y = this.mouseY - pokerToMouseVector.y;
			var pok:Poker = e.target as Poker;
			var pokerInGroup:Group = pok.parent;
			var numPokerInGroup:int = pokerInGroup.numChildren;
			var indexOfPoker:int = pokerInGroup.getChildIndex(pok);
			if(indexOfPoker<numPokerInGroup-1){
				for(var i:int=indexOfPoker;i<numPokerInGroup-1;i++){
					var nextPoker:Poker = PokerInGroup.getChildAt(i);
					var j:int = 1;
					nextPoker.x = dragedPoker.x;
					nextPoker.y = dragedPoker.y *j;
					j++;
				}
			}
			
			//trace(e.localX+", "+e.localY + "|" + dragedPoker.x +", " + dragedPoker.y);
		}
	}
}