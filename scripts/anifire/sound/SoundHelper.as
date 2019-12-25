package anifire.sound
{
	import anifire.event.AVM2SoundEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	
	public class SoundHelper
	{
		
		private static var _timer:Timer = null;
		
		private static var _bufferExhaustItems:Array = null;
		 
		
		public function SoundHelper()
		{
			super();
		}
		
		private static function initializeIfNeed() : void
		{
			if(_timer == null)
			{
				_timer = new Timer(500);
			}
		}
		
		private static function startTimerIfNeed() : void
		{
			if(!_timer.running)
			{
				_timer.stop();
				_timer.reset();
				if(_timer.hasEventListener(TimerEvent.TIMER))
				{
					_timer.removeEventListener(TimerEvent.TIMER,onTimer);
				}
				_timer.addEventListener(TimerEvent.TIMER,onTimer);
				_timer.start();
			}
		}
		
		private static function stopTimerIfNeed() : void
		{
			if(_timer.hasEventListener(TimerEvent.TIMER))
			{
				_timer.removeEventListener(TimerEvent.TIMER,onTimer);
				_timer.stop();
				_timer.reset();
			}
		}
		
		public static function addBufferExhaustEventListenerToSoundChannel(param1:SoundChannel, param2:Sound, param3:Number, param4:Number, param5:Function) : void
		{
			initializeIfNeed();
			startTimerIfNeed();
			var _loc6_:BufferExhaustItem = new BufferExhaustItem(param2,param1,param3,param4);
			if(_bufferExhaustItems == null)
			{
				_bufferExhaustItems = new Array(0);
			}
			_bufferExhaustItems.push(_loc6_);
			_timer.addEventListener(TimerEvent.TIMER,_loc6_.onTimerListener);
			if(param5 != null)
			{
				_loc6_.soundChannel.addEventListener(AVM2SoundEvent.BUFFER_EXHAUST,param5);
			}
		}
		
		public static function isSoundBufferReadyAtTime(param1:Sound, param2:Number, param3:Boolean) : Boolean
		{
			if(param3)
			{
				return true;
			}
			if(param1.bytesTotal > 0 && param1.bytesLoaded >= param1.bytesTotal)
			{
				return true;
			}
			if(param1.length >= param2 + 2000)
			{
				return true;
			}
			return false;
		}
		
		public static function isStreamSoundBufferReadyAtTime(param1:NetStreamController, param2:Number) : Boolean
		{
			var _loc3_:Number = param2 / 1000;
			var _loc4_:Number = 0.2;
			if(param1.duration_in_second <= 0)
			{
				return false;
			}
			_loc3_ = _loc3_ % param1.duration_in_second;
			if(_loc3_ >= param1.duration_in_second - _loc4_)
			{
				return true;
			}
			if(param1.bufferLength == 0)
			{
				return false;
			}
			if(_loc3_ >= param1.position && _loc3_ < param1.position + param1.bufferLength + _loc4_)
			{
				return true;
			}
			if(_loc3_ < 0)
			{
				return true;
			}
			return false;
		}
		
		public static function isVideoBufferReadyAtTime(param1:VideoNetStreamController, param2:Number) : Boolean
		{
			var _loc3_:Number = 0.2;
			if(param1.url != null && param1.url.search("1177843.flv") >= 0)
			{
				if(param1.bytesLoaded > 2501000)
				{
					return true;
				}
				return false;
			}
			var _loc4_:Number = param2 / 1000;
			if(param1.duration_in_second > 0)
			{
				_loc4_ = _loc4_ % param1.duration_in_second;
			}
			if(param1.duration_in_second <= 0)
			{
				return false;
			}
			if(param1.bytesLoaded >= param1.bytesTotal && param1.bytesTotal > 0)
			{
				return true;
			}
			if(param1.bytesLoaded <= 0 || param1.bytesTotal <= 0)
			{
				return false;
			}
			if(_loc4_ >= param1.position && _loc4_ < param1.position + param1.bufferLength - _loc3_)
			{
				return true;
			}
			return false;
		}
		
		private static function onTimer(param1:Event) : void
		{
		}
	}
}

import anifire.event.AVM2SoundEvent;
import anifire.sound.SoundHelper;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.media.Sound;
import flash.media.SoundChannel;

class BufferExhaustItem
{
	 
	
	public var sound:Sound;
	
	public var soundChannel:SoundChannel;
	
	public var startTime:Number;
	
	public var endTime:Number;
	
	public var isSoundCompletelyDownloaded:Boolean;
	
	function BufferExhaustItem(param1:Sound, param2:SoundChannel, param3:Number, param4:Number)
	{
		super();
		this.isSoundCompletelyDownloaded = false;
		this.sound = param1;
		this.sound.addEventListener(Event.COMPLETE,this.onSoundCompletelyDownloaded);
		this.soundChannel = param2;
		this.startTime = param3;
		this.endTime = param4;
	}
	
	private function onSoundCompletelyDownloaded(param1:Event) : void
	{
		(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onSoundCompletelyDownloaded);
		this.isSoundCompletelyDownloaded = true;
	}
	
	public function onTimerListener(param1:TimerEvent) : void
	{
		if(SoundHelper.isSoundBufferReadyAtTime(this.sound,this.endTime - this.startTime,this.isSoundCompletelyDownloaded))
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onTimerListener);
			return;
		}
		if(SoundHelper.isSoundBufferReadyAtTime(this.sound,this.soundChannel.position,this.isSoundCompletelyDownloaded))
		{
			return;
		}
		this.soundChannel.dispatchEvent(new AVM2SoundEvent(AVM2SoundEvent.BUFFER_EXHAUST,this.soundChannel));
	}
}
