package component.object 
{
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Demy
	 */
	public class GameObject extends EventDispatcher 
	{
		private static var globalId:int = 0;
		
		private var _id:int;
		
		public function GameObject() 
		{
			_id = globalId++;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public static function resetIds():void
		{
			globalId = 0;
		}
		
	}

}