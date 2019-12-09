package anifire.player.playback
{
   import anifire.util.UtilUnitConvert;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.media.SoundTransform;
   
   public class AssetSound extends EventDispatcher
   {
       
      
      private var _numOfPendingJobs:int = 0;
      
      private var _anime:Anime = null;
      
      private var saveSoundArr:Array;
      
      private var savedScene:Array = null;
      
      private var _numOfAssets:int;
      
      public function AssetSound(param1:Anime)
      {
         super();
         if(this._anime == null)
         {
            this._anime = param1;
         }
      }
      
      public function playSound() : void
      {
         var _loc2_:Asset = null;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:AnimeScene = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc1_:int = 0;
         while(_loc1_ < this.saveSoundArr.length)
         {
            _loc2_ = this.saveSoundArr[_loc1_].targetAsset as Asset;
            _loc3_ = this.saveSoundArr[_loc1_].setVolumeOnly as Boolean;
            _loc4_ = this.saveSoundArr[_loc1_].curFrame as Number;
            _loc5_ = _loc2_.parentScene;
            _loc6_ = this.saveSoundArr[_loc1_].startFlag as String;
            if(_loc5_ == null)
            {
               _loc5_ = this.saveSoundArr[_loc1_].targetAssetScene;
            }
            if(_loc2_.sound != null)
            {
               if(_loc3_)
               {
                  _loc2_.soundChannel.soundTransform = new SoundTransform(this._anime.volume);
                  break;
               }
               if(_loc2_ is Character && _loc6_ == "motion")
               {
                  _loc7_ = _loc4_ - _loc5_.startFrame + (_loc2_ as Character).action.getLocalEndFrame() - (_loc2_ as Character).action.getLocalStartFrame() + 1;
               }
               else
               {
                  _loc7_ = _loc4_ - _loc5_.startFrame;
               }
               _loc8_ = UtilUnitConvert.frameToSec(_loc7_,true);
               _loc9_ = _loc2_.sound.length / 1000;
               if(_loc8_ <= _loc9_)
               {
                  _loc2_.playMusic(_loc8_ * 1000,0,new SoundTransform(this._anime.volume));
               }
               else if(_loc8_ > _loc9_)
               {
                  _loc2_.playMusic(_loc8_ % _loc9_ * 1000,0,new SoundTransform(this._anime.volume));
               }
            }
            _loc1_++;
         }
      }
      
      public function saveSoundEvent(param1:Asset, param2:Number, param3:String = "", param4:AnimeScene = null, param5:Boolean = false) : void
      {
         this.saveSoundArr.push({
            "targetAsset":param1,
            "curFrame":param2,
            "startFlag":param3,
            "targetAssetScene":param4
         });
         if(this._numOfAssets == this.saveSoundArr.length || param5)
         {
            this.dispatchEvent(new Event("AssetSoundRdy"));
            this.playSound();
            this.clearAllData();
         }
      }
      
      private function BufferCompleteHandler(param1:Event) : void
      {
         if((param1.currentTarget as AnimeScene).hasEventListener("init_remote_data_complete"))
         {
            (param1.currentTarget as AnimeScene).removeEventListener("init_remote_data_complete",this.BufferCompleteHandler);
         }
         var _loc2_:AnimeScene = param1.currentTarget as AnimeScene;
         var _loc3_:Object = _loc2_.extraData;
         var _loc4_:Asset = _loc3_.targetAsset;
         var _loc5_:Boolean = _loc3_.setVolumeOnly;
         var _loc6_:Number = _loc3_.curFrame;
         var _loc7_:String = _loc3_.startFlag;
         if(_loc7_ == null || _loc7_ == "")
         {
            _loc7_ = "";
         }
         this.saveSoundEvent(_loc4_,_loc6_,_loc7_,_loc2_,true);
      }
      
      private function clearAllData() : void
      {
         var _loc1_:int = 0;
         if(this.savedScene != null)
         {
            if(this.savedScene.length != 0)
            {
            }
            _loc1_ = 0;
            while(_loc1_ < this.savedScene.length)
            {
               if((this.savedScene[_loc1_] as AnimeScene).hasEventListener("init_remote_data_complete"))
               {
                  (this.savedScene[_loc1_] as AnimeScene).removeEventListener("init_remote_data_complete",this.BufferCompleteHandler);
               }
               _loc1_++;
            }
         }
         this._numOfPendingJobs = 0;
         this.saveSoundArr = new Array();
         this.savedScene = new Array();
         this._numOfAssets = 0;
      }
      
      public function setSceneVolume(param1:Number, param2:AnimeScene, param3:Number) : void
      {
         var _loc6_:String = null;
         var _loc7_:AnimeScene = null;
         var _loc8_:Character = null;
         var _loc12_:int = 0;
         var _loc13_:Behaviour = null;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Asset = null;
         _loc4_ = 0;
         while(_loc4_ < param2.getNumEffect())
         {
            _loc5_ = param2.getEffectByIndex(_loc4_);
            _loc6_ = _loc5_.id;
            if(_loc5_.sound != null)
            {
               _loc7_ = param2.prevScene;
               while(_loc7_ != null && _loc7_.getEffectById(_loc6_) != null)
               {
                  _loc5_ = _loc7_.getEffectById(_loc6_);
                  _loc7_ = _loc7_.prevScene;
               }
               if(_loc5_.soundChannel != null)
               {
                  _loc5_.soundChannel.soundTransform = new SoundTransform(param3);
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param2.getNumBg())
         {
            _loc5_ = param2.getBgByIndex(_loc4_);
            _loc6_ = _loc5_.id;
            if(_loc5_.sound != null)
            {
               _loc7_ = param2.prevScene;
               while(_loc7_ != null && _loc7_.getBgByID(_loc6_) != null)
               {
                  _loc5_ = _loc7_.getBgByID(_loc6_);
                  _loc7_ = _loc7_.prevScene;
               }
               if(_loc5_.soundChannel != null)
               {
                  _loc5_.soundChannel.soundTransform = new SoundTransform(param3);
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param2.getNumProp())
         {
            _loc5_ = param2.getPropByIndex(_loc4_);
            _loc6_ = _loc5_.id;
            if(_loc5_.sound != null)
            {
               _loc7_ = param2.prevScene;
               while(_loc7_ != null && _loc7_.getPropById(_loc6_) != null)
               {
                  _loc5_ = _loc7_.getPropById(_loc6_);
                  _loc7_ = _loc7_.prevScene;
               }
               if(_loc5_.soundChannel != null)
               {
                  _loc5_.soundChannel.soundTransform = new SoundTransform(param3);
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param2.getNumChar())
         {
            _loc5_ = param2.getCharByIndex(_loc4_);
            _loc8_ = _loc5_ as Character;
            if(_loc8_.sound != null)
            {
               _loc12_ = _loc8_.state;
               if(_loc12_ == 1)
               {
                  _loc13_ = _loc8_.action;
               }
               else if(_loc12_ == 2)
               {
                  _loc13_ = _loc8_.motion;
               }
               else if(param1 > param2.startFrame + _loc8_.action.getLocalEndFrame() - _loc8_.action.getLocalStartFrame() + 1 && _loc8_.motion != null)
               {
                  _loc13_ = _loc8_.motion;
                  if(_loc12_.toString() == "1")
                  {
                  }
               }
               else
               {
                  _loc13_ = _loc8_.action;
                  if(_loc12_.toString() == "2" || _loc12_.toString() == "3")
                  {
                  }
               }
               while(!_loc13_.isFirstBehavior)
               {
                  _loc13_ = _loc13_.prevBehavior;
               }
               if(_loc13_.myChar.soundChannel != null)
               {
                  _loc13_.myChar.soundChannel.soundTransform = new SoundTransform(param3);
               }
            }
            _loc4_++;
         }
         var _loc9_:Prop = null;
         var _loc10_:Prop = null;
         var _loc11_:Prop = null;
         _loc4_ = 0;
         while(_loc4_ < param2.getNumChar())
         {
            _loc5_ = param2.getCharByIndex(_loc4_);
            _loc14_ = _loc5_.id;
            _loc8_ = _loc5_ as Character;
            if(_loc8_.prop != null || _loc8_.head != null || _loc8_.wear != null)
            {
               _loc9_ = _loc8_.prop;
               _loc10_ = _loc8_.head;
               _loc11_ = _loc8_.wear;
               _loc7_ = param2.prevScene;
               while(_loc7_ != null && _loc7_.getCharByID(_loc14_) != null)
               {
                  _loc15_ = _loc7_.getCharByID(_loc14_).prop != null && _loc9_ != null && _loc7_.getCharByID(_loc14_).prop.file == _loc9_.file;
                  _loc16_ = _loc7_.getCharByID(_loc14_).head != null && _loc10_ != null && _loc7_.getCharByID(_loc14_).head.file == _loc10_.file;
                  _loc17_ = _loc7_.getCharByID(_loc14_).wear != null && _loc11_ != null && _loc7_.getCharByID(_loc14_).wear.file == _loc11_.file;
                  if(_loc15_ || _loc16_ || _loc17_)
                  {
                     if(_loc15_)
                     {
                        _loc9_ = _loc7_.getCharByID(_loc14_).prop;
                     }
                     if(_loc16_)
                     {
                        _loc10_ = _loc7_.getCharByID(_loc14_).head;
                     }
                     if(_loc17_)
                     {
                        _loc11_ = _loc7_.getCharByID(_loc14_).wear;
                     }
                     _loc7_ = _loc7_.prevScene;
                     continue;
                  }
                  break;
               }
               if(_loc9_ != null && _loc9_.soundChannel != null)
               {
                  _loc9_.soundChannel.soundTransform = new SoundTransform(param3);
               }
               if(_loc10_ != null && _loc10_.soundChannel != null)
               {
                  _loc10_.soundChannel.soundTransform = new SoundTransform(param3);
               }
               if(_loc11_ != null && _loc11_.soundChannel != null)
               {
                  _loc11_.soundChannel.soundTransform = new SoundTransform(param3);
               }
            }
            _loc4_++;
         }
      }
      
      public function getSceneToStop(param1:AnimeScene, param2:Number) : void
      {
         var _loc6_:Character = null;
         var _loc7_:AnimeScene = null;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:int = 0;
         var _loc17_:Behaviour = null;
         this.clearAllData();
         var _loc3_:int = 0;
         var _loc4_:Asset = null;
         var _loc5_:String = null;
         _loc3_ = 0;
         while(_loc3_ < param1.getNumEffect())
         {
            _loc4_ = param1.getEffectByIndex(_loc3_);
            _loc5_ = _loc4_.id;
            _loc7_ = param1.prevScene;
            while(_loc7_ != null && _loc7_.getEffectById(_loc5_) != null)
            {
               _loc4_ = _loc7_.getEffectById(_loc5_);
               _loc7_ = _loc7_.prevScene;
            }
            _loc4_.stopMusic();
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.getNumBg())
         {
            _loc4_ = param1.getBgByIndex(_loc3_);
            _loc5_ = _loc4_.id;
            if(_loc4_.sound != null)
            {
               _loc7_ = param1.prevScene;
               while(_loc7_ != null && _loc7_.getBgByID(_loc5_) != null)
               {
                  _loc4_ = _loc7_.getBgByID(_loc5_);
                  _loc7_ = _loc7_.prevScene;
               }
               _loc4_.stopMusic();
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.getNumProp())
         {
            _loc4_ = param1.getPropByIndex(_loc3_);
            _loc5_ = _loc4_.id;
            if(_loc4_.sound != null)
            {
               _loc7_ = param1.prevScene;
               while(_loc7_ != null && _loc7_.getPropById(_loc5_) != null)
               {
                  _loc4_ = _loc7_.getPropById(_loc5_);
                  _loc7_ = _loc7_.prevScene;
               }
               _loc4_.stopMusic();
            }
            _loc3_++;
         }
         var _loc8_:AnimeScene = param1;
         var _loc9_:Prop = null;
         var _loc10_:Prop = null;
         var _loc11_:Prop = null;
         _loc3_ = 0;
         while(_loc3_ < param1.getNumChar())
         {
            _loc4_ = param1.getCharByIndex(_loc3_);
            _loc5_ = _loc4_.id;
            _loc6_ = _loc4_ as Character;
            if(_loc6_.prop != null || _loc6_.head != null || _loc6_.wear != null)
            {
               _loc9_ = _loc6_.prop;
               _loc10_ = _loc6_.head;
               _loc11_ = _loc6_.wear;
               _loc7_ = param1.prevScene;
               while(_loc7_ != null && _loc7_.getCharByID(_loc5_) != null)
               {
                  _loc13_ = _loc7_.getCharByID(_loc5_).prop != null && _loc9_ != null && _loc7_.getCharByID(_loc5_).prop.file == _loc9_.file;
                  _loc14_ = _loc7_.getCharByID(_loc5_).head != null && _loc10_ != null && _loc7_.getCharByID(_loc5_).head.file == _loc10_.file;
                  _loc15_ = _loc7_.getCharByID(_loc5_).wear != null && _loc11_ != null && _loc7_.getCharByID(_loc5_).wear.file == _loc11_.file;
                  if(_loc13_ || _loc14_ || _loc15_)
                  {
                     if(_loc13_)
                     {
                        _loc9_ = _loc7_.getCharByID(_loc5_).prop;
                     }
                     if(_loc14_)
                     {
                        _loc10_ = _loc7_.getCharByID(_loc5_).head;
                     }
                     if(_loc15_)
                     {
                        _loc11_ = _loc7_.getCharByID(_loc5_).wear;
                     }
                     _loc7_ = _loc7_.prevScene;
                     continue;
                  }
                  break;
               }
               if(_loc9_ != null)
               {
                  _loc9_.stopMusic();
               }
               if(_loc10_ != null)
               {
                  _loc10_.stopMusic();
               }
               if(_loc11_ != null)
               {
                  _loc11_.stopMusic();
               }
            }
            _loc3_++;
         }
         var _loc12_:int = 0;
         while(_loc12_ < param1.getNumChar())
         {
            _loc6_ = param1.getCharByIndex(_loc12_);
            _loc16_ = _loc6_.state;
            if(_loc16_ == 1)
            {
               _loc17_ = _loc6_.action;
            }
            else if(_loc16_ == 2)
            {
               _loc17_ = _loc6_.motion;
            }
            else if(param2 > param1.startFrame + param1.getCharByIndex(_loc12_).action.getLocalEndFrame() - param1.getCharByIndex(_loc12_).action.getLocalStartFrame() + 1 && param1.getCharByIndex(_loc12_).motion != null)
            {
               _loc17_ = (_loc6_ as Character).motion;
               if(_loc16_.toString() == "1")
               {
               }
            }
            else
            {
               _loc17_ = (_loc6_ as Character).action;
               if(_loc16_.toString() == "2" || _loc16_.toString() == "3")
               {
               }
            }
            while(_loc17_.isFirstBehavior != true)
            {
               if(_loc17_.prevBehavior == null)
               {
                  break;
               }
               _loc17_ = _loc17_.prevBehavior;
            }
            _loc17_.myChar.stopMusic();
            _loc12_++;
         }
      }
      
      public function getSceneToPlay(param1:Number, param2:AnimeScene) : void
      {
         var _loc6_:String = null;
         var _loc7_:Character = null;
         var _loc8_:AnimeScene = null;
         var _loc9_:AnimeScene = null;
         var _loc16_:String = null;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:String = null;
         var _loc21_:int = 0;
         var _loc22_:Behaviour = null;
         this.clearAllData();
         this.saveSoundArr = new Array();
         this._numOfPendingJobs = 0;
         this.savedScene = new Array();
         this._numOfAssets = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Asset = null;
         this._numOfAssets = param2.getNumBg() + param2.getNumProp() + param2.getNumChar() + param2.getNumEffect();
         _loc3_ = 0;
         while(_loc3_ < param2.getNumEffect())
         {
            _loc5_ = param2.getEffectByIndex(_loc3_);
            _loc6_ = _loc5_.id;
            _loc8_ = param2.prevScene;
            while(_loc8_ != null && _loc8_.getEffectById(_loc6_) != null)
            {
               _loc5_ = _loc8_.getEffectById(_loc6_);
               _loc8_ = _loc8_.prevScene;
            }
            _loc9_ = _loc5_.parentScene;
            this.savedScene.push(_loc9_);
            if(_loc9_.getBufferProgress() < 100)
            {
               this._numOfPendingJobs++;
               _loc9_.extraData = {
                  "targetAsset":_loc5_,
                  "curFrame":param1
               };
               _loc9_.addEventListener("init_remote_data_complete",this.BufferCompleteHandler);
               this._anime.initRemoteDataByScene(_loc9_);
            }
            else
            {
               this.saveSoundEvent(_loc5_,param1);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param2.getNumBg())
         {
            _loc5_ = param2.getBgByIndex(_loc3_);
            _loc6_ = _loc5_.id;
            _loc8_ = param2.prevScene;
            while(_loc8_ != null && _loc8_.getBgByID(_loc6_) != null)
            {
               _loc5_ = _loc8_.getBgByID(_loc6_);
               _loc8_ = _loc8_.prevScene;
            }
            _loc9_ = _loc5_.parentScene;
            this.savedScene.push(_loc9_);
            if(_loc9_.getBufferProgress() < 100)
            {
               this._numOfPendingJobs++;
               _loc9_.extraData = {
                  "targetAsset":_loc5_,
                  "curFrame":param1
               };
               _loc9_.addEventListener("init_remote_data_complete",this.BufferCompleteHandler);
               this._anime.initRemoteDataByScene(_loc9_);
            }
            else
            {
               this.saveSoundEvent(_loc5_,param1);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param2.getNumProp())
         {
            _loc5_ = param2.getPropByIndex(_loc3_);
            _loc6_ = _loc5_.id;
            _loc8_ = param2.prevScene;
            while(_loc8_ != null && _loc8_.getPropById(_loc6_) != null)
            {
               _loc5_ = _loc8_.getPropById(_loc6_);
               _loc8_ = _loc8_.prevScene;
            }
            _loc9_ = _loc5_.parentScene;
            this.savedScene.push(_loc9_);
            if(param2.getBufferProgress() < 100)
            {
               this._numOfPendingJobs++;
               _loc9_.extraData = {
                  "targetAsset":_loc5_,
                  "curFrame":param1
               };
               _loc9_.addEventListener("init_remote_data_complete",this.BufferCompleteHandler);
               this._anime.initRemoteDataByScene(_loc9_);
            }
            else
            {
               this.saveSoundEvent(_loc5_,param1);
            }
            _loc3_++;
         }
         var _loc10_:AnimeScene = param2;
         var _loc11_:AnimeScene = param2;
         var _loc12_:AnimeScene = param2;
         var _loc13_:Prop = null;
         var _loc14_:Prop = null;
         var _loc15_:Prop = null;
         _loc3_ = 0;
         while(_loc3_ < param2.getNumChar())
         {
            _loc5_ = param2.getCharByIndex(_loc3_);
            _loc9_ = _loc5_.parentScene;
            _loc7_ = _loc5_ as Character;
            _loc16_ = _loc5_.id;
            if(_loc7_.prop != null || _loc7_.head != null || _loc7_.wear != null)
            {
               if(_loc7_.prop != null)
               {
                  this._numOfAssets++;
                  _loc13_ = _loc7_.prop;
               }
               if(_loc7_.head != null)
               {
                  this._numOfAssets++;
                  _loc14_ = _loc7_.head;
               }
               if(_loc7_.wear != null)
               {
                  this._numOfAssets++;
                  _loc15_ = _loc7_.wear;
               }
               _loc8_ = param2.prevScene;
               while(_loc8_ != null && _loc8_.getCharByID(_loc16_) != null)
               {
                  _loc17_ = _loc8_.getCharByID(_loc16_).prop != null && _loc13_ != null && _loc8_.getCharByID(_loc16_).prop.file == _loc13_.file;
                  _loc18_ = _loc8_.getCharByID(_loc16_).head != null && _loc14_ != null && _loc8_.getCharByID(_loc16_).head.file == _loc14_.file;
                  _loc19_ = _loc8_.getCharByID(_loc16_).wear != null && _loc15_ != null && _loc8_.getCharByID(_loc16_).wear.file == _loc15_.file;
                  if(_loc17_ || _loc18_ || _loc19_)
                  {
                     if(_loc17_)
                     {
                        _loc10_ = _loc8_;
                        _loc13_ = _loc8_.getCharByID(_loc16_).prop;
                     }
                     if(_loc18_)
                     {
                        _loc11_ = _loc8_;
                        _loc14_ = _loc8_.getCharByID(_loc16_).head;
                     }
                     if(_loc19_)
                     {
                        _loc12_ = _loc8_;
                        _loc15_ = _loc8_.getCharByID(_loc16_).wear;
                     }
                     _loc8_ = _loc8_.prevScene;
                     continue;
                  }
                  break;
               }
               if(_loc13_ != null)
               {
                  this.savedScene.push(_loc10_);
                  if(_loc10_.getBufferProgress() < 100)
                  {
                     this._numOfPendingJobs++;
                     _loc10_.extraData = {
                        "targetAsset":_loc13_,
                        "curFrame":param1
                     };
                     _loc10_.addEventListener("init_remote_data_complete",this.BufferCompleteHandler);
                     this._anime.initRemoteDataByScene(_loc10_);
                  }
                  else
                  {
                     this.saveSoundEvent(_loc13_,param1,"",_loc10_);
                  }
               }
               if(_loc14_ != null)
               {
                  this.savedScene.push(_loc11_);
                  if(_loc11_.getBufferProgress() < 100)
                  {
                     this._numOfPendingJobs++;
                     _loc11_.extraData = {
                        "targetAsset":_loc14_,
                        "curFrame":param1
                     };
                     _loc11_.addEventListener("init_remote_data_complete",this.BufferCompleteHandler);
                     this._anime.initRemoteDataByScene(_loc11_);
                  }
                  else
                  {
                     this.saveSoundEvent(_loc14_,param1,"",_loc11_);
                  }
               }
               if(_loc15_ != null)
               {
                  this.savedScene.push(_loc12_);
                  if(_loc12_.getBufferProgress() < 100)
                  {
                     this._numOfPendingJobs++;
                     _loc12_.extraData = {
                        "targetAsset":_loc15_,
                        "curFrame":param1
                     };
                     _loc12_.addEventListener("init_remote_data_complete",this.BufferCompleteHandler);
                     this._anime.initRemoteDataByScene(_loc12_);
                  }
                  else
                  {
                     this.saveSoundEvent(_loc15_,param1,"",_loc12_);
                  }
               }
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param2.getNumChar())
         {
            _loc20_ = "action";
            _loc5_ = param2.getCharByIndex(_loc3_);
            _loc21_ = param2.getCharByIndex(_loc3_).state;
            if(_loc21_ == 1)
            {
               _loc22_ = (_loc5_ as Character).action;
            }
            else if(_loc21_ == 2)
            {
               _loc22_ = (_loc5_ as Character).motion;
            }
            else if(param1 > param2.startFrame + param2.getCharByIndex(_loc3_).action.getLocalEndFrame() - param2.getCharByIndex(_loc3_).action.getLocalStartFrame() + 1 && param2.getCharByIndex(_loc3_).motion != null)
            {
               _loc22_ = (_loc5_ as Character).motion;
               if(_loc21_.toString() == "1")
               {
               }
            }
            else
            {
               _loc22_ = (_loc5_ as Character).action;
               if(_loc21_.toString() == "2" || _loc21_.toString() == "3")
               {
               }
            }
            while(_loc22_.isFirstBehavior != true)
            {
               if(_loc22_.prevBehavior == null)
               {
                  break;
               }
               _loc22_ = _loc22_.prevBehavior;
            }
            _loc5_ = _loc22_.myChar;
            _loc9_ = _loc5_.parentScene;
            if(_loc22_ is Motion)
            {
               _loc20_ = "motion";
            }
            this.savedScene.push(param2);
            if(_loc9_.getBufferProgress() < 100)
            {
               this._numOfPendingJobs++;
               _loc9_.extraData = {
                  "targetAsset":_loc5_,
                  "curFrame":param1,
                  "startFlag":_loc20_
               };
               _loc9_.addEventListener("init_remote_data_complete",this.BufferCompleteHandler);
               this._anime.initRemoteDataByScene(_loc9_);
            }
            else
            {
               this.saveSoundEvent(_loc5_,param1,_loc20_);
            }
            _loc3_++;
         }
         if(this._numOfPendingJobs == 0)
         {
            this.dispatchEvent(new Event("AssetSoundRdy"));
            this.playSound();
         }
      }
   }
}
