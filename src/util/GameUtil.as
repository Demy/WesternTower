package util 
{
	/**
	 * ...
	 * @author Demy
	 */
	public class GameUtil 
	{
		
		public function GameUtil() 
		{
			
		}
		
		public static function random(size:int):int
		{
			return Math.round(Math.random() * (size - 1));
		}
		
	}

}