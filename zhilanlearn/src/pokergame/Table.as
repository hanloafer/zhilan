package pokergame
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Table extends Sprite
	{
		private var groupOne:Sprite;
		private var groupTwo:Sprite;
		private var groupThree:Sprite;
		private var groupFrou:Sprite;
		
		private var pokerAry:Array = [];
		private var dragedPoker:Poker;
		
		public function Table()
		{
			initGroup();
			var signAry:Array = ["A","B","C","D"];
			for(var j:int=0;j<signAry.length;j++){
				var valueAry:Array = ["6","K","5","4","3","A","7","Q","8","10","2","J","9"];
				for(var i:int=0;i<valueAry.length;i++){
					var poker:Poker = new Poker(signAry[j], valueAry[i]);
					//poker.x = j*100;
					poker.y = i*25;
					switch(signAry[j]){
						case"A":
							groupOne.addChild(poker);trace(signAry[j]);break;
						case"B":
							groupTwo.addChild(poker);trace(signAry[j]);break;
						case"C":
							groupThree.addChild(poker);trace(signAry[j]);break;
						case"D":
							groupFrou.addChild(poker);trace(signAry[j]);break;
					}
					
					pokerAry.push(poker);
				}
			}
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function initGroup():void{
			groupOne = drawGroup();
			groupTwo = drawGroup();
			groupThree = drawGroup();
			groupFrou = drawGroup();
			
			groupTwo.x = 120;
			groupThree.x = 240;
			groupFrou.x = 360;
			
			addChild(groupOne);
			addChild(groupTwo);
			addChild(groupThree);
			addChild(groupFrou);
			
		}
		
		public function drawGroup():Sprite{
			var _sprite:Sprite = new Sprite();
			_sprite.graphics.beginFill(0x006699,1);
			_sprite.graphics.drawRoundRect(10,10,50,75,3,3);
			_sprite.graphics.endFill();
			addChild(_sprite);
			return _sprite;
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
				//this.setChildIndex(dragedPoker,this.numChildren-1);
				pokerToMouse = new Point(e.localX,e.localY);
			}else{
				trace("[beginDrag 的目标不是poker]");
			}
		}
		
		public function beginDrag():void{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,movePoker);
		}
		
		public function movePoker(e:MouseEvent):void{
			dragedPoker.x  = this.mouseX-pokerToMouse.x;
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
			if(this.mouseX){
			
			}else{
				if(this.mouseX<(groupTwo.x+groupOne.x)/2){
					dragedPoker.x = groupOne.x;
				}else{
					if(this.mouseX<(groupThree.x+groupFrou.x)/2){
						dragedPoker.x = groupFrou.x;
					}else{
						
					}
				}
			}
			
		}
		
		
	}
}