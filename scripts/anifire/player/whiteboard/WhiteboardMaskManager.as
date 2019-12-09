package anifire.player.whiteboard
{
   import anifire.whiteboard.models.WhiteboardFontModel;
   import anifire.whiteboard.models.WhiteboardModel;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class WhiteboardMaskManager extends EventDispatcher
   {
      
      private static var _instance:WhiteboardMaskManager;
       
      
      private var _whiteboardFontModelList:Object;
      
      private var _fontMaskLoaderList:Object;
      
      private var _whiteboardModelList:Object;
      
      private var _customMaskLoaderList:Object;
      
      public function WhiteboardMaskManager(param1:IEventDispatcher = null)
      {
         this._whiteboardFontModelList = new Object();
         this._fontMaskLoaderList = new Object();
         this._whiteboardModelList = new Object();
         this._customMaskLoaderList = new Object();
         super(param1);
      }
      
      public static function get instance() : WhiteboardMaskManager
      {
         if(!_instance)
         {
            _instance = new WhiteboardMaskManager();
         }
         return _instance;
      }
      
      public function getFontModel(param1:String) : WhiteboardFontModel
      {
         if(this._whiteboardFontModelList[param1])
         {
            return this._whiteboardFontModelList[param1];
         }
         return null;
      }
      
      public function getWhiteboardModel(param1:String) : WhiteboardModel
      {
         if(this._whiteboardModelList[param1])
         {
            return this._whiteboardModelList[param1];
         }
         return null;
      }
      
      public function addFontModel(param1:String, param2:WhiteboardFontModel) : void
      {
         this._whiteboardFontModelList[param1] = param2;
      }
      
      public function addModel(param1:String, param2:WhiteboardModel) : void
      {
         this._whiteboardModelList[param1] = param2;
      }
      
      public function getFontMaskLoader(param1:String) : FontMaskLoader
      {
         var _loc2_:FontMaskLoader = this._fontMaskLoaderList[param1];
         if(!_loc2_)
         {
            _loc2_ = new FontMaskLoader();
            this._fontMaskLoaderList[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function getCustomMaskLoader(param1:String) : CustomMaskLoader
      {
         var _loc2_:CustomMaskLoader = this._customMaskLoaderList[param1];
         if(!_loc2_)
         {
            _loc2_ = new CustomMaskLoader();
            this._customMaskLoaderList[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function removeFontMaskLoader(param1:String) : void
      {
         this._fontMaskLoaderList[param1] = null;
      }
      
      public function removeCustomMaskLoader(param1:String) : void
      {
         this._customMaskLoaderList[param1] = null;
      }
   }
}
