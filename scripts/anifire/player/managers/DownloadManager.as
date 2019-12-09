package anifire.player.managers
{
   import anifire.constant.AnimeConstants;
   import anifire.interfaces.ISoundAsset;
   import anifire.player.events.PlayerEvent;
   import anifire.sound.NetStreamController;
   import anifire.sound.VideoNetStreamController;
   import anifire.util.Util;
   import anifire.util.UtilHashArray;
   import anifire.util.UtilPlain;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   import mx.containers.Canvas;
   
   public class DownloadManager extends EventDispatcher
   {
      
      private static var singleton:DownloadManager;
       
      
      private var _movieDuration:Number;
      
      private var _sounds:UtilHashArray;
      
      private var _sound_download_queue:Array;
      
      private var _downloadServiceProviders:Array;
      
      private var _timer:Timer;
      
      private var _graphContainer:DisplayObjectContainer;
      
      private var _curMilliSecond:Number;
      
      private var _downloadStartTime:Number = 0;
      
      private var _urlArray:UtilHashArray;
      
      public function DownloadManager()
      {
         this._urlArray = new UtilHashArray();
         super();
      }
      
      public static function getInstance() : DownloadManager
      {
         if(DownloadManager.singleton == null)
         {
            DownloadManager.singleton = new DownloadManager();
         }
         return DownloadManager.singleton;
      }
      
      public function set drawingCanvas(param1:Canvas) : void
      {
         this._graphContainer = param1;
      }
      
      public function get urlArray() : UtilHashArray
      {
         return this._urlArray;
      }
      
      public function set urlArray(param1:UtilHashArray) : void
      {
         this._urlArray = param1;
      }
      
      public function init() : void
      {
         this._sounds = new UtilHashArray();
         this._timer = new Timer(500);
      }
      
      public function initDependency(param1:int, param2:DisplayObjectContainer, param3:Number = 0) : void
      {
         this._movieDuration = param1;
         this._graphContainer = param2;
         this._downloadStartTime = param3;
      }
      
      private function startTimer() : void
      {
         if(Util.isDebugMode)
         {
            this._timer.addEventListener(TimerEvent.TIMER,this.doDrawDownloadStatus);
         }
         this._timer.addEventListener(TimerEvent.TIMER,this.doManageDownloadStatus);
         this._timer.start();
      }
      
      private function stopTimer() : void
      {
         if(Capabilities.isDebugger)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.doDrawDownloadStatus);
         }
         this._timer.removeEventListener(TimerEvent.TIMER,this.doManageDownloadStatus);
      }
      
      public function registerSoundChannel(param1:URLRequest, param2:Number, param3:Number, param4:ISoundAsset, param5:Number) : void
      {
         var _loc6_:String = null;
         _loc6_ = new Date().toString() + Math.random().toString();
         var _loc7_:ProgressiveSoundItem = new ProgressiveSoundItem();
         _loc7_.init(param1,param2,param3,param4,param5);
         this._sounds.push(_loc6_,_loc7_);
      }
      
      public function registerNetStream(param1:String, param2:String, param3:Number, param4:Number, param5:Number) : NetStreamController
      {
         var _loc6_:String = null;
         _loc6_ = new Date().toString() + Math.random().toString();
         var _loc7_:NetStreamController = new NetStreamController(param5);
         var _loc8_:StreamSoundItem = new StreamSoundItem();
         _loc8_.init(param1,param2,_loc7_,param3,param4);
         this._sounds.push(_loc6_,_loc8_);
         return _loc7_;
      }
      
      public function registerVideoNetStream(param1:String, param2:Number, param3:Number, param4:Number) : VideoNetStreamController
      {
         var _loc5_:String = null;
         _loc5_ = new Date().toString() + Math.random().toString();
         var _loc6_:VideoNetStreamController = new VideoNetStreamController(param4);
         var _loc7_:VideoStreamSoundItem = new VideoStreamSoundItem();
         _loc7_.init(param1,_loc6_,param2,param3);
         this._sounds.push(_loc5_,_loc7_);
         return _loc6_;
      }
      
      public function startDownload() : void
      {
         var _loc1_:int = 0;
         this._downloadServiceProviders = new Array();
         _loc1_ = 0;
         while(_loc1_ < AnimeConstants.MAX_CONCURRENT_NETWORK_CONNECTION)
         {
            this._downloadServiceProviders.push(new DownloadServiceProvider());
            _loc1_++;
         }
         this._sound_download_queue = new Array();
         _loc1_ = 0;
         while(_loc1_ < this._sounds.length)
         {
            this._sound_download_queue.push(this._sounds.getValueByIndex(_loc1_));
            _loc1_++;
         }
         this.reorganizeCustomerQueue(this._downloadStartTime);
         this.startTimer();
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         var _loc2_:DownloadServiceProvider = null;
         if(this._downloadServiceProviders == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this._downloadServiceProviders.length)
         {
            _loc2_ = this._downloadServiceProviders[_loc1_] as DownloadServiceProvider;
            if(_loc2_.hasCustomer)
            {
               _loc2_.destroy();
            }
            _loc1_++;
         }
      }
      
      private function doManageDownloadStatus(param1:TimerEvent) : void
      {
         (param1.target as IEventDispatcher).removeEventListener(param1.type,this.doManageDownloadStatus);
         this.manageDownloadServiceProvider();
         if(this.hasEventListener(PlayerEvent.BUFFER_READY))
         {
            if(this.getIsBufferReady(this._curMilliSecond))
            {
               this.dispatchEvent(new PlayerEvent(PlayerEvent.BUFFER_READY));
            }
         }
         if(this._sound_download_queue.length <= 0 && this._downloadServiceProviders.length <= 0)
         {
            this.stopTimer();
         }
         else
         {
            this._timer.addEventListener(TimerEvent.TIMER,this.doManageDownloadStatus);
         }
      }
      
      public function getIsBufferReadyByTimeRange(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:SoundItem = null;
         if(param2 > this._movieDuration)
         {
            param2 = this._movieDuration;
         }
         _loc3_ = 0;
         while(_loc3_ < this._sounds.length)
         {
            _loc4_ = this._sounds.getValueByIndex(_loc3_);
            if(UtilPlain.isTimeRangesOverlap(param1,param2,_loc4_.startTime,_loc4_.endTime))
            {
               if(!_loc4_.isSoundBufferReadyAtTime(param2 - _loc4_.startTime))
               {
                  return false;
               }
            }
            _loc3_++;
         }
         return true;
      }
      
      private function getIsBufferReady(param1:Number) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:SoundItem = null;
         var _loc4_:DownloadServiceProvider = null;
         _loc2_ = 0;
         while(_loc2_ < this._sound_download_queue.length)
         {
            _loc3_ = this._sound_download_queue[_loc2_] as SoundItem#39;
            if(!this.checkBufferReady(_loc3_,param1,this._movieDuration))
            {
               return false;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._downloadServiceProviders.length)
         {
            _loc4_ = this._downloadServiceProviders[_loc2_] as DownloadServiceProvider;
            _loc3_ = _loc4_.currentCustomer;
            if(_loc3_ != null && !this.checkBufferReady(_loc3_,param1,this._movieDuration))
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      private function checkBufferReady(param1:SoundItem#39, param2:Number, param3:Number) : Boolean
      {
         if(param1.endTime < param2)
         {
            return true;
         }
         if(param1.startTime > param2 + AnimeConstants.MIN_TIME_TO_BUFFER)
         {
            return true;
         }
         var _loc4_:Number = AnimeConstants.MIN_TIME_TO_BUFFER + param2;
         if(_loc4_ > param3)
         {
            _loc4_ = param3;
         }
         if(param1.isSoundBufferReadyAtTime(_loc4_ - param1.startTime))
         {
            return true;
         }
         return false;
      }
      
      private function manageDownloadServiceProvider() : void
      {
         var _loc1_:int = 0;
         var _loc2_:DownloadServiceProvider = null;
         var _loc3_:SoundItem = null;
         _loc1_ = 0;
         while(_loc1_ < this._downloadServiceProviders.length)
         {
            _loc2_ = this._downloadServiceProviders[_loc1_] as DownloadServiceProvider;
            if(_loc2_.hasCustomer && _loc2_.isCustomerBufferReady)
            {
               if(_loc2_.currentCustomer is StreamSoundItem)
               {
                  this._sound_download_queue.push(_loc2_.currentCustomer);
               }
               _loc2_.stopService();
            }
            if(!_loc2_.hasCustomer && this._sound_download_queue.length > 0)
            {
               _loc3_ = this._sound_download_queue.shift() as SoundItem#39;
               _loc2_.startService(_loc3_);
            }
            _loc1_++;
         }
      }
      
      public function reorganizeCustomerQueue(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:StreamSoundItem = null;
         var _loc5_:VideoStreamSoundItem = null;
         this._curMilliSecond = param1;
         this._sound_download_queue.sort(this.sortCustomerInQueue);
         var _loc3_:int = 0;
         while(_loc3_ < this._sounds.length)
         {
            if(this._sounds.getValueByIndex(_loc3_) is StreamSoundItem)
            {
               _loc4_ = this._sounds.getValueByIndex(_loc3_);
               if(_loc4_.isConnected)
               {
                  _loc2_ = Math.max(param1 - _loc4_.startTime,0) / 1000;
                  _loc4_.seek(_loc2_);
               }
            }
            else if(this._sounds.getValueByIndex(_loc3_) is VideoStreamSoundItem)
            {
               _loc5_ = this._sounds.getValueByIndex(_loc3_);
               if(_loc5_.isConnected)
               {
                  _loc2_ = Math.max(param1 - _loc5_.startTime,0) / 1000;
                  _loc5_.seek(_loc2_);
               }
            }
            _loc3_++;
         }
      }
      
      private function sortCustomerInQueue(param1:SoundItem#39, param2:SoundItem#39) : Number
      {
         if(param1.startTime <= this._curMilliSecond && param1.endTime >= this._curMilliSecond)
         {
            return -1;
         }
         if(param2.startTime <= this._curMilliSecond && param2.endTime >= this._curMilliSecond)
         {
            return 1;
         }
         if(param1.startTime > this._curMilliSecond && this._curMilliSecond > param2.endTime)
         {
            return -1;
         }
         if(param2.startTime > this._curMilliSecond && this._curMilliSecond > param1.endTime)
         {
            return 1;
         }
         if(param1.startTime < param2.startTime)
         {
            return -1;
         }
         if(param2.startTime < param1.startTime)
         {
            return 1;
         }
         if(param1.endTime < param2.endTime)
         {
            return -1;
         }
         if(param2.endTime < param1.endTime)
         {
            return 1;
         }
         return 0;
      }
      
      private function onLoadError(param1:Event) : void
      {
         (param1.target as IEventDispatcher).removeEventListener(param1.type,this.onLoadError);
      }
      
      private function doDrawDownloadStatus(param1:Event) : void
      {
         (param1.target as IEventDispatcher).removeEventListener(param1.type,this.doDrawDownloadStatus);
      }
   }
}

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

class SoundItem#39 extends EventDispatcher
{
    
   
   public var startTime:Number;
   
   public var endTime:Number;
   
   public var trimStartTime:Number = 0;
   
   function SoundItem#39()
   {
      super();
   }
   
   public function isSoundBufferReadyAtTime(param1:Number) : Boolean
   {
      return false;
   }
   
   protected function onSoundLoadedError(param1:Event) : void
   {
      (param1.target as IEventDispatcher).removeEventListener(param1.type,this.onSoundLoadedError);
   }
   
   public function load() : void
   {
   }
}

import anifire.interfaces.ISoundAsset;
import anifire.sound.SoundHelper;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

class ProgressiveSoundItem extends SoundItem#39
{
    
   
   private var _isSoundFullyDownloaded:Boolean = false;
   
   private var _urlRequest:URLRequest;
   
   private var _animeSound:ISoundAsset;
   
   function ProgressiveSoundItem()
   {
      super();
   }
   
   public function get animeSound() : ISoundAsset
   {
      return this._animeSound;
   }
   
   private function onSoundFullyDownloaded(param1:Event) : void
   {
      (param1.target as IEventDispatcher).removeEventListener(param1.type,this.onSoundFullyDownloaded);
      this._isSoundFullyDownloaded = true;
   }
   
   override public function isSoundBufferReadyAtTime(param1:Number) : Boolean
   {
      return SoundHelper.isSoundBufferReadyAtTime(this._animeSound.sound,param1,this._isSoundFullyDownloaded);
   }
   
   public function init(param1:URLRequest, param2:Number, param3:Number, param4:ISoundAsset, param5:Number) : void
   {
      this.startTime = param2;
      this.endTime = param3;
      this.trimStartTime = param5;
      this._animeSound = param4;
      this._urlRequest = param1;
   }
   
   override public function load() : void
   {
      if(this._animeSound)
      {
         this._animeSound.addEventListener(Event.COMPLETE,this.onSoundFullyDownloaded);
         this._animeSound.addEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadedError);
         this._animeSound.load();
      }
   }
   
   override protected function onSoundLoadedError(param1:Event) : void
   {
      (param1.target as IEventDispatcher).removeEventListener(param1.type,this.onSoundLoadedError);
      this._isSoundFullyDownloaded = true;
   }
}

import anifire.sound.NetStreamController;
import anifire.sound.SoundHelper;

class StreamSoundItem extends SoundItem#39
{
    
   
   private var _netStreamController:NetStreamController = null;
   
   private var _url:String;
   
   private var _filename:String;
   
   function StreamSoundItem()
   {
      super();
   }
   
   public function get url() : String
   {
      return this._url;
   }
   
   public function get filename() : String
   {
      return this._filename;
   }
   
   public function get netStreamController() : NetStreamController
   {
      return this._netStreamController;
   }
   
   override public function isSoundBufferReadyAtTime(param1:Number) : Boolean
   {
      return SoundHelper.isStreamSoundBufferReadyAtTime(this._netStreamController,param1);
   }
   
   public function get isConnected() : Boolean
   {
      return this._netStreamController.netConnectionStatus == NetStreamController.CONNECT_STATE__CONNECTED?true:false;
   }
   
   public function seek(param1:Number) : void
   {
      this._netStreamController.seek(param1);
   }
   
   public function init(param1:String, param2:String, param3:NetStreamController, param4:Number, param5:Number) : void
   {
      this.startTime = param4;
      this.endTime = param5;
      this._netStreamController = param3;
      this._url = param1;
      this._filename = param2;
   }
   
   override public function load() : void
   {
      this.netStreamController.load(this.url,this.filename);
   }
}

import anifire.sound.SoundHelper;
import anifire.sound.VideoNetStreamController;

class VideoStreamSoundItem extends SoundItem#39
{
    
   
   private var _videoNetStreamController:VideoNetStreamController = null;
   
   private var _url:String;
   
   function VideoStreamSoundItem()
   {
      super();
   }
   
   public function get url() : String
   {
      return this._url;
   }
   
   public function get videoNetStreamController() : VideoNetStreamController
   {
      return this._videoNetStreamController;
   }
   
   override public function isSoundBufferReadyAtTime(param1:Number) : Boolean
   {
      return SoundHelper.isVideoBufferReadyAtTime(this.videoNetStreamController,param1);
   }
   
   public function get isConnected() : Boolean
   {
      return this._videoNetStreamController.netConnectionStatus == VideoNetStreamController.CONNECT_STATE__CONNECTED?true:false;
   }
   
   public function seek(param1:Number) : void
   {
      this._videoNetStreamController.seek(param1);
   }
   
   public function init(param1:String, param2:VideoNetStreamController, param3:Number, param4:Number) : void
   {
      this.startTime = param3;
      this.endTime = param4;
      this._videoNetStreamController = param2;
      this._url = param1;
   }
   
   override public function load() : void
   {
      this.videoNetStreamController.load(this.url);
   }
}

import anifire.util.UtilErrorLogger;

class DownloadServiceProvider
{
    
   
   private var _soundItem:SoundItem#39 = null;
   
   function DownloadServiceProvider()
   {
      super();
   }
   
   public function get currentCustomer() : SoundItem#39
   {
      return this._soundItem;
   }
   
   public function get hasCustomer() : Boolean
   {
      return this._soundItem == null?false:true;
   }
   
   public function get isCustomerBufferReady() : Boolean
   {
      return this._soundItem.isSoundBufferReadyAtTime(this._soundItem.trimStartTime + this._soundItem.endTime - this._soundItem.startTime);
   }
   
   public function startService(param1:SoundItem#39) : void
   {
      if(param1)
      {
         this._soundItem = param1;
         this._soundItem.load();
      }
   }
   
   public function destroy() : void
   {
      var progressiveSoundItem:ProgressiveSoundItem = null;
      try
      {
         if(this._soundItem is ProgressiveSoundItem)
         {
            progressiveSoundItem = this._soundItem as ProgressiveSoundItem;
            if(progressiveSoundItem.animeSound.sound.isBuffering)
            {
               progressiveSoundItem.animeSound.close();
            }
         }
         return;
      }
      catch(e:Error)
      {
         UtilErrorLogger.getInstance().appendCustomError("DownloadManager:destroy",e);
         return;
      }
   }
   
   public function stopService() : void
   {
      var progressiveSoundItem:ProgressiveSoundItem = null;
      var videoSoundItem:VideoStreamSoundItem = null;
      try
      {
         if(this._soundItem is ProgressiveSoundItem)
         {
            progressiveSoundItem = this._soundItem as ProgressiveSoundItem;
            if(progressiveSoundItem != null)
            {
               if(progressiveSoundItem.animeSound.sound.bytesLoaded < progressiveSoundItem.animeSound.sound.bytesTotal)
               {
                  progressiveSoundItem.animeSound.close();
               }
            }
         }
         else if(this._soundItem is VideoStreamSoundItem)
         {
            videoSoundItem = this._soundItem as VideoStreamSoundItem;
            if(videoSoundItem.videoNetStreamController.bytesLoaded < videoSoundItem.videoNetStreamController.bytesTotal)
            {
               videoSoundItem.videoNetStreamController.close();
            }
         }
         this._soundItem = null;
         return;
      }
      catch(e:Error)
      {
         UtilErrorLogger.getInstance().appendCustomError("DownloadManager:stopService",e);
         return;
      }
   }
}
