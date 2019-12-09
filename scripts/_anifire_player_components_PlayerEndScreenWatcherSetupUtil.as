package
{
   import anifire.player.components.PlayerEndScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   
   public class _anifire_player_components_PlayerEndScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _anifire_player_components_PlayerEndScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PlayerEndScreen.watcherSetupUtil = new _anifire_player_components_PlayerEndScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}
