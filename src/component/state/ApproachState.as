package component.state 
{
	import com.foed.Vector2D;
	import component.object.Carriage;
	import component.object.Enemy;
	import component.object.MovingObject;
	import component.Road;
	/**
	 * ...
	 * @author Demy
	 */
	public class ApproachState implements IEnemyState 
	{
		private var owner:Enemy;
		private var paths:Road;
		private var lastCarriage:Carriage
		private var caravan:Vector.<Carriage>;
		
		public function ApproachState(owner:Enemy, paths:Road, caravan:Vector.<Carriage>) 
		{
			this.caravan = caravan;
			lastCarriage = caravan[caravan.length - 1];
			this.paths = paths;
			this.owner = owner;
		}
		
		public function update():void
		{
			if (!owner) return;
			
			const mainPath:Array = paths.getPath()
			const enemyPathIndex:int = owner.vehicle.pathIndex - 1;
			const carriagePathIndex:int = lastCarriage.vehicle.pathIndex - 1;
			if (enemyPathIndex > mainPath.length - carriagePathIndex)
			{
				owner.state = new RoadCrossingState(owner, paths, caravan);
				return;
			}
			
			owner.vehicle.followPath(paths.getTopPath());
		}
		
	}

}