package anifire.player.whiteboard
{
   import anifire.bubble.Bubble;
   import anifire.util.FontManager;
   import anifire.util.UtilMath;
   import anifire.whiteboard.models.MaskGridModel;
   import anifire.whiteboard.models.WhiteboardFontModel;
   import anifire.whiteboard.models.WhiteboardModel;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.registerClassAlias;
   import flash.text.TextLineMetrics;
   import flash.utils.ByteArray;
   
   public class WhiteboardLoader extends EventDispatcher
   {
      
      public static const MASK_FILE_EXT:String = ".wb.amf";
      
      private static var _genericWhiteboardModel:WhiteboardModel;
      
      {
         registerClassAlias("anifire.whiteboard.models.WhiteboardModel",WhiteboardModel);
         registerClassAlias("anifire.whiteboard.models.MaskGridModel",MaskGridModel);
         registerClassAlias("anifire.whiteboard.models.WhiteboardFontModel",WhiteboardFontModel);
      }
      
      private var GenericMaskClass:Class;
      
      private var _whiteboardModel:WhiteboardModel;
      
      private var _isGenericMask:Boolean;
      
      private var _bubble:Bubble;
      
      public function WhiteboardLoader()
      {
         this.GenericMaskClass = WhiteboardLoader_GenericMaskClass;
         super();
      }
      
      public function loadCustomMask(param1:String) : void
      {
         var _loc3_:CustomMaskLoader = null;
         var _loc2_:WhiteboardModel = WhiteboardMaskManager.instance.getWhiteboardModel(param1);
         if(_loc2_)
         {
            this._whiteboardModel = _loc2_;
            this.dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            _loc3_ = WhiteboardMaskManager.instance.getCustomMaskLoader(param1);
            _loc3_.addEventListener(Event.COMPLETE,this.loadCustomMaskCompleteHandler);
            _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.loadCustomMaskErrorHandler);
            _loc3_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadCustomMaskErrorHandler);
            _loc3_.loadCustomMask(param1);
         }
      }
      
      private function loadCustomMaskCompleteHandler(param1:Event) : void
      {
         var _loc3_:WhiteboardModel = null;
         var _loc4_:ByteArray = null;
         var _loc5_:WhiteboardModel = null;
         var _loc6_:PlayerMaskGridModel = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc2_:CustomMaskLoader = param1.target as CustomMaskLoader;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.loadCustomMaskCompleteHandler);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.loadCustomMaskErrorHandler);
            _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadCustomMaskErrorHandler);
            _loc3_ = WhiteboardMaskManager.instance.getWhiteboardModel(_loc2_.id);
            if(_loc3_)
            {
               this._whiteboardModel = _loc3_;
               this.dispatchEvent(new Event(Event.COMPLETE));
            }
            else
            {
               _loc4_ = _loc2_.data as ByteArray;
               _loc4_.position = 0;
               _loc5_ = _loc4_.readObject() as WhiteboardModel;
               this._whiteboardModel = new WhiteboardModel();
               _loc7_ = _loc5_.sequence.length;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc6_ = new PlayerMaskGridModel();
                  _loc6_.init(_loc5_.sequence[_loc8_]);
                  this._whiteboardModel.sequence.push(_loc6_);
                  _loc8_++;
               }
               WhiteboardMaskManager.instance.addModel(_loc2_.id,this._whiteboardModel);
               WhiteboardMaskManager.instance.removeCustomMaskLoader(_loc2_.id);
               this.dispatchEvent(new Event(Event.COMPLETE));
            }
         }
      }
      
      private function loadCustomMaskErrorHandler(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.loadCustomMaskCompleteHandler);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.loadCustomMaskErrorHandler);
            _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadCustomMaskErrorHandler);
            this.loadGenericMask();
         }
      }
      
      public function loadBubbleMask(param1:Bubble) : void
      {
         var _loc2_:WhiteboardFontModel = null;
         var _loc3_:FontMaskLoader = null;
         if(param1)
         {
            this._bubble = param1;
            if(FontMaskLoader.WHITEBOARD_FONT_LIST.indexOf(param1.textFont) >= 0)
            {
               _loc2_ = WhiteboardMaskManager.instance.getFontModel(param1.textFont);
               if(_loc2_)
               {
                  this.initBubbleMask(this._bubble,_loc2_);
               }
               else
               {
                  _loc3_ = WhiteboardMaskManager.instance.getFontMaskLoader(param1.textFont);
                  _loc3_.addEventListener(Event.COMPLETE,this.loadFontMaskCompleteHandler);
                  _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.loadFontMaskErrorHandler);
                  _loc3_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadFontMaskErrorHandler);
                  _loc3_.loadFontMask(param1.textFont);
               }
            }
            else
            {
               this.initBubbleMask(this._bubble);
            }
         }
      }
      
      private function loadFontMaskCompleteHandler(param1:Event) : void
      {
         var _loc3_:WhiteboardFontModel = null;
         var _loc4_:ByteArray = null;
         var _loc5_:WhiteboardFontModel = null;
         var _loc2_:FontMaskLoader = param1.target as FontMaskLoader;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.loadFontMaskCompleteHandler);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.loadFontMaskErrorHandler);
            _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadFontMaskErrorHandler);
            _loc3_ = WhiteboardMaskManager.instance.getFontModel(this._bubble.textFont);
            if(_loc3_)
            {
               this.initBubbleMask(this._bubble,_loc3_);
            }
            else
            {
               _loc4_ = _loc2_.data as ByteArray;
               _loc4_.position = 0;
               _loc5_ = _loc4_.readObject() as WhiteboardFontModel;
               WhiteboardMaskManager.instance.addFontModel(this._bubble.textFont,_loc5_);
               WhiteboardMaskManager.instance.removeFontMaskLoader(this._bubble.textFont);
               this.initBubbleMask(this._bubble,_loc5_);
            }
         }
      }
      
      private function loadFontMaskErrorHandler(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.loadFontMaskCompleteHandler);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.loadFontMaskErrorHandler);
            _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadFontMaskErrorHandler);
            WhiteboardMaskManager.instance.removeFontMaskLoader(this._bubble.textFont);
            this.initBubbleMask(this._bubble);
         }
      }
      
      private function initBubbleMask(param1:Bubble, param2:WhiteboardFontModel = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:WhiteboardModel = null;
         var _loc5_:WhiteboardModel = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Point = null;
         var _loc9_:PlayerMaskGridModel = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         var _loc13_:RectanglarMaskGridModel = null;
         var _loc14_:TextLineMetrics = null;
         var _loc15_:Boolean = false;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         if(param1)
         {
            _loc3_ = 60;
            _loc4_ = new WhiteboardModel();
            _loc8_ = new Point();
            _loc11_ = new Array(" ","\n");
            _loc12_ = param1.textSize / _loc3_;
            _loc15_ = param1.textBold && FontManager.instance.supportBold(param1.textFont);
            param1.redraw();
            _loc16_ = param1.text.length;
            _loc17_ = 0;
            while(_loc17_ < _loc16_)
            {
               _loc10_ = param1.text.charAt(_loc17_);
               if(_loc11_.indexOf(_loc10_) < 0)
               {
                  _loc5_ = null;
                  if(param2)
                  {
                     _loc5_ = param2.getGlyph(_loc10_,_loc15_);
                  }
                  if(_loc5_)
                  {
                     _loc6_ = param1.getLabel().getCharBoundaries(_loc17_);
                     _loc18_ = _loc5_.sequence.length;
                     _loc19_ = 0;
                     while(_loc19_ < _loc18_)
                     {
                        _loc9_ = new PlayerMaskGridModel();
                        _loc9_.init(_loc5_.sequence[_loc19_]);
                        _loc8_.x = _loc9_.x;
                        _loc8_.y = _loc9_.y;
                        _loc8_ = UtilMath.scalePoint(_loc8_,_loc12_,_loc12_);
                        _loc8_.offset(_loc6_.x,_loc6_.y);
                        _loc8_.offset(param1.getLabel().x,param1.getLabel().y);
                        _loc9_.drawingX = _loc8_.x;
                        _loc9_.drawingY = _loc8_.y;
                        _loc9_.drawingBrushSize = _loc9_.drawingBrushSize * _loc12_;
                        _loc4_.sequence.push(_loc9_);
                        _loc19_++;
                     }
                  }
                  else
                  {
                     _loc6_ = param1.getLabel().getCharBoundaries(_loc17_);
                     if(_loc6_)
                     {
                        _loc7_ = _loc6_.clone();
                        _loc7_.offset(param1.getLabel().x,param1.getLabel().y);
                        _loc13_ = new RectanglarMaskGridModel();
                        _loc13_.rect = _loc7_;
                        _loc13_.drawingX = _loc7_.x + _loc7_.width / 2;
                        _loc13_.drawingY = _loc7_.y + _loc7_.height / 2;
                        if(_loc17_ % 3 == 0)
                        {
                           _loc9_ = new PlayerMaskGridModel();
                           _loc8_.x = 0;
                           _loc8_.y = 0;
                           _loc8_ = UtilMath.scalePoint(_loc8_,_loc12_,_loc12_);
                           _loc8_.offset(_loc6_.x,_loc6_.y);
                           _loc8_.offset(param1.getLabel().x,param1.getLabel().y);
                           _loc9_.drawingX = _loc8_.x;
                           _loc9_.drawingY = _loc8_.y;
                           _loc4_.sequence.push(_loc9_);
                        }
                        _loc4_.sequence.push(_loc13_);
                     }
                  }
               }
               _loc17_++;
            }
            this._whiteboardModel = _loc4_;
            this.dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      public function loadGenericMask() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:WhiteboardModel = null;
         var _loc3_:PlayerMaskGridModel = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(!_genericWhiteboardModel)
         {
            _loc1_ = new this.GenericMaskClass();
            _loc2_ = _loc1_.readObject() as WhiteboardModel;
            _genericWhiteboardModel = new WhiteboardModel();
            _loc4_ = _loc2_.sequence.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = new PlayerMaskGridModel();
               _loc3_.init(_loc2_.sequence[_loc5_]);
               _genericWhiteboardModel.sequence.push(_loc3_);
               _loc5_++;
            }
         }
         this._whiteboardModel = _genericWhiteboardModel;
         this._isGenericMask = true;
         this.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get isGenericMask() : Boolean
      {
         return this._isGenericMask;
      }
      
      public function get whiteboardModel() : WhiteboardModel
      {
         return this._whiteboardModel;
      }
      
      public function get sequence() : Vector.<MaskGridModel>
      {
         if(this._whiteboardModel)
         {
            return this._whiteboardModel.sequence;
         }
         return null;
      }
   }
}
