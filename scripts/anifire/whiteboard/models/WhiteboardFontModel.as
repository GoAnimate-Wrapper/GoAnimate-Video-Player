package anifire.whiteboard.models
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class WhiteboardFontModel implements IExternalizable
   {
       
      
      private var glyphs:Object;
      
      private var boldGlyphs:Object;
      
      public function WhiteboardFontModel()
      {
         super();
         this.glyphs = {};
         this.boldGlyphs = {};
      }
      
      public function saveGlyph(param1:String, param2:WhiteboardModel, param3:Boolean = false) : void
      {
         var _loc4_:WhiteboardModel = new WhiteboardModel();
         var _loc5_:int = param2.sequence.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_.sequence.push(param2.sequence[_loc6_].clone());
            _loc6_++;
         }
         if(param3)
         {
            this.boldGlyphs[param1] = _loc4_;
         }
         else
         {
            this.glyphs[param1] = _loc4_;
         }
      }
      
      public function loadGlyph(param1:String, param2:Boolean = false) : WhiteboardModel
      {
         var _loc4_:WhiteboardModel = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:WhiteboardModel = this.getGlyph(param1,param2);
         if(_loc3_)
         {
            _loc4_ = new WhiteboardModel();
            _loc5_ = _loc3_.sequence.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc4_.sequence.push(_loc3_.sequence[_loc6_].clone());
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      public function getGlyph(param1:String, param2:Boolean) : WhiteboardModel
      {
         return !!param2?this.boldGlyphs[param1]:this.glyphs[param1];
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeObject(this.glyphs);
         param1.writeObject(this.boldGlyphs);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         this.glyphs = param1.readObject();
         this.boldGlyphs = param1.readObject();
      }
   }
}
