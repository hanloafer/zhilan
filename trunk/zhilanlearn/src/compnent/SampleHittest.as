package compnent
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SampleHittest extends Sprite
	{
		private var circle:Sprite;
		public function SampleHittest()
		{
			circle = new Sprite();
			circle.graphics.beginFill(0x669900);
			circle.graphics.drawCircle(0,0,10);
			circle.graphics.endFill();
			
			var rectA:RectSprite = new RectSprite();
			rectA.mouseChildren = false;
			rectA.x = 100;
			rectA.y = 50;
			//rectA.startDrag(true);
			
			var pointStar:CircleSprtie = new CircleSprtie();
			pointStar.x = 20;
			pointStar.y = 20;
			addChild(pointStar);
			addChild(rectA);
			addChild(circle);
			
			circle.startDrag(true); 
			rectA.addEventListener(Event.ENTER_FRAME,isHit);
			pointStar.addEventListener(Event.ENTER_FRAME,isHit);
			
			//pointStar.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver) 
		}
		
		private function onMouseOver(e:MouseEvent):void{
			trace("鼠标和 圆 发生碰撞");
		}
		
		public function isHit(e:Event):void{
			if(e.target is RectSprite){                
				if(circle.hitTestObject(e.target as RectSprite)){
					trace("this is rectA")
				}
			}else if(e.target is CircleSprtie){       
				if(circle.hitTestObject(e.target as CircleSprtie)){
					trace("this is pointStar")
				}
			}
		}
		
		public function isHitRect(e:Event):void{
			if(circle.hitTestObject(e.target as RectSprite)){       //计算circle显示对象，看它是否与evt.target相交或重叠
				trace("this is RectA");
			}
		}
		
		public function isHitCircle(evt:Event):void{
			if(circle.hitTestObject(evt.target as CircleSprtie)){       //计算circle显示对象，看它是否与evt.target相交或重叠
				trace("this is pointStar");
			}
		}
	}
}