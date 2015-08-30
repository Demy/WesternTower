package component 
{
	import com.foed.Vector2D;
	import flash.geom.Point;
	import model.RoadWays;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Demy
	 */
	public class Road extends Sprite 
	{
		private static const START_POINT:Point = new Point(150, 0);
		
		private var roadGenerator:RoadGenerator;
		private var roadWays:RoadWays
		
		public function Road() 
		{			
			createBacground(START_POINT);
			roadWays = new RoadWays();
			
			roadGenerator = new RoadGenerator(this, START_POINT.x);
		}
		
		private function createBacground(startPoint:Point):void 
		{
			var firstTile:Image = RoadGenerator.generateNewPiece(RoadGenerator.HORIZONTAL);
			addChild(firstTile);
			firstTile.x = startPoint.x - firstTile.width * 1.5;
			firstTile.y = startPoint.y + firstTile.height * 0.5;
			var secondTile:Image = RoadGenerator.generateNewPiece(RoadGenerator.HORIZONTAL);
			addChild(secondTile);
			secondTile.x = startPoint.x - secondTile.width * 0.5;
			secondTile.y = startPoint.y + secondTile.height * 0.5;
		}
		
		public function add(object:DisplayObject):void
		{
			addChild(object);
		}
		
		public function createRoad(endX:Number):void
		{
			var startX:Number = roadWays.mainRoad.length == 0 ? 0 : 
				roadWays.mainRoad[roadWays.mainRoad.length - 1].x;
			if (endX - startX > 0 && endX > startX)
			{
				var ways:RoadWays = roadGenerator.generateRoadPart(startX, endX);
				roadWays.mainRoad = roadWays.mainRoad.concat(ways.mainRoad);
				roadWays.topSideRoad = ways.topSideRoad.concat(roadWays.mainRoad);
				roadWays.bottomSideRoad = roadWays.mainRoad.concat(ways.bottomSideRoad);
			}
		}
		
		private function lastIndexOf(point:Vector2D, array:Array):int 
		{
			var i:int = array.length;
			var vector:Vector2D;
			while (i--) 
			{
				vector = array[i];
				if (vector.x == point.x && vector.y == point.y) return i;
			}
			return -1;
		}
		
		public function getTopPath():Array
		{
			return roadWays.topSideRoad;
		}
		
		public function getBottomPath():Array
		{
			return roadWays.bottomSideRoad;
		}
		
		public function getPath():Array
		{
			return roadWays.mainRoad;
		}
		
		private function drawPath(path:Array, color:uint):void 
		{
			if (!path) return;
			var i:int = path.length;
			while (i--)
			{
				var point:Vector2D = path[i];
				var marker:Quad = new Quad(10, 10, color);
				marker.x = point.x - marker.width * 0.5;
				marker.y = point.y - marker.height * 0.5;
				addChild(marker);
				
				var counter:TextField = new TextField(60, 60, String(i), "Verdana", 30);
				counter.x = marker.x;
				counter.y = marker.y;
				addChild(counter);
			}
		}
		
	}

}