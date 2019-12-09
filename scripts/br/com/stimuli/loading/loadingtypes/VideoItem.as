package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.ProgressEvent;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   
   public class VideoItem extends LoadingItem
   {
       
      
      private var nc:NetConnection;
      
      public var stream:NetStream;
      
      public var dummyEventTrigger:Sprite;
      
      public var _checkPolicyFile:Boolean;
      
      public var pausedAtStart:Boolean = false;
      
      public var _metaData:Object;
      
      public var _canBeginStreaming:Boolean = false;
      
      public function VideoItem(param1:URLRequest, param2:String, param3:String)
      {
         specificAvailableProps = [BulkLoader.CHECK_POLICY_FILE,BulkLoader.PAUSED_AT_START];
         super(param1,param2,param3);
         _bytesTotal = _bytesLoaded = 0;
      }
      
      override public function _parseOptions(param1:Object) : Array
      {
         this.pausedAtStart = param1[BulkLoader.PAUSED_AT_START] || false;
         this._checkPolicyFile = param1[BulkLoader.CHECK_POLICY_FILE] || false;
         return super._parseOptions(param1);
      }
      
      override public function load() : void
      {
         super.load();
         this.nc = new NetConnection();
         this.nc.connect(null);
         this.stream = new NetStream(this.nc);
         this.stream.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false,0,true);
         this.stream.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false,0,true);
         this.dummyEventTrigger = new Sprite();
         this.dummyEventTrigger.addEventListener(Event.ENTER_FRAME,this.createNetStreamEvent,false,0,true);
         var customClient:Object = new Object();
         customClient.onCuePoint = function(... rest):void
         {
         };
         customClient.onMetaData = this.onVideoMetadata;
         customClient.onPlayStatus = function(... rest):void
         {
         };
         this.stream.client = customClient;
         try
         {
            this.stream.play(url.url,this._checkPolicyFile);
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
         }
         this.stream.seek(0);
      }
      
      public function createNetStreamEvent(param1:Event) : void
      {
         var _loc2_:Event = null;
         var _loc3_:Event = null;
         var _loc4_:ProgressEvent = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(_bytesTotal == _bytesLoaded && _bytesTotal > 8)
         {
            if(this.dummyEventTrigger)
            {
               this.dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,this.createNetStreamEvent,false);
            }
            this.fireCanBeginStreamingEvent();
            _loc2_ = new Event(Event.COMPLETE);
            this.onCompleteHandler(_loc2_);
         }
         else if(_bytesTotal == 0 && this.stream && this.stream.bytesTotal > 4)
         {
            _loc3_ = new Event(Event.OPEN);
            this.onStartedHandler(_loc3_);
            _bytesLoaded = this.stream.bytesLoaded;
            _bytesTotal = this.stream.bytesTotal;
         }
         else if(this.stream)
         {
            _loc4_ = new ProgressEvent(ProgressEvent.PROGRESS,false,false,this.stream.bytesLoaded,this.stream.bytesTotal);
            if(this.isVideo() && this.metaData && !this._canBeginStreaming)
            {
               _loc5_ = getTimer() - responseTime;
               if(_loc5_ > 100)
               {
                  _loc6_ = bytesLoaded / (_loc5_ / 1000);
                  _bytesRemaining = _bytesTotal - bytesLoaded;
                  _loc7_ = _bytesRemaining / (_loc6_ * 0.8);
                  _loc8_ = this.metaData.duration - this.stream.bufferLength;
                  if(_loc8_ > _loc7_)
                  {
                     this.fireCanBeginStreamingEvent();
                  }
               }
            }
            super.onProgressHandler(_loc4_);
         }
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         _content = this.stream;
         super.onCompleteHandler(param1);
      }
      
      override public function onStartedHandler(param1:Event) : void
      {
         _content = this.stream;
         if(this.pausedAtStart && this.stream)
         {
            this.stream.pause();
         }
         super.onStartedHandler(param1);
      }
      
      override public function stop() : void
      {
         try
         {
            if(this.stream)
            {
               this.stream.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         if(this.stream)
         {
            this.stream.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false);
            this.stream.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false);
         }
         if(this.dummyEventTrigger)
         {
            this.dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,this.createNetStreamEvent,false);
            this.dummyEventTrigger = null;
         }
      }
      
      override public function isVideo() : Boolean
      {
         return true;
      }
      
      override public function isStreamable() : Boolean
      {
         return true;
      }
      
      override public function destroy() : void
      {
         if(!this.stream)
         {
         }
         this.stop();
         this.cleanListeners();
         this.stream = null;
         super.destroy();
      }
      
      function onNetStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:Event = null;
         if(!this.stream)
         {
            return;
         }
         this.stream.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false);
         if(param1.info.code == "NetStream.Play.Start")
         {
            _content = this.stream;
            _loc2_ = new Event(Event.OPEN);
            this.onStartedHandler(_loc2_);
         }
         else if(param1.info.code == "NetStream.Play.StreamNotFound")
         {
            onErrorHandler(_createErrorEvent(new Error("[VideoItem] NetStream not found at " + this.url.url)));
         }
      }
      
      function onVideoMetadata(param1:*) : void
      {
         this._metaData = param1;
      }
      
      public function get metaData() : Object
      {
         return this._metaData;
      }
      
      public function get checkPolicyFile() : Object
      {
         return this._checkPolicyFile;
      }
      
      private function fireCanBeginStreamingEvent() : void
      {
         if(this._canBeginStreaming)
         {
            return;
         }
         this._canBeginStreaming = true;
         var _loc1_:Event = new Event(BulkLoader.CAN_BEGIN_PLAYING);
         dispatchEvent(_loc1_);
      }
      
      public function get canBeginStreaming() : Boolean
      {
         return this._canBeginStreaming;
      }
   }
}
