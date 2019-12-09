package anifire.player.whiteboard
{
   import anifire.whiteboard.models.MaskGridModel;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class WhiteboardMask extends Sprite
   {
      
      public static const GENERIC_MASK_SIZE:Number = 146;
       
      
      private var _sequence:Vector.<MaskGridModel>;
      
      private var _lastIndex:int = 9999;
      
      private var _lastDrawnGrid:PlayerMaskGridModel;
      
      public function WhiteboardMask()
      {
         super();
      }
      
      public function set sequence(param1:Vector.<MaskGridModel>) : void
      {
         if(param1 != this._sequence)
         {
            this._sequence = param1;
         }
      }
      
      public function playMask(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PlayerMaskGridModel = null;
         var _loc6_:Rectangle = null;
         if(this._sequence && this._sequence.length > 0 && param1 >= 0 && param1 <= 1)
         {
            _loc2_ = int(Math.round(param1 * (this._sequence.length - 1)));
            if(_loc2_ < this._lastIndex)
            {
               this.graphics.clear();
               this._lastIndex = 0;
               this._lastDrawnGrid = null;
            }
            _loc3_ = this._lastIndex == 0?0:int(this._lastIndex + 1);
            _loc4_ = _loc3_;
            for(; _loc4_ < this._sequence.length; _loc4_++)
            {
               if(_loc4_ > _loc2_)
               {
                  break;
               }
               _loc5_ = this._sequence[_loc4_] as PlayerMaskGridModel;
               if(_loc5_)
               {
                  if(this._lastDrawnGrid)
                  {
                     if(this._lastDrawnGrid.drawingX == _loc5_.drawingX && this._lastDrawnGrid.drawingY == _loc5_.drawingY && this._lastDrawnGrid.drawingBrushSize == _loc5_.drawingBrushSize)
                     {
                        continue;
                     }
                  }
                  if(_loc5_ is RectanglarMaskGridModel)
                  {
                     this.graphics.beginFill(16711680);
                     _loc6_ = (_loc5_ as RectanglarMaskGridModel).rect;
                     this.graphics.drawRect(_loc6_.x,_loc6_.y,_loc6_.width,_loc6_.height);
                     this.graphics.endFill();
                  }
                  else if(_loc5_)
                  {
                     this.graphics.beginFill(16711680);
                     this.graphics.drawCircle(_loc5_.drawingX,_loc5_.drawingY,_loc5_.drawingBrushSize);
                     this.graphics.endFill();
                     this._lastDrawnGrid = _loc5_;
                     continue;
                  }
               }
            }
            this._lastIndex = _loc2_;
         }
      }
   }
}
