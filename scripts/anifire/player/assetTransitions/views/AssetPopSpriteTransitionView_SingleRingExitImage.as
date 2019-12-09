package anifire.player.assetTransitions.views
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class AssetPopSpriteTransitionView_SingleRingExitImage extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      public var dataClass:Class;
      
      public function AssetPopSpriteTransitionView_SingleRingExitImage()
      {
         this.dataClass = AssetPopSpriteTransitionView_SingleRingExitImage_dataClass;
         super();
         initialWidth = 3000 / 20;
         initialHeight = 3000 / 20;
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
