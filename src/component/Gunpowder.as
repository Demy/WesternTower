package component 
{
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.extensions.PDParticleSystem;
	/**
	 * ...
	 * @author Demy
	 */
	public class Gunpowder 
	{
		static public const SHOT_XML_NAME:String = "particleGunShot";
		static public const SHOT_TEXTURE_NAME:String = "texture";
		
		private static var particles:PDParticleSystem;
		
		public function Gunpowder()
		{
		}
		
		public static function shoot(parent:DisplayObjectContainer, x:Number, y:Number):void 
		{
			if (!particles)
			{
				particles = new PDParticleSystem(
				Game.imageLoader.getXML(SHOT_XML_NAME), 
				Game.imageLoader.getTexture(SHOT_TEXTURE_NAME));
			}
			if (!Starling.juggler.contains(particles)) 
				Starling.juggler.add(particles);
			particles.emitterX = x;
			particles.emitterY = y;
			parent.addChild(particles);
			particles.start(0.5);
		}
		
		public static function dispose():void
		{
			if (particles)
			{
				particles.stop();
				if (Starling.juggler.contains(particles)) Starling.juggler.remove(particles);
				particles.dispose();
				particles = null;
			}
			
		}
		
	}

}