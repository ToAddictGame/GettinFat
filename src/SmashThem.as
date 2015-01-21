package
{
	import com.chartboost.plugin.air.Chartboost;
	import com.chartboost.plugin.air.ChartboostEvent;
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import Screen.InGame;
	import Screen.Menu;
	import Screen.TutGame;
	
	import feathers.layout.ViewPortBounds;
	
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	
	[SWF(frameRate="60",width="100%",height="100%",backgroundColor = "0x333333")]
	public class SmashThem extends Sprite
	{
		private var _starling:Starling;
		private var chartboost:Chartboost;
		public function SmashThem()
		{
			super();		
			
			Starling.handleLostContext = true;
		
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.displayState = StageDisplayState.FULL_SCREEN;
			
			
			//ON DEVICE
			var screenWidth:int = Capabilities.screenResolutionX;
			var screenHeight:int = Capabilities.screenResolutionY;
			var viewPort:Rectangle = new Rectangle(0,0,screenWidth,screenHeight);
			
			
			//ON AIR DEBUG
			/*var screenWidth:int = stage.fullScreenWidth;
			var screenHeight:int = stage.fullScreenHeight;
			var viewPort:Rectangle = new Rectangle(0,0,screenWidth,screenHeight);
			*/
			
			_starling = new Starling(Game,stage,viewPort);
			_starling.antiAliasing = 1;
			
			
			
			
			_starling.start();
			Starling.current.showStats = true;
			
			//trace("TAMANHO: " + stage.stageWidth + " x " + stage.stageHeight);
			//trace("TEST: " + Capabilities.screenResolutionY);
			trace("FULLSCREEN : " + stage.fullScreenWidth + " x " + stage.fullScreenHeight);
			trace("VIEWPORT : " +_starling.viewPort);
			
			trace("SCALE FACTOR: " + _starling.contentScaleFactor);
			
			
			
			
		
			
			
			/*chartboost = Chartboost.getInstance();
			
			if (Chartboost.isAndroid()) {
				chartboost.init("54a17f080d602547d6a4fc95", "7456e19b027b74eb33a3ec06c335055942afb72c");
				chartboost.cacheInterstitial();
				chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_CACHED, onChartboosCached);
				trace("SUCCESS");
			} else if (Chartboost.isIOS()) {
				chartboost.init("IOS_APP_ID", "IOS_APP_SIGNATURE");
			}*/
						
		}
		
	
		
		protected function onChartboosCached(event:ChartboostEvent):void
		{
			trace(" bu",event.location);
			chartboost.showInterstitial();
		}
	}
}