package anifire.player.whiteboard
{
   import anifire.constant.ServerConstants;
   import anifire.managers.AppConfigManager;
   import anifire.util.FontManager;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class FontMaskLoader extends URLLoader
   {
      
      public static const WHITEBOARD_FONT_LIST:Array = ["Claire Hand","Blambot Casual","Coming Soon","Bangers","Caveat","Walter","Patrick Hand"];
       
      
      private const FONT_MASK_FILE_EXT:String = ".wbf.amf";
      
      private var _fontFamily:String;
      
      public function FontMaskLoader(param1:URLRequest = null)
      {
         super(param1);
      }
      
      public function loadFontMask(param1:String) : void
      {
         if(this._fontFamily)
         {
            return;
         }
         this._fontFamily = param1;
         var _loc2_:RegExp = new RegExp(ServerConstants.FLASHVAR_CLIENT_THEME_PLACEHOLDER,"g");
         var _loc3_:String = AppConfigManager.instance.getValue(ServerConstants.FLASHVAR_CLIENT_THEME_PATH);
         _loc3_ = _loc3_.replace(_loc2_,"go/font/mask/" + FontManager.getFontManager().nameToFileName(param1) + this.FONT_MASK_FILE_EXT);
         var _loc4_:URLRequest = new URLRequest(_loc3_);
         this.dataFormat = URLLoaderDataFormat.BINARY;
         this.load(_loc4_);
      }
      
      public function get fontFamily() : String
      {
         return this._fontFamily;
      }
   }
}
