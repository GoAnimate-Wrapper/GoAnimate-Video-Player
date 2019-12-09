package anifire.player.assetTransitions.sound
{
   import flash.media.Sound;
   
   public class TransitionSound
   {
      
      public static var soundIndex:int = 0;
       
      
      public var mySoundClass02:Class;
      
      private var _sound:Sound;
      
      public function TransitionSound()
      {
         this.mySoundClass02 = TransitionSound_mySoundClass02;
         super();
         this._sound = new this.mySoundClass02() as Sound;
      }
      
      public function play() : void
      {
         this._sound.play();
      }
   }
}
