package component 
{
	import com.foed.Vector2D;
	import component.object.Carriage;
	import component.object.Enemy;
	import component.object.Gunman;
	import component.object.MovingObject;
	import component.state.ApproachState;
	import starling.display.DisplayObjectContainer;
	import util.GameUtil;
	/**
	 * ...
	 * @author Demy
	 */
	public class GameScene 
	{
		private var road:Road;
		
		private var caravan:Vector.<Carriage>;
		private var gunmen:Vector.<Gunman>;
		
		private var wave:Vector.<Enemy>;
		
		public function GameScene(gunmen:Vector.<Gunman>) 
		{
			this.gunmen = gunmen;
			wave = new Vector.<Enemy>();
		}
		
		public function set field(value:Road):void 
		{
			road = value;
		}
		
		private function setGunmen():void 
		{
			var caravanSize:int = caravan.length;
			var freePositions:Array;
			var carriage:Carriage;
			var numTries:int = 0;
			var i:int = gunmen.length;
			while (i--)
			{
				numTries = 0;
				do 
				{
					numTries++;
					carriage = caravan[GameUtil.random(caravanSize)];
					freePositions = getFreeSpots(carriage.id);
				} 
				while (freePositions.length == 0 && numTries < 10)
				
				if (numTries >= 10) continue;
				
				var position:uint = freePositions[GameUtil.random(freePositions.length)];
				gunmen[i].moveTo(carriage.id, position);
				(carriage.view as DisplayObjectContainer).addChild(gunmen[i].view);
			}
		}
		
		private function getFreeSpots(carriageId:int):Array 
		{
			var freeSpots:Array = [Carriage.TOP_LEFT_POSITION, Carriage.TOP_RIGHT_POSITION,
				Carriage.BOTTOM_LEFT_POSITION, Carriage.BOTTOM_RIGHT_POSITION];
			var gunman:Gunman;
			var i:int = gunmen.length;
			while (i--)
			{
				gunman = gunmen[i];
				if (gunman.vehicleId == carriageId)
				{
					var spotIndex:int = freeSpots.indexOf(gunman.position);
					if (spotIndex < 0) continue;
					freeSpots.splice(spotIndex, 1);
				}
			}
			return freeSpots;
		}
		
		public function createCaravan(length:int, hp:int, speed:int):void
		{
			caravan = new Vector.<Carriage>(length);
			var firstPoint:Vector2D = road.getPath()[0];
			var carriage:Carriage;
			var size:int = length;
			for (var i:int = 0; i < size; i++)
			{
				carriage = new Carriage(hp, speed);
				road.add(carriage.view);
				if (firstPoint)
				{
					carriage.vehicle.x = firstPoint.x - i * carriage.view.width * 1.5;
					carriage.vehicle.y = firstPoint.y;
				}
				caravan[i] = carriage;
			}
			setGunmen();
		}
		
		public function addEnemies(enemies:Vector.<Enemy>):void
		{
			wave = wave.concat(enemies);
			
			var enemy:Enemy;
			var firstPoint:Vector2D = road.getTopPath()[0];
			var i:int = enemies.length;
			while (i--)
			{
				enemy = enemies[i];
				road.add(enemy.view);
				if (firstPoint)
				{
					enemy.vehicle.x = firstPoint.x + i * enemy.view.width * 1.5 + enemy.view.width * 2;
					enemy.vehicle.y = firstPoint.y;
					enemy.state = new ApproachState(enemy, road, caravan);
				}
			}
		}
		
		public function update():void
		{
			var gunman:Gunman;
			
			var i:int = gunmen.length;
			while (i--)
			{
				gunman = gunmen[i];
				gunman.shoot(wave);
			}
			
			var object:MovingObject;
			
			i = caravan.length;
			while (i--)
			{
				object = caravan[i];
				object.vehicle.followPath(road.getPath());
				object.update();
			}
			
			i = wave.length;
			while (i--)
			{
				object = wave[i];
				object.update();
			}
		}
		
	}

}