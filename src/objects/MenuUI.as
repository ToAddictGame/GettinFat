package objects
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import events.NavigationEvent;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	
	public class MenuUI extends Sprite
	{
		private var avatarList:List;
		private var btPlay:Button;
		private var gameTitle:Label;
		
		//MARGINS PADDINGS BORDERS
		private var margin:int = 20;
		
		public function MenuUI()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			createGameTitle();
			createBts();
			createAvatarList();
			
			
			
			
		}
		
		private function createGameTitle():void
		{
			gameTitle = new Label();
			gameTitle.text = "GettinFat";
			
			gameTitle.textRendererFactory = function():ITextRenderer
			{
				var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				textRenderer.textFormat = new BitmapFontTextFormat( Assets.getFont().name,74 );
				textRenderer.smoothing = TextureSmoothing.TRILINEAR;
				return textRenderer;
			}
			gameTitle.validate();
			gameTitle.x = stage.stageWidth/2 - gameTitle.width/2;
			gameTitle.y = stage.stageHeight/4;
			this.addChild(gameTitle);
		}
		
		private function createBts():void
		{
			btPlay = new Button();
			btPlay.defaultSkin = new Image(Assets.getTexture("playButton"));
			btPlay.width = 100;
			btPlay.height = 100;
			btPlay.x = stage.stageWidth/2 - (btPlay.width/2);
			btPlay.y = gameTitle.y + gameTitle.height + margin;
			this.addChild(btPlay);
			
			btPlay.addEventListener( Event.TRIGGERED, onBtClick );
				
		
			/*
			
			this.addChild(playButton);
			texto = new TextField(500,100,"Skinny Eater",Assets.getFont().name,74,0xFFFFFF);
			texto.x = stage.stageWidth/2 - texto.width/2;
			texto.y = 100;
			this.addChild(texto);
			
			menuUI = new MenuUI();
			this.addChild(menuUI);*/
			
			//Tween(this,2,*/
		}
		
		private function onBtClick(e:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id:"tut"},true));
		}
		
		private function createAvatarList():void
		{
			var avatarCollection:ListCollection = new ListCollection([
				{image:Assets.getTexture("bug1"),name:"Item1"},
				{image:Assets.getTexture("bug1"),name:"Item2"},
				{image:Assets.getTexture("bug1"),name:"Item3"},
				{image:Assets.getTexture("bug2"),name:"Item4"},
				{image:Assets.getTexture("bug1"),name:"Item1"},
				{image:Assets.getTexture("bug1"),name:"Item2"},
				{image:Assets.getTexture("bug1"),name:"Item3"},
				{image:Assets.getTexture("bug2"),name:"Item4"},
				{image:Assets.getTexture("bug1"),name:"Item1"},
				{image:Assets.getTexture("bug1"),name:"Item2"},
				{image:Assets.getTexture("bug1"),name:"Item3"},
				{image:Assets.getTexture("bug1"),name:"Item4"},
				{image:Assets.getTexture("bug2"),name:"Item1"},
				{image:Assets.getTexture("bug1"),name:"Item2"},
				{image:Assets.getTexture("bug1"),name:"Item3"},
				{image:Assets.getTexture("bug1"),name:"Item4"},
				{image:Assets.getTexture("bug2"),name:"Item1"},
				{image:Assets.getTexture("bug1"),name:"Item2"},
				{image:Assets.getTexture("bug1"),name:"Item3"},
				{image:Assets.getTexture("bug1"),name:"Item4"},
				{image:Assets.getTexture("bug2"),name:"Item1"},
				{image:Assets.getTexture("bug1"),name:"Item2"},
				{image:Assets.getTexture("bug1"),name:"Item3"},
				{image:Assets.getTexture("bug2"),name:"Item4"}
				
			]);
			avatarList = new List();
			avatarList.dataProvider =avatarCollection;
			avatarList.itemRendererProperties.labelField = "name";
			avatarList.itemRendererProperties.iconSourceField  = "image";
			avatarList.width = stage.width - margin*10;
			avatarList.x = stage.stageWidth/2 - avatarList.width/2;
			avatarList.y = btPlay.y + btPlay.height + margin;
			
			
			this.addChild(avatarList);
			avatarList.addEventListener(Event.CHANGE,avatarPickerHandler);
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			layout.gap = 10;
			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
				layout.paddingLeft = 15;
			avatarList.layout = layout;
			avatarList.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
			avatarList.verticalScrollPolicy = List.SCROLL_POLICY_OFF;
			
			avatarList.scrollToDisplayIndex(7);
			
		}
		
		private function avatarPickerHandler(e:Event):void
		{
			var list:List = List(e.currentTarget);
			MonsterDebugger.trace(this,list.dataProvider.data[list.selectedIndex].name);
		}
	}
}