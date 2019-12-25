package anifire.util
{
	import flash.external.ExternalInterface;
	
	public class GoExtInterface
	{
		 
		
		public function GoExtInterface()
		{
			super();
		}
		
		public static function get available() : Boolean
		{
			return ExternalInterface.available;
		}
		
		public static function call(param1:String, ... rest) : *
		{
			try
			{
				switch(rest.length)
				{
					case 0:
						return ExternalInterface.call(param1);
					case 1:
						return ExternalInterface.call(param1,rest[0]);
					case 2:
						return ExternalInterface.call(param1,rest[0],rest[1]);
					case 3:
						return ExternalInterface.call(param1,rest[0],rest[1],rest[2]);
				}
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		public static function addCallback(param1:String, param2:Function) : void
		{
			try
			{
				ExternalInterface.addCallback(param1,param2);
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
