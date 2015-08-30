package component.state 
{
	import component.object.Carriage;
	import component.object.Enemy;
	import component.Road;
	/**
	 * ...
	 * @author Demy
	 */
	public class RoadCrossingState implements IEnemyState 
	{
		private var owner:Enemy;
		private var paths:Road;
		private var caravan:Vector.<Carriage>;
		private var tempPath:Array;
		private var lastIndex:int;
		
		public function RoadCrossingState(owner:Enemy, paths:Road, caravan:Vector.<Carriage>) 
		{
			this.caravan = caravan;
			this.paths = paths;
			this.owner = owner;
			
			const oldPath:Array = paths.getTopPath();
			const newPath:Array = paths.getBottomPath();
			const nextIndex:int = owner.vehicle.pathIndex - 1;
			lastIndex = newPath.length - nextIndex + 2;
			tempPath = [newPath[newPath.length - nextIndex + 1], 
				newPath[lastIndex]];
			owner.vehicle.pathIndex = 0;
		}
		
		public function update():void 
		{
			owner.vehicle.followPath(tempPath);
			if (owner.vehicle.pathIndex > 0) 
				owner.state = new ChaseState(owner, paths, caravan, lastIndex);
		}
		
	}

}