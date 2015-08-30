package model 
{
	import component.object.Gunman;
	/**
	 * ...
	 * @author Demy
	 */
	public class GameSettings 
	{
		public var caravanLength:int;
		public var carriageHP:int;
		public var gunmanDamage:int;
		public var gunmanDelay:Number;
		public var gunmanRange:Number;
		public var gunmanAccuracy:Number;
		public var weaponAccuracy:Number;
		
		public var gunmen:Vector.<Gunman>;
		
		public var enemyCount:int;
		public var enemyHP:int;
		public var enemySpeed:Number;
		public var enemyDamage:int;
		public var enemyDelay:Number;
		public var enemyRange:Number;
		public var enemyMissChance:Number;
		public var enemyDodge:Number;
		
		public var simulationTime:Number;
		
		public function GameSettings() 
		{
			
		}
		
	}

}