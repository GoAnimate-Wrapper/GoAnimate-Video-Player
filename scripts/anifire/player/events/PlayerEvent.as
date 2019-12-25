package anifire.player.events
{
	import flash.events.Event;
	
	public class PlayerEvent extends Event
	{
		
		public static const LOADING_BYTES:String = "loading_bytes";
		
		public static const MOVIE_STRUCTURE_READY:String = "movie_structure_ready";
		
		public static const BUFFER_EXHAUST:String = "buffer_exhaust";
		
		public static const BUFFER_READY:String = "buffer_ready";
		
		public static const BUFFER_READY_WHEN_MOVIE_START:String = "buffer_ready_when_movie_start";
		
		public static const LOAD_MOVIE_COMPLETE:String = "load_movie_complete";
		
		public static const LOAD_MOVIE_PROGRESS:String = "load_movie_progress";
		
		public static const PLAYHEAD_SCENE_LAST_ACTION_FRAME_REACHED:String = "playhead_scene_last_action_frame_reach";
		
		public static const PLAYHEAD_USER_PAUSE:String = "playhead_user_pause";
		
		public static const PLAYHEAD_USER_RESUME:String = "playhead_user_resume";
		
		public static const PLAYHEAD_USER_GOTOANDPAUSE:String = "playhead_user_gotoandpause";
		
		public static const PLAYHEAD_USER_START_PLAY:String = "playhead_user_start_play";
		
		public static const PLAYHEAD_TIME_CHANGE:String = "playhead_time_change";
		
		public static const PLAYHEAD_MOVIE_END:String = "playhead_movie_end";
		
		public static const VOLUME_CHANGE:String = "volume_change";
		
		public static const INIT_REMOTE_DATA_COMPLETE:String = "init_remote_data_complete";
		
		public static const ERROR_LOADING_MOVIE:String = "error_loading_movie";
		
		public static const FULL_SCREEN:String = "full_screen";
		
		public static const NOR_SCREEN:String = "nor_screen";
		
		public static const LOGO_CLICK:String = "logoClick";
		
		public static const NEXTMOVIE:String = "next_movie";
		
		public static const REAL_START_PLAY:String = "plainplayer_play";
		
		public static const LOAD_CCTHEME_COMPLETE:String = "load_cctheme_complete";
		
		public static const BUFFERING:String = "BUFFERING";
		
		public static const PLAYING:String = "PLAYING";
		
		public static const PAUSE:String = "PAUSE";
		
		public static const RESUME:String = "RESUME";
		 
		
		private var _data:Object;
		
		public function PlayerEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
		{
			this._data = param2;
			super(param1,param3,param4);
		}
		
		public function getData() : Object
		{
			return this._data;
		}
		
		override public function clone() : Event
		{
			return new PlayerEvent(this.type,this.getData(),this.bubbles,this.cancelable);
		}
	}
}
