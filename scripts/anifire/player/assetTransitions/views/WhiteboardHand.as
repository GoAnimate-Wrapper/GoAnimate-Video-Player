package anifire.player.assetTransitions.views
{
   import anifire.player.managers.WhiteboardHandManager;
   import flash.display.Sprite;
   
   public class WhiteboardHand extends Sprite
   {
       
      
      private var _clipLoader:WhiteboardHandLoader;
      
      private var _whiteboardHandStyle:int = 0;
      
      private var _isHand:Boolean;
      
      public function WhiteboardHand()
      {
         super();
      }
      
      public function switchHand(param1:int, param2:Boolean = true) : void
      {
         if(this._whiteboardHandStyle != param1 || param2 != this._isHand)
         {
            this._whiteboardHandStyle = param1;
            this._isHand = param2;
            if(this._clipLoader)
            {
               this._clipLoader.visible = false;
               removeChild(this._clipLoader);
            }
            this._clipLoader = WhiteboardHandManager.instance.getClipLoader(this._whiteboardHandStyle,this._isHand);
            if(this._clipLoader)
            {
               this._clipLoader.visible = true;
               addChild(this._clipLoader);
            }
         }
      }
      
      public function pause() : void
      {
      }
      
      public function resume() : void
      {
      }
   }
}
