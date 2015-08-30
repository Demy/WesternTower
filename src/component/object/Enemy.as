package component.object 
{
	import component.GameVehicle;
	import component.state.ApproachState;
	import component.state.IEnemyState;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import util.GameUtil;
	/**
	 * ...
	 * @author Demy
	 */
	public class Enemy extends MovingObject
	{
		private static const DEAFULT_TEXTURE:String = "tempEnemy2";
		
		public static const DEFAULT_SPEED:Number = 3;
		
		private static const SPEED_STEP:Number = Math.PI * 0.05;
		
		private var _damage:int;
		private var _range:Number;
		private var missChance:Number;
		private var delay:int;
		private var dodge:int;
		
		private var _state:IEnemyState;
		private var _reward:int;
		
		public function Enemy(name:String, hp:int, damage:int, missChance:Number, delay:int, range:Number, dodge:int,
			speed:Number, reward:int) 
		{
			super(hp, speed);
			_reward = reward;
			this.dodge = dodge;
			this.delay = delay;
			this.missChance = missChance;
			_range = range;
			_damage = damage;
			
			if (name == "") name = defaultName();
		}
		
		override public function update():void 
		{
			if (_state) _state.update();
			
			super.update();
		}
		
		override protected function getMiddleOffset():Number 
		{
			return 0.6;
		}
		
		override protected function getTextureName():String 
		{
			return DEAFULT_TEXTURE;
		}
		
		override protected function getDefaultSpeed():Number 
		{
			return DEFAULT_SPEED;
		}
		
		override protected function getSpeedAngleStep():Number 
		{
			return SPEED_STEP;
		}
		
		public function get damage():int 
		{
			return _damage;
		}
		
		public function get range():Number 
		{
			return _range;
		}
		
		public function get state():IEnemyState 
		{
			return _state;
		}
		
		public function set state(value:IEnemyState):void 
		{
			_state = value;
		}
		
		public function get reward():int 
		{
			return _reward;
		}
		
		private function defaultName():String 
		{
			return "Test Enemy" + String(GameUtil.random(100));
		}
		
		public function clone():Enemy
		{
			return new Enemy("", maxHp, _damage, missChance, delay, _range, dodge, speed, _reward);
		}
		
	}

}