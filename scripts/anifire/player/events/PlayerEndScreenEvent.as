package anifire.player.events
{
	import flash.events.Event;
	
	public class PlayerEndScreenEvent extends Event
	{
		
		public static const REPLAY_BUTTON_CLICK:String = "replayButtonClick";
		
		public static const CREDIT_SCREEN_TIME_UP:String = "creditScreenTimeUp";
		 
		
		public function PlayerEndScreenEvent(param1:String)
		{
			super(param1);
		}
	}
}
