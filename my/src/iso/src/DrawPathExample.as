package{
	import flash.display.*;
	
	public class DrawPathExample extends Sprite {
		
		public function DrawPathExample(){
			
			var star_commands:Vector.<int> = new Vector.<int>(5, true);
			
			star_commands[0] = 1;
			star_commands[1] = 2;
			star_commands[2] = 2;
			star_commands[3] = 2;
			star_commands[4] = 2;
			
			var star_coord:Vector.<Number> = new Vector.<Number>(10, true);
			star_coord[0] = 66; //x
			star_coord[1] = 10; //y 
			star_coord[2] = 23; 
			star_coord[3] = 127; 
			star_coord[4] = 122; 
			star_coord[5] = 50; 
			star_coord[6] = 10; 
			star_coord[7] = 49; 
			star_coord[8] = 109; 
			star_coord[9] = 127;
			
			
			graphics.beginFill(0x003366);
			graphics.drawPath(star_commands, star_coord);
			
		}
		
	}
}
