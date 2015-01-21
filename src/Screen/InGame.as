package Screen
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.gamecook.scores.FScoreboard;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import events.NavigationEvent;
	
	import objects.Bubble;
	import objects.Food;
	import objects.GameUI;
	import objects.MainCharacter;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	
	public class InGame extends Sprite
	{	
		public static const WAIT_STATE:String = "Waiting";
		public static const PLAY_STATE:String = "PLaying";
		public static const EATING_STATE:String = "Eating";		
		public static const ENDED_STATE:String = "Ended";		
		private var currentGameState:String = WAIT_STATE;
		
		
		//OBJECTS
		private var character:MainCharacter;		
		private var bubble:Bubble;		
		private var food:Food;
		
		//BOUNDS CONTROLLERS ARRAYS		
		private var foodMaxNumber:int;
		private var foodArray:Vector.<Food>;
		private var foodEatenNr:int;
			
		//UTILITIES
		private var gameArea:Quad;
		private var gameLost:Boolean;
		
		//TIMER
		private var increaseFoodTimer:Timer;
		
		//GUI
		private var gameUI:GameUI;
		
		public static var scoreBoard:FScoreboard;
		
		public function InGame()
		{
			super();
			MonsterDebugger.initialize(this);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{			
			gameArea = new Quad(stage.stageWidth,stage.stageHeight);
			gameArea.alpha = 0;
			this.addChild(gameArea);
						
			bubble = new Bubble();			
			this.addChild(bubble);			
			
			character = new MainCharacter();			
			this.addChild(character);			
						
			increaseFoodTimer = new Timer(3000,1000);			
			
			gameUI = new GameUI();
			this.addChild(gameUI);
						
			scoreBoard = new FScoreboard("ScoreBoard",5);	
			
		}
		
		private function Update():void
		{
			//trace(character.bounds);
			switch(currentGameState)
			{
				case WAIT_STATE:
					
					
					break;
				case PLAY_STATE:					
					this.addEventListener(TouchEvent.TOUCH, touchHandle);
					this.removeEventListener(TouchEvent.TOUCH, restartGameTouch);
					if(bubble.x != character.x)
					{
						bubble.x = character.x;
						bubble.y = character.y;
					}
					
					character.walk();
					
					CreateBugs();
					checkForCollisions();
					
					break
				case EATING_STATE:					
					this.removeEventListener(TouchEvent.TOUCH, touchHandle);				
					TweenMax.killTweensOf(character);
					
					
					break;
				case ENDED_STATE:
					this.removeEventListener(TouchEvent.TOUCH, touchHandle);
					this.removeEventListener(Event.ENTER_FRAME, bubbleGrow);
					increaseFoodTimer.removeEventListener(TimerEvent.TIMER,increaseFoodNumber);
						
					
					gameUI.passDataToHighscore(scoreBoard.scores);
					gameUI.showFinalScoreBoard();
					stopAllTweens();
					
					this.addEventListener(NavigationEvent.RESTART_GAME, restartGameTouch);
					this.currentGameState = WAIT_STATE;
					break;
			}			
		}
		
		
		public function init():void
		{
			this.visible = true;
			currentGameState = PLAY_STATE;
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			this.addEventListener(Event.ENTER_FRAME, Update);		
			this.addEventListener("FINISH_EATING",finishEating);
			character.x = stage.stageWidth/2;
			character.y = stage.stageHeight/2;
			character.init();
			
			this.foodMaxNumber = 15;			
			this.foodEatenNr = 0;
			this.foodArray = new Vector.<Food>();
			
			bubble.init();			
			
			gameLost = false;			
			gameUI.init();		
			
			increaseFoodTimer.addEventListener(TimerEvent.TIMER, increaseFoodNumber);
			increaseFoodTimer.repeatCount = 100000;
			increaseFoodTimer.start();		
			
			
		}
		
		private function onKeyPress(e:KeyboardEvent):void
		{
			var character:String = String.fromCharCode(e.charCode);
		
			
			if(character == "a")
			{
				MonsterDebugger.trace(this,scoreBoard.scores);
			}
			else if(character == "d")
			{
				scoreBoard.clearScoreboard();
			}
			else if(character == "s")
			{
				scoreBoard.addScore({playerId:"bug1",score:foodEatenNr.toString()});
			}
		
		}
		
		protected function increaseFoodNumber(event:TimerEvent):void
		{
			//trace("LESTS INCREASE FOOD");
			foodMaxNumber ++;
			
		}
		
		private function finishEating(e:Event):void
		{
			currentGameState = PLAY_STATE;
				
		}
		
		
		private function restartGameTouch(e:NavigationEvent):void
		{		
			for each (var food:Food in foodArray) 
			{
				this.removeChild(food);
			}
			init();				
			
		}
		
		private function stopAllTweens():void
		{
			TweenMax.killTweensOf(character);
			TweenLite.killTweensOf(this.bubble);
			
			for each (var food:Food in foodArray) 
			{
				TweenMax.killTweensOf(food);
			}
			
		}
		
		private function CreateBugs():void
		{
			if(foodArray.length <= foodMaxNumber)
			{			
				var number:int = (Math.random() *4)+1;
				var speed:Number = Math.random() + 6;
		
				food = new Food(number,speed);
				
				//INITIAL POSITION
				var randomSide:int = Math.random()*7;				
				var newY:int = Math.random() * stage.stageHeight;
				food.y = newY;
				
				if( randomSide %2 == 0)
					food.x = 0 - food.width;
				else
				{
					food.x = stage.stageWidth + food.width;
				}	
				foodArray.push(food);	
				this.addChild(food);
				setChildIndex(food,getChildIndex(character)-1);
							
			}		
		}
		
		private function checkForFood():void
		{
			var foodToTrack:Food;		
			var p1:Point = new Point(bubble.x, bubble.y);
			var radius1:Number = bubble.width / 2;			
			var collisionOccur:Boolean = false;
			
			for(var i:int = foodArray.length-1; i>=0; i--)
			{
				foodToTrack = foodArray[i];				
				
				var p2:Point = new Point(foodToTrack.x, foodToTrack.y);				
				var distance:Number = Point.distance(p1, p2);				
				var radius2:Number = foodToTrack.width / 2;
				
				if (distance < radius1 + radius2)
				{	
					currentGameState = EATING_STATE;
					foodToTrack.beenHit = true;		
					foodToTrack.moveToMouth(p1);
					setChildIndex(foodToTrack,getChildIndex(character)+1);
					foodArray.splice(i,1);	
					collisionOccur = true;
					character.eat();
					character.getFat();
					
					this.foodEatenNr ++;
					gameUI.updateScore(this.foodEatenNr);
				}				
			}	
			
			if(collisionOccur == false)
			{
				currentGameState  = PLAY_STATE;				
			}
			bubble.init();
		}
		
		private function checkForCollisions():void
		{			
			var foodToTrack:Food;				

			var p1:Point = new Point(character.x, character.y);
			var radius1:Number = character.width / 2;	
			
			
			for(var i:int = foodArray.length-1; i>=0; i--)
			{
				foodToTrack = foodArray[i];		
				
				var p2:Point = new Point(foodToTrack.x, foodToTrack.y);				
				var distance:Number = Point.distance(p1, p2);
				
				var radius2:Number = foodToTrack.width / 2;
				
				//if(bugToTrack.bounds.contains(character.x,character.y))
				if (distance < (radius1 + radius2)-40)
				{
					saveScore();
					currentGameState = ENDED_STATE;
					foodToTrack.beenHit = true;		
				}				
			}						
		}
		
		private function saveScore():void
		{
			scoreBoard.addScore({playerId:"bug1",score:foodEatenNr.toString()});
		}
		
		private function touchHandle(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);					
			
			if(touch)
			{
				var disX:int = touch.globalX - character.x;
				var disY:int = touch.globalY  - character.y;;
				var radiansDegrees:Number = Math.atan2(disY,disX);
				character.rotation = radiansDegrees+deg2rad(90);						
				
				TweenLite.to(character,1,{x:touch.globalX, y: touch.globalY});		
				
			}
			
			
			if(touch && touch.phase == "ended")
			{
				this.removeEventListener(Event.ENTER_FRAME, bubbleGrow);				
				checkForFood();	
			
				
			}	
			else if(touch && touch.phase == "began")
			{				
				this.addEventListener(Event.ENTER_FRAME, bubbleGrow);				
			}
		}		
		
		private function bubbleGrow():void
		{			
			bubble.grow();
		}		
				
		public function disposeTemporarily():void
		{
			this.visible = false;
		}	
		
	}
}