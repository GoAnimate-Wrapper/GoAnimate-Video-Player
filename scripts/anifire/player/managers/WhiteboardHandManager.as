package anifire.player.managers
{
   import anifire.constants.WhiteboardConstants;
   import anifire.player.assetTransitions.views.WhiteboardHandLoader;
   
   public class WhiteboardHandManager
   {
      
      public static const HAND_CLIP_PREFIX:String = "hand";
      
      public static const ERASER_CLIP_PREFIX:String = "eraser";
      
      private static var __instance:WhiteboardHandManager;
       
      
      private var _clipLoaders:Object;
      
      public function WhiteboardHandManager()
      {
         super();
         this._clipLoaders = {};
      }
      
      public static function get instance() : WhiteboardHandManager
      {
         if(!__instance)
         {
            __instance = new WhiteboardHandManager();
         }
         return __instance;
      }
      
      public function getClipLoader(param1:int, param2:Boolean = true) : WhiteboardHandLoader
      {
         if(param1 == WhiteboardConstants.NO_HAND)
         {
            return null;
         }
         var _loc3_:String = (!!param2?HAND_CLIP_PREFIX:ERASER_CLIP_PREFIX) + param1;
         var _loc4_:WhiteboardHandLoader = this._clipLoaders[_loc3_];
         if(!_loc4_)
         {
            _loc4_ = new WhiteboardHandLoader(param1,param2);
            this._clipLoaders[_loc3_] = _loc4_;
         }
         return _loc4_;
      }
   }
}
