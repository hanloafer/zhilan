package simmvc
{
	public class IView
	{
		public function IView()
		{
		}
		
		function get viewCotroller():IViewController;
		function set viewCotroller(value:IViewController):void;
	}
}