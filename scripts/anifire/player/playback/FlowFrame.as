package anifire.player.playback
{
	import anifire.component.flowFrames.FlowFrameMaker;
	import anifire.constant.ThemeConstants;
	import anifire.event.FlowFrameMakerEvent;
	import anifire.managers.CCThemeManager;
	import anifire.models.AssetModel;
	import anifire.player.managers.FlowFrameInfoManager;
	import anifire.util.UtilPlain;
	
	public class FlowFrame extends Prop
	{
		
		public static const XML_TAG:String = "imgframe";
		
		public static const XML_NODE_NAME_WIDTH:String = "width";
		
		public static const XML_NODE_NAME_HEIGHT:String = "height";
		
		public static const XML_NODE_NAME_COLOR:String = "color";
		
		public static const XML_NODE_NAME_OPACITY:String = "opacity";
		
		public static const XML_NODE_NAME_IMAGE_FILE:String = "imgfile";
		
		public static const XML_NODE_NAME_IMAGE_SCALE_X:String = "imgsx";
		
		public static const XML_NODE_NAME_IMAGE_SCALE_Y:String = "imgsy";
		
		public static const XML_NODE_NAME_IMAGE_X:String = "imgx";
		
		public static const XML_NODE_NAME_IMAGE_Y:String = "imgy";
		
		public static const XML_NODE_NAME_IMAGE_ROTATION:String = "imgrot";
		 
		
		private var _flowFrameMaker:FlowFrameMaker;
		
		private var _flowFrameFileId:String;
		
		private var _flowFrameXml:XML;
		
		private var _flowFrameThumbXml:XML;
		
		private var _flowWidth:Number = 0;
		
		private var _flowHeight:Number = 0;
		
		private var _innerImageFileId:String;
		
		private var _baseColor:uint = 0;
		
		private var _opacity:int = 0;
		
		private var _innerImageScaleX:Number = 1;
		
		private var _innerImageScaleY:Number = 1;
		
		private var _innerImageX:Number = 0;
		
		private var _innerImageY:Number = 0;
		
		private var _innerImageRotation:Number = 0;
		
		public function FlowFrame()
		{
			super();
		}
		
		override protected function getIsVideo() : Boolean
		{
			return false;
		}
		
		override public function init(param1:XML, param2:AnimeScene, param3:PlayerDataStock) : Boolean
		{
			_dataStock = param3;
			if(param1)
			{
				super.initAsset(param1.@id,param1.@index,param2);
				this._xs = String(param1["x"]).split(",");
				this._ys = String(param1["y"]).split(",");
				this._xscales = String(param1["xscale"]).split(",");
				this._yscales = String(param1["yscale"]).split(",");
				this._rotations = String(param1["rotation"]).split(",");
				this._facings = String(param1["face"]).split(",");
				this.facing = this._facings[0];
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
				this._flowFrameXml = param1;
				this._flowFrameFileId = this._flowFrameXml.file[0].toString();
				return true;
			}
			return false;
		}
		
		override protected function flip() : void
		{
			if(this.facing == Prop.FACE_POSITIVE)
			{
				UtilPlain.flipObj(this._flowFrameMaker,true,false);
			}
			else
			{
				UtilPlain.flipObj(this._flowFrameMaker,false,true);
			}
		}
		
		override public function initRemoteData(param1:PlayerDataStock, param2:int = 0, param3:Boolean = false) : void
		{
			this._flowFrameMaker = new FlowFrameMaker();
			this._flowFrameThumbXml = FlowFrameInfoManager.instance.getFlowFrameXml(this._flowFrameFileId,param1.getThemeXMLs());
			if(this._flowFrameThumbXml)
			{
				this._flowFrameMaker.readNode(this._flowFrameThumbXml);
			}
			if(this._flowFrameXml.hasOwnProperty(XML_NODE_NAME_COLOR))
			{
				this._baseColor = uint(this._flowFrameXml.color[0]);
				this._flowFrameMaker.baseColor = this._baseColor;
			}
			if(this._flowFrameXml.hasOwnProperty(XML_NODE_NAME_OPACITY))
			{
				this._opacity = int(this._flowFrameXml.child(XML_NODE_NAME_OPACITY)[0]);
				this._flowFrameMaker.opacity = this._opacity;
			}
			this._flowWidth = Number(this._flowFrameXml.child(XML_NODE_NAME_WIDTH)[0]);
			this._flowHeight = Number(this._flowFrameXml.child(XML_NODE_NAME_HEIGHT)[0]);
			this._flowFrameMaker.resizeFrame(this._flowWidth,this._flowHeight);
			if(this._flowFrameXml.hasOwnProperty(XML_NODE_NAME_IMAGE_FILE))
			{
				this._innerImageFileId = this._flowFrameXml.child(XML_NODE_NAME_IMAGE_FILE)[0];
			}
			else
			{
				this._innerImageFileId = null;
			}
			this.initFlowImage();
			this.initInnerImage();
			if(this._innerImageFileId != null)
			{
				if(this._flowFrameXml.hasOwnProperty(XML_NODE_NAME_IMAGE_SCALE_X))
				{
					this._innerImageScaleX = Number(this._flowFrameXml.child(XML_NODE_NAME_IMAGE_SCALE_X)[0]);
				}
				if(this._flowFrameXml.hasOwnProperty(XML_NODE_NAME_IMAGE_SCALE_Y))
				{
					this._innerImageScaleY = Number(this._flowFrameXml.child(XML_NODE_NAME_IMAGE_SCALE_Y)[0]);
				}
				if(this._flowFrameXml.hasOwnProperty(XML_NODE_NAME_IMAGE_X))
				{
					this._innerImageX = Number(this._flowFrameXml.child(XML_NODE_NAME_IMAGE_X)[0]);
				}
				if(this._flowFrameXml.hasOwnProperty(XML_NODE_NAME_IMAGE_Y))
				{
					this._innerImageY = Number(this._flowFrameXml.child(XML_NODE_NAME_IMAGE_Y)[0]);
				}
				if(this._flowFrameXml.hasOwnProperty(XML_NODE_NAME_IMAGE_ROTATION))
				{
					this._innerImageRotation = Number(this._flowFrameXml.child(XML_NODE_NAME_IMAGE_ROTATION)[0]);
				}
			}
			this._flowFrameMaker.addEventListener(FlowFrameMakerEvent.LOAD_IMAGE_COMPLETE,this.flowFrameMaker_loadImageCompleteHandler);
			this._flowFrameMaker.loadImage();
			this.getBundle().addChild(this._flowFrameMaker);
		}
		
		private function loadFlowImage() : void
		{
			var _loc1_:int = 0;
			var _loc2_:String = null;
			var _loc3_:String = null;
			if(this._flowFrameMaker)
			{
				_loc1_ = this._flowFrameFileId.indexOf(".");
				if(_loc1_ > -1)
				{
					_loc2_ = this._flowFrameFileId.substring(0,_loc1_);
					_loc3_ = this._flowFrameFileId.substring(_loc1_ + 1);
					this._flowFrameMaker.updateFlowImageSource(_loc2_,_loc3_);
				}
			}
		}
		
		private function updateInnerImageProperties() : void
		{
			this._flowFrameMaker.moveInnerImage(this._innerImageX,this._innerImageY);
			this._flowFrameMaker.scaleInnerImage(this._innerImageScaleX,this._innerImageScaleY);
			this._flowFrameMaker.rotateInnerImage(this._innerImageRotation);
		}
		
		protected function initFlowImage() : void
		{
			var _loc2_:String = null;
			var _loc3_:String = null;
			var _loc1_:int = this._flowFrameFileId.indexOf(".");
			if(_loc1_ > -1)
			{
				_loc2_ = this._flowFrameFileId.substring(0,_loc1_);
				_loc3_ = this._flowFrameFileId.substring(_loc1_ + 1);
				this._flowFrameMaker.initFlowImageSource(_loc2_,_loc3_);
			}
		}
		
		private function initInnerImage() : void
		{
			var _loc1_:String = null;
			var _loc2_:String = null;
			var _loc3_:String = null;
			var _loc4_:String = null;
			var _loc5_:int = 0;
			var _loc6_:AssetModel = null;
			if(this._innerImageFileId != null)
			{
				_loc5_ = this._innerImageFileId.indexOf(".");
				if(_loc5_ > 0)
				{
					_loc1_ = this._innerImageFileId.substring(0,_loc5_);
					_loc2_ = this._innerImageFileId.substring(_loc5_ + 1);
					_loc5_ = _loc2_.indexOf(".");
					if(_loc1_ == ThemeConstants.UGC_THEME_ID)
					{
						_loc6_ = CCThemeManager.instance.getThemeModel(_loc1_).getPropModel(_loc2_);
						if(_loc6_)
						{
							_loc3_ = _loc6_.encAssetId;
							_loc4_ = _loc6_.signature;
						}
					}
				}
			}
			this._flowFrameMaker.initInnerImageSource(_loc1_,_loc3_,false,_loc4_);
		}
		
		private function flowFrameMaker_loadImageCompleteHandler(param1:FlowFrameMakerEvent) : void
		{
			this._flowFrameMaker.removeEventListener(FlowFrameMakerEvent.LOAD_IMAGE_COMPLETE,this.flowFrameMaker_loadImageCompleteHandler);
			this.updateInnerImageProperties();
			initAllTransitionsRemoteData();
		}
		
		override public function prepareImage() : void
		{
		}
		
		public function get flowFrameMaker() : FlowFrameMaker
		{
			return this._flowFrameMaker;
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
