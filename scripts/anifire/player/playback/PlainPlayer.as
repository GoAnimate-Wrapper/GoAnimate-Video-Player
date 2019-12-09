package anifire.player.playback
{
   import anifire.constant.ServerConstants;
   import anifire.managers.AppConfigManager;
   import anifire.player.events.PlayerEvent;
   import anifire.util.UtilErrorLogger;
   import anifire.util.UtilHashArray;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.net.URLRequest;
   
   public class PlainPlayer extends Anime
   {
      
      public static const MOVIE_ZIP_NOT_YET_LOAD:int = 0;
      
      public static const MOVIE_ZIP_LOADING:int = 1;
      
      public static const MOVIE_ZIP_LOADED:int = 2;
       
      
      public var loadingState:int = 0;
      
      public function PlainPlayer()
      {
         super();
      }
      
      public function initMovie(param1:URLRequest, param2:Array) : void
      {
         var _loc3_:AppConfigManager = AppConfigManager.instance;
         var _loc4_:String = _loc3_.getValue(ServerConstants.PARAM_MOVIE_ID);
         var _loc5_:PlainPlayer = this;
         var _loc6_:PlayerDataStock = getDataStock();
         _loc6_.addEventListener(PlayerEvent.LOAD_MOVIE_COMPLETE,this.onReadyToPlay);
         _loc6_.addEventListener(PlayerEvent.LOAD_MOVIE_COMPLETE,this.onLoadMovieCompleted,false,0,true);
         _loc6_.addEventListener(PlayerEvent.ERROR_LOADING_MOVIE,this.onLoadMovieError,false,0,true);
         _loc6_.addEventListener(PlayerEvent.LOAD_MOVIE_PROGRESS,this.onMovieProgress,false,0,true);
         _loc6_.initByLoadMovieZip(param2);
         this.loadingState = MOVIE_ZIP_LOADING;
      }
      
      private function onReadyToPlay(param1:PlayerEvent) : void
      {
         (param1.target as IEventDispatcher).removeEventListener(PlayerEvent.LOAD_MOVIE_COMPLETE,this.onReadyToPlay);
         UtilErrorLogger.getInstance().info("PlainPlayer.readyToPlay");
         dispatchEvent(new PlayerEvent(PlayerEvent.REAL_START_PLAY));
         startPlay();
      }
      
      private function onLoadMovieError(param1:PlayerEvent) : void
      {
         UtilErrorLogger.getInstance().appendDebug("PlainPlayer.onLoadMovieError");
         this.dispatchEvent(param1);
      }
      
      private function onMovieProgress(param1:PlayerEvent) : void
      {
         this.dispatchEvent(new PlayerEvent(PlayerEvent.LOAD_MOVIE_PROGRESS,param1.getData()));
      }
      
      private function onLoadMovieCompleted(param1:Event) : void
      {
         var _loc2_:AppConfigManager = AppConfigManager.instance;
         var _loc3_:String = _loc2_.getValue(ServerConstants.PARAM_MOVIE_ID);
         var _loc4_:* = _loc2_.getValue(ServerConstants.PARAM_ISEMBED_ID) == "0";
         this.init(this.getDataStock());
         this.loadingState = MOVIE_ZIP_LOADED;
      }
      
      public function initAndPreview(param1:XML, param2:UtilHashArray, param3:UtilHashArray) : void
      {
         if(param3 != null)
         {
            this.getDataStock().initByHashArray(param1,param2,param3);
         }
         this.getDataStock().addEventListener(PlayerEvent.LOAD_CCTHEME_COMPLETE,this.onCCThemeLoaded);
         this.getDataStock().loadAllCCThemeXmls();
      }
      
      private function onCCThemeLoaded(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(param1.type,this.onCCThemeLoaded);
         this.init(this.getDataStock(),true);
         this.startPlay();
         this.loadingState = MOVIE_ZIP_LOADED;
      }
      
      public function playMovie() : void
      {
         this.execute(Anime.COMMAND_PLAY);
      }
      
      public function pauseMovie(param1:Boolean = true) : void
      {
         this.execute(Anime.COMMAND_PAUSE,param1);
      }
      
      public function goToAndPauseMovie(param1:Number, param2:Boolean = false) : void
      {
         this.execute(Anime.COMMAND_GOTO_AND_PAUSE,param1,param2);
      }
      
      public function goToAndPauseResetMovie() : void
      {
         this.execute(Anime.COMMAND_GOTO_AND_PAUSE_RESET);
      }
      
      public function setVolume(param1:Number) : void
      {
         this.execute(Anime.COMMAND_SET_VOLUME,param1);
      }
      
      public function onRemoveEnterFrame() : void
      {
         this.execute(Anime.COMMAND_REMOVE_ENTER_FRAME);
      }
      
      public function onAddEnterFrame() : void
      {
         this.execute(Anime.COMMAND_ADD_ENTER_FRAME);
      }
      
      public function endMovie() : void
      {
         this.execute(Anime.COMMAND_END);
      }
   }
}
