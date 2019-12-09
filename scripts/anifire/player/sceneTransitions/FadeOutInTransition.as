package anifire.player.sceneTransitions
{
   import anifire.constant.AnimeConstants;
   import anifire.player.playback.AnimeScene;
   import anifire.player.playback.GoTransition;
   import anifire.player.playback.PlayerConstant;
   import anifire.util.UtilPlain;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class FadeOutInTransition extends GoTransition
   {
       
      
      private var effectee:DisplayObject;
      
      private var _param:Array;
      
      public function FadeOutInTransition()
      {
         super();
      }
      
      override public function init(param1:XML, param2:AnimeScene, param3:Sprite) : Boolean
      {
         if(super.init(param1,param2,param3))
         {
            this._param = String(param1.fx.@param).split(",");
            return true;
         }
         return false;
      }
      
      override public function play(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:BitmapData = null;
         var _loc6_:Bitmap = null;
         var _loc7_:Number = NaN;
         if(param3 <= param1 + dur)
         {
            if(param1 <= param3 && this.getBundle().numChildren == 0)
            {
               if(prevScene)
               {
                  prevSceneCapture.bitmapData = prevScene.endSceneCapture;
                  prevSceneCapture.width = AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2;
                  prevSceneCapture.height = AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2;
               }
               else
               {
                  prevSceneCapture.bitmapData = new BitmapData(AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2,AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2,false,0);
               }
               prevSceneCapture.x = AnimeConstants.SCREEN_X - PlayerConstant.BLEED_MARGIN;
               prevSceneCapture.y = AnimeConstants.screenY - PlayerConstant.BLEED_MARGIN;
               if(!currSMC.contains(this.getBundle()))
               {
                  currSMC.addChild(this.getBundle());
               }
               _bundle.addChild(prevSceneCapture);
               _bundle.x = 0;
               _bundle.y = 0;
               _bundle.alpha = 1;
               _loc4_ = 0;
               if(this._param)
               {
                  _loc4_ = uint(this._param[0]);
               }
               _loc5_ = new BitmapData(AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2,AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2,false,_loc4_);
               _loc6_ = new Bitmap(_loc5_);
               _loc6_.alpha = 0;
               _loc6_.x = AnimeConstants.SCREEN_X - PlayerConstant.BLEED_MARGIN;
               _loc6_.y = AnimeConstants.screenY - PlayerConstant.BLEED_MARGIN;
               this.effectee = _loc6_;
               _bundle.addChild(_loc6_);
            }
            else if(param3 < param1 + dur)
            {
               _loc7_ = (param3 - param1) / ((dur - 1) / 2);
               if(_loc7_ > 1)
               {
                  _loc7_ = Math.abs(_loc7_ - 2);
               }
               this.effectee.alpha = _loc7_;
               if(param1 + Math.round(dur / 2) == param3)
               {
                  _bundle.removeChildAt(0);
               }
            }
            else if(param3 == param1 + dur)
            {
               UtilPlain.removeAllSon(_bundle);
            }
         }
      }
   }
}
