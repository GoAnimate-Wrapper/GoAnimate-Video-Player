package anifire.player.playback
{
   import anifire.component.ActionSequence;
   import anifire.interfaces.ISequentialAction;
   import anifire.util.UtilErrorLogger;
   import anifire.util.UtilPlain;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class SequentialAction extends Action implements ISequentialAction
   {
       
      
      private var _actionSequence:ActionSequence;
      
      public function SequentialAction()
      {
         super();
         this._actionSequence = new ActionSequence();
      }
      
      public function get actionSequence() : ActionSequence
      {
         return this._actionSequence;
      }
      
      override protected function setContent(param1:Sprite) : void
      {
         var _loc2_:MovieClip = null;
         super.setContent(param1);
         if(param1)
         {
            _loc2_ = UtilPlain.getCharacter(param1);
            if(_loc2_)
            {
               this._actionSequence.initByFrameLabels(_loc2_.currentLabels,_loc2_.totalFrames);
            }
         }
      }
      
      override protected function onEnterFrame(param1:Event) : void
      {
         var mc:MovieClip = null;
         var frame:Number = NaN;
         var e:Event = param1;
         try
         {
            if(this.getIsLoop())
            {
               mc = UtilPlain.getCharacter(this.getContent());
               if(mc && this._actionSequence.shouldChangeSubAction(mc.currentFrame))
               {
                  frame = this._actionSequence.getNextSubActionStartFrame(mc.currentFrame);
                  mc.gotoAndPlay(frame);
               }
            }
            return;
         }
         catch(e:Error)
         {
            UtilErrorLogger.getInstance().appendCustomError("SequentialAction:onEnterFrame",e);
            return;
         }
      }
      
      override public function behaviourToClipFrame(param1:Number) : Number
      {
         return this._actionSequence.behaviourToClipFrame(param1);
      }
   }
}
