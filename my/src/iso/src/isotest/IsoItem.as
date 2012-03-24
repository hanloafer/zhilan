package isotest
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class IsoItem extends Sprite
	{
		
		private var _state:int = 0;
		
		private var _isoPos:Point = new Point();
		
		private var _rect:Point = new Point();
		
		public function IsoItem()
		{
			super();
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:*):void{
			if(_state == 0){
				startIsoDrag();
				_state = 1;
			}else if(_state == 1){
				stopIsoDrag();
				_state = 0;
			}
		}
		
		private var _startPt:Point;
		private var _startPos:Point;
		
		private function startIsoDrag():void{
			_startPt = IsoMath.screenToIso(new Point(this.parent.mouseX, this.parent.mouseY));
			_startPos = new Point(this._isoPos.x, this._isoPos.y);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.filters = [new GlowFilter(0xff0000, 1, 30)];
		}
		
		private function stopIsoDrag():void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.filters = [];
		}
		
		private function mouseMove(e:*):void{
			var _cpt:Point = IsoMath.screenToIso(new Point(this.parent.mouseX, this.parent.mouseY));
			var daltaPt:Point = new Point(int(_cpt.x - _startPt.x), int(_cpt.y - _startPt.y));
			this.isoPos = new Point(_startPos.x + daltaPt.x, _startPos.y + daltaPt.y);
		}
		
		
		public function get rect():Point
		{
			return _rect;
		}

		public function set rect(value:Point):void
		{
			_rect = value;
		}

		public function get isoPos():Point
		{
			return _isoPos;
		}

		public function set isoPos(value:Point):void
		{
			if(value.x != _isoPos.x || value.y != _isoPos.y){
				_isoPos.x = value.x;
				_isoPos.y = value.y;
				render();
			}
		}
		
		
		public function render():void{
			var spt:Point = IsoMath.isoToScreen(_isoPos);
			this.x = spt.x;
			this.y = spt.y;
		}

	}
}