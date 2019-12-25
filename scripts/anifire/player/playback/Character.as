package anifire.player.playback
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.assets.transition.AssetTransitionNode;
	import anifire.color.SelectedColor;
	import anifire.component.SkinnedAssetMaker;
	import anifire.constant.AnimeConstants;
	import anifire.constant.RaceConstants;
	import anifire.event.ByteLoaderEvent;
	import anifire.event.ExtraDataEvent;
	import anifire.event.LoadMgrEvent;
	import anifire.event.SpeechPitchEvent;
	import anifire.interfaces.ICharacter;
	import anifire.interfaces.IRegulatedProcess;
	import anifire.interfaces.ISpeak;
	import anifire.player.events.PlayerEvent;
	import anifire.player.interfaces.IAssetMotion;
	import anifire.player.interfaces.IPlayback;
	import anifire.util.UtilCommonLoader;
	import anifire.util.UtilErrorLogger;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilHashSelectedColor;
	import anifire.util.UtilLoadMgr;
	import anifire.util.UtilPlain;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	public class Character extends Asset implements ISpeak, IRegulatedProcess, IPlayback
	{
		
		public static const STATE_ACTION:int = 1;
		
		public static const STATE_MOTION:int = 2;
		
		public static const STATE_FADE:int = 3;
		
		public static const STATE_NULL:int = 0;
		
		public static const XML_TAG:String = "char";
		 
		
		private var _xscale:Number = 1;
		
		private var _xscales:Array;
		
		private var _yscale:Number = 1;
		
		private var _yscales:Array;
		
		private var _rotation:Number = 0;
		
		private var _rotations:Array;
		
		private var _lookAtCamera:Boolean = false;
		
		private var _face:String = null;
		
		private var _facings:Array;
		
		private var _motionface:String;
		
		private var _action:Action = null;
		
		private var _motion:Motion = null;
		
		private var _charInNextScene:Character;
		
		private var _charInPrevScene:Character;
		
		private var _prop:Prop;
		
		private var _head:Prop;
		
		private var _wear:Prop;
		
		private var _myLoadMgr:UtilLoadMgr;
		
		private var _isSpeech:Boolean = false;
		
		private var _assetMotion:IAssetMotion;
		
		private var _motionCache:MotionCache;
		
		private var _motionStartFrame:int = 1;
		
		private var _motionEndFrame:int = -1;
		
		private var _speechSource:IEventDispatcher;
		
		private var _speechPitchSourceArray:Vector.<AnimeSound>;
		
		private var _speechOverlapped:Boolean;
		
		private var motionSound:Sound;
		
		private var actionSound:Sound;
		
		private var _currentPitch:Number = -1;
		
		public function Character()
		{
			this._speechPitchSourceArray = new Vector.<AnimeSound>();
			super();
		}
		
		public static function connectCharacters(param1:Vector.<Character>, param2:Vector.<Character>) : void
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:Character = null;
			var _loc7_:Character = null;
			var _loc8_:Point = null;
			var _loc9_:Point = null;
			var _loc10_:Vector.<Character> = null;
			var _loc11_:Character = null;
			if(param1 && param2 && param1.length > 0 && param2.length > 0)
			{
				_loc8_ = new Point();
				_loc9_ = new Point();
				_loc10_ = param2.concat();
				_loc3_ = param1.length;
				_loc4_ = 0;
				while(_loc4_ < _loc3_)
				{
					_loc6_ = param1[_loc4_];
					_loc8_.x = _loc6_._xs[_loc6_._xs.length - 1];
					_loc8_.y = _loc6_._ys[_loc6_._ys.length - 1];
					_loc5_ = 0;
					while(_loc5_ < _loc10_.length)
					{
						_loc7_ = _loc10_[_loc5_];
						if(_loc6_.action.getFile() == _loc7_.action.getFile())
						{
							_loc9_.x = _loc7_._xs[0];
							_loc9_.y = _loc7_._ys[0];
							if(Point.distance(_loc8_,_loc9_) <= 1)
							{
								if(_loc6_.isSpeech || _loc7_.isSpeech)
								{
									if(_loc6_.action.getFile() == _loc7_.action.getFile())
									{
										_loc6_.isSpeech = _loc7_.isSpeech = true;
									}
								}
								if(_loc6_.action.getFace() == _loc7_.action.getFace())
								{
									_loc6_._charInNextScene = _loc7_;
									_loc7_._charInPrevScene = _loc6_;
									if(_loc6_.isSpeech)
									{
										_loc11_ = _loc6_._charInPrevScene;
										while(_loc11_)
										{
											if(_loc11_.action.getFile() == _loc6_.action.getFile())
											{
												_loc11_.isSpeech = true;
												_loc11_ = _loc11_._charInPrevScene;
											}
											else
											{
												_loc11_ = null;
											}
										}
									}
									_loc10_.splice(_loc5_,1);
									break;
								}
							}
						}
						_loc5_++;
					}
					_loc4_++;
				}
			}
		}
		
		public static function isChanged(param1:Character, param2:Character) : Boolean
		{
			if(param1._x != param2._x || param1._y != param2._y || param1._xscale != param2._xscale || param1._yscale != param2._yscale || param1._rotation != param2._rotation)
			{
				return true;
			}
			return false;
		}
		
		public function get charInPrevScene() : Character
		{
			return this._charInPrevScene;
		}
		
		public function get isSpeech() : Boolean
		{
			return this._isSpeech;
		}
		
		public function set isSpeech(param1:Boolean) : void
		{
			this._isSpeech = param1;
		}
		
		public function get isCC() : Boolean
		{
			return raceCode == RaceConstants.CUSTOM_CHARACTER;
		}
		
		public function get face() : String
		{
			return this._face;
		}
		
		public function set face(param1:String) : void
		{
			this._face = param1;
		}
		
		public function get motion() : Motion
		{
			return this._motion;
		}
		
		public function set motion(param1:Motion) : void
		{
			this._motion = param1;
			if(this._motion != null)
			{
				this._motion.myChar = this;
			}
		}
		
		public function get action() : Action
		{
			return this._action;
		}
		
		public function set action(param1:Action) : void
		{
			this._action = param1;
			if(this._action != null)
			{
				this._action.myChar = this;
			}
		}
		
		public function get prop() : Prop
		{
			return this._prop;
		}
		
		public function set prop(param1:Prop) : void
		{
			this._prop = param1;
		}
		
		public function get head() : Prop
		{
			return this._head;
		}
		
		public function set head(param1:Prop) : void
		{
			this._head = param1;
		}
		
		public function get wear() : Prop
		{
			return this._wear;
		}
		
		public function set wear(param1:Prop) : void
		{
			this._wear = param1;
		}
		
		override public function propagateSceneState(param1:int) : void
		{
			if(param1 == AnimeScene.STATE_ACTION)
			{
				this.setState(Character.STATE_ACTION);
			}
			else if(param1 == AnimeScene.STATE_MOTION)
			{
				if(this._charInNextScene == null)
				{
					this.setState(Character.STATE_FADE);
				}
				else if(this.motion == null)
				{
					this.setState(Character.STATE_ACTION);
				}
				else if(Character.isChanged(this,this._charInNextScene))
				{
					this.setState(Character.STATE_MOTION);
				}
				else
				{
					this.setState(Character.STATE_ACTION);
				}
			}
			else if(param1 == AnimeScene.STATE_NULL)
			{
				this.setState(Character.STATE_NULL);
			}
		}
		
		override protected function setState(param1:int) : void
		{
			var _loc2_:Behaviour = null;
			var _loc3_:Behaviour = null;
			var _loc4_:SoundTransform = null;
			var _loc5_:Behaviour = null;
			if(param1 == Character.STATE_MOTION)
			{
				UtilPlain.removeAllSon(_bundle);
				_bundle.addChild(this.motion.getLoader());
				this.updateMotionStaticProperty();
				if(this.action.nextBehavior == null)
				{
					this.detachAllProps(this.action);
					this.action.pause();
				}
				if(this.motion.isFirstBehavior)
				{
					this.detachAllProps(this.motion);
					this.motion.resume();
				}
				this.attachAllProps(this.motion);
				if(this.prop != null && this.prop.isFirstProp)
				{
					this.prop.resume();
				}
				if(this.head != null && this.head.isFirstProp)
				{
					this.head.resume();
				}
				if(this.wear != null && this.wear.isFirstProp)
				{
					this.wear.resume();
				}
				_loc3_ = this.action;
				while(!_loc3_.isFirstBehavior)
				{
					_loc3_ = _loc3_.prevBehavior;
				}
				_loc2_ = this.motion;
				while(!_loc2_.isFirstBehavior)
				{
					_loc2_ = _loc2_.prevBehavior;
				}
				_loc2_.myChar.sound = _loc2_.myChar.motionSound;
				if(_loc3_.myChar.isPlaying)
				{
					_loc3_.myChar.stopMusic();
					_loc2_.myChar.playMusic(0,0,_loc3_.myChar.soundChannel.soundTransform);
				}
			}
			else if(param1 == Character.STATE_FADE)
			{
				if(this._state != Character.STATE_ACTION)
				{
					UtilPlain.removeAllSon(_bundle);
					_bundle.addChild(this.action.getLoader());
					this.updateActionStaticProperty();
					if(this.motion != null)
					{
						this.motion.pause();
					}
					if(this.action.isFirstBehavior)
					{
						this.action.resume();
					}
				}
			}
			else if(param1 == Character.STATE_ACTION)
			{
				if(this._state != Character.STATE_ACTION)
				{
					UtilPlain.removeAllSon(_bundle);
					_bundle.addChild(this.action.getLoader());
					this.updateActionStaticProperty();
					if(this.motion != null)
					{
						this.detachAllProps(this.motion);
						this.motion.pause();
					}
					if(this.action.isFirstBehavior)
					{
						this.detachAllProps(this.action);
						this.action.resume();
					}
					this.attachAllProps(this.action);
					if(this.prop != null && this.prop.isFirstProp)
					{
						this.prop.resume();
					}
					if(this.head != null && this.head.isFirstProp)
					{
						this.head.resume();
					}
					if(this.wear != null && this.wear.isFirstProp)
					{
						this.wear.resume();
					}
					_loc2_ = this.action;
					while(!_loc2_.isFirstBehavior)
					{
						_loc2_ = _loc2_.prevBehavior;
					}
					if(this.motion != null)
					{
						_loc3_ = this.motion;
						while(!_loc3_.isFirstBehavior)
						{
							_loc3_ = _loc3_.prevBehavior;
						}
					}
					_loc2_.myChar.sound = _loc2_.myChar.actionSound;
					if(this.motion != null && _loc3_.myChar.isPlaying)
					{
						_loc3_.myChar.stopMusic();
						_loc2_.myChar.playMusic(0,0,_loc3_.myChar.soundChannel.soundTransform);
					}
				}
			}
			super.setState(param1);
		}
		
		public function getMotionSound() : Sound
		{
			return this.motionSound;
		}
		
		public function getActionSound() : Sound
		{
			return this.motionSound;
		}
		
		public function startProcess(param1:Boolean = false, param2:Number = 0) : void
		{
			this.initRemoteData(_dataStock);
		}
		
		public function initRemoteData(param1:PlayerDataStock, param2:Number = 0, param3:Number = 0) : void
		{
			var _loc4_:UtilLoadMgr = new UtilLoadMgr();
			_loc4_.addEventListener(LoadMgrEvent.ALL_COMPLETE,this.onInitRemoteDataCompleted);
			if(this.motion != null)
			{
				_loc4_.addEventDispatcher(this.motion.getEventDispatcher(),PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
				this.motion.addEventListener("MotionSoundRdy",this.initSound);
				this.motion.initRemoteData(param1,raceCode,param2,param3);
			}
			if(this.action != null)
			{
				_loc4_.addEventDispatcher(this.action.getEventDispatcher(),PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
				this.action.addEventListener("SoundRdy",this.initSound);
				this.action.initRemoteData(param1,raceCode,param2,param3,this.isSpeech,this.head == null,customColor);
			}
			if(this.prop != null)
			{
				_loc4_.addEventDispatcher(this.prop.getEventDispatcher(),PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
				this.prop.initRemoteData(param1,this.prop.raceCode);
			}
			if(this.head != null)
			{
				_loc4_.addEventDispatcher(this.head.getEventDispatcher(),PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
				this.head.initRemoteData(param1,this.head.raceCode,this.isSpeech);
			}
			if(this.wear != null)
			{
				_loc4_.addEventDispatcher(this.wear.getEventDispatcher(),PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
				this.wear.initRemoteData(param1,this.wear.raceCode);
			}
			_loc4_.commit();
			this.setState(Character.STATE_NULL);
		}
		
		private function onInitRemoteDataCompleted(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitRemoteDataCompleted);
			this.initAllTransitionsRemoteData();
		}
		
		private function initSound(param1:ExtraDataEvent) : void
		{
			var _loc2_:Class = null;
			if(param1.type == "SoundRdy")
			{
				if(this.action.hasEventListener("SoundRdy"))
				{
					this.action.removeEventListener("SoundRdy",this.initSound);
				}
				_loc2_ = param1.getData() as Class;
				this.actionSound = new _loc2_();
				this.sound = this.actionSound;
			}
			else if(param1.type == "MotionSoundRdy")
			{
				if(this.action.hasEventListener("MotionSoundRdy"))
				{
					this.action.removeEventListener("MotionSoundRdy",this.initSound);
				}
				_loc2_ = param1.getData() as Class;
				this.motionSound = new _loc2_();
			}
		}
		
		public function init(param1:XML, param2:AnimeScene, param3:UtilHashArray, param4:PlayerDataStock) : Boolean
		{
			var _loc5_:Boolean = false;
			var _loc9_:XML = null;
			var _loc10_:int = 0;
			var _loc11_:SelectedColor = null;
			_dataStock = param4;
			super.initAsset(param1.@id,param1.@index,param2);
			_bundle.blendMode = BlendMode.LAYER;
			this.raceCode = param1.@isCC == "Y"?1:0;
			if(param1.@raceCode.length() > 0)
			{
				this.raceCode = int(param1.@raceCode);
			}
			this._xs = String(param1["x"]).split(",");
			this._ys = String(param1["y"]).split(",");
			this._lookAtCamera = param1.@faceCamera == "true";
			this._xscales = String(param1["xscale"]).split(",");
			this._yscales = String(param1["yscale"]).split(",");
			this._rotations = String(param1["rotation"]).split(",");
			this._facings = String(param1.action.@face).split(",");
			this._motionface = param1.action.@motionface;
			if(_xs.length > 1)
			{
				this._assetMotion = new SlideMotion();
				SlideMotion(this._assetMotion).init(_xs,_ys,this._xscales,this._yscales,this._rotations);
				if(param1.hasOwnProperty(SlideMotion.XML_TAG_NAME))
				{
					SlideMotion(this._assetMotion).convertFromXml(param1.child(SlideMotion.XML_TAG_NAME)[0]);
				}
				this._motionCache = new MotionCache(this._assetMotion,Math.ceil(param2.totalFrame));
			}
			var _loc6_:XML = param1.child(Prop.XML_TAG)[0];
			if(_loc6_ != null)
			{
				this.prop = new Prop();
				if(param2)
				{
					this.prop.sceneId = param2.id;
				}
				_loc5_ = this.prop.init(_loc6_,null,param4);
				if(!_loc5_)
				{
					this.prop = null;
				}
			}
			else
			{
				this.prop = null;
			}
			var _loc7_:XML = param1.child(Prop.XML_TAG_HEAD)[0];
			if(_loc7_ != null)
			{
				this.head = new Prop();
				if(param2)
				{
					this.head.sceneId = param2.id;
				}
				_loc5_ = this.head.init(_loc7_,null,param4);
				this.head.lookAtCamera = this._lookAtCamera;
				if(!_loc5_)
				{
					this.head = null;
				}
			}
			else
			{
				this.head = null;
			}
			var _loc8_:XML = param1.child(Prop.XML_TAG_WEAR)[0];
			if(_loc8_ != null)
			{
				this.wear = new Prop();
				if(param2)
				{
					this.wear.sceneId = param2.id;
				}
				_loc5_ = this.wear.init(_loc8_,null,param4);
				if(!_loc5_)
				{
					this.wear = null;
				}
			}
			else
			{
				this.wear = null;
			}
			if(param1.hasOwnProperty("action"))
			{
				this.action = Action.createAction(param1.action[0]);
				_loc5_ = this.action.init(param1.child(Action.XML_TAG)[0],param3,param4);
				if(param2)
				{
					this.action.sceneId = param2.id;
				}
				if(!_loc5_)
				{
					return false;
				}
			}
			if(param1.color.length())
			{
				customColor = new UtilHashSelectedColor();
				_loc10_ = 0;
				while(_loc10_ < param1.child("color").length())
				{
					_loc9_ = param1.child("color")[_loc10_];
					_loc11_ = new SelectedColor(_loc9_.@r,_loc9_.attribute("oc").length() == 0?uint(uint.MAX_VALUE):uint(_loc9_.@oc),uint(_loc9_));
					addCustomColor(_loc9_.@r,_loc11_);
					_loc10_++;
				}
			}
			return true;
		}
		
		public function initDependency(param1:Number, param2:Number, param3:Number, param4:Number, param5:UtilHashArray) : void
		{
			this.initAssetDependency();
			var _loc6_:Action = this._charInPrevScene != null?this._charInPrevScene.action:null;
			var _loc7_:Motion = this._charInPrevScene != null?this._charInPrevScene.motion:null;
			this.action.initDependency(param1,_loc7_,param4,_loc6_,param3,param5,raceCode);
			if(this._charInNextScene != null)
			{
				this.motion = this._charInNextScene.motion;
			}
			else
			{
				this.motion = null;
			}
			if(this.motion != null)
			{
				this.motion.initDependency(this.action,param1,param2,_loc7_,param4,_loc6_,param3,param5);
			}
			if(this.prop != null)
			{
				Prop.connectPropsIfNecessary(this.prop,this._charInNextScene != null?this._charInNextScene.prop:null);
				this.prop.initDependency(null,param5);
			}
			if(this.head != null)
			{
				Prop.connectPropsIfNecessary(this.head,this._charInNextScene != null?this._charInNextScene.head:null);
				this.head.initDependency(null,param5);
			}
			if(this.wear != null)
			{
				Prop.connectPropsIfNecessary(this.wear,this._charInNextScene != null?this._charInNextScene.wear:null);
				this.wear.initDependency(null,param5);
			}
		}
		
		public function playFrame(param1:uint, param2:uint) : void
		{
			var _loc3_:Point = null;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			var _loc9_:Number = NaN;
			var _loc10_:Number = NaN;
			if(this._state == Character.STATE_FADE)
			{
				_bundle.alpha = 1 - _loc4_;
			}
			else if(this._state == Character.STATE_ACTION)
			{
				if(this._assetMotion)
				{
					_loc3_ = this._motionCache.getPosition(param1);
					_bundle.x = _loc3_.x;
					_bundle.y = _loc3_.y;
					_loc3_ = this._motionCache.getScale(param1);
					_bundle.scaleX = _loc3_.x;
					_bundle.scaleY = _loc3_.y;
					_bundle.rotation = this._motionCache.getRotation(param1);
					if(!this._assetMotion.pathOriented && this._xs.length > 2 && this._ys.length > 2)
					{
						_loc4_ = (param1 - 1) / (param2 - 1);
						if(_loc4_ != 0 && _loc4_ != 1)
						{
							_loc5_ = 0;
							_loc10_ = 1 / (param2 - 1);
							this.action.flip(this._facings[0]);
							if(this._motionCache.getHFlipped(param1))
							{
								this.action.flip(Behaviour.CHANGE_FACE);
							}
						}
					}
				}
			}
		}
		
		public function get isFlipped() : Boolean
		{
			if(this.action)
			{
				return this.action.isFlipped;
			}
			return false;
		}
		
		private function updateActionStaticProperty() : void
		{
			_bundle.x = this._xs[0];
			_bundle.y = this._ys[0];
			_bundle.scaleY = this._yscales[0];
			_bundle.scaleX = this._xscales[0];
			_bundle.rotation = this._rotations[0];
			_bundle.alpha = 1;
			if(this.head == null)
			{
				this.action.setLookAtCamera(this._lookAtCamera);
			}
			this.action.updateStaticProperties();
			if(this.motion != null)
			{
				this.motion.updateStaticProperties();
			}
			if(this.prop != null)
			{
				this.prop.propagateCharState(Character.STATE_ACTION);
			}
			if(this.head != null)
			{
				this.head.propagateCharState(Character.STATE_ACTION);
			}
			if(this.wear != null)
			{
				this.wear.propagateCharState(Character.STATE_ACTION);
			}
		}
		
		private function updateMotionStaticProperty() : void
		{
			if(this.motion != null)
			{
				if(this.prop != null)
				{
					this.prop.propagateCharState(Character.STATE_MOTION);
				}
				if(this.head != null)
				{
					this.head.propagateCharState(Character.STATE_MOTION);
				}
				if(this.wear != null)
				{
					this.wear.propagateCharState(AnimeScene.STATE_MOTION);
				}
			}
		}
		
		private function removeHandProp(param1:Behaviour) : void
		{
			if(param1.getLoader() is ICharacter && (param1.getLoader() is SkinnedAssetMaker || ICharacter(param1.getLoader()).ver == 2))
			{
				ICharacter(param1.getLoader()).CCM.addEventListener(ByteLoaderEvent.LOAD_BYTES_COMPLETE,this.onLoadThumbForCcComplete);
				ICharacter(param1.getLoader()).CCM.removeStyle(AnimeConstants.CLASS_GOPROP);
			}
			else
			{
				param1.removeProp();
			}
		}
		
		private function detachAllProps(param1:Behaviour) : void
		{
			if(this.prop != null)
			{
				this.removeHandProp(param1);
			}
			if(this.head != null)
			{
				param1.removeHead();
			}
			if(this.wear != null)
			{
				param1.removeWear();
			}
		}
		
		private function attachAllProps(param1:Behaviour) : void
		{
			var behavior:Behaviour = param1;
			try
			{
				if(this.prop != null)
				{
					if(behavior.getLoader() is ICharacter && (behavior.getLoader() is SkinnedAssetMaker || ICharacter(behavior.getLoader()).ver == 2))
					{
						ICharacter(behavior.getLoader()).CCM.addEventListener(ByteLoaderEvent.LOAD_BYTES_COMPLETE,this.onLoadThumbForCcComplete);
						ICharacter(behavior.getLoader()).CCM.updatePropInfo(UtilCommonLoader(this.prop.getLoader()).content.loaderInfo,this.prop.handStyle);
					}
					else
					{
						behavior.setProp(this.prop.getBundle());
					}
				}
				else
				{
					this.removeHandProp(behavior);
				}
				if(this.head != null)
				{
					behavior.setHead(this.head.getBundle(),this.raceCode);
				}
				else
				{
					behavior.removeHead();
				}
				if(this.wear != null)
				{
					behavior.setWear(this.wear.getBundle(),this.head);
				}
				else
				{
					behavior.removeWear();
				}
				return;
			}
			catch(e:Error)
			{
				UtilErrorLogger.getInstance().appendCustomError("Character:attachAllProps",e);
				return;
			}
		}
		
		private function onLoadThumbForCcComplete(param1:Event) : void
		{
			ICharacter(this.action.getLoader()).insertColor(this.customColor);
			ICharacter(this.action.getLoader()).addLibrary(AnimeConstants.CLASS_GOPROP,"","");
			ICharacter(this.action.getLoader()).reloadSkin();
		}
		
		override public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
		{
			if(this._state == Character.STATE_MOTION)
			{
				this.motion.goToAndPause(param1 - param4 + 1);
			}
			else if(this._state == Character.STATE_FADE)
			{
				this.action.goToAndPause(param1);
			}
			else if(this._state == Character.STATE_ACTION)
			{
				this.action.goToAndPause(param1);
			}
			if(this.assetView is IPlayback)
			{
				IPlayback(this.assetView).goToAndPause(param1,param2,param3,param4);
			}
		}
		
		override public function goToAndPauseReset() : void
		{
			if(this._state == Character.STATE_MOTION)
			{
				this.motion.goToAndPauseReset();
			}
			else if(this._state == Character.STATE_FADE)
			{
				this.action.goToAndPauseReset();
			}
			else if(this._state == Character.STATE_ACTION)
			{
				this.action.goToAndPauseReset();
			}
		}
		
		override public function pauseBundle() : void
		{
			var _loc1_:Behaviour = null;
			if(this._state == Character.STATE_MOTION)
			{
				this.motion.pause();
			}
			else if(this._state == Character.STATE_FADE)
			{
				this.action.pause();
			}
			else if(this._state == Character.STATE_ACTION)
			{
				this.action.pause();
			}
		}
		
		override public function resumeBundle() : void
		{
			this.action.resume();
		}
		
		override public function destroy(param1:Boolean = false) : void
		{
			if(this.action != null)
			{
				this.detachAllProps(this.action);
				this.action.destroy(param1);
			}
			if(this.motion != null)
			{
				this.detachAllProps(this.motion);
				this.motion.destroy(param1);
			}
			if(this.prop != null)
			{
				this.prop.destroy(param1);
			}
			if(this.wear != null)
			{
				this.wear.destroy(param1);
			}
			if(this.head != null)
			{
				this.head.destroy(param1);
			}
			if(param1)
			{
				this.action = null;
				this.motion = null;
				this.prop = null;
				this.wear = null;
				this.head = null;
			}
			this.resetTransition();
			this.disableLipSync();
		}
		
		public function speak(param1:Number) : void
		{
			if(param1 != this._currentPitch)
			{
				this._currentPitch = param1;
				if(this.head)
				{
					this.head.speak(param1);
				}
				else if(this.action)
				{
					this.action.speak(param1);
				}
			}
		}
		
		public function prepareImage() : void
		{
			try
			{
				if(this.head)
				{
					this.head.prepareImage();
				}
				if(this.action)
				{
					this.action.prepareImage();
				}
				if(this.prop)
				{
					this.prop.prepareImage();
				}
				if(this.wear)
				{
					this.wear.prepareImage();
				}
				this.enableLipSync();
				return;
			}
			catch(e:Error)
			{
				UtilErrorLogger.getInstance().appendCustomError("Character:prepareImage",e);
				UtilErrorLogger.getInstance().error("Character:prepareImage" + e);
				return;
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
			if(this._assetMotion && this.parentScene)
			{
				this._motionCache = new MotionCache(this._assetMotion,this.parentScene.totalFrame,this._motionStartFrame,this._motionEndFrame);
			}
		}
		
		public function get bodyScale() : Number
		{
			if(this.action)
			{
				return this.action.bodyScale;
			}
			return 1;
		}
		
		override public function get themeId() : String
		{
			if(this.action)
			{
				return this.action.themeId;
			}
			return null;
		}
		
		private function speechPitchEventHandler(param1:SpeechPitchEvent) : void
		{
			this.speak(param1.value);
		}
		
		public function addSpeechPitchSource(param1:AnimeSound) : void
		{
			var _loc2_:AnimeSound = null;
			if(this._speechOverlapped)
			{
				return;
			}
			if(param1 && this._speechPitchSourceArray.indexOf(param1) == -1)
			{
				this._speechPitchSourceArray.push(param1);
			}
			for each(_loc2_ in this._speechPitchSourceArray)
			{
				if(param1 != _loc2_ && this.checkSoundOverlap(param1,_loc2_))
				{
					this._speechOverlapped = true;
					this.removeAllSpeechPitchSource();
					break;
				}
			}
		}
		
		private function checkSoundOverlap(param1:AnimeSound, param2:AnimeSound) : Boolean
		{
			if(param1.getActualEndFrame() < param2.getStartFrame() || param1.getStartFrame() > param2.getActualEndFrame())
			{
				return false;
			}
			return true;
		}
		
		private function removeAllSpeechPitchSource() : void
		{
			this._speechPitchSourceArray.splice(0,this._speechPitchSourceArray.length);
		}
		
		public function enableLipSync() : void
		{
			var _loc1_:AnimeSound = null;
			for each(_loc1_ in this._speechPitchSourceArray)
			{
				if(_loc1_)
				{
					_loc1_.addEventListener(SpeechPitchEvent.PITCH,this.speechPitchEventHandler);
				}
			}
		}
		
		public function disableLipSync() : void
		{
			var _loc1_:AnimeSound = null;
			for each(_loc1_ in this._speechPitchSourceArray)
			{
				if(_loc1_)
				{
					_loc1_.removeEventListener(SpeechPitchEvent.PITCH,this.speechPitchEventHandler);
				}
			}
		}
	}
}
