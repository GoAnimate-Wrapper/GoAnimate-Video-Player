package anifire.player.sceneEffects
{
   import anifire.constant.AnimeConstants;
   import anifire.effect.EarthquakeEffect;
   import anifire.effect.EffectMgr;
   import anifire.player.playback.AnimeScene;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   
   public class HoveringEffectAsset extends ProgramEffectAsset
   {
       
      
      private var _originalPos:Point;
      
      private var _effectSeq:Array;
      
      public function HoveringEffectAsset()
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
         var _loc5_:EarthquakeEffect = EffectMgr.getEffectByXML(_loc4_) as EarthquakeEffect;
         this.effectee = param3;
         this.originalPos = new Point(this.effectee.x,this.effectee.y);
         this._sttime = param1["st"];
         this._edtime = param1["et"];
         var _loc6_:String = "0,-0.2,-0.35,-0.5,-0.7,-0.85,-1,-1.2,-1.35,-1.5,-1.7,-1.85,-2,-2.2,-2.35,-2.5,-2.7,-2.85,-3,-3.2,-3.35,-3.5,-3.7,-3.85,-3.7,-3.6,-3.45,-3.3,-3.15,-3.05,-2.9,-2.75,-2.6,-2.5,-2.35,-2.2,-2.1,-1.95,-1.8,-1.65,-1.55,-1.4,-1.25,-1.1,-1,-0.85,-0.7,-0.6,-0.45,-0.3,-0.15,-0.05,0.1,0.25,0.4,0.5,0.65,0.8,0.9,1.05,1.2,1.35,1.45,1.6,1.75,1.9,2,2.15,2.1,2.05,2,2,1.95,1.9,1.85,1.8,1.75,1.7,1.7,1.65,1.6,1.55,1.5,1.45,1.45,1.4,1.35,1.3,1.25,1.2,1.15,1.15,1.1,1.05,1,0.95,0.9,0.85,0.85,0.8,0.75,0.7,0.65,0.6,0.6,0.55,0.5,0.45,0.4,0.35,0.3,0.3,0.25,0.2,0.15,0.15";
         this._effectSeq = _loc6_.split(",");
      }
      
      override public function play(param1:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:Number = 20;
         var _loc3_:Boolean = true;
         var _loc4_:Number = param1 - this.startFrame;
         if(!(this._sttime == 0 && this._edtime == 0 || _loc4_ >= this._sttime && _loc4_ <= this._edtime))
         {
            _loc3_ = false;
         }
         if(param1 <= this.startFrame + this.length && _loc3_)
         {
            _loc5_ = 1.05;
            _loc6_ = (_loc5_ - 1) * AnimeConstants.SCREEN_HEIGHT / 2;
            _loc8_ = this._effectSeq[_loc4_ % this._effectSeq.length];
            if(Math.abs(_loc8_) >= _loc6_)
            {
               if(_loc8_ < 0)
               {
                  _loc7_ = -_loc6_;
               }
               else
               {
                  _loc7_ = _loc6_;
               }
            }
            else
            {
               _loc7_ = _loc8_;
            }
            this.effectee.y = _loc7_;
         }
         else
         {
            this.effectee.x = 0;
            this.effectee.y = 0;
            this.effectee.scaleX = 1;
            this.effectee.scaleY = 1;
         }
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
