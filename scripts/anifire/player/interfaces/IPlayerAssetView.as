package anifire.player.interfaces
{
   import anifire.bubble.Bubble;
   import anifire.player.playback.Asset;
   import flash.display.DisplayObject;
   
   public interface IPlayerAssetView
   {
       
      
      function get bundle() : DisplayObject;
      
      function set bundle(param1:DisplayObject) : void;
      
      function get assetView() : DisplayObject;
      
      function get bubble() : Bubble;
      
      function set bubble(param1:Bubble) : void;
      
      function get asset() : Asset;
      
      function set asset(param1:Asset) : void;
   }
}
