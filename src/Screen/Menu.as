package Screen
{
	import objects.MenuUI;		
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class Menu extends Sprite
	{
		private var menuUI:MenuUI;
		private var texto:TextField;
		
		private var playButton:Button;
		

		
		public function Menu()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			menuUI = new MenuUI();
			this.addChild(menuUI);
			
		}		
		
		
		public function initialize():void
		{
			this.visible = true;
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
	}
}