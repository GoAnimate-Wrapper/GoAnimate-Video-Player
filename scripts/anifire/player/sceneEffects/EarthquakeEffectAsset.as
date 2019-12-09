package anifire.player.sceneEffects
{
   import anifire.effect.EarthquakeEffect;
   import anifire.effect.EffectMgr;
   import anifire.player.playback.AnimeScene;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   
   public class EarthquakeEffectAsset extends ProgramEffectAsset
   {
       
      
      private var _originalPos:Point;
      
      public function EarthquakeEffectAsset()
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
      }
      
      override public function play(param1:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:Number = 20;
         var _loc3_:Boolean = true;
         var _loc4_:Number = param1 - this.startFrame;
         if(!(this._sttime == 0 && this._edtime == 0 || _loc4_ >= this._sttime && _loc4_ <= this._edtime))
         {
            _loc3_ = false;
         }
         if(param1 < this.startFrame + this.length - 1 && _loc3_)
         {
            this.effectee.x = -10 + Math.round(Math.random() * _loc2_ - _loc2_ / 2);
            this.effectee.y = -10 + Math.round(Math.random() * _loc2_ - _loc2_ / 2);
            _loc5_ = 1.05;
            this.effectee.scaleX = _loc5_;
            this.effectee.scaleY = _loc5_;
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
