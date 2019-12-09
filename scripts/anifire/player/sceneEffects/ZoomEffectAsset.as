package anifire.player.sceneEffects
{
   import anifire.constant.AnimeConstants;
   import anifire.effect.EffectMgr;
   import anifire.effect.ZoomEffect;
   import anifire.player.playback.AnimeScene;
   import anifire.util.UtilUnitConvert;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ZoomEffectAsset extends ProgramEffectAsset
   {
      
      private static const RASTERIZED_IMG_NAME:String = "zoom_rasterized_img";
      
      private static const ERR_RANGE:Number = 0.2;
       
      
      public const MODE_NOR:String = "mode_normal";
      
      public const MODE_PRE:String = "mode_previous_zoom";
      
      public const MODE_EXT:String = "mode_extend_currzoom";
      
      private var _originalPos:Point;
      
      private var _originalScale:Point;
      
      private var _targetPos:Point;
      
      private var _targetScale:Point;
      
      private var _isRasterized:Boolean;
      
      private var _targetRect:Rectangle;
      
      private var _cut:Boolean = false;
      
      private var _pan:Boolean = false;
      
      private var _mode:String = "mode_normal";
      
      private var _refZoom:ZoomEffectAsset;
      
      private var _effectX:Number;
      
      private var _effectY:Number;
      
      private var _effectWidth:Number;
      
      private var _effectHeight:Number;
      
      private var _mver:Number;
      
      private var _prevZoom:ZoomEffectAsset;
      
      private var _motionData:Array;
      
      public function ZoomEffectAsset()
      {
         super();
      }
      
      public static function isDummyZoomNeededForPreviousZoom(param1:ZoomEffectAsset, param2:ZoomEffectAsset) : Boolean
      {
         if(param1 != null)
         {
            if(param1.sttime == 0 && param1.edtime == 0 || getDiffSec(param1.edtime,param1.parentScene.duration#1) < ERR_RANGE)
            {
               if(param2 == null || param2.sttime > 1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function isDummyZoomNeededForCurrentZoom(param1:ZoomEffectAsset, param2:Number = 1) : Boolean
      {
         if(param1 != null && param2 <= 3)
         {
            if(param1.sttime != 0 && param1.edtime != 0)
            {
               if(getDiffSec(param1.edtime,param1.parentScene.duration#1) >= ERR_RANGE || param1.edzoom >= 0.1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private static function getDiffSec(param1:Number, param2:Number) : Number
      {
         return Math.abs(UtilUnitConvert.frameToSec(param1) - UtilUnitConvert.frameToSec(param2));
      }
      
      public function get targetRect() : Rectangle
      {
         return this._targetRect;
      }
      
      public function set targetRect(param1:Rectangle) : void
      {
         this._targetRect = param1;
      }
      
      public function get refZoom() : ZoomEffectAsset
      {
         return this._refZoom;
      }
      
      public function set refZoom(param1:ZoomEffectAsset) : void
      {
         this._refZoom = param1;
      }
      
      public function get prevZoom() : ZoomEffectAsset
      {
         return this._prevZoom;
      }
      
      public function set prevZoom(param1:ZoomEffectAsset) : void
      {
         this._prevZoom = param1;
      }
      
      public function get mode() : String
      {
         return this._mode;
      }
      
      public function set mode(param1:String) : void
      {
         this._mode = param1;
      }
      
      public function get cut() : Boolean
      {
         return this._cut;
      }
      
      public function set cut(param1:Boolean) : void
      {
         this._cut = param1;
      }
      
      public function get pan() : Boolean
      {
         return this._pan;
      }
      
      public function set pan(param1:Boolean) : void
      {
         this._pan = param1;
      }
      
      private function get originalPos() : Point
      {
         return this._originalPos;
      }
      
      private function set originalPos(param1:Point) : void
      {
         this._originalPos = param1;
      }
      
      private function get originalScale() : Point
      {
         return this._originalScale;
      }
      
      private function set originalScale(param1:Point) : void
      {
         this._originalScale = param1;
      }
      
      private function get targetPos() : Point
      {
         return this._targetPos;
      }
      
      private function set targetPos(param1:Point) : void
      {
         this._targetPos = param1;
      }
      
      private function get targetScale() : Point
      {
         return this._targetScale;
      }
      
      private function set targetScale(param1:Point) : void
      {
         this._targetScale = param1;
      }
      
      private function get isRasterized() : Boolean
      {
         return this._isRasterized;
      }
      
      private function set isRasterized(param1:Boolean) : void
      {
         this._isRasterized = param1;
      }
      
      public function init(param1:XML, param2:AnimeScene, param3:DisplayObjectContainer, param4:Number = 0) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc17_:Number = NaN;
         initAsset(param1.@id,param1.@index,param2);
         var _loc5_:XML = param1.child(EffectMgr.XML_NODE_TAG)[0];
         initEffectAsset(EffectMgr.getType(_loc5_));
         var _loc6_:ZoomEffect = EffectMgr.getEffectByXML(_loc5_) as ZoomEffect;
         var _loc11_:Array = String(param1.x).split(",");
         var _loc12_:Array = String(param1.y).split(",");
         var _loc13_:Array = String(param1.width).split(",");
         var _loc14_:Array = String(param1.height).split(",");
         this._mver = param4;
         this._effectX = _loc7_ = param1.x;
         this._effectY = _loc8_ = param1.y;
         this._effectWidth = _loc9_ = _loc6_.width;
         this._effectHeight = _loc10_ = _loc6_.height;
         this.sttime = param1["st"];
         this.edtime = param1["et"];
         if(param1["st"].@dur > -1)
         {
            this.stzoom = UtilUnitConvert.frameToSec(param1["st"].@dur,false);
         }
         else
         {
            this.stzoom = UtilUnitConvert.frameToDuration(AnimeConstants.DEFAULT_CAMERA_ZOOM_DURATION);
         }
         if(param1["et"].@dur > -1)
         {
            this.edzoom = UtilUnitConvert.frameToSec(param1["et"].@dur,false);
         }
         else
         {
            this.edzoom = UtilUnitConvert.frameToDuration(AnimeConstants.DEFAULT_CAMERA_ZOOM_DURATION);
         }
         if(this.stzoom == 0 && this.edtime < this.sttime)
         {
            this.sttime = this.edtime;
         }
         this.mode = this.MODE_NOR;
         var _loc15_:String = _loc5_.@isCut;
         if(_loc15_ == "true")
         {
            this.cut = true;
         }
         var _loc16_:String = _loc5_.@isPan;
         if(_loc16_ == "true")
         {
            this.pan = true;
         }
         this.effectee = param3;
         this.isRasterized = false;
         if(_loc11_.length == 1)
         {
            this.originalPos = new Point(this.effectee.x,this.effectee.y);
            this.originalScale = new Point(this.effectee.scaleX,this.effectee.scaleY);
            _loc17_ = AnimeConstants.SCREEN_WIDTH / _loc9_;
            this.targetPos = new Point(this.originalPos.x - _loc7_ * _loc17_ + AnimeConstants.SCREEN_X,this.originalPos.y - _loc8_ * _loc17_ + AnimeConstants.SCREEN_Y);
            this.targetScale = new Point(this.originalScale.x * _loc17_,this.originalScale.y * _loc17_);
            this.targetRect = new Rectangle(_loc7_,_loc8_,_loc9_,_loc10_);
         }
         else
         {
            if(param4 <= 3)
            {
               this.stzoom = param2.duration#1;
            }
            _loc17_ = AnimeConstants.SCREEN_WIDTH / _loc13_[0];
            this.originalPos = new Point(-_loc11_[0] * _loc17_ + AnimeConstants.SCREEN_X,-_loc12_[0] * _loc17_ + AnimeConstants.SCREEN_Y);
            this.originalScale = new Point(_loc17_,_loc17_);
            _loc17_ = AnimeConstants.SCREEN_WIDTH / _loc13_[1];
            this.targetPos = new Point(-_loc11_[1] * _loc17_ + AnimeConstants.SCREEN_X,-_loc12_[1] * _loc17_ + AnimeConstants.SCREEN_Y);
            this.targetScale = new Point(_loc17_,_loc17_);
            this.targetRect = new Rectangle(_loc11_[1],_loc12_[1],_loc13_[1],_loc14_[1]);
         }
      }
      
      public function initDummyZoom(param1:AnimeScene, param2:DisplayObjectContainer, param3:ZoomEffectAsset, param4:ZoomEffectAsset, param5:String = "mode_normal") : void
      {
         var _loc6_:Number = new Date().valueOf() * Math.random();
         initAsset("dummy_zoom_" + _loc6_.toString(),-1,param1);
         initEffectAsset(EffectMgr.TYPE_ZOOM);
         this.mode = param5;
         this.prevZoom = param3;
         this.refZoom = param4;
         if(param3 != null && this.mode == this.MODE_PRE)
         {
            if(param3.cut)
            {
               this.cut = true;
            }
         }
         if(param4 != null)
         {
            if(param4.cut && this.mode == this.MODE_EXT)
            {
               if(param4.cut)
               {
                  this.cut = true;
               }
            }
            if(param4.edzoom > -1)
            {
               this.edzoom = param4.edzoom;
            }
         }
         this._effectX = AnimeConstants.SCREEN_X;
         this._effectY = AnimeConstants.SCREEN_Y;
         this._effectWidth = AnimeConstants.SCREEN_WIDTH;
         this._effectHeight = AnimeConstants.SCREEN_HEIGHT;
         this.effectee = param2;
         this.originalPos = new Point(param2.x,param2.y);
         this.originalScale = new Point(1,1);
         this.targetPos = this.originalPos.clone();
         this.targetScale = this.originalScale.clone();
      }
      
      public function initDependencyWithPrevZoom(param1:Number, param2:Number, param3:ZoomEffectAsset) : void
      {
         var _loc5_:Object = null;
         initDependency(param1,param2,0);
         var _loc4_:Boolean = false;
         if(param3 != null && this.mode == this.MODE_PRE)
         {
            this.originalPos = param3.targetPos.clone();
            this.originalScale = param3.targetScale.clone();
            _loc4_ = true;
         }
         else if(this.mode == this.MODE_EXT)
         {
            this.originalPos = this.refZoom.targetPos.clone();
            this.originalScale = this.refZoom.targetScale.clone();
         }
         else if(this.mode == this.MODE_NOR && param3 != null && !this.pan)
         {
            if((getDiffSec(param3.parentScene.duration#1,param3.edtime) < ERR_RANGE || param3.edtime == 0) && getDiffSec(this.startFrame,this.parentScene.startFrame) < ERR_RANGE)
            {
               this.originalPos = param3.targetPos.clone();
               this.originalScale = param3.targetScale.clone();
               _loc4_ = true;
            }
         }
         if(_loc4_)
         {
            this.effectee.x = this.originalPos.x;
            this.effectee.y = this.originalPos.y;
            this.effectee.scaleX = this.originalScale.x;
            this.effectee.scaleY = this.originalScale.y;
         }
         this.calculateMotionData();
         if(this._motionData.length > 0)
         {
            _loc5_ = this._motionData[0];
            this.effectee.x = _loc5_.x;
            this.effectee.y = _loc5_.y;
            this.effectee.scaleX = _loc5_.scaleX;
            this.effectee.scaleY = _loc5_.scaleY;
         }
      }
      
      private function calculateMotionData() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         this._motionData = new Array();
         var _loc1_:Number = 1;
         var _loc6_:uint = this.startFrame;
         while(_loc6_ <= this.endFrame)
         {
            if(this.endFrame > this.startFrame)
            {
               _loc1_ = (_loc6_ - this.startFrame) / (this.endFrame - this.startFrame);
            }
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            else if(_loc1_ > 1 || this.endFrame - this.startFrame == 1)
            {
               _loc1_ = 1;
            }
            if(this.cut == true)
            {
               _loc1_ = 1;
            }
            _loc7_ = this.originalPos.x + (this.targetPos.x - this.originalPos.x) * _loc1_;
            _loc2_ = _loc7_;
            _loc7_ = this.originalPos.y + (this.targetPos.y - this.originalPos.y) * _loc1_;
            _loc3_ = _loc7_;
            _loc7_ = this.originalScale.x + (this.targetScale.x - this.originalScale.x) * _loc1_;
            _loc4_ = _loc7_;
            _loc7_ = this.originalScale.y + (this.targetScale.y - this.originalScale.y) * _loc1_;
            _loc5_ = _loc7_;
            this._motionData.push({
               "x":_loc2_,
               "y":_loc3_,
               "scaleX":_loc4_,
               "scaleY":_loc5_
            });
            _loc6_++;
         }
      }
      
      override public function play(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1 >= _startFrame && param1 <= _endFrame)
         {
            _loc2_ = param1 - startFrame;
            _loc3_ = this._motionData[_loc2_];
            this.effectee.x = _loc3_.x;
            this.effectee.y = _loc3_.y;
            this.effectee.scaleX = _loc3_.scaleX;
            this.effectee.scaleY = _loc3_.scaleY;
         }
         if(this._mver > 3)
         {
            if(param1 < this.startFrame)
            {
               if(this.startFrame == this.endFrame)
               {
                  this.effectee.x = this.originalPos.x;
                  this.effectee.y = this.originalPos.y;
                  this.effectee.scaleX = this.originalScale.x;
                  this.effectee.scaleY = this.originalScale.y;
               }
               else
               {
                  this.effectee.x = this._motionData[0].x;
                  this.effectee.y = this._motionData[0].y;
                  this.effectee.scaleX = this._motionData[0].scaleX;
                  this.effectee.scaleY = this._motionData[0].scaleY;
               }
            }
            else if(param1 > this.endFrame)
            {
               this.effectee.x = this._motionData[this._motionData.length - 1].x;
               this.effectee.y = this._motionData[this._motionData.length - 1].y;
               this.effectee.scaleX = this._motionData[this._motionData.length - 1].scaleX;
               this.effectee.scaleY = this._motionData[this._motionData.length - 1].scaleY;
            }
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
      
      override public function restore() : void
      {
         if(this.effectee != null)
         {
            this.effectee.x = 0;
            this.effectee.y = 0;
            this.effectee.scaleX = 1;
            this.effectee.scaleY = 1;
         }
      }
      
      public function returnString() : String
      {
         return this.id + "," + this.mode + "," + this.startFrame + "," + this.endFrame;
      }
   }
}
