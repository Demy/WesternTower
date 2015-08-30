package component.object 
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Demy
	 */
	public class Weapon extends GameObject 
	{
		private var _name:String;
		private var _damage:int;
		private var _range:Number;
		private var _accuracy:Number;
		private var _minLevel:int;
		private var _ammo:int;
		private var _cost:int;
		private var _reloadingTime:int;
		private var cooldown:int;
		private var ammoLeft:int;
		
		private var _view:DisplayObjectContainer;
		
		public function Weapon(name:String, price:int, minLevel:int, damage:int, range:Number, ammo:int, 
			accuracy:Number, reloadingTime:int) 
		{
			_name = name;
			_cost = price;
			_damage = damage;
			_range = range;
			_accuracy = accuracy;
			_minLevel = minLevel;
			_ammo = ammo;
			_reloadingTime = reloadingTime;
			cooldown = 0;
			ammoLeft = _ammo;
			
			//TODO: cooldown for each shot and realoading for the whole barrel
		}
		
		public function reload():void
		{
			if (reloading()) --cooldown;
		}
		
		private function draw():void 
		{
			_view = new Sprite();
			var image:Quad = new Quad(3, 7, 0x808080);
			image.x = -image.width * 0.5;
			image.y = -image.height;
			_view.addChild(image);
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get damage():int 
		{
			return _damage;
		}
		
		public function get range():Number 
		{
			return _range;
		}
		
		public function get accuracy():Number 
		{
			return _accuracy;
		}
		
		public function get minLevel():int 
		{
			return _minLevel;
		}
		
		public function get ammo():int 
		{
			return _ammo;
		}
		
		public function get cost():int 
		{
			return _cost;
		}
		
		public function get view():DisplayObject 
		{
			if (!_view) draw();
			return _view;
		}
		
		public function get reloadingTime():int 
		{
			return _reloadingTime;
		}
		
		public function reloading():Boolean
		{
			return (cooldown > 0);
		}
		
		public function shoot():void
		{
			if (--ammoLeft <= 0) 
			{
				cooldown = _reloadingTime;
				ammoLeft = _ammo;
			}
		}
		
		public function copy():Weapon
		{
			return new Weapon(_name, _cost, _minLevel, _damage, _range, _ammo, _accuracy, _reloadingTime);
		}
		
	}

}