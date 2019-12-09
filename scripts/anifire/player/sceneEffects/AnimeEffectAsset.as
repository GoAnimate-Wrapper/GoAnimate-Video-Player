package anifire.player.sceneEffects
{
   import anifire.assets.AssetImageLibrary;
   import anifire.assets.AssetImageLibraryObject;
   import anifire.effect.AnimeEffect;
   import anifire.effect.EffectMgr;
   import anifire.event.EffectEvt;
   import anifire.player.events.PlayerEvent;
   import anifire.player.playback.AnimeScene;
   import anifire.player.playback.PlayerConstant;
   import anifire.player.playback.PlayerDataStock;
   import anifire.util.UtilErrorLogger;
   import anifire.util.UtilXmlInfo;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   
   public class AnimeEffectAsset extends EffectAsset
   {
       
      
      private var _xscale:Number;
      
      private var _yscale:Number;
      
      private var _file:String;
      
      private var _firstEffect:AnimeEffectAsset;
      
      private var _isFirstEffect:Boolean;
      
      private var _prevEffect:AnimeEffectAsset;
      
      private var _nextEffect:AnimeEffectAsset;
      
      private var _effectImage:AnimeEffect;
      
      private var _effectXML:XML;
      
      public function AnimeEffectAsset()
      {
         super();
      }
      
      public static function connectEffectsBetweenScenes(param1:Vector.<EffectAsset>, param2:Vector.<EffectAsset>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:AnimeEffectAsset = null;
         var _loc7_:AnimeEffectAsset = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Vector.<EffectAsset> = null;
         if(param1 && param2 && param1.length > 0 && param2.length > 0)
         {
            _loc8_ = new Point();
            _loc9_ = new Point();
            _loc10_ = param2.concat();
            _loc5_ = param1.length;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc6_ = param1[_loc3_] as AnimeEffectAsset;
               _loc4_ = 0;
               while(_loc4_ < _loc10_.length)
               {
                  _loc7_ = _loc10_[_loc4_] as AnimeEffectAsset;
                  if(_loc6_.file != _loc7_.file)
                  {
                     _loc4_++;
                     continue;
                  }
                  _loc6_._nextEffect = _loc7_;
                  _loc7_._prevEffect = _loc6_;
                  _loc10_.splice(_loc4_,1);
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      private function get file() : String
      {
         return this._file;
      }
      
      private function set file(param1:String) : void
      {
         this._file = param1;
      }
      
      public function init(param1:XML, param2:AnimeScene, param3:PlayerDataStock, param4:DisplayObjectContainer) : Boolean
      {
         initAsset(param1.@id,param1.@index,param2);
         this._effectXML = param1.child(EffectMgr.XML_NODE_TAG)[0];
         initEffectAsset(EffectMgr.getType(this._effectXML));
         this.file = UtilXmlInfo.getZipFileNameOfEffect(param1.child("file")[0].toString());
         if(param3.getPlayerData(this.file) == null)
         {
            return false;
         }
         var _loc5_:String = UtilXmlInfo.getThemeIdFromFileName(this.file);
         if(_loc5_ != "ugc")
         {
            param3.decryptPlayerData(this.file);
         }
         this._x = param1["x"];
         this._y = param1["y"];
         this._sttime = param1["st"];
         this._edtime = param1["et"];
         this._xscale = param1["xscale"];
         this._yscale = param1["yscale"];
         this.effectee = param4;
         if(this._effectXML.@id == "black_all.swf")
         {
            this._x = this._x - 2;
            this._y = this._y - 2;
            this._xscale = 1.2;
            this._yscale = 1.2;
         }
         return true;
      }
      
      override public function initDependency(param1:Number, param2:Number, param3:Number) : void
      {
         super.initDependency(param1,param2,param3);
         if(this._prevEffect != null && this.file == this._prevEffect.file)
         {
            this._firstEffect = this._prevEffect._firstEffect;
            this._isFirstEffect = false;
            this._effectImage = this._firstEffect._effectImage;
         }
         else
         {
            this._firstEffect = this;
            this._isFirstEffect = true;
            this._effectImage = EffectMgr.getEffectByXML(this._effectXML) as AnimeEffect;
         }
      }
      
      override public function propagateSceneState(param1:int) : void
      {
         if(param1 == AnimeScene.STATE_ACTION)
         {
            this.setState(STATE_ACTION);
         }
         else if(param1 == AnimeScene.STATE_MOTION)
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
            this._effectImage.x = this._x;
            this._effectImage.y = this._y;
            this._effectImage.scaleX = this._xscale;
            this._effectImage.scaleY = this._yscale;
            effectee.addChild(this._effectImage);
            if(this._isFirstEffect)
            {
               this.resume();
            }
         }
         super.setState(param1);
      }
      
      override public function play(param1:Number) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Number = param1 - this.startFrame + 1;
         if(!(this._sttime == 0 && this._edtime == 0 || _loc3_ >= this._sttime && _loc3_ <= this._edtime))
         {
            _loc2_ = false;
         }
         if(this._effectImage.visible != _loc2_)
         {
            this._effectImage.visible = _loc2_;
            if(!_loc2_)
            {
               this.pause();
            }
            else
            {
               this.resume();
            }
         }
      }
      
      override public function pause() : void
      {
         PlayerConstant.stopFamily(this._effectImage);
      }
      
      override public function resume() : void
      {
         PlayerConstant.playFamily(this._effectImage);
      }
      
      override public function initRemoteData(param1:PlayerDataStock) : void
      {
         if(!this._isFirstEffect)
         {
            this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
            return;
         }
         var _loc2_:String = this.file;
         var _loc3_:Number = 0;
         _loc3_ = AssetImageLibrary.instance.requestImage(_loc2_,this.parentScene.id,this._effectImage);
         if(_loc3_ <= 0)
         {
            this._effectImage.addEventListener(EffectEvt.LOAD_EFFECT_COMPLETE,this.onInitRemoteDataCompleted);
            this._effectImage.shouldPauseOnLoadComplete = true;
            this._effectImage.loadEffectImage(param1.getPlayerData(this.file) as ByteArray);
         }
         else
         {
            this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
         }
      }
      
      private function onInitRemoteDataCompleted(param1:EffectEvt) : void
      {
         var _loc3_:Class = null;
         (param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitRemoteDataCompleted);
         var _loc2_:Loader = param1.getData() as Loader;
         if(_loc2_.content.loaderInfo.applicationDomain.hasDefinition("theSound"))
         {
            _loc3_ = _loc2_.content.loaderInfo.applicationDomain.getDefinition("theSound") as Class;
            this.sound = new _loc3_();
         }
         this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
      }
      
      override public function destroy(param1:Boolean = false) : void
      {
         if(this._nextEffect == null)
         {
            super.destroy();
         }
      }
      
      override public function prepareImage() : void
      {
         var imageId:Number = NaN;
         var imageName:String = null;
         var asset:AssetImageLibraryObject = null;
         try
         {
            imageId = 0;
            imageName = this.file;
            asset = AssetImageLibrary.instance.borrowImage(imageName,imageId,this.parentScene.id);
            if(asset && asset.image)
            {
               this._effectImage = asset.image as AnimeEffect;
               if(this._isFirstEffect)
               {
                  PlayerConstant.goToAndStopFamilyAt1(this._effectImage);
               }
            }
            return;
         }
         catch(e:Error)
         {
            UtilErrorLogger.getInstance().appendCustomError("AnimeEffectAsset:prepareImage",e);
            UtilErrorLogger.getInstance().error("AnimeEffectAsset:prepareImage" + e);
            return;
         }
      }
   }
}
