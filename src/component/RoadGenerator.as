package component 
{
	import com.foed.Vector2D;
	import model.RoadWays;
	import starling.animation.Tween;
	import starling.display.DisplayObjectContainer;
	import starling.core.Starling;
	import starling.display.Image;
	import util.GameUtil;
	/**
	 * ...
	 * @author Demy
	 */
	public class RoadGenerator 
	{
		private static const CURVY_PIECE:String = "01";
		private static const STRAIGHT_PIECE:String = "02";
		
		public static const HORIZONTAL:int = 0;
		private static const TO_BOTTOM:int = 1;
		private static const TO_TOP:int = 2;
		
		private static const VERTICAL:int = 3;
		private static const BOTTOM_RIGHT:int = 4;
		private static const TOP_RIGHT:int = 5;
		
		private static const PIECES_COUNT:int = 3;
		
		private static const PREFIX:String = "roadPiece";
		
		private static var pieceSize:Number;
		
		private var prevDirection:int;
		private var directionToAvoid:int;
		
		private var startY:Number;
		
		private var stage:DisplayObjectContainer;
		
		public function RoadGenerator(stage:DisplayObjectContainer, startY:Number) 
		{
			this.stage = stage;
			prevDirection = HORIZONTAL;
			directionToAvoid = TO_BOTTOM;
			pieceSize = -1;
			this.startY = startY;
		}
		
		public function generateRoadPart(startX:Number, endX:Number):RoadWays 
		{
			var result:RoadWays = new RoadWays();
			result.directions = [];			
			var widthLeft:Number = endX - startX;
			var place:Vector2D = new Vector2D();
			var direction:int;
			var startY:Number = startY;
			while (widthLeft > 0)
			{
				direction = getDirection();
				if (direction == directionToAvoid) direction = getDirection();
				directionToAvoid = prevDirection;
				prevDirection = direction;
				result.directions.push(direction);
				
				var newPiece:Image = generateNewPiece(direction);
				place.x = endX - widthLeft;
				place.y = startY;
				setPieceToPosition(newPiece, place, direction);
				
				stage.addChildAt(newPiece, 0);
				widthLeft -= pieceSize;
				
				if (direction == TO_TOP || direction == TO_BOTTOM) 
				{
					startY = generateExtraPart(place, result.directions, direction == TO_TOP);
					widthLeft -= pieceSize;
				}
			}
			generateWays(result, startX, this.startY, endX);
			this.startY = startY;
			return result;
		}
		
		private function generateExtraPart(place:Vector2D, directions:Array, toTop:Boolean):Number 
		{
			var sign:int = (toTop ? -1 : 1);
			var extraDirection:int = toTop ? BOTTOM_RIGHT : TOP_RIGHT;
			
			var newPlace:Vector2D = new Vector2D(place.x, place.y + pieceSize * sign);
			var extraPiece:Image = generateNewPiece(VERTICAL);
			setPieceToPosition(extraPiece, newPlace, VERTICAL);
			stage.addChildAt(extraPiece, 0);
			directions.push(VERTICAL);
			
			newPlace = new Vector2D(place.x, place.y + pieceSize * 2 * sign);
			var backPiece:Image = generateNewPiece(extraDirection);
			setPieceToPosition(backPiece, newPlace, extraDirection);
			stage.addChildAt(backPiece, 0);
			directions.push(extraDirection);
			
			newPlace = new Vector2D(place.x + pieceSize, place.y + pieceSize * 2 * sign);
			var endPiece:Image = generateNewPiece(HORIZONTAL);
			setPieceToPosition(endPiece, newPlace, HORIZONTAL);
			stage.addChildAt(endPiece, 0);
			directions.push(HORIZONTAL);
			
			return newPlace.y;
		}
		
		private function setPieceToPosition(piece:Image, place:Vector2D, direction:int):void 
		{
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			if (direction == HORIZONTAL) offsetX += pieceSize;
			if (direction == TO_TOP) offsetX += pieceSize;
			if (direction == BOTTOM_RIGHT) offsetY += pieceSize;
			if (direction == TOP_RIGHT) 
			{
				offsetX += pieceSize;
				offsetY += pieceSize;
			}
			
			piece.x = place.x + offsetX;
			piece.y = place.y + offsetY;
		}
		
		private function getDirection():int 
		{
			var index:int = GameUtil.random(PIECES_COUNT);
			return index;
		}
		
		public static function generateNewPiece(direction:int):Image 
		{			
			var piece:Image = new Image(Game.imageLoader.getTexture(
					PREFIX + getNameByDirection(direction)));
			piece.rotation = getRotationByDirection(direction);			
			if (pieceSize < 0) pieceSize = piece.width;
			return piece;
		}
		
		private static function getRotationByDirection(direction:int):Number
		{
			if (direction == HORIZONTAL) return Math.PI * 0.5;
			if (direction == TO_TOP) return Math.PI * 0.5;
			if (direction == TOP_RIGHT) return Math.PI;
			if (direction == BOTTOM_RIGHT) return Math.PI * 1.5;
			return 0;
		}
		
		private static function getNameByDirection(direction:int):String
		{
			if (direction == VERTICAL || direction == HORIZONTAL) return STRAIGHT_PIECE;
			return CURVY_PIECE;
		}
		
		private function generateWays(result:RoadWays, startX:Number, startY:Number, endX:Number):void 
		{			
			var directions:Array = result.directions;
			var direction:int;
			var widthLeft:Number = endX - startX;
			var place:Vector2D = new Vector2D();	
			
			var size:int = result.directions.length;
			for (var i:int = 0; i < size; i++)
			{
				place.x = endX - widthLeft;
				place.y = startY;
				direction = directions[i];
				addPathPoints(result, direction, place, 
					(direction == VERTICAL ? directions[i - 1] == TO_BOTTOM : true));
					
				widthLeft -= (direction == VERTICAL || direction == TO_BOTTOM ||
					direction == TO_TOP ? 0 : pieceSize);
				startY += (direction == VERTICAL ? (pieceSize * 2) * 
					(directions[i - 1] == TO_BOTTOM ? 1 : -1) : 0);
			}
			
			result.topSideRoad.reverse();
		}
		
		private function addPathPoints(result:RoadWays, direction:int, place:Vector2D, 
			toBottom:Boolean = true):void 
		{
			var road:Array = result.mainRoad;
			var topRoad:Array = result.topSideRoad;
			var bottomRoad:Array = result.bottomSideRoad;
			
			var mainPath:Array = [];
			getMainPoints(mainPath, direction, place, toBottom);
			
			var topPoint:Vector2D;
			var bottomPoint:Vector2D;
			var size:int = mainPath.length;
			for (var i:int = 0; i < size; i++)
			{
				road.push(mainPath[i]);
				if (direction != VERTICAL && direction != HORIZONTAL)
				{
					topPoint = new Vector2D(mainPath[i].x, mainPath[i].y);
					bottomPoint = new Vector2D(mainPath[i].x, mainPath[i].y);
					topPoint.y -= pieceSize * 0.5;
					topPoint.x += (direction == TOP_RIGHT || direction == TO_BOTTOM ? 1 : -1) * 
						pieceSize * 0.5;
					bottomPoint.y += pieceSize * 0.5;
					bottomPoint.x += (direction != TOP_RIGHT && direction != TO_BOTTOM ? 1 : -1) * 
						pieceSize * 0.5;
					topRoad.push(topPoint);
					bottomRoad.push(bottomPoint);
				}
			}
		}
		
		private function getMainPoints(road:Array, direction:int, place:Vector2D, toBottom:Boolean):void 
		{
			switch (direction) 
			{
				case TO_TOP:
					road.push(new Vector2D(place.x + pieceSize * 0.250, place.y + pieceSize * 0.475));
					road.push(new Vector2D(place.x + pieceSize * 0.400, place.y + pieceSize * 0.400));
					road.push(new Vector2D(place.x + pieceSize * 0.475, place.y + pieceSize * 0.250));
					road.push(new Vector2D(place.x + pieceSize * 0.5, place.y));
				break;
				case TO_BOTTOM:
					road.push(new Vector2D(place.x + pieceSize * 0.250, place.y + pieceSize * 0.475));
					road.push(new Vector2D(place.x + pieceSize * 0.400, place.y + pieceSize * 0.550));
					road.push(new Vector2D(place.x + pieceSize * 0.475, place.y + pieceSize * 0.750));
					road.push(new Vector2D(place.x + pieceSize * 0.5, place.y + pieceSize));
				break;
				case BOTTOM_RIGHT:
					road.push(new Vector2D(place.x + pieceSize * 0.500, place.y + pieceSize * 0.750));
					road.push(new Vector2D(place.x + pieceSize * 0.550, place.y + pieceSize * 0.550));
					road.push(new Vector2D(place.x + pieceSize * 0.750, place.y + pieceSize * 0.475));
					road.push(new Vector2D(place.x + pieceSize, place.y + pieceSize * 0.475));
				break;
				case TOP_RIGHT:
					road.push(new Vector2D(place.x + pieceSize * 0.500, place.y + pieceSize * 0.275));
					road.push(new Vector2D(place.x + pieceSize * 0.550, place.y + pieceSize * 0.450));
					road.push(new Vector2D(place.x + pieceSize * 0.750, place.y + pieceSize * 0.500));
					road.push(new Vector2D(place.x + pieceSize, place.y + pieceSize * 0.5));
				break;
			}
		}
		
	}

}