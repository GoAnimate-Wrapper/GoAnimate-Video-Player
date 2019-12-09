package anifire.player.sceneEffects
{
   import anifire.effect.EffectMgr;
   import anifire.player.playback.AnimeScene;
   import com.gskinner.geom.ColorMatrix;
   import flash.display.DisplayObjectContainer;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   
   public class GrayScaleEffectAsset extends ProgramEffectAsset
   {
       
      
      private var _originalPos:Point;
      
      private var _active:Boolean;
      
      public function GrayScaleEffectAsset()
      {
         super();
      }
      
      private function get originalPos() : Point
      {
         return this._originalPos;
      }
      
      private function set originalPos(param1:Point) : void
      {
         this._originalPos = param1;
      }
      
      public function init(param1:XML, param2:AnimeScene, param3:DisplayObjectContainer) : void
      {
         initAsset(param1.@id,param1.@index,param2);
         var _loc4_:XML = param1.child(EffectMgr.XML_NODE_TAG)[0];
         initEffectAsset(EffectMgr.getType(_loc4_));
         this.effectee = param3;
         this.originalPos = new Point(this.effectee.x,this.effectee.y);
         this._sttime = param1["st"];
         this._edtime = param1["et"];
         this._active = false;
      }
      
      override public function propagateSceneState(param1:int) : void
      {
         if(param1 == AnimeScene.STATE_ACTION)
         {
            this.setState(STATE_ACTION);
         }
         else if(param1 == AnimeScene.STATE_NULL)
         {
            this.setState(STATE_NULL);
         }
      }
      
      override protected function setState(param1:int) : void
      {
         if(param1 == STATE_ACTION || param1 == STATE_MOTION)
         {
         }
         super.setState(param1);
      }
      
      override public function play(param1:Number) : void
      {
         var _loc5_:Array = null;
         var _loc6_:ColorMatrixFilter = null;
         var _loc2_:Boolean = true;
         var _loc3_:ColorMatrix = new ColorMatrix();
         var _loc4_:Number = param1 - this.startFrame;
         if(!(this._sttime == 0 && this._edtime == 0 || _loc4_ >= this._sttime && _loc4_ <= this._edtime))
         {
            _loc2_ = false;
         }
         if(param1 <= this.startFrame + this.length && _loc2_)
         {
            if(!this._active)
            {
               _loc5_ = [0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0];
               _loc6_ = new ColorMatrixFilter(_loc5_);
               this.effectee.filters = [_loc6_];
               this._active = true;
            }
         }
         else if(this._active)
         {
            _loc3_.adjustColor(0,0,0,0);
            this.effectee.filters = [new ColorMatrixFilter(_loc3_)];
            this._active = false;
         }
      }
      
      override public function restore() : void
      {
         var _loc1_:ColorMatrix = new ColorMatrix();
         _loc1_.adjustColor(0,0,0,0);
         this.effectee.filters = [new ColorMatrixFilter(_loc1_)];
         this._active = false;
      }
      
      override public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
      {
         this.play(param2);
      }
      
      override public function pause() : void
      {
      }
      
      override public function resume() : void
      {
      }
      
      override public function destroy(param1:Boolean = false) : void
      {
      }
   }
}
