package anifire.player.playback
{
	import anifire.constant.AnimeConstants;
	import anifire.event.LoadMgrEvent;
	import anifire.interfaces.IRegulatedProcess;
	import anifire.player.events.PlayerEvent;
	import anifire.util.UtilCommonLoader;
	import anifire.util.UtilLoadMgr;
	import anifire.util.UtilPlain;
	import anifire.util.UtilXmlInfo;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public class Segment extends Asset implements IRegulatedProcess
	{
		
		private static const STATE_NULL:int = 0;
		
		private static const STATE_ACTION:int = 1;
		
		public static const XML_TAG:String = "segment";
		
		private static const TYPE_TI:int = 1;
		
		private static const TYPE_BODY:int = 2;
		
		private static const TYPE_TO:int = 3;
		 
		
		private var _file:String;
		
		private var _myLoader:UtilCommonLoader = null;
		
		private var _symbolName:String;
		
		private var _photos:Array;
		
		private var _tempDataStock:PlayerDataStock;
		
		private var _firstSegmentSymbolObj:DisplayObject;
		
		private var _isFirstSegmentsSymbolObj:Boolean = true;
		
		private var _isFirstSegment:Boolean;
		
		private var _firstSegment:Segment;
		
		private var _prevSegment:Segment = null;
		
		private var _segmentType:int;
		
		private var _symbolsContainer:Sprite;
		
		public function Segment()
		{
			this._photos = new Array();
			super();
		}
		
		public static function connectSegment(param1:Vector.<Segment>, param2:Vector.<Segment>) : void
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:Segment = null;
			var _loc7_:Segment = null;
			var _loc8_:Vector.<Segment> = null;
			var _loc9_:Boolean = false;
			var _loc10_:int = 0;
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
						_loc9_ = false;
						if(_loc6_.file == _loc7_.file && _loc6_.getPhotosNum() == _loc7_.getPhotosNum())
						{
							_loc9_ = true;
							_loc10_ = 0;
							while(_loc10_ < _loc6_.getPhotosNum())
							{
								if(_loc6_.getPhotoByIndex(_loc10_).photo_file_path != _loc7_.getPhotoByIndex(_loc10_).photo_file_path)
								{
									_loc9_ = false;
									break;
								}
								_loc10_++;
							}
						}
						if(_loc9_)
						{
							_loc7_._prevSegment = _loc6_;
							_loc8_.splice(_loc4_,1);
						}
						_loc4_++;
					}
					_loc3_++;
				}
			}
		}
		
		private function get segmentType() : int
		{
			return this._segmentType;
		}
		
		private function set segmentType(param1:int) : void
		{
			this._segmentType = param1;
		}
		
		private function getLoader() : UtilCommonLoader
		{
			return this._myLoader;
		}
		
		private function setLoader(param1:UtilCommonLoader) : void
		{
			this._myLoader = param1;
		}
		
		private function get firstSegmentSymbolObj() : DisplayObject
		{
			return this._firstSegmentSymbolObj;
		}
		
		private function set firstSegmentSymbolObj(param1:DisplayObject) : void
		{
			if(this._isFirstSegmentsSymbolObj)
			{
				this._firstSegmentSymbolObj = param1;
			}
			else
			{
				this._prevSegment._firstSegmentSymbolObj = param1;
			}
			this._firstSegmentSymbolObj = param1;
		}
		
		private function getPhotosNum() : int
		{
			return this._photos.length;
		}
		
		private function getPhotoByIndex(param1:int) : Photo
		{
			return this._photos[param1] as Photo;
		}
		
		private function addPhoto(param1:Photo) : void
		{
			this._photos.push(param1);
		}
		
		private function get symbolName() : String
		{
			return this._symbolName;
		}
		
		private function set symbolName(param1:String) : void
		{
			this._symbolName = param1;
		}
		
		private function get file() : String
		{
			return this._file;
		}
		
		private function set file(param1:String) : void
		{
			this._file = param1;
		}
		
		private function get isFirstSegment() : Boolean
		{
			return this._isFirstSegment;
		}
		
		private function set isFirstSegment(param1:Boolean) : void
		{
			this._isFirstSegment = param1;
		}
		
		private function get firstSegment() : Segment
		{
			return this._firstSegment;
		}
		
		private function set firstSegment(param1:Segment) : void
		{
			this._firstSegment = param1;
		}
		
		private function get symbolsContainer() : Sprite
		{
			return this._symbolsContainer;
		}
		
		private function set symbolsContainer(param1:Sprite) : void
		{
			this._symbolsContainer = param1;
		}
		
		public function init(param1:XML, param2:AnimeScene, param3:PlayerDataStock) : Boolean
		{
			var _loc7_:XML = null;
			var _loc8_:String = null;
			var _loc9_:Photo = null;
			var _loc10_:Number = NaN;
			_dataStock = param3;
			super.initAsset(param1.@id,param1.@index,param2);
			this.file = UtilXmlInfo.getZipFileNameOfSegment(param1["file"].toString());
			this.setState(STATE_NULL);
			this._xs = new Array();
			this._xs.push(AnimeConstants.SCREEN_X);
			this._ys = new Array();
			this._ys.push(AnimeConstants.SCREEN_Y);
			var _loc4_:String = UtilXmlInfo.getThemeIdFromFileName(this.file);
			this.symbolName = param1.@symbol;
			if(this.symbolName.substr(0,2) == "TI")
			{
				this.segmentType = TYPE_TI;
			}
			else if(this.symbolName.substr(0,2) == "TO")
			{
				this.segmentType = TYPE_TO;
			}
			else
			{
				this.segmentType = TYPE_BODY;
			}
			if(_loc4_ != "ugc")
			{
				param3.decryptPlayerData(this.file);
			}
			var _loc5_:XMLList = param1.child("photo");
			var _loc6_:Array = this.sortPhotoXmlByIndex(_loc5_);
			var _loc11_:int = 0;
			while(_loc11_ < _loc6_.length)
			{
				_loc7_ = _loc6_[_loc11_];
				_loc8_ = _loc7_.child("file")[0].toString();
				_loc8_ = UtilXmlInfo.getZipFileNameOfProp(_loc8_);
				if(_loc7_.child("rotation").length() > 0)
				{
					_loc10_ = _loc7_.child("rotation")[0].toString();
				}
				else
				{
					_loc10_ = 0;
				}
				_loc9_ = new Photo();
				_loc9_.init(_loc8_,_loc10_,_loc11_);
				this.addPhoto(_loc9_);
				_loc11_++;
			}
			if(param3.getPlayerData(this.file) == null)
			{
				return false;
			}
			return true;
		}
		
		public function startProcess(param1:Boolean = false, param2:Number = 0) : void
		{
			this.initRemoteData(_dataStock);
		}
		
		public function initRemoteData(param1:PlayerDataStock) : void
		{
			var iDataStock:PlayerDataStock = param1;
			try
			{
				this._tempDataStock = iDataStock;
				this.getLoader().addEventListener(Event.COMPLETE,this.onSegmentLoadBytesComplete);
				this.getLoader().shouldPauseOnLoadBytesComplete = true;
				this.getLoader().loadBytes(iDataStock.getPlayerData(this.file) as ByteArray);
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		private function onSegmentLoadBytesComplete(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onSegmentLoadBytesComplete);
			if(this.firstSegmentSymbolObj == null)
			{
				this.firstSegmentSymbolObj = UtilPlain.extractSymbolFromLoader(this.getLoader(),this.symbolName);
				UtilPlain.stopFamily(this.firstSegmentSymbolObj);
			}
			this.firstSegmentSymbolObj.addEventListener(Event.ENTER_FRAME,this.doInitPhotoInstance);
		}
		
		private function doInitPhotoInstance(param1:Event) : void
		{
			var _loc2_:Photo = null;
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doInitPhotoInstance);
			var _loc3_:UtilLoadMgr = new UtilLoadMgr();
			_loc3_.addEventListener(LoadMgrEvent.ALL_COMPLETE,this.onPhotoRemoteDataInited);
			var _loc4_:int = 0;
			while(_loc4_ < this.getPhotosNum())
			{
				_loc2_ = this.getPhotoByIndex(_loc4_);
				_loc3_.addEventDispatcher(_loc2_,PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
				_loc2_.initRemoteData(this._tempDataStock,this.firstSegmentSymbolObj);
				_loc4_++;
			}
			_loc3_.commit();
		}
		
		private function onPhotoRemoteDataInited(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onPhotoRemoteDataInited);
			this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
		}
		
		public function initDependency() : void
		{
			var _loc1_:Photo = null;
			var _loc2_:int = 0;
			this.initAssetDependency();
			if(this._prevSegment != null)
			{
				this.isFirstSegment = false;
				this.firstSegment = this._prevSegment.firstSegment;
				this.setLoader(this.firstSegment.getLoader());
				this.symbolsContainer = this._firstSegment.symbolsContainer;
				if(this._prevSegment.symbolName != this.symbolName)
				{
					this._isFirstSegmentsSymbolObj = true;
				}
				else
				{
					this._isFirstSegmentsSymbolObj = false;
				}
			}
			else
			{
				this.isFirstSegment = true;
				this.firstSegment = this;
				this.setLoader(new UtilCommonLoader());
				this._isFirstSegmentsSymbolObj = true;
				this.symbolsContainer = new Sprite();
			}
			while(_loc2_ < this.getPhotosNum())
			{
				_loc1_ = this.getPhotoByIndex(_loc2_);
				_loc1_.initDependency(this.isFirstSegment,this._isFirstSegmentsSymbolObj,this._prevSegment != null?this._prevSegment.getPhotoByIndex(_loc2_):null);
				_loc2_++;
			}
		}
		
		public function updateProperties(param1:Number) : void
		{
		}
		
		override public function destroy(param1:Boolean = false) : void
		{
			var _loc2_:Photo = null;
			var _loc3_:int = 0;
			this.pause();
			if(param1)
			{
				this.setLoader(null);
				this.firstSegmentSymbolObj = null;
				_loc3_ = 0;
				while(_loc3_ < this.getPhotosNum())
				{
					_loc2_ = this.getPhotoByIndex(_loc3_);
					_loc2_.destroy(param1);
					_loc3_++;
				}
			}
		}
		
		override public function propagateSceneState(param1:int) : void
		{
			var _loc2_:int = 0;
			var _loc3_:Photo = null;
			var _loc4_:DisplayObject = null;
			if(param1 == AnimeScene.STATE_ACTION)
			{
				UtilPlain.removeAllSon(_bundle);
				this.symbolsContainer.addChild(this.firstSegmentSymbolObj);
				_bundle.addChild(this.symbolsContainer);
				_loc2_ = 0;
				while(_loc2_ < this.symbolsContainer.numChildren)
				{
					_loc4_ = this.symbolsContainer.getChildAt(_loc2_);
					if(_loc4_ == this.firstSegmentSymbolObj)
					{
						_loc4_.visible = true;
					}
					else
					{
						_loc4_.visible = false;
					}
					_loc2_++;
				}
				this.resume();
				this.setState(STATE_ACTION);
			}
			else if(param1 == AnimeScene.STATE_NULL)
			{
				this.setState(STATE_NULL);
			}
			_loc2_ = 0;
			while(_loc2_ < this.getPhotosNum())
			{
				_loc3_ = this.getPhotoByIndex(_loc2_);
				_loc3_.propagateSceneState(param1);
				_loc2_++;
			}
		}
		
		override public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
		{
			UtilPlain.gotoAndStopFamilyAt1(this.firstSegmentSymbolObj);
		}
		
		override public function pause() : void
		{
			UtilPlain.stopFamily(this.firstSegmentSymbolObj);
		}
		
		override public function resume() : void
		{
			UtilPlain.playFamily(this.firstSegmentSymbolObj);
		}
		
		private function sortPhotoXmlByIndex(param1:XMLList) : Array
		{
			var curPhotoXML:XML = null;
			var photoXMLlist:XMLList = param1;
			var photoXMLs:Array = new Array();
			var i:int = 0;
			while(i < photoXMLlist.length())
			{
				curPhotoXML = photoXMLlist[i];
				photoXMLs.push(curPhotoXML);
				i++;
			}
			var compareIndexFunction:Function = function(param1:XML, param2:XML):int
			{
				var _loc3_:String = "index";
				var _loc4_:Number = Number(param1.attribute(_loc3_));
				var _loc5_:Number = Number(param2.attribute(_loc3_));
				if(_loc4_ < _loc5_)
				{
					return -1;
				}
				if(_loc4_ > _loc5_)
				{
					return 1;
				}
				return 0;
			};
			photoXMLs.sort(compareIndexFunction);
			return photoXMLs;
		}
	}
}
