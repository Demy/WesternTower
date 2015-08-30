package component.state 
{
	import component.object.Carriage;
	import component.object.Enemy;
	import component.Road;
	/**
	 * ...
	 * @author Demy
	 */
	public class ChaseState implements IEnemyState 
	{
		private var owner:Enemy;
		private var paths:Road;
		private var caravan:Vector.<Carriage>;
		
		public function ChaseState(owner:Enemy, paths:Road, caravan:Vector.<Carriage>, lastIndex:int) 
		{
			this.caravan = caravan;
			this.paths = paths;
			this.owner = owner;
			owner.vehicle.pathIndex = lastIndex;
		}
		
		public function update():void 
		{
			owner.vehicle.followPath(paths.getBottomPath());
		}
		
	}

}