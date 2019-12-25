package anifire.player.playback
{
	import anifire.component.ProgressMonitor;
	import anifire.component.ThemeLoader;
	import anifire.constant.CcLibConstant;
	import anifire.constant.ServerConstants;
	import anifire.constant.ThemeConstants;
	import anifire.event.LoadMgrEvent;
	import anifire.managers.AppConfigManager;
	import anifire.managers.CCThemeManager;
	import anifire.models.creator.CCCharacterActionModel;
	import anifire.player.events.PlayerEvent;
	import anifire.util.UtilCrypto;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilLoadMgr;
	import anifire.util.UtilPlain;
	import anifire.util.UtilXmlInfo;
	import br.com.stimuli.loading.BulkLoader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	public class PlayerDataStock extends EventDispatcher
	{
		 
		
		public var embedCredit:Class;
		
		private var _playerDataArray:Object;
		
		private var _playerDataIsDecryptedArray:Object;
		
		private var _playerCustomFontList:Object;
		
		private var _filmXmlArray:Array;
		
		private var _themeXMLs:UtilHashArray;
		
		private var urlRequestArray:Array;
		
		private var bulkLoader:BulkLoader;
		
		private var _licensedSoundInfo:String = "";
		
		private var _themeListXmlArray:Array;
		
		private var _fontListXmlArray:Array;
		
		public function PlayerDataStock()
		{
			this.embedCredit = PlayerDataStock_embedCredit;
			this._filmXmlArray = new Array();
			this._themeListXmlArray = new Array();
			this._fontListXmlArray = new Array();
			super();
			this._playerDataArray = new Object();
			this._playerDataIsDecryptedArray = new Object();
			this._themeXMLs = new UtilHashArray();
		}
		
		public function get playerCustomFontList() : Object
		{
			return this._playerCustomFontList;
		}
		
		public function set playerCustomFontList(param1:Object) : void
		{
			this._playerCustomFontList = param1;
		}
		
		public function getFilmXmlArray() : Array
		{
			return this._filmXmlArray;
		}
		
		private function addFilmXML(param1:XML) : void
		{
			this._filmXmlArray.push(param1);
		}
		
		public function getThemeXMLs() : UtilHashArray
		{
			return this._themeXMLs;
		}
		
		public function addCamAsPlayerData(param1:String, param2:Object) : void
		{
			if(this.getPlayerData(param1) is CCCharacterActionModel)
			{
				return;
			}
			this.addPlayerData(param1,param2);
		}
		
		private function addPlayerData(param1:String, param2:Object, param3:Boolean = false) : void
		{
			this._playerDataArray[param1] = param2;
			this._playerDataIsDecryptedArray[param1] = param3;
		}
		
		public function initByHashArray(param1:XML, param2:UtilHashArray, param3:UtilHashArray) : void
		{
			var _loc4_:int = 0;
			this.addFilmXML(param1.copy());
			_loc4_ = 0;
			while(_loc4_ < param3.length)
			{
				if(param3.getKey(_loc4_) == PlayerConstant.MOVIE_ZIP_FONT_INFO)
				{
					this.playerCustomFontList = param3.getValueByIndex(_loc4_);
				}
				else
				{
					this.addPlayerData(param3.getKey(_loc4_),param3.getValueByIndex(_loc4_),true);
				}
				_loc4_++;
			}
			_loc4_ = 0;
			while(_loc4_ < param2.length)
			{
				this.addThemeXML(XML(param2.getValueByIndex(_loc4_)).copy());
				_loc4_++;
			}
		}
		
		private function addThemeXML(param1:XML) : void
		{
			var _loc3_:XML = null;
			var _loc2_:String = UtilXmlInfo.getThemeIdFromThemeXML(param1);
			if(!this._themeXMLs.containsKey(_loc2_))
			{
				this._themeXMLs.push(_loc2_,param1);
			}
			else
			{
				_loc3_ = UtilXmlInfo.merge2ThemeXml(this._themeXMLs.getValueByKey(_loc2_) as XML,param1,_loc2_,"",false);
				this._themeXMLs.push(_loc2_,_loc3_);
			}
		}
		
		public function initByLoadMovieZip(param1:Array) : void
		{
			var urlRequest:URLRequest = null;
			var urlRequestArray:Array = param1;
			try
			{
				this.urlRequestArray = urlRequestArray;
				this.bulkLoader = new BulkLoader(new Date().toString() + Math.random().toString());
				for each(urlRequest in urlRequestArray)
				{
					this.bulkLoader.add(urlRequest,{"type":BulkLoader.TYPE_BINARY});
				}
				this.bulkLoader.addEventListener(BulkLoader.ERROR,this.onLoadMovieZipCompleted);
				this.bulkLoader.addEventListener(BulkLoader.COMPLETE,this.onLoadMovieZipCompleted);
				this.bulkLoader.addEventListener(BulkLoader.PROGRESS,this.onLoadMovieProgress);
				ProgressMonitor.getInstance().reset();
				ProgressMonitor.getInstance().numProgress = 3;
				ProgressMonitor.getInstance().addProgressEventDispatcher(this.bulkLoader);
				this.bulkLoader.start();
				return;
			}
			catch(e:TypeError)
			{
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		public function destroy() : void
		{
			if(this.bulkLoader != null)
			{
				this.bulkLoader.removeAll();
			}
		}
		
		private function onLoadMovieProgress(param1:Event) : void
		{
			this.dispatchEvent(new PlayerEvent(PlayerEvent.LOAD_MOVIE_PROGRESS,param1));
		}
		
		private function onLoadMovieZipCompleted(param1:Event) : void
		{
			var _loc9_:Event = null;
			var _loc11_:URLRequest = null;
			var _loc12_:String = null;
			var _loc13_:Array = null;
			var _loc14_:ByteArray = null;
			var _loc15_:ByteArray = null;
			var _loc16_:ZipFile = null;
			var _loc17_:int = 0;
			var _loc18_:ZipEntry = null;
			var _loc19_:ByteArray = null;
			var _loc20_:int = 0;
			var _loc21_:ZipEntry = null;
			var _loc22_:ZipFile = null;
			var _loc23_:ByteArray = null;
			var _loc24_:Object = null;
			var _loc25_:XML = null;
			var _loc26_:int = 0;
			var _loc27_:XML = null;
			var _loc28_:XML = null;
			var _loc29_:ByteArray = null;
			var _loc30_:Object = null;
			var _loc2_:AppConfigManager = AppConfigManager.instance;
			var _loc3_:Boolean = false;
			var _loc4_:* = _loc2_.getValue(ServerConstants.FLASHVAR_IS_VIDEO_RECORD_MODE) == "1";
			if(_loc4_)
			{
				_loc12_ = _loc2_.getValue(ServerConstants.FLASHVAR_CHAIN_MOVIE_ID);
				if(_loc12_ != null && _loc12_ != "")
				{
					_loc13_ = _loc12_.split(",");
					if(_loc13_[_loc13_.length - 1] == ServerConstants.END_CREDIT_MOVIE_ID)
					{
						_loc3_ = true;
					}
				}
			}
			var _loc5_:BulkLoader = param1.target as BulkLoader;
			var _loc6_:int = 0;
			var _loc7_:String = "";
			var _loc8_:String = "";
			var _loc10_:int = 1;
			if(param1.type != BulkLoader.COMPLETE)
			{
				_loc7_ = _loc7_ + ("Error loading file by url. The type of event returned is: " + param1.toString() + ".");
				_loc9_ = new PlayerEvent(PlayerEvent.ERROR_LOADING_MOVIE,"");
				this.dispatchEvent(_loc9_);
				return;
			}
			for each(_loc11_ in this.urlRequestArray)
			{
				_loc14_ = _loc5_.getBinary(_loc11_,true);
				_loc6_ = _loc14_.readByte();
				_loc15_ = new ByteArray();
				_loc14_.readBytes(_loc15_);
				if(_loc6_ != 0)
				{
					_loc7_ = _loc7_ + ("Downloading file completed with non-zero returnCode: " + _loc6_ + ". " + _loc15_.toString());
					try
					{
						_loc27_ = new XML(_loc15_.toString());
						_loc8_ = _loc27_.child("code");
					}
					catch(e:Error)
					{
					}
				}
				if(_loc7_ != "")
				{
					_loc9_ = new PlayerEvent(PlayerEvent.ERROR_LOADING_MOVIE,_loc8_);
					this.dispatchEvent(_loc9_);
					return;
				}
				_loc16_ = new ZipFile(_loc15_);
				_loc17_ = 0;
				while(_loc17_ < _loc16_.size)
				{
					_loc18_ = _loc16_.entries[_loc17_];
					if(_loc18_.name == PlayerConstant.FILM_XML_FILENAME)
					{
						if(_loc4_ == "1")
						{
							_loc28_ = new XML(_loc16_.getInput(_loc18_).toString());
							_loc26_ = 0;
							while(_loc26_ < _loc28_.child("sound").length())
							{
								_loc25_ = _loc28_.child("sound")[_loc26_];
								if(_loc25_.hasOwnProperty("info"))
								{
									this._licensedSoundInfo = this._licensedSoundInfo + (_loc25_.info.title + " - Author: " + _loc25_.info.author + "\n");
								}
								_loc26_++;
							}
						}
						this.addFilmXML(new XML(_loc16_.getInput(_loc18_).toString()));
						if(this._licensedSoundInfo != "" && (_loc10_ == this.urlRequestArray.length - 1 && _loc3_ == true || _loc10_ == this.urlRequestArray.length && _loc3_ == false))
						{
							this.addCreditScreen();
						}
					}
					else if(_loc18_.name.indexOf("ugc.char") > -1 && _loc18_.name.substr(_loc18_.name.length - 3,3).toLowerCase() == "xml")
					{
						_loc24_ = _loc16_.getInput(_loc18_);
						this.addPlayerData(_loc18_.name,new XML(_loc24_.toString()));
					}
					else if(_loc18_.name.indexOf("ugc.prop") > -1 && _loc18_.name.substr(_loc18_.name.length - 3,3).toLowerCase() == "xml")
					{
						_loc24_ = _loc16_.getInput(_loc18_);
						this.addPlayerData(_loc18_.name,_loc24_);
					}
					else if(_loc18_.name == "themelist.xml")
					{
						_loc24_ = _loc16_.getInput(_loc18_);
						this._themeListXmlArray.push(new XML(_loc24_.toString()));
					}
					else if(_loc18_.name == "fontlist.xml")
					{
						_loc24_ = _loc16_.getInput(_loc18_);
						this._fontListXmlArray.push(new XML(_loc24_.toString()));
					}
					else if(_loc18_.name.substr(_loc18_.name.length - 3,3).toLowerCase() == "xml")
					{
						if(_loc18_.name == "ugc.xml")
						{
							_loc24_ = _loc16_.getInput(_loc18_);
							this.addThemeXML(new XML(_loc24_.toString()));
						}
					}
					else if(_loc18_.name.indexOf(CcLibConstant.NODE_LIBRARY) > -1 && _loc18_.name.substr(_loc18_.name.length - 3,3).toLowerCase() == "zip")
					{
						_loc19_ = _loc16_.getInput(_loc18_);
						_loc22_ = new ZipFile(_loc19_);
						_loc20_ = 0;
						while(_loc20_ < _loc22_.size)
						{
							_loc21_ = _loc22_.entries[_loc20_];
							if(_loc21_.name.substr(_loc21_.name.length - 3,3).toLowerCase() == "swf")
							{
								_loc23_ = _loc22_.getInput(_loc21_);
								this.addPlayerData(_loc21_.name,_loc23_);
							}
							_loc20_++;
						}
					}
					else if(_loc18_.name.substr(_loc18_.name.length - 3,3).toLowerCase() == "zip")
					{
						_loc19_ = _loc16_.getInput(_loc18_);
						_loc22_ = new ZipFile(_loc19_);
						this.addPlayerData(_loc18_.name,UtilPlain.convertZipAsImagedataObject(_loc22_));
					}
					else if(_loc18_.name == PlayerConstant.MOVIE_ZIP_FONT_INFO)
					{
						_loc29_ = _loc16_.getInput(_loc18_);
						_loc30_ = com.adobe.serialization.json.JSON.decode(_loc29_.toString());
						this.playerCustomFontList = _loc30_;
					}
					else
					{
						_loc19_ = _loc16_.getInput(_loc18_);
						this.addPlayerData(_loc18_.name,_loc19_);
					}
					_loc17_++;
				}
				_loc10_++;
			}
			this.loadAllThemeXmls();
		}
		
		private function loadMovieXml() : void
		{
			var _loc1_:URLRequest = new URLRequest("https://s3.amazonaws.com/schoolcloudfront/xml/movie/movie/33/0P0PDv0XN3zE/1269236357.gz.xml");
			var _loc2_:URLLoader = new URLLoader();
			_loc2_.dataFormat = URLLoaderDataFormat.TEXT;
			_loc2_.addEventListener(Event.COMPLETE,this.onLoadMovieXmlComplete);
			_loc2_.load(_loc1_);
		}
		
		private function onLoadMovieXmlComplete(param1:Event) : void
		{
			IEventDispatcher(param1.target).removeEventListener(param1.type,this.onLoadMovieXmlComplete);
			if(param1.target is URLLoader)
			{
				this.addFilmXML(new XML(URLLoader(param1.target).data));
			}
			this.loadAllThemeXmls();
		}
		
		private function loadAllThemeXmls() : void
		{
			var _loc2_:XMLList = null;
			var _loc3_:UtilLoadMgr = null;
			var _loc4_:ThemeLoader = null;
			var _loc5_:Array = null;
			var _loc6_:String = null;
			var _loc7_:Number = NaN;
			var _loc8_:XML = null;
			var _loc1_:XML = this.getThemeXMLs().getValueByKey("ugc");
			if(_loc1_)
			{
				_loc2_ = _loc1_.char.@cc_theme_id;
			}
			if(this._themeListXmlArray && this._themeListXmlArray.length > 0)
			{
				_loc3_ = new UtilLoadMgr();
				_loc3_.addEventListener(LoadMgrEvent.ALL_COMPLETE,this.onAllThemeXmlLoaded);
				_loc5_ = new Array();
				_loc7_ = 0;
				while(_loc7_ < this._themeListXmlArray.length)
				{
					if(this._themeListXmlArray[_loc7_])
					{
						for each(_loc8_ in this._themeListXmlArray[_loc7_].theme)
						{
							_loc6_ = _loc8_.toString();
							if(_loc8_.toString() != "ugc" && _loc5_.indexOf(_loc6_) == -1)
							{
								_loc4_ = ThemeLoader.getThemeLoader(_loc6_);
								_loc4_.addEventListener(Event.COMPLETE,this.onThemeXmlLoaded);
								_loc3_.addEventDispatcher(_loc4_,Event.COMPLETE);
								_loc4_.load(_loc6_);
								_loc5_.push(_loc6_);
							}
						}
						for each(_loc6_ in _loc2_)
						{
							if(!CCThemeManager.instance.getThemeModel(_loc6_).completed)
							{
								_loc3_.addEventDispatcher(CCThemeManager.instance.getThemeModel(_loc6_),Event.COMPLETE);
								CCThemeManager.instance.getThemeModel(_loc6_).load();
							}
						}
					}
					_loc7_++;
				}
				_loc3_.commit();
			}
			else
			{
				this.dispatchEvent(new PlayerEvent(PlayerEvent.LOAD_MOVIE_COMPLETE));
			}
		}
		
		public function loadAllCCThemeXmls() : void
		{
			var _loc3_:XMLList = null;
			var _loc4_:UtilLoadMgr = null;
			var _loc1_:XML = this.getThemeXMLs().getValueByKey("ugc");
			var _loc2_:String = ThemeConstants.UGC_THEME_ID;
			if(_loc1_)
			{
				CCThemeManager.instance.getThemeModel(_loc2_).parseThemeXML(_loc1_);
				_loc3_ = _loc1_.char.@cc_theme_id;
				_loc4_ = new UtilLoadMgr();
				_loc4_.addEventListener(LoadMgrEvent.ALL_COMPLETE,this.onAllCCThemeXmlLoaded);
				for each(_loc2_ in _loc3_)
				{
					if(!CCThemeManager.instance.getThemeModel(_loc2_).completed)
					{
						_loc4_.addEventDispatcher(CCThemeManager.instance.getThemeModel(_loc2_),Event.COMPLETE);
						CCThemeManager.instance.getThemeModel(_loc2_).load();
					}
				}
				_loc4_.commit();
			}
			else
			{
				this.dispatchEvent(new PlayerEvent(PlayerEvent.LOAD_CCTHEME_COMPLETE));
			}
		}
		
		private function onThemeXmlLoaded(param1:Event) : void
		{
			IEventDispatcher(param1.target).removeEventListener(param1.type,this.onThemeXmlLoaded);
			this.addThemeXML(ThemeLoader(param1.target).xml);
		}
		
		private function onAllCCThemeXmlLoaded(param1:Event) : void
		{
			this.dispatchEvent(new PlayerEvent(PlayerEvent.LOAD_CCTHEME_COMPLETE));
		}
		
		private function onAllThemeXmlLoaded(param1:Event) : void
		{
			this.dispatchEvent(new PlayerEvent(PlayerEvent.LOAD_MOVIE_COMPLETE));
		}
		
		private function addCreditScreen() : void
		{
			var _loc1_:XML = new XML(<film copyable="0" duration="1" published="0" pshare="1">
						<meta>
						  <title>credit screen</title>
						  <tag>credit screen</tag>
						  <hiddenTag/>
						  <desc></desc>
						  <mver>3</mver>
						</meta>
						<scene id="SCENE0" adelay="60" lock="Y" index="0">
						  <bg id="BG7" index="0">
							 <file>ugc.credit.png</file>
						  </bg>
						  <bubbleAsset id="BUBBLE8" index="1">
							 <x>234</x>
							 <y>85</y>
							 <bubble x="-119.1" y="32.3" w="418.3" h="25.7" rotate="0" type="BLANK">
								<body rgb="16777215" alpha="1" linergb="0" tailx="180" taily="110"/>
								<text rgb="13421772" font="Arial" size="16" align="center" bold="true" italic="false" embed="false">Music licensed under Creative Commons Share Alike:</text>
								<url/>
							 </bubble>
						  </bubbleAsset>
						</scene>
					 </film>);
			var _loc2_:XML = <bubbleAsset id="BUBBLE9" index="2">
						<x>233.5</x>
						<y>123</y>
						<bubble x="-152.3" y="27.1" w="484.8" h="40" rotate="0" type="BLANK">
						  <body rgb="16777215" alpha="1" linergb="0" tailx="180" taily="110"/>
						  <text rgb="13421772" font="Arial" size="18" align="center" bold="false" italic="false" embed="false"></text>
						  <url/>
						</bubble>
					 </bubbleAsset>;
			_loc2_.bubble.text = this._licensedSoundInfo;
			var _loc3_:Array = this._licensedSoundInfo.split("\n");
			_loc2_.bubble.@h = 30 * _loc3_.length;
			_loc1_.scene.appendChild(_loc2_);
			var _loc4_:ByteArray = new this.embedCredit();
			this.addPlayerData("ugc.bg.credit.png",_loc4_);
			this.addFilmXML(_loc1_);
		}
		
		private function onInitPlayerDataStockDone(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitPlayerDataStockDone);
			this.dispatchEvent(new PlayerEvent(PlayerEvent.LOAD_MOVIE_COMPLETE));
		}
		
		public function getPlayerData(param1:String) : Object
		{
			return this._playerDataArray[param1] as Object;
		}
		
		public function decryptPlayerData(param1:String) : void
		{
			var _loc2_:UtilCrypto = null;
			if(!this._playerDataIsDecryptedArray[param1])
			{
				_loc2_ = new UtilCrypto();
				_loc2_.decrypt(this._playerDataArray[param1] as ByteArray);
				this._playerDataIsDecryptedArray[param1] = true;
			}
		}
	}
}
