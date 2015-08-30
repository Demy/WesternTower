package  
{
	import component.GameLevel;
	import component.object.Enemy;
	import component.object.Gunman;
	import component.object.Weapon;
	import menu.DesignMenu;
	import model.GameSettings;
	import model.GunShop;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Demy
	 */
	public class Game extends Sprite
	{
		private static const DESIGN_MODE:String = "design";
		private static const GAME_MODE:String = "game";
		
		private static const MODE:String = GAME_MODE;
		
		private static const START_GROUP_SIZE:int = 3;
		
		private var gameStage:GameLevel;
		private var designTool:DesignMenu;
		
		public static var imageLoader:ResourceLoader;
		
		public function Game() 
		{
			imageLoader = new ResourceLoader();
			imageLoader.addEventListener(Event.COMPLETE, startGame);
			imageLoader.load(AssetsPaths);
		}
		
		private function startGame(e:Event):void 
		{
			if (MODE == GAME_MODE)
			{
				gameStage = new GameLevel(Starling.current.stage.stageWidth, 
					Starling.current.stage.stageHeight);
				addChild(gameStage);
				gameStage.start(getDefaultSetteings());
			}
			else
			{
				designTool = new DesignMenu(getDefaultSetteings());
				designTool.addEventListener(Event.COMPLETE, startGameEmulation);
				addChild(designTool);
				
				gameStage = new GameLevel(Starling.current.stage.stageWidth, 
					Starling.current.stage.stageHeight - designTool.height);
				gameStage.y = designTool.height;
				addChildAt(gameStage, 0);
				gameStage.addEventListener(Event.COMPLETE, enableDesignMode);
			}
		}
		
		private function getDefaultSetteings():GameSettings 
		{
			var result:GameSettings = new GameSettings();
			result.caravanLength = 5;
			result.carriageHP = 20;
			result.gunmanDamage = 1;
			result.gunmanDelay = 1;
			result.gunmanRange = 300;
			result.gunmanAccuracy = 1;
			result.weaponAccuracy = 1;
			result.enemyCount = 0;
			result.enemyHP = 5;
			result.enemySpeed = Enemy.DEFAULT_SPEED;
			result.enemyDamage = 1;
			result.enemyDelay = 1;
			result.enemyRange = 300;
			result.enemyMissChance = 0.8;
			result.enemyDodge = 0.1;
			result.simulationTime = 10;
			
			result.gunmen = new Vector.<Gunman>(START_GROUP_SIZE); 
			var weapon:Weapon;
			var i:int = START_GROUP_SIZE;
			while (i--)
			{
				weapon = GunShop.getRandomAt(1);
				result.gunmen[i] = new Gunman(Gunman.randomName(), 1, 0, result.gunmanAccuracy, weapon, 
					0);
			}
			
			return result;
		}
		
		private function startGameEmulation(e:Event):void 
		{
			if (gameStage.isStarted) gameStage.stop();
			gameStage.start(designTool.settings);
		}
		
		private function enableDesignMode(e:Event):void 
		{
			designTool.enable();
		}
		
		override public function dispose():void 
		{			
			gameStage.removeEventListener(Event.COMPLETE, enableDesignMode);
			gameStage = null
			designTool.removeEventListener(Event.COMPLETE, startGameEmulation);
			designTool = null;
			imageLoader = null;
			
			super.dispose();
		}
		
	}

}