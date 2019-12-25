package
{
	import anifire.player.components.SceneBufferProgressBar;
	import mx.binding.IWatcherSetupUtil2;
	import mx.binding.PropertyWatcher;
	import mx.core.IFlexModuleFactory;
	
	public class _anifire_player_components_SceneBufferProgressBarWatcherSetupUtil implements IWatcherSetupUtil2
	{
		 
		
		public function _anifire_player_components_SceneBufferProgressBarWatcherSetupUtil()
		{
			super();
		}
		
		public static function init(param1:IFlexModuleFactory) : void
		{
			SceneBufferProgressBar.watcherSetupUtil = new _anifire_player_components_SceneBufferProgressBarWatcherSetupUtil();
		}
		
		public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
		{
			param5[0] = new PropertyWatcher("mainMask",{"propertyChange":true},[param4[0]],param2);
			param5[0].updateParent(param1);
		}
	}
}
