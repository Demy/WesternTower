package component {
	import flash.utils.setTimeout;
	import starling.animation.IAnimatable;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Demy
	 */
	public class GameCamera implements IAnimatable
	{
		static private const LONG_ANIMATION_LENGTH:int = 30;
		static private const QUICK_ANIMATION_LENGTH:int = 15;
		
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		public var x:Number;
		public var y:Number;
		
		private var _scale:Number;
		private var object:DisplayObject;
		
		private var isMoving:Boolean;
		private var stepX:Number;
		private var stepY:Number;
		private var animationFrames:int;
		private var _gameField:DisplayObject;
		
		public function GameCamera(stageWidth:Number, stageHeight:Number) 
		{
			this.stageHeight = stageHeight;
			this.stageWidth = stageWidth;
			
			x = stageWidth * 0.5;
			y = stageHeight * 0.5;
			
			_scale = 0.4;
			
			isMoving = false;
		}
		
		public function set gameField(value:DisplayObject):void 
		{
			_gameField = value;
		}
		
		public function follow(object:DisplayObject, quickMovement:Boolean = false):void
		{
			if (this.object == object) return;
			this.object = object;
			
			isMoving = true;
			
			animationFrames = quickMovement ? QUICK_ANIMATION_LENGTH : LONG_ANIMATION_LENGTH;
		}
		
		public function get target():DisplayObject
		{
			return object;
		}
		
		public function advanceTime(time:Number):void 
		{
			if (_gameField)
			{
				_gameField.x = -x * _scale + stageWidth * _scale * 0.5 + 100;
				_gameField.y = -y * _scale + stageHeight * _scale * 0.5 + 100;
				_gameField.scaleX = _gameField.scaleY = _scale;
			}
			
			if (!object) return;
			if (isMoving) 
			{
				var dif:Number = object.x - x;
				stepX = Math.max(1, Math.abs(object.x - x) / animationFrames);
				stepY = Math.max(1, Math.abs(object.y - y) / animationFrames);
				x += dif > 0 ? 
					Math.min(stepX, dif) :
					Math.max( -stepX, dif); 
				dif = object.y - y;
				y += dif > 0 ? 
					Math.min(stepY, dif) :
					Math.max( -stepY, dif); 
					
				isMoving = (x == object.x && y == object.y) || --animationFrames > 0;
			}
			else
			{
				x = object.x;
				y = object.y;
			}
		}
		
		public function zoomIn():void 
		{
			_scale *= 1.1;
		}
		
		public function zoomOut():void 
		{
			_scale *= 0.9;
		}
		
		public function get scale():Number 
		{
			return _scale;
		}
		
	}

}