package model 
{
	import component.object.Weapon;
	/**
	 * ...
	 * @author Demy
	 */
	public class GunShop 
	{
		private static const STORE:Array = [
			new Weapon("Peacemaker", 0, 1, 1, 200, 0.6, 6, 3),
			new Weapon("S&W", 10, 2, 1, 200, 0.9, 6, 2),
			new Weapon("Remington", 20, 3, 1, 200, 0.9, 6, 1)
		];
		
		public function GunShop() 
		{
			
		}
		
		public static function getRandomAt(level:int):Weapon
		{
			var availableGuns:Array = getAvailableForLevel(level, true);
			if (availableGuns.length == 0) return null;
			var index:int = Math.round(Math.random() * (availableGuns.length - 1));
			return availableGuns[index].copy();
		}
		
		static private function getAvailableForLevel(level:int, addLower:Boolean):Array 
		{
			var availableGuns:Array = [];
			var i:int = STORE.length;
			var gun:Weapon;
			while (i--)
			{
				gun = STORE[i];
				if (gun.minLevel > level) continue;
				if (gun.minLevel < level && availableGuns.length > 0) continue;
				availableGuns.push(gun);
			}
			return availableGuns;
		}
		
		public static function findBetterWeaponByCost(level:int, weapon:Weapon, money:int):Weapon
		{
			var availableGuns:Array = getAvailableForLevel(level, true);
			var i:int = availableGuns.length;
			var gun:Weapon;
			while (i--)
			{
				gun = availableGuns[i];
				if (gun.minLevel > weapon.minLevel && gun.cost <= money)
				{
					return gun.copy();
				}
			}
			return null;
		}
		
	}

}