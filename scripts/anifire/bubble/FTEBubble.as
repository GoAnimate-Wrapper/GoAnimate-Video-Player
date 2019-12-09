package anifire.bubble
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontWeight;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextLine;
   import flashx.textLayout.compose.TextLineRecycler;
   import flashx.textLayout.formats.TextAlign;
   import mx.events.PropertyChangeEvent;
   
   public class FTEBubble extends Sprite
   {
       
      
      protected var _contentWidth:Number;
      
      protected var _contentHeight:Number;
      
      protected var _text:String;
      
      protected var _elementFormat:ElementFormat;
      
      protected var _textBold:Boolean;
      
      protected var _fontFamily:String;
      
      protected var _fontSize:Number;
      
      protected var _color:uint;
      
      protected var _textAlign:String = "left";
      
      protected var _leading:Number = 0;
      
      protected var _extraAscent:Number = 0;
      
      protected var _textBlock:TextBlock;
      
      protected var _textLines:Vector.<TextLine>;
      
      protected var _atomBounds:Vector.<Rectangle>;
      
      protected var _autoUpdate:Boolean = true;
      
      protected var _updatePending:Boolean;
      
      public function FTEBubble()
      {
         super();
         this._textBlock = new TextBlock();
         this._textLines = new Vector.<TextLine>();
         this._atomBounds = new Vector.<Rectangle>();
      }
      
      [Bindable(event="propertyChange")]
      public function get text() : String
      {
         return this._text;
      }
      
      private function set _3556653text(param1:String) : void
      {
         if(this._text != param1)
         {
            this._text = param1;
            this.updateBubble();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get textBold() : Boolean
      {
         return this._textBold;
      }
      
      private function set _1004169902textBold(param1:Boolean) : void
      {
         if(this._textBold != param1)
         {
            this._textBold = param1;
            this.updateBubble();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fontFamily() : String
      {
         return this._fontFamily;
      }
      
      private function set _1224696685fontFamily(param1:String) : void
      {
         if(this._fontFamily != param1)
         {
            this._fontFamily = param1;
            this.updateBubble();
         }
      }
      
      public function get fontSize() : Number
      {
         return this._fontSize;
      }
      
      public function set fontSize(param1:Number) : void
      {
         if(this._fontSize != param1)
         {
            this._fontSize = param1;
            this.updateBubble();
         }
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color != param1)
         {
            this._color = param1;
            this.updateBubble();
         }
      }
      
      public function get textAlign() : String
      {
         return this._textAlign;
      }
      
      public function set textAlign(param1:String) : void
      {
         if(this._textAlign != param1)
         {
            this._textAlign = param1;
            this.updateBubble();
         }
      }
      
      public function get leading() : Number
      {
         return this._leading;
      }
      
      public function set leading(param1:Number) : void
      {
         if(this._leading != param1)
         {
            this._leading = param1;
            this.updateBubble();
         }
      }
      
      public function get extraAscent() : Number
      {
         return this._extraAscent;
      }
      
      public function set extraAscent(param1:Number) : void
      {
         if(this._extraAscent != param1)
         {
            this._extraAscent = param1;
            this.updateBubble();
         }
      }
      
      public function get autoUpdate() : Boolean
      {
         return this._autoUpdate;
      }
      
      public function set autoUpdate(param1:Boolean) : void
      {
         if(this._autoUpdate != param1)
         {
            this._autoUpdate = param1;
            if(this._autoUpdate && this._updatePending)
            {
               this.updateBubble();
            }
         }
      }
      
      protected function updateBubble() : void
      {
         if(this._autoUpdate)
         {
            this.updateElementFormat();
            this.createText();
         }
         else
         {
            this._updatePending = true;
         }
      }
      
      protected function updateElementFormat() : void
      {
         this._elementFormat = new ElementFormat();
         var _loc1_:FontDescription = new FontDescription();
         _loc1_.fontName = this._fontFamily;
         _loc1_.fontWeight = !!this._textBold?FontWeight.BOLD:FontWeight.NORMAL;
         _loc1_.fontLookup = FontLookup.EMBEDDED_CFF;
         this._elementFormat.fontDescription = _loc1_;
         this._elementFormat.fontSize = this._fontSize;
         this._elementFormat.color = this._color;
      }
      
      protected function clearText() : void
      {
         var _loc3_:TextLine = null;
         var _loc1_:int = this._textLines.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._textLines[_loc2_];
            removeChild(_loc3_);
            TextLineRecycler.addLineForReuse(_loc3_);
            _loc2_++;
         }
         this._textLines.length = 0;
         this._atomBounds.length = 0;
      }
      
      protected function createText() : void
      {
         var _loc3_:TextLine = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Rectangle = null;
         this.clearText();
         var _loc1_:TextElement = new TextElement(this._text,this._elementFormat);
         this._textBlock.content = _loc1_;
         this._contentHeight = 0;
         var _loc2_:TextLine = null;
         while(true)
         {
            _loc3_ = TextLineRecycler.getLineForReuse();
            if(_loc3_)
            {
               _loc2_ = this._textBlock.recreateTextLine(_loc3_,_loc2_,this.width);
            }
            else
            {
               _loc2_ = this._textBlock.createTextLine(_loc2_,this.width);
            }
            if(!_loc2_)
            {
               break;
            }
            _loc4_ = 0;
            if(this._textAlign == TextAlign.CENTER)
            {
               _loc4_ = (this._contentWidth - _loc2_.textWidth) * 0.5;
            }
            else if(this._textAlign == TextAlign.RIGHT)
            {
               _loc4_ = this._contentWidth - _loc2_.textWidth;
            }
            _loc2_.x = _loc4_;
            _loc2_.y = this._contentHeight + _loc2_.ascent + this._extraAscent;
            _loc5_ = _loc2_.atomCount;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = this._text.charAt(_loc2_.textBlockBeginIndex + _loc6_);
               _loc8_ = _loc2_.getAtomBounds(_loc6_);
               _loc8_.x = _loc8_.x + _loc2_.x;
               _loc8_.y = _loc8_.y + _loc2_.y;
               this._atomBounds.push(_loc8_);
               _loc6_++;
            }
            this._contentHeight = this._contentHeight + (_loc2_.textHeight + this._leading + this._extraAscent);
            this._textLines.push(_loc2_);
            addChild(_loc2_);
         }
         this._contentHeight = this._contentHeight - this._leading;
         this._textBlock.releaseLineCreationData();
      }
      
      public function getAtomBounds(param1:int) : Rectangle
      {
         return this._atomBounds[param1];
      }
      
      private function releaseLinesFromTextBlock() : void
      {
         var _loc1_:TextLine = this._textBlock.firstLine;
         var _loc2_:TextLine = this._textBlock.lastLine;
         if(_loc1_)
         {
            this._textBlock.releaseLines(_loc1_,_loc2_);
         }
      }
      
      override public function set width(param1:Number) : void
      {
         this._contentWidth = param1;
         this.updateBubble();
      }
      
      override public function get width() : Number
      {
         return this._contentWidth;
      }
      
      override public function get height() : Number
      {
         return this._contentHeight;
      }
      
      public function set text(param1:String) : void
      {
         var _loc2_:Object = this.text;
         if(_loc2_ !== param1)
         {
            this._3556653text = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"text",_loc2_,param1));
            }
         }
      }
      
      public function set fontFamily(param1:String) : void
      {
         var _loc2_:Object = this.fontFamily;
         if(_loc2_ !== param1)
         {
            this._1224696685fontFamily = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fontFamily",_loc2_,param1));
            }
         }
      }
      
      public function set textBold(param1:Boolean) : void
      {
         var _loc2_:Object = this.textBold;
         if(_loc2_ !== param1)
         {
            this._1004169902textBold = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textBold",_loc2_,param1));
            }
         }
      }
   }
}
