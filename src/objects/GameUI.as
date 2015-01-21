package objects
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import events.NavigationEvent;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Panel;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	
	public class GameUI extends Sprite
	{
		//IMAGES
		private var panelBackground:Image;
		
			
		//COMPONENTS
		private var scoreLabel:Label;
		private var finalLabel:Label;
		private var panel:Panel;
		private var panelScoreList:List;
		private var btReplay:Button;
		
		
		public function GameUI()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			createLabels();
			createFinalScoreBoard();
				
			init();			
		}
		
		private function createFinalScoreBoard():void
		{
			panelBackground = new Image(Assets.getTexture("highScoreBoard"));
			panel = new Panel();
			
			panel.width = panelBackground.width;
			panel.height = panelBackground.height;
			panel.x = stage.stageWidth/2 - panel.width/2;
			panel.y = stage.stageHeight/2 - panel.height/2;
			panel.backgroundSkin = panelBackground;
			panel.backgroundDisabledSkin = panelBackground;
			
			
		
			
		
			
			panel.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.title = "Highscore";
				header.titleFactory = function():ITextRenderer
				{
					var titleRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
					
					//styles here
					titleRenderer.textFormat = new BitmapFontTextFormat(  Assets.getFont().name,64,0xFFFFFF,"center" );
					
					return titleRenderer;
				}
				
				return header;
			}
			
			this.addChild( panel );	
				
			panelScoreList = new List();			
			panelScoreList.width = 550;
			panelScoreList.height = 700;
			panelScoreList.x = panel.width/2 - panelScoreList.width/2;
			panelScoreList.y = 100;			
			panelScoreList.itemRendererProperties.labelField = "score";
			panelScoreList.itemRendererProperties.iconSourceField = "thumbnail";
			panelScoreList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				renderer.labelFactory = function():ITextRenderer
				{
					var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
					textRenderer.textFormat = new BitmapFontTextFormat( Assets.getFont().name,44,0xFFFFFF,"center"  );
					textRenderer.smoothing = TextureSmoothing.TRILINEAR;
					return textRenderer;
				}				
				return renderer;
			};
			
			btReplay = new Button();
			btReplay.defaultSkin = new Image(Assets.getTexture("playButton"));
			btReplay.width = 100;
			btReplay.height = 100;
			btReplay.x = panel.width/2 - btReplay.width/2;
			btReplay.y = panel.height - btReplay.height*2;
			btReplay.addEventListener(Event.TRIGGERED, onBtClick );
				
			
			panel.addChild( panelScoreList );
			panel.addChild(btReplay);
			
		}
		
		private function onBtClick(e:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.RESTART_GAME, {id:"restart"},true));
		}
		
		private function createLabels():void
		{
			//SCORE
			this.scoreLabel = new Label();					
			this.scoreLabel.x = 100;
			this.addChild(scoreLabel);
					
			
			scoreLabel.textRendererFactory = function():ITextRenderer
			{
				var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				textRenderer.textFormat = new BitmapFontTextFormat( Assets.getFont().name,44 );
				textRenderer.smoothing = TextureSmoothing.TRILINEAR;
				return textRenderer;
			}
			
				
			//FINAL RESTART LABEL
			this.finalLabel = new Label();
			this.finalLabel.text = "You lost \n tap to try again";
			this.finalLabel.validate();
			this.finalLabel.x = stage.stageWidth/2 - this.finalLabel.width/2;
			this.finalLabel.y = stage.stageHeight/2 - this.finalLabel.height/2;
			
			finalLabel.textRendererFactory = function():ITextRenderer
			{
				var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				textRenderer.textFormat = new BitmapFontTextFormat( Assets.getFont().name,64,0xFFFFFF,"center" );
				textRenderer.smoothing = TextureSmoothing.TRILINEAR;
				return textRenderer;
			}
				
		}
		
		public function init():void
		{		
			this.scoreLabel.text = "Score 0";
			this.finalLabel.visible = false;		
			this.panel.visible = false;				
		}
		
		public function passDataToHighscore(_data:Array):void
		{
			var localHighscore:ListCollection = new ListCollection();
			for (var i:int = 0; i < _data.length; i++) 
			{				
				localHighscore.push({score: _data[i].score, thumbnail:Assets.getTexture(_data[i].playerId)});
			}
			
			MonsterDebugger.trace(this,_data);
			panelScoreList.dataProvider = localHighscore;
		}
		
		public function updateScore(score:int):void
		{
			this.scoreLabel.text = "Score " +score.toString();
		}
		
		public function showFinalMessage():void
		{				
			finalLabel.visible = true;			
		}
		public function showFinalScoreBoard():void
		{
			panel.visible = true;
		}
		
	}
}