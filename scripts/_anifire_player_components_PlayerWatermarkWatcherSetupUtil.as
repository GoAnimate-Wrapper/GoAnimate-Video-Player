package
{
   import anifire.player.components.PlayerWatermark;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _anifire_player_components_PlayerWatermarkWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _anifire_player_components_PlayerWatermarkWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PlayerWatermark.watcherSetupUtil = new _anifire_player_components_PlayerWatermarkWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("_clickable",{"propertyChange":true},[param4[0],param4[1]],param2);
         param5[0].updateParent(param1);
      }
   }
}
