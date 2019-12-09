package anifire.player.skins
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class BigPlayButtonSkin__embed_mxml__styles_images_player_stage_play_init_swf_1937767806 extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      public var dataClass:Class;
      
      public function BigPlayButtonSkin__embed_mxml__styles_images_player_stage_play_init_swf_1937767806()
      {
         this.dataClass = BigPlayButtonSkin__embed_mxml__styles_images_player_stage_play_init_swf_1937767806_dataClass;
         super();
         initialWidth = 2000 / 20;
         initialHeight = 2000 / 20;
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
