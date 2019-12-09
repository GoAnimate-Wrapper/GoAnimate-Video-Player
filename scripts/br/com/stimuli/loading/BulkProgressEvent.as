package br.com.stimuli.loading
{
   import flash.events.Event;
   import flash.events.ProgressEvent;
   
   public class BulkProgressEvent extends ProgressEvent
   {
      
      public static const PROGRESS:String = "progress";
      
      public static const COMPLETE:String = "complete";
       
      
      public var bytesTotalCurrent:int;
      
      public var _ratioLoaded:Number;
      
      public var _percentLoaded:Number;
      
      public var _weightPercent:Number;
      
      public var itemsLoaded:int;
      
      public var itemsTotal:int;
      
      public var name:String;
      
      public function BulkProgressEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
      {
         super(param1,param2,param3);
         this.name = param1;
      }
      
      public function setInfo(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Number) : void
      {
         this.bytesLoaded = param1;
         this.bytesTotal = param2;
         this.bytesTotalCurrent = param3;
         this.itemsLoaded = param4;
         this.itemsTotal = param5;
         this.weightPercent = param6;
         this.percentLoaded = param2 > 0?Number(param1 / param2):Number(0);
         this.ratioLoaded = param5 == 0?Number(0):Number(param4 / param5);
      }
      
      override public function clone() : Event
      {
         var _loc1_:BulkProgressEvent = new BulkProgressEvent(this.name,bubbles,cancelable);
         _loc1_.setInfo(bytesLoaded,bytesTotal,this.bytesTotalCurrent,this.itemsLoaded,this.itemsTotal,this.weightPercent);
         return _loc1_;
      }
      
      public function loadingStatus() : String
      {
         var _loc1_:Array = [];
         _loc1_.push("bytesLoaded: " + bytesLoaded);
         _loc1_.push("bytesTotal: " + bytesTotal);
         _loc1_.push("itemsLoaded: " + this.itemsLoaded);
         _loc1_.push("itemsTotal: " + this.itemsTotal);
         _loc1_.push("bytesTotalCurrent: " + this.bytesTotalCurrent);
         _loc1_.push("percentLoaded: " + BulkLoader.truncateNumber(this.percentLoaded));
         _loc1_.push("weightPercent: " + BulkLoader.truncateNumber(this.weightPercent));
         _loc1_.push("ratioLoaded: " + BulkLoader.truncateNumber(this.ratioLoaded));
         return "BulkProgressEvent " + _loc1_.join(", ") + ";";
      }
      
      public function get weightPercent() : Number
      {
         return this._weightPercent;
      }
      
      public function set weightPercent(param1:Number) : void
      {
         if(isNaN(param1) || !isFinite(param1))
         {
            param1 = 0;
         }
         this._weightPercent = param1;
      }
      
      public function get percentLoaded() : Number
      {
         return this._percentLoaded;
      }
      
      public function set percentLoaded(param1:Number) : void
      {
         if(isNaN(param1) || !isFinite(param1))
         {
            param1 = 0;
         }
         this._percentLoaded = param1;
      }
      
      public function get ratioLoaded() : Number
      {
         return this._ratioLoaded;
      }
      
      public function set ratioLoaded(param1:Number) : void
      {
         if(isNaN(param1) || !isFinite(param1))
         {
            param1 = 0;
         }
         this._ratioLoaded = param1;
      }
      
      override public function toString() : String
      {
         return super.toString();
      }
   }
}
