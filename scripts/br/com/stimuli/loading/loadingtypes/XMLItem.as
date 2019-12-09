package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class XMLItem extends LoadingItem
   {
       
      
      public var loader:URLLoader;
      
      public function XMLItem(param1:URLRequest, param2:String, param3:String)
      {
         super(param1,param2,param3);
      }
      
      override public function _parseOptions(param1:Object) : Array
      {
         return super._parseOptions(param1);
      }
      
      override public function load() : void
      {
         super.load();
         this.loader = new URLLoader();
         this.loader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         this.loader.addEventListener(Event.COMPLETE,this.onCompleteHandler,false,0,true);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false,0,true);
         this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false,0,true);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,super.onSecurityErrorHandler,false,0,true);
         this.loader.addEventListener(Event.OPEN,this.onStartedHandler,false,0,true);
         try
         {
            this.loader.load(url);
            return;
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
            return;
         }
      }
      
      override public function onErrorHandler(param1:ErrorEvent) : void
      {
         super.onErrorHandler(param1);
      }
      
      override public function onStartedHandler(param1:Event) : void
      {
         super.onStartedHandler(param1);
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         var evt:Event = param1;
         try
         {
            _content = new XML(this.loader.data);
         }
         catch(e:Error)
         {
            _content = null;
            status = STATUS_ERROR;
            dispatchEvent(_createErrorEvent(e));
         }
         super.onCompleteHandler(evt);
      }
      
      override public function stop() : void
      {
         try
         {
            if(this.loader)
            {
               this.loader.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         if(this.loader)
         {
            this.loader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler,false);
            this.loader.removeEventListener(Event.COMPLETE,this.onCompleteHandler,false);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false);
            this.loader.removeEventListener(BulkLoader.OPEN,this.onStartedHandler,false);
            this.loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,super.onSecurityErrorHandler,false);
         }
      }
      
      override public function isText() : Boolean
      {
         return true;
      }
      
      override public function destroy() : void
      {
         this.stop();
         this.cleanListeners();
         _content = null;
         this.loader = null;
      }
   }
}
