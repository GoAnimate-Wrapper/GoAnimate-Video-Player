package
{
   import anifire.player.components.PlayerProgressBar;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _anifire_player_components_PlayerProgressBarWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _anifire_player_components_PlayerProgressBarWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PlayerProgressBar.watcherSetupUtil = new _anifire_player_components_PlayerProgressBarWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("_progressPercent",{"propertyChange":true},[param4[0]],param2);
         param5[0].updateParent(param1);
      }
   }
}
