package anifire.player.assetTransitions.views
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class AssetPopSpriteTransitionView_StarExitImage extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      public var dataClass:Class;
      
      public function AssetPopSpriteTransitionView_StarExitImage()
      {
         this.dataClass = AssetPopSpriteTransitionView_StarExitImage_dataClass;
         super();
         initialWidth = 11000 / 20;
         initialHeight = 8000 / 20;
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
