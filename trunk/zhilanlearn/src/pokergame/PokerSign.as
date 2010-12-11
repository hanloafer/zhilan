package pokergame
{
	import flash.display.Sprite;
	
	public class PokerSign extends Sprite
	{
		public static const HONGTAO:String = "A";
		public static const HEITAO:String = "B";
		public static const FANGKUAI:String = "C";
		public static const MEIHUA:String = "D";
		
		public function PokerSign(signName:String)
		{
			super();
			var sign:Sprite =  getSignImg(signName);
			addChild(sign);
		}
		
		private function getSignImg(sign:String):Sprite{
			switch(sign){
				case HONGTAO:
					return new HongTao();
					break;
				case HEITAO:
					return new HeiTao();
					break;
				case FANGKUAI:
					return new FangKuai();
					break;
				case MEIHUA:
					return new MeiHua();
					break;
			}
			return null;//!!!!!! why need return ????????
			
		}
	}
}