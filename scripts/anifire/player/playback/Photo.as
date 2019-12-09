package anifire.player.playback
{
   import anifire.constant.SlideShowEmbedConstant;
   import anifire.player.events.PlayerEvent;
   import anifire.util.UtilCommonLoader;
   import anifire.util.UtilLoadMgr;
   import anifire.util.UtilPlain;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class Photo extends EventDispatcher
   {
       
      
      public var photo_file_path:String;
      
      private var photo_containers:Array;
      
      private var bitmap_arr:Array;
      
      private var isFirstBitmap:Boolean;
      
      private var isFirstContainer:Boolean;
      
      private var index:int;
      
      private var rotation:Number;
      
      private var isVertical:Boolean;
      
      private var photoFrameArr:Array;
      
      public function Photo()
      {
         this.photoFrameArr = new Array();
         super();
      }
      
      public function init(param1:String, param2:Number, param3:int) : void
      {
         this.photo_file_path = param1;
         this.bitmap_arr = new Array();
         this.photo_containers = new Array();
         this.index = param3;
         this.rotation = param2;
      }
      
      public function initDependency(param1:Boolean, param2:Boolean, param3:Photo) : void
      {
         this.isFirstBitmap = param1;
         this.isFirstContainer = param2;
         if(!this.isFirstBitmap)
         {
         }
         if(!this.isFirstContainer)
         {
         }
      }
      
      public function initRemoteData(param1:PlayerDataStock, param2:DisplayObject) : void
      {
         this.initPhotoContainers(param2);
         this.initBitmaps(param1);
      }
      
      private function initPhotoContainers(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RegExp = null;
         var _loc5_:DisplayObjectContainer = null;
         _loc3_ = this.getRegExpToSearchPhotoInstanceContainer(this.index);
         var _loc4_:Array = UtilPlain.getMultipleInstance(param1,_loc3_);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = (_loc4_[_loc6_] as DisplayObjectContainer).parent;
            this.photo_containers.push(_loc5_);
            _loc6_++;
         }
      }
      
      private function initBitmaps(param1:PlayerDataStock) : void
      {
         var _loc2_:UtilCommonLoader = new UtilCommonLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.onPhotosInitRemoteDataComplete);
         _loc2_.loadBytes(param1.getPlayerData(this.photo_file_path) as ByteArray);
      }
      
      private function onPhotosInitRemoteDataComplete(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:DisplayObjectContainer = null;
         var _loc8_:DisplayObjectContainer = null;
         var _loc9_:DisplayObjectContainer = null;
         var _loc10_:Rectangle = null;
         var _loc11_:UtilLoadMgr = null;
         var _loc12_:BitmapData = null;
         var _loc13_:Loader = null;
         var _loc14_:Class = null;
         (param1.target as IEventDispatcher).removeEventListener(param1.type,this.onPhotosInitRemoteDataComplete);
         var _loc2_:Bitmap = (param1.target as Loader).content as Bitmap;
         var _loc3_:BitmapData = _loc2_.bitmapData;
         if(this.photo_containers.length > 0)
         {
            _loc5_ = this.isPhotoVertical(_loc3_.width,_loc3_.height,this.rotation);
            _loc6_ = this.photo_containers[0] as DisplayObjectContainer;
            _loc7_ = this.getPhotoContainerByDirection(_loc6_,false);
            _loc8_ = this.getPhotoContainerByDirection(_loc6_,true);
            if(_loc5_)
            {
               _loc9_ = _loc8_;
            }
            else
            {
               _loc9_ = _loc7_;
            }
            _loc9_ = _loc9_.getChildByName("PIC") as DisplayObjectContainer;
            _loc10_ = _loc9_.getRect(_loc9_);
            this.processBitmap(_loc2_,_loc10_,this.rotation);
            _loc11_ = new UtilLoadMgr();
            _loc12_ = _loc2_.bitmapData;
            _loc4_ = 0;
            while(_loc4_ < this.photo_containers.length)
            {
               _loc6_ = this.photo_containers[_loc4_] as DisplayObjectContainer;
               _loc7_ = this.getPhotoContainerByDirection(_loc6_,false);
               _loc8_ = this.getPhotoContainerByDirection(_loc6_,true);
               if(_loc5_)
               {
                  _loc9_ = _loc8_;
               }
               else
               {
                  _loc9_ = _loc7_;
               }
               _loc9_ = _loc9_.getChildByName("PIC") as DisplayObjectContainer;
               _loc10_ = _loc9_.getRect(_loc9_);
               _loc2_ = new Bitmap(_loc12_);
               _loc2_.pixelSnapping = PixelSnapping.ALWAYS;
               _loc2_.smoothing = true;
               _loc13_ = new Loader();
               _loc14_ = SlideShowEmbedConstant.HORIZONTAL_PHOTO_FRAME_BYTES;
               _loc13_.loadBytes(new _loc14_() as ByteArray);
               this.photoFrameArr.push(_loc13_);
               _loc11_.addEventDispatcher(_loc13_.contentLoaderInfo,Event.COMPLETE);
               this.rotateAndPositionAndResizeObj(_loc2_,_loc10_);
               this.bitmap_arr.push(_loc2_);
               if(_loc5_)
               {
                  if(_loc7_ != null)
                  {
                     _loc7_.parent.removeChild(_loc7_);
                  }
               }
               else if(_loc8_ != null)
               {
                  _loc8_.parent.removeChild(_loc8_);
               }
               this.photo_containers[_loc4_] = _loc9_;
               _loc4_++;
            }
         }
         this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
      }
      
      private function doAddPhotoFrame(param1:Event) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Rectangle = null;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         (param1.target as IEventDispatcher).removeEventListener(param1.type,this.doAddPhotoFrame);
         var _loc2_:int = 0;
         while(_loc2_ < this.photo_containers.length)
         {
            _loc3_ = (this.photoFrameArr[_loc2_] as Loader).content as DisplayObjectContainer;
            _loc4_ = this.bitmap_arr[_loc2_] as DisplayObject;
            _loc5_ = _loc3_.getChildByName("PIC") as DisplayObjectContainer;
            _loc6_ = _loc5_.getRect(_loc3_);
            _loc7_ = _loc5_.getRect(_loc5_);
            _loc8_ = _loc4_.getRect(_loc4_);
            _loc9_ = this.getDisplacementToCenterAlign2Rectangle(_loc8_,_loc6_);
            _loc3_.x = _loc3_.x + _loc9_.x;
            _loc3_.y = _loc3_.y + _loc9_.y;
            _loc10_ = this.getDisplacementToCenterAlign2Rectangle(_loc7_,_loc8_);
            _loc4_.x = _loc4_.x + _loc10_.x;
            _loc4_.y = _loc4_.y + _loc10_.y;
            _loc5_.addChild(_loc4_);
            this.bitmap_arr[_loc2_] = _loc3_;
            _loc2_++;
         }
      }
      
      private function getDisplacementToCenterAlign2Rectangle(param1:Rectangle, param2:Rectangle) : Point
      {
         var _loc3_:Point = new Point((param2.left + param2.right) / 2,(param2.top + param2.bottom) / 2);
         var _loc4_:Point = new Point((param1.left + param1.right) / 2,(param1.top + param1.bottom) / 2);
         return _loc4_.subtract(_loc3_);
      }
      
      private function rotateAndPositionAndResizeObj(param1:DisplayObject, param2:Rectangle) : void
      {
         var _loc3_:* = param1.height > param1.width;
         param1.width = param2.width;
         param1.height = param2.height;
         var _loc4_:Sprite = new Sprite();
         _loc4_.addChild(param1);
         var _loc5_:Rectangle = param1.getRect(_loc4_);
         var _loc6_:Point = new Point((param2.left + param2.right) / 2,(param2.top + param2.bottom) / 2);
         var _loc7_:Point = new Point((_loc5_.left + _loc5_.right) / 2,(_loc5_.top + _loc5_.bottom) / 2);
         var _loc8_:Point = _loc6_.subtract(_loc7_);
         param1.x = param1.x + _loc8_.x;
         param1.y = param1.y + _loc8_.y;
      }
      
      private function putPhotosToContainer() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.photo_containers.length)
         {
            _loc1_ = this.photo_containers[_loc3_] as DisplayObjectContainer;
            _loc2_ = this.bitmap_arr[_loc3_] as DisplayObject;
            if(_loc1_ && _loc2_)
            {
               UtilPlain.removeAllSon(_loc1_);
               _loc1_.addChild(_loc2_);
            }
            _loc3_++;
         }
      }
      
      private function getPhotoContainerByDirection(param1:DisplayObjectContainer, param2:Boolean) : DisplayObjectContainer
      {
         if(param2)
         {
            return param1.getChildByName("VER") as DisplayObjectContainer;
         }
         return param1.getChildByName("HOR") as DisplayObjectContainer;
      }
      
      public function propagateSceneState(param1:int) : void
      {
         if(param1 == AnimeScene.STATE_ACTION)
         {
            this.putPhotosToContainer();
         }
      }
      
      private function isPhotoVertical(param1:int, param2:int, param3:Number) : Boolean
      {
         var _loc4_:* = param2 > param1;
         var _loc5_:* = Math.abs(param3) / 90 % 2 == 1;
         if(_loc4_ && _loc5_)
         {
            return false;
         }
         if(_loc4_ && !_loc5_)
         {
            return true;
         }
         if(!_loc4_ && _loc5_)
         {
            return true;
         }
         if(!_loc4_ && !_loc5_)
         {
            return false;
         }
         return false;
      }
      
      private function processBitmap(param1:Bitmap, param2:Rectangle, param3:Number) : void
      {
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc4_:BitmapData = param1.bitmapData;
         var _loc5_:int = param2.width;
         var _loc6_:int = param2.height;
         var _loc7_:int = _loc4_.width;
         var _loc8_:int = _loc4_.height;
         var _loc9_:* = _loc7_ < _loc8_;
         var _loc10_:Boolean = this.isPhotoVertical(_loc7_,_loc8_,param3);
         var _loc11_:int = _loc9_ == _loc10_?int(_loc7_):int(_loc8_);
         var _loc12_:int = _loc9_ == _loc10_?int(_loc8_):int(_loc7_);
         var _loc13_:Number = _loc12_ / _loc11_;
         var _loc14_:Number = _loc6_ / _loc5_;
         if(_loc13_ > _loc14_)
         {
            _loc15_ = _loc11_;
            _loc16_ = Math.floor(_loc11_ * _loc14_);
         }
         else
         {
            _loc16_ = _loc12_;
            _loc15_ = _loc12_ / _loc14_;
         }
         var _loc17_:Matrix = new Matrix();
         _loc17_.translate(-_loc7_ / 2,-_loc8_ / 2);
         _loc17_.rotate(Math.PI * param3 / 180);
         _loc17_.translate(_loc15_ / 2,_loc16_ / 2);
         var _loc18_:BitmapData = new BitmapData(_loc15_,_loc16_);
         _loc18_.draw(_loc4_,_loc17_);
         param1.bitmapData = _loc18_;
         _loc4_.dispose();
      }
      
      private function getRegExpToSearchPhotoInstanceContainer(param1:int) : RegExp
      {
         return new RegExp("^PIC_" + (param1 + 1));
      }
      
      public function destroy(param1:Boolean = false) : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < this.bitmap_arr.length)
            {
               _loc2_ = this.bitmap_arr[_loc3_] as Bitmap;
               if(_loc2_.bitmapData.width > 0)
               {
                  _loc2_.bitmapData.dispose();
               }
               _loc3_++;
            }
         }
      }
   }
}
