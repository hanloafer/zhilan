package
{
	import flash.display.Sprite;
	import flash.utils.describeType;
	
	public class TestA extends Sprite
	{
		public function TestA()
		{
			super();
			var a:*= new Object();
			a.a = 3;
			trace(describeType(a));
			for(var k:* in a){
				trace(a[k]);
			}
		}
	}
}