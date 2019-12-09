package anifire.player.sceneTransitions
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.constant.AnimeConstants;
   import anifire.player.playback.AnimeScene;
   import anifire.player.playback.GoTransition;
   import anifire.player.playback.PlayerConstant;
   import anifire.util.UtilPlain;
   import com.jumpeye.Events.FLASHEFFEvents;
   import com.jumpeye.flashEff2.core.interfaces.IFlashEffSymbolText;
   import fl.transitions.Transition;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class FlashEffTransition extends GoTransition
   {
       
      
      private var _type:String;
      
      private var _direction:uint;
      
      private var _param:Array;
      
      private var effectee:DisplayObject;
      
      private var myEffect:FlashEff2Flex;
      
      public function FlashEffTransition()
      {
         this.myEffect = new FlashEff2Flex();
         super();
      }
      
      override public function init(param1:XML, param2:AnimeScene, param3:Sprite) : Boolean
      {
         var _loc4_:Array = null;
         if(super.init(param1,param2,param3))
         {
            _loc4_ = String(param1.fx.@type).split(".");
            this._type = _loc4_[1];
            this._direction = _loc4_[2] == "in"?uint(0):uint(1);
            this._param = String(param1.fx.@param).split(",");
            return true;
         }
         return false;
      }
      
      override public function play(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Object = null;
         var _loc6_:IFlashEffSymbolText = null;
         var _loc7_:MovieClip = null;
         if(param3 <= param1 + dur)
         {
            if(param1 <= param3 && this.getBundle().numChildren == 0)
            {
               _loc4_ = (dur - 1) / AnimeConstants.FRAME_PER_SEC;
               _loc5_ = new Object();
               _loc6_ = AssetTransitionConstants.flashEffPlusParamById(this._type,1);
               _loc6_.tweenDuration = _loc4_;
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
               _loc7_ = new MovieClip();
               prevSceneCapture.x = AnimeConstants.SCREEN_X - PlayerConstant.BLEED_MARGIN;
               prevSceneCapture.y = AnimeConstants.screenY - PlayerConstant.BLEED_MARGIN;
               _loc7_.x = 0;
               _loc7_.y = 0;
               if(this._direction == Transition.IN)
               {
                  UtilPlain.switchParent(currSMC,_loc7_);
               }
               else
               {
                  _loc7_.addChild(prevSceneCapture);
               }
               if(!currSMC.contains(this.getBundle()))
               {
                  if(this._direction == Transition.IN)
                  {
                     currSMC.addChildAt(this.getBundle(),0);
                  }
                  else
                  {
                     currSMC.addChild(this.getBundle());
                  }
               }
               UtilPlain.removeAllSon(_bundle);
               if(this._direction == Transition.IN)
               {
                  this.getBundle().addChild(prevSceneCapture);
                  currSMC.addChild(_loc7_);
               }
               else
               {
                  this.myEffect = new FlashEff2Flex();
                  this.getBundle().addChild(_loc7_);
                  this.getBundle().addChild(this.myEffect);
               }
               this.getBundle().x = 0;
               this.getBundle().y = 0;
               this.getBundle().alpha = 1;
               if(_loc7_.stage)
               {
                  this.myEffect.hideTransition = _loc6_;
                  this.myEffect.hideDelay = 0;
                  this.myEffect.addEventListener(FLASHEFFEvents.TRANSITION_END,this.transitionEndHandler);
                  this.myEffect.target = _loc7_ as DisplayObject;
               }
            }
         }
      }
      
      private function transitionEndHandler(param1:Event) : void
      {
      }
   }
}
