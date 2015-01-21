package
{

	
	import Screen.InGame;
	import Screen.Menu;
	import Screen.TutGame;
	
	import events.NavigationEvent;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class Game extends Sprite
	{
		private var menuScreen:Menu;
		private var inGameScreen:InGame;
		private var tutGameScreen:TutGame;
		private var bg:Image;
		
		
		
		public function Game()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{		
			/*TapjoyAIR.requestTapjoyConnect("8a896858-eba9-47de-88b7-e8976ad443d0","UaoGq46gBYu81YLG4mQM");
			var extension:TapjoyAIR = TapjoyAIR.getTapjoyConnectInstance();*/
			
			bg = new Image(Assets.getTexture("bg"));
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			
			this.addChild(bg);
			
			menuScreen = new Menu();
			menuScreen.initialize();
			this.addChild(menuScreen);
			
			tutGameScreen = new TutGame();
			tutGameScreen.disposeTemporarily();
			this.addChild(tutGameScreen);
			
			
			inGameScreen = new InGame();
			inGameScreen.disposeTemporarily();
			this.addChild(inGameScreen);
			
		
			
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, handleChangeScreen);
			
			
		}
		
		private function handleChangeScreen(e:NavigationEvent):void
		{
			trace("TENHO K FAZER KK MERDA" , e.params.id);
			
			switch(e.params.id)
			{
				case "tut":
					menuScreen.disposeTemporarily();
					tutGameScreen.initialize();
					break;
				case "play":
					tutGameScreen.disposeTemporarily();
					inGameScreen.init();
					break;
			}
			
			
		}
	}
}