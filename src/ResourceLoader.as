package  
{
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author Demy
	 */
	public class ResourceLoader extends EventDispatcher
	{
		private var assetManager:AssetManager;
		
		public function ResourceLoader() 
		{
			assetManager = new AssetManager();
			assetManager.verbose = false;
		}
		
		public function load(source:Class):void
		{
			assetManager.enqueue(source);
			assetManager.loadQueue(function onProgress(progress:Number):void
			{
				if (progress == 1) 
				{
					/*var images:Vector.<String> = assetManager.getTextureNames();
					var i:int = images.length;
					while (i--) trace(images[i]);*/
					dispatchEvent(new Event(Event.COMPLETE));
				}
			});
		}
		
		public function getTexture(name:String):Texture
		{
			if (!assetManager) return null;
			return assetManager.getTexture(name);
		}
		
		public function getXML(name:String):XML
		{
			if (!assetManager) return null;
			return assetManager.getXml(name);
		}
		
		public function dispose():void
		{
			if (!assetManager) return;
			assetManager.dispose();
			assetManager = null;
		}
		
	}

}