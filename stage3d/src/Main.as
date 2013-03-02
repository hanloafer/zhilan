package
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.*;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author hanlu
	 */
	public class Main extends Sprite
	{
		
		public function Main():void
		{
			addChild(new HelloTexture());
		}
		
		
	
	}

}