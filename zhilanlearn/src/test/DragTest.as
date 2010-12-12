package test
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import pokergame.Poker;
	import pokergame.PokerSign;

	public class DragTest extends Sprite
	{
		private var dragedPoker:Poker;
		private var pok:Poker;
		public function DragTest()
		{
			pok = new Poker(PokerSign.FANGKUAI,"7");
			addChild(pok);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
//		stage是每个地方都能监听到时间
//		sprite是有像素的地方才能监听到事件
		public function onAddedToStage(e:Event):void{
			pok.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
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
			if(dragedPoker is Poker){
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
			trace(e.localX+", "+e.localY + "|" + dragedPoker.x +", " + dragedPoker.y);
		}
		
		
		
	}
}