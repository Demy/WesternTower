package component 
{
	import component.object.Enemy;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import model.GameSettings;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Demy
	 */
	public class WaveSpawner extends EventDispatcher
	{
		public static var defaultEnemy:Enemy;
		private static var waves:Array = [
			{start: 2, enemyCount: 3},
			{start: 15, enemyCount: 3}
		];
		
		private var timer:Timer;
		private var nextSpawnAt:Number;
		private var currentWave:int;
		
		public function WaveSpawner() 
		{
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, tick);
			timer.start();
			
			nextSpawnAt = waves[0].start;
			currentWave = -1;
		}
		
		private function tick(e:TimerEvent):void 
		{
			if (timer.currentCount >= nextSpawnAt)
			{
				++currentWave;
				dispatchEvent(new Event(Event.CHANGE));
				
				if (waves.length > currentWave + 1) 
				{
					nextSpawnAt = waves[currentWave + 1].start;
				}
				else
				{
					clearTimer();
				}
			}
		}
		
		private function clearTimer():void 
		{
			timer.removeEventListener(TimerEvent.TIMER, tick);
			timer.stop();
		}
		
		public function getCurrentEnemies():Vector.<Enemy>
		{
			var result:Vector.<Enemy> = new Vector.<Enemy>(waves[currentWave].enemyCount);
			var i:int = waves[currentWave].enemyCount;
			while (i--)
			{
				result[i] = defaultEnemy.clone();
			}
			return result;
		}
		
		public static function setStandardEnemy(settings:GameSettings):void
		{
			defaultEnemy = new Enemy(
				"",
				settings.enemyHP, 
				settings.enemyDamage, 
				settings.enemyMissChance,
				settings.enemyDelay, 
				settings.enemyRange, 
				settings.enemyDodge,
				settings.enemySpeed,
				10
			);
		}
		
	}

}