package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.net.URLRequest;
   
   public class SoundItem#56 extends LoadingItem
   {
       
      
      public var loader:Sound;
      
      public function SoundItem#56(param1:URLRequest, param2:String, param3:String)
      {
         specificAvailableProps = [BulkLoader.CONTEXT];
         super(param1,param2,param3);
      }
      
      override public function _parseOptions(param1:Object) : Array
      {
         _context = param1[BulkLoader.CONTEXT] || null;
         return super._parseOptions(param1);
      }
      
      override public function load() : void
      {
         super.load();
         this.loader = new Sound();
         this.loader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         this.loader.addEventListener(Event.COMPLETE,this.onCompleteHandler,false,0,true);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false,0,true);
         this.loader.addEventListener(Event.OPEN,this.onStartedHandler,false,0,true);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,super.onSecurityErrorHandler,false,0,true);
         try
         {
            this.loader.load(url,_context);
            return;
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
            return;
         }
      }
      
      override public function onStartedHandler(param1:Event) : void
      {
         _content = this.loader;
         super.onStartedHandler(param1);
      }
      
      override public function onErrorHandler(param1:ErrorEvent) : void
      {
         super.onErrorHandler(param1);
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         _content = this.loader;
         super.onCompleteHandler(param1);
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
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,super.onSecurityErrorHandler,false);
         }
      }
      
      override public function isStreamable() : Boolean
      {
         return true;
      }
      
      override public function isSound() : Boolean
      {
         return true;
      }
      
      override public function destroy() : void
      {
         this.cleanListeners();
         this.stop();
         _content = null;
         this.loader = null;
      }
   }
}
