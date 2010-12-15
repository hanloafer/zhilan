package test
{
	import flash.display.Sprite;
	
	import pokergame.Group;
	import pokergame.Poker;
	import pokergame.PokerSign;
	import pokergame.event.GroupEvent;
	
	public class TestPokerGroup extends Sprite
	{
		
		public static const GROUP_DISTANCE:Number = 100;
		
		private var group1:Group;
		private var group2:Group;
		private var group3:Group;
		private var group4:Group;
		
		public function TestPokerGroup()
		{
			super();
			initTable();
			group1.addEventListener(GroupEvent.POKER_DRAG_END, onPokerDragEnd);
			group2.addEventListener(GroupEvent.POKER_DRAG_END, onPokerDragEnd);
			group3.addEventListener(GroupEvent.POKER_DRAG_END, onPokerDragEnd);
			group4.addEventListener(GroupEvent.POKER_DRAG_END, onPokerDragEnd);
		}
		
		private function onPokerDragEnd(e:GroupEvent):void{
			// step 1. get poker location
			
			// step 2. get poker's group location
			
			// step 3. get poker in table location
			
			// step 4. judge the poker's nearest group 
			var poker:Poker = e.poker ;
			var group:Group = e.target as Group;
			var nearestGroup:Group = getNearestGroupForDragedPoker(poker,group);
			group.removePoker(poker);
			nearestGroup.addPoker(poker);
			
		}
		
		private function getNearestGroupForDragedPoker(poker:Poker,group:Group):Group{
			
			//算出poker相对于桌子的x坐标
			var pokerToTableX:Number = poker.x +group.x;
			//判断离那个group最近
			if(pokerToTableX<(group2.x+group3.x)/2){
				if(pokerToTableX<(group1.x+group2.x)/2){
					trace("zuo1");
					return group1;
				}else{
					trace("zuo2");
					return group2;
				}
			}else{
				if(pokerToTableX<(group3.x+group4.x)/2){
					trace("zuo3");
					return group3;
				}else{
					trace("zuo4");
					return group4;
				}
			}
		}
		
		private function initTable():void{
			var poker1:Poker = new Poker(PokerSign.FANGKUAI, "8");
			
			var pokerlist:Array = [];
			for(var i:int=2; i<10; i++){
				pokerlist.push(new Poker(PokerSign.MEIHUA, String(i)));
			}
			
			group1 = new Group();
			group1.addPoker(poker1);
			group1.addPokers(pokerlist);
			group1.name = "D";
			addChild(group1);
			
			var pokerlist2:Array = [];
			for(var i:int=2; i<10; i++){
				pokerlist2.push(new Poker(PokerSign.HEITAO, String(i)));
			}
			
			group2 = new Group();
			group2.addPokers(pokerlist2);
			addChild(group2);
			group2.x = GROUP_DISTANCE;
			group2.name = "B";
			
			
			var pokerlist3:Array = [];
			for(var i:int=2; i<10; i++){
				pokerlist3.push(new Poker(PokerSign.FANGKUAI, String(i)));
			}
			
			group3 = new Group();
			group3.addPokers(pokerlist3);
			addChild(group3);
			group1.name = "C";
			group3.x = group2.x+GROUP_DISTANCE;
			
			
			var pokerlist4:Array = [];
			for(var i:int=2; i<10; i++){
				pokerlist4.push(new Poker(PokerSign.HONGTAO, String(i)));
			}
			
			group4 = new Group();
			group4.addPokers(pokerlist4);
			addChild(group4);
			group1.name = "A";
			group4.x = group3.x+GROUP_DISTANCE;
		}
	}
}