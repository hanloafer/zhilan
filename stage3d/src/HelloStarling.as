package  
{
	import flash.display.*;
	import flash.events.*;
	import starling.core.*;
	
	/**
	 * ...
	 * @author hanlu
	 */
	public class HelloStarling extends Sprite 
	{
		
		private var starling:starling.core.Starling;
		public function HelloStarling() 
		{
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, onadded);
		}
		
		private function onadded(e:*):void {
			starling = new starling.core.Starling(StarlingGame, stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			starling.antiAliasing = 1;
			starling.start();
		}
		
	}

}