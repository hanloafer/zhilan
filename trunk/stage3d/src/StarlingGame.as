package
{
	import starling.display.*;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author hanlu
	 */
	public class StarlingGame extends Sprite
	{
		
		[Embed(source="1.png")]
        private var pic:Class;
		
		public function StarlingGame()
		{
			var q:Quad = new Quad(200, 200);
			q.setVertexColor(0, 0x000000);
			q.setVertexColor(1, 0xAA0000);
			q.setVertexColor(2, 0x00FF00);
			q.setVertexColor(3, 0x0000FF);
			addChild(q);
			
			q.x = 100;
			
			
			q.y = 200;
			
			
			
			var texture:Texture = Texture.fromBitmap(new pic());
			var img:Image = new Image(texture);
			addChild(img);
		}
	
	}

}