package events
{
	import starling.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		public static const RESTART_GAME:String = "restartGame";
		
		public var params:Object;
		
		public function NavigationEvent(type:String, _params:Object = null, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
			params = _params;
		}
	}
}