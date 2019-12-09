package anifire.event
{
   public class AVM2SoundEvent extends ExtraDataEvent
   {
      
      public static const BUFFER_EXHAUST:String = "buffer_exhaust";
      
      public static const SOUND_DATA_SUFFICIENT:String = "sound_data_sufficient";
       
      
      public function AVM2SoundEvent(param1:String, param2:Object, param3:Object = null, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param2,param3,param4,param5);
      }
   }
}
