package model 
{
	/**
	 * ...
	 * @author Demy
	 */
	public class Statistics 
	{
		public static const KILLS_LABEL:String = "Kills:";
		public static const HITS_LABEL:String = "Successful hits:";
		
		private static var records:Object = new Object();
		
		public function Statistics() 
		{
			
		}
		
		public static function addRecord(object:Object, label:String, value:Number):void
		{
			if (records[object.name] == undefined) records[object.name] = new Object();
			if (records[object.name][label] == undefined) records[object.name][label] = 0;
			records[object.name][label] += value;
		}
		
		public static function getValue(object:Object, label:String):Number
		{
			if (!records[object.name]) return 0;
			if (!records[object.name][label]) return 0;
			return records[object.name][label];
		}
		
	}

}