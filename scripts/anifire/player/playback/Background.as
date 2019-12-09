package anifire.player.playback
{
   import anifire.assets.AssetImageLibrary;
   import anifire.assets.AssetImageLibraryObject;
   import anifire.color.SelectedColor;
   import anifire.constant.AnimeConstants;
   import anifire.interfaces.IRegulatedProcess;
   import anifire.player.events.PlayerEvent;
   import anifire.util.UtilColor;
   import anifire.util.UtilCommonLoader;
   import anifire.util.UtilErrorLogger;
   import anifire.util.UtilHashSelectedColor;
   import anifire.util.UtilPlain;
   import anifire.util.UtilXmlInfo;
   import flash.display.Bitmap;
   import flash.display.BlendMode;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class Background extends Asset implements IRegulatedProcess
   {
      
      public static const STATE_ACTION:int = 1;
      
      public static const STATE_NULL:int = 0;
      
      public static const XML_TAG:String = "bg";
       
      
      private var _myLoader:UtilCommonLoader = null;
      
      private var _file:String;
      
      private var _bgInPrevScene:Background;
      
      private var _bgInNextScene:Background;
      
      private var _startFrameOffset:Number;
      
      private var _isFirstBg:Boolean;
      
      private var _firstBg:Background;
      
      private var _assetImageId:Number = 0;
      
      public function Background()
      {
         super();
      }
      
      public function get assetImageId() : Number
      {
         return this._assetImageId;
      }
      
      private function get file() : String
      {
         return this._file;
      }
      
      private function set file(param1:String) : void
      {
         this._file = param1;
      }
      
      private function getLoader() : UtilCommonLoader
      {
         return this._myLoader;
      }
      
      private function setLoader(param1:UtilCommonLoader) : void
      {
         this._myLoader = param1;
      }
      
      private function get startFrameOffset() : Number
      {
         return this._startFrameOffset;
      }
      
      private function set startFrameOffset(param1:Number) : void
      {
         this._startFrameOffset = param1;
      }
      
      public function get isFirstBg() : Boolean
      {
         return this._isFirstBg;
      }
      
      public function set isFirstBg(param1:Boolean) : void
      {
         this._isFirstBg = param1;
      }
      
      private function get firstBg() : Background
      {
         return this._firstBg;
      }
      
      private function set firstBg(param1:Background) : void
      {
         this._firstBg = param1;
      }
      
      public function init(param1:XML, param2:AnimeScene, param3:PlayerDataStock) : Boolean
      {
         var _loc5_:XML = null;
         var _loc7_:SelectedColor = null;
         _dataStock = param3;
         super.initAsset(param1.@id,param1.@index,param2);
         _bundle.blendMode = BlendMode.LAYER;
         this.file = UtilXmlInfo.getZipFileNameOfBg(param1["file"].toString());
         this.setState(Background.STATE_NULL);
         this._xs = new Array();
         this._xs.push(AnimeConstants.SCREEN_X);
         this._ys = new Array();
         this._ys.push(AnimeConstants.SCREEN_Y);
         _bundle.x = AnimeConstants.SCREEN_X;
         _bundle.y = AnimeConstants.SCREEN_Y;
         if(param1.@hidden == "Y")
         {
            _bundle.visible = false;
         }
         if(param1.hasOwnProperty("@xscale") && String(param1.@xscale) == "-1")
         {
            _bundle.scaleX = -1;
            _bundle.x = _bundle.x + AnimeConstants.SCREEN_WIDTH;
         }
         var _loc4_:String = UtilXmlInfo.getThemeIdFromFileName(this.file);
         if(_loc4_ != "ugc")
         {
            param3.decryptPlayerData(this.file);
         }
         if(param3.getPlayerData(this.file) == null)
         {
            return false;
         }
         var _loc6_:uint = 0;
         customColor = new UtilHashSelectedColor();
         _loc6_ = 0;
         while(_loc6_ < param1.child("color").length())
         {
            _loc5_ = param1.child("color")[_loc6_];
            _loc7_ = new SelectedColor(_loc5_.@r,_loc5_.attribute("oc").length() == 0?uint(uint.MAX_VALUE):uint(_loc5_.@oc),uint(_loc5_));
            addCustomColor(_loc5_.@r,_loc7_);
            _loc6_++;
         }
         return true;
      }
      
      public function startProcess(param1:Boolean = false, param2:Number = 0) : void
      {
         this.initRemoteData(_dataStock);
      }
      
      private function dispatchImageReady() : void
      {
         this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
      }
      
      public function initRemoteData(param1:PlayerDataStock) : void
      {
         var result:Number = NaN;
         var iDataStock:PlayerDataStock = param1;
         try
         {
            result = 0;
            if(this.parentScene)
            {
               result = AssetImageLibrary.instance.requestImage(this.file,this.parentScene.id,this.getLoader());
            }
            if(result > 0)
            {
               setTimeout(this.dispatchImageReady,10);
            }
            else
            {
               this.getLoader().addEventListener(Event.COMPLETE,this.onInitRemoteCompleted);
               this.getLoader().shouldPauseOnLoadBytesComplete = true;
               this.getLoader().loadBytes(iDataStock.getPlayerData(this.file) as ByteArray,UtilCommonLoader.externalLoaderContext);
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      private function onInitRemoteCompleted(param1:Event) : void
      {
         var _loc2_:Class = null;
         (param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitRemoteCompleted);
         if(this.getLoader().content.width == 1119 && this.getLoader().content.height == 720 || this.getLoader().content.width == 1679 && this.getLoader().content.height == 1080 || this.getLoader().content.width == 1920 && this.getLoader().content.height == 1236 || this.getLoader().content.width == 3840 && this.getLoader().content.height == 2472)
         {
            this.getLoader().content.width = AnimeConstants.SCREEN_WIDTH;
            this.getLoader().content.height = AnimeConstants.SCREEN_HEIGHT;
         }
         this.getLoader().content.width = this.getLoader().content.width + 2;
         this.getLoader().content.height = this.getLoader().content.height + 2;
         this.getLoader().content.x = this.getLoader().content.x - 1;
         this.getLoader().content.y = this.getLoader().content.y - 1;
         if(this.getLoader().content.loaderInfo.contentType == "image/jpeg" || this.getLoader().content.loaderInfo.contentType == "image/gif" || this.getLoader().content.loaderInfo.contentType == "image/png")
         {
            Bitmap(this.getLoader().content).smoothing = true;
         }
         if(this.getLoader().content.loaderInfo.applicationDomain.hasDefinition("theSound"))
         {
            _loc2_ = this.getLoader().content.loaderInfo.applicationDomain.getDefinition("theSound") as Class;
            this.sound = new _loc2_();
            this.dispatchEvent(new Event("SoundAdded"));
         }
         this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
      }
      
      public function initDependency(param1:Background, param2:Number) : void
      {
         this._bgInPrevScene = param1;
         if(this._bgInPrevScene != null && this._bgInPrevScene.file == this.file)
         {
            this.firstBg = this._bgInPrevScene.firstBg;
            this.isFirstBg = false;
            this._bgInPrevScene._bgInNextScene = this;
            this.setLoader(new UtilCommonLoader());
            this.startFrameOffset = param1.startFrameOffset + param2;
         }
         else
         {
            this.firstBg = this;
            this.isFirstBg = true;
            this.setLoader(new UtilCommonLoader());
            this.startFrameOffset = 0;
         }
      }
      
      public function updateProperties(param1:Number) : void
      {
      }
      
      override public function destroy(param1:Boolean = false) : void
      {
         if(this._bgInNextScene == null)
         {
            this.pause();
         }
         if(param1)
         {
            this.setLoader(null);
         }
      }
      
      override public function propagateSceneState(param1:int) : void
      {
         if(param1 == AnimeScene.STATE_ACTION)
         {
            this.getLoader().alpha = 1;
            this.getLoader().visible = true;
            UtilPlain.removeAllSon(_bundle);
            _bundle.addChild(this.getLoader());
            if(this.isFirstBg)
            {
               this.resume();
            }
            this.setState(Background.STATE_ACTION);
         }
         else if(param1 == AnimeScene.STATE_NULL)
         {
            this.setState(Background.STATE_NULL);
         }
      }
      
      private function sceneToAssetFrame(param1:Number) : Number
      {
         return param1 + this.startFrameOffset;
      }
      
      override public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
      {
         var _loc5_:Number = this.sceneToAssetFrame(param1);
         if(_bundle)
         {
            PlayerConstant.goToAndStopFamily(_bundle,_loc5_);
         }
      }
      
      public function prepareImage() : void
      {
         var imageId:Number = NaN;
         var asset:AssetImageLibraryObject = null;
         try
         {
            imageId = 0;
            if(this._bgInPrevScene)
            {
               imageId = this._bgInPrevScene.assetImageId;
            }
            asset = AssetImageLibrary.instance.borrowImage(this.file,imageId,this.parentScene.id);
            if(asset && asset.image)
            {
               this._assetImageId = asset.imageId;
               this.setLoader(UtilCommonLoader(asset.image));
               if(this.isFirstBg)
               {
                  PlayerConstant.goToAndStopFamilyAt1(asset.image);
               }
               UtilColor.resetAssetPartsColor(asset.image);
            }
            return;
         }
         catch(e:Error)
         {
            UtilErrorLogger.getInstance().appendCustomError("Background:prepareImage",e);
            UtilErrorLogger.getInstance().error("Background:prepareImage" + e);
            return;
         }
      }
   }
}
