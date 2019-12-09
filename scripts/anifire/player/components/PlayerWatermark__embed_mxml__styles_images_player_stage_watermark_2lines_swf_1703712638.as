package anifire.player.components
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class PlayerWatermark__embed_mxml__styles_images_player_stage_watermark_2lines_swf_1703712638 extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      public var dataClass:Class;
      
      public function PlayerWatermark__embed_mxml__styles_images_player_stage_watermark_2lines_swf_1703712638()
      {
         this.dataClass = PlayerWatermark__embed_mxml__styles_images_player_stage_watermark_2lines_swf_1703712638_dataClass;
         super();
         initialWidth = 2400 / 20;
         initialHeight = 700 / 20;
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
