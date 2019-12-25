package anifire.sound
{
	import anifire.constant.AnimeConstants;
	import anifire.event.NetStreamClientEvent;
	import anifire.event.VideoNetStreamEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.setTimeout;
	
	public class VideoNetStreamController extends EventDispatcher
	{
		
		private static const isDebug:Boolean = true;
		
		public static const CONNECT_STATE__NOT_CONNECT:int = 0;
		
		public static const CONNECT_STATE__CONNECTING:int = 1;
		
		public static const CONNECT_STATE__CONNECTED:int = 2;
		
		private static const PLAYHEAD_STATUS__NULL:int = 0;
		
		private static const PLAYHEAD_STATUS__PLAYING:int = 1;
		
		private static const PLAYHEAD_STATUS__PAUSED:int = 2;
		
		private static const TIME_TOLERANCE:Number = 0.1;
		 
		
		private const TIME_INTERVAL:Number = 100;
		
		private const MAX_TIME_INTERVAL:Number = 800;
		
		private var playHeadCommands:Array;
		
		private var _netConnetion:NetConnection;
		
		private var _netStream:NetStream = null;
		
		private var _netClient:NetStreamClient;
		
		private var _playHeadStatus:int = 0;
		
		private var _netConnectionStatus:int = 0;
		
		private var _url:String;
		
		private var _filename:String;
		
		private var _duration_in_second:Number = 0;
		
		private var _bufferLength:Number = 0;
		
		private var _soundTransform:SoundTransform;
		
		private var _volume:Number = 1;
		
		private var _position_snapshot_before_seek:Number;
		
		private var _seek_time_interval:Number;
		
		private var _assume_seek_time_ready:Boolean;
		
		private var _videoContainer:Sprite;
		
		private var _video:Video;
		
		private var _width:Number;
		
		private var _height:Number;
		
		public function VideoNetStreamController(param1:Number)
		{
			this.playHeadCommands = new Array();
			super();
			this._soundTransform = new SoundTransform(this._volume);
			this._duration_in_second = param1;
			this.addPlayHeadCommand(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_PAUSE,0));
			this.addEventListener(VideoNetStreamEvent.VIDEO_START_TO_PLAY,this.correctVideoScaling);
			this._video = new Video();
			this._videoContainer = new Sprite();
			this._videoContainer.addChild(this._video);
		}
		
		public function get url() : String
		{
			return this._url;
		}
		
		public function get width() : Number
		{
			return this._width;
		}
		
		public function get height() : Number
		{
			return this._height;
		}
		
		public function updateDimension(param1:Number, param2:Number) : void
		{
			this._width = param1;
			this._height = param2;
		}
		
		private function correctVideoScaling(param1:Event) : void
		{
			var _loc2_:Rectangle = this.getVideo().getBounds(this.getVideo());
			this.getVideo().scaleX = this.getVideo().scaleX * (this.width / _loc2_.width);
			this.getVideo().scaleY = this.getVideo().scaleY * (this.height / _loc2_.height);
		}
		
		public function getVideoContainer() : DisplayObject
		{
			return this._videoContainer;
		}
		
		private function getVideo() : Video
		{
			return this._video;
		}
		
		private function get playHeadStatus() : int
		{
			return this._playHeadStatus;
		}
		
		private function set playHeadStatus(param1:int) : void
		{
			this._playHeadStatus = param1;
		}
		
		public function get netConnectionStatus() : int
		{
			return this._netConnectionStatus;
		}
		
		public function set netConnectionStatus(param1:int) : void
		{
			this._netConnectionStatus = param1;
		}
		
		private function get netConnection() : NetConnection
		{
			return this._netConnetion;
		}
		
		private function set netConnection(param1:NetConnection) : void
		{
			this._netConnetion = param1;
		}
		
		public function get bytesLoaded() : uint
		{
			if(this.netStream != null)
			{
				return this.netStream.bytesLoaded;
			}
			return 0;
		}
		
		public function get bytesTotal() : uint
		{
			if(this.netStream != null)
			{
				return this.netStream.bytesTotal;
			}
			return 0;
		}
		
		private function get netStream() : NetStream
		{
			return this._netStream;
		}
		
		private function set netStream(param1:NetStream) : void
		{
			this._netStream = param1;
		}
		
		private function get netClient() : NetStreamClient
		{
			return this._netClient;
		}
		
		private function set netClient(param1:NetStreamClient) : void
		{
			this._netClient = param1;
		}
		
		public function get duration_in_second() : Number
		{
			return this._duration_in_second;
		}
		
		public function setVolume(param1:Number) : void
		{
			this._volume = param1;
			this._soundTransform.volume = this._volume;
			if(this.netStream != null)
			{
				this.netStream.soundTransform = this._soundTransform;
			}
		}
		
		public function flipVideo(param1:Boolean) : void
		{
			if(param1)
			{
				this.getVideo().scaleX = -1 * Math.abs(this.getVideo().scaleX);
				this.getVideo().x = this.width;
			}
			else
			{
				this.getVideo().scaleX = Math.abs(this.getVideo().scaleX);
				this.getVideo().x = 0;
			}
		}
		
		private function addPlayHeadCommand(param1:PlayHeadCommand#52) : void
		{
			var _loc4_:PlayHeadCommand = null;
			var _loc5_:PlayHeadCommand = null;
			var _loc2_:Boolean = false;
			if(this.netConnectionStatus == CONNECT_STATE__CONNECTED && this.playHeadCommands.length <= 0)
			{
				_loc2_ = true;
			}
			var _loc3_:PlayHeadCommand = new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_SEPERATOR,0);
			this.playHeadCommands.push(param1);
			this.playHeadCommands.push(_loc3_);
			if(param1.playHeadCommand == PlayHeadCommand#52.PLAYHEAD_COMMAND_SEEK)
			{
				_loc4_ = new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_SEPERATOR,0);
				_loc5_ = new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_SEPERATOR,0);
				if(this.playHeadStatus == PLAYHEAD_STATUS__PAUSED)
				{
					this.playHeadCommands.push(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_RESUME));
					this.playHeadCommands.push(_loc4_);
					this.playHeadCommands.push(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_PAUSE));
					this.playHeadCommands.push(_loc5_);
				}
				else if(this.playHeadStatus == PLAYHEAD_STATUS__PLAYING)
				{
					this.playHeadCommands.push(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_PAUSE));
					this.playHeadCommands.push(_loc4_);
					this.playHeadCommands.push(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_RESUME));
					this.playHeadCommands.push(_loc5_);
				}
			}
			if(_loc2_)
			{
				this.execPlayHeadCommand();
			}
		}
		
		private function optimizePlayHeadCommand() : void
		{
			var _loc1_:int = 0;
			var _loc2_:PlayHeadCommand = null;
			var _loc3_:PlayHeadCommand = null;
			var _loc4_:PlayHeadCommand = null;
			_loc1_ = 0;
			while(_loc1_ < this.playHeadCommands.length)
			{
				_loc2_ = this.playHeadCommands[_loc1_] as PlayHeadCommand#52;
				if(_loc2_.playHeadCommand == PlayHeadCommand#52.PLAYHEAD_COMMAND_PAUSE || _loc2_.playHeadCommand == PlayHeadCommand#52.PLAYHEAD_COMMAND_RESUME)
				{
					_loc3_ = _loc2_;
				}
				else if(_loc2_.playHeadCommand == PlayHeadCommand#52.PLAYHEAD_COMMAND_SEEK)
				{
					_loc4_ = _loc2_;
				}
				_loc1_++;
			}
			this.playHeadCommands.splice(0,this.playHeadCommands.length);
			if(_loc4_ != null)
			{
				this.playHeadCommands.push(_loc4_);
				this.playHeadCommands.push(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_SEPERATOR,0));
			}
			if(_loc3_ != null)
			{
				this.playHeadCommands.push(_loc3_);
				this.playHeadCommands.push(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_SEPERATOR,0));
			}
		}
		
		private function execPlayHeadCommand() : void
		{
			var _loc1_:PlayHeadCommand = null;
			var _loc2_:Number = NaN;
			this.optimizePlayHeadCommand();
			if(this.playHeadCommands.length > 0)
			{
				_loc1_ = this.playHeadCommands.shift() as PlayHeadCommand#52;
				if(_loc1_.playHeadCommand == PlayHeadCommand#52.PLAYHEAD_COMMAND_PAUSE)
				{
					this.netStream.pause();
				}
				else if(_loc1_.playHeadCommand == PlayHeadCommand#52.PLAYHEAD_COMMAND_RESUME)
				{
					this.netStream.resume();
				}
				else if(_loc1_.playHeadCommand == PlayHeadCommand#52.PLAYHEAD_COMMAND_SEEK)
				{
					_loc2_ = _loc1_.time_in_second - TIME_TOLERANCE;
					if(_loc2_ <= 0)
					{
						_loc2_ = 0;
					}
					if(Math.abs(_loc2_ - this.netStream.time) < TIME_TOLERANCE)
					{
						this._seek_time_interval = this.MAX_TIME_INTERVAL;
						this._assume_seek_time_ready = true;
					}
					else
					{
						this._seek_time_interval = this.TIME_INTERVAL;
						this._assume_seek_time_ready = false;
					}
					this._position_snapshot_before_seek = this.netStream.time;
					this.netStream.seek(_loc2_);
				}
				setTimeout(this.proceedToNextCommand,200);
			}
		}
		
		private function doExecOnPauseReady(param1:NetStatusEvent) : void
		{
			var _loc2_:String = param1.info.code as String;
			if(_loc2_ == "NetStream.Pause.Notify" || _loc2_ == "NetStream.Buffer.Flush")
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doExecOnPauseReady);
				this.proceedToNextCommand();
			}
		}
		
		private function doExecOnSeekReady(param1:NetStatusEvent) : void
		{
			var _loc2_:String = param1.info.code as String;
			if(_loc2_ == "NetStream.Seek.Notify" || _loc2_ == "NetStream.Buffer.Flush")
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doExecOnSeekReady);
				setTimeout(this.onPositionReadyAfterSeek,this._seek_time_interval,this._position_snapshot_before_seek);
			}
		}
		
		private function onPositionReadyAfterSeek(param1:Number) : void
		{
			if(!this._assume_seek_time_ready && param1 == this.netStream.time)
			{
				setTimeout(this.onPositionReadyAfterSeek,this._seek_time_interval,param1);
			}
			else
			{
				this.proceedToNextCommand();
			}
		}
		
		private function doExecOnResumeReady(param1:NetStatusEvent) : void
		{
			var _loc2_:String = param1.info.code as String;
			if(_loc2_ == "NetStream.Unpause.Notify" || _loc2_ == "NetStream.Play.Start")
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doExecOnResumeReady);
				this.proceedToNextCommand();
			}
		}
		
		private function proceedToNextCommand() : void
		{
			this.playHeadCommands.shift();
			this.execPlayHeadCommand();
		}
		
		public function get position() : Number
		{
			if(this.netConnectionStatus == CONNECT_STATE__CONNECTED)
			{
				return this.netStream.time;
			}
			return 0;
		}
		
		public function get bufferLength() : Number
		{
			if(this.netConnectionStatus == CONNECT_STATE__CONNECTED)
			{
				return this.netStream.bufferLength;
			}
			return 0;
		}
		
		public function resume() : void
		{
			if(this.netConnectionStatus == CONNECT_STATE__CONNECTED)
			{
				this.addPlayHeadCommand(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_RESUME));
			}
			this.playHeadStatus = PLAYHEAD_STATUS__PLAYING;
		}
		
		public function pause() : void
		{
			if(this.netConnectionStatus == CONNECT_STATE__CONNECTED)
			{
				this.addPlayHeadCommand(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_PAUSE));
			}
			this.playHeadStatus = PLAYHEAD_STATUS__PAUSED;
		}
		
		public function seek(param1:Number) : void
		{
			var _loc2_:Number = NaN;
			if(this.netConnectionStatus == CONNECT_STATE__CONNECTED)
			{
				_loc2_ = 0.2;
				this.addPlayHeadCommand(new PlayHeadCommand#52(PlayHeadCommand#52.PLAYHEAD_COMMAND_SEEK,param1));
			}
		}
		
		public function load(param1:String) : void
		{
			if(this.netConnectionStatus == CONNECT_STATE__NOT_CONNECT)
			{
				this.netConnectionStatus = CONNECT_STATE__CONNECTING;
				this._url = param1;
				this.netConnection = new NetConnection();
				this.netConnection.addEventListener(NetStatusEvent.NET_STATUS,this.doStartLoadNetstream);
				this.netConnection.connect(null);
				if(isDebug)
				{
					this.netConnection.addEventListener(NetStatusEvent.NET_STATUS,this.doTraceNetstatus);
				}
			}
		}
		
		public function close() : void
		{
		}
		
		private function doStartLoadNetstream(param1:NetStatusEvent) : void
		{
			if(param1.info.code == "NetConnection.Connect.Success")
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doStartLoadNetstream);
				this.netStream = new NetStream(this.netConnection);
				this.netStream.bufferTime = AnimeConstants.MIN_TIME_TO_BUFFER;
				if(isDebug)
				{
					this.netStream.addEventListener(NetStatusEvent.NET_STATUS,this.doTraceNetstatus);
				}
				this.netStream.addEventListener(NetStatusEvent.NET_STATUS,this.doInitializePlayHead);
				this.netClient = new NetStreamClient();
				this.netClient.addEventListener(NetStreamClientEvent.PLAY_STATUS_READY,this.doSayPlayComplete);
				this.netClient.addEventListener(NetStreamClientEvent.META_DATA_READY,this.doUpdateDuration);
				this.netStream.client = this.netClient;
				this.netStream.bufferTime = AnimeConstants.MIN_TIME_TO_BUFFER / 1000;
				this.netStream.soundTransform = this._soundTransform;
				this.netStream.checkPolicyFile = true;
				this.netStream.play(this._url);
				this.getVideo().attachNetStream(this.netStream);
			}
		}
		
		private function doInitializePlayHead(param1:NetStatusEvent) : void
		{
			if(param1.info.code == "NetStream.Play.Start")
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doInitializePlayHead);
				this.netConnectionStatus = CONNECT_STATE__CONNECTED;
				this.execPlayHeadCommand();
				this.doDetectWhenVideoStartPlay();
			}
		}
		
		private function doDetectWhenVideoStartPlay() : void
		{
			if(this.getVideo().videoHeight > 0 || this.getVideo().videoWidth > 0)
			{
				this.dispatchEvent(new VideoNetStreamEvent(VideoNetStreamEvent.VIDEO_START_TO_PLAY,this));
			}
			else
			{
				setTimeout(this.doDetectWhenVideoStartPlay,AnimeConstants.FRAME_PER_SEC);
			}
		}
		
		private function doSayPlayComplete(param1:NetStreamClientEvent) : void
		{
			if(param1.infoObject.code == "NetStream.Play.Complete")
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doSayPlayComplete);
				this.dispatchEvent(new Event(Event.SOUND_COMPLETE));
			}
		}
		
		private function doUpdateDuration(param1:NetStreamClientEvent) : void
		{
			if(param1.infoObject.duration != null)
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doUpdateDuration);
				this._duration_in_second = Number(param1.infoObject.duration);
			}
		}
		
		private function doTraceNetstatus(param1:NetStatusEvent) : void
		{
			this.traceInfo("net status event trigger: ",param1.info);
		}
		
		private function traceInfo(param1:String, param2:Object) : void
		{
			var _loc3_:* = null;
			for(_loc3_ in param2)
			{
			}
		}
	}
}

class PlayHeadCommand#52
{
	
	public static const PLAYHEAD_COMMAND_SEPERATOR:int = 0;
	
	public static const PLAYHEAD_COMMAND_RESUME:int = 1;
	
	public static const PLAYHEAD_COMMAND_PAUSE:int = 2;
	
	public static const PLAYHEAD_COMMAND_SEEK:int = 3;
	 
	
	public var playHeadCommand:int;
	
	public var time_in_second:Number;
	
	function PlayHeadCommand#52(param1:int, param2:Number = 0)
	{
		super();
		this.playHeadCommand = param1;
		this.time_in_second = param2;
	}
}
