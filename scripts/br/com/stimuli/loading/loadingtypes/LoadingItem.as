package br.com.stimuli.loading.loadingtypes
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.utils.SmartURL;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	public class LoadingItem extends EventDispatcher
	{
		
		public static const STATUS_STOPPED:String = "stopped";
		
		public static const STATUS_STARTED:String = "started";
		
		public static const STATUS_FINISHED:String = "finished";
		
		public static const STATUS_ERROR:String = "error";
		 
		
		public var _type:String;
		
		public var url:URLRequest;
		
		public var _id:String;
		
		public var _uid:String;
		
		public var _additionIndex:int;
		
		public var _priority:int = 0;
		
		public var _isLoaded:Boolean;
		
		public var _isLoading:Boolean;
		
		public var status:String;
		
		public var maxTries:int = 3;
		
		public var numTries:int = 0;
		
		public var weight:int = 1;
		
		public var preventCache:Boolean;
		
		public var _bytesTotal:int = -1;
		
		public var _bytesLoaded:int = 0;
		
		public var _bytesRemaining:int = 10000000;
		
		public var _percentLoaded:Number;
		
		public var _weightPercentLoaded:Number;
		
		public var _addedTime:int;
		
		public var _startTime:int;
		
		public var _responseTime:Number;
		
		public var _latency:Number;
		
		public var _totalTime:int;
		
		public var _timeToDownload:Number;
		
		public var _speed:Number;
		
		public var _content;
		
		public var _httpStatus:int = -1;
		
		public var _context = null;
		
		public var _parsedURL:SmartURL;
		
		public var specificAvailableProps:Array;
		
		public var propertyParsingErrors:Array;
		
		public var errorEvent:ErrorEvent;
		
		public function LoadingItem(param1:URLRequest, param2:String, param3:String)
		{
			super();
			this._type = param2;
			this.url = param1;
			this._parsedURL = new SmartURL(param1.url);
			if(!this.specificAvailableProps)
			{
				this.specificAvailableProps = [];
			}
			this._uid = param3;
		}
		
		public function _parseOptions(param1:Object) : Array
		{
			var _loc3_:* = null;
			this.preventCache = param1[BulkLoader.PREVENT_CACHING];
			this._id = param1[BulkLoader.ID];
			this._priority = int(int(param1[BulkLoader.PRIORITY])) || 0;
			this.maxTries = int(param1[BulkLoader.MAX_TRIES]) || 3;
			this.weight = int(int(param1[BulkLoader.WEIGHT])) || 1;
			var _loc2_:Array = BulkLoader.GENERAL_AVAILABLE_PROPS.concat(this.specificAvailableProps);
			this.propertyParsingErrors = [];
			for(_loc3_ in param1)
			{
				if(_loc2_.indexOf(_loc3_) == -1)
				{
					this.propertyParsingErrors.push(this + ": got a wrong property name: " + _loc3_ + ", with value:" + param1[_loc3_]);
				}
			}
			return this.propertyParsingErrors;
		}
		
		public function get content() : *
		{
			return this._content;
		}
		
		public function load() : void
		{
			var _loc1_:String = null;
			if(this.preventCache)
			{
				_loc1_ = "BulkLoaderNoCache=" + this._uid + "_" + int(Math.random() * 100 * getTimer());
				if(this.url.url.indexOf("?") == -1)
				{
					this.url.url = this.url.url + ("?" + _loc1_);
				}
				else
				{
					this.url.url = this.url.url + ("&" + _loc1_);
				}
			}
			this._isLoading = true;
			this._startTime = getTimer();
		}
		
		public function onHttpStatusHandler(param1:HTTPStatusEvent) : void
		{
			this._httpStatus = param1.status;
			dispatchEvent(param1);
		}
		
		public function onProgressHandler(param1:*) : void
		{
			this._bytesLoaded = param1.bytesLoaded;
			this._bytesTotal = param1.bytesTotal;
			this._bytesRemaining = this._bytesTotal - this.bytesLoaded;
			this._percentLoaded = this._bytesLoaded / this._bytesTotal;
			this._weightPercentLoaded = this._percentLoaded * this.weight;
			dispatchEvent(param1);
		}
		
		public function onCompleteHandler(param1:Event) : void
		{
			this._totalTime = getTimer();
			this._timeToDownload = (this._totalTime - this._responseTime) / 1000;
			if(this._timeToDownload == 0)
			{
				this._timeToDownload = 0.1;
			}
			this._speed = BulkLoader.truncateNumber(this.bytesTotal / 1024 / this._timeToDownload);
			this.status = STATUS_FINISHED;
			this._isLoaded = true;
			dispatchEvent(param1);
			param1.stopPropagation();
		}
		
		public function onErrorHandler(param1:ErrorEvent) : void
		{
			this.numTries++;
			param1.stopPropagation();
			if(this.numTries < this.maxTries)
			{
				this.status = null;
				this.load();
			}
			else
			{
				this.status = STATUS_ERROR;
				this.errorEvent = param1;
				this._dispatchErrorEvent(this.errorEvent);
			}
		}
		
		public function _dispatchErrorEvent(param1:ErrorEvent) : void
		{
			this.status = STATUS_ERROR;
			dispatchEvent(new ErrorEvent(BulkLoader.ERROR,true,false,param1.text));
		}
		
		public function _createErrorEvent(param1:Error) : ErrorEvent
		{
			return new ErrorEvent(BulkLoader.ERROR,false,false,param1.message);
		}
		
		public function onSecurityErrorHandler(param1:ErrorEvent) : void
		{
			this.status = STATUS_ERROR;
			this.errorEvent = param1 as ErrorEvent;
			param1.stopPropagation();
			this._dispatchErrorEvent(this.errorEvent);
		}
		
		public function onStartedHandler(param1:Event) : void
		{
			this._responseTime = getTimer();
			this._latency = BulkLoader.truncateNumber((this._responseTime - this._startTime) / 1000);
			this.status = STATUS_STARTED;
			dispatchEvent(param1);
		}
		
		override public function toString() : String
		{
			return "LoadingItem url: " + this.url.url + ", type:" + this._type + ", status: " + this.status;
		}
		
		public function stop() : void
		{
			if(this._isLoaded)
			{
				return;
			}
			this.status = STATUS_STOPPED;
			this._isLoading = false;
		}
		
		public function cleanListeners() : void
		{
		}
		
		public function isVideo() : Boolean
		{
			return false;
		}
		
		public function isSound() : Boolean
		{
			return false;
		}
		
		public function isText() : Boolean
		{
			return false;
		}
		
		public function isXML() : Boolean
		{
			return false;
		}
		
		public function isImage() : Boolean
		{
			return false;
		}
		
		public function isSWF() : Boolean
		{
			return false;
		}
		
		public function isLoader() : Boolean
		{
			return false;
		}
		
		public function isStreamable() : Boolean
		{
			return false;
		}
		
		public function destroy() : void
		{
			this._content = null;
		}
		
		public function get bytesTotal() : int
		{
			return this._bytesTotal;
		}
		
		public function get bytesLoaded() : int
		{
			return this._bytesLoaded;
		}
		
		public function get bytesRemaining() : int
		{
			return this._bytesRemaining;
		}
		
		public function get percentLoaded() : Number
		{
			return this._percentLoaded;
		}
		
		public function get weightPercentLoaded() : Number
		{
			return this._weightPercentLoaded;
		}
		
		public function get priority() : int
		{
			return this._priority;
		}
		
		public function get type() : String
		{
			return this._type;
		}
		
		public function get isLoaded() : Boolean
		{
			return this._isLoaded;
		}
		
		public function get addedTime() : int
		{
			return this._addedTime;
		}
		
		public function get startTime() : int
		{
			return this._startTime;
		}
		
		public function get responseTime() : Number
		{
			return this._responseTime;
		}
		
		public function get latency() : Number
		{
			return this._latency;
		}
		
		public function get totalTime() : int
		{
			return this._totalTime;
		}
		
		public function get timeToDownload() : int
		{
			return this._timeToDownload;
		}
		
		public function get speed() : Number
		{
			return this._speed;
		}
		
		public function get httpStatus() : int
		{
			return this._httpStatus;
		}
		
		public function get id() : String
		{
			return this._id;
		}
		
		public function get hostName() : String
		{
			return this._parsedURL.host;
		}
		
		public function get humanFiriendlySize() : String
		{
			var _loc1_:Number = this._bytesTotal / 1024;
			if(_loc1_ < 1024)
			{
				return int(_loc1_) + " kb";
			}
			return (_loc1_ / 1024).toPrecision(3) + " mb";
		}
		
		public function getStats() : String
		{
			return "Item url: " + this.url.url + "(s), total time: " + (this._totalTime / 1000).toPrecision(3) + "(s), download time: " + this._timeToDownload.toPrecision(3) + "(s), latency:" + this._latency + "(s), speed: " + this._speed + " kb/s, size: " + this.humanFiriendlySize;
		}
	}
}
