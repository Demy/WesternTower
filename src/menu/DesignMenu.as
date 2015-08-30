package menu 
{
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.TextInput;
	import feathers.layout.ILayout;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.VerticalLayout;
	import flash.utils.setTimeout;
	import model.GameSettings;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Demy
	 */
	public class DesignMenu extends Sprite 
	{
		private var currentSettings:GameSettings;
		
		private var caravanLength:TextInput;
		private var startButton:Button;
		public var carriageHP:TextInput;
		public var gunmanDamage:TextInput;
		public var gunmanDelay:TextInput;
		public var gunmanRange:TextInput;
		public var gunmanAccuracy:TextInput;
		public var weaponAccuracy:TextInput;
		public var enemyCount:TextInput;
		public var enemyHP:TextInput;
		public var enemySpeed:TextInput;
		public var enemyDamage:TextInput;
		public var enemyDelay:TextInput;
		public var enemyRange:TextInput;
		public var enemyMissChance:TextInput;
		public var enemyDodge:TextInput;
		public var simulationTime:TextInput;
		
		public function DesignMenu(defaultSettings:GameSettings) 
		{
			currentSettings = defaultSettings;
			
			addChild(new Quad(Starling.current.stage.stageWidth, 
				Starling.current.stage.stageHeight * 0.4, 0xE6E6E6));
				
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 5;
			layout.padding = 10;
				
			var leftForm:ScrollContainer = createForm(layout);
			
			var rightForm:ScrollContainer = createForm(layout);
			rightForm.x = leftForm.width;
				
			var timeContrainer:Sprite = new Sprite();
			timeContrainer.x = rightForm.width + rightForm.x;
			timeContrainer.y = layout.padding;
			addChild(timeContrainer);
			
			addFields(leftForm, rightForm, timeContrainer);
			
			startButton = createButton();
			startButton.addEventListener(Event.TRIGGERED, startSimulation);
			startButton.y = height - startButton.defaultSkin.height - layout.padding * 2;
			startButton.x = timeContrainer.x + layout.padding;
		}
		
		public function enable():void
		{
			startButton.alpha = 1;
			startButton.touchable = true;
		}
		
		private function createForm(layout:ILayout):ScrollContainer 
		{
			var result:ScrollContainer = new ScrollContainer();
			result.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			result.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			result.layout = layout;
			result.width = Starling.current.stage.stageWidth * 0.3;
			result.height = height;
			addChild(result);
			return result;
		}
		
		private function addFields(leftForm:ScrollContainer, rightForm:ScrollContainer, timeContrainer:Sprite):void 
		{
			caravanLength = createField("Caravan length", currentSettings.caravanLength, leftForm);
			carriageHP = createField("Cariage HP", currentSettings.carriageHP, leftForm);
			gunmanDamage = createField("Gunman damage", currentSettings.gunmanDamage, leftForm);
			gunmanDelay = createField("Gunman delay", currentSettings.gunmanDelay, leftForm);
			gunmanRange = createField("Gunman range", currentSettings.gunmanRange, leftForm);
			gunmanAccuracy = createField("Gunman accuracy", currentSettings.gunmanAccuracy * 100, leftForm);
			weaponAccuracy = createField("Weapon accuracy", currentSettings.weaponAccuracy * 100, leftForm);
			
			enemyCount = createField("Enemies in wave", currentSettings.enemyCount, rightForm);
			enemyHP = createField("Enemy speed", currentSettings.enemyHP, rightForm);
			enemySpeed = createField("Enemy HP", currentSettings.enemySpeed, rightForm);
			enemyDamage = createField("Enemy damage", currentSettings.enemyDamage, rightForm);
			enemyDelay = createField("Enemy delay", currentSettings.enemyDelay, rightForm);
			enemyRange = createField("Enemy range", currentSettings.enemyRange, rightForm);
			enemyMissChance = createField("Enemy miss chance", currentSettings.enemyMissChance * 100, rightForm);
			enemyDodge = createField("Enemy dodge", currentSettings.enemyDodge * 100, rightForm);
			
			simulationTime = createField("Simulatin time", 2, timeContrainer);
		}
		
		private function createField(label:String, value:Number, container:DisplayObjectContainer):TextInput
		{
			var fieldContainer:Sprite = new Sprite();
			var labelField:TextField = new TextField(130, 18, label);
			var valueField:TextInput = new TextInput();
			valueField.backgroundSkin = new Quad(70, 17, 0xFFFFFF);
			valueField.width = valueField.backgroundSkin.width;
			valueField.x = labelField.width + 10;
			valueField.paddingLeft = 4;
			valueField.paddingTop = 2;
			valueField.text = String(value);
			valueField.restrict = "0-9.";
			fieldContainer.addChild(labelField);
			fieldContainer.addChild(valueField);
			container.addChild(fieldContainer);
			
			return valueField;
		}
		
		private function createButton():Button 
		{
			var result:Button = new Button();
			result.defaultSkin = new Quad(100, 30, 0xFFFFFF);
			result.label = "Start!";
			addChild(result);
			return result;
		}
		
		private function startSimulation(e:Event):void 
		{
			updateSettings(currentSettings);
			
			startButton.touchable = false;
			startButton.alpha = 0.5;			
			
			dispatchEvent(new Event(Event.COMPLETE))
		}
		
		private function updateSettings(currentSettings:GameSettings):void 
		{
			currentSettings.caravanLength = int(caravanLength.text);
			currentSettings.carriageHP = int(carriageHP.text);
			currentSettings.gunmanDamage = int(gunmanDamage.text);
			currentSettings.gunmanDelay = Number(gunmanDelay.text);
			currentSettings.gunmanRange = Number(gunmanRange.text);
			currentSettings.gunmanAccuracy = Number(gunmanAccuracy.text) / 100;
			currentSettings.weaponAccuracy = Number(weaponAccuracy.text) / 100;
			currentSettings.enemyCount = int(enemyCount.text);
			currentSettings.enemyHP = int(enemyHP.text);
			currentSettings.enemySpeed = Number(enemySpeed.text);
			currentSettings.enemyDamage = int(enemyDamage.text);
			currentSettings.enemyDelay = Number(enemyDelay.text);
			currentSettings.enemyRange = Number(enemyRange.text);
			currentSettings.enemyMissChance = Number(enemyMissChance.text) / 100;
			currentSettings.enemyDodge = Number(enemyDodge.text) / 100;
			currentSettings.simulationTime = Number(simulationTime.text);
		}
		
		public function get settings():GameSettings
		{
			return currentSettings;
		}
		
	}

}