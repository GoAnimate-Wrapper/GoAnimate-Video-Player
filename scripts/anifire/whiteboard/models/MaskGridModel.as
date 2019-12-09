package anifire.whiteboard.models
{
   import flash.events.EventDispatcher;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class MaskGridModel extends EventDispatcher implements IExternalizable
   {
       
      
      public var x:int;
      
      public var y:int;
      
      public var brushSize:int;
      
      public function MaskGridModel()
      {
         super();
         this.reset();
      }
      
      public function clone() : MaskGridModel
      {
         var _loc1_:MaskGridModel = new MaskGridModel();
         _loc1_.x = this.x;
         _loc1_.y = this.y;
         _loc1_.brushSize = this.brushSize;
         return _loc1_;
      }
      
      public function reset() : void
      {
         this.x = 0;
         this.y = 0;
         this.brushSize = 1;
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeInt(this.x);
         param1.writeInt(this.y);
         param1.writeInt(this.brushSize);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         this.x = param1.readInt();
         this.y = param1.readInt();
         this.brushSize = param1.readInt();
      }
   }
}
