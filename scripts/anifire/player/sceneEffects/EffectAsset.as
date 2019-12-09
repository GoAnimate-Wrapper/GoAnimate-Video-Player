package anifire.player.sceneEffects
{
   import anifire.effect.EffectMgr;
   import anifire.player.events.PlayerEvent;
   import anifire.player.playback.Asset;
   import anifire.player.playback.PlayerDataStock;
   import flash.display.DisplayObjectContainer;
   
   public class EffectAsset extends Asset
   {
      
      public static const XML_TAG:String = "effectAsset";
       
      
      protected const STATE_NULL:int = 0;
      
      protected const STATE_ACTION:int = 1;
      
      protected const STATE_MOTION:int = 2;
      
      protected var _type:String;
      
      protected var _startFrame:Number;
      
      protected var _endFrame:Number;
      
      protected var _length:Number;
      
      private var _effectee:DisplayObjectContainer;
      
      public function EffectAsset()
      {
         super();
      }
      
      public static function getEffectType(param1:XML) : String
      {
         return EffectMgr.getType(param1.child(EffectMgr.XML_NODE_TAG)[0]);
      }
      
      public function get effectee() : DisplayObjectContainer
      {
         return this._effectee;
      }
      
      public function set effectee(param1:DisplayObjectContainer) : void
      {
         this._effectee = param1;
      }
      
      public function getType() : String
      {
         return this._type;
      }
      
      protected function initEffectAsset(param1:String) : void
      {
         this._type = param1;
      }
      
      public function initRemoteData(param1:PlayerDataStock) : void
      {
         this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
      }
      
      override public function propagateSceneState(param1:int) : void
      {
      }
      
      public function play(param1:Number) : void
      {
      }
      
      public function get startFrame() : Number
      {
         return this._startFrame;
      }
      
      public function set startFrame(param1:Number) : void
      {
         this._startFrame = param1;
      }
      
      public function get endFrame() : Number
      {
         return this._endFrame;
      }
      
      public function set endFrame(param1:Number) : void
      {
         this._endFrame = param1;
      }
      
      public function get length() : Number
      {
         return this._length;
      }
      
      public function set length(param1:Number) : void
      {
         this._length = param1;
      }
      
      public function prepareImage() : void
      {
      }
      
      public function restore() : void
      {
      }
      
      public function initDependency(param1:Number, param2:Number, param3:Number) : void
      {
         this._startFrame = param1;
         this._endFrame = param2;
         this._length = param3;
      }
   }
}
