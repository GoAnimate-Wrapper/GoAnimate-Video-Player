package anifire.player.components
{
   import anifire.player.events.PlayerEvent;
   import anifire.player.events.SceneBufferEvent;
   import anifire.player.managers.SceneBufferManager;
   import anifire.player.playback.AnimeScene;
   import anifire.player.playback.PlainPlayer;
   import flash.events.IEventDispatcher;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.graphics.SolidColor;
   import spark.components.Group;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class SceneBufferProgressBar extends Group implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _SceneBufferProgressBar_Group3:Group;
      
      private var _1144153660_sceneLayer:Group;
      
      private var _8651707mainMask:Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _plainPlayer:PlainPlayer;
      
      private var _scenes:Vector.<Rect>;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SceneBufferProgressBar()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._scenes = new Vector.<Rect>();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._SceneBufferProgressBar_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_anifire_player_components_SceneBufferProgressBarWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SceneBufferProgressBar[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.height = 5;
         this.clipAndEnableScrolling = true;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.mxmlContent = [this._SceneBufferProgressBar_Group2_i(),this._SceneBufferProgressBar_Group3_i()];
         this.addEventListener("creationComplete",this.___SceneBufferProgressBar_Group1_creationComplete);
         this.addEventListener("resize",this.___SceneBufferProgressBar_Group1_resize);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SceneBufferProgressBar._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      protected function onCreationComplete() : void
      {
      }
      
      public function set plainPlayer(param1:PlainPlayer) : void
      {
         if(param1 != this._plainPlayer)
         {
            if(this._plainPlayer)
            {
               this._plainPlayer.removeEventListener(PlayerEvent.MOVIE_STRUCTURE_READY,this.onMovieStructureReady);
            }
            this._plainPlayer = param1;
            if(this._plainPlayer)
            {
               this._plainPlayer.addEventListener(PlayerEvent.MOVIE_STRUCTURE_READY,this.onMovieStructureReady);
            }
         }
      }
      
      private function onMovieStructureReady(param1:PlayerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Vector.<AnimeScene> = null;
         var _loc4_:int = 0;
         var _loc5_:AnimeScene = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Rect = null;
         var _loc9_:SolidColor = null;
         var _loc10_:int = 0;
         IEventDispatcher(param1.target).removeEventListener(param1.type,this.onMovieStructureReady);
         if(this._plainPlayer)
         {
            _loc2_ = 550 / this._plainPlayer.duration#1;
            _loc3_ = this._plainPlayer.getAnimeScenes();
            _loc4_ = _loc3_.length;
            _loc10_ = 0;
            while(_loc10_ < _loc4_)
            {
               _loc5_ = _loc3_[_loc10_];
               _loc6_ = (_loc5_.startFrame - 1) * _loc2_;
               _loc7_ = _loc5_.duration#1 * _loc2_;
               _loc8_ = new Rect();
               _loc8_.x = _loc6_;
               _loc8_.width = _loc7_;
               _loc8_.height = 5;
               _loc9_ = new SolidColor(2236962,0);
               _loc8_.fill = _loc9_;
               this._sceneLayer.addElement(_loc8_);
               this._scenes.push(_loc8_);
               _loc10_++;
            }
            SceneBufferManager.instance.addEventListener(SceneBufferEvent.SCENE_BUFFERED,this.onSceneBuffered);
         }
      }
      
      private function onSceneBuffered(param1:SceneBufferEvent) : void
      {
         var _loc2_:SolidColor = this._scenes[param1.sceneIndex].fill as SolidColor;
         if(_loc2_)
         {
            _loc2_.alpha = 1;
         }
      }
      
      protected function onResize(param1:ResizeEvent) : void
      {
         this._sceneLayer.scaleX = this.width / 550;
      }
      
      private function _SceneBufferProgressBar_Group2_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.mxmlContent = [this._SceneBufferProgressBar_Rect1_c()];
         _loc1_.id = "mainMask";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.mainMask = _loc1_;
         BindingManager.executeBindings(this,"mainMask",this.mainMask);
         return _loc1_;
      }
      
      private function _SceneBufferProgressBar_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.radiusX = 2;
         _loc1_.radiusY = 2;
         _loc1_.fill = this._SceneBufferProgressBar_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _SceneBufferProgressBar_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         return _loc1_;
      }
      
      private function _SceneBufferProgressBar_Group3_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.mxmlContent = [this._SceneBufferProgressBar_Rect2_c(),this._SceneBufferProgressBar_Group4_i()];
         _loc1_.id = "_SceneBufferProgressBar_Group3";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._SceneBufferProgressBar_Group3 = _loc1_;
         BindingManager.executeBindings(this,"_SceneBufferProgressBar_Group3",this._SceneBufferProgressBar_Group3);
         return _loc1_;
      }
      
      private function _SceneBufferProgressBar_Rect2_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._SceneBufferProgressBar_SolidColor2_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _SceneBufferProgressBar_SolidColor2_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         return _loc1_;
      }
      
      private function _SceneBufferProgressBar_Group4_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.id = "_sceneLayer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._sceneLayer = _loc1_;
         BindingManager.executeBindings(this,"_sceneLayer",this._sceneLayer);
         return _loc1_;
      }
      
      public function ___SceneBufferProgressBar_Group1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function ___SceneBufferProgressBar_Group1_resize(param1:ResizeEvent) : void
      {
         this.onResize(param1);
      }
      
      private function _SceneBufferProgressBar_bindingsSetup() : Array
      {
         var _loc1_:Array = [];
         _loc1_[0] = new Binding(this,null,null,"_SceneBufferProgressBar_Group3.mask","mainMask");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get _sceneLayer() : Group
      {
         return this._1144153660_sceneLayer;
      }
      
      public function set _sceneLayer(param1:Group) : void
      {
         var _loc2_:Object = this._1144153660_sceneLayer;
         if(_loc2_ !== param1)
         {
            this._1144153660_sceneLayer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_sceneLayer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainMask() : Group
      {
         return this._8651707mainMask;
      }
      
      public function set mainMask(param1:Group) : void
      {
         var _loc2_:Object = this._8651707mainMask;
         if(_loc2_ !== param1)
         {
            this._8651707mainMask = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainMask",_loc2_,param1));
            }
         }
      }
   }
}
