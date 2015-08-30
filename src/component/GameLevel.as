package component 
{
	import component.object.Carriage;
	import component.object.GameObject;
	import flash.utils.setTimeout;
	import model.GameSettings;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Demy
	 */
	public class GameLevel extends Sprite implements IAnimatable 
	{
		static private const FPS:int = 30;
		
		private var _isStarted:Boolean;
		
		private var road:Road;
		
		private var camera:GameCamera;
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		private var settings:GameSettings;
		private var gameTime:int;
		private var scene:GameScene;
		private var spawner:WaveSpawner;
		
		public function GameLevel(stageWidth:Number, stageHeight:Number) 
		{	
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			
			_isStarted = false;
		}
		
		public function start(settings:GameSettings):void
		{
			_isStarted = true;
			
			applySettings(settings);
			setupLevel();
			runLevel();
		}
		
		private function pause(e:Event = null):void 
		{
			if (Starling.juggler.contains(this)) 
			{
				Starling.juggler.remove(this);
				return;
			}
			Starling.juggler.add(camera);
		}
		
		public function stop():void 
		{
			Starling.juggler.remove(this);
			Starling.juggler.remove(camera);
		}
		
		
		private function applySettings(settings:GameSettings):void 
		{
			this.settings = settings;
			
			GameObject.resetIds();
			
			WaveSpawner.setStandardEnemy(settings);
		}
		
		private function setupLevel():void 
		{			
			road = new Road();
			addChild(road);
			
			camera = new GameCamera(stageWidth, stageHeight);
			camera.gameField = road;
			drawRoad();
			
			scene = new GameScene(settings.gunmen);
			scene.field = road;
			scene.createCaravan(settings.caravanLength, settings.carriageHP, Carriage.DEFAULT_SPEED);
			
			spawner = new WaveSpawner();
			spawner.addEventListener(Event.CHANGE, addEnemies);
		}
		
		private function runLevel():void 
		{
			Starling.juggler.add(this);
			Starling.juggler.add(camera);
			
			gameTime = setTimeout(function():void {
				pause();
				dispatchEvent(new Event(Event.COMPLETE));
			}, settings.simulationTime * 1000 * 60);
		}
		
		private function addEnemies(e:Event):void 
		{
			scene.addEnemies(spawner.getCurrentEnemies());
		}
		
		
		public function advanceTime(time:Number):void
		{
			scene.update();
			//drawRoad();
		}
		
		private function drawRoad():void 
		{
			var dif:Number = (stageWidth / camera.scale - stageWidth);
			var endX:Number = camera.x + stageWidth * 0.5 + dif;
			road.createRoad(endX * 0.9);
		}
		
		
		public function get isStarted():Boolean 
		{
			return _isStarted;
		}
		
		override public function dispose():void 
		{
			Starling.juggler.remove(this);
			
			super.dispose();
		}
		
	}

}