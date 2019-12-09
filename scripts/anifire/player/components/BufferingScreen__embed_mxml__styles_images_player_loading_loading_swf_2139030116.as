package anifire.player.components
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class BufferingScreen__embed_mxml__styles_images_player_loading_loading_swf_2139030116 extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      public var dataClass:Class;
      
      public function BufferingScreen__embed_mxml__styles_images_player_loading_loading_swf_2139030116()
      {
         this.dataClass = BufferingScreen__embed_mxml__styles_images_player_loading_loading_swf_2139030116_dataClass;
         super();
         initialWidth = 1000 / 20;
         initialHeight = 1000 / 20;
      }
      
      override public function get movieClipData() : ByteArray
      {
         if(bytes == null)
         {
            bytes = ByteArray(new this.dataClass());
         }
         return bytes;
      }
   }
}
