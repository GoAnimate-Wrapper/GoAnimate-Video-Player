package anifire.component
{
   import anifire.constant.ServerConstants;
   import anifire.managers.AppConfigManager;
   import anifire.util.UtilHashArray;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.utils.ByteArray;
   import nochump.util.zip.ZipFile;
   
   public class ThemeLoader extends EventDispatcher
   {
      
      private static var _themeLoaders:UtilHashArray = new UtilHashArray();
      
      private static var _configManager:AppConfigManager;
       
      
      private var _themeXml:XML;
      
      private var _themeId:String;
      
      public function ThemeLoader()
      {
         super();
         _configManager = AppConfigManager.instance;
      }
      
      public static function getThemeLoader(param1:String) : ThemeLoader
      {
         return new ThemeLoader();
      }
      
      public function get xml() : XML
      {
         if(this._themeXml)
         {
            return this._themeXml.copy();
         }
         return null;
      }
      
      public function get id() : String
      {
         return this._themeId;
      }
      
      private function getThemeRequest(param1:String) : URLRequest
      {
         var _loc5_:RegExp = null;
         var _loc2_:* = param1 + "/" + param1 + ".zip";
         var _loc3_:String = _configManager.getValue(ServerConstants.FLASHVAR_STORE_PATH) as String;
         if(_loc3_ == "" || _loc3_ == null)
         {
            _loc3_ = _configManager.getValue(ServerConstants.FLASHVAR_APISERVER) as String;
            _loc3_ = _loc3_ + ("static/store/" + _loc2_);
         }
         else
         {
            _loc5_ = new RegExp(ServerConstants.FLASHVAR_STORE_PLACEHOLDER,"g");
            _loc3_ = _loc3_.replace(_loc5_,_loc2_);
         }
         var _loc4_:URLRequest = new URLRequest(_loc3_);
         _loc4_.method = URLRequestMethod.GET;
         return _loc4_;
      }
      
      public function load(param1:String) : void
      {
         this._themeId = param1;
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.onXmlLoaded);
         _loc2_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc2_.load(this.getThemeRequest(param1));
      }
      
      private function onXmlLoaded(param1:Event) : void
      {
         (param1.target as IEventDispatcher).removeEventListener(param1.type,this.onXmlLoaded);
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:ZipFile = new ZipFile(_loc2_.data as ByteArray);
         this._themeXml = new XML(_loc3_.getInput(_loc3_.getEntry("theme.xml")));
         this.dispatchEvent(param1);
      }
   }
}
