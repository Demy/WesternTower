package component.object 
{
	import component.GameVehicle;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Demy
	 */
	public class MovingObject extends GameObject 
	{
		private static const TEXTURE_SCALE:Number = 0.25;
		
		protected var _hp:int;
		protected var _maxHp:Number;
		protected var speed:int;
		
		protected var _view:DisplayObject;
		protected var _vehicle:GameVehicle;
		
		protected var settedUp:Boolean;
		
		public function MovingObject(hp:int, speed:int) 
		{
			_hp = hp;
			_maxHp = hp;
			this.speed = speed;
			settedUp = false;
			
			init();
		}
		
		protected function init():void 
		{
			_view = createView();
			_vehicle = new GameVehicle();
			
			_vehicle.maxSpeed = speed;
		}
		
		protected function createView():Sprite 
		{
			var result:Sprite = new Sprite();
			var image:Image = new Image(Game.imageLoader.getTexture(getTextureName()));
			image.scaleX = image.scaleY = TEXTURE_SCALE;
			image.x = -image.width * getMiddleOffset();
			image.y = -image.height * 0.5;
			result.addChild(image);
			return result;
		}
		
		protected function getMiddleOffset():Number 
		{
			return 0.5;
		}
		
		protected function getTextureName():String 
		{
			return "";
		}
		
		public function update():void
		{
			_vehicle.update();
			
			_view.x = _vehicle.x;
			_view.y = _vehicle.y;
			
			if (!settedUp) 
			{
				_view.rotation = getNewAngle();
				settedUp = true;
			}
			else
			{
				adjustRotation(_view, _vehicle);
			}
		}
		
		protected function adjustRotation(view:DisplayObject, vehicle:GameVehicle):void 
		{
			const curRotation:Number = getNewAngle();
			if (_view.rotation != curRotation)
			{
				const step:Number = (_view.rotation > curRotation ? -1 : 1) * 
					(getSpeedAngleStep() * _vehicle.maxSpeed / getDefaultSpeed());
				_view.rotation = (_view.rotation > curRotation ? 
					Math.max(_view.rotation + step, curRotation) : 
					Math.min(_view.rotation + step, curRotation));
			}
		}
		
		protected function getDefaultSpeed():Number 
		{
			return 1;
		}
		
		protected function getSpeedAngleStep():Number 
		{
			return 1;
		}
		
		protected function getNewAngle():Number 
		{
			var nextAngle:Number = vehicle.rotation * Math.PI / 180;
			nextAngle = nextAngle % (Math.PI * 2); 
			nextAngle = getClosestAngle(view.rotation, nextAngle);
			return nextAngle;
		}
		
		protected function getClosestAngle(currentAngle:Number, nextAngle:Number):Number 
		{
			var positioveSuggest:Number = Math.PI * 2 + nextAngle;
			var negativeSuggest:Number = -Math.PI * 2 + nextAngle;
			if (Math.abs(positioveSuggest - currentAngle) < Math.abs(nextAngle - currentAngle))
			{
				nextAngle = positioveSuggest;
			}
			else if (Math.abs(negativeSuggest - currentAngle) < Math.abs(nextAngle - currentAngle))
			{
				nextAngle = negativeSuggest;
			}
			return nextAngle;
		}
		
		public function get hp():int 
		{
			return _hp;
		}
		
		public function get view():DisplayObject 
		{
			return _view;
		}
		
		public function get vehicle():GameVehicle 
		{
			return _vehicle;
		}
		
		public function get maxHp():Number 
		{
			return _maxHp;
		}
		
		public function set hp(value:int):void 
		{
			_hp = value;
		}
		
	}

}