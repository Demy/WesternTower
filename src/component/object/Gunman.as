package component.object 
{
	import flash.geom.Point;
	import model.GunShop;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import util.GameUtil;
	import component.Gunpowder;
	/**
	 * ...
	 * @author Demy
	 */
	public class Gunman extends GameObject 
	{
		static public const LEVEL_UP:String = "levelUp";
		
		private static const names:Array = ["Joe", "Jack", "Marty", "Bob", "Alex"];
		
		private static const EXP_IN_1_LVL:int = 100;
		
		private static const LEFT_POS_X:Number = -67;
		private static const RIGHT_POS_X:Number = -43;
		private static const VERTICAL_POS_DIF:Number = 15;
		
		private var _accuracy:Number;
		private var _name:String;
		private var _vehicleId:int;
		private var _position:uint;
		private var _view:DisplayObjectContainer;
		private var _weapon:Weapon;
		private var _level:int;
		private var _experience:int;
		private var _money:int;
		
		public function Gunman(name:String, level:int, experience:int, accuracy:Number, weapon:Weapon,
			money:int) 
		{
			_experience = experience;
			_level = level;
			_weapon = weapon;
			_name = name;
			_accuracy = accuracy;
			_money = money;
			
			draw();
			_view.addChild(_weapon.view);
		}
		
		public function moveTo(vehicleId:int, position:uint):void
		{
			_vehicleId = vehicleId;
			_position = position;
			drawForPosition(position);
		}
		
		private function drawForPosition(position:uint):DisplayObject
		{			
			const isTop:Boolean = (position == Carriage.TOP_LEFT_POSITION || 
				position == Carriage.TOP_RIGHT_POSITION);
			const isLeft:Boolean = (position == Carriage.TOP_LEFT_POSITION || 
				position == Carriage.BOTTOM_LEFT_POSITION);
			_view.x = (isLeft ? LEFT_POS_X : RIGHT_POS_X);
			_view.y = VERTICAL_POS_DIF * (isTop ? -1 : 1);
			return _view;
		}
		
		private function draw():void 
		{
			_view = new Sprite();
			var image:DisplayObject = new Quad(20, 10, 0xff0000);
			image.x = -image.width * 0.5;
			image.y = -image.height * 0.5;
			_view.addChild(image);
		}
		
		public function shoot(enemies:Vector.<Enemy>):Boolean
		{
			if (weapon.reloading()) 
			{
				_weapon.reload();
				return false;
			}
			
			var target:Enemy;
			var enemy:Enemy;
			var curDistance:Number = 0;
			var i:int = enemies.length;
			while (i--)
			{
				enemy = enemies[i];
				var enemyDistance:Number = getFakeDist(enemy, _view.parent);
					
				var isFirstDistance:Boolean = (curDistance == 0 && enemyDistance <= weapon.range * weapon.range);
				var isBetterDistance:Boolean = (curDistance && enemyDistance > curDistance && 
					enemyDistance <= weapon.range * weapon.range);
				var isReachable:Boolean = isEnemyReachable(enemy, _view.parent);
				
				if ((isFirstDistance || isBetterDistance) && isReachable) 
				{
					target = enemy;
					curDistance = enemyDistance;
				}
			}
			if (target && target.hp)
			{
				if (Math.random() <= (_accuracy + (_weapon.accuracy - 1)))
				{
					target.hp -= target.hp/*_weapon.damage*/;
					_weapon.shoot();
					Gunpowder.shoot(_view.parent.parent, _view.parent.x + _view.x, _view.parent.y + _view.y);
					if (target.hp <= 0) gainBounty(target);
				}
				return true;
			}
			return false;
		}
		
		private function gainBounty(target:Enemy):void 
		{
			experience += 200;
			money += target.reward;
		}
		
		private function isEnemyReachable(enemy:Enemy, parent:DisplayObject):Boolean
		{
			var enemyPosition:Point = new Point(enemy.view.x, enemy.view.y);
			enemyPosition = enemy.view.parent.localToGlobal(enemyPosition);
			enemyPosition = parent.globalToLocal(enemyPosition);
			
			var upgradePosition:Point = new Point(_view.x, _view.y);
			
			return isInShootingArea(upgradePosition, enemyPosition);
		}
		
		private function getFakeDist(enemy:Enemy, parent:DisplayObject):Number 
		{
			return (enemy.view.x - parent.x) * (enemy.view.x - parent.x) + 
				(enemy.view.y - parent.y) * (enemy.view.y - parent.y)
		}
		
		private function isInShootingArea(upgradePosition:Point, enemyPosition:Point):Boolean 
		{
			var result:Boolean = false;
			if (upgradePosition.x < 0 && upgradePosition.y > 0)
			{
				result = 
					( - (upgradePosition.y / upgradePosition.x) * enemyPosition.x + 
						upgradePosition.y - enemyPosition.x) > 0;
				result = result && 
					((upgradePosition.y / upgradePosition.x) * enemyPosition.x - 
						upgradePosition.y - enemyPosition.x) > 0;
			}
			else if (upgradePosition.x > 0 && upgradePosition.y > 0)
			{
				result = 
					( - (upgradePosition.y / upgradePosition.x) * enemyPosition.x + 
						upgradePosition.y + 2 * upgradePosition.x - enemyPosition.x) > 0;
				result = result && 
					((upgradePosition.y / upgradePosition.x) * enemyPosition.x - 
						upgradePosition.y + 2 * upgradePosition.x - enemyPosition.x) > 0;
			}
			else if (upgradePosition.x < 0 && upgradePosition.y < 0)
			{
				result = 
					( - (upgradePosition.y / upgradePosition.x) * enemyPosition.x + 
						upgradePosition.y - enemyPosition.x) < 0;
				result = result && 
					((upgradePosition.y / upgradePosition.x) * enemyPosition.x - 
						upgradePosition.y - enemyPosition.x) < 0;
			}
			else
			{
				result = 
					( - (upgradePosition.y / upgradePosition.x) * enemyPosition.x + 
						upgradePosition.y + 2 * upgradePosition.x - enemyPosition.x) < 0;
				result = result && 
					((upgradePosition.y / upgradePosition.x) * enemyPosition.x - 
						upgradePosition.y + 2 * upgradePosition.x - enemyPosition.x) < 0;
			}
			return result;
		}
		
		public static function randomName():String
		{
			return names[GameUtil.random(names.length)];
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get vehicleId():int 
		{
			return _vehicleId;
		}
		
		public function get position():uint 
		{
			return _position;
		}
		
		public function get accuracy():Number 
		{
			return _accuracy;
		}
		
		public function get view():DisplayObject 
		{
			return _view;
		}
		
		public function get weapon():Weapon 
		{
			return _weapon;
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function get experience():int 
		{
			return _experience;
		}
		
		public function set experience(value:int):void 
		{
			_experience = value;
			
			if (_experience >= EXP_IN_1_LVL * _level) 
			{
				++_level;
				_experience %= EXP_IN_1_LVL * _level;
				levelUp();
			}
		}
		
		public function get money():int 
		{
			return _money;
		}
		
		public function set money(value:int):void 
		{
			_money = value;
			spendMoney();
		}
		
		private function levelUp():void 
		{
			spendMoney();
			
			dispatchEventWith(LEVEL_UP);
		}
		
		private function spendMoney():void 
		{
			var weaponToBuy:Weapon = GunShop.findBetterWeaponByCost(_level, _weapon, _money);
			if (weaponToBuy)
			{
				_view.removeChild(_weapon.view);
				_money -= weaponToBuy.cost;
				_weapon = weaponToBuy;
				_view.addChild(_weapon.view);
			}
		}
		
	}

}