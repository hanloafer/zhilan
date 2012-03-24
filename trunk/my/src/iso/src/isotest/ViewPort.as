package isotest
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ViewPort extends Sprite
	{
		public function ViewPort()
		{
			super();
			_container = new Sprite();
			addChild(_container);
			_itemContainer = new Sprite();
			_bgContainer = new Sprite();
			_container.addChild(_bgContainer);
			_container.addChild(_itemContainer);
			_container.x = 500;
			initBg();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			
		}
		
		private function onAdd(e:*):void{
			this.parent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
			this.parent.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		}
		
		public function get container():Sprite
		{
			return _container;
		}

		private function onMouseDown(e:Event):void{
			
			_container.startDrag();
			e.stopImmediatePropagation();
		}
		
		private function onMouseUp(e:*):void{
			e.stopImmediatePropagation();
			_container.stopDrag();
		}
		
		private var _container:Sprite;
		
		private var _itemContainer:Sprite;
		private var _bgContainer:Sprite;
		
		private function initBg():void{
			var grids:int = 20;
			grids++;
			var g:Graphics = _bgContainer.graphics;
			g.lineStyle(0.5, 0x00ff00);
			
			var i:int,j:int;
			var sx:Number,sy:Number,ex:Number, ey:Number;
			var sp:Point, ep:Point;
			sy = 0;
			ey = grids-1;
			for(i=0; i<grids; i++){
				sx = i;
				ex = i;
				sp = IsoMath.isoToScreen(new Point(sx, sy));
				ep = IsoMath.isoToScreen(new Point(ex, ey));
				g.moveTo(sp.x, sp.y);
				g.lineTo(ep.x, ep.y);
			}
			sx = 0;
			ex = grids-1;
			for(i=0; i<grids; i++){
				ey = i;
				sy = i;
				sp = IsoMath.isoToScreen(new Point(sx, sy));
				ep = IsoMath.isoToScreen(new Point(ex, ey));
				g.moveTo(sp.x, sp.y);
				g.lineTo(ep.x, ep.y);
			}
			
			g = this.graphics;
			g.beginFill(0x000000);
			g.drawRect(0,0, 2000, 2000);
			g.endFill();
			_bgContainer.cacheAsBitmap = true;
		}
		
		public function addItem(item:IsoItem):void{
			trace("fuck");
			var idx:int = _items.indexOf(item);
			if(idx != -1){
				return;
			}else{
				_items.push(item);
				_itemContainer.addChild(item);
				item.render();
			}
		}
		
		private var _items:Array = [];
		
		public function removeItem(item:IsoItem):void{
			var idx:int = _items.indexOf(item);
			if(idx == -1){
				return;
			}else{
				_items.splice(idx, 1);
				_itemContainer.removeChild(item);
			}
		}
		
		
		
	}
	
	
}