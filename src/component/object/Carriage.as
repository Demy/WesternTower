package component.object 
{
	import com.foed.Circle;
	import component.GameVehicle;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Demy
	 */
	public class Carriage extends MovingObject 
	{
		public static const TOP_LEFT_POSITION:uint = 0;
		public static const TOP_RIGHT_POSITION:uint = 1;
		public static const BOTTOM_LEFT_POSITION:uint = 2;
		public static const BOTTOM_RIGHT_POSITION:uint = 3;
		
		private static const DEAFULT_TEXTURE:String = "wagon";
		
		public static const DEFAULT_SPEED:Number = 2;
		
		private static const SPEED_STEP:Number = Math.PI * 0.008;
		
		public function Carriage(hp:int, speed:int) 
		{
			super(hp, speed);
		}
		
		override protected function getMiddleOffset():Number 
		{
			return 0.8;
		}
		
		override protected function getTextureName():String 
		{
			return DEAFULT_TEXTURE;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override protected function getDefaultSpeed():Number 
		{
			return DEFAULT_SPEED;
		}
		
		override protected function getSpeedAngleStep():Number 
		{
			return SPEED_STEP;
		}
		
	}

}