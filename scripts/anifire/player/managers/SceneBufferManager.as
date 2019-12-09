package anifire.player.managers
{
   import anifire.component.ProcessRegulator;
   import anifire.component.ProgressMonitor;
   import anifire.player.events.PlayerEvent;
   import anifire.player.events.SceneBufferEvent;
   import anifire.player.playback.Anime;
   import anifire.player.playback.AnimeScene;
   import anifire.util.Util;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.ProgressEvent;
   
   public class SceneBufferManager extends EventDispatcher
   {
      
      public static const MIN_BUFFER_TIME_IN_SEC:Number = 30;
      
      public static const PREVIEW_MIN_BUFFER_TIME_IN_SEC:Number = 15;
      
      private static var _instance:SceneBufferManager;
      
      private static var _highSpeedMode:Boolean = true;
       
      
      private var _anime:Anime;
      
      private var _bufferingTime:Number = 0;
      
      private var _remainingDurationInSecond:Number = 0;
      
      private var _sceneRegulator:ProcessRegulator;
      
      private var _fromSceneIndex:Number = 0;
      
      private var _isBufferReady:Boolean = false;
      
      private var _defaultMinBufferTime:Number = 30;
      
      public function SceneBufferManager(param1:IEventDispatcher = null)
      {
         this._sceneRegulator = new ProcessRegulator();
         super(param1);
         this._isBufferReady = false;
      }
      
      public static function get instance() : SceneBufferManager
      {
         if(!_instance)
         {
            _instance = new SceneBufferManager();
         }
         return _instance;
      }
      
      public static function get highSpeedMode() : Boolean
      {
         return _highSpeedMode;
      }
      
      public static function set highSpeedMode(param1:Boolean) : void
      {
         _highSpeedMode = param1;
      }
      
      public function get isBufferReady() : Boolean
      {
         return this._isBufferReady;
      }
      
      private function calculateRemainingDurationInSecond() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:AnimeScene = null;
         if(this._anime)
         {
            this._remainingDurationInSecond = 0;
            _loc1_ = this._fromSceneIndex;
            while(_loc1_ < this._anime.getNumScene())
            {
               _loc2_ = this._anime.getSceneByIndex(_loc1_);
               if(_loc2_)
               {
                  this._remainingDurationInSecond = this._remainingDurationInSecond + _loc2_.durationInSecond;
               }
               _loc1_++;
            }
         }
      }
      
      public function startBuffering(param1:Number, param2:Anime) : void
      {
         this._anime = param2;
         if(this._anime)
         {
            this._bufferingTime = 0;
            this._isBufferReady = false;
            this._fromSceneIndex = param1;
            this.calculateRemainingDurationInSecond();
            this.bufferScene(param1);
         }
      }
      
      private function bufferScene(param1:Number = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:AnimeScene = null;
         if(this._anime)
         {
            this._sceneRegulator.removeEventListener(ProgressEvent.PROGRESS,this.onSceneBuffering);
            this._sceneRegulator.reset();
            ProgressMonitor.getInstance().addProgressEventDispatcher(this);
            _loc2_ = param1;
            while(_loc2_ < this._anime.getNumScene())
            {
               _loc3_ = this._anime.getSceneByIndex(_loc2_);
               this._sceneRegulator.addProcess(_loc3_,PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
               _loc2_++;
            }
            this._sceneRegulator.addEventListener(ProgressEvent.PROGRESS,this.onSceneBuffering);
            this._sceneRegulator.startProcess(true);
         }
      }
      
      private function onSceneBuffering(param1:ProgressEvent) : void
      {
         var _loc2_:AnimeScene = null;
         var _loc3_:ProgressEvent = null;
         var _loc4_:SceneBufferEvent = null;
         if(this._anime)
         {
            _loc2_ = this._anime.getSceneByIndex(this._fromSceneIndex + param1.bytesLoaded - 1);
            if(_loc2_)
            {
               this._bufferingTime = this._bufferingTime + _loc2_.durationInSecond;
            }
            _loc3_ = new ProgressEvent(ProgressEvent.PROGRESS);
            if(param1.bytesLoaded == param1.bytesTotal)
            {
               _loc3_.bytesLoaded = 100;
               _loc3_.bytesTotal = 100;
            }
            else
            {
               _loc3_.bytesLoaded = this._bufferingTime;
               _loc3_.bytesTotal = this.minBufferTimeInSecond;
            }
            if(_loc3_.bytesLoaded / _loc3_.bytesTotal <= 1)
            {
               this.dispatchEvent(_loc3_);
            }
            _loc4_ = new SceneBufferEvent(SceneBufferEvent.SCENE_BUFFERED);
            _loc4_.sceneIndex = this._fromSceneIndex + param1.bytesLoaded - 1;
            this.dispatchEvent(_loc4_);
            if(this._isBufferReady == false)
            {
               if(this._bufferingTime >= this.minBufferTimeInSecond || param1.bytesLoaded == param1.bytesTotal)
               {
                  this._isBufferReady = true;
                  this.dispatchEvent(new SceneBufferEvent(SceneBufferEvent.BUFFER_READY));
               }
            }
         }
      }
      
      private function get minBufferTimeInSecond() : Number
      {
         if(Util.isVideoRecording())
         {
            return 9999999;
         }
         return Math.min(this._defaultMinBufferTime,this._remainingDurationInSecond);
      }
      
      public function reset() : void
      {
         this._anime = null;
         this._bufferingTime = 0;
         this._isBufferReady = false;
         this._remainingDurationInSecond = 0;
         this._sceneRegulator.removeEventListener(ProgressEvent.PROGRESS,this.onSceneBuffering);
         this._sceneRegulator.reset();
      }
      
      public function set defaultMinBufferTime(param1:Number) : void
      {
         this._defaultMinBufferTime = param1;
      }
   }
}
