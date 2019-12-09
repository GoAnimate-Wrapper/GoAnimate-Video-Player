package anifire.player.playback
{
   import anifire.interfaces.IRegulatedProcess;
   import anifire.util.UtilEffect;
   import anifire.util.UtilPlain;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class GoTransition extends Asset implements IRegulatedProcess
   {
      
      public static const STATE_ACTION:int = 1;
      
      public static const STATE_NULL:int = 0;
      
      public static const XML_TAG:String = "trans";
       
      
      private var _currSceneCapture:Bitmap;
      
      private var _prevSceneCapture:Bitmap;
      
      private var _currSceneContainer:DisplayObjectContainer;
      
      private var _prevSceneContainer:DisplayObjectContainer;
      
      private var _currSMC:DisplayObjectContainer;
      
      private var _prevScene:AnimeScene;
      
      private var _transMovieBody:Sprite;
      
      private var _dur:Number;
      
      private var _mid:Number;
      
      private var _initPos:Point;
      
      protected var _supportSeeking:Boolean;
      
      private var _easeFx:Function;
      
      public function GoTransition()
      {
         super();
      }
      
      public function get easeFx() : Function
      {
         return this._easeFx;
      }
      
      public function set easeFx(param1:Function) : void
      {
         this._easeFx = param1;
      }
      
      public function get transMovieBody() : Sprite
      {
         return this._transMovieBody;
      }
      
      public function set transMovieBody(param1:Sprite) : void
      {
         this._transMovieBody = param1;
      }
      
      public function get currSMC() : DisplayObjectContainer
      {
         return this._currSMC;
      }
      
      public function set currSMC(param1:DisplayObjectContainer) : void
      {
         this._currSMC = param1;
      }
      
      public function get initPos() : Point
      {
         return this._initPos;
      }
      
      public function set initPos(param1:Point) : void
      {
         this._initPos = param1;
      }
      
      public function get prevSceneCapture() : Bitmap
      {
         return this._prevSceneCapture;
      }
      
      public function set prevSceneCapture(param1:Bitmap) : void
      {
         this._prevSceneCapture = param1;
      }
      
      public function get dur() : Number
      {
         return this._dur;
      }
      
      public function get currSceneContainer() : DisplayObjectContainer
      {
         return this._currSceneContainer;
      }
      
      public function set currSceneContainer(param1:DisplayObjectContainer) : void
      {
         this._currSceneContainer = param1;
      }
      
      public function get prevSceneContainer() : DisplayObjectContainer
      {
         return this._prevSceneContainer;
      }
      
      public function set prevSceneContainer(param1:DisplayObjectContainer) : void
      {
         this._prevSceneContainer = param1;
      }
      
      public function get prevScene() : AnimeScene
      {
         return this._prevScene;
      }
      
      public function set prevScene(param1:AnimeScene) : void
      {
         this._prevScene = param1;
      }
      
      public function init(param1:XML, param2:AnimeScene, param3:Sprite) : Boolean
      {
         this._dur = Number(param1.fx.@dur);
         this._mid = Number(param1.fx.@mid);
         this._initPos = new Point();
         this._initPos.x = Number(param1.fx.@initx);
         this._initPos.y = Number(param1.fx.@inity);
         this._easeFx = UtilEffect.getEffectByName(param1.fx.@ease);
         this.transMovieBody = param3;
         super.initAsset(param1.@id,param1.@index,param2);
         _bundle = new Sprite();
         _bundle.mouseEnabled = _bundle.mouseChildren = false;
         return true;
      }
      
      public function startProcess(param1:Boolean = false, param2:Number = 0) : void
      {
      }
      
      public function initDependency(param1:AnimeScene, param2:AnimeScene) : void
      {
         this._currSceneCapture = new Bitmap();
         this._prevSceneCapture = new Bitmap();
         this.currSMC = param2.getSceneMasterContainer();
         this.currSceneContainer = param2.getSceneContainer();
         if(param1)
         {
            this.prevSceneContainer = param1.getSceneContainer();
         }
      }
      
      override public function propagateSceneState(param1:int) : void
      {
         if(param1 == AnimeScene.STATE_ACTION)
         {
            UtilPlain.removeAllSon(_bundle);
            this.setState(GoTransition.STATE_ACTION);
         }
         else if(param1 == AnimeScene.STATE_NULL)
         {
            this.setState(GoTransition.STATE_NULL);
         }
      }
      
      public function play(param1:Number, param2:Number, param3:Number) : void
      {
      }
      
      public function get supportSeeking() : Boolean
      {
         return this._supportSeeking;
      }
   }
}
