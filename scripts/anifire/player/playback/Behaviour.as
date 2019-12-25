package anifire.player.playback
{
	import anifire.color.SelectedColor;
	import anifire.component.CustomCharacterMaker;
	import anifire.component.SkinnedCharacterMaker;
	import anifire.constant.AnimeConstants;
	import anifire.constant.RaceConstants;
	import anifire.constant.ServerConstants;
	import anifire.event.ExtraDataEvent;
	import anifire.event.LoadEmbedMovieEvent;
	import anifire.event.SpeechPitchEvent;
	import anifire.interfaces.ICharacter;
	import anifire.interfaces.IPlayable;
	import anifire.managers.AppConfigManager;
	import anifire.managers.CCBodyManager;
	import anifire.managers.CCThemeManager;
	import anifire.models.creator.CCBodyModel;
	import anifire.models.creator.CCCharacterActionModel;
	import anifire.models.creator.CCColor;
	import anifire.player.events.PlayerEvent;
	import anifire.util.Util;
	import anifire.util.UtilCommonLoader;
	import anifire.util.UtilErrorLogger;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilHashBytes;
	import anifire.util.UtilHashSelectedColor;
	import anifire.util.UtilPlain;
	import anifire.util.UtilXmlInfo;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public class Behaviour implements IPlayable, IEventDispatcher
	{
		
		public static const FACE_POSITIVE:String = "1";
		
		public static const FACE_NEGATIVE:String = "-1";
		
		public static const CHANGE_FACE:String = "0";
		
		private static const CC_NOT_YET_INITIALIZED:String = "0";
		
		private static const CC_INITIALIZING:String = "1";
		
		private static const CC_ALREADY_FINISH_INITIALIZING:String = "2";
		 
		
		private var _file:String;
		
		private var _loader:DisplayObjectContainer;
		
		private var _content:Sprite;
		
		private var _face:String;
		
		private var _eventDispatcher:EventDispatcher;
		
		private var _isFirstBehavior:Boolean = false;
		
		private var _firstBehavior:Behaviour = null;
		
		private var _prevBehavior:Behaviour;
		
		private var _nextBehavior:Behaviour;
		
		private var _myChar:Character;
		
		private var _isLoop:Boolean;
		
		private var _localEndFrame:Number = 1;
		
		protected var _currentFrame:Number;
		
		private var _localStartFrame:Number = 0;
		
		private var _totalFrames:Number = 1;
		
		private var _handProp:DisplayObject = null;
		
		private var _headProp:DisplayObject = null;
		
		private var _wearProp:DisplayObject = null;
		
		private var _customHead:Prop = null;
		
		private var _charObj:DisplayObjectContainer;
		
		private var _charObjFlipped:DisplayObjectContainer;
		
		private var _isContentSet:Boolean = false;
		
		private var _isCC:Boolean = false;
		
		private var _assetImageId:Number = 0;
		
		private var _sceneId:String;
		
		private var _raceCode:Number;
		
		private var _charXML:XML;
		
		private var _isFlipped:Boolean;
		
		private var _bodyScale:Number = 1;
		
		private var _freeactionFolderName:String = "default";
		
		private var _lookAtCamera:Boolean = false;
		
		private var _loadHead:Boolean = true;
		
		private var _lipSync:Boolean = false;
		
		public function Behaviour()
		{
			this._eventDispatcher = new EventDispatcher();
			super();
		}
		
		public function set sceneId(param1:String) : void
		{
			this._sceneId = param1;
		}
		
		public function get sceneId() : String
		{
			return this._sceneId;
		}
		
		public function get assetImageId() : Number
		{
			return this._assetImageId;
		}
		
		public function get myChar() : Character
		{
			return this._myChar;
		}
		
		public function set myChar(param1:Character) : void
		{
			this._myChar = param1;
		}
		
		public function get isFirstBehavior() : Boolean
		{
			return this._isFirstBehavior;
		}
		
		public function set isFirstBehavior(param1:Boolean) : void
		{
			this._isFirstBehavior = param1;
		}
		
		public function get firstBehavior() : Behaviour
		{
			return this._firstBehavior;
		}
		
		public function set firstBehavior(param1:Behaviour) : void
		{
			this._firstBehavior = param1;
		}
		
		public function set prevBehavior(param1:Behaviour) : void
		{
			this._prevBehavior = param1;
		}
		
		public function get prevBehavior() : Behaviour
		{
			return this._prevBehavior;
		}
		
		public function get nextBehavior() : Behaviour
		{
			return this._nextBehavior;
		}
		
		public function set nextBehavior(param1:Behaviour) : void
		{
			this._nextBehavior = param1;
		}
		
		public function getLocalStartFrame() : Number
		{
			return this._localStartFrame;
		}
		
		protected function setLocalStartFrame(param1:Number) : void
		{
			this._localStartFrame = param1;
		}
		
		public function getLocalEndFrame() : Number
		{
			return this._localEndFrame;
		}
		
		protected function setLocalEndFrame(param1:Number) : void
		{
			this._localEndFrame = param1;
		}
		
		protected function getTotalFrames() : Number
		{
			return this._totalFrames;
		}
		
		private function setTotalFrames(param1:Number) : void
		{
			this._totalFrames = param1;
		}
		
		public function getIsLoop() : Boolean
		{
			return this._isLoop;
		}
		
		private function setIsLoop(param1:Boolean) : void
		{
			this._isLoop = param1;
		}
		
		public function getFile() : String
		{
			return this._file;
		}
		
		protected function setFile(param1:String) : void
		{
			var _loc2_:RegExp = /.zip/gi;
			this._file = param1.replace(_loc2_,".xml");
		}
		
		public function getLoader() : DisplayObjectContainer
		{
			return this._loader;
		}
		
		private function setLoader(param1:DisplayObjectContainer) : void
		{
			this._loader = param1;
			if(param1 != null)
			{
				this._loader.name = AnimeConstants.LOADER_NAME;
			}
		}
		
		public function getEventDispatcher() : EventDispatcher
		{
			return this._eventDispatcher;
		}
		
		protected function getContent() : Sprite
		{
			return this._content;
		}
		
		protected function setContent(param1:Sprite) : void
		{
			this._content = param1;
		}
		
		public function isContentSet() : Boolean
		{
			return this._isContentSet;
		}
		
		public function getFace() : String
		{
			return this._face;
		}
		
		public function setFace(param1:String) : void
		{
			this._face = param1;
		}
		
		public function getLookAtCamera() : Boolean
		{
			return this._lookAtCamera;
		}
		
		public function setLookAtCamera(param1:Boolean) : void
		{
			var _loc2_:CustomCharacterMaker = null;
			if(this._isCC)
			{
				this._lookAtCamera = param1;
				_loc2_ = CustomCharacterMaker(this.getLoader());
				if(_loc2_)
				{
					_loc2_.lookAtCamera = param1;
				}
			}
		}
		
		public function initRemoteData(param1:PlayerDataStock, param2:int, param3:Number = 0, param4:Number = 0, param5:Boolean = false, param6:Boolean = true, param7:UtilHashSelectedColor = null) : void
		{
			var xml:XML = null;
			var cam:CCCharacterActionModel = null;
			var data:UtilHashBytes = null;
			var skins:UtilHashBytes = null;
			var figure:ByteArray = null;
			var libraryNode:XML = null;
			var i:int = 0;
			var lid:String = null;
			var scMaker:SkinnedCharacterMaker = null;
			var ccMaker:CustomCharacterMaker = null;
			var j:int = 0;
			var color:SelectedColor = null;
			var ccColor:CCColor = null;
			var iDataStock:PlayerDataStock = param1;
			var raceCode:int = param2;
			var startMilliSec:Number = param3;
			var endMilliSec:Number = param4;
			var isSpeech:Boolean = param5;
			var loadHead:Boolean = param6;
			var customColor:UtilHashSelectedColor = param7;
			this._isCC = raceCode == RaceConstants.CUSTOM_CHARACTER;
			this._raceCode = raceCode;
			var playerData:Object = iDataStock.getPlayerData(this.getFile());
			if(!this._isCC)
			{
				switch(raceCode)
				{
					case RaceConstants.STATIC_SWF:
						this._assetImageId = 0;
						if(!this.myChar.parentScene.id)
						{
						}
						if(this._assetImageId > 0)
						{
							this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
						}
						else
						{
							this._assetImageId = this._assetImageId * -1;
							UtilCommonLoader(this.getLoader()).shouldPauseOnLoadBytesComplete = true;
							UtilCommonLoader(this.getLoader()).addEventListener(Event.COMPLETE,this.onInitRemoteDataCompleted);
							try
							{
								UtilCommonLoader(this.getLoader()).loadBytes(playerData as ByteArray);
							}
							catch(e:Error)
							{
								UtilErrorLogger.getInstance().appendCustomError("Behaviour:initRemoteData",e);
							}
						}
						break;
					case RaceConstants.SKINNED_SWF:
						scMaker = SkinnedCharacterMaker(this.getLoader());
						scMaker.addEventListener(LoadEmbedMovieEvent.COMPLETE_EVENT,this.onInitCCRemoteDataCompleted);
						scMaker.themeId = UtilXmlInfo.getThemeIdFromFileName(this.getFile());
						data = new UtilHashBytes();
						try
						{
							if(playerData.hasOwnProperty("imageData") && playerData.hasOwnProperty("figure"))
							{
								data = playerData["imageData"];
								figure = playerData["figure"] as ByteArray;
							}
							else
							{
								figure = playerData as ByteArray;
							}
						}
						catch(e:Error)
						{
							UtilErrorLogger.getInstance().appendCustomError("Behaviour:initRemoteData",e);
						}
						scMaker.init(this._charXML,figure,data,isSpeech,true,this.getFile(),this.getFile());
				}
			}
			else
			{
				ccMaker = CustomCharacterMaker(this.getLoader());
				ccMaker.shouldPauseOnLoadBytesComplete = true;
				ccMaker.addEventListener(LoadEmbedMovieEvent.COMPLETE_EVENT,this.onInitCCRemoteDataCompleted);
				data = new UtilHashBytes();
				try
				{
					if(playerData.hasOwnProperty("imageData"))
					{
						xml = playerData["xml"] as XML;
						cam = playerData["cam"] as CCCharacterActionModel;
						data = playerData["imageData"];
					}
					else if(playerData is XML)
					{
						xml = XML(playerData);
					}
					else if(playerData is CCCharacterActionModel)
					{
						cam = CCCharacterActionModel(playerData).clone();
					}
				}
				catch(e:Error)
				{
					UtilErrorLogger.getInstance().appendCustomError("Behaviour:initRemote",e);
					UtilErrorLogger.getInstance().error("Behaviour:initRemote" + e);
				}
				ccMaker.sceneId = this._sceneId;
				ccMaker.loadHead = loadHead;
				this._loadHead = loadHead;
				ccMaker.useImageLibrary = true;
				if(customColor)
				{
					j = 0;
					while(j < customColor.length)
					{
						color = customColor.getValueByIndex(j);
						if(color)
						{
							ccColor = new CCColor();
							ccColor.type = color.areaName;
							ccColor.oc = color.orgColor;
							ccColor.dest = color.dstColor;
							cam.addColor(ccColor.type,ccColor);
						}
						j++;
					}
				}
				if(cam)
				{
					this._bodyScale = cam.bodyScale.scalex;
					ccMaker.initByCamWithData(cam,startMilliSec,endMilliSec,data,isSpeech,true,this.getFile());
				}
				else
				{
					ccMaker.initByXMLWithData(xml,startMilliSec,endMilliSec,data,isSpeech,true,this.getFile());
				}
			}
		}
		
		protected function onInitCCRemoteDataCompleted(param1:Event) : void
		{
			if(param1)
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitCCRemoteDataCompleted);
			}
			this.setContent(Sprite(this.getLoader()));
			this._isContentSet = true;
			this._charObj = UtilPlain.getCharacter(this.getContent());
			this._charObjFlipped = UtilPlain.getCharacterFlip(this.getContent());
			if(!this.getIsLoop())
			{
				this._currentFrame = 0;
			}
			this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
		}
		
		protected function onInitRemoteDataCompleted(param1:Event) : void
		{
			var _loc4_:DisplayObject = null;
			var _loc5_:Class = null;
			var _loc6_:ExtraDataEvent = null;
			if(param1)
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitRemoteDataCompleted);
			}
			var _loc2_:* = AppConfigManager.instance.getValue(ServerConstants.FLASHVAR_IS_IN_SPEEDY_MODE) == "1";
			if(_loc2_)
			{
				_loc4_ = Util.getCharacter(UtilCommonLoader(this.getLoader()).content as Sprite);
				if(_loc4_)
				{
					_loc4_.filters = [];
				}
			}
			if(UtilCommonLoader(this.getLoader()).content.loaderInfo.applicationDomain.hasDefinition("theSound"))
			{
				_loc5_ = UtilCommonLoader(this.getLoader()).content.loaderInfo.applicationDomain.getDefinition("theSound") as Class;
				if(this is Action)
				{
					_loc6_ = new ExtraDataEvent("SoundRdy",this,_loc5_);
				}
				else if(this is Motion)
				{
					_loc6_ = new ExtraDataEvent("MotionSoundRdy",this,_loc5_);
				}
				this.dispatchEvent(_loc6_);
			}
			this.setContent(UtilCommonLoader(this.getLoader()).content as Sprite);
			this._isContentSet = true;
			this._charObj = UtilPlain.getCharacter(this.getContent());
			this._charObjFlipped = UtilPlain.getCharacterFlip(this.getContent());
			if(!this._charObj)
			{
				this._charObj = this.getContent();
			}
			if(!this.getIsLoop())
			{
				this._currentFrame = 0;
			}
			this.goToAndPauseReset();
			var _loc3_:PlayerEvent = new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
			this.dispatchEvent(_loc3_);
		}
		
		public function initBehaviour(param1:XML, param2:String, param3:UtilHashArray, param4:PlayerDataStock) : Boolean
		{
			var filename:String = null;
			var themeId:String = null;
			var themeXML:XML = null;
			var behaviourXML:XML = param1;
			var themeXMLnodeName:String = param2;
			var themeXMLs:UtilHashArray = param3;
			var dataStock:PlayerDataStock = param4;
			filename = behaviourXML.toString();
			this.setFile(UtilXmlInfo.getZipFileNameOfBehaviour(filename,true));
			themeId = UtilXmlInfo.getThemeIdFromFileName(this.getFile());
			if(themeId != "ugc" && String(behaviourXML).lastIndexOf(".xml") == -1)
			{
				dataStock.decryptPlayerData(this.getFile());
			}
			var faces:Array = String(behaviourXML.attribute("face")).split(",");
			if(faces[0] == FACE_POSITIVE)
			{
				this.setFace(FACE_POSITIVE);
			}
			else
			{
				this.setFace(FACE_NEGATIVE);
			}
			themeXML = themeXMLs.getValueByKey(themeId) as XML;
			if(!themeXML)
			{
				return false;
			}
			var assetId:String = UtilXmlInfo.getCharIdFromFileName(this.getFile());
			var cc_themeId:String = themeXML.char.(@id == assetId).@cc_theme_id;
			if(cc_themeId && this.initBehaviourForCC(dataStock))
			{
				return true;
			}
			return this.initBehaviourWithTheme(behaviourXML,themeXMLnodeName,themeXMLs,dataStock);
		}
		
		private function initBehaviourWithTheme(param1:XML, param2:String, param3:UtilHashArray, param4:PlayerDataStock) : Boolean
		{
			var _loc5_:XML = PlayerConstant.getBehaviourXMLfromThemeXML(this.getFile(),param2,param3);
			if(_loc5_ == null)
			{
				return false;
			}
			if(_loc5_.attribute("loop").length() <= 0)
			{
				this.setIsLoop(true);
			}
			else if(_loc5_.attribute("loop")[0].toString() == "Y")
			{
				this.setIsLoop(true);
			}
			else
			{
				this.setIsLoop(false);
			}
			if(_loc5_.attribute("totalframe").length() > 0)
			{
				this.setTotalFrames(Number(_loc5_.attribute("totalframe")[0].toString()));
			}
			else
			{
				this.setTotalFrames(1);
			}
			if(!param4.getPlayerData(this.getFile()))
			{
				UtilErrorLogger.getInstance().error("Behaviour:initBehaviour: no player data: " + this.getFile());
				return false;
			}
			return true;
		}
		
		private function initBehaviourForCC(param1:PlayerDataStock) : Boolean
		{
			var _loc6_:CCCharacterActionModel = null;
			var _loc7_:String = null;
			var _loc2_:String = UtilXmlInfo.getThumbIdFromFileName(this.getFile());
			var _loc3_:String = UtilXmlInfo.getCompFileNameOfBehaviour(this.getFile());
			var _loc4_:XML = param1.getPlayerData(_loc3_) as XML;
			var _loc5_:CCBodyModel = CCBodyManager.instance.getBodyModel(UtilXmlInfo.getCharIdFromFileName(this.getFile()));
			if(_loc4_)
			{
				if(!_loc5_.completed)
				{
					_loc5_.parse(_loc4_);
				}
				_loc7_ = _loc5_.themeId;
				_loc6_ = CCThemeManager.instance.getThemeModel(_loc7_).getCharacterActionModel(_loc5_,_loc2_);
				this._freeactionFolderName = _loc6_.freeactionFolderName;
			}
			if(_loc6_)
			{
				this.setIsLoop(_loc6_.actionModel.isLoop);
				this.setTotalFrames(_loc6_.actionModel.totalframe);
				param1.addCamAsPlayerData(this.getFile(),_loc6_);
				return true;
			}
			UtilErrorLogger.getInstance().error("Behaviour:initBehaviour: no cam data: " + this.getFile());
			return false;
		}
		
		public function flip(param1:String) : void
		{
			var _loc2_:DisplayObject = this._charObj;
			var _loc3_:DisplayObject = this._charObjFlipped;
			if(param1 == CHANGE_FACE)
			{
				if(UtilPlain.isObjectFlipped(this.getLoader()))
				{
					param1 = FACE_POSITIVE;
				}
				else
				{
					param1 = FACE_NEGATIVE;
				}
				this._isFlipped = !this._isFlipped;
			}
			if(param1 == FACE_POSITIVE)
			{
				UtilPlain.flipObj(this.getLoader(),true,false);
				if(_loc3_ != null)
				{
					if(this._handProp != null)
					{
						this.setProp(this._handProp);
					}
					if(this._headProp != null)
					{
						this.setHead(this._headProp);
					}
					if(this._customHead != null || this._wearProp != null)
					{
						this.setWear(this._wearProp,this._customHead);
					}
				}
			}
			else if(param1 == FACE_NEGATIVE)
			{
				UtilPlain.flipObj(this.getLoader(),false,true);
				if(_loc3_ != null)
				{
					if(this._handProp != null)
					{
						this.setProp(this._handProp);
					}
					if(this._headProp != null)
					{
						this.setHead(this._headProp);
					}
					if(this._customHead != null || this._wearProp != null)
					{
						this.setWear(this._wearProp,this._customHead);
					}
				}
				this._isFlipped = true;
			}
		}
		
		protected function pretendToBe(param1:Behaviour) : void
		{
			this.setFile(param1.getFile());
			this.setIsLoop(param1.getIsLoop());
			this.setTotalFrames(param1.getTotalFrames());
		}
		
		protected function onEnterFrame(param1:Event) : void
		{
			this._currentFrame++;
			if(!this.getIsLoop() && this._currentFrame >= this.getTotalFrames())
			{
				this.pause();
			}
		}
		
		protected function initLoader(param1:int, param2:XML = null) : void
		{
			this._charXML = param2;
			if(this.isFirstBehavior)
			{
				switch(param1)
				{
					case RaceConstants.CUSTOM_CHARACTER:
						this.setLoader(new CustomCharacterMaker());
						break;
					case RaceConstants.SKINNED_SWF:
						this.setLoader(new SkinnedCharacterMaker());
						break;
					case RaceConstants.STATIC_SWF:
						this.setLoader(new UtilCommonLoader());
				}
			}
			else
			{
				this.setLoader(this.firstBehavior.getLoader());
			}
		}
		
		public function updateStaticProperties() : void
		{
			this.flip(this.getFace());
		}
		
		public function setProp(param1:DisplayObject) : void
		{
			var _loc2_:DisplayObjectContainer = null;
			var _loc3_:DisplayObjectContainer = null;
			this._handProp = param1;
			if(!UtilPlain.isObjectFlipped(this.getLoader()))
			{
				_loc3_ = this._charObj;
			}
			else
			{
				_loc3_ = this._charObjFlipped;
				if(_loc3_ == null)
				{
					_loc3_ = this._charObj;
				}
			}
			_loc2_ = UtilPlain.getProp(_loc3_);
			if(_loc2_)
			{
				UtilPlain.removeAllSon(_loc2_);
				_loc2_.addChild(param1);
				param1.x = 0;
				param1.y = 0;
				param1.scaleX = Math.abs(1 / UtilPlain.getRelativeProperty(_loc2_.parent,this.getLoader(),UtilPlain.PROPERTY_SCALEX));
				param1.scaleY = Math.abs(1 / UtilPlain.getRelativeProperty(_loc2_.parent,this.getLoader(),UtilPlain.PROPERTY_SCALEY));
			}
		}
		
		public function removeProp() : void
		{
			var _loc1_:DisplayObjectContainer = null;
			var _loc2_:DisplayObjectContainer = null;
			var _loc3_:int = 0;
			_loc2_ = this._charObj;
			_loc1_ = UtilPlain.getProp(_loc2_);
			if(_loc1_)
			{
				UtilPlain.removeAllSon(_loc1_);
			}
			_loc2_ = this._charObjFlipped;
			if(_loc2_)
			{
				_loc1_ = UtilPlain.getProp(_loc2_);
				if(_loc1_)
				{
					UtilPlain.removeAllSon(_loc1_);
				}
			}
		}
		
		public function setHead(param1:DisplayObject = null, param2:int = 0) : void
		{
			var _loc3_:DisplayObjectContainer = null;
			this._headProp = param1;
			this.removeHead();
			if(!UtilPlain.isObjectFlipped(this.getLoader()))
			{
				_loc3_ = this._charObj;
			}
			else
			{
				_loc3_ = this._charObjFlipped;
				if(_loc3_ == null)
				{
					_loc3_ = this._charObj;
				}
			}
			this.setHeadForCharObj(param1,_loc3_,param2);
		}
		
		private function setHeadForCharObj(param1:DisplayObject, param2:DisplayObjectContainer, param3:int = 0) : void
		{
			var _loc4_:DisplayObjectContainer = null;
			_loc4_ = UtilPlain.getHead(param2);
			if(_loc4_ != null)
			{
				if(param1 != null)
				{
					_loc4_.getChildByName(AnimeConstants.MOVIECLIP_DEFAULT_HEAD).alpha = 0;
					_loc4_.getChildByName(AnimeConstants.MOVIECLIP_DEFAULT_HEAD).visible = false;
					param1.name = AnimeConstants.MOVIECLIP_CUSTOM_HEAD;
					_loc4_.addChild(param1);
					switch(param3)
					{
						case RaceConstants.STATIC_SWF:
						case RaceConstants.SKINNED_SWF:
							param1.x = 0;
							param1.y = 0;
							param1.scaleX = Math.abs(1 / UtilPlain.getRelativeProperty(_loc4_,this.getLoader(),UtilPlain.PROPERTY_SCALEX));
							param1.scaleY = Math.abs(1 / UtilPlain.getRelativeProperty(_loc4_,this.getLoader(),UtilPlain.PROPERTY_SCALEY));
							break;
						case RaceConstants.CUSTOM_CHARACTER:
							CustomCharacterMaker(this.getLoader()).refreshScale();
					}
				}
			}
			_loc4_ = UtilPlain.getTail(param2);
			if(_loc4_ != null)
			{
				if(param1 != null)
				{
					_loc4_.getChildByName(AnimeConstants.MOVIECLIP_DEFAULT_TAIL).alpha = 0;
					_loc4_.getChildByName(AnimeConstants.MOVIECLIP_DEFAULT_TAIL).visible = false;
				}
			}
		}
		
		public function removeHead() : void
		{
			var _loc1_:DisplayObjectContainer = this._charObj;
			var _loc2_:DisplayObjectContainer = this._charObjFlipped;
			this.removeHeadForCharObj(_loc1_);
			if(_loc2_ != null)
			{
				this.removeHeadForCharObj(_loc2_);
			}
		}
		
		private function removeHeadForCharObj(param1:DisplayObjectContainer) : void
		{
			var _loc2_:DisplayObjectContainer = null;
			var _loc3_:DisplayObject = null;
			var _loc4_:DisplayObject = null;
			var _loc5_:DisplayObject = null;
			_loc2_ = UtilPlain.getHead(param1);
			if(_loc2_ != null)
			{
				_loc3_ = _loc2_.getChildByName(AnimeConstants.MOVIECLIP_CUSTOM_HEAD);
				if(_loc3_ != null)
				{
					_loc2_.removeChild(_loc3_);
				}
				_loc4_ = _loc2_.getChildByName(AnimeConstants.MOVIECLIP_DEFAULT_HEAD);
				_loc4_.alpha = 1;
				_loc4_.visible = true;
			}
			_loc2_ = UtilPlain.getTail(param1);
			if(_loc2_ != null)
			{
				_loc5_ = _loc2_.getChildByName(AnimeConstants.MOVIECLIP_DEFAULT_TAIL);
				if(_loc5_ != null)
				{
					_loc5_.alpha = 1;
					_loc5_.visible = true;
				}
			}
		}
		
		public function setWear(param1:DisplayObject, param2:Prop) : void
		{
			var _loc3_:DisplayObjectContainer = null;
			this._wearProp = param1;
			this._customHead = param2;
			this.removeWear();
			if(!UtilPlain.isObjectFlipped(this.getLoader()))
			{
				_loc3_ = this._charObj;
			}
			else
			{
				_loc3_ = this._charObjFlipped;
				if(_loc3_ == null)
				{
					_loc3_ = this._charObj;
				}
			}
			this.setWearForCharObj(param1,param2,_loc3_);
		}
		
		public function setWearForCharObj(param1:DisplayObject, param2:Prop, param3:DisplayObjectContainer) : void
		{
			var _loc4_:DisplayObjectContainer = null;
			var _loc5_:DisplayObjectContainer = null;
			var _loc6_:Number = NaN;
			_loc4_ = UtilPlain.getHead(param3);
			if(_loc4_ != null)
			{
				param1.name = AnimeConstants.MOVIECLIP_CUSTOM_WEAR;
				_loc4_.addChild(param1);
				param1.x = 0;
				param1.y = 0;
				param1.scaleX = Math.abs(1 / UtilPlain.getRelativeProperty(_loc4_,this.getLoader(),UtilPlain.PROPERTY_SCALEX));
				param1.scaleY = Math.abs(1 / UtilPlain.getRelativeProperty(_loc4_,this.getLoader(),UtilPlain.PROPERTY_SCALEY));
				_loc5_ = UtilPlain.getInstance(_loc4_,"theTop");
				if(_loc4_.getChildByName(AnimeConstants.MOVIECLIP_DEFAULT_HEAD).alpha != 0)
				{
					_loc6_ = _loc4_.getChildByName(AnimeConstants.MOVIECLIP_DEFAULT_HEAD).getBounds(_loc4_).y;
				}
				else
				{
					_loc6_ = param2 != null?Number(param2.getBundle().getBounds(param2.getBundle()).y):Number(0);
				}
				if(_loc5_ != null)
				{
					_loc5_.y = _loc6_;
				}
			}
		}
		
		public function removeWear() : void
		{
			var _loc1_:DisplayObjectContainer = this._charObj;
			var _loc2_:DisplayObjectContainer = this._charObjFlipped;
			this.removeWearForCharObj(_loc1_);
			if(_loc2_ != null)
			{
				this.removeWearForCharObj(_loc2_);
			}
		}
		
		private function removeWearForCharObj(param1:DisplayObjectContainer) : void
		{
			var _loc2_:DisplayObjectContainer = null;
			var _loc3_:DisplayObject = null;
			_loc2_ = UtilPlain.getHead(param1);
			if(_loc2_ != null)
			{
				_loc3_ = _loc2_.getChildByName(AnimeConstants.MOVIECLIP_CUSTOM_WEAR);
				if(_loc3_ != null)
				{
					_loc2_.removeChild(_loc3_);
				}
			}
		}
		
		private function sceneToBehaviuorFrame(param1:Number) : Number
		{
			var _loc2_:Number = param1 + this.getLocalStartFrame() - 1;
			if(!this.getIsLoop() && _loc2_ > this.getTotalFrames())
			{
				_loc2_ = this.getTotalFrames();
			}
			return _loc2_;
		}
		
		public function behaviourToClipFrame(param1:Number) : Number
		{
			return param1;
		}
		
		public function goToAndPause(param1:Number) : void
		{
			if(this.getContent())
			{
				this.getContent().removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
				this._currentFrame = this.sceneToBehaviuorFrame(param1);
				if(this.firstBehavior)
				{
					this._currentFrame = this.firstBehavior.behaviourToClipFrame(this._currentFrame);
				}
				else
				{
					this._currentFrame = this.behaviourToClipFrame(this._currentFrame);
				}
				PlayerConstant.goToAndStopFamily(this.getLoader(),this._currentFrame);
			}
		}
		
		public function goToAndPauseReset() : void
		{
			if(this.getContent())
			{
				this.getContent().removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
				this._currentFrame = this.behaviourToClipFrame(1);
				if(this.isFirstBehavior)
				{
					PlayerConstant.goToAndStopFamily(this.getLoader(),this._currentFrame);
				}
			}
		}
		
		public function pause() : void
		{
			if(this.getContent())
			{
				this.getContent().removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
				PlayerConstant.stopFamily(this.getLoader());
			}
		}
		
		public function resume() : void
		{
			if(this.getContent())
			{
				this.getContent().addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
				if(!this.getIsLoop() && this._currentFrame >= this.getTotalFrames())
				{
					this.pause();
				}
				else
				{
					PlayerConstant.playFamily(this.getLoader());
				}
			}
		}
		
		public function destroy(param1:Boolean = false) : void
		{
			if(this.getLoader() is UtilCommonLoader)
			{
				UtilCommonLoader(this.getLoader()).removeEventListener(Event.COMPLETE,this.onInitRemoteDataCompleted);
			}
			if(this.nextBehavior == null)
			{
				this.pause();
			}
			if(param1)
			{
				this.setLoader(null);
			}
		}
		
		public function speak(param1:Number) : void
		{
			var _loc2_:ICharacter = null;
			var _loc3_:SpeechPitchEvent = null;
			if(this._raceCode == 1 || this._raceCode == 2)
			{
				_loc2_ = ICharacter(this.getLoader());
				if(_loc2_)
				{
					_loc2_.speak(param1);
				}
			}
			else
			{
				this._lipSync = param1 != -1;
				if(this._lipSync && this.getContent())
				{
					_loc3_ = new SpeechPitchEvent(SpeechPitchEvent.PITCH);
					_loc3_.value = param1;
					Sprite(this.getContent()).dispatchEvent(_loc3_);
				}
			}
		}
		
		public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
		{
			this._eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
		}
		
		public function dispatchEvent(param1:Event) : Boolean
		{
			return this._eventDispatcher.dispatchEvent(param1);
		}
		
		public function hasEventListener(param1:String) : Boolean
		{
			return this._eventDispatcher.hasEventListener(param1);
		}
		
		public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
		{
			this._eventDispatcher.removeEventListener(param1,param2,param3);
		}
		
		public function willTrigger(param1:String) : Boolean
		{
			return this._eventDispatcher.willTrigger(param1);
		}
		
		public function prepareImage() : void
		{
			var _loc1_:CustomCharacterMaker = null;
			if(this._isCC)
			{
				_loc1_ = CustomCharacterMaker(this.getLoader());
				_loc1_.prepareImage(this._sceneId,this.isFirstBehavior,this._loadHead);
				this.onInitCCRemoteDataCompleted(null);
			}
		}
		
		public function get isFlipped() : Boolean
		{
			return this._isFlipped;
		}
		
		public function get bodyScale() : Number
		{
			return this._bodyScale;
		}
		
		public function get freeactionFolderName() : String
		{
			return this._freeactionFolderName;
		}
	}
}
