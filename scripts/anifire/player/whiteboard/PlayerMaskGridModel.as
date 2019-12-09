package anifire.player.whiteboard
{
   import anifire.whiteboard.models.MaskGridModel;
   
   public class PlayerMaskGridModel extends MaskGridModel
   {
       
      
      public var drawingX:Number = 0;
      
      public var drawingY:Number = 0;
      
      public var drawingBrushSize:Number = 1;
      
      public function PlayerMaskGridModel()
      {
         super();
      }
      
      public function init(param1:MaskGridModel) : void
      {
         if(param1)
         {
            this.drawingX = x = param1.x;
            this.drawingY = y = param1.y;
            brushSize = param1.brushSize;
            this.drawingBrushSize = brushSize + 1;
         }
      }
   }
}
