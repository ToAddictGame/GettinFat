package Screen
{
	import com.greensock.TweenLite;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Utils3D;
	import flash.utils.Timer;
	
	import events.NavigationEvent;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import objects.Bubble;
	import objects.Food;
	import objects.MainCharacter;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	
	public class TutGame extends Sprite
	{
		public static const WAIT_FOR_PRESS:String = "Waiting for press";
		public static const WAIT_FOR_EAT:String = "Eat";
		public static const WAIT_FOR_COLLISION:String = "Collide";		
		public static const TUT_ENDED:String = "Ended";	
		private var currentGameState:String;
		
		private var character:MainCharacter;
		private var bubble:Bubble;
		
		private var food:Food;
		private var bg:Image;
		
		private var gameArea:Quad;
		
		private var stringArray:Array = ["Click and press to make bubble grow and to move character", "When the bubble and the bug collide, release the screen!", 
			"Press again and let the bug touch you","You'r dead, so don't do that!" ];
		private var label:Label;
		private var finalButton:Button;
		
		private var bubbleGrow:Boolean =false;
		
		//TIMERS		
		private var timeToCreateBug:Timer = new Timer(1000);
		
		public function TutGame()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void
		{
			
			bg = new Image(Assets.getTexture("bg"));
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;			
			this.addChild(bg);
			
			gameArea = new Quad(stage.stageWidth,stage.stageHeight);
			gameArea.alpha = 0;
			this.addChild(gameArea);
				
			character = new MainCharacter();			
			character.x = stage.width/2 - character.width /2;
			character.y = stage.stageHeight/2 - character.height/2;
			this.addChild(character);
			
			bubble = new Bubble();
			bubble.x = character.x;
			bubble.y = character.y;
			addChild(bubble);
			
			this.label = new Label();
			label.textRendererFactory = function():ITextRenderer
			{
				var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				textRenderer.textFormat = new BitmapFontTextFormat( Assets.getFont().name,44 );
				textRenderer.smoothing = TextureSmoothing.TRILINEAR;
				return textRenderer;
			}
			this.addChild(label);	
			
			finalButton = new Button();
			finalButton.defaultSkin = new Image(Assets.getTexture("playButton"));
			finalButton.width = 100;
			finalButton.height = 100;
			finalButton.x = stage.stageWidth/2 - finalButton.width/2;
			finalButton.y = stage.stageHeight/2 - finalButton.height/2;
			finalButton.addEventListener(Event.TRIGGERED, onBtClick );
			
			currentGameState = WAIT_FOR_PRESS;
			
			this.addEventListener(Event.ENTER_FRAME,Update);
			this.addEventListener("FINISH_EATING",finishEating);
			
			
		}
		
		private function onBtClick():void
		{
			trace("CLICKED");
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id:"play"},true));
			
		}
		
		private function finishEating():void
		{
			trace("FINISH EAT");
			init();				
			
			if(currentGameState == WAIT_FOR_EAT){
				currentGameState = WAIT_FOR_COLLISION;
				init();
			}
			else if(currentGameState == WAIT_FOR_COLLISION)
				currentGameState = TUT_ENDED;
		}
		
		private function Update(e:Event):void
		{
			
			//trace(currentGameState);
			bubble.x = character.x;
			bubble.y = character.y;
			
			switch(currentGameState)
			{
				case WAIT_FOR_PRESS:
				{
					label.text = stringArray[0];
					this.addEventListener(TouchEvent.TOUCH, touchHandler);
					
					break;
				}
				case WAIT_FOR_EAT:
				{					
					label.text = stringArray[1];
					break;
				}
				case WAIT_FOR_COLLISION:
				{
					label.text = stringArray[2];
					this.addEventListener(TouchEvent.TOUCH, touchHandler);
					if(food !=null)
						CheckForCollision(food,character);
					break;
				}
				case TUT_ENDED:
				{
					label.text = stringArray[3];
					this.removeEventListener(TouchEvent.TOUCH, touchHandler);
					if(!finalButton.stage)
					{
						trace("ADIN");
						this.addChild(finalButton);
					}
					break;
				}					
				default:
				{
					break;
				}
			}
			
			label.x = stage.width/2 - label.width /2;
			label.y = 10;
			
			if(bubbleGrow == true)
			{
				bubble.grow();
			}
			
		}
		
		private function init():void
		{
			character.x = stage.width/2 - character.width /2;
			character.y = stage.stageHeight/2 - character.height/2;
			character.rotation = 0;
			character.walk();
			TweenLite.killTweensOf(character);
			
			bubble.init();
			food = null;
			
			this.removeEventListener(TouchEvent.TOUCH, touchHandler);
			
		}
		
		private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);					
			
			
			if(touch && touch.phase == "ended")
			{
				//this.removeEventListener(TouchEvent.TOUCH, touchHandler);
				trace("ACABAOU");
				if(food != null && currentGameState == WAIT_FOR_EAT)
				{
					CheckForCollision(food,bubble);
				}
				bubbleGrow = false;
				bubble.init();
				
				
				
			}	
			else if(touch && touch.phase == TouchPhase.MOVED)
			{				
				var disX:int = touch.globalX - character.x;
				var disY:int = touch.globalY  - character.y;;
				var radiansDegrees:Number = Math.atan2(disY,disX);
				character.rotation = radiansDegrees+deg2rad(90);						
				
				TweenLite.to(character,1,{x:touch.globalX, y: touch.globalY});	
				
				bubbleGrow = true;
				
				if(food == null)
				{				
					timeToCreateBug.addEventListener(TimerEvent.TIMER,createBug);
					timeToCreateBug.start();
					
				}				
			}
		
			if(touch && touch.phase == "began" && currentGameState == WAIT_FOR_PRESS)
			{				
				currentGameState = WAIT_FOR_EAT;
			}
			
		}		
			
		private function CheckForCollision(object1:Object, object2:Object):void
		{
			//trace("BU");
			var p1:Point = new Point(object1.x, object1.y);
			var p2:Point = new Point(object2.x, object2.y);		
			
			var radius1:Number = object1.width / 2;			
			var radius2:Number = object2.width / 2;
			
			var distance:Number = Point.distance(p1, p2);				
				
			if (distance < radius1 + radius2)
			{					
				
				
				setChildIndex(object1 as Food,getChildIndex(character)+1);
				
				if(currentGameState == WAIT_FOR_EAT)
				{
					character.eat();
					character.getFat();		
					object1.moveToMouth(p2);
				}
				else if(currentGameState == WAIT_FOR_COLLISION)
				{
					currentGameState = TUT_ENDED;
					object1.visible = false;
					bubbleGrow = false;
					init();
					trace("BATEU ULTIMA VEZ");
				}
				
				
			}	
		}		
		
		
		protected function createBug(event:TimerEvent):void
		{
			timeToCreateBug.removeEventListener(TimerEvent.TIMER,createBug);
			food = new Food(1);
			food.x = stage.stageWidth/10;
			food.y = stage.stageHeight/10;
			this.addChild(food);			
			
		}	
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}	
		
		public function initialize():void
		{
			this.visible = true;
			init();
		}
		
	}
	
}