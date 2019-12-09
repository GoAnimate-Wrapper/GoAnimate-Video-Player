package anifire.player.assetTransitions.views
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class AssetPopSpriteTransitionView_DotsEnterImage extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      public var dataClass:Class;
      
      public function AssetPopSpriteTransitionView_DotsEnterImage()
      {
         this.dataClass = AssetPopSpriteTransitionView_DotsEnterImage_dataClass;
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
