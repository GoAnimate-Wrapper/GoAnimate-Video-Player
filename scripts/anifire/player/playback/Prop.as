package anifire.player.playback
{
	import anifire.assets.AssetImageLibrary;
	import anifire.assets.AssetImageLibraryObject;
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.assets.transition.AssetTransitionNode;
	import anifire.color.SelectedColor;
	import anifire.component.CustomHeadMaker;
	import anifire.component.SkinnedHeadMaker;
	import anifire.constant.RaceConstants;
	import anifire.event.LoadEmbedMovieEvent;
	import anifire.interfaces.IRegulatedProcess;
	import anifire.managers.CCBodyManager;
	import anifire.managers.CCThemeManager;
	import anifire.models.AssetModel;
	import anifire.models.creator.CCBodyModel;
	import anifire.models.creator.CCCharacterActionModel;
	import anifire.player.interfaces.IAssetMotion;
	import anifire.player.interfaces.IPlayback;
	import anifire.player.managers.DownloadManager;
	import anifire.sound.VideoNetStreamController;
	import anifire.util.UtilColor;
	import anifire.util.UtilCommonLoader;
	import anifire.util.UtilErrorLogger;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilHashBytes;
	import anifire.util.UtilHashSelectedColor;
	import anifire.util.UtilNetwork;
	import anifire.util.UtilPlain;
	import anifire.util.UtilUnitConvert;
	import anifire.util.UtilXmlInfo;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class Prop extends Asset implements IRegulatedProcess, IPlayback
	{
		
		private static const STATE_NULL:int = 0;
		
		private static const STATE_ACTION:int = 1;
		
		private static const STATE_MOTION:int = 2;
		
		private static const STATE_FADE:int = 3;
		
		public static const FACE_POSITIVE:String = "1";
		
		public static const FACE_NEGATIVE:String = "-1";
		
		public static const XML_TAG:String = "prop";
		
		public static const XML_TAG_HEAD:String = "head";
		
		public static const XML_TAG_WEAR:String = "wear";
		
		private static var _boundBeforeCenterAlignLibrary:Object = new Object();
		 
		
		private var _file:String;
		
		private var _loader:DisplayObjectContainer;
		
		private var _xscale:Number = 1;
		
		public var _xscales:Array;
		
		private var _yscale:Number = 1;
		
		public var _yscales:Array;
		
		private var _rotation:Number;
		
		protected var _rotations:Array;
		
		private var _propInNextScene:Prop;
		
		private var _propInPrevScene:Prop;
		
		private var _isFirstProp:Boolean = false;
		
		private var _firstProp:Prop = null;
		
		private var _facing:String;
		
		public var _facings:Array;
		
		private var _imageData:ByteArray;
		
		private var _handStyle:String = "";
		
		private var _isCC:Boolean = false;
		
		private var _videoNetStreamController:VideoNetStreamController;
		
		private var _lookAtCamera:Boolean = false;
		
		public var _isContentSet:Boolean = false;
		
		private var _isSpeech:Boolean = false;
		
		private var _sceneId:String;
		
		private var _assetImageId:Number = 0;
		
		private var _headXML:XML;
		
		protected var _motion:IAssetMotion;
		
		protected var _motionCache:MotionCache;
		
		private var _motionStartFrame:int = 1;
		
		private var _motionEndFrame:int = -1;
		
		private var _hasMask:Boolean;
		
		private var _boundBeforeCenterAlign:Rectangle;
		
		public function Prop()
		{
			super();
		}
		
		public static function isChanged(param1:Prop, param2:Prop) : Boolean
		{
			if(param1._x != param2._x || param1._y != param2._y || param1._xscale != param2._xscale || param1._yscale != param2._yscale || param1._rotation != param2._rotation)
			{
				return true;
			}
			return false;
		}
		
		public static function connectPropsIfNecessary(param1:Prop, param2:Prop) : Boolean
		{
			if(param1 == null || param2 == null)
			{
				return false;
			}
			if(param1.file != param2.file)
			{
				return false;
			}
			var _loc3_:Point = new Point(param1._xs[param1._xs.length - 1],param1._ys[param1._ys.length - 1]);
			var _loc4_:Point = new Point(param2._xs[0],param2._ys[0]);
			if(Point.distance(_loc3_,_loc4_) > 1)
			{
				return false;
			}
			param1._propInNextScene = param2;
			param2._propInPrevScene = param1;
			return true;
		}
		
		public static function connectPropsBetweenScenes(param1:Vector.<Prop>, param2:Vector.<Prop>) : void
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:Prop = null;
			var _loc7_:Prop = null;
			var _loc8_:Vector.<Prop> = null;
			if(param1 && param2 && param1.length > 0 && param2.length > 0)
			{
				_loc8_ = param2.concat();
				_loc5_ = param1.length;
				_loc3_ = 0;
				while(_loc3_ < _loc5_)
				{
					_loc6_ = param1[_loc3_];
					_loc4_ = 0;
					while(_loc4_ < _loc8_.length)
					{
						_loc7_ = _loc8_[_loc4_];
						if(connectPropsIfNecessary(_loc6_,_loc7_))
						{
							_loc8_.splice(_loc4_,1);
							break;
						}
						_loc4_++;
					}
					_loc3_++;
				}
			}
		}
		
		private function get bundle() : DisplayObjectContainer
		{
			return _bundle;
		}
		
		public function get assetImageId() : Number
		{
			return this._assetImageId;
		}
		
		public function set sceneId(param1:String) : void
		{
			this._sceneId = param1;
		}
		
		public function get sceneId() : String
		{
			return this._sceneId;
		}
		
		public function get isSpeech() : Boolean
		{
			return this._isSpeech;
		}
		
		public function set isSpeech(param1:Boolean) : void
		{
			this._isSpeech = param1;
		}
		
		public function get lookAtCamera() : Boolean
		{
			return this._lookAtCamera;
		}
		
		public function set lookAtCamera(param1:Boolean) : void
		{
			this._lookAtCamera = param1;
		}
		
		public function get isCC() : Boolean
		{
			return raceCode == RaceConstants.CUSTOM_CHARACTER;
		}
		
		public function set isCC(param1:Boolean) : void
		{
			this._isCC = param1;
		}
		
		public function get file() : String
		{
			return this._file;
		}
		
		public function set file(param1:String) : void
		{
			var _loc2_:RegExp = /.zip/gi;
			this._file = param1.replace(_loc2_,".xml");
		}
		
		public function get facing() : String
		{
			return this._facing;
		}
		
		public function set facing(param1:String) : void
		{
			this._facing = param1;
		}
		
		public function get imageData() : ByteArray
		{
			return this._imageData;
		}
		
		public function set imageData(param1:ByteArray) : void
		{
			this._imageData = param1;
		}
		
		public function get handStyle() : String
		{
			return this._handStyle;
		}
		
		public function set handStyle(param1:String) : void
		{
			this._handStyle = param1;
		}
		
		public function getLoader() : DisplayObjectContainer
		{
			return this._loader;
		}
		
		private function setLoader(param1:DisplayObjectContainer) : void
		{
			this._loader = param1;
		}
		
		private function get objInsideBundle() : DisplayObject
		{
			if(this.getIsVideo())
			{
				return this.videoNetStreamController.getVideoContainer();
			}
			return this.getLoader();
		}
		
		private function get videoNetStreamController() : VideoNetStreamController
		{
			return this._videoNetStreamController;
		}
		
		private function set videoNetStreamController(param1:VideoNetStreamController) : void
		{
			this._videoNetStreamController = param1;
		}
		
		public function get isFirstProp() : Boolean
		{
			return this._isFirstProp;
		}
		
		public function set isFirstProp(param1:Boolean) : void
		{
			this._isFirstProp = param1;
		}
		
		private function get firstProp() : Prop
		{
			return this._firstProp;
		}
		
		private function set firstProp(param1:Prop) : void
		{
			this._firstProp = param1;
		}
		
		public function get isContentSet() : Boolean
		{
			return this._isContentSet;
		}
		
		public function set isContentSet(param1:Boolean) : void
		{
			this._isContentSet = param1;
		}
		
		protected function getIsVideo() : Boolean
		{
			var _loc1_:Array = this.file.split(".");
			if(_loc1_[_loc1_.length - 1] == "flv")
			{
				return true;
			}
			return false;
		}
		
		public function init(param1:XML, param2:AnimeScene, param3:PlayerDataStock) : Boolean
		{
			var colorXML:XML = null;
			var themeXML:XML = null;
			var assetId:String = null;
			var cc_themeId:String = null;
			var selectedColor:SelectedColor = null;
			var propXML:XML = param1;
			var iParentScene:AnimeScene = param2;
			var dataStock:PlayerDataStock = param3;
			_dataStock = dataStock;
			var isInitSuccessful:Boolean = true;
			this.raceCode = propXML.@isCC == "Y"?1:0;
			this.raceCode = propXML.@raceCode.length() > 0?int(int(propXML.@raceCode)):int(this.raceCode);
			this.handStyle = propXML.@handstyle.length() == 0?"":propXML.@handstyle;
			try
			{
				if(iParentScene == null)
				{
					this.file = UtilXmlInfo.getZipFileNameOfProp(propXML.child("file")[0].toString());
					this.setBundle(new Sprite());
				}
				else
				{
					super.initAsset(propXML.@id,propXML.@index,iParentScene);
					this.file = UtilXmlInfo.getZipFileNameOfProp(propXML.child("file")[0].toString());
					this._xs = String(propXML["x"]).split(",");
					this._ys = String(propXML["y"]).split(",");
					this._xscales = String(propXML["xscale"]).split(",");
					this._yscales = String(propXML["yscale"]).split(",");
					this._rotations = String(propXML["rotation"]).split(",");
					this._facings = String(propXML["face"]).split(",");
					this.facing = this._facings[0];
					if(_xs.length > 1)
					{
						this._motion = new SlideMotion();
						SlideMotion(this._motion).init(_xs,_ys,this._xscales,this._yscales,this._rotations);
						if(propXML.hasOwnProperty(SlideMotion.XML_TAG_NAME))
						{
							SlideMotion(this._motion).convertFromXml(propXML.child(SlideMotion.XML_TAG_NAME)[0]);
						}
						this._motionCache = new MotionCache(this._motion,iParentScene.totalFrame);
					}
					this.bundle.scaleX = this._xscales[0];
					this.bundle.scaleY = this._yscales[0];
					this.bundle.rotation = this._rotations[0];
					this._sceneId = iParentScene.id;
				}
				_bundle.blendMode = BlendMode.LAYER;
				this.themeId = UtilXmlInfo.getThemeIdFromFileName(this.file);
				if(themeId != "ugc")
				{
					dataStock.decryptPlayerData(this.file);
				}
				themeXML = dataStock.getThemeXMLs().getValueByKey(themeId) as XML;
				if(!themeXML)
				{
					return false;
				}
				assetId = UtilXmlInfo.getCharIdFromFacialFileName(this.file);
				cc_themeId = themeXML.char.(@id == assetId).@cc_theme_id;
				if(cc_themeId)
				{
					this.initPropForCC(dataStock);
				}
			}
			catch(e:Error)
			{
				isInitSuccessful = false;
			}
			if(!this.getIsVideo() && dataStock.getPlayerData(this.file) == null)
			{
				isInitSuccessful = false;
			}
			var j:uint = 0;
			customColor = new UtilHashSelectedColor();
			j = 0;
			while(j < propXML.child("color").length())
			{
				colorXML = propXML.child("color")[j];
				selectedColor = new SelectedColor(colorXML.@r,colorXML.attribute("oc").length() == 0?uint(uint.MAX_VALUE):uint(colorXML.@oc),uint(colorXML));
				addCustomColor(colorXML.@r,selectedColor);
				j++;
			}
			if(isInitSuccessful)
			{
				return true;
			}
			return false;
		}
		
		private function initPropForCC(param1:PlayerDataStock) : Boolean
		{
			var _loc6_:CCCharacterActionModel = null;
			var _loc7_:String = null;
			var _loc2_:String = UtilXmlInfo.getFacialIdFromFileName(this.file);
			var _loc3_:String = UtilXmlInfo.getCompFileNameOfBehaviour(this.file);
			var _loc4_:XML = param1.getPlayerData(_loc3_) as XML;
			var _loc5_:CCBodyModel = CCBodyManager.instance.getBodyModel(UtilXmlInfo.getCharIdFromFacialFileName(this.file));
			if(_loc4_)
			{
				if(!_loc5_.completed)
				{
					_loc5_.parse(_loc4_);
				}
				_loc7_ = _loc5_.themeId;
				_loc6_ = CCThemeManager.instance.getThemeModel(_loc7_).getCharacterFacialModel(_loc5_,_loc2_);
			}
			if(_loc6_)
			{
				param1.addCamAsPlayerData(this.file,_loc6_);
				return true;
			}
			UtilErrorLogger.getInstance().error("Behaviour:initBehaviour: no cam data: " + this.file);
			return false;
		}
		
		public function initDependency(param1:DownloadManager, param2:UtilHashArray) : void
		{
			var currentProp:Prop = null;
			var videoDurationInSecond:Number = NaN;
			var THUMB_ID_REGEX:RegExp = null;
			var thumbId:String = null;
			var propModel:AssetModel = null;
			var propXMLinThemeXML:XML = null;
			var themeId:String = null;
			var charId:String = null;
			var themeXML:XML = null;
			var result:XMLList = null;
			var item:XML = null;
			var downloadManager:DownloadManager = param1;
			var themeXMLs:UtilHashArray = param2;
			this.initAssetDependency();
			if(this._propInPrevScene != null && this._propInPrevScene.file == this.file)
			{
				this.isFirstProp = false;
				this.firstProp = this._propInPrevScene.firstProp;
				if(this.getIsVideo())
				{
					this.videoNetStreamController = this.firstProp.videoNetStreamController;
				}
				else
				{
					switch(raceCode)
					{
						case RaceConstants.STATIC_SWF:
							this.setLoader(new UtilCommonLoader());
							break;
						case RaceConstants.CUSTOM_CHARACTER:
							this.setLoader(this.firstProp.getLoader());
							break;
						case RaceConstants.SKINNED_SWF:
							this.setLoader(this.firstProp.getLoader());
					}
				}
			}
			else
			{
				this.isFirstProp = true;
				this.firstProp = this;
				if(this.getIsVideo())
				{
					currentProp = this;
					videoDurationInSecond = 0;
					while(currentProp._propInNextScene != null)
					{
						videoDurationInSecond = videoDurationInSecond + currentProp.parentScene.duration#1;
						currentProp = currentProp._propInNextScene;
					}
					THUMB_ID_REGEX = /\d+\.flv/;
					thumbId = this.file.match(THUMB_ID_REGEX)[0];
					propModel = CCThemeManager.instance.getThemeModel(themeId).getPropModel(thumbId);
					this.videoNetStreamController = downloadManager.registerVideoNetStream(UtilNetwork.getGetUserUploadVideoUrl(propModel.encAssetId,propModel.signature),UtilUnitConvert.frameToSec(this.parentScene.startFrame) * 1000,UtilUnitConvert.frameToSec(videoDurationInSecond) * 1000,0);
					if(this.getIsVideo())
					{
						propXMLinThemeXML = UtilXmlInfo.getPropXMLfromThemeXML(this.file,themeXMLs);
						this.videoNetStreamController.updateDimension(propXMLinThemeXML.@width,propXMLinThemeXML.@height);
					}
				}
				else
				{
					switch(raceCode)
					{
						case RaceConstants.STATIC_SWF:
							this.setLoader(new UtilCommonLoader());
							break;
						case RaceConstants.CUSTOM_CHARACTER:
							this.setLoader(new CustomHeadMaker());
							break;
						case RaceConstants.SKINNED_SWF:
							this.setLoader(new SkinnedHeadMaker());
					}
				}
			}
			if(raceCode == RaceConstants.SKINNED_SWF)
			{
				themeId = UtilXmlInfo.getThemeIdFromFileName(this._file);
				charId = UtilXmlInfo.getCharIdFromFacialFileName(this._file);
				themeXML = XML(themeXMLs.getValueByKey(themeId));
				result = themeXML.char.(@id == charId);
				for each(item in result)
				{
					this._headXML = item;
				}
			}
			this.getBundle().addChild(this.objInsideBundle);
		}
		
		public function startProcess(param1:Boolean = false, param2:Number = 0) : void
		{
			this.initRemoteData(_dataStock);
		}
		
		public function initRemoteData(param1:PlayerDataStock, param2:int = 0, param3:Boolean = false) : void
		{
			var imageName:String = null;
			var result:Number = NaN;
			var model:Object = null;
			var data:UtilHashBytes = null;
			var playerData:Object = null;
			var ccMaker:CustomHeadMaker = null;
			var tmpArray:ByteArray = null;
			var scMaker:SkinnedHeadMaker = null;
			var figure:ByteArray = null;
			var iDataStock:PlayerDataStock = param1;
			var raceCode:int = param2;
			var isSpeech:Boolean = param3;
			if(this.getIsVideo())
			{
				if(this.parentScene != null)
				{
					this.videoNetStreamController.getVideoContainer().x = -1 * this.videoNetStreamController.width / 2;
					this.videoNetStreamController.getVideoContainer().y = -1 * this.videoNetStreamController.height / 2;
				}
				this.initAllTransitionsRemoteData();
			}
			else
			{
				imageName = this.file;
				result = 0;
				playerData = iDataStock.getPlayerData(this.file);
				switch(raceCode)
				{
					case RaceConstants.STATIC_SWF:
						if(this.parentScene == null)
						{
							imageName = imageName + ".handProp";
						}
						result = AssetImageLibrary.instance.requestImage(imageName,this._sceneId,this.getLoader());
						if(result > 0)
						{
							setTimeout(initAllTransitionsRemoteData,10);
						}
						else
						{
							tmpArray = new ByteArray();
							ByteArray(playerData).position = 0;
							ByteArray(playerData).readBytes(tmpArray);
							this.imageData = tmpArray;
							UtilCommonLoader(this.getLoader()).shouldPauseOnLoadBytesComplete = true;
							UtilCommonLoader(this.getLoader()).addEventListener(Event.COMPLETE,this.onInitRemoteDataCompleted);
							try
							{
								UtilCommonLoader(this.getLoader()).loadBytes(playerData as ByteArray,UtilCommonLoader.externalLoaderContext);
							}
							catch(e:Error)
							{
								UtilErrorLogger.getInstance().appendCustomError("Prop:initRemoteData",e);
							}
						}
						break;
					case RaceConstants.CUSTOM_CHARACTER:
						ccMaker = CustomHeadMaker(this.getLoader());
						ccMaker.shouldPauseOnLoadBytesComplete = true;
						ccMaker.addEventListener(LoadEmbedMovieEvent.COMPLETE_EVENT,this.onInitCCRemoteDataCompleted);
						try
						{
							if(playerData.hasOwnProperty("xml"))
							{
								model = playerData["xml"] as XML;
							}
							else if(playerData is CCCharacterActionModel)
							{
								model = CCCharacterActionModel(playerData);
							}
							else
							{
								model = XML(playerData);
							}
						}
						catch(e:Error)
						{
							UtilErrorLogger.getInstance().appendCustomError("Prop:initRemoteData",e);
						}
						ccMaker.sceneId = this._sceneId;
						ccMaker.useImageLibrary = true;
						ccMaker.init(model);
						break;
					case RaceConstants.SKINNED_SWF:
						if(this.parentScene == null)
						{
							imageName = imageName + ".handProp";
						}
						result = AssetImageLibrary.instance.requestImage(imageName,this._sceneId,this.getLoader());
						if(result > 0)
						{
							setTimeout(initAllTransitionsRemoteData,10);
						}
						else
						{
							scMaker = SkinnedHeadMaker(this.getLoader());
							scMaker.themeId = UtilXmlInfo.getThemeIdFromFileName(this.file);
							scMaker.addEventListener(LoadEmbedMovieEvent.COMPLETE_EVENT,this.onInitCCRemoteDataCompleted);
							try
							{
								if(playerData.hasOwnProperty("xml") && playerData.hasOwnProperty("figure") && playerData.hasOwnProperty("imageData"))
								{
									model = playerData["xml"] as XML;
									figure = playerData["figure"] as ByteArray;
									data = playerData["imageData"];
								}
								else
								{
									figure = playerData as ByteArray;
								}
							}
							catch(e:Error)
							{
								UtilErrorLogger.getInstance().appendCustomError("Prop:initRemoteData",e);
							}
							scMaker.init(this._headXML,figure,data,false,false,"",this.file);
						}
				}
			}
		}
		
		public function prepareImage() : void
		{
			var head:CustomHeadMaker = null;
			var imageId:Number = NaN;
			var imageName:String = null;
			var asset:AssetImageLibraryObject = null;
			try
			{
				if(!this.getIsVideo())
				{
					if(this.isCC)
					{
						head = CustomHeadMaker(this.getLoader());
						head.prepareImage(this._sceneId,this.isFirstProp);
						if(this.isFirstProp)
						{
							PlayerConstant.goToAndStopFamilyAt1(head);
						}
					}
					else
					{
						imageId = 0;
						if(this._propInPrevScene)
						{
							imageId = this._propInPrevScene.assetImageId;
						}
						imageName = this.file;
						if(this.parentScene == null)
						{
							imageName = imageName + ".handProp";
						}
						asset = AssetImageLibrary.instance.borrowImage(imageName,imageId,this._sceneId);
						if(asset && asset.image)
						{
							this._assetImageId = asset.imageId;
							this.setLoader(DisplayObjectContainer(asset.image));
							if(this.isFirstProp)
							{
								PlayerConstant.goToAndStopFamilyAt1(asset.image);
							}
							UtilColor.resetAssetPartsColor(asset.image);
						}
					}
				}
				return;
			}
			catch(e:Error)
			{
				UtilErrorLogger.getInstance().appendCustomError("Prop:prepareImage",e);
				UtilErrorLogger.getInstance().error("Prop:prepareImage" + e);
				return;
			}
		}
		
		private function onInitCCRemoteDataCompleted(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitCCRemoteDataCompleted);
			this.initAllTransitionsRemoteData();
		}
		
		protected function onInitRemoteDataCompleted(param1:Event) : void
		{
			var _loc4_:Class = null;
			var _loc5_:Rectangle = null;
			if(param1)
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitRemoteDataCompleted);
			}
			var _loc2_:Loader = UtilCommonLoader(this.getLoader());
			var _loc3_:Bitmap = _loc2_.content as Bitmap;
			if(_loc3_)
			{
				_loc3_.smoothing = true;
			}
			if(_loc2_.content.loaderInfo.applicationDomain.hasDefinition("theSound"))
			{
				_loc4_ = _loc2_.content.loaderInfo.applicationDomain.getDefinition("theSound") as Class;
				this.sound = new _loc4_();
				this.dispatchEvent(new Event("SoundAdded"));
			}
			if(this.parentScene != null)
			{
				_loc5_ = _loc2_.getBounds(_loc2_);
				this._boundBeforeCenterAlign = _loc5_;
				_boundBeforeCenterAlignLibrary[this.file] = _loc5_;
				_loc2_.content.x = _loc2_.content.x - (_loc5_.left + _loc5_.right) / 2;
				_loc2_.content.y = _loc2_.content.y - (_loc5_.top + _loc5_.bottom) / 2;
			}
			this.initAllTransitionsRemoteData();
		}
		
		public function get boundBeforeCenterAlign() : Rectangle
		{
			if(!this._boundBeforeCenterAlign)
			{
				this._boundBeforeCenterAlign = _boundBeforeCenterAlignLibrary[this.file];
			}
			return this._boundBeforeCenterAlign;
		}
		
		override public function setVolume(param1:Number) : void
		{
			if(this.getIsVideo())
			{
				this.videoNetStreamController.setVolume(param1);
			}
		}
		
		override public function propagateSceneState(param1:int) : void
		{
			if(param1 == AnimeScene.STATE_ACTION)
			{
				this.setState(Prop.STATE_ACTION);
			}
			else if(param1 == AnimeScene.STATE_MOTION)
			{
				if(this._propInNextScene == null)
				{
					this.setState(STATE_FADE);
				}
				else if(isChanged(this,this._propInNextScene))
				{
					this.setState(STATE_MOTION);
				}
				else
				{
					this.setState(STATE_ACTION);
				}
			}
			else if(param1 == AnimeScene.STATE_NULL)
			{
				this.setState(Prop.STATE_NULL);
			}
		}
		
		public function propagateCharState(param1:int) : void
		{
			var _loc2_:CustomHeadMaker = null;
			if(param1 == Character.STATE_ACTION || param1 == Character.STATE_FADE || param1 == Character.STATE_MOTION)
			{
				if(this.isCC)
				{
					_loc2_ = CustomHeadMaker(this.getLoader());
					if(_loc2_)
					{
						_loc2_.lookAtCamera = this.lookAtCamera;
					}
				}
				this.getBundle().addChild(this.objInsideBundle);
				if(this.isFirstProp)
				{
					this.resume();
				}
			}
		}
		
		protected function flip() : void
		{
			if(this.facing == Prop.FACE_POSITIVE)
			{
				if(this.getIsVideo())
				{
					this.videoNetStreamController.flipVideo(false);
				}
				else
				{
					UtilPlain.flipObj(this.objInsideBundle,true,false);
				}
			}
			else if(this.getIsVideo())
			{
				this.videoNetStreamController.flipVideo(true);
			}
			else
			{
				UtilPlain.flipObj(this.objInsideBundle,false,true);
			}
		}
		
		public function get isFlipped() : Boolean
		{
			return this.facing != Prop.FACE_POSITIVE;
		}
		
		public function get hasMask() : Boolean
		{
			return this._hasMask;
		}
		
		public function playFrame(param1:uint, param2:uint) : void
		{
			var _loc3_:Point = null;
			if(this._state == STATE_ACTION)
			{
				if(this._motion)
				{
					_loc3_ = this._motionCache.getPosition(param1);
					this.bundle.x = _loc3_.x;
					this.bundle.y = _loc3_.y;
					_loc3_ = this._motionCache.getScale(param1);
					this.bundle.scaleX = _loc3_.x;
					this.bundle.scaleY = _loc3_.y;
					this.bundle.rotation = this._motionCache.getRotation(param1);
				}
			}
		}
		
		override protected function setState(param1:int) : void
		{
			if(param1 == Prop.STATE_ACTION)
			{
				this.bundle.x = this._xs[0];
				this.bundle.y = this._ys[0];
				this.bundle.scaleX = this._xscales[0];
				this.bundle.scaleY = this._yscales[0];
				this.bundle.rotation = this._rotations[0];
				this.getBundle().addChild(this.objInsideBundle);
				this.flip();
				if(this.isFirstProp)
				{
					this.resume();
				}
			}
			else if(param1 == Prop.STATE_MOTION)
			{
				this.getBundle().addChild(this.objInsideBundle);
				this.flip();
				if(this.isFirstProp)
				{
					this.resume();
				}
			}
			super.setState(param1);
		}
		
		override public function pauseBundle() : void
		{
			if(this.getIsVideo())
			{
				this.videoNetStreamController.pause();
			}
			else
			{
				super.pauseBundle();
			}
		}
		
		override public function resumeBundle() : void
		{
			if(this.getIsVideo())
			{
				this.videoNetStreamController.resume();
			}
			else
			{
				super.resumeBundle();
			}
		}
		
		override public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
		{
			var _loc5_:Number = NaN;
			if(this.getIsVideo())
			{
				_loc5_ = UtilUnitConvert.frameToSec(param2 - this.firstProp.parentScene.startFrame);
				this.videoNetStreamController.pause();
				this.videoNetStreamController.seek(_loc5_);
			}
			else
			{
				PlayerConstant.goToAndStopFamily(this.getBundle(),param1);
			}
			if(this.assetView is IPlayback)
			{
				IPlayback(this.assetView).goToAndPause(param1,param2,param3,param4);
			}
		}
		
		override public function goToAndPauseReset() : void
		{
			if(this.getIsVideo())
			{
				this.videoNetStreamController.pause();
				this.videoNetStreamController.seek(0);
			}
			else
			{
				super.goToAndPauseReset();
			}
		}
		
		override public function destroy(param1:Boolean = false) : void
		{
			if(this._propInNextScene == null)
			{
				super.destroy();
			}
			if(param1)
			{
				this.setLoader(null);
			}
			this.resetTransition();
		}
		
		public function speak(param1:Number) : void
		{
			var _loc2_:CustomHeadMaker = null;
			var _loc3_:SkinnedHeadMaker = null;
			switch(raceCode)
			{
				case RaceConstants.CUSTOM_CHARACTER:
					_loc2_ = CustomHeadMaker(this.getLoader());
					if(_loc2_)
					{
						_loc2_.speak(param1);
					}
					break;
				case RaceConstants.SKINNED_SWF:
					_loc3_ = SkinnedHeadMaker(this.getLoader());
					if(_loc3_)
					{
						_loc3_.speak(param1);
					}
			}
		}
		
		override public function addTransition(param1:AssetTransitionNode) : void
		{
			if(param1)
			{
				if(param1.type == AssetTransitionConstants.TYPE_MOTION_PATH)
				{
					this._motionStartFrame = param1.startFrame;
					this._motionEndFrame = param1.endFrame;
					this.updateMotionCache();
				}
			}
			super.addTransition(param1);
		}
		
		private function updateMotionCache() : void
		{
			if(this._motion && this.parentScene)
			{
				this._motionCache = new MotionCache(this._motion,this.parentScene.totalFrame,this._motionStartFrame,this._motionEndFrame);
			}
		}
	}
}
