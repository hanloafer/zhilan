package compnent
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class circle extends Sprite
	{
		private var btmd:BitmapData = new BitmapData(100,100,true);
		private var bmp:Bitmap= new Bitmap(btmd, "auto", true);
		
		public function circle()
		{
			/*var i:int;
			var j:int;
			var t:int = Math.pow(i,2)+Math.pow(j,2);
			if(t<100){
				btmd.setPixel(i,j,0xffffff);
			}*/	
			for(var i=0;i<100;i++){
				for(var j=0;j<100;j++){
					if((i-50)*(i-50)+(j-50)*(j-50)<=2500){btmd.setPixel(i,j,0xFF0000)};
				}
			}
			addChild(bmp);
		}
	}
}