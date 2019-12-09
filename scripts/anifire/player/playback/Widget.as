package anifire.player.playback
{
   import anifire.component.widgets.IconWidget;
   import anifire.component.widgets.RepeatIconWidget;
   import anifire.component.widgets.WidgetFactory;
   import anifire.component.widgets.WidgetMaker;
   import anifire.event.WidgetEvent;
   import anifire.models.widget.WidgetPartModel;
   import anifire.models.widget.WidgetStyleModel;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class Widget extends Prop
   {
      
      public static const XML_TAG:String = "widget";
       
      
      private var _chartType:String;
      
      private var _title:String;
      
      private var _styleModel:WidgetStyleModel;
      
      private var _dataRows:Vector.<WidgetPartModel>;
      
      private var _widgetMaker:WidgetMaker;
      
      protected var _displayInPercentage:Boolean;
      
      protected var _displayDataLabel:Boolean;
      
      protected var _displayValueLabel:Boolean;
      
      protected var _displayAxis:Boolean;
      
      protected var _displayLegend:Boolean;
      
      protected var _numberFormatType:int;
      
      protected var _iconDirection:String;
      
      private var _propId:String;
      
      private var _bounds:Rectangle;
      
      private var _dataRanges:Vector.<String>;
      
      protected var _gridRows:int;
      
      protected var _gridColumns:int;
      
      public function Widget()
      {
         this._bounds = new Rectangle(-50,-50,100,100);
         super();
      }
      
      override public function init(param1:XML, param2:AnimeScene, param3:PlayerDataStock) : Boolean
      {
         if(param1)
         {
            super.initAsset(param1.@id,param1.@index,param2);
            this._xs = String(param1["x"]).split(",");
            this._ys = String(param1["y"]).split(",");
            this._xscales = String(param1["xscale"]).split(",");
            this._yscales = String(param1["yscale"]).split(",");
            this._rotations = String(param1["rotation"]).split(",");
            this.facing = "1";
            if(_xs.length > 1)
            {
               _motion = new SlideMotion();
               SlideMotion(_motion).init(_xs,_ys,_xscales,_yscales,_rotations);
               if(param1.hasOwnProperty(SlideMotion.XML_TAG_NAME))
               {
                  SlideMotion(_motion).convertFromXml(param1.child(SlideMotion.XML_TAG_NAME)[0]);
               }
               _motionCache = new MotionCache(_motion,param2.totalFrame);
            }
            if(param1.hasOwnProperty("chart"))
            {
               this.deserializeChartXml(param1.chart[0]);
            }
            return true;
         }
         return false;
      }
      
      private function deserializeChartXml(param1:XML) : void
      {
         if(param1.hasOwnProperty("@type"))
         {
            this._chartType = String(param1.@type);
         }
         if(param1.hasOwnProperty("bounds"))
         {
            this._bounds.x = Number(param1.bounds.x);
            this._bounds.y = Number(param1.bounds.y);
            this._bounds.width = Number(param1.bounds.width);
            this._bounds.height = Number(param1.bounds.height);
         }
         if(param1.hasOwnProperty("range"))
         {
            this.deserializeRange(param1.range[0]);
         }
         this._displayDataLabel = String(param1.@dataLabel) == "Y";
         this._displayValueLabel = String(param1.@valueLabel) == "Y";
         this._displayInPercentage = String(param1.@percentLabel) == "Y";
         this._displayAxis = String(param1.@axis) == "Y";
         this._displayLegend = String(param1.@legend) == "Y";
         this._numberFormatType = int(param1.@format);
         if(param1.hasOwnProperty("@gCol"))
         {
            this._gridColumns = int(param1.@gCol);
         }
         else
         {
            this._gridColumns = 1;
         }
         if(param1.hasOwnProperty("@gRow"))
         {
            this._gridRows = int(param1.@gRow);
         }
         else
         {
            this._gridRows = 1;
         }
         if(param1.hasOwnProperty("title"))
         {
            this._title = String(param1.title);
         }
         if(param1.hasOwnProperty("data"))
         {
            this.deserializeData(param1.data[0]);
         }
         if(param1.hasOwnProperty("style"))
         {
            this.deserializeStyle(param1.style[0]);
         }
         if(param1.hasOwnProperty("prop"))
         {
            this.deserializeProp(param1.prop[0]);
         }
         if(param1.hasOwnProperty("@iconFill"))
         {
            this._iconDirection = param1.@iconFill;
         }
      }
      
      override protected function getIsVideo() : Boolean
      {
         return false;
      }
      
      override public function initRemoteData(param1:PlayerDataStock, param2:int = 0, param3:Boolean = false) : void
      {
         this._widgetMaker = WidgetFactory.createWidgetMaker(this._chartType);
         this._widgetMaker.displayValueLabel = this._displayValueLabel;
         this._widgetMaker.displayPercentageLabel = this._displayInPercentage;
         this._widgetMaker.displayDataLabel = this._displayDataLabel;
         this._widgetMaker.displayAxis = this._displayAxis;
         this._widgetMaker.displayLegend = this._displayLegend;
         this._widgetMaker.numberFormatType = this._numberFormatType;
         if(this._styleModel)
         {
            this._widgetMaker.styleModel = this._styleModel;
         }
         if(this._dataRanges)
         {
            this._widgetMaker.updateRanges(this._dataRanges);
         }
         if(this._dataRows)
         {
            this._widgetMaker.updateModel(this._dataRows);
         }
         if(this._iconDirection != null && this._iconDirection != "")
         {
            this._widgetMaker.iconDirection = this._iconDirection;
         }
         var _loc4_:RepeatIconWidget = this._widgetMaker as RepeatIconWidget;
         if(_loc4_)
         {
            _loc4_.rows = this._gridRows;
            _loc4_.columns = this._gridColumns;
         }
         this._widgetMaker.bounds = this._bounds;
         this._widgetMaker.title = this._title;
         this._widgetMaker.validate();
         this.getBundle().addChild(this._widgetMaker);
         if(this._propId)
         {
            this.loadProp();
         }
         else
         {
            this.initAllTransitionsRemoteData();
         }
      }
      
      private function loadProp() : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:IconWidget = this._widgetMaker as IconWidget;
         if(_loc1_)
         {
            _loc2_ = this._propId.indexOf(".");
            if(_loc2_ > 0)
            {
               _loc3_ = this._propId.substring(0,_loc2_);
               _loc4_ = this._propId.substring(_loc2_ + 1);
               _loc2_ = _loc4_.indexOf(".");
               if(_loc3_ == "ugc")
               {
                  _loc4_ = _loc4_.substring(0,_loc2_);
               }
               if(_loc2_ > 0 && _loc2_ != _loc4_.length - 4)
               {
                  _loc5_ = _loc4_.substring(_loc2_ + 1);
                  _loc4_ = _loc4_.substring(0,_loc2_);
               }
               _loc1_.addEventListener(WidgetEvent.WIDGET_ICON_LOAD_COMPLETE,this.widgetMaker_loadPropCompleteHandler);
               _loc1_.updateIconImage(_loc3_,_loc4_,_loc5_);
            }
         }
      }
      
      private function widgetMaker_loadPropCompleteHandler(param1:Event) : void
      {
         this._widgetMaker.removeEventListener(WidgetEvent.WIDGET_ICON_LOAD_COMPLETE,this.widgetMaker_loadPropCompleteHandler);
         this.initAllTransitionsRemoteData();
      }
      
      private function deserializeRange(param1:XML) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1)
         {
            this._dataRanges = new Vector.<String>();
            _loc2_ = param1.cell;
            _loc3_ = _loc2_.length();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               this._dataRanges.push(String(_loc2_[_loc4_]));
               _loc4_++;
            }
         }
      }
      
      private function deserializeData(param1:XML) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XMLList = null;
         var _loc4_:WidgetPartModel = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 && param1.hasOwnProperty("row"))
         {
            this._dataRows = new Vector.<WidgetPartModel>();
            _loc2_ = param1.row;
            _loc5_ = _loc2_.length();
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc3_ = _loc2_[_loc6_].cell;
               if(_loc3_)
               {
                  _loc4_ = new WidgetPartModel();
                  _loc4_.readFromXml(_loc3_);
                  this._dataRows.push(_loc4_);
               }
               _loc6_++;
            }
         }
      }
      
      private function deserializeStyle(param1:XML) : void
      {
         this._styleModel = new WidgetStyleModel();
         this._styleModel.deserialize(param1);
      }
      
      private function deserializeProp(param1:XML) : void
      {
         this._propId = param1.file[0].toString();
      }
      
      override public function prepareImage() : void
      {
      }
      
      public function get widgetMaker() : WidgetMaker
      {
         return this._widgetMaker;
      }
      
      override public function resumeBundle() : void
      {
      }
      
      override public function goToAndPauseBundle(param1:uint) : void
      {
      }
      
      override public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
      {
      }
   }
}
